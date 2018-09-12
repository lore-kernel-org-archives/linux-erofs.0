From: cgxu519@gmx.com (Chengguang Xu)
Date: Wed, 12 Sep 2018 13:10:28 +0800
Subject: [PATCH 1/7] staging: erofs: code cleanup for erofs_kmalloc()
In-Reply-To: <20180912051034.3463-1-cgxu519@gmx.com>
References: <20180912051034.3463-1-cgxu519@gmx.com>
Message-ID: <20180912051034.3463-2-cgxu519@gmx.com>

Define a dummy function of time_to_inject(), so that we don't
have to check macro CONFIG_EROFS_FAULT_INJECTION in calling place.
Base on above adjustment, do proper code cleanup for erofs_kmalloc().

Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
---
 drivers/staging/erofs/internal.h | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 367b39fe46e5..1bb2e9e96143 100644
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
 
@@ -139,21 +139,25 @@ static inline bool time_to_inject(struct erofs_sb_info *sbi, int type)
 	atomic_inc(&ffi->inject_ops);
 	if (atomic_read(&ffi->inject_ops) >= ffi->inject_rate) {
 		atomic_set(&ffi->inject_ops, 0);
+		erofs_show_injection_info(type);
 		return true;
 	}
 	return false;
 }
+
+#else
+static inline bool time_to_inject(struct erofs_sb_info *sbi, int type)
+{
+	return false;
+}
 #endif
 
 static inline void *erofs_kmalloc(struct erofs_sb_info *sbi,
 					size_t size, gfp_t flags)
 {
-#ifdef CONFIG_EROFS_FAULT_INJECTION
-	if (time_to_inject(sbi, FAULT_KMALLOC)) {
-		erofs_show_injection_info(FAULT_KMALLOC);
+	if (time_to_inject(sbi, FAULT_KMALLOC))
 		return NULL;
-	}
-#endif
+
 	return kmalloc(size, flags);
 }
 
-- 
2.17.1
