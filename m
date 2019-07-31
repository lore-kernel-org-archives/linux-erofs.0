From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 31 Jul 2019 23:57:32 +0800
Subject: [PATCH v2 02/22] staging: erofs: rename source files for better
 understanding
In-Reply-To: <20190731155752.210602-1-gaoxiang25@huawei.com>
References: <20190731155752.210602-1-gaoxiang25@huawei.com>
Message-ID: <20190731155752.210602-3-gaoxiang25@huawei.com>

Keep in line with erofs-outofstaging patchset as well, see
https://lore.kernel.org/linux-fsdevel/20190725095658.155779-1-gaoxiang25 at huawei.com/

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/Makefile                     | 2 +-
 drivers/staging/erofs/{include/linux => }/tagptr.h | 6 +++---
 drivers/staging/erofs/{unzip_vle.c => zdata.c}     | 4 ++--
 drivers/staging/erofs/{unzip_vle.h => zdata.h}     | 8 ++++----
 drivers/staging/erofs/{unzip_pagevec.h => zpvec.h} | 8 ++++----
 5 files changed, 14 insertions(+), 14 deletions(-)
 rename drivers/staging/erofs/{include/linux => }/tagptr.h (97%)
 rename drivers/staging/erofs/{unzip_vle.c => zdata.c} (99%)
 rename drivers/staging/erofs/{unzip_vle.h => zdata.h} (97%)
 rename drivers/staging/erofs/{unzip_pagevec.h => zpvec.h} (96%)

diff --git a/drivers/staging/erofs/Makefile b/drivers/staging/erofs/Makefile
index 3ade87e78d06..5cdae21cb5af 100644
--- a/drivers/staging/erofs/Makefile
+++ b/drivers/staging/erofs/Makefile
@@ -9,5 +9,5 @@ obj-$(CONFIG_EROFS_FS) += erofs.o
 ccflags-y += -I $(srctree)/$(src)/include
 erofs-objs := super.o inode.o data.o namei.o dir.o utils.o
 erofs-$(CONFIG_EROFS_FS_XATTR) += xattr.o
-erofs-$(CONFIG_EROFS_FS_ZIP) += unzip_vle.o zmap.o decompressor.o
+erofs-$(CONFIG_EROFS_FS_ZIP) += decompressor.o zmap.o zdata.o
 
diff --git a/drivers/staging/erofs/include/linux/tagptr.h b/drivers/staging/erofs/tagptr.h
similarity index 97%
rename from drivers/staging/erofs/include/linux/tagptr.h
rename to drivers/staging/erofs/tagptr.h
index b3f13773fb99..a72897c86744 100644
--- a/drivers/staging/erofs/include/linux/tagptr.h
+++ b/drivers/staging/erofs/tagptr.h
@@ -4,8 +4,8 @@
  *
  * Copyright (C) 2018 Gao Xiang <gaoxiang25 at huawei.com>
  */
-#ifndef _LINUX_TAGPTR_H
-#define _LINUX_TAGPTR_H
+#ifndef __EROFS_FS_TAGPTR_H
+#define __EROFS_FS_TAGPTR_H
 
 #include <linux/types.h>
 #include <linux/build_bug.h>
@@ -106,5 +106,5 @@ tagptr_init(o, cmpxchg(&ptptr->v, o.v, n.v)); })
 	ptptr->v &= ~tags; \
 *ptptr; })
 
-#endif
+#endif	/* __EROFS_FS_TAGPTR_H */
 
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/zdata.c
similarity index 99%
rename from drivers/staging/erofs/unzip_vle.c
rename to drivers/staging/erofs/zdata.c
index 28a98e79c1e9..f7667628bbf1 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/zdata.c
@@ -1,12 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * linux/drivers/staging/erofs/unzip_vle.c
+ * linux/drivers/staging/erofs/zdata.c
  *
  * Copyright (C) 2018 HUAWEI, Inc.
  *             http://www.huawei.com/
  * Created by Gao Xiang <gaoxiang25 at huawei.com>
  */
-#include "unzip_vle.h"
+#include "zdata.h"
 #include "compress.h"
 #include <linux/prefetch.h>
 
diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/zdata.h
similarity index 97%
rename from drivers/staging/erofs/unzip_vle.h
rename to drivers/staging/erofs/zdata.h
index d92515cd1c06..8d0119d697da 100644
--- a/drivers/staging/erofs/unzip_vle.h
+++ b/drivers/staging/erofs/zdata.h
@@ -1,16 +1,16 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * linux/drivers/staging/erofs/unzip_vle.h
+ * linux/drivers/staging/erofs/zdata.h
  *
  * Copyright (C) 2018 HUAWEI, Inc.
  *             http://www.huawei.com/
  * Created by Gao Xiang <gaoxiang25 at huawei.com>
  */
-#ifndef __EROFS_FS_UNZIP_VLE_H
-#define __EROFS_FS_UNZIP_VLE_H
+#ifndef __EROFS_FS_ZDATA_H
+#define __EROFS_FS_ZDATA_H
 
 #include "internal.h"
-#include "unzip_pagevec.h"
+#include "zpvec.h"
 
 #define Z_EROFS_NR_INLINE_PAGEVECS      3
 
diff --git a/drivers/staging/erofs/unzip_pagevec.h b/drivers/staging/erofs/zpvec.h
similarity index 96%
rename from drivers/staging/erofs/unzip_pagevec.h
rename to drivers/staging/erofs/zpvec.h
index f07302c3c3f5..77bf6877bad8 100644
--- a/drivers/staging/erofs/unzip_pagevec.h
+++ b/drivers/staging/erofs/zpvec.h
@@ -1,15 +1,15 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * linux/drivers/staging/erofs/unzip_pagevec.h
+ * linux/drivers/staging/erofs/zpvec.h
  *
  * Copyright (C) 2018 HUAWEI, Inc.
  *             http://www.huawei.com/
  * Created by Gao Xiang <gaoxiang25 at huawei.com>
  */
-#ifndef __EROFS_UNZIP_PAGEVEC_H
-#define __EROFS_UNZIP_PAGEVEC_H
+#ifndef __EROFS_FS_ZPVEC_H
+#define __EROFS_FS_ZPVEC_H
 
-#include <linux/tagptr.h>
+#include "tagptr.h"
 
 /* page type in pagevec for unzip subsystem */
 enum z_erofs_page_type {
-- 
2.17.1
