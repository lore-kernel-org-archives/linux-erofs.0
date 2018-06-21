From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 21 Jun 2018 21:55:13 +0800
Subject: [erofs-dev] [RFC PATCH RESEND 09/12] erofs: update Kconfig and
 Makefile
In-Reply-To: <1529589316-114929-1-git-send-email-gaoxiang25@huawei.com>
References: <1529588426-111662-1-git-send-email-gaoxiang25@huawei.com>
 <1529589316-114929-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1529589316-114929-3-git-send-email-gaoxiang25@huawei.com>

This commit adds Makefile and Kconfig for erofs, and
updates Makefile and Kconfig files in the fs directory.

Signed-off-by: Miao Xie <miaoxie at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/Kconfig        |  1 +
 fs/Makefile       |  1 +
 fs/erofs/Kconfig  | 34 ++++++++++++++++++++++++++++++++++
 fs/erofs/Makefile |  7 +++++++
 4 files changed, 43 insertions(+)
 create mode 100644 fs/erofs/Kconfig
 create mode 100644 fs/erofs/Makefile

diff --git a/fs/Kconfig b/fs/Kconfig
index bc821a8..c14ec12 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -251,6 +251,7 @@ source "fs/pstore/Kconfig"
 source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
 source "fs/exofs/Kconfig"
+source "fs/erofs/Kconfig"
 
 endif # MISC_FILESYSTEMS
 
diff --git a/fs/Makefile b/fs/Makefile
index c9375fd..9477dfc 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -128,3 +128,4 @@ obj-y				+= exofs/ # Multiple modules
 obj-$(CONFIG_CEPH_FS)		+= ceph/
 obj-$(CONFIG_PSTORE)		+= pstore/
 obj-$(CONFIG_EFIVAR_FS)		+= efivarfs/
+obj-$(CONFIG_EROFS_FS)		+= erofs/
diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
new file mode 100644
index 0000000..1c2f276
--- /dev/null
+++ b/fs/erofs/Kconfig
@@ -0,0 +1,34 @@
+config EROFS_FS
+	tristate "EROFS filesystem support"
+	depends on BLOCK
+	help
+	  EROFS(Enhanced Read-Only File System) is a lightweight
+	  read-only file system with modern designs (eg. page-sized
+	  blocks, inline xattrs/data, etc.) for scenarios which have
+	  high-performance read-only requirements, eg. firmwares in
+	  mobile phone or LIVECDs.
+
+	  It also provides VLE compression support, focusing on
+	  random read improvements, keeping relatively lower
+	  compression ratios, which is also useful for
+	  high-performance devices with limited ROM space.
+
+	  If unsure, say N.
+
+config EROFS_FS_DEBUG
+	bool "EROFS debugging feature"
+	depends on EROFS_FS
+	help
+	  Print erofs debugging messages and enable more BUG_ONs
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
diff --git a/fs/erofs/Makefile b/fs/erofs/Makefile
new file mode 100644
index 0000000..61dfcae
--- /dev/null
+++ b/fs/erofs/Makefile
@@ -0,0 +1,7 @@
+EROFS_VERSION = "1.0"
+
+EXTRA_CFLAGS += -Wall -DEROFS_VERSION=\"$(EROFS_VERSION)\"
+
+obj-$(CONFIG_EROFS_FS) += erofs.o
+erofs-objs := super.o inode.o data.o namei.o dir.o
+
-- 
1.9.1
