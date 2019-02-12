From: cgxu519@gmx.com (Chengguang Xu)
Date: Tue, 12 Feb 2019 11:24:23 +0800
Subject: [PATCH 2/2] staging: erofs: remove redundant unlikely annotation in
 unzip_vle.c
In-Reply-To: <20190212032423.14637-1-cgxu519@gmx.com>
References: <20190212032423.14637-1-cgxu519@gmx.com>
Message-ID: <20190212032423.14637-2-cgxu519@gmx.com>

unlikely has already included in IS_ERR(),
so just remove it.

Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
---
 drivers/staging/erofs/unzip_vle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 4ac1099a39c6..7cd2d4d9c264 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -539,7 +539,7 @@ static int z_erofs_vle_work_iter_begin(struct z_erofs_vle_work_builder *builder,
 	if (unlikely(work == ERR_PTR(-EAGAIN)))
 		goto repeat;
 
-	if (unlikely(IS_ERR(work)))
+	if (IS_ERR(work))
 		return PTR_ERR(work);
 got_it:
 	z_erofs_pagevec_ctor_init(&builder->vector,
-- 
2.20.1
