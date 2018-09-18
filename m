From: cgxu519@gmx.com (Chengguang Xu)
Date: Tue, 18 Sep 2018 23:10:55 +0800
Subject: [PATCH v3 1/4] staging: erofs: code cleanup for erofs_kmalloc()
In-Reply-To: <20180918151058.25041-1-cgxu519@gmx.com>
References: <20180918151058.25041-1-cgxu519@gmx.com>
Message-ID: <20180918151058.25041-2-cgxu519@gmx.com>

Define a dummy function of time_to_inject()/erofs_show_injection_info(),
so that we don't have to check macro CONFIG_EROFS_FAULT_INJECTION in
calling place.

Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index f20c6e9b7471..0011b9d505fd 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -42,12 +42,12 @@
 #define DBG_BUGON(...)          ((void)0)
 #endif
 
-#ifdef CONFIG_EROFS_FAULT_INJECTION
 enum {
 	FAULT_KMALLOC,
 	FAULT_MAX,
 };
 
+#ifdef CONFIG_EROFS_FAULT_INJECTION
 extern char *erofs_fault_name[FAULT_MAX];
 #define IS_FAULT_SET(fi, type) ((fi)->inject_type & (1 << (type)))
 
@@ -143,17 +143,24 @@ static inline bool time_to_inject(struct erofs_sb_info *sbi, int type)
 	}
 	return false;
 }
+#else
+static inline bool time_to_inject(struct erofs_sb_info *sbi, int type)
+{
+	return false;
+}
+
+static inline void erofs_show_injection_info(int type)
+{
+}
 #endif
 
 static inline void *erofs_kmalloc(struct erofs_sb_info *sbi,
 					size_t size, gfp_t flags)
 {
-#ifdef CONFIG_EROFS_FAULT_INJECTION
 	if (time_to_inject(sbi, FAULT_KMALLOC)) {
 		erofs_show_injection_info(FAULT_KMALLOC);
 		return NULL;
 	}
-#endif
 	return kmalloc(size, flags);
 }
 
-- 
2.17.1
