From: gaoxiang25@huawei.com (g00380047)
Date: Sat, 13 Oct 2018 01:23:12 +0800
Subject: [WIP] [NOMERGE] [PATCH] staging: erofs: fix a missing case in
 `z_erofs_do_read_page'
Message-ID: <20181012172312.3442-1-gaoxiang25@huawei.com>

From: Gao Xiang <gaoxiang25@huawei.com>

Note that `z_erofs_vle_work_iter_begin' could fail due to OOM,
for instance. In that case, PG_error will be set for the current
page and that is fine. However, if it goes on to handle the next
page, `z_erofs_vle_work_iter_begin' would be skipped due to
the valid `map_blocks' and the following unexpected behaviors
could happen. Let's fix it now.

SLUB: Unable to allocate memory on node -1, gfp=0x2408040(GFP_NOFS|__GFP_ZERO)
  cache: erofs_compress, object size: 144, buffer size: 144, default order: 0, min order: 0
  node 0: slabs: 98, objs: 2744, free: 0
erofs: z_erofs_vle_normalaccess_readpages, readahead error at page 1008 of nid 5391488
...
PC is at z_erofs_vle_work_add_page+0xa0/0x17c
LR is at z_erofs_do_read_page+0x12c/0xcf0
...
 z_erofs_vle_work_add_page+0xa0/0x17c
 z_erofs_vle_normalaccess_readpages+0x1a0/0x37c
 read_pages+0x70/0x190
 __do_page_cache_readahead+0x194/0x1a8
 filemap_fault+0x398/0x684
 __do_fault+0x8c/0x138
 handle_pte_fault+0x730/0xb7c
 __handle_mm_fault+0xac/0xf4
 handle_mm_fault+0x7c/0x118
 do_page_fault+0x354/0x474
 do_translation_fault+0x40/0x48
 do_mem_abort+0x80/0x100

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---

please ignore this patch since it is still work-in-progress.

Thanks,
Gao Xiang

 drivers/staging/erofs/unzip_vle.c | 62 +++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 79d3ba62b298..96e832a538e1 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -583,9 +583,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	struct erofs_map_blocks *const map = &m->map;
 	struct z_erofs_vle_work_builder *const builder = &fe->builder;
 	const loff_t offset = page_offset(page);
-
-	bool tight = builder_is_followed(builder);
-	struct z_erofs_vle_work *work = builder->work;
+	bool tight = true;
 
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
 	struct address_space *const mngda = sbi->managed_cache->i_mapping;
@@ -593,8 +591,10 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	bool noio_outoforder;
 #endif
 
+	struct z_erofs_vle_work *work;
 	enum z_erofs_page_type page_type;
 	unsigned int cur, end, spiltted, index;
+	bool dontremap;
 	int err = 0;
 
 	trace_erofs_readpage(page, false);
@@ -606,48 +606,52 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	end = PAGE_SIZE;
 repeat:
 	cur = end - 1;
+	dontremap = offset + cur >= map->m_la &&
+		    offset + cur < map->m_la + map->m_llen;
 
-	/* lucky, within the range of the current map_blocks */
-	if (offset + cur >= map->m_la &&
-		offset + cur < map->m_la + map->m_llen)
-		goto hitted;
-
-	/* go ahead the next map_blocks */
-	debugln("%s: [out-of-range] pos %llu", __func__, offset + cur);
+	if (!dontremap) {
+		/*
+		 * finalize the last decompression work, turn off `initial'
+		 * if the previous work was actually available.
+		 */
+		if (z_erofs_vle_work_iter_end(builder))
+			fe->initial = false;
 
-	if (z_erofs_vle_work_iter_end(builder))
-		fe->initial = false;
+		map->m_la = offset + cur;
+		map->m_llen = 0;
 
-	map->m_la = offset + cur;
-	map->m_llen = 0;
-	err = erofs_map_blocks_iter(fe->inode, map, &m->mpage, 0);
-	if (unlikely(err))
-		goto err_out;
+		err = erofs_map_blocks_iter(fe->inode, map, &m->mpage, 0);
+		if (unlikely(err))
+			goto err_out;
+	}
 
 	if (unlikely(!(map->m_flags & EROFS_MAP_MAPPED)))
 		goto hitted;
 
-	DBG_BUGON(map->m_plen != 1 << sbi->clusterbits);
-	DBG_BUGON(erofs_blkoff(map->m_pa));
+	if (!(dontremap && builder->work)) {
+		DBG_BUGON(map->m_plen != 1 << sbi->clusterbits);
+		DBG_BUGON(erofs_blkoff(map->m_pa));
 
-	err = z_erofs_vle_work_iter_begin(builder, sb, map, &fe->owned_head);
-	if (unlikely(err))
-		goto err_out;
+		err = z_erofs_vle_work_iter_begin(builder, sb,
+						  map, &fe->owned_head);
+		if (unlikely(err))
+			goto err_out;
 
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
-	grp = fe->builder.grp;
+		grp = fe->builder.grp;
 
-	/* let's do out-of-order decompression for noio */
-	noio_outoforder = grab_managed_cache_pages(mngda,
-		erofs_blknr(map->m_pa),
-		grp->compressed_pages, erofs_blknr(map->m_plen),
+		/* let's do out-of-order decompression for noio */
+		noio_outoforder = grab_managed_cache_pages(mngda,
+			erofs_blknr(map->m_pa),
+			grp->compressed_pages, erofs_blknr(map->m_plen),
 		/* compressed page caching selection strategy */
 		fe->initial | (EROFS_FS_ZIP_CACHE_LVL >= 2 ?
 			map->m_la < fe->cachedzone_la : 0));
 
-	if (noio_outoforder && builder_is_followed(builder))
-		builder->role = Z_EROFS_VLE_WORK_PRIMARY;
+		if (noio_outoforder && builder_is_followed(builder))
+			builder->role = Z_EROFS_VLE_WORK_PRIMARY;
 #endif
+	}
 
 	tight &= builder_is_followed(builder);
 	work = builder->work;
-- 
2.14.4
