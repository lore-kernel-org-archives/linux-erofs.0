From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 24 Jan 2019 10:58:25 +0800
Subject: [PREVIEW] [PATCH] staging: erofs: fix mis-acted TAIL merging
 behavior
In-Reply-To: <20190123225749.DDDF6218A4@mail.kernel.org>
References: <20190122124530.5621-1-gaoxiang25@huawei.com>
 <20190123225749.DDDF6218A4@mail.kernel.org>
Message-ID: <ee00e4ea-b281-8d64-305c-39a81faa8603@huawei.com>

Hi Sasha,

Sorry for annoying, please ignore this patch since it has not been
sent to linux-staging mailing list.

On 2019/1/24 6:57, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 3883a79abd02 staging: erofs: introduce VLE decompression support.
> 
> The bot has tested the following trees: v4.20.3, v4.19.16.
> 
> v4.20.3: Build OK!
> v4.19.16: Failed to apply! Possible dependencies:
>     ab47dd2b0819 ("staging: erofs: cleanup z_erofs_vle_work_{lookup, register}")
> 

Anyway, the corresponding 4.19 patch is attached in the end.

Thanks,
Gao Xiang

> 
> How should we proceed with this patch?
> 
> --
> Thanks,
> Sasha
> 


>From 6982dff48665dae0a6ed77ed2abef476e2d01488 Mon Sep 17 00:00:00 2001
From: Gao Xiang <gaoxiang25@huawei.com>
Date: Tue, 22 Jan 2019 17:29:47 +0800
Subject: [PATCH 4.19] staging: erofs: fix mis-acted TAIL merging behavior

EROFS has an optimized path called TAIL merging, which is designed
to merge multiple reads and the corresponding decompressions into
one if these requests read continuous pages almost at the same time.

