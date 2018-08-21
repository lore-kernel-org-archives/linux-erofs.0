From: chao@kernel.org (Chao Yu)
Date: Tue, 21 Aug 2018 22:49:37 +0800
Subject: [PATCH 9/9] staging: erofs: fix potential overflow in erofs_grab_bio()
In-Reply-To: <20180821144937.20555-1-chao@kernel.org>
References: <20180821144937.20555-1-chao@kernel.org>
Message-ID: <20180821144937.20555-10-chao@kernel.org>

From: Chao Yu <yuchao0@huawei.com>

As Dan reported in LKP's mailing list:

https://lists.01.org/pipermail/kbuild-all/2018-August/051419.html

New smatch warnings:
drivers/staging/erofs/internal.h:446 erofs_grab_bio() warn: should 'blkaddr << (12 - 9)' be a 64 bit type?
drivers/staging/erofs/data.c:78 __erofs_get_meta_page() error: 'bio' dereferencing possible ERR_PTR()
drivers/staging/erofs/internal.h:446 erofs_grab_bio() warn: should 'blkaddr << (12 - 9)' be a 64 bit type?

Old smatch warnings:
drivers/staging/erofs/unzip_vle.c:989 z_erofs_vle_unzip() error: double unlock 'mutex:&z_pagemap_global_lock'
drivers/staging/erofs/unzip_vle.c:1318 z_erofs_vle_normalaccess_readpage() warn: should 'page->index << 12' be a 64 bit type?
drivers/staging/erofs/unzip_vle.c:1351 __z_erofs_vle_normalaccess_readpages() warn: should '()->index << 12' be a 64 bit type?

It needs to cast varable's type to sector_t before left shifting.

Reported-by: Dan Carpenter <dan.carpenter at oracle.com>
Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 drivers/staging/erofs/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 8951e01216e3..f20c6e9b7471 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -443,7 +443,7 @@ erofs_grab_bio(struct super_block *sb,
 
 	bio->bi_end_io = endio;
 	bio_set_dev(bio, sb->s_bdev);
-	bio->bi_iter.bi_sector = blkaddr << LOG_SECTORS_PER_BLOCK;
+	bio->bi_iter.bi_sector = (sector_t)blkaddr << LOG_SECTORS_PER_BLOCK;
 	return bio;
 }
 
-- 
2.18.0
