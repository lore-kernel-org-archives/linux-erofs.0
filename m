From: chao@kernel.org (Chao Yu)
Date: Mon, 11 Mar 2019 23:10:10 +0800
Subject: [PATCH] staging: erofs: fix to handle error path of erofs_vmap()
Message-ID: <20190311151010.3620-1-chao@kernel.org>

From: Chao Yu <yuchao0@huawei.com>

erofs_vmap() wrapped vmap() and vm_map_ram() to return virtual
continuous memory, but both of them can failed due to a lot of
reason, previously, erofs_vmap()'s callers didn't handle them,
which can potentially cause NULL pointer access, fix it.

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Fixes: 0d40d6e399c1 ("staging: erofs: add a generic z_erofs VLE decompressor")
Cc: <stable at vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c     | 4 ++++
 drivers/staging/erofs/unzip_vle_lz4.c | 7 +++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 2b5951f233db..396f38b1c1b2 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1010,6 +1010,10 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 
 skip_allocpage:
 	vout = erofs_vmap(pages, nr_pages);
+	if (!vout) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	err = z_erofs_vle_unzip_vmap(compressed_pages,
 		clusterpages, vout, llen, work->pageofs, overlapped);
diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
index 8e8d705a6861..cff293710663 100644
--- a/drivers/staging/erofs/unzip_vle_lz4.c
+++ b/drivers/staging/erofs/unzip_vle_lz4.c
@@ -137,10 +137,13 @@ int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
 
 	nr_pages = DIV_ROUND_UP(outlen + pageofs, PAGE_SIZE);
 
-	if (clusterpages == 1)
+	if (clusterpages == 1) {
 		vin = kmap_atomic(compressed_pages[0]);
-	else
+	} else {
 		vin = erofs_vmap(compressed_pages, clusterpages);
+		if (!vin)
+			return -ENOMEM;
+	}
 
 	preempt_disable();
 	vout = erofs_pcpubuf[smp_processor_id()].data;
-- 
2.18.0