In general, it behaves as follows:
 ________________________________________________________________
  ... |  TAIL  .  HEAD  |  PAGE  |  PAGE  |  TAIL    . HEAD | ...
 _____|_combined page A_|________|________|_combined page B_|____
        1  ]  ->  [  2                          ]  ->  [ 3
If the above three reads are requested in the order 1-2-3, it will
generate a large work chain rather than 3 individual work chains
to reduce scheduling overhead and boost up sequential read.

However, if Read 2 is processed slightly earlier than Read 1,
currently it still generates 2 individual work chains (chain 1, 2)
but it does in-place decompression for combined page A, moreover,
if chain 2 decompresses ahead of chain 1, it will be a race and
lead to corrupted decompressed page. This patch fixes it.

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Cc: <stable at vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 69 +++++++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 8721f0a41d15..05aa5d3a2e82 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -60,15 +60,30 @@ enum z_erofs_vle_work_role {
 	Z_EROFS_VLE_WORK_SECONDARY,
 	Z_EROFS_VLE_WORK_PRIMARY,
 	/*
-	 * The current work has at least been linked with the following
-	 * processed chained works, which means if the processing page
-	 * is the tail partial page of the work, the current work can
-	 * safely use the whole page, as illustrated below:
-	 * +--------------+-------------------------------------------+
-	 * |  tail page   |      head page (of the previous work)     |
-	 * +--------------+-------------------------------------------+
-	 *   /\  which belongs to the current work
-	 * [  (*) this page can be used for the current work itself.  ]
+	 * The current work was the tail of an exist chain, but the following
+	 * processed chained works are now all hooked up to it.
+	 * A new chain should be created for the remaining unprocessed works,
+	 * therefore different from Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED,
+	 * the next work cannot reuse the whole page in the following scenario:
+	 *  ________________________________________________________________
+	 * |      tail (partial) page     |       head (partial) page       |
+	 * |  (belongs to the next work)  |  (belongs to the current work)  |
+	 * |_______PRIMARY_FOLLOWED_______|________PRIMARY_HOOKED___________|
+	 */
+	Z_EROFS_VLE_WORK_PRIMARY_HOOKED,
+	/*
+	 * The current work has been linked with the processed chained works,
+	 * and could be also linked with the potential remaining works, which
+	 * means if the processing page is the tail partial page of the work,
+	 * the current work can safely use the whole page (since the next work
+	 * is under control) for in-place decompression, as illustrated below:
+	 *  ________________________________________________________________
+	 * |  tail (partial) page  |          head (partial) page           |
+	 * | (of the current work) |         (of the previous work)         |
+	 * |  PRIMARY_FOLLOWED or  |                                        |
+	 * |_____PRIMARY_HOOKED____|____________PRIMARY_FOLLOWED____________|
+	 *
+	 * [  (*) the above page can be used for the current work itself.  ]
 	 */
 	Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED,
 	Z_EROFS_VLE_WORK_MAX
@@ -237,10 +252,10 @@ static int z_erofs_vle_work_add_page(
 	return ret ? 0 : -EAGAIN;
 }
 
-static inline bool try_to_claim_workgroup(
-	struct z_erofs_vle_workgroup *grp,
-	z_erofs_vle_owned_workgrp_t *owned_head,
-	bool *hosted)
+static enum z_erofs_vle_work_role
+try_to_claim_workgroup(struct z_erofs_vle_workgroup *grp,
+		       z_erofs_vle_owned_workgrp_t *owned_head,
+		       bool *hosted)
 {
 	DBG_BUGON(*hosted == true);
 
@@ -254,6 +269,9 @@ static inline bool try_to_claim_workgroup(
 
 		*owned_head = grp;
 		*hosted = true;
+		/* lucky, I am the followee :) */
+		return Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED;
+
 	} else if (grp->next == Z_EROFS_VLE_WORKGRP_TAIL) {
 		/*
 		 * type 2, link to the end of a existing open chain,
@@ -263,12 +281,11 @@ static inline bool try_to_claim_workgroup(
 		if (Z_EROFS_VLE_WORKGRP_TAIL != cmpxchg(&grp->next,
 			Z_EROFS_VLE_WORKGRP_TAIL, *owned_head))
 			goto retry;
-
 		*owned_head = Z_EROFS_VLE_WORKGRP_TAIL;
-	} else
-		return false;	/* :( better luck next time */
+		return Z_EROFS_VLE_WORK_PRIMARY_HOOKED;
+	}
 
-	return true;	/* lucky, I am the followee :) */
+	return Z_EROFS_VLE_WORK_PRIMARY; /* :( better luck next time */
 }
 
 static struct z_erofs_vle_work *
@@ -343,12 +360,8 @@ z_erofs_vle_work_lookup(struct super_block *sb,
 	*hosted = false;
 	if (!primary)
 		*role = Z_EROFS_VLE_WORK_SECONDARY;
-	/* claim the workgroup if possible */
-	else if (try_to_claim_workgroup(grp, owned_head, hosted))
-		*role = Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED;
-	else
-		*role = Z_EROFS_VLE_WORK_PRIMARY;
-
+	else	/* claim the workgroup if possible */
+		*role = try_to_claim_workgroup(grp, owned_head, hosted);
 	return work;
 }
 
@@ -431,6 +444,9 @@ static inline void __update_workgrp_llen(struct z_erofs_vle_workgroup *grp,
 	}
 }
 
+#define builder_is_hooked(builder) \
+	((builder)->role >= Z_EROFS_VLE_WORK_PRIMARY_HOOKED)
+
 #define builder_is_followed(builder) \
 	((builder)->role >= Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED)
 
@@ -595,7 +611,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	struct z_erofs_vle_work_builder *const builder = &fe->builder;
 	const loff_t offset = page_offset(page);
 
-	bool tight = builder_is_followed(builder);
+	bool tight = builder_is_hooked(builder);
 	struct z_erofs_vle_work *work = builder->work;
 
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
@@ -659,7 +675,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 		builder->role = Z_EROFS_VLE_WORK_PRIMARY;
 #endif
 
-	tight &= builder_is_followed(builder);
+	tight &= builder_is_hooked(builder);
 	work = builder->work;
 hitted:
 	cur = end - min_t(unsigned, offset + end - map->m_la, end);
@@ -674,6 +690,9 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 			(tight ? Z_EROFS_PAGE_TYPE_EXCLUSIVE :
 				Z_EROFS_VLE_PAGE_TYPE_TAIL_SHARED));
 
+	if (cur)
+		tight &= builder_is_followed(builder);
+
 retry:
 	err = z_erofs_vle_work_add_page(builder, page, page_type);
 	/* should allocate an additional staging page for pagevec */
-- 
2.14.4
