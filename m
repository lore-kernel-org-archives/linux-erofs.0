From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 5 Nov 2018 18:31:13 +0800
Subject: [PATCH 4.20-rc1 rebased 02/10] staging: erofs: remove the redundant
 d_rehash() for the root dentry
In-Reply-To: <20181105103121.39655-1-gaoxiang25@huawei.com>
References: <20181105103121.39655-1-gaoxiang25@huawei.com>
Message-ID: <20181105103121.39655-2-gaoxiang25@huawei.com>

There is actually no need at all to d_rehash() for the root dentry
as Al pointed out, fix it.

Reported-by: Al Viro <viro at ZenIV.linux.org.uk>
Cc: Al Viro <viro at ZenIV.linux.org.uk>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/super.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index f69e619807a1..1ab3553c839b 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -442,12 +442,6 @@ static int erofs_read_super(struct super_block *sb,
 
 	erofs_register_super(sb);
 
-	/*
-	 * We already have a positive dentry, which was instantiated
-	 * by d_make_root. Just need to d_rehash it.
-	 */
-	d_rehash(sb->s_root);
-
 	if (!silent)
 		infoln("mounted on %s with opts: %s.", dev_name,
 			(char *)data);
-- 
2.14.4
