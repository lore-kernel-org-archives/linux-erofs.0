From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 22 Jun 2018 10:01:25 +0800
Subject: [PATCH 05/11] erofs: fix to handle return value of
 erofs_init_page_bundle() correctly
In-Reply-To: <20180622020131.65525-1-yuchao0@huawei.com>
References: <20180622020131.65525-1-yuchao0@huawei.com>
Message-ID: <20180622020131.65525-5-yuchao0@huawei.com>

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 fs/erofs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 0db207056bc5..e6d4efd7c043 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -189,8 +189,8 @@ static int erofs_read_super(struct super_block *sb,
 		infoln("root inode @ nid %llu", ROOT_NID(sbi));
 #ifdef CONFIG_EROFS_FS_PAGE_BUNDLE
 	sbi->ibundle = erofs_init_page_bundle(sb);
-	if (sbi->ibundle == NULL) {
-		err = -ENOMEM;
+	if (IS_ERR(sbi->ibundle)) {
+		err = PTR_ERR(sbi->ibundle);
 		goto err_sbi;
 	}
 #endif
-- 
2.18.0.rc1
