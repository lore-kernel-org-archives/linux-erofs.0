From: cgxu519@gmx.com (Chengguang Xu)
Date: Tue, 12 Feb 2019 11:24:22 +0800
Subject: [PATCH 1/2] staging: erofs: remove redundant likely/unlikely
 annotation in namei.c
Message-ID: <20190212032423.14637-1-cgxu519@gmx.com>

unlikely has already included in IS_ERR(),
so just remove redundant likely/unlikely
annotation.

Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
---
 drivers/staging/erofs/namei.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/erofs/namei.c b/drivers/staging/erofs/namei.c
index 5596c52e246d..1acd742a41ed 100644
--- a/drivers/staging/erofs/namei.c
+++ b/drivers/staging/erofs/namei.c
@@ -144,7 +144,7 @@ static struct page *find_target_block_classic(
 				head = mid + 1;
 				startprfx = matched;
 
-				if (likely(!IS_ERR(candidate)))
+				if (!IS_ERR(candidate))
 					put_page(candidate);
 				candidate = page;
 			} else {
@@ -177,7 +177,7 @@ int erofs_namei(struct inode *dir,
 	diff = 1;
 	page = find_target_block_classic(dir, name, &diff);
 
-	if (unlikely(IS_ERR(page)))
+	if (IS_ERR(page))
 		return PTR_ERR(page);
 
 	data = kmap_atomic(page);
@@ -187,7 +187,7 @@ int erofs_namei(struct inode *dir,
 		find_target_dirent(name, data, EROFS_BLKSIZ) :
 		(struct erofs_dirent *)data;
 
-	if (likely(!IS_ERR(de))) {
+	if (!IS_ERR(de)) {
 		*nid = le64_to_cpu(de->nid);
 		*d_type = de->file_type;
 	}
-- 
2.20.1
