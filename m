From: digholebhagyashri@gmail.com (Bhagyashri P. Dighole)
Date: Mon, 5 Nov 2018 10:52:54 +0530
Subject: [PATCH v2 1/2] staging: erofs: Modify conditional check
Message-ID:
 <3db6ea6f3a7b1fab94e5dacc1ec4a026e38548c2.1541394756.git.digholebhagyashri@example.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20181105052254.WBeXFJWF2hvIYuVt2V-PpKnFWkzRhjVMrbTERBd3DWw@z>

Found issue using checkpatch.
Use ! for NULL test rather than explicitly comparing to NULL.

Signed-off-by: Bhagyashri P. Dighole <digholebhagyashri at gmail.com>
---
 drivers/staging/erofs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index 6384f73..a671ad4 100644
--- a/drivers/staging/erofs/data.c
+++ b/drivers/staging/erofs/data.c
@@ -240,7 +240,7 @@ static inline struct bio *erofs_read_raw_page(
 		bio = NULL;
 	}
 
-	if (bio == NULL) {
+	if (!bio) {
 		struct erofs_map_blocks map = {
 			.m_la = blknr_to_addr(current_block),
 		};
-- 
2.7.4
