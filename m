From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 11 Aug 2018 04:10:37 +0800
Subject: [PREVIEW] [PATCH v2 09/10] staging: erofs: fix a bug when appling
 cache strategy
In-Reply-To: <1533931838-47642-1-git-send-email-gaoxiang25@huawei.com>
References: <1533931838-47642-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1533931838-47642-9-git-send-email-gaoxiang25@huawei.com>

As described in Kconfig, the last compressed pack should be cached
for further reading for either `EROFS_FS_ZIP_CACHE_UNIPOLAR' or
`EROFS_FS_ZIP_CACHE_BIPOLAR' by design.

However, there is a bug in z_erofs_do_read_page, it will
switch `initial' to `false' at the very beginning before it decides
to cache the last compressed pack.

caching strategy should work properly after appling this patch.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
change log v2:
 - spilt into small patches at Chao's suggestion.

 drivers/staging/erofs/unzip_vle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 6c93877..1f64cb1 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -629,7 +629,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	/* go ahead the next map_blocks */
 	debugln("%s: [out-of-range] pos %llu", __func__, offset + cur);
 
-	if (!z_erofs_vle_work_iter_end(builder))
+	if (z_erofs_vle_work_iter_end(builder))
 		fe->initial = false;
 
 	map->m_la = offset + cur;
-- 
1.9.1
