From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 26 Jul 2018 20:21:51 +0800
Subject: [PATCH 08/25] staging: erofs: update Kconfig and Makefile
In-Reply-To: <1532607728-103372-1-git-send-email-gaoxiang25@huawei.com>
References: <1527764767-22190-1-git-send-email-gaoxiang25@huawei.com>
 <1532607728-103372-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1532607728-103372-9-git-send-email-gaoxiang25@huawei.com>

This commit adds Makefile and Kconfig for erofs, and
updates Makefile and Kconfig files in the fs directory.

Signed-off-by: Miao Xie <miaoxie at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/Kconfig        |  2 ++
 drivers/staging/Makefile       |  1 +
 drivers/staging/erofs/Kconfig  | 36 ++++++++++++++++++++++++++++++++++++
 drivers/staging/erofs/Makefile | 11 +++++++++++
 4 files changed, 50 insertions(+)
 create mode 100644 drivers/staging/erofs/Kconfig
 create mode 100644 drivers/staging/erofs/Makefile

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 75a4804..de9c95a 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -126,4 +126,6 @@ source "drivers/staging/mt7621-eth/Kconfig"
 
 source "drivers/staging/mt7621-dts/Kconfig"
 
+source "drivers/staging/erofs/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index e84959a..a33ac34 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -54,3 +54,4 @@ obj-$(CONFIG_SOC_MT7621)	+= mt7621-dma/
 obj-$(CONFIG_SOC_MT7621)	+= mt7621-mmc/
 obj-$(CONFIG_SOC_MT7621)	+= mt7621-eth/
 obj-$(CONFIG_SOC_MT7621)	+= mt7621-dts/
+obj-$(CONFIG_EROFS_FS)		+= erofs/
diff --git a/drivers/staging/erofs/Kconfig b/drivers/staging/erofs/Kconfig
new file mode 100644
index 0000000..077430f
--- /dev/null
+++ b/drivers/staging/erofs/Kconfig
@@ -0,0 +1,36 @@
+# SPDX-License-Identifier: GPL-2.0
+
+config EROFS_FS
+	tristate "EROFS filesystem support"
+	depends on BLOCK
+	help
+	  EROFS(Enhanced Read-Only File System) is a lightweight
+	  read-only file system with modern designs (eg. page-sized
+	  blocks, inline xattrs/data, etc.) for scenarios which need
+	  high-performance read-only requirements, eg. firmwares in
+	  mobile phone or LIVECDs.
+
+	  It also provides VLE compression support, focusing on
+	  random read improvements, keeping relatively lower
+	  compression ratios, which is useful for high-performance
+	  devices with limited memory and ROM space.
+
+	  If unsure, say N.
+
+config EROFS_FS_DEBUG
+	bool "EROFS debugging feature"
+	depends on EROFS_FS
+	help
+	  Print EROFS debugging messages and enable more BUG_ONs
+	  which check the filesystem consistency aggressively.
+
+	  For daily use, say N.
+
+config EROFS_FS_USE_VM_MAP_RAM
+	bool "EROFS VM_MAP_RAM Support"
+	depends on EROFS_FS
+	help
+	  use vm_map_ram/vm_unmap_ram instead of vmap/vunmap.
+
+	  If you don't know what these are, say N.
+
diff --git a/drivers/staging/erofs/Makefile b/drivers/staging/erofs/Makefile
new file mode 100644
index 0000000..31e909e
--- /dev/null
+++ b/drivers/staging/erofs/Makefile
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0
+
+EROFS_VERSION = "1.0pre1"
+
+ccflags-y += -Wall -DEROFS_VERSION=\"$(EROFS_VERSION)\"
+
+obj-$(CONFIG_EROFS_FS) += erofs.o
+# staging requirement: to be self-contained in its own directory
+ccflags-y += -I$(src)/include
+erofs-objs := super.o inode.o data.o namei.o dir.o
+
-- 
1.9.1
