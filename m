From: colin.king@canonical.com (Colin King)
Date: Mon, 17 Jun 2019 13:55:29 +0100
Subject: [PATCH] staging: erofs: clean up initialization of pointer de
Message-ID: <20190617125529.28327-1-colin.king@canonical.com>

From: Colin Ian King <colin.king@canonical.com>

Currently pointer de is being initialized with a value that is
never read and a few statements later de is being re-assigned. Clean
this up by ininitialzing de and removing the re-assignment.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king at canonical.com>
---
 drivers/staging/erofs/dir.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/dir.c b/drivers/staging/erofs/dir.c
index 9bbc68729c11..dbf6a151886c 100644
--- a/drivers/staging/erofs/dir.c
+++ b/drivers/staging/erofs/dir.c
@@ -42,10 +42,9 @@ static int erofs_fill_dentries(struct dir_context *ctx,
 			       void *dentry_blk, unsigned int *ofs,
 			       unsigned int nameoff, unsigned int maxsize)
 {
-	struct erofs_dirent *de = dentry_blk;
+	struct erofs_dirent *de = dentry_blk + *ofs;
 	const struct erofs_dirent *end = dentry_blk + nameoff;
 
-	de = dentry_blk + *ofs;
 	while (de < end) {
 		const char *de_name;
 		unsigned int de_namelen;
-- 
2.20.1
