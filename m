From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 22 Jun 2018 10:01:27 +0800
Subject: [PATCH 07/11] erofs: remove unused EROFS_XATTR_INDEX_ADVISE
In-Reply-To: <20180622020131.65525-1-yuchao0@huawei.com>
References: <20180622020131.65525-1-yuchao0@huawei.com>
Message-ID: <20180622020131.65525-7-yuchao0@huawei.com>

EROFS_XATTR_INDEX_ADVISE is never used in anywhere of erofs, just
remove it.

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 fs/erofs/erofs_fs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/erofs/erofs_fs.h b/fs/erofs/erofs_fs.h
index 96feebc0bbec..fc92213c02e5 100644
--- a/fs/erofs/erofs_fs.h
+++ b/fs/erofs/erofs_fs.h
@@ -150,7 +150,6 @@ struct erofs_xattr_ibody_header {
 #define EROFS_XATTR_INDEX_TRUSTED           4
 #define EROFS_XATTR_INDEX_LUSTRE            5
 #define EROFS_XATTR_INDEX_SECURITY          6
-#define EROFS_XATTR_INDEX_ADVISE            7
 
 /* xattr entry (for both inline & shared xattrs) */
 struct erofs_xattr_entry {
-- 
2.18.0.rc1
