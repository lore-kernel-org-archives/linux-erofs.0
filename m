From: hsiangkao@aol.com (Gao Xiang)
Date: Fri, 23 Nov 2018 01:15:58 +0800
Subject: [PATCH v2 01/10] staging: erofs: fix `trace_erofs_readpage' position
In-Reply-To: <1542906967-249-1-git-send-email-hsiangkao@aol.com>
References: <1542906967-249-1-git-send-email-hsiangkao@aol.com>
Message-ID: <1542906967-249-2-git-send-email-hsiangkao@aol.com>

From: Gao Xiang <gaoxiang25@huawei.com>

`trace_erofs_readpage' was designed for .readpage() interface hook
in order to trace the detailed synchronized read rather than
the internal implementation `z_erofs_do_read_page' which both
.readpage() and .readpages() use.

It seems the tracepoint was placed to a wrong place by mistake and
it should be moved to the right place.

Fixes: 284db12cfda3 ("staging: erofs: add trace points for reading zipped data")
Reviewed-by: Chen Gong <gongchen4 at huawei.com>
Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 6a283f618f46..ede3383ac601 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -598,8 +598,6 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	unsigned int cur, end, spiltted, index;
 	int err = 0;
 
-	trace_erofs_readpage(page, false);
-
 	/* register locked file pages as online pages in pack */
 	z_erofs_onlinepage_init(page);
 
@@ -1288,6 +1286,8 @@ static int z_erofs_vle_normalaccess_readpage(struct file *file,
 	int err;
 	LIST_HEAD(pagepool);
 
+	trace_erofs_readpage(page, false);
+
 #if (EROFS_FS_ZIP_CACHE_LVL >= 2)
 	f.cachedzone_la = (erofs_off_t)page->index << PAGE_SHIFT;
 #endif
-- 
2.11.0
