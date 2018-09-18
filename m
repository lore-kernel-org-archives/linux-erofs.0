From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 18 Sep 2018 21:44:36 +0800
Subject: [PATCH] staging: erofs: initialize `pblk' with 0 first in
 `z_erofs_map_blocks_iter'
In-Reply-To: <20180918130911.GA16187@kroah.com>
References: <20180918130911.GA16187@kroah.com>
Message-ID: <1537278276-110982-1-git-send-email-gaoxiang25@huawei.com>

This commit message helps to understand why `pblk' is assigned with 0 here.

[ Greg reported a warning raised by gcc. ]
In file included from drivers/staging/erofs/unzip_vle.h:16:0,
                 from drivers/staging/erofs/unzip_vle.c:13:
drivers/staging/erofs/unzip_vle.c: In function ?z_erofs_map_blocks_iter?:
drivers/staging/erofs/internal.h:303:34: warning: ?pblk? may be used uninitialized in this function [-Wmaybe-uninitialized]
 #define blknr_to_addr(nr)       ((erofs_off_t)(nr) * EROFS_BLKSIZ)
                                  ^
drivers/staging/erofs/unzip_vle.c:1574:20: note: ?pblk? was declared here
  erofs_blk_t mblk, pblk;
                    ^~~~

Actually, it is a false-positive warning when looking into that. [1]
Just initialize the variable to keep gcc from printing foolish warnings.

[1] https://lists.ozlabs.org/pipermail/linux-erofs/2018-September/000637.html

Reported-by: Greg Kroah-Hartman <gregkh at linuxfoundation.org>
Thanks-to: Dan Carpenter <dan.carpenter at oracle.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index ad3b7bb..3ff8adf 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1571,7 +1571,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 	unsigned int lcn;
 	u32 ofs_rem;
 
-	erofs_blk_t mblk, pblk;
+	erofs_blk_t mblk, pblk = 0;
 	struct page *mpage = *mpage_ret;
 	struct z_erofs_vle_decompressed_index *di;
 	unsigned int cluster_type, logical_cluster_ofs;
-- 
1.9.1
