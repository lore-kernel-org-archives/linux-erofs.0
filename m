From: digholebhagyashri@gmail.com (Bhagyashri P. Dighole)
Date: Mon, 5 Nov 2018 01:27:01 +0530
Subject: [PATCH] staging: erofs: Modify conditional check.
Message-ID: <20181104195701.GA18201@bhagyashri-Lenovo-G570>

This patch includes modified condition to check for bio struct.

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
