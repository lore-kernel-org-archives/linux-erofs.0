From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 22 Jun 2018 03:23:16 +0800
Subject: [PATCH RESEND] erofs: add the missing header <linux/prefetch.h>
Message-ID: <1529608996-25811-1-git-send-email-gaoxiang25@huawei.com>

This fixes compiling errors built with:
config: parisc-allmodconfig (attached as .config)
compiler: hppa-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0

Reported-by: kbuild test robot <lkp at intel.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 fs/erofs/data.c  | 1 +
 fs/erofs/unzip.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index c54495d..20d7e80 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -11,6 +11,7 @@
  * distribution for more details.
  */
 #include "internal.h"
+#include <linux/prefetch.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 3, 0))
 static inline void read_endio(struct bio *bio, int err)
diff --git a/fs/erofs/unzip.c b/fs/erofs/unzip.c
index 171aec1..b427952 100644
--- a/fs/erofs/unzip.c
+++ b/fs/erofs/unzip.c
@@ -13,6 +13,7 @@
 #include "unzip.h"
 #include <linux/slab.h>
 #include <linux/blkdev.h>
+#include <linux/prefetch.h>
 
 static struct workqueue_struct *z_erofs_workqueue __read_mostly;
 static struct kmem_cache *z_erofs_pack_cachep __read_mostly;
-- 
1.9.1
