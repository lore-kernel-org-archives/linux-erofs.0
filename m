From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 19 Dec 2018 12:38:42 +0800
Subject: [PATCH v2 3/5] erofs-utils: silence `Consider adding
 'AC_CONFIG_MACRO_DIRS([m4])' to configure.ac'
In-Reply-To: <20181219043844.43451-1-gaoxiang25@huawei.com>
References: <20181219040516.21113-1-gaoxiang25@huawei.com>
 <20181219043844.43451-1-gaoxiang25@huawei.com>
Message-ID: <20181219043844.43451-3-gaoxiang25@huawei.com>

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 configure.ac | 1 +
 1 file changed, 1 insertion(+)

diff --git a/configure.ac b/configure.ac
index 4529576..858ae25 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,6 +3,7 @@
 
 AC_PREREQ([2.69])
 AC_INIT([mkfs.erofs], [0.0.1], [bluce.liguifu at huawei.com])
+AC_CONFIG_MACRO_DIR([m4])
 AM_INIT_AUTOMAKE([foreign -Wall -Werror])
 AC_CONFIG_SRCDIR([mkfs_main.c])
 AC_CONFIG_HEADERS([config.h])
-- 
2.14.4
