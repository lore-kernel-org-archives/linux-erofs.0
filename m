From: hsiangkao@aol.com (Gao Xiang)
Date: Fri, 11 Jan 2019 21:28:36 +0800
Subject: [PATCH 2/2] erofs-utils: move 'ACLOCAL_AMFLAGS = -I m4' to
 $(top_srcdir)/Makefile.am
In-Reply-To: <20190111132836.16001-1-hsiangkao@aol.com>
References: <20190111132836.16001-1-hsiangkao@aol.com>
Message-ID: <20190111132836.16001-2-hsiangkao@aol.com>

Signed-off-by: Gao Xiang <hsiangkao at aol.com>
---
 Makefile.am      | 2 ++
 mkfs/Makefile.am | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index cb574c3..0eb37d6 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,3 +1,5 @@
 # Makefile.am
 
+ACLOCAL_AMFLAGS = -I m4
+
 SUBDIRS=mkfs
diff --git a/mkfs/Makefile.am b/mkfs/Makefile.am
index 9865f04..0f57761 100644
--- a/mkfs/Makefile.am
+++ b/mkfs/Makefile.am
@@ -22,7 +22,6 @@ noinst_HEADERS = erofs_config.h  \
 		 mkfs_file.h
 
 mkfs_erofs_CFLAGS = -Wall -Werror -I$(top_srcdir)/include
-ACLOCAL_AMFLAGS = -I m4
 
 if SUPPORT_LARG_FILE_AT_BIT32
     mkfs_erofs_CFLAGS += -D_FILE_OFFSET_BITS=64
-- 
2.11.0
