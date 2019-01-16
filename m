From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 16 Jan 2019 13:53:54 +0800
Subject: [PATCH] erofs-utils: rename the package name to erofs-utils
Message-ID: <20190116055354.34357-1-gaoxiang25@huawei.com>

mkfs.erofs is a part of erofs-utils, thus
it isn't suitable for the package name.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 74ad0c0..8e3f703 100644
--- a/configure.ac
+++ b/configure.ac
@@ -2,7 +2,7 @@
 # Process this file with autoconf to produce a configure script.
 
 AC_PREREQ([2.69])
-AC_INIT([mkfs.erofs], [0.1], [bluce.liguifu at huawei.com])
+AC_INIT([erofs-utils], [0.1], [bluce.liguifu at huawei.com])
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_AUX_DIR(config)
 AM_INIT_AUTOMAKE([foreign -Wall -Werror])
-- 
2.14.4
