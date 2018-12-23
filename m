From: blucerlee@gmail.com (Li Guifu)
Date: Sun, 23 Dec 2018 05:02:02 -0800
Subject: [PATCH] erofs-utils: fix the source code hierarchy
Message-ID: <20181223130202.68742-1-blucerlee@gmail.com>

1. move generic header files, erofs_fs.h and list_head.h, into include/
2. move the other mkfs source files into mkfs/

Signed-off-by: Li Guifu <blucerlee at gmail.com>
---
 Makefile.am                                   | 32 +------------------
 configure.ac                                  |  5 +--
 erofs_fs.h => include/erofs_fs.h              |  0
 list_head.h => include/list_head.h            |  0
 mkfs/Makefile.am                              | 31 ++++++++++++++++++
 erofs_cache.c => mkfs/erofs_cache.c           |  0
 erofs_cache.h => mkfs/erofs_cache.h           |  0
 erofs_compressor.c => mkfs/erofs_compressor.c |  0
 erofs_compressor.h => mkfs/erofs_compressor.h |  0
 erofs_config.c => mkfs/erofs_config.c         |  0
 erofs_config.h => mkfs/erofs_config.h         |  0
 erofs_debug.h => mkfs/erofs_debug.h           |  0
 erofs_error.h => mkfs/erofs_error.h           |  0
 erofs_io.c => mkfs/erofs_io.c                 |  0
 erofs_io.h => mkfs/erofs_io.h                 |  0
 erofs_lz4hc.c => mkfs/erofs_lz4hc.c           |  0
 erofs_lz4hc.h => mkfs/erofs_lz4hc.h           |  0
 erofs_types.h => mkfs/erofs_types.h           |  0
 mkfs_erofs.h => mkfs/mkfs_erofs.h             |  0
 mkfs_file.c => mkfs/mkfs_file.c               |  0
 mkfs_file.h => mkfs/mkfs_file.h               |  0
 mkfs_inode.c => mkfs/mkfs_inode.c             |  0
 mkfs_inode.h => mkfs/mkfs_inode.h             |  0
 mkfs_main.c => mkfs/mkfs_main.c               |  0
 24 files changed, 35 insertions(+), 33 deletions(-)
 rename erofs_fs.h => include/erofs_fs.h (100%)
 rename list_head.h => include/list_head.h (100%)
 create mode 100644 mkfs/Makefile.am
 rename erofs_cache.c => mkfs/erofs_cache.c (100%)
 rename erofs_cache.h => mkfs/erofs_cache.h (100%)
 rename erofs_compressor.c => mkfs/erofs_compressor.c (100%)
 rename erofs_compressor.h => mkfs/erofs_compressor.h (100%)
 rename erofs_config.c => mkfs/erofs_config.c (100%)
 rename erofs_config.h => mkfs/erofs_config.h (100%)
 rename erofs_debug.h => mkfs/erofs_debug.h (100%)
 rename erofs_error.h => mkfs/erofs_error.h (100%)
 rename erofs_io.c => mkfs/erofs_io.c (100%)
 rename erofs_io.h => mkfs/erofs_io.h (100%)
 rename erofs_lz4hc.c => mkfs/erofs_lz4hc.c (100%)
 rename erofs_lz4hc.h => mkfs/erofs_lz4hc.h (100%)
 rename erofs_types.h => mkfs/erofs_types.h (100%)
 rename mkfs_erofs.h => mkfs/mkfs_erofs.h (100%)
 rename mkfs_file.c => mkfs/mkfs_file.c (100%)
 rename mkfs_file.h => mkfs/mkfs_file.h (100%)
 rename mkfs_inode.c => mkfs/mkfs_inode.c (100%)
 rename mkfs_inode.h => mkfs/mkfs_inode.h (100%)
 rename mkfs_main.c => mkfs/mkfs_main.c (100%)

diff --git a/Makefile.am b/Makefile.am
index 4381d3d..cb574c3 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,33 +1,3 @@
 # Makefile.am
-AUTOMAKE_OPTIONS = foreign
-bin_PROGRAMS     = mkfs.erofs
-mkfs_erofs_SOURCES = erofs_compressor.c \
-					 mkfs_file.c \
-					 erofs_lz4hc.c \
-					 mkfs_main.c \
-					 erofs_cache.c \
-					 erofs_io.c \
-					 mkfs_inode.c \
-					 erofs_config.c
-
-noinst_HEADERS = erofs_config.h  \
-				 mkfs_inode.h \
-				 erofs_error.h \
-				 erofs_lz4hc.h \
-				 list_head.h \
-				 erofs_cache.h \
-				 erofs_fs.h \
-				 erofs_debug.h \
-				 mkfs_erofs.h \
-				 erofs_compressor.h \
-				 erofs_io.h \
-				 erofs_types.h \
-				 mkfs_file.h
-
-mkfs_erofs_CFLAGS = -Wall -Werror -DEROFS_MKFS_VERSION=\"v1.0\"
-ACLOCAL_AMFLAGS = -I m4
-
-if SUPPORT_LARG_FILE_AT_BIT32
-    mkfs_erofs_CFLAGS += -D_FILE_OFFSET_BITS=64
-endif
 
+SUBDIRS=mkfs
diff --git a/configure.ac b/configure.ac
index 345e8ba..524252f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -6,7 +6,7 @@ AC_INIT([mkfs.erofs], [0.0.1], [bluce.liguifu at huawei.com])
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_AUX_DIR(config)
 AM_INIT_AUTOMAKE([foreign -Wall -Werror])
