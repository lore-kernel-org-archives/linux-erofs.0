From: ming.lei@redhat.com (Ming Lei)
Date: Thu, 15 Nov 2018 16:53:00 +0800
Subject: [PATCH V10 13/19] iomap & xfs: only account for new added page
In-Reply-To: <20181115085306.9910-1-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
Message-ID: <20181115085306.9910-14-ming.lei@redhat.com>

After multi-page is enabled, one new page may be merged to a segment
even though it is a new added page.

This patch deals with this issue by post-check in case of merge, and
only a freshly new added page need to be dealt with for iomap & xfs.

Cc: Dave Chinner <dchinner at redhat.com>
Cc: Kent Overstreet <kent.overstreet at gmail.com>
Cc: Mike Snitzer <snitzer at redhat.com>
Cc: dm-devel at redhat.com
Cc: Alexander Viro <viro at zeniv.linux.org.uk>
Cc: linux-fsdevel at vger.kernel.org
Cc: Shaohua Li <shli at kernel.org>
Cc: linux-raid at vger.kernel.org
Cc: linux-erofs at lists.ozlabs.org
Cc: David Sterba <dsterba at suse.com>
Cc: linux-btrfs at vger.kernel.org
Cc: Darrick J. Wong <darrick.wong at oracle.com>
Cc: linux-xfs at vger.kernel.org
Cc: Gao Xiang <gaoxiang25 at huawei.com>
Cc: Christoph Hellwig <hch at lst.de>
Cc: Theodore Ts'o <tytso at mit.edu>
Cc: linux-ext4 at vger.kernel.org
Cc: Coly Li <colyli at suse.de>
Cc: linux-bcache at vger.kernel.org
Cc: Boaz Harrosh <ooo at electrozaur.com>
Cc: Bob Peterson <rpeterso at redhat.com>
Cc: cluster-devel at redhat.com
Signed-off-by: Ming Lei <ming.lei at redhat.com>
---
 fs/iomap.c          | 22 ++++++++++++++--------
 fs/xfs/xfs_aops.c   | 10 ++++++++--
 include/linux/bio.h | 11 +++++++++++
 3 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index df0212560b36..a1b97a5c726a 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -288,6 +288,7 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	loff_t orig_pos = pos;
 	unsigned poff, plen;
 	sector_t sector;
+	bool need_account = false;
 
 	if (iomap->type == IOMAP_INLINE) {
 		WARN_ON_ONCE(pos);
@@ -313,18 +314,15 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	 */
 	sector = iomap_sector(iomap, pos);
 	if (ctx->bio && bio_end_sector(ctx->bio) == sector) {
-		if (__bio_try_merge_page(ctx->bio, page, plen, poff))
+		if (__bio_try_merge_page(ctx->bio, page, plen, poff)) {
+			need_account = iop && bio_is_last_segment(ctx->bio,
+					page, plen, poff);
 			goto done;
+		}
 		is_contig = true;
 	}
 
-	/*
-	 * If we start a new segment we need to increase the read count, and we
-	 * need to do so before submitting any previous full bio to make sure
-	 * that we don't prematurely unlock the page.
-	 */
-	if (iop)
-		atomic_inc(&iop->read_count);
+	need_account = true;
 
 	if (!ctx->bio || !is_contig || bio_full(ctx->bio)) {
 		gfp_t gfp = mapping_gfp_constraint(page->mapping, GFP_KERNEL);
@@ -347,6 +345,14 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	__bio_add_page(ctx->bio, page, plen, poff);
 done:
 	/*
+	 * If we add a new page we need to increase the read count, and we
+	 * need to do so before submitting any previous full bio to make sure
+	 * that we don't prematurely unlock the page.
+	 */
+	if (iop && need_account)
+		atomic_inc(&iop->read_count);
+
+	/*
 	 * Move the caller beyond our range so that it keeps making progress.
 	 * For that we have to include any leading non-uptodate ranges, but
 	 * we can skip trailing ones as they will be handled in the next
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 1f1829e506e8..d8e9cc9f751a 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -603,6 +603,7 @@ xfs_add_to_ioend(
 	unsigned		len = i_blocksize(inode);
 	unsigned		poff = offset & (PAGE_SIZE - 1);
 	sector_t		sector;
+	bool			need_account;
 
 	sector = xfs_fsb_to_db(ip, wpc->imap.br_startblock) +
 		((offset - XFS_FSB_TO_B(mp, wpc->imap.br_startoff)) >> 9);
@@ -617,13 +618,18 @@ xfs_add_to_ioend(
 	}
 
 	if (!__bio_try_merge_page(wpc->ioend->io_bio, page, len, poff)) {
-		if (iop)
-			atomic_inc(&iop->write_count);
+		need_account = true;
 		if (bio_full(wpc->ioend->io_bio))
 			xfs_chain_bio(wpc->ioend, wbc, bdev, sector);
 		__bio_add_page(wpc->ioend->io_bio, page, len, poff);
+	} else {
+		need_account = iop && bio_is_last_segment(wpc->ioend->io_bio,
+				page, len, poff);
 	}
 
+	if (iop && need_account)
+		atomic_inc(&iop->write_count);
+
 	wpc->ioend->io_size += len;
 }
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 1a2430a8b89d..5040e9a2eb09 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -341,6 +341,17 @@ static inline struct bio_vec *bio_last_bvec_all(struct bio *bio)
 	return &bio->bi_io_vec[bio->bi_vcnt - 1];
 }
 
+/* iomap needs this helper to deal with sub-pagesize bvec */
+static inline bool bio_is_last_segment(struct bio *bio, struct page *page,
+		unsigned int len, unsigned int off)
+{
+	struct bio_vec bv;
+
+	bvec_last_segment(bio_last_bvec_all(bio), &bv);
+
+	return bv.bv_page == page && bv.bv_len == len && bv.bv_offset == off;
+}
+
 enum bip_flags {
 	BIP_BLOCK_INTEGRITY	= 1 << 0, /* block layer owns integrity data */
 	BIP_MAPPED_INTEGRITY	= 1 << 1, /* ref tag has been remapped */
-- 
2.9.5
