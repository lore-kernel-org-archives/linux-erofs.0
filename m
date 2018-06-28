From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 28 Jun 2018 23:02:15 +0800
Subject: [RFC PATCH RESEND v3] <linux/tagptr.h>: Introduce tagged pointer
In-Reply-To: <1530176789-107541-1-git-send-email-gaoxiang25@huawei.com>
References: <1530176789-107541-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1530198135-112481-1-git-send-email-gaoxiang25@huawei.com>

Currently kernel has scattered tagged pointer usages hacked
by hand in plain code, without a unique and portable functionset
to highlight the tagged pointer itself and wrap these hacked code
in order to clean up all over meaningless magic masks.

Therefore, this patch introduces simple generic methods to fold
tags into a pointer integer. It currently supports the last n bits
of the pointer for tags, which can be selected by users.

In addition, it will also be used for the upcoming EROFS filesystem,
which heavily uses tagged pointer approach for high performance
and reducing extra memory allocation.

Refer to:
https://en.wikipedia.org/wiki/Tagged_pointer

To: Alexander Viro <viro at zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh at linuxfoundation.org>
Cc: Kate Stewart <kstewart at linuxfoundation.org>
Cc: Matthew Wilcox <willy at infradead.org>
Cc: Philippe Ombredanne <pombredanne at nexb.com>
Cc: Thomas Gleixner <tglx at linutronix.de>
Cc: Chao Yu <yuchao0 at huawei.com>
Cc: Miao Xie <miaoxie at huawei.com>
Cc: linux-fsdevel at vger.kernel.org
Cc: linux-erofs at lists.ozlabs.org
Cc: linux-kernel at vger.kernel.org
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
change log v3:
  - include/linux/file.h: define a unique alias fdtagptr_t (tagptr2_t)

change log v2:
  - add support to select the last {1,2,3,...} bits for tags


Tagged pointers are good for performance and memory saving,
hoping for a generic taggedptr approach to clean up redundant dirty code.

Any comments, suggestions or alternative approaches are welcomed. :)

Thanks,
Gao Xiang

 fs/file.c              | 24 +++++++++-------
 include/linux/file.h   | 15 ++++++----
 include/linux/tagptr.h | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+), 16 deletions(-)
 create mode 100644 include/linux/tagptr.h

diff --git a/fs/file.c b/fs/file.c
index 7ffd6e9..a54a551 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -727,42 +727,44 @@ struct file *fget_raw(unsigned int fd)
  * The fput_needed flag returned by fget_light should be passed to the
  * corresponding fput_light.
  */
-static unsigned long __fget_light(unsigned int fd, fmode_t mask)
+static fdtagptr_t __fget_light(unsigned int fd, fmode_t mask)
 {
+	const fdtagptr_t nil = tagptr_fold(fdtagptr_t, NULL, 0);
 	struct files_struct *files = current->files;
 	struct file *file;
 
 	if (atomic_read(&files->count) == 1) {
 		file = __fcheck_files(files, fd);
 		if (!file || unlikely(file->f_mode & mask))
-			return 0;
-		return (unsigned long)file;
+			return nil;
+		return tagptr_fold(fdtagptr_t, file, 0);
 	} else {
 		file = __fget(fd, mask);
 		if (!file)
-			return 0;
-		return FDPUT_FPUT | (unsigned long)file;
+			return nil;
+		return tagptr_fold(fdtagptr_t, file, FDPUT_FPUT);
 	}
 }
-unsigned long __fdget(unsigned int fd)
+
+fdtagptr_t __fdget(unsigned int fd)
 {
 	return __fget_light(fd, FMODE_PATH);
 }
 EXPORT_SYMBOL(__fdget);
 
-unsigned long __fdget_raw(unsigned int fd)
+fdtagptr_t __fdget_raw(unsigned int fd)
 {
 	return __fget_light(fd, 0);
 }
 
