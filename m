From: hsiangkao@aol.com (Gao Xiang)
Date: Sun, 18 Aug 2019 18:28:24 +0800
Subject: [PATCH] staging: erofs: refuse to mount images with malformed volume
 name
Message-ID: <20190818102824.22330-1-hsiangkao@aol.com>

From: Gao Xiang <gaoxiang25@huawei.com>

As Richard reminder [1], A valid volume name should be
ended in NIL terminator within the length of volume_name.

Since this field currently isn't really used, let's fix
it to avoid potential bugs in the future.

[1] https://lore.kernel.org/r/1133002215.69049.1566119033047.JavaMail.zimbra at nod.at/

Reported-by: Richard Weinberger <richard at nod.at>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/super.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index f65a1ff9f42f..2da471010a86 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -131,9 +131,14 @@ static int superblock_read(struct super_block *sb)
 	sbi->build_time_nsec = le32_to_cpu(layout->build_time_nsec);
 
 	memcpy(&sb->s_uuid, layout->uuid, sizeof(layout->uuid));
-	memcpy(sbi->volume_name, layout->volume_name,
-	       sizeof(layout->volume_name));
 
+	ret = strscpy(sbi->volume_name, layout->volume_name,
+		      sizeof(layout->volume_name));
+	if (ret < 0) {	/* -E2BIG */
+		errln("bad volume name without NIL terminator");
+		ret = -EFSCORRUPTED;
+		goto out;
+	}
 	ret = 0;
 out:
 	brelse(bh);
-- 
2.17.1
