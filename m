From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 11 Aug 2018 04:10:38 +0800
Subject: [PREVIEW] [PATCH v2 10/10] staging: erofs: complete error handing of
 z_erofs_do_read_page
In-Reply-To: <1533931838-47642-1-git-send-email-gaoxiang25@huawei.com>
References: <1533931838-47642-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1533931838-47642-10-git-send-email-gaoxiang25@huawei.com>

This patch completes error handing code of z_erofs_do_read_page.
PG_error will be set when some read error happens, therefore
z_erofs_onlinepage_endio will unlock this page without setting
PG_uptodate.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
change log v2:
 - spilt into small patches at Chao's suggestion.

 drivers/staging/erofs/unzip_vle.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 1f64cb1..1d0ffa6 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -611,7 +611,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 
 	enum z_erofs_page_type page_type;
 	unsigned cur, end, spiltted, index;
-	int err;
+	int err = 0;
 
 	/* register locked file pages as online pages in pack */
 	z_erofs_onlinepage_init(page);
@@ -638,12 +638,11 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	if (unlikely(err))
 		goto err_out;
 
-	/* deal with hole (FIXME! broken now) */
 	if (unlikely(!(map->m_flags & EROFS_MAP_MAPPED)))
 		goto hitted;
 
 	DBG_BUGON(map->m_plen != 1 << sbi->clusterbits);
-	BUG_ON(erofs_blkoff(map->m_pa));
+	DBG_BUGON(erofs_blkoff(map->m_pa));
 
 	err = z_erofs_vle_work_iter_begin(builder, sb, map, &fe->owned_head);
 	if (unlikely(err))
@@ -688,7 +687,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 
 		err = z_erofs_vle_work_add_page(builder,
 			newpage, Z_EROFS_PAGE_TYPE_EXCLUSIVE);
-		if (!err)
+		if (likely(!err))
 			goto retry;
 	}
 
@@ -699,9 +698,10 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 
 	/* FIXME! avoid the last relundant fixup & endio */
 	z_erofs_onlinepage_fixup(page, index, true);
-	++spiltted;
 
-	/* also update nr_pages and increase queued_pages */
+	/* bump up the number of spiltted parts of a page */
+	++spiltted;
+	/* also update nr_pages */
 	work->nr_pages = max_t(pgoff_t, work->nr_pages, index + 1);
 next_part:
 	/* can be used for verification */
@@ -711,16 +711,18 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	if (end > 0)
 		goto repeat;
 
+out:
 	/* FIXME! avoid the last relundant fixup & endio */
 	z_erofs_onlinepage_endio(page);
 
 	debugln("%s, finish page: %pK spiltted: %u map->m_llen %llu",
 		__func__, page, spiltted, map->m_llen);
-	return 0;
+	return err;
 
+	/* if some error occurred while processing this page */
 err_out:
-	/* TODO: the missing error handing cases */
-	return err;
+	SetPageError(page);
+	goto out;
 }
 
 static void z_erofs_vle_unzip_kickoff(void *ptr, int bios)
-- 
1.9.1
