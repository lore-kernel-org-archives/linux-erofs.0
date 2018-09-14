From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 14 Sep 2018 22:40:26 +0800
Subject: [PATCH 4/8] staging: erofs: fix a bug when appling cache strategy
In-Reply-To: <1536936030-62362-1-git-send-email-gaoxiang25@huawei.com>
References: <1536936030-62362-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1536936030-62362-5-git-send-email-gaoxiang25@huawei.com>

As described in Kconfig, the last compressed pack should be cached
for further reading for either `EROFS_FS_ZIP_CACHE_UNIPOLAR' or
`EROFS_FS_ZIP_CACHE_BIPOLAR' by design.

However, there is a bug in z_erofs_do_read_page, it will
switch `initial' to `false' at the very beginning before it decides
to cache the last compressed pack.

caching strategy should work properly after appling this patch.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index d4998fe..0f2e180 100644
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
