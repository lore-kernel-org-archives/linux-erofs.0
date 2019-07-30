From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 30 Jul 2019 15:13:59 +0800
Subject: [PATCH v5 10/24] erofs: update Kconfig and Makefile
In-Reply-To: <20190730071413.11871-1-gaoxiang25@huawei.com>
References: <20190730071413.11871-1-gaoxiang25@huawei.com>
Message-ID: <20190730071413.11871-11-gaoxiang25@huawei.com>

This commit adds Makefile and Kconfig for erofs, and
updates Makefile and Kconfig files in the fs directory.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/Kconfig        |  1 +
 fs/Makefile       |  1 +
 fs/erofs/Kconfig  | 36 ++++++++++++++++++++++++++++++++++++
 fs/erofs/Makefile |  9 +++++++++
 4 files changed, 47 insertions(+)
 create mode 100644 fs/erofs/Kconfig
 create mode 100644 fs/erofs/Makefile

diff --git a/fs/Kconfig b/fs/Kconfig
index bfb1c6095c7a..669d46550e6d 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -261,6 +261,7 @@ source "fs/romfs/Kconfig"
 source "fs/pstore/Kconfig"
 source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
+source "fs/erofs/Kconfig"
 
 endif # MISC_FILESYSTEMS
 
diff --git a/fs/Makefile b/fs/Makefile
index d60089fd689b..b2e4973a0bea 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -130,3 +130,4 @@ obj-$(CONFIG_F2FS_FS)		+= f2fs/
 obj-$(CONFIG_CEPH_FS)		+= ceph/
 obj-$(CONFIG_PSTORE)		+= pstore/
 obj-$(CONFIG_EFIVAR_FS)		+= efivarfs/
+obj-$(CONFIG_EROFS_FS)		+= erofs/
diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
new file mode 100644
index 000000000000..98f05043448a
--- /dev/null
+++ b/fs/erofs/Kconfig
@@ -0,0 +1,36 @@
+# SPDX-License-Identifier: GPL-2.0-only
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
diff --git a/fs/erofs/Makefile b/fs/erofs/Makefile
new file mode 100644
index 000000000000..c3f4e549ef90
--- /dev/null
+++ b/fs/erofs/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0-only
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
