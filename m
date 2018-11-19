From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 19 Nov 2018 21:31:06 +0800
Subject: [RFC PATCH v2 chao/erofs-dev 5/5] staging: erofs: simplify
 `z_erofs_vle_submit_all'
In-Reply-To: <20181119133106.45183-1-gaoxiang25@huawei.com>
References: <20181119133106.45183-1-gaoxiang25@huawei.com>
Message-ID: <20181119133106.45183-5-gaoxiang25@huawei.com>

Previously, there are too many hacked stuffs such as `__FSIO_1',
`lstgrp_noio', `lstgrp_io' out there in `z_erofs_vle_submit_all'.

Rework the whole process by properly introducing the jobqueue idea
to represent each type of queued workgroups, and 2 independent
jobqueues if managed cache is enabled.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 195 ++++++++++++++++++++++----------------
 1 file changed, 113 insertions(+), 82 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 55666e62ec57..66ded80f662f 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1214,33 +1214,28 @@ pickup_page_for_submission(struct z_erofs_vle_workgroup *grp,
 	return page;
 }
 
-static inline struct z_erofs_vle_unzip_io *
-prepare_io_handler(struct super_block *sb,
-		   struct z_erofs_vle_unzip_io *io,
-		   bool background)
+static struct z_erofs_vle_unzip_io *
+jobqueue_init(struct super_block *sb,
+	      struct z_erofs_vle_unzip_io *io,
+	      bool foreground)
 {
 	struct z_erofs_vle_unzip_io_sb *iosb;
 
-	if (!background) {
+	if (foreground) {
 		/* waitqueue available for foreground io */
-		BUG_ON(!io);
+		DBG_BUGON(!io);
 
 		init_waitqueue_head(&io->u.wait);
 		atomic_set(&io->pending_bios, 0);
 		goto out;
 	}
 
-	if (io)
-		BUG();
-	else {
-		/* allocate extra io descriptor for background io */
-		iosb = kvzalloc(sizeof(struct z_erofs_vle_unzip_io_sb),
+	iosb = kvzalloc(sizeof(struct z_erofs_vle_unzip_io_sb),
 			GFP_KERNEL | __GFP_NOFAIL);
-		BUG_ON(!iosb);
-
-		io = &iosb->io;
-	}
+	DBG_BUGON(!iosb);
 
+	/* initialize fields in the allocated descriptor */
+	io = &iosb->io;
 	iosb->sb = sb;
 	INIT_WORK(&io->u.work, z_erofs_vle_unzip_wq);
 out:
@@ -1248,27 +1243,105 @@ prepare_io_handler(struct super_block *sb,
 	return io;
 }
 
+/* define workgroup jobqueue types */
+enum {
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+	JQ_BYPASS,
+#endif
+	JQ_SUBMIT,
+	NR_JOBQUEUES,
+};
+
+static void *jobqueueset_init(struct super_block *sb,
+			      z_erofs_vle_owned_workgrp_t qtail[],
+			      struct z_erofs_vle_unzip_io *q[],
+			      struct z_erofs_vle_unzip_io *fgq,
+			      bool forcefg)
+{
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-#define __FSIO_1 1
+	/*
+	 * if managed cache is enabled, bypass jobqueue is needed,
+	 * no need to read from device for all workgroups in this queue.
+	 */
+	q[JQ_BYPASS] = jobqueue_init(sb, fgq + JQ_BYPASS, true);
+	qtail[JQ_BYPASS] = &q[JQ_BYPASS]->head;
+#endif
+
+	q[JQ_SUBMIT] = jobqueue_init(sb, fgq + JQ_SUBMIT, forcefg);
+	qtail[JQ_SUBMIT] = &q[JQ_SUBMIT]->head;
+
+	return tagptr_cast_ptr(tagptr_fold(tagptr1_t, q[JQ_SUBMIT], !forcefg));
+}
+
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+static void move_to_bypass_jobqueue(struct z_erofs_vle_workgroup *grp,
+				    z_erofs_vle_owned_workgrp_t qtail[],
+				    z_erofs_vle_owned_workgrp_t owned_head)
+{
+	z_erofs_vle_owned_workgrp_t *const submit_qtail = qtail[JQ_SUBMIT];
+	z_erofs_vle_owned_workgrp_t *const bypass_qtail = qtail[JQ_BYPASS];
+
+	DBG_BUGON(owned_head == Z_EROFS_VLE_WORKGRP_TAIL_CLOSED);
+	if (owned_head == Z_EROFS_VLE_WORKGRP_TAIL)
+		owned_head = Z_EROFS_VLE_WORKGRP_TAIL_CLOSED;
+
+	WRITE_ONCE(grp->next, Z_EROFS_VLE_WORKGRP_TAIL_CLOSED);
+
+	WRITE_ONCE(*submit_qtail, owned_head);
+	WRITE_ONCE(*bypass_qtail, &grp->next);
+
+	qtail[JQ_BYPASS] = &grp->next;
+}
+
+static bool postsubmit_is_all_bypassed(struct z_erofs_vle_unzip_io *q[],
+				       unsigned int nr_bios,
+				       bool force_fg)
+{
+	/*
+	 * although background is preferred, no one is pending for submission.
+	 * don't issue workqueue for decompression but drop it directly instead.
+	 */
+	if (force_fg || nr_bios)
+		return false;
+
+	kvfree(container_of(q[JQ_SUBMIT],
+			    struct z_erofs_vle_unzip_io_sb,
+			    io));
+	return true;
+}
 #else
-#define __FSIO_1 0
+static void move_to_bypass_jobqueue(struct z_erofs_vle_workgroup *grp,
+				    z_erofs_vle_owned_workgrp_t qtail[],
+				    z_erofs_vle_owned_workgrp_t owned_head)
+{
+	/* impossible to bypass submission for managed cache disabled */
+	DBG_BUGON(1);
+}
+
+static bool postsubmit_is_all_bypassed(struct z_erofs_vle_unzip_io *q[],
+				       unsigned int nr_bios,
+				       bool force_fg)
+{
+	/* bios should be >0 if managed cache is disabled */
+	DBG_BUGON(!nr_bios);
+	return false;
+}
 #endif
 
 static bool z_erofs_vle_submit_all(struct super_block *sb,
 				   z_erofs_vle_owned_workgrp_t owned_head,
 				   struct list_head *pagepool,
-				   struct z_erofs_vle_unzip_io *fg_io,
+				   struct z_erofs_vle_unzip_io *fgq,
 				   bool force_fg)
 {
 	struct erofs_sb_info *const sbi = EROFS_SB(sb);
 	const unsigned int clusterpages = erofs_clusterpages(sbi);
 	const gfp_t gfp = GFP_NOFS;
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-	struct z_erofs_vle_workgroup *lstgrp_noio = NULL, *lstgrp_io = NULL;
-#endif
-	struct z_erofs_vle_unzip_io *ios[1 + __FSIO_1];
+
+	z_erofs_vle_owned_workgrp_t qtail[NR_JOBQUEUES];
+	struct z_erofs_vle_unzip_io *q[NR_JOBQUEUES];
 	struct bio *bio;
-	tagptr1_t bi_private;
+	void *bi_private;
 	/* since bio will be NULL, no need to initialize last_index */
 	pgoff_t uninitialized_var(last_index);
 	bool force_submit = false;
@@ -1277,28 +1350,13 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 	if (unlikely(owned_head == Z_EROFS_VLE_WORKGRP_TAIL))
 		return false;
 
-	/*
-	 * force_fg == 1, (io, fg_io[0]) no io, (io, fg_io[1]) need submit io
-	 * force_fg == 0, (io, fg_io[0]) no io; (io[1], bg_io) need submit io
-	 */
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-	ios[0] = prepare_io_handler(sb, fg_io + 0, false);
-#endif
-
-	if (force_fg) {
-		ios[__FSIO_1] = prepare_io_handler(sb, fg_io + __FSIO_1, false);
-		bi_private = tagptr_fold(tagptr1_t, ios[__FSIO_1], 0);
-	} else {
-		ios[__FSIO_1] = prepare_io_handler(sb, NULL, true);
-		bi_private = tagptr_fold(tagptr1_t, ios[__FSIO_1], 1);
-	}
-
-	nr_bios = 0;
 	force_submit = false;
 	bio = NULL;
+	nr_bios = 0;
+	bi_private = jobqueueset_init(sb, qtail, q, fgq, force_fg);
 
 	/* by default, all need io submission */
-	ios[__FSIO_1]->head = owned_head;
+	q[JQ_SUBMIT]->head = owned_head;
 
 	do {
 		struct z_erofs_vle_workgroup *grp;
@@ -1339,8 +1397,9 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 
 		if (!bio) {
 			bio = erofs_grab_bio(sb, first_index + i,
-				BIO_MAX_PAGES, z_erofs_vle_read_endio, true);
-			bio->bi_private = tagptr_cast_ptr(bi_private);
+					     BIO_MAX_PAGES,
+					     z_erofs_vle_read_endio, true);
+			bio->bi_private = bi_private;
 
 			++nr_bios;
 		}
@@ -1355,47 +1414,19 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 		if (++i < clusterpages)
 			goto repeat;
 
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-		if (nr_uptodate < clusterpages) {
-			lstgrp_io = grp;
-		} else {
-			z_erofs_vle_owned_workgrp_t iogrp_next =
-				owned_head == Z_EROFS_VLE_WORKGRP_TAIL ?
-				Z_EROFS_VLE_WORKGRP_TAIL_CLOSED :
-				owned_head;
-
-			if (!lstgrp_io)
-				ios[1]->head = iogrp_next;
-			else
-				WRITE_ONCE(lstgrp_io->next, iogrp_next);
-
-			if (!lstgrp_noio)
-				ios[0]->head = &grp->next;
-			else
-				WRITE_ONCE(lstgrp_noio->next, grp);
-
-			lstgrp_noio = grp;
-		}
-#endif
+		if (nr_uptodate < clusterpages)
+			qtail[JQ_SUBMIT] = &grp->next;
+		else
+			move_to_bypass_jobqueue(grp, qtail, owned_head);
 	} while (owned_head != Z_EROFS_VLE_WORKGRP_TAIL);
 
 	if (bio)
 		__submit_bio(bio, REQ_OP_READ, 0);
 
-#ifndef EROFS_FS_HAS_MANAGED_CACHE
-	BUG_ON(!nr_bios);
-#else
-	if (lstgrp_noio)
-		WRITE_ONCE(lstgrp_noio->next, Z_EROFS_VLE_WORKGRP_TAIL_CLOSED);
-
-	if (!force_fg && !nr_bios) {
-		kvfree(container_of(ios[1],
-			struct z_erofs_vle_unzip_io_sb, io));
+	if (postsubmit_is_all_bypassed(q, nr_bios, force_fg))
 		return true;
-	}
-#endif
 
-	z_erofs_vle_unzip_kickoff(tagptr_cast_ptr(bi_private), nr_bios);
+	z_erofs_vle_unzip_kickoff(bi_private, nr_bios);
 	return true;
 }
 
@@ -1404,23 +1435,23 @@ static void z_erofs_submit_and_unzip(struct z_erofs_vle_frontend *f,
 				     bool force_fg)
 {
 	struct super_block *sb = f->inode->i_sb;
-	struct z_erofs_vle_unzip_io io[1 + __FSIO_1];
+	struct z_erofs_vle_unzip_io io[NR_JOBQUEUES];
 
 	if (!z_erofs_vle_submit_all(sb, f->owned_head, pagepool, io, force_fg))
 		return;
 
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-	z_erofs_vle_unzip_all(sb, &io[0], pagepool);
+	z_erofs_vle_unzip_all(sb, &io[JQ_BYPASS], pagepool);
 #endif
 	if (!force_fg)
 		return;
 
 	/* wait until all bios are completed */
-	wait_event(io[__FSIO_1].u.wait,
-		!atomic_read(&io[__FSIO_1].pending_bios));
+	wait_event(io[JQ_SUBMIT].u.wait,
+		   !atomic_read(&io[JQ_SUBMIT].pending_bios));
 
 	/* let's synchronous decompression */
-	z_erofs_vle_unzip_all(sb, &io[__FSIO_1], pagepool);
+	z_erofs_vle_unzip_all(sb, &io[JQ_SUBMIT], pagepool);
 }
 
 static int z_erofs_vle_normalaccess_readpage(struct file *file,
-- 
2.14.4
