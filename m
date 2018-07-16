From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 16 Jul 2018 09:58:20 +0800
Subject: [PATCH 2/2] erofs: fix the missing integer overflow
In-Reply-To: <1531706300-45908-1-git-send-email-gaoxiang25@huawei.com>
References: <1531158912-84952-1-git-send-email-gaoxiang25@huawei.com>
 <1531706300-45908-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1531706300-45908-2-git-send-email-gaoxiang25@huawei.com>

This patch fixes the missing integer overflow in internal.h

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/internal.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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
