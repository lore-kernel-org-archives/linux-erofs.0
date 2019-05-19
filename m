From: hariprasad.kelam@gmail.com (Hariprasad Kelam)
Date: Sun, 19 May 2019 15:04:40 +0530
Subject: [Patch v2] staging: erofs: fix Warning Use BUG_ON instead of if
 condition followed by BUG
Message-ID: <20190519093440.GA16838@hari-Inspiron-1545>

fix below warning reported by  coccicheck

drivers/staging/erofs/unzip_pagevec.h:74:2-5: WARNING: Use BUG_ON
instead of if condition followed by BUG.

Signed-off-by: Hariprasad Kelam <hariprasad.kelam at gmail.com>
-----
Changes in v2:
  - replace BUG_ON with  DBG_BUGON
-----
---
 drivers/staging/erofs/unzip_pagevec.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/unzip_pagevec.h b/drivers/staging/erofs/unzip_pagevec.h
index f37d8fd..7938ee3 100644
--- a/drivers/staging/erofs/unzip_pagevec.h
+++ b/drivers/staging/erofs/unzip_pagevec.h
@@ -70,8 +70,7 @@ z_erofs_pagevec_ctor_next_page(struct z_erofs_pagevec_ctor *ctor,
 			return tagptr_unfold_ptr(t);
 	}
 
-	if (unlikely(nr >= ctor->nr))
-		BUG();
+	DBG_BUGON(nr >= ctor->nr);
 
 	return NULL;
 }
-- 
2.7.4
