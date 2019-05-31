From: hsiangkao@aol.com (Gao Xiang)
Date: Fri, 31 May 2019 08:50:46 +0800
Subject: [PATCH 12/13] erofs-utils: add a README
In-Reply-To: <20190531005047.22093-1-hsiangkao@aol.com>
References: <20190531005047.22093-1-hsiangkao@aol.com>
Message-ID: <20190531005047.22093-13-hsiangkao@aol.com>

From: Gao Xiang <gaoxiang25@huawei.com>

This patch adds a README and some warnings here.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 README | 11 +++++++++++
 1 file changed, 11 insertions(+)
 create mode 100644 README

diff --git a/README b/README
new file mode 100644
index 0000000..4d509be
--- /dev/null
+++ b/README
@@ -0,0 +1,11 @@
+
+The new erofs-utils introduces a completely new framework,
+which is more cleaner but still under development for now.
+
+Use the old the mkfs-dev branch of erofs-utils temporarily
+to build erofs image instead:
+git clone git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git -b mkfs-dev
+
+Thanks,
+Gao Xiang
+
-- 
2.17.1
