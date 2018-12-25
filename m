From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 25 Dec 2018 14:07:43 +0800
Subject: [PATCH 1/2] erofs-utils: move list_head.h to include/erofs
Message-ID: <20181225060744.31239-1-gaoxiang25@huawei.com>

In order to avoid name conficts, move it to
the sub-directory instead and rename to list.h.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 include/{list_head.h => erofs/list.h} | 6 +++---
 mkfs/erofs_cache.h                    | 2 +-
 mkfs/mkfs_erofs.h                     | 2 +-
 mkfs/mkfs_file.c                      | 2 +-
 mkfs/mkfs_file.h                      | 2 +-
 mkfs/mkfs_inode.h                     | 2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)
 rename include/{list_head.h => erofs/list.h} (97%)

diff --git a/include/list_head.h b/include/erofs/list.h
similarity index 97%
rename from include/list_head.h
rename to include/erofs/list.h
index adbf561..8dcbc5b 100644
--- a/include/list_head.h
+++ b/include/erofs/list.h
@@ -1,13 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * list_head.h
+ * include/erofs/list.h
  *
  * Copyright (C) 2018 HUAWEI, Inc.
  *             http://www.huawei.com/
  * Created by Li Guifu <bluce.liguifu at huawei.com>
  */
-#ifndef __CONFIG_LIST_H
-#define __CONFIG_LIST_H
+#ifndef __EROFS_LIST_HEAD_H
+#define __EROFS_LIST_HEAD_H
 
 #include <assert.h>
 #include <stddef.h>
diff --git a/mkfs/erofs_cache.h b/mkfs/erofs_cache.h
index ca0702a..989853b 100644
--- a/mkfs/erofs_cache.h
+++ b/mkfs/erofs_cache.h
@@ -9,7 +9,7 @@
 #ifndef __EROFS_CACHE_H__
 #define __EROFS_CACHE_H__
 #include "mkfs_erofs.h"
-#include "list_head.h"
+#include <erofs/list.h>
 
 enum erofs_meta_type {
 	EROFS_META_INODE,
diff --git a/mkfs/mkfs_erofs.h b/mkfs/mkfs_erofs.h
index 7fdc4c5..26f891c 100644
--- a/mkfs/mkfs_erofs.h
+++ b/mkfs/mkfs_erofs.h
@@ -11,7 +11,7 @@
 #define __EROFS_MKFS_H
 
 #include <linux/limits.h>
-#include "list_head.h"
+#include <erofs/list.h>
 #include "erofs_types.h"
 
 typedef unsigned int __u32;
diff --git a/mkfs/mkfs_file.c b/mkfs/mkfs_file.c
index 9aa62e2..bb9877e 100644
--- a/mkfs/mkfs_file.c
+++ b/mkfs/mkfs_file.c
@@ -28,7 +28,7 @@
 #define O_BINARY 0
 #endif
 #include "erofs_types.h"
-#include "list_head.h"
+#include <erofs/list.h>
 #include "erofs_cache.h"
 #include "erofs_compressor.h"
 
diff --git a/mkfs/mkfs_file.h b/mkfs/mkfs_file.h
index 3b23d00..852e92f 100644
--- a/mkfs/mkfs_file.h
+++ b/mkfs/mkfs_file.h
@@ -14,7 +14,7 @@
 #include <sys/types.h>
 #include <stdio.h>
 #include <unistd.h>
-#include "list_head.h"
+#include <erofs/list.h>
 #include "mkfs_erofs.h"
 
 #define FILE_TYPE_NONE (0)
diff --git a/mkfs/mkfs_inode.h b/mkfs/mkfs_inode.h
index 100e788..8a9b81e 100644
--- a/mkfs/mkfs_inode.h
+++ b/mkfs/mkfs_inode.h
@@ -9,7 +9,7 @@
 #ifndef CONFIG_EROFS_MKFS_INODE_H
 #define CONFIG_EROFS_MKFS_INODE_H
 
-#include "list_head.h"
+#include <erofs/list.h>
 #include "erofs_cache.h"
 #include "mkfs_file.h"
 
-- 
2.14.4
