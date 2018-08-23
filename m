From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 23 Aug 2018 14:55:43 +0800
Subject: [chao-linux:erofs-dev 26/29]
 drivers/staging/erofs/unzip_vle.c:1359 z_erofs_vle_normalaccess_readpages()
 warn: should '()->index << 12' be a 64 bit type?
In-Reply-To: <20180823064644.yza5xjztahdirxf3@mwanda>
References: <20180823064644.yza5xjztahdirxf3@mwanda>
Message-ID: <ddc989c6-06ef-f42b-905d-76bc0be8c40f@huawei.com>

Hi Dan,

Thanks for your report. I will make a patch and fix it soon.

Thanks,
Gao Xiang

On 2018/8/23 14:46, Dan Carpenter wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/chao/linux.git erofs-dev
> head:   f05fd191f51bb21e90cd1f74f6362c03945fac45
> commit: 3306d5aab516bdb5d8ba51df88cf0ac5e91e3349 [26/29] staging: erofs: cleanup z_erofs_vle_normalaccess_readpages
> 
> New smatch warnings:
> drivers/staging/erofs/unzip_vle.c:1359 z_erofs_vle_normalaccess_readpages() warn: should '()->index << 12' be a 64 bit type?
> 
> Old smatch warnings:
> drivers/staging/erofs/unzip_vle.c:1322 z_erofs_vle_normalaccess_readpage() warn: should 'page->index << 12' be a 64 bit type?
> 
> # https://git.kernel.org/pub/scm/linux/kernel/git/chao/linux.git/commit/?id=3306d5aab516bdb5d8ba51df88cf0ac5e91e3349
> git remote add chao-linux https://git.kernel.org/pub/scm/linux/kernel/git/chao/linux.git
> git remote update chao-linux
> git checkout 3306d5aab516bdb5d8ba51df88cf0ac5e91e3349
> vim +1359 drivers/staging/erofs/unzip_vle.c
> 
> 3883a79a Gao Xiang 2018-07-26  1341  
> 3306d5aa Gao Xiang 2018-08-21  1342  static int z_erofs_vle_normalaccess_readpages(struct file *filp,
> 3883a79a Gao Xiang 2018-07-26  1343  					      struct address_space *mapping,
> 3306d5aa Gao Xiang 2018-08-21  1344  					      struct list_head *pages,
> 3306d5aa Gao Xiang 2018-08-21  1345  					      unsigned int nr_pages)
> 3883a79a Gao Xiang 2018-07-26  1346  {
> 3883a79a Gao Xiang 2018-07-26  1347  	struct inode *const inode = mapping->host;
> 3306d5aa Gao Xiang 2018-08-21  1348  	struct erofs_sb_info *const sbi = EROFS_I_SB(inode);
> 3306d5aa Gao Xiang 2018-08-21  1349  	const bool sync = __should_decompress_synchronously(sbi, nr_pages);
> 3883a79a Gao Xiang 2018-07-26  1350  
> 3883a79a Gao Xiang 2018-07-26  1351  	struct z_erofs_vle_frontend f = VLE_FRONTEND_INIT(inode);
> 3883a79a Gao Xiang 2018-07-26  1352  	gfp_t gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
> 3883a79a Gao Xiang 2018-07-26  1353  	struct page *head = NULL;
> 3883a79a Gao Xiang 2018-07-26  1354  	LIST_HEAD(pagepool);
> 3883a79a Gao Xiang 2018-07-26  1355  
> 182cb9a7 Chen Gong 2018-08-21  1356  	trace_erofs_readpages(mapping->host, lru_to_page(pages), nr_pages, false);
> 182cb9a7 Chen Gong 2018-08-21  1357  
> 105d4ad8 Gao Xiang 2018-07-26  1358  #if (EROFS_FS_ZIP_CACHE_LVL >= 2)
> 105d4ad8 Gao Xiang 2018-07-26 @1359  	f.cachedzone_la = lru_to_page(pages)->index << PAGE_SHIFT;
> 105d4ad8 Gao Xiang 2018-07-26  1360  #endif
> 3883a79a Gao Xiang 2018-07-26  1361  	for (; nr_pages; --nr_pages) {
> 3883a79a Gao Xiang 2018-07-26  1362  		struct page *page = lru_to_page(pages);
> 3883a79a Gao Xiang 2018-07-26  1363  
> 3883a79a Gao Xiang 2018-07-26  1364  		prefetchw(&page->flags);
> 3883a79a Gao Xiang 2018-07-26  1365  		list_del(&page->lru);
> 3883a79a Gao Xiang 2018-07-26  1366  
> 3883a79a Gao Xiang 2018-07-26  1367  		if (add_to_page_cache_lru(page, mapping, page->index, gfp)) {
> 3883a79a Gao Xiang 2018-07-26  1368  			list_add(&page->lru, &pagepool);
> 3883a79a Gao Xiang 2018-07-26  1369  			continue;
> 3883a79a Gao Xiang 2018-07-26  1370  		}
> 3883a79a Gao Xiang 2018-07-26  1371  
> 3883a79a Gao Xiang 2018-07-26  1372  		BUG_ON(PagePrivate(page));
> 3883a79a Gao Xiang 2018-07-26  1373  		set_page_private(page, (unsigned long)head);
> 3883a79a Gao Xiang 2018-07-26  1374  		head = page;
> 3883a79a Gao Xiang 2018-07-26  1375  	}
> 3883a79a Gao Xiang 2018-07-26  1376  
> 3883a79a Gao Xiang 2018-07-26  1377  	while (head != NULL) {
> 3883a79a Gao Xiang 2018-07-26  1378  		struct page *page = head;
> 3883a79a Gao Xiang 2018-07-26  1379  		int err;
> 3883a79a Gao Xiang 2018-07-26  1380  
> 3883a79a Gao Xiang 2018-07-26  1381  		/* traversal in reverse order */
> 3883a79a Gao Xiang 2018-07-26  1382  		head = (void *)page_private(page);
> 3883a79a Gao Xiang 2018-07-26  1383  
> 3883a79a Gao Xiang 2018-07-26  1384  		err = z_erofs_do_read_page(&f, page, &pagepool);
> 3883a79a Gao Xiang 2018-07-26  1385  		if (err) {
> 3883a79a Gao Xiang 2018-07-26  1386  			struct erofs_vnode *vi = EROFS_V(inode);
> 3883a79a Gao Xiang 2018-07-26  1387  
> 3883a79a Gao Xiang 2018-07-26  1388  			errln("%s, readahead error at page %lu of nid %llu",
> 3883a79a Gao Xiang 2018-07-26  1389  				__func__, page->index, vi->nid);
> 3883a79a Gao Xiang 2018-07-26  1390  		}
> 3883a79a Gao Xiang 2018-07-26  1391  
> 3883a79a Gao Xiang 2018-07-26  1392  		put_page(page);
> 3883a79a Gao Xiang 2018-07-26  1393  	}
> 3883a79a Gao Xiang 2018-07-26  1394  
> 3883a79a Gao Xiang 2018-07-26  1395  	(void)z_erofs_vle_work_iter_end(&f.builder);
> 3883a79a Gao Xiang 2018-07-26  1396  
> 3883a79a Gao Xiang 2018-07-26  1397  	z_erofs_submit_and_unzip(&f, &pagepool, sync);
> 3883a79a Gao Xiang 2018-07-26  1398  
> 3883a79a Gao Xiang 2018-07-26  1399  	if (f.m_iter.mpage != NULL)
> 3883a79a Gao Xiang 2018-07-26  1400  		put_page(f.m_iter.mpage);
> 3883a79a Gao Xiang 2018-07-26  1401  
> 3883a79a Gao Xiang 2018-07-26  1402  	/* clean up the remaining free pages */
> 3883a79a Gao Xiang 2018-07-26  1403  	put_pages_list(&pagepool);
> 3883a79a Gao Xiang 2018-07-26  1404  	return 0;
> 3883a79a Gao Xiang 2018-07-26  1405  }
> 3883a79a Gao Xiang 2018-07-26  1406  
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
