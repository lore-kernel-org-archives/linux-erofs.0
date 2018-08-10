From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 11 Aug 2018 04:10:34 +0800
Subject: [PREVIEW] [PATCH v3 06/10] staging: erofs: fix compression mapping
 beyond EOF
In-Reply-To: <1533931838-47642-1-git-send-email-gaoxiang25@huawei.com>
References: <1533931838-47642-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1533931838-47642-6-git-send-email-gaoxiang25@huawei.com>

Logical address of EOF LTP mapping should start at
`inode->i_size' rather than `inode->i_size - 1' to
`m_la(in) + 1 - inode->i_size', fix it.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
change log v3:
 - spilt into small patches at Chao's suggestion.

 drivers/staging/erofs/unzip_vle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 6404e02..f81b2a6 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1550,7 +1550,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 	if (unlikely(map->m_la >= inode->i_size)) {
 		BUG_ON(!initial);
 		map->m_llen = map->m_la + 1 - inode->i_size;
-		map->m_la = inode->i_size - 1;
+		map->m_la = inode->i_size;
 		map->m_flags = 0;
 		goto out;
 	}
-- 
1.9.1