-unsigned long __fdget_pos(unsigned int fd)
+fdtagptr_t __fdget_pos(unsigned int fd)
 {
-	unsigned long v = __fdget(fd);
-	struct file *file = (struct file *)(v & ~3);
+	fdtagptr_t v = __fdget(fd);
+	struct file *file = tagptr_unfold_ptr(v);
 
 	if (file && (file->f_mode & FMODE_ATOMIC_POS)) {
 		if (file_count(file) > 1) {
-			v |= FDPUT_POS_UNLOCK;
+			tagptr_set_tags(&v, FDPUT_POS_UNLOCK);
 			mutex_lock(&file->f_pos_lock);
 		}
 	}
diff --git a/include/linux/file.h b/include/linux/file.h
index 279720d..38b6641 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -9,6 +9,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/posix_types.h>
+#include <linux/tagptr.h>
 
 struct file;
 
@@ -34,6 +35,9 @@ struct fd {
 #define FDPUT_FPUT       1
 #define FDPUT_POS_UNLOCK 2
 
+/* tagged pointer for fd */
+typedef tagptr2_t	fdtagptr_t;
+
 static inline void fdput(struct fd fd)
 {
 	if (fd.flags & FDPUT_FPUT)
@@ -42,14 +46,15 @@ static inline void fdput(struct fd fd)
 
 extern struct file *fget(unsigned int fd);
 extern struct file *fget_raw(unsigned int fd);
-extern unsigned long __fdget(unsigned int fd);
-extern unsigned long __fdget_raw(unsigned int fd);
-extern unsigned long __fdget_pos(unsigned int fd);
+extern fdtagptr_t __fdget(unsigned int fd);
+extern fdtagptr_t __fdget_raw(unsigned int fd);
+extern fdtagptr_t __fdget_pos(unsigned int fd);
 extern void __f_unlock_pos(struct file *);
 
-static inline struct fd __to_fd(unsigned long v)
+static inline struct fd __to_fd(fdtagptr_t v)
 {
-	return (struct fd){(struct file *)(v & ~3),v & 3};
+	return (struct fd){ tagptr_unfold_ptr(v),
+		tagptr_unfold_tags(v) };
 }
 
 static inline struct fd fdget(unsigned int fd)
diff --git a/include/linux/tagptr.h b/include/linux/tagptr.h
new file mode 100644
index 0000000..50d2f89
--- /dev/null
+++ b/include/linux/tagptr.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Tagged pointer implementation
+ *
+ * Copyright (C) 2018 Gao Xiang <gaoxiang25 at huawei.com>
+ */
+#ifndef _LINUX_TAGPTR_H
+#define _LINUX_TAGPTR_H
+
+#include <linux/types.h>
+#include <linux/build_bug.h>
+
+/* the name of types are tagptr{1, 2, 3...}_t */
+#define __MAKE_TAGPTR(n) \
+typedef struct tagptr##n {	\
+	uintptr_t v;	\
+} tagptr##n##_t;
+
+__MAKE_TAGPTR(1)
+__MAKE_TAGPTR(2)
+__MAKE_TAGPTR(3)
+__MAKE_TAGPTR(4)
+
+#undef __MAKE_TAGPTR
+
+extern void __compiletime_error("bad tagptr tags")
+	__bad_tagptr_tags(void);
+
+extern void __compiletime_error("bad tagptr type")
+	__bad_tagptr_type(void);
+
+#define __tagptr_mask_1(ptr, n)	\
+	__builtin_types_compatible_p(typeof(ptr), tagptr##n##_t) ? \
+		(1UL << (n)) - 1 :
+
+#define __tagptr_mask(ptr)	(\
+	__tagptr_mask_1(ptr, 1) ( \
+	__tagptr_mask_1(ptr, 2) ( \
+	__tagptr_mask_1(ptr, 3) ( \
+	__tagptr_mask_1(ptr, 4) ( \
+	__bad_tagptr_type(), 0)))))
+
+/* encode the tagged pointer */
+#define tagptr_fold(type, ptr, _tags) ({ \
+	const typeof(_tags) tags = (_tags); \
+	if (__builtin_constant_p(tags) && (tags & ~__tagptr_mask(type))) \
+		__bad_tagptr_tags(); \
+((typeof(type)){ .v = (uintptr_t)ptr | tags }); })
+
+#define tagptr_unfold_ptr(tptr) \
+	((void *)((tptr).v & ~__tagptr_mask(tptr)))
+
+#define tagptr_unfold_tags(tptr) \
+	((tptr).v & __tagptr_mask(tptr))
+
+#define tagptr_replace_tags(_ptptr, tags) ({ \
+	typeof(_ptptr) ptptr = (_ptptr); \
+	*ptptr = tagptr_fold(*ptptr, tagptr_unfold_ptr(*ptptr), tags); \
+*ptptr; })
+
+#define tagptr_set_tags(_ptptr, _tags) ({ \
+	typeof(_ptptr) ptptr = (_ptptr); \
+	const typeof(_tags) tags = (_tags); \
+	if (__builtin_constant_p(tags) && (tags & ~__tagptr_mask(*ptptr))) \
+		__bad_tagptr_tags(); \
+	ptptr->v |= tags; \
+*ptptr; })
+
+#define tagptr_clear_tags(_ptptr, _tags) ({ \
+	typeof(_ptptr) ptptr = (_ptptr); \
+	const typeof(_tags) tags = (_tags); \
+	if (__builtin_constant_p(tags) && (tags & ~__tagptr_mask(*ptptr))) \
+		__bad_tagptr_tags(); \
+	ptptr->v &= ~tags; \
+*ptptr; })
+
+#endif
+
-- 
1.9.1
