From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 28 Jul 2018 15:10:32 +0800
Subject: [PATCH] staging: erofs: fix a compile warning of
 Z_EROFS_VLE_VMAP_ONSTACK_PAGES
In-Reply-To: <1532607728-103372-26-git-send-email-gaoxiang25@huawei.com>
References: <1532607728-103372-26-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1532761832-6964-1-git-send-email-gaoxiang25@huawei.com>

There is a type mismatch in the definition of
Z_EROFS_VLE_VMAP_ONSTACK_PAGES, let's fix it.

Link: https://lists.01.org/pipermail/kbuild-all/2018-July/050707.html
Reported-by: kbuild test robot <lkp at intel.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/unzip_vle.h
index 3521dfb..3939985 100644
--- a/drivers/staging/erofs/unzip_vle.h
+++ b/drivers/staging/erofs/unzip_vle.h
@@ -218,7 +218,7 @@ static inline void z_erofs_onlinepage_endio(struct page *page)
 }
 
 #define Z_EROFS_VLE_VMAP_ONSTACK_PAGES	\
-	min(THREAD_SIZE / 8 / sizeof(struct page *), 96UL)
+	min_t(unsigned int, THREAD_SIZE / 8 / sizeof(struct page *), 96U)
 #define Z_EROFS_VLE_VMAP_GLOBAL_PAGES	2048
 
 /* unzip_vle_lz4.c */
-- 
1.9.1