-AC_CONFIG_SRCDIR([mkfs_main.c])
+AC_CONFIG_SRCDIR([mkfs/mkfs_main.c])
 AC_CONFIG_HEADERS([config.h])
 
 # Checks for programs.
@@ -98,5 +98,6 @@ if test "x${have_lz4}" = "x0" ; then
   AC_MSG_ERROR([Cannot build without lz4])
 fi
 
-AC_CONFIG_FILES([Makefile])
+AC_CONFIG_FILES([Makefile
+		 mkfs/Makefile])
 AC_OUTPUT
diff --git a/erofs_fs.h b/include/erofs_fs.h
similarity index 100%
rename from erofs_fs.h
rename to include/erofs_fs.h
diff --git a/list_head.h b/include/list_head.h
similarity index 100%
rename from list_head.h
rename to include/list_head.h
diff --git a/mkfs/Makefile.am b/mkfs/Makefile.am
new file mode 100644
index 0000000..a9240e4
--- /dev/null
+++ b/mkfs/Makefile.am
@@ -0,0 +1,31 @@
+## Makefile.am
+AUTOMAKE_OPTIONS = foreign
+bin_PROGRAMS     = mkfs.erofs
+mkfs_erofs_SOURCES = erofs_compressor.c \
+					 mkfs_file.c \
+					 erofs_lz4hc.c \
+					 mkfs_main.c \
+					 erofs_cache.c \
+					 erofs_io.c \
+					 mkfs_inode.c \
+					 erofs_config.c
+
+noinst_HEADERS = erofs_config.h  \
+				 mkfs_inode.h \
+				 erofs_error.h \
+				 erofs_lz4hc.h \
+				 erofs_cache.h \
+				 erofs_debug.h \
+				 mkfs_erofs.h \
+				 erofs_compressor.h \
+				 erofs_io.h \
+				 erofs_types.h \
+				 mkfs_file.h
+
+mkfs_erofs_CFLAGS = -Wall -Werror -DEROFS_MKFS_VERSION=\"v1.0\" -I$(top_srcdir)/include
+ACLOCAL_AMFLAGS = -I m4
+
+if SUPPORT_LARG_FILE_AT_BIT32
+    mkfs_erofs_CFLAGS += -D_FILE_OFFSET_BITS=64
+endif
+
diff --git a/erofs_cache.c b/mkfs/erofs_cache.c
similarity index 100%
rename from erofs_cache.c
rename to mkfs/erofs_cache.c
diff --git a/erofs_cache.h b/mkfs/erofs_cache.h
similarity index 100%
rename from erofs_cache.h
rename to mkfs/erofs_cache.h
diff --git a/erofs_compressor.c b/mkfs/erofs_compressor.c
similarity index 100%
rename from erofs_compressor.c
rename to mkfs/erofs_compressor.c
diff --git a/erofs_compressor.h b/mkfs/erofs_compressor.h
similarity index 100%
rename from erofs_compressor.h
rename to mkfs/erofs_compressor.h
diff --git a/erofs_config.c b/mkfs/erofs_config.c
similarity index 100%
rename from erofs_config.c
rename to mkfs/erofs_config.c
diff --git a/erofs_config.h b/mkfs/erofs_config.h
similarity index 100%
rename from erofs_config.h
rename to mkfs/erofs_config.h
diff --git a/erofs_debug.h b/mkfs/erofs_debug.h
similarity index 100%
rename from erofs_debug.h
rename to mkfs/erofs_debug.h
diff --git a/erofs_error.h b/mkfs/erofs_error.h
similarity index 100%
rename from erofs_error.h
rename to mkfs/erofs_error.h
diff --git a/erofs_io.c b/mkfs/erofs_io.c
similarity index 100%
rename from erofs_io.c
rename to mkfs/erofs_io.c
diff --git a/erofs_io.h b/mkfs/erofs_io.h
similarity index 100%
rename from erofs_io.h
rename to mkfs/erofs_io.h
diff --git a/erofs_lz4hc.c b/mkfs/erofs_lz4hc.c
similarity index 100%
rename from erofs_lz4hc.c
rename to mkfs/erofs_lz4hc.c
diff --git a/erofs_lz4hc.h b/mkfs/erofs_lz4hc.h
similarity index 100%
rename from erofs_lz4hc.h
rename to mkfs/erofs_lz4hc.h
diff --git a/erofs_types.h b/mkfs/erofs_types.h
similarity index 100%
rename from erofs_types.h
rename to mkfs/erofs_types.h
diff --git a/mkfs_erofs.h b/mkfs/mkfs_erofs.h
similarity index 100%
rename from mkfs_erofs.h
rename to mkfs/mkfs_erofs.h
diff --git a/mkfs_file.c b/mkfs/mkfs_file.c
similarity index 100%
rename from mkfs_file.c
rename to mkfs/mkfs_file.c
diff --git a/mkfs_file.h b/mkfs/mkfs_file.h
similarity index 100%
rename from mkfs_file.h
rename to mkfs/mkfs_file.h
diff --git a/mkfs_inode.c b/mkfs/mkfs_inode.c
similarity index 100%
rename from mkfs_inode.c
rename to mkfs/mkfs_inode.c
diff --git a/mkfs_inode.h b/mkfs/mkfs_inode.h
similarity index 100%
rename from mkfs_inode.h
rename to mkfs/mkfs_inode.h
diff --git a/mkfs_main.c b/mkfs/mkfs_main.c
similarity index 100%
rename from mkfs_main.c
rename to mkfs/mkfs_main.c
-- 
2.17.1
