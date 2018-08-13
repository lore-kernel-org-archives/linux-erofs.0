From: leon.imhof@in.tum.de (Leon Imhof)
Date: Mon, 13 Aug 2018 17:20:11 +0200
Subject: [PATCH] staging: erofs: change 'unsigned' to 'unsigned int'
Message-ID: <20180813151950.GA22144@host.localhost>

Fix coding style issue "Prefer 'unsigned int' to bare use of 'unsigned'"
detected by checkpatch.pl

Signed-off-by: Leon Imhof <leon.imhof at in.tum.de>
---
 drivers/staging/erofs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index ac263a180253..2a401216007a 100644
--- a/drivers/staging/erofs/data.c
+++ b/drivers/staging/erofs/data.c
@@ -337,7 +337,7 @@ static int erofs_raw_access_readpage(struct file *file, struct page *page)
 
 static int erofs_raw_access_readpages(struct file *filp,
 	struct address_space *mapping,
-	struct list_head *pages, unsigned nr_pages)
+	struct list_head *pages, unsigned int nr_pages)
 {
 	erofs_off_t last_block;
 	struct bio *bio = NULL;
-- 
2.18.0
