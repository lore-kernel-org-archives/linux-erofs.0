From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 19 Dec 2018 12:05:16 +0800
Subject: [PATCH 2/2] erofs-utils: let erofs-utils use shared libraries if it
 can
In-Reply-To: <20181219040516.21113-1-gaoxiang25@huawei.com>
References: <20181219040516.21113-1-gaoxiang25@huawei.com>
Message-ID: <20181219040516.21113-2-gaoxiang25@huawei.com>

As an option, add LDFLAGS=--static LIBS=-Wl,--static
in front of ./configure to force static compilation as before.

ex,
$ LDFLAGS=--static LIBS=-Wl,--static ./configure
$ make

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 Makefile.am | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index cef847d..4381d3d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -25,7 +25,6 @@ noinst_HEADERS = erofs_config.h  \
 				 mkfs_file.h
 
 mkfs_erofs_CFLAGS = -Wall -Werror -DEROFS_MKFS_VERSION=\"v1.0\"
-mkfs_erofs_LDFLAGS  = --static
 ACLOCAL_AMFLAGS = -I m4
 
 if SUPPORT_LARG_FILE_AT_BIT32
-- 
2.14.4
