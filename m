From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 29 Jul 2019 14:51:38 +0800
Subject: [PATCH 01/22] staging: erofs: update source file headers
In-Reply-To: <20190729065159.62378-1-gaoxiang25@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
Message-ID: <20190729065159.62378-2-gaoxiang25@huawei.com>

- Use the correct style for all SPDX License Identifiers;
- Get rid of the unnecessary license boilerplate;
- Use "GPL-2.0-only" instead of "GPL-2.0" suggested-by Stephen.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/Kconfig                      | 2 +-
 drivers/staging/erofs/Makefile                     | 2 +-
 drivers/staging/erofs/compress.h                   | 2 +-
 drivers/staging/erofs/data.c                       | 6 +-----
 drivers/staging/erofs/decompressor.c               | 2 +-
 drivers/staging/erofs/dir.c                        | 6 +-----
 drivers/staging/erofs/erofs_fs.h                   | 8 ++------
 drivers/staging/erofs/include/linux/tagptr.h       | 6 +++---
 drivers/staging/erofs/include/trace/events/erofs.h | 2 +-
 drivers/staging/erofs/inode.c                      | 6 +-----
 drivers/staging/erofs/internal.h                   | 8 ++------
 drivers/staging/erofs/namei.c                      | 6 +-----
 drivers/staging/erofs/super.c                      | 6 +-----
 drivers/staging/erofs/unzip_pagevec.h              | 8 ++------
 drivers/staging/erofs/unzip_vle.c                  | 6 +-----
 drivers/staging/erofs/unzip_vle.h                  | 8 ++------
 drivers/staging/erofs/utils.c                      | 7 +------
 drivers/staging/erofs/xattr.c                      | 6 +-----
 drivers/staging/erofs/xattr.h                      | 8 ++------
 drivers/staging/erofs/zmap.c                       | 2 +-
 20 files changed, 27 insertions(+), 80 deletions(-)

diff --git a/drivers/staging/erofs/Kconfig b/drivers/staging/erofs/Kconfig
index d04b798a8efb..2577cbb46a5b 100644
--- a/drivers/staging/erofs/Kconfig
+++ b/drivers/staging/erofs/Kconfig
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0
+# SPDX-License-Identifier: GPL-2.0-only
 
 config EROFS_FS
 	tristate "EROFS filesystem support"
diff --git a/drivers/staging/erofs/Makefile b/drivers/staging/erofs/Makefile
index e704d9e51514..3ade87e78d06 100644
--- a/drivers/staging/erofs/Makefile
+++ b/drivers/staging/erofs/Makefile
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0
+# SPDX-License-Identifier: GPL-2.0-only
 
 EROFS_VERSION = "1.0pre1"
 
diff --git a/drivers/staging/erofs/compress.h b/drivers/staging/erofs/compress.h
index c43aa3374d28..043013f9ef1b 100644
--- a/drivers/staging/erofs/compress.h
+++ b/drivers/staging/erofs/compress.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * linux/drivers/staging/erofs/compress.h
  *
diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index f73e4720cd3e..75b859e48084 100644
--- a/drivers/staging/erofs/data.c
+++ b/drivers/staging/erofs/data.c
@@ -1,14 +1,10 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * linux/drivers/staging/erofs/data.c
  *
  * Copyright (C) 2017-2018 HUAWEI, Inc.
  *             http://www.huawei.com/
  * Created by Gao Xiang <gaoxiang25 at huawei.com>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of the Linux
- * distribution for more details.
  */
 #include "internal.h"
 #include <linux/prefetch.h>
diff --git a/drivers/staging/erofs/decompressor.c b/drivers/staging/erofs/decompressor.c
index 1fb0abb98dff..b75524d0b322 100644
--- a/drivers/staging/erofs/decompressor.c
+++ b/drivers/staging/erofs/decompressor.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * linux/drivers/staging/erofs/decompressor.c
  *
diff --git a/drivers/staging/erofs/dir.c b/drivers/staging/erofs/dir.c
index dbf6a151886c..2fbfc4935077 100644
--- a/drivers/staging/erofs/dir.c
+++ b/drivers/staging/erofs/dir.c
@@ -1,14 +1,10 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * linux/drivers/staging/erofs/dir.c
  *
  * Copyright (C) 2017-2018 HUAWEI, Inc.
  *             http://www.huawei.com/
  * Created by Gao Xiang <gaoxiang25 at huawei.com>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of the Linux
