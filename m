From: yamada.masahiro@socionext.com (Masahiro Yamada)
Date: Wed, 15 May 2019 13:31:22 +0900
Subject: [PATCH] staging: erofs: drop unneeded -Wall addition
Message-ID: <20190515043123.9106-1-yamada.masahiro@socionext.com>

The top level Makefile adds -Wall globally:

  KBUILD_CFLAGS   := -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs \

I see two "-Wall" added for compiling objects in drivers/staging/erofs/.

Signed-off-by: Masahiro Yamada <yamada.masahiro at socionext.com>
---

 drivers/staging/erofs/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/Makefile b/drivers/staging/erofs/Makefile
index 38ab344a285e..a34248a2a16a 100644
--- a/drivers/staging/erofs/Makefile
+++ b/drivers/staging/erofs/Makefile
@@ -2,7 +2,7 @@
 
 EROFS_VERSION = "1.0pre1"
 
-ccflags-y += -Wall -DEROFS_VERSION=\"$(EROFS_VERSION)\"
+ccflags-y += -DEROFS_VERSION=\"$(EROFS_VERSION)\"
 
 obj-$(CONFIG_EROFS_FS) += erofs.o
 # staging requirement: to be self-contained in its own directory
-- 
2.17.1
