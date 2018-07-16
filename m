From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 16 Jul 2018 10:13:10 +0800
Subject: [PATCH v2 2/2] erofs: fix the potential integer overflow
In-Reply-To: <1531706300-45908-2-git-send-email-gaoxiang25@huawei.com>
References: <1531706300-45908-2-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1531707190-50579-1-git-send-email-gaoxiang25@huawei.com>

This patch fixes the potential integer overflow
in internal.h and dir.c

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
change log v2:
 - fix the the potential integer overflow in dir.c
 - there is no need to fix the potential integer overflow
   in the unzip subsystem since it will be replaced this week.

 fs/erofs/dir.c      | 2 +-
 fs/erofs/internal.h | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/dir.c b/fs/erofs/dir.c
index 176b2f7..d4e87fa 100644
--- a/fs/erofs/dir.c
+++ b/fs/erofs/dir.c
@@ -128,7 +128,7 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
 		unlock_page(dentry_page);
 		put_page(dentry_page);
 
-		ctx->pos = i * EROFS_BLKSIZ + ofs;
+		ctx->pos = blknr_to_addr(i) + ofs;
 
 		if (unlikely(err))
 			break;
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index e52252f..3f3745f 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -163,14 +163,15 @@ static inline void *erofs_kmalloc(struct erofs_sb_info *sbi,
 /* data type for filesystem-wide blocks number */
 typedef u32 erofs_blk_t;
 
+#define blknr_to_addr(nr)       ((erofs_off_t)(nr) * EROFS_BLKSIZ)
+
 static inline erofs_off_t iloc(struct erofs_sb_info *sbi, erofs_nid_t nid)
 {
-	return sbi->meta_blkaddr * EROFS_BLKSIZ + (nid << sbi->islotbits);
+	return blknr_to_addr(sbi->meta_blkaddr) + (nid << sbi->islotbits);
 }
 
 #define erofs_blknr(addr)       ((addr) / EROFS_BLKSIZ)
 #define erofs_blkoff(addr)      ((addr) % EROFS_BLKSIZ)
-#define blknr_to_addr(nr)       ((erofs_off_t)(nr) * EROFS_BLKSIZ)
 
 #define inode_set_inited_xattr(inode)   (EROFS_V(inode)->flags |= 1)
 #define inode_has_inited_xattr(inode)   (EROFS_V(inode)->flags & 1)
-- 
1.9.1
