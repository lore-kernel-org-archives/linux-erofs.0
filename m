From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 29 Jan 2019 16:35:19 +0800
Subject: [PATCH v4 1/2] staging: erofs: use xattr_prefix to wrap up
Message-ID: <20190129083520.28607-1-gaoxiang25@huawei.com>

Let's use xattr_prefix instead of open code.
No logic changes.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
[resend v2 as v4]
change log v2:
 - remove the confusing line according to Dan Carpenter;

 drivers/staging/erofs/xattr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
index 1c9498e38f0e..7de46690d972 100644
--- a/drivers/staging/erofs/xattr.c
+++ b/drivers/staging/erofs/xattr.c
@@ -520,8 +520,7 @@ static int xattr_entrylist(struct xattr_iter *_it,
 	if (h == NULL || (h->list != NULL && !h->list(it->dentry)))
 		return 1;
 
-	/* Note that at least one of 'prefix' and 'name' should be non-NULL */
-	prefix = h->prefix != NULL ? h->prefix : h->name;
+	prefix = xattr_prefix(h);
 	prefix_len = strlen(prefix);
 
 	if (it->buffer == NULL) {
-- 
2.14.4