- * distribution for more details.
  */
 #include "internal.h"
 
diff --git a/drivers/staging/erofs/erofs_fs.h b/drivers/staging/erofs/erofs_fs.h
index 9f61abb7c1ca..9cd749d56920 100644
--- a/drivers/staging/erofs/erofs_fs.h
+++ b/drivers/staging/erofs/erofs_fs.h
@@ -1,14 +1,10 @@
-/* SPDX-License-Identifier: GPL-2.0 OR Apache-2.0
- *
+/* SPDX-License-Identifier: GPL-2.0-only OR Apache-2.0 */
+/*
  * linux/drivers/staging/erofs/erofs_fs.h
  *
  * Copyright (C) 2017-2018 HUAWEI, Inc.
  *             http://www.huawei.com/
  * Created by Gao Xiang <gaoxiang25 at huawei.com>
- *
- * This file is dual-licensed; you may select either the GNU General Public
- * License version 2 or Apache License, Version 2.0. See the file COPYING
- * in the main directory of the Linux distribution for more details.
  */
 #ifndef __EROFS_FS_H
 #define __EROFS_FS_H
diff --git a/drivers/staging/erofs/include/linux/tagptr.h b/drivers/staging/erofs/include/linux/tagptr.h
index ccd106dbd48e..b3f13773fb99 100644
--- a/drivers/staging/erofs/include/linux/tagptr.h
+++ b/drivers/staging/erofs/include/linux/tagptr.h
@@ -1,6 +1,6 @@
-/* SPDX-License-Identifier: GPL-2.0
- *
- * Tagged pointer implementation
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * A tagged pointer implementation
  *
  * Copyright (C) 2018 Gao Xiang <gaoxiang25 at huawei.com>
  */
diff --git a/drivers/staging/erofs/include/trace/events/erofs.h b/drivers/staging/erofs/include/trace/events/erofs.h
index 660c92fc1803..bfb2da9c4eee 100644
--- a/drivers/staging/erofs/include/trace/events/erofs.h
+++ b/drivers/staging/erofs/include/trace/events/erofs.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+/* SPDX-License-Identifier: GPL-2.0-only */
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM erofs
 
diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index 4c3d8bf8d249..c13d66ccc74a 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -1,14 +1,10 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * linux/drivers/staging/erofs/inode.c
  *
  * Copyright (C) 2017-2018 HUAWEI, Inc.
  *             http://www.huawei.com/
  * Created by Gao Xiang <gaoxiang25 at huawei.com>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of the Linux
- * distribution for more details.
  */
 #include "xattr.h"
 
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 0ebc294120c2..501429ec0f91 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -1,14 +1,10 @@
-/* SPDX-License-Identifier: GPL-2.0
- *
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
  * linux/drivers/staging/erofs/internal.h
  *
  * Copyright (C) 2017-2018 HUAWEI, Inc.
  *             http://www.huawei.com/
  * Created by Gao Xiang <gaoxiang25 at huawei.com>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of the Linux
- * distribution for more details.
  */
 #ifndef __INTERNAL_H
 #define __INTERNAL_H
diff --git a/drivers/staging/erofs/namei.c b/drivers/staging/erofs/namei.c
index fd3ae78d0ba5..50816b4c05fc 100644
--- a/drivers/staging/erofs/namei.c
+++ b/drivers/staging/erofs/namei.c
@@ -1,14 +1,10 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * linux/drivers/staging/erofs/namei.c
  *
  * Copyright (C) 2017-2018 HUAWEI, Inc.
  *             http://www.huawei.com/
  * Created by Gao Xiang <gaoxiang25 at huawei.com>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of the Linux
- * distribution for more details.
  */
 #include "internal.h"
 #include "xattr.h"
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 3e2a65ba1945..38cd7a59750a 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -1,14 +1,10 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * linux/drivers/staging/erofs/super.c
  *
  * Copyright (C) 2017-2018 HUAWEI, Inc.
  *             http://www.huawei.com/
  * Created by Gao Xiang <gaoxiang25 at huawei.com>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of the Linux
