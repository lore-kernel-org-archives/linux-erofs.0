From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 11 Jul 2019 22:57:41 +0800
Subject: [PATCH v2 10/24] erofs: update Kconfig and Makefile
In-Reply-To: <20190711145755.33908-1-gaoxiang25@huawei.com>
References: <20190711145755.33908-1-gaoxiang25@huawei.com>
Message-ID: <20190711145755.33908-11-gaoxiang25@huawei.com>

This commit adds Makefile and Kconfig for erofs, and
updates Makefile and Kconfig files in the fs directory.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/Kconfig        |  1 +
 fs/Makefile       |  1 +
 fs/erofs/Kconfig  | 45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/erofs/Makefile |  9 +++++++++
 4 files changed, 56 insertions(+)
 create mode 100644 fs/erofs/Kconfig
 create mode 100644 fs/erofs/Makefile

diff --git a/fs/Kconfig b/fs/Kconfig
index f1046cf6ad85..529a174cbb9c 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -262,6 +262,7 @@ source "fs/romfs/Kconfig"
 source "fs/pstore/Kconfig"
 source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
+source "fs/erofs/Kconfig"
 
 endif # MISC_FILESYSTEMS
 
diff --git a/fs/Makefile b/fs/Makefile
index c9aea23aba56..6166f533abf7 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -130,3 +130,4 @@ obj-$(CONFIG_F2FS_FS)		+= f2fs/
 obj-$(CONFIG_CEPH_FS)		+= ceph/
 obj-$(CONFIG_PSTORE)		+= pstore/
 obj-$(CONFIG_EFIVAR_FS)		+= efivarfs/
+obj-$(CONFIG_EROFS_FS)		+= erofs/
diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
new file mode 100644
index 000000000000..bcab58d3f709
--- /dev/null
+++ b/fs/erofs/Kconfig
@@ -0,0 +1,45 @@
+# SPDX-License-Identifier: GPL-2.0
+
+config EROFS_FS
+	tristate "EROFS filesystem support"
+	depends on BLOCK
+	help
+	  EROFS (Enhanced Read-Only File System) is a lightweight
+	  read-only file system with modern designs (eg. page-sized
+	  blocks, inline xattrs/data, etc.) for scenarios which need
+	  high-performance read-only requirements, e.g. Android OS
+	  for mobile phones and LIVECDs.
+
+	  It also provides fixed-sized output compression support,
+	  which improves storage density, keeps relatively higher
+	  compression ratios, which is more useful to achieve high
+	  performance for embedded devices with limited memory.
+
+	  If unsure, say N.
+
+config EROFS_FS_DEBUG
+	bool "EROFS debugging feature"
+	depends on EROFS_FS
+	help
+	  Print debugging messages and enable more BUG_ONs which check
+	  filesystem consistency and find potential issues aggressively,
+	  which can be used for Android eng build, for example.
+
+	  For daily use, say N.
+
+config EROFS_FAULT_INJECTION
+	bool "EROFS fault injection facility"
+	depends on EROFS_FS
+	help
+	  Test EROFS to inject faults such as ENOMEM, EIO, and so on.
+	  If unsure, say N.
+
+config EROFS_FS_IO_MAX_RETRIES
+	int "EROFS IO Maximum Retries"
+	depends on EROFS_FS
+	default "5"
+	help
+	  Maximum retry count of IO Errors.
+
+	  If unsure, leave the default value (5 retries, 6 IOs at most).
+
diff --git a/fs/erofs/Makefile b/fs/erofs/Makefile
new file mode 100644
index 000000000000..ec2795f33dc5
--- /dev/null
+++ b/fs/erofs/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0
+
+EROFS_VERSION = "1.0"
+
+ccflags-y += -DEROFS_VERSION=\"$(EROFS_VERSION)\"
+
+obj-$(CONFIG_EROFS_FS) += erofs.o
+erofs-objs := super.o inode.o data.o namei.o dir.o
+
-- 
2.17.1
