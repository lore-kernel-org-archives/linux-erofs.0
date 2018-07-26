From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 26 Jul 2018 20:22:08 +0800
Subject: [PATCH 25/25] staging: erofs: add a TODO and update MAINTAINERS for
 staging
In-Reply-To: <1532607728-103372-1-git-send-email-gaoxiang25@huawei.com>
References: <1527764767-22190-1-git-send-email-gaoxiang25@huawei.com>
 <1532607728-103372-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1532607728-103372-26-git-send-email-gaoxiang25@huawei.com>

This patch adds a TODO to list the things to be done, and
the relevant info to MAINTAINERS so we can take all the blame :)

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 MAINTAINERS                |  7 +++++++
 drivers/staging/erofs/TODO | 45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)
 create mode 100644 drivers/staging/erofs/TODO

diff --git a/MAINTAINERS b/MAINTAINERS
index 0fe4228..8d470b0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13487,6 +13487,13 @@ M:	H Hartley Sweeten <hsweeten at visionengravers.com>
 S:	Odd Fixes
 F:	drivers/staging/comedi/
 
+STAGING - EROFS FILE SYSTEM
+M:	Gao Xiang <gaoxiang25 at huawei.com>
+M:	Chao Yu <yuchao0 at huawei.com>
+L:	linux-erofs at lists.ozlabs.org
+S:	Maintained
+F:	drivers/staging/erofs/
+
 STAGING - FLARION FT1000 DRIVERS
 M:	Marek Belisko <marek.belisko at gmail.com>
 S:	Odd Fixes
diff --git a/drivers/staging/erofs/TODO b/drivers/staging/erofs/TODO
new file mode 100644
index 0000000..f99ddb8
--- /dev/null
+++ b/drivers/staging/erofs/TODO
@@ -0,0 +1,45 @@
+
+EROFS is still working in progress, thus it is not suitable
+for all productive uses. play at your own risk :)
+
+TODO List:
+ - add the missing error handling code
+   (mainly existed in xattr and decompression submodules);
+
+ - finalize erofs ondisk format design  (which means that
+   minor on-disk revisions could happen later);
+
+ - documentation and detailed technical analysis;
+
+ - general code review and clean up
+   (including confusing variable names and code snippets);
+
+ - support larger compressed clustersizes for selection
+   (currently erofs only works as expected with the page-sized
+    compressed cluster configuration, usually 4KB);
+
+ - support more lossless data compression algorithms
+   in addition to LZ4 algorithms in VLE approach;
+
+ - data deduplication and other useful features.
+
+erofs-mkfs (preview version) binaries for i386 / x86_64 are available at:
+
+   https://github.com/hsiangkao/erofs_mkfs_binary
+
+It is still in progress opening mkfs source code to public,
+in any case an open-source mkfs will be released in the near future.
+
+
+Code, suggestions, etc, are welcome. Please feel free to
+ask and send patches,
+
+To:
+  linux-erofs mailing list   <linux-erofs at lists.ozlabs.org>
+  Gao Xiang                  <gaoxiang25 at huawei.com>
+  Chao Yu                    <yuchao0 at huawei.com>
+
+Cc: (for linux-kernel upstream patches)
+  Greg Kroah-Hartman         <gregkh at linuxfoundation.org>
+  linux-staging mailing list <devel at driverdev.osuosl.org>
+
-- 
1.9.1
