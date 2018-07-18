From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 18 Jul 2018 23:16:14 +0800
Subject: [PATCH] erofs: fix unrecognized mount option message level
Message-ID: <1531926974-72570-1-git-send-email-gaoxiang25@huawei.com>

Commonly 'unrecognized mount option' message should be
printed at least in KERN_ERR message level rather than
KERN_INFO level since it is important for the operating
system that some filesytems cannot be mounted normally,
therefore the level of 'invalid options' message should
be bumped up.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index de8ee81..ab0e4cd 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -232,7 +232,7 @@ static int parse_options(struct super_block *sb, char *options)
 #endif
 			break;
 		default:
-			infoln("Unrecognized mount option \"%s\" "
+			errln("Unrecognized mount option \"%s\" "
 					"or missing value", p);
 			return -EINVAL;
 		}
-- 
1.9.1
