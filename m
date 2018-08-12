From: chao@kernel.org (Chao Yu)
Date: Sun, 12 Aug 2018 22:01:50 +0800
Subject: [PATCH 8/8] staging: erofs: fix compression mapping beyond EOF
In-Reply-To: <20180812140150.13397-1-chao@kernel.org>
References: <20180812140150.13397-1-chao@kernel.org>
Message-ID: <20180812140150.13397-9-chao@kernel.org>

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
index 6c5b0a312592..2f47498eb1fe 100644
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
2.18.0
