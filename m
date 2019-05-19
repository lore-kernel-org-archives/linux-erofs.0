From: hsiangkao@aol.com (Gao Xiang)
Date: Sun, 19 May 2019 17:35:57 +0800
Subject: [PATCH v2] staging: erofs: fix Warning Use BUG_ON instead of if
 condition followed by BUG
In-Reply-To: <20190518173331.GA1069@hari-Inspiron-1545>
References: <20190518173331.GA1069@hari-Inspiron-1545>
Message-ID: <20190519093557.20982-1-hsiangkao@aol.com>

From: Hariprasad Kelam <hariprasad.kelam@gmail.com>

fix below warning reported by  coccicheck

drivers/staging/erofs/unzip_pagevec.h:74:2-5: WARNING: Use BUG_ON
instead of if condition followed by BUG.

Signed-off-by: Hariprasad Kelam <hariprasad.kelam at gmail.com>
[ Gao Xiang: use DBG_BUGON instead of BUG_ON for eng version only. ]
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
change log v2:
 - use DBG_BUGON as what said in the commit message.

Thanks,
Gao Xiang

 drivers/staging/erofs/unzip_pagevec.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/erofs/unzip_pagevec.h b/drivers/staging/erofs/unzip_pagevec.h
index f37d8fd14771..7af0ba8d8495 100644
--- a/drivers/staging/erofs/unzip_pagevec.h
+++ b/drivers/staging/erofs/unzip_pagevec.h
@@ -69,10 +69,7 @@ z_erofs_pagevec_ctor_next_page(struct z_erofs_pagevec_ctor *ctor,
 		if (tags == Z_EROFS_PAGE_TYPE_EXCLUSIVE)
 			return tagptr_unfold_ptr(t);
 	}
-
-	if (unlikely(nr >= ctor->nr))
-		BUG();
-
+	DBG_BUGON(nr >= ctor->nr);
 	return NULL;
 }
 
-- 
2.17.1
