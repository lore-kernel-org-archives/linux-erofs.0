From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 25 Jan 2019 19:51:03 +0800
Subject: [PATCH 1/2] staging: erofs: use xattr_prefix to wrap up
Message-ID: <20190125115103.47250-1-gaoxiang25@huawei.com>

Let's use xattr_prefix instead of open code.
No logic changes.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
index 1c9498e38f0e..eca65df46133 100644
--- a/drivers/staging/erofs/xattr.c
+++ b/drivers/staging/erofs/xattr.c
@@ -521,7 +521,7 @@ static int xattr_entrylist(struct xattr_iter *_it,
 		return 1;
 
 	/* Note that at least one of 'prefix' and 'name' should be non-NULL */
-	prefix = h->prefix != NULL ? h->prefix : h->name;
+	prefix = xattr_prefix(h);
 	prefix_len = strlen(prefix);
 
 	if (it->buffer == NULL) {
-- 
2.14.4
