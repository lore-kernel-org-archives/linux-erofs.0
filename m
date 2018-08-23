From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 23 Aug 2018 17:19:01 +0800
Subject: [PREVIEW] [PATCH] staging: erofs: fix potential overflow in
 z_erofs_vle_normalaccess_readpage{, s}
Message-ID: <1535015941-116443-1-git-send-email-gaoxiang25@huawei.com>

As Dan reported in the LKP mailing list:
https://lists.01.org/pipermail/kbuild-all/2018-August/051558.html

New smatch warnings:
drivers/staging/erofs/unzip_vle.c:1359 z_erofs_vle_normalaccess_readpages() warn: should '()->index << 12' be a 64 bit type?

Old smatch warnings:
drivers/staging/erofs/unzip_vle.c:1322 z_erofs_vle_normalaccess_readpage() warn: should 'page->index << 12' be a 64 bit type?

It needs to cast variable's type to erofs_off_t before left shifting.

Reported-by: Dan Carpenter <dan.carpenter at oracle.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---

Hi Chao,

This patch is based on
`staging: erofs: fix potential overflow in erofs_grab_bio()'
in order to avoid patch conflict when rebasing.

I think it is better to rearrange the commit order in the erofs branch and
it needs to be sent separately in advance to Greg.

Thanks,
Gao Xiang

 drivers/staging/erofs/unzip_vle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 6c4c928..22f9a02 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1314,7 +1314,7 @@ static int z_erofs_vle_normalaccess_readpage(struct file *file,
 	LIST_HEAD(pagepool);
 
 #if (EROFS_FS_ZIP_CACHE_LVL >= 2)
-	f.cachedzone_la = page->index << PAGE_SHIFT;
+	f.cachedzone_la = (erofs_off_t)page->index << PAGE_SHIFT;
 #endif
 	err = z_erofs_do_read_page(&f, page, &pagepool);
 	(void)z_erofs_vle_work_iter_end(&f.builder);
@@ -1347,7 +1347,7 @@ static inline int __z_erofs_vle_normalaccess_readpages(
 	LIST_HEAD(pagepool);
 
 #if (EROFS_FS_ZIP_CACHE_LVL >= 2)
-	f.cachedzone_la = lru_to_page(pages)->index << PAGE_SHIFT;
+	f.cachedzone_la = (erofs_off_t)lru_to_page(pages)->index << PAGE_SHIFT;
 #endif
 	for (; nr_pages; --nr_pages) {
 		struct page *page = lru_to_page(pages);
-- 
1.9.1
