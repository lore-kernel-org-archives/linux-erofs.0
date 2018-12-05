From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 5 Dec 2018 21:23:14 +0800
Subject: [PATCH 2/2] staging: erofs: update erofs-utils information in TODO
In-Reply-To: <20181205132314.8124-1-gaoxiang25@huawei.com>
References: <20181205132314.8124-1-gaoxiang25@huawei.com>
Message-ID: <20181205132314.8124-2-gaoxiang25@huawei.com>

erofs-utils was released by the original author Li Guifu
weeks ago in the linux-erofs mailing list [1], update
information in TODO and let's wait the original author
finish all open source works.

[1] https://lists.ozlabs.org/pipermail/linux-erofs/2018-November/001004.html

Cc: Li Guifu <bluce.liguifu at huawei.com>
Cc: Fang Wei <fangwei1 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/TODO | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/erofs/TODO b/drivers/staging/erofs/TODO
index f99ddb842f99..a8608b2f72bd 100644
--- a/drivers/staging/erofs/TODO
+++ b/drivers/staging/erofs/TODO
@@ -23,13 +23,14 @@ TODO List:
 
  - data deduplication and other useful features.
 
-erofs-mkfs (preview version) binaries for i386 / x86_64 are available at:
-
-   https://github.com/hsiangkao/erofs_mkfs_binary
-
-It is still in progress opening mkfs source code to public,
-in any case an open-source mkfs will be released in the near future.
-
+The following git tree provides the file system user-space
+tools under development (ex, formatting tool mkfs.erofs):
+>> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git
+
+The open-source development of erofs-utils is at the early stage.
+Contact the original author Li Guifu <bluce.liguifu at huawei.com> and
+the co-maintainer Fang Wei <fangwei1 at huawei.com> for the latest news
+and more details.
 
 Code, suggestions, etc, are welcome. Please feel free to
 ask and send patches,
-- 
2.14.4
