From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 22 Jun 2018 10:01:24 +0800
Subject: [PATCH 04/11] erofs: fix to do endian conversion correctly
In-Reply-To: <20180622020131.65525-1-yuchao0@huawei.com>
References: <20180622020131.65525-1-yuchao0@huawei.com>
Message-ID: <20180622020131.65525-4-yuchao0@huawei.com>

erofs_super_block::root_nid is type of __le16, so it needs to use
le16_to_cpu for endian conversion instead of le64_to_cpu, fix it.

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 fs/erofs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 8da471155da2..0db207056bc5 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -114,7 +114,7 @@ static int superblock_read(struct super_block *sb)
 	sbi->clusterbits = 12;
 #endif
 
-	sbi->root_nid = le64_to_cpu(layout->root_nid);
+	sbi->root_nid = le16_to_cpu(layout->root_nid);
 	sbi->inos = le64_to_cpu(layout->inos);
 
 	sbi->build_time = le64_to_cpu(layout->build_time);
-- 
2.18.0.rc1