- * distribution for more details.
  */
 #include <linux/module.h>
 #include <linux/buffer_head.h>
diff --git a/drivers/staging/erofs/unzip_pagevec.h b/drivers/staging/erofs/unzip_pagevec.h
index e65dbca93ae8..f07302c3c3f5 100644
--- a/drivers/staging/erofs/unzip_pagevec.h
+++ b/drivers/staging/erofs/unzip_pagevec.h
@@ -1,14 +1,10 @@
-/* SPDX-License-Identifier: GPL-2.0
- *
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
  * linux/drivers/staging/erofs/unzip_pagevec.h
  *
  * Copyright (C) 2018 HUAWEI, Inc.
  *             http://www.huawei.com/
  * Created by Gao Xiang <gaoxiang25 at huawei.com>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of the Linux
- * distribution for more details.
  */
 #ifndef __EROFS_UNZIP_PAGEVEC_H
 #define __EROFS_UNZIP_PAGEVEC_H
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 56c009cf611e..28a98e79c1e9 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1,14 +1,10 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * linux/drivers/staging/erofs/unzip_vle.c
  *
  * Copyright (C) 2018 HUAWEI, Inc.
  *             http://www.huawei.com/
  * Created by Gao Xiang <gaoxiang25 at huawei.com>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of the Linux
- * distribution for more details.
  */
 #include "unzip_vle.h"
 #include "compress.h"
diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/unzip_vle.h
index df91ad149439..d92515cd1c06 100644
--- a/drivers/staging/erofs/unzip_vle.h
+++ b/drivers/staging/erofs/unzip_vle.h
@@ -1,14 +1,10 @@
-/* SPDX-License-Identifier: GPL-2.0
- *
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
  * linux/drivers/staging/erofs/unzip_vle.h
  *
  * Copyright (C) 2018 HUAWEI, Inc.
  *             http://www.huawei.com/
  * Created by Gao Xiang <gaoxiang25 at huawei.com>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of the Linux
- * distribution for more details.
  */
 #ifndef __EROFS_FS_UNZIP_VLE_H
 #define __EROFS_FS_UNZIP_VLE_H
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index 4bbd3bf34acd..a68dbe375fa0 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -1,16 +1,11 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * linux/drivers/staging/erofs/utils.c
  *
  * Copyright (C) 2018 HUAWEI, Inc.
  *             http://www.huawei.com/
  * Created by Gao Xiang <gaoxiang25 at huawei.com>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of the Linux
- * distribution for more details.
  */
-
 #include "internal.h"
 #include <linux/pagevec.h>
 
diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
index df40654b9fbb..b29177a17347 100644
--- a/drivers/staging/erofs/xattr.c
+++ b/drivers/staging/erofs/xattr.c
@@ -1,14 +1,10 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * linux/drivers/staging/erofs/xattr.c
  *
  * Copyright (C) 2017-2018 HUAWEI, Inc.
  *             http://www.huawei.com/
  * Created by Gao Xiang <gaoxiang25 at huawei.com>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of the Linux
- * distribution for more details.
  */
 #include <linux/security.h>
 #include "xattr.h"
diff --git a/drivers/staging/erofs/xattr.h b/drivers/staging/erofs/xattr.h
index 3990805dfc6c..fbcd57bdf886 100644
--- a/drivers/staging/erofs/xattr.h
+++ b/drivers/staging/erofs/xattr.h
@@ -1,14 +1,10 @@
-/* SPDX-License-Identifier: GPL-2.0
- *
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
  * linux/drivers/staging/erofs/xattr.h
  *
  * Copyright (C) 2017-2018 HUAWEI, Inc.
  *             http://www.huawei.com/
  * Created by Gao Xiang <gaoxiang25 at huawei.com>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of the Linux
- * distribution for more details.
  */
 #ifndef __EROFS_XATTR_H
 #define __EROFS_XATTR_H
diff --git a/drivers/staging/erofs/zmap.c b/drivers/staging/erofs/zmap.c
index 9c0bd65c46bf..205e884ca4e0 100644
--- a/drivers/staging/erofs/zmap.c
+++ b/drivers/staging/erofs/zmap.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * linux/drivers/staging/erofs/zmap.c
  *
-- 
2.17.1
