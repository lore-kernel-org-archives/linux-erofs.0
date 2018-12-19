From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 19 Dec 2018 12:38:44 +0800
Subject: [PATCH v2 5/5] erofs-utils: add AC_CONFIG_AUX_DIR(config)
In-Reply-To: <20181219043844.43451-1-gaoxiang25@huawei.com>
References: <20181219040516.21113-1-gaoxiang25@huawei.com>
 <20181219043844.43451-1-gaoxiang25@huawei.com>
Message-ID: <20181219043844.43451-5-gaoxiang25@huawei.com>

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 .gitignore   | 9 +--------
 configure.ac | 1 +
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/.gitignore b/.gitignore
index 7e0a1cf..3cebe03 100644
--- a/.gitignore
+++ b/.gitignore
@@ -28,17 +28,10 @@ TAGS
 .deps/
 Makefile.in
 aclocal.m4
-compile
-config.guess
 config.h
 config.h.in
-config.sub
 configure
-depcomp
-install-sh
 libtool
-ltmain.sh
 m4/
-missing
 stamp-h1
-
+config/
diff --git a/configure.ac b/configure.ac
index 858ae25..345e8ba 100644
--- a/configure.ac
+++ b/configure.ac
@@ -4,6 +4,7 @@
 AC_PREREQ([2.69])
 AC_INIT([mkfs.erofs], [0.0.1], [bluce.liguifu at huawei.com])
 AC_CONFIG_MACRO_DIR([m4])
+AC_CONFIG_AUX_DIR(config)
 AM_INIT_AUTOMAKE([foreign -Wall -Werror])
 AC_CONFIG_SRCDIR([mkfs_main.c])
 AC_CONFIG_HEADERS([config.h])
-- 
2.14.4
