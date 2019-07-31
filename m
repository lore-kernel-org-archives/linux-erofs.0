From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 31 Jul 2019 23:57:51 +0800
Subject: [PATCH v2 21/22] staging: erofs: update super.c
In-Reply-To: <20190731155752.210602-1-gaoxiang25@huawei.com>
References: <20190731155752.210602-1-gaoxiang25@huawei.com>
Message-ID: <20190731155752.210602-22-gaoxiang25@huawei.com>

Keep in line with erofs-outofstaging patchset:
- "Chao Yu" is most commonly used in Linux community;
- quoted string split across lines.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/super.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index a14fa5228bca..f65a1ff9f42f 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -326,8 +326,7 @@ static int parse_options(struct super_block *sb, char *options)
 				return err;
 			break;
 		default:
-			errln("Unrecognized mount option \"%s\" "
-					"or missing value", p);
+			errln("Unrecognized mount option \"%s\" or missing value", p);
 			return -EINVAL;
 		}
 	}
@@ -662,6 +661,6 @@ module_init(erofs_module_init);
 module_exit(erofs_module_exit);
 
 MODULE_DESCRIPTION("Enhanced ROM File System");
-MODULE_AUTHOR("Gao Xiang, Yu Chao, Miao Xie, CONSUMER BG, HUAWEI Inc.");
+MODULE_AUTHOR("Gao Xiang, Chao Yu, Miao Xie, CONSUMER BG, HUAWEI Inc.");
 MODULE_LICENSE("GPL");
 
-- 
2.17.1
