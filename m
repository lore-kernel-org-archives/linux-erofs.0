From: bluce.liguifu@huawei.com (Li Guifu)
Date: Mon, 24 Dec 2018 18:28:50 +0800
Subject: [PATCH] erofs-utils: fix tab algin to 8 spaces in the Makefile.am
Message-ID: <20181224102850.11967-1-bluce.liguifu@huawei.com>

The tab isnot 8 spaces in the Makefile.am, one line has
been exceed 80 spaces, fix them.

Signed-off-by: Li Guifu <bluce.liguifu at huawei.com>
---
 mkfs/Makefile.am | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/mkfs/Makefile.am b/mkfs/Makefile.am
index a9240e4..4933069 100644
--- a/mkfs/Makefile.am
+++ b/mkfs/Makefile.am
@@ -2,27 +2,28 @@
 AUTOMAKE_OPTIONS = foreign
 bin_PROGRAMS     = mkfs.erofs
 mkfs_erofs_SOURCES = erofs_compressor.c \
-					 mkfs_file.c \
-					 erofs_lz4hc.c \
-					 mkfs_main.c \
-					 erofs_cache.c \
-					 erofs_io.c \
-					 mkfs_inode.c \
-					 erofs_config.c
+		     mkfs_file.c \
+		     erofs_lz4hc.c \
+		     mkfs_main.c \
+		     erofs_cache.c \
+		     erofs_io.c \
+		     mkfs_inode.c \
+		     erofs_config.c
 
 noinst_HEADERS = erofs_config.h  \
-				 mkfs_inode.h \
-				 erofs_error.h \
-				 erofs_lz4hc.h \
-				 erofs_cache.h \
-				 erofs_debug.h \
-				 mkfs_erofs.h \
-				 erofs_compressor.h \
-				 erofs_io.h \
-				 erofs_types.h \
-				 mkfs_file.h
+		 mkfs_inode.h \
+		 erofs_error.h \
+		 erofs_lz4hc.h \
+		 erofs_cache.h \
+		 erofs_debug.h \
+		 mkfs_erofs.h \
+		 erofs_compressor.h \
+		 erofs_io.h \
+		 erofs_types.h \
+		 mkfs_file.h
 
-mkfs_erofs_CFLAGS = -Wall -Werror -DEROFS_MKFS_VERSION=\"v1.0\" -I$(top_srcdir)/include
+mkfs_erofs_CFLAGS = -Wall -Werror -DEROFS_MKFS_VERSION=\"v1.0\" \
+		    -I$(top_srcdir)/include
 ACLOCAL_AMFLAGS = -I m4
 
 if SUPPORT_LARG_FILE_AT_BIT32
-- 
2.17.1
