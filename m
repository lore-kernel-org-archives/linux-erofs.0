From: hsiangkao@aol.com (Gao Xiang)
Date: Sun, 12 Aug 2018 15:49:12 +0800
Subject: [PREVIEW] [PATCH v4 06/10] staging: erofs: fix compression mapping
 beyond EOF
In-Reply-To: <88f19b7f-fe44-097f-125b-36ff70a37da0@kernel.org>
References: <88f19b7f-fe44-097f-125b-36ff70a37da0@kernel.org>
Message-ID: <1534060152-3343-1-git-send-email-hsiangkao@aol.com>

From: Gao Xiang <gaoxiang25@huawei.com>

Logical address of EOF LTP mapping should start at
`inode->i_size' rather than `inode->i_size - 1' to
`m_la(in)', fix it.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
change log v4:
 - fix the description `m_la(in) + 1 - inode->i_size' to
   `m_la(in)' in the commit message.

change log v3:
 - spilt into small patches at Chao's suggestion.

Hi Chao,
Please help use this commit message. Thanks.

Thanks,
Gao Xiang
 
 drivers/staging/erofs/unzip_vle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 79d4ca0..aecf650 100644
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
