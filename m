From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 16 Jul 2019 15:04:16 +0800
Subject: [PATCH v2 14/17] erofs-utils: non-inline tail-end block should be
 zeroed beyond EOF
In-Reply-To: <20190716070419.30203-1-gaoxiang25@huawei.com>
References: <20190716070419.30203-1-gaoxiang25@huawei.com>
Message-ID: <20190716070419.30203-15-gaoxiang25@huawei.com>

Otherwise random data from last bdrop() could be readed and
it will cause unexpected behavior accidentally.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 lib/inode.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/lib/inode.c b/lib/inode.c
index 16b011e..affd6db 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -523,14 +523,19 @@ int erofs_write_tail_end(struct erofs_inode *inode)
 		ibh->op = &erofs_write_inline_bhops;
 	} else {
 		int ret;
+		erofs_off_t pos;
 
 		erofs_mapbh(bh->block, true);
-		ret = dev_write(inode->idata,
-				erofs_btell(bh, true) - EROFS_BLKSIZ,
-				inode->idata_size);
+		pos = erofs_btell(bh, true) - EROFS_BLKSIZ;
+		ret = dev_write(inode->idata, pos, inode->idata_size);
 		if (ret)
 			return ret;
-
+		if (inode->idata_size < EROFS_BLKSIZ) {
+			ret = dev_fillzero(pos + inode->idata_size,
+					   EROFS_BLKSIZ - inode->idata_size);
+			if (ret)
+				return ret;
+		}
 		inode->idata_size = 0;
 		free(inode->idata);
 		inode->idata = NULL;
-- 
2.17.1
