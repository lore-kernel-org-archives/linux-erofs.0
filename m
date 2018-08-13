From: hsiangkao@aol.com (Gao Xiang)
Date: Tue, 14 Aug 2018 03:41:49 +0800
Subject: [PREVIEW] [PATCH RESEND staging-next 8/8] staging: erofs: fix
 compression mapping beyond EOF
In-Reply-To: <1534189309-924-1-git-send-email-hsiangkao@aol.com>
References: <1534189309-924-1-git-send-email-hsiangkao@aol.com>
Message-ID: <1534189309-924-8-git-send-email-hsiangkao@aol.com>

From: Gao Xiang <gaoxiang25@huawei.com>

Logical address of EOF LTP mapping should start at
`inode->i_size' rather than `inode->i_size - 1' to
`m_la(in)', fix it.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index dab8921..6c4c928 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1548,7 +1548,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 	if (unlikely(map->m_la >= inode->i_size)) {
 		BUG_ON(!initial);
 		map->m_llen = map->m_la + 1 - inode->i_size;
-		map->m_la = inode->i_size - 1;
+		map->m_la = inode->i_size;
 		map->m_flags = 0;
 		goto out;
 	}
-- 
2.7.4
