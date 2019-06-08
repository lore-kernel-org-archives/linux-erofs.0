From: hariprasad.kelam@gmail.com (Hariprasad Kelam)
Date: Sat, 8 Jun 2019 15:19:18 +0530
Subject: [PATCH] staging: erofs: make use of DBG_BUGON
Message-ID: <20190608094918.GA11605@hari-Inspiron-1545>

DBG_BUGON is introduced and it could only crash when EROFS_FS_DEBUG
(EROFS developping feature) is on.
replace BUG_ON with DBG_BUGON.

Signed-off-by: Hariprasad Kelam <hariprasad.kelam at gmail.com>
---
 drivers/staging/erofs/unzip_vle.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/unzip_vle.h
index 517e5ce..902e67d 100644
--- a/drivers/staging/erofs/unzip_vle.h
+++ b/drivers/staging/erofs/unzip_vle.h
@@ -147,7 +147,7 @@ static inline unsigned z_erofs_onlinepage_index(struct page *page)
 {
 	union z_erofs_onlinepage_converter u;
 
-	BUG_ON(!PagePrivate(page));
+	DBG_BUGON(!PagePrivate(page));
 	u.v = &page_private(page);
 
 	return atomic_read(u.o) >> Z_EROFS_ONLINEPAGE_INDEX_SHIFT;
@@ -179,7 +179,7 @@ static inline void z_erofs_onlinepage_fixup(struct page *page,
 		if (!index)
 			return;
 
-		BUG_ON(id != index);
+		DBG_BUGON(id != index);
 	}
 
 	v = (index << Z_EROFS_ONLINEPAGE_INDEX_SHIFT) |
@@ -193,7 +193,7 @@ static inline void z_erofs_onlinepage_endio(struct page *page)
 	union z_erofs_onlinepage_converter u;
 	unsigned v;
 
-	BUG_ON(!PagePrivate(page));
+	DBG_BUGON(!PagePrivate(page));
 	u.v = &page_private(page);
 
 	v = atomic_dec_return(u.o);
-- 
2.7.4
