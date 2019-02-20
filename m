From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 20 Feb 2019 17:18:43 +0800
Subject: [PATCH for-4.19 01/12] staging: erofs: fix a bug when appling cache
 strategy
In-Reply-To: <20190220091854.19242-1-gaoxiang25@huawei.com>
References: <20190220091854.19242-1-gaoxiang25@huawei.com>
Message-ID: <20190220091854.19242-2-gaoxiang25@huawei.com>

commit 0734ffbf574ee813b20899caef2fe0ed502bb783 upstream.

As described in Kconfig, the last compressed pack should be cached
for further reading for either `EROFS_FS_ZIP_CACHE_UNIPOLAR' or
`EROFS_FS_ZIP_CACHE_BIPOLAR' by design.

However, there is a bug in z_erofs_do_read_page, it will
switch `initial' to `false' at the very beginning before it decides
to cache the last compressed pack.

caching strategy should work properly after appling this patch.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh at linuxfoundation.org>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 0346630b67c8..35ae0865c1fd 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -624,7 +624,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	/* go ahead the next map_blocks */
 	debugln("%s: [out-of-range] pos %llu", __func__, offset + cur);
 
-	if (!z_erofs_vle_work_iter_end(builder))
+	if (z_erofs_vle_work_iter_end(builder))
 		fe->initial = false;
 
 	map->m_la = offset + cur;
-- 
2.14.4
