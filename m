From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 20 Aug 2018 21:29:03 +0800
Subject: [PATCH] staging: erofs: fix error handling in __erofs_get_meta_page
Message-ID: <1534771743-129893-1-git-send-email-gaoxiang25@huawei.com>

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

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
Hi Chao,

Could you please fold this patch in the previous patch if it is convenient?
`staging: erofs: separate erofs_get_meta_page'

It seems v2 of these patches has not been sent out to the staging mailing list.
LINK: https://lore.kernel.org/lkml/ffd2748a-273f-792b-d418-2fcf85c3d45f at huawei.com/

Thanks,
Gao Xiang

 drivers/staging/erofs/data.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index 87a18a0..3c0d915 100644
--- a/drivers/staging/erofs/data.c
+++ b/drivers/staging/erofs/data.c
@@ -63,9 +63,9 @@ struct page *__erofs_get_meta_page(struct super_block *sb,
 		struct bio *bio;
 
 		bio = erofs_grab_bio(sb, blkaddr, 1, read_endio, nofail);
-		if (unlikely(bio == NULL)) {
+		if (IS_ERR(bio)) {
 			DBG_BUGON(nofail);
-			err = -ENOMEM;
+			err = PTR_ERR(bio);
 			goto err_out;
 		}
 
-- 
1.9.1
