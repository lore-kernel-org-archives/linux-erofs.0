From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 22 Jun 2018 09:57:58 +0800
Subject: [PATCH RESEND 2/2] erofs: update SPDX-License-Identifier
In-Reply-To: <20180622015758.64935-1-yuchao0@huawei.com>
References: <20180622015758.64935-1-yuchao0@huawei.com>
Message-ID: <20180622015758.64935-2-yuchao0@huawei.com>

From: Gao Xiang <gaoxiang25@huawei.com>

Update the source code license to "GPLv2+" from patchset v2.
(Could be updated suggested by Savannah in the future.)

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 fs/erofs/data.c          | 2 +-
 fs/erofs/dir.c           | 2 +-
 fs/erofs/erofs_fs.h      | 2 +-
 fs/erofs/inode.c         | 2 +-
 fs/erofs/internal.h      | 2 +-
 fs/erofs/namei.c         | 2 +-
 fs/erofs/pagevec.h       | 2 +-
 fs/erofs/staging.h       | 2 +-
 fs/erofs/super.c         | 2 +-
 fs/erofs/unzip.c         | 2 +-
 fs/erofs/unzip.h         | 2 +-
 fs/erofs/unzip_generic.c | 2 +-
 fs/erofs/unzip_lz4.c     | 2 +-
 fs/erofs/unzip_vle.h     | 2 +-
 fs/erofs/xattr.c         | 2 +-
 fs/erofs/xattr.h         | 2 +-
 16 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index c54495d6e2f1..acd4ff41b3d7 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * linux/fs/erofs/data.c
  *
diff --git a/fs/erofs/dir.c b/fs/erofs/dir.c
index 7d3448ba2458..39870e165007 100644
--- a/fs/erofs/dir.c
+++ b/fs/erofs/dir.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * linux/fs/erofs/dir.c
  *
diff --git a/fs/erofs/erofs_fs.h b/fs/erofs/erofs_fs.h
index c08d98295d76..96feebc0bbec 100644
--- a/fs/erofs/erofs_fs.h
+++ b/fs/erofs/erofs_fs.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0+
  *
  * linux/fs/erofs/erofs_fs.h
  *
diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index 61010c03386e..94e827b57a5b 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * linux/fs/erofs/inode.c
  *
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 307f435d982d..934f750975f2 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0+
  *
  * linux/fs/erofs/internal.h
  *
diff --git a/fs/erofs/namei.c b/fs/erofs/namei.c
index ae715842058c..506974fd3a88 100644
--- a/fs/erofs/namei.c
+++ b/fs/erofs/namei.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * linux/fs/erofs/namei.c
  *
diff --git a/fs/erofs/pagevec.h b/fs/erofs/pagevec.h
index 5a7ef76d3934..8ba78d52cb2d 100644
--- a/fs/erofs/pagevec.h
+++ b/fs/erofs/pagevec.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0+
  *
  * linux/fs/erofs/pagevec.h
  *
diff --git a/fs/erofs/staging.h b/fs/erofs/staging.h
index 7712a7bf1add..5563dc96d1ab 100644
--- a/fs/erofs/staging.h
+++ b/fs/erofs/staging.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+/* SPDX-License-Identifier: GPL-2.0+ */
 
 /* should be avoid in the future */
 #include <linux/version.h>
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 7e725bbd9a0e..8da471155da2 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * linux/fs/erofs/super.c
  *
diff --git a/fs/erofs/unzip.c b/fs/erofs/unzip.c
index 171aec14272f..04df8e060594 100644
--- a/fs/erofs/unzip.c
+++ b/fs/erofs/unzip.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * linux/fs/erofs/unzip.c
  *
diff --git a/fs/erofs/unzip.h b/fs/erofs/unzip.h
index 45e4e1425bda..486a8fb515bf 100644
--- a/fs/erofs/unzip.h
+++ b/fs/erofs/unzip.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0+
  *
  * linux/fs/erofs/unzip.h
  *
diff --git a/fs/erofs/unzip_generic.c b/fs/erofs/unzip_generic.c
index 5e0b0bcd157d..3282443e94cc 100644
--- a/fs/erofs/unzip_generic.c
+++ b/fs/erofs/unzip_generic.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * linux/fs/erofs/unzip_generic.c
  *
diff --git a/fs/erofs/unzip_lz4.c b/fs/erofs/unzip_lz4.c
index aa2e398e2cdb..f46aaa7e9ff8 100644
--- a/fs/erofs/unzip_lz4.c
+++ b/fs/erofs/unzip_lz4.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * linux/fs/erofs/unzip_lz4.c
  *
diff --git a/fs/erofs/unzip_vle.h b/fs/erofs/unzip_vle.h
index cf7ef9f006bf..4e3f0396d720 100644
--- a/fs/erofs/unzip_vle.h
+++ b/fs/erofs/unzip_vle.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0+
  *
  * linux/fs/erofs/unzip_vle.h
  *
diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
index 6ee0f0c20a9a..f27ee416542d 100644
--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * linux/fs/erofs/xattr.c
  *
diff --git a/fs/erofs/xattr.h b/fs/erofs/xattr.h
index b93ccdfffacc..7f3d2b87d7a7 100644
--- a/fs/erofs/xattr.h
+++ b/fs/erofs/xattr.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0+
  *
  * linux/fs/erofs/xattr.h
  *
-- 
2.18.0.rc1
