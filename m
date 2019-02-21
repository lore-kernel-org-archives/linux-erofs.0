From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 21 Feb 2019 10:34:11 +0800
Subject: [PATCH 2/2] staging: erofs: switch to ->iterate_shared()
In-Reply-To: <20190221023411.2980-1-gaoxiang25@huawei.com>
References: <20190221023411.2980-1-gaoxiang25@huawei.com>
Message-ID: <20190221023411.2980-2-gaoxiang25@huawei.com>

After commit 6192269444eb ("introduce a parallel variant of ->iterate()"),
readdir can be done without taking exclusive inode lock of course.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/dir.c b/drivers/staging/erofs/dir.c
index 8f8ac9675921..829f7b12e0dc 100644
--- a/drivers/staging/erofs/dir.c
+++ b/drivers/staging/erofs/dir.c
@@ -142,6 +142,6 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
 const struct file_operations erofs_dir_fops = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
-	.iterate	= erofs_readdir,
+	.iterate_shared	= erofs_readdir,
 };
 
-- 
2.14.4
