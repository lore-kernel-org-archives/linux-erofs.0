From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 22 Jun 2018 10:01:23 +0800
Subject: [PATCH 03/11] erofs: fix missing endian conversion
In-Reply-To: <20180622020131.65525-1-yuchao0@huawei.com>
References: <20180622020131.65525-1-yuchao0@huawei.com>
Message-ID: <20180622020131.65525-3-yuchao0@huawei.com>

This patch fixes to add missing endian conversion.

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 fs/erofs/dir.c   | 13 ++++++++-----
 fs/erofs/namei.c |  2 +-
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/erofs/dir.c b/fs/erofs/dir.c
index 39870e165007..5c5be7a88f71 100644
--- a/fs/erofs/dir.c
+++ b/fs/erofs/dir.c
@@ -40,17 +40,19 @@ static int erofs_fill_dentries(struct dir_context *ctx,
 		unsigned char dbg_namebuf[EROFS_NAME_LEN];
 #endif
 
+		nameoff = le16_to_cpu(de->nameoff);
+
 		if (unlikely(de->file_type < EROFS_FT_MAX))
 			d_type = erofs_filetype_table[de->file_type];
 		else
 			d_type = DT_UNKNOWN;
 
-		de_name = (char *)dentry_blk + de->nameoff;
+		de_name = (char *)dentry_blk + nameoff;
 
 		de_namelen = unlikely(de + 1 >= end) ?
 			/* last directory entry */
-			strnlen(de_name, maxsize - de->nameoff) :
-			de[1].nameoff - de->nameoff;
+			strnlen(de_name, maxsize - nameoff) :
+			le16_to_cpu(de[1].nameoff) - nameoff;
 
 		/* the corrupted directory found */
 		BUG_ON(de_namelen < 0);
@@ -64,7 +66,8 @@ static int erofs_fill_dentries(struct dir_context *ctx,
 			dbg_namebuf, de_namelen, d_type);
 #endif
 
-		if (!dir_emit(ctx, de_name, de_namelen, de->nid, d_type))
+		if (!dir_emit(ctx, de_name, de_namelen,
+					le64_to_cpu(de->nid), d_type))
 			/* stoped by some reason */
 			return 1;
 		++de;
@@ -96,7 +99,7 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
 		lock_page(dentry_page);
 		de = (struct erofs_dirent *)kmap(dentry_page);
 
-		nameoff = de->nameoff;
+		nameoff = le16_to_cpu(de->nameoff);
 
 		if (unlikely(nameoff < sizeof(struct erofs_dirent) ||
 			nameoff >= PAGE_SIZE)) {
diff --git a/fs/erofs/namei.c b/fs/erofs/namei.c
index 506974fd3a88..e30294b279d1 100644
--- a/fs/erofs/namei.c
+++ b/fs/erofs/namei.c
@@ -125,7 +125,7 @@ static struct page *find_target_block_classic(
 
 			matched = min(startprfx, endprfx);
 
-			dname.name = (u8 *)de + de->nameoff;
+			dname.name = (u8 *)de + nameoff;
 			dname.len = ndirents == 1 ?
 				/* since the rest of the last page is 0 */
 				EROFS_BLKSIZ - nameoff
-- 
2.18.0.rc1
