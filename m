From: julia.lawall@lip6.fr (Julia Lawall)
Date: Tue, 3 Jul 2018 09:13:03 +0200 (CEST)
Subject: [chao-linux:erofs-dev 24/33] fs/erofs/unzip_vle.c:651:1-7:
 preceding lock on line 509
In-Reply-To: <923d1ae9-3bc7-f070-050b-087a356c7702@huawei.com>
References: <201807031201.90hBVFTJ%fengguang.wu@intel.com>
 <alpine.DEB.2.20.1807030724250.2333@hadrien>
 <923d1ae9-3bc7-f070-050b-087a356c7702@huawei.com>
Message-ID: <alpine.DEB.2.20.1807030911350.3965@hadrien>



On Tue, 3 Jul 2018, Gao Xiang wrote:

> Hi Julia,
>
> On 2018/7/3 13:27, Julia Lawall wrote:
> > Hello,
> >
> > There is not actually a bug here, but I wonder if the backwards goto int
> > another if branch (use_global_pagemap) is really the best way to do this?
> > I found it rather confusing to think about.  It could be better to just
> > duplicate the assignment to pages, or make a flag that would be tested
> > after the if-else.
> >
>
> I wrote this code just because of the designed pagemap allocation policy:
>
> If the pagemap is too large enough to alloc onstack, then
>     I try to use the global pagemap with "trylock" if the global pagemap is not occupied.
>     or if the global pagemap is occupied,
>          alloc a pagemap if the corresponding memory allocation is ok,
>          or if the memory allocation is failed, fall back to use the global pagemap with sleeping "lock" again.
>
> If the code style makes automatic testing confused, I could use alternative way to replace it in the next version.

In the end, I understood the structure, but I think that a backwards goto
into another if branch is a bit of mental overload.

julia

>
> Thanks for your caring and report. :)
>
> Thanks,
> Gao Xiang
>
> > julia
> >
> > On Tue, 3 Jul 2018, kbuild test robot wrote:
> >
> >>
> >> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/chao/linux.git erofs-dev
> >> head:   17811ace07ef1cec14913201833ea69ac3243d3a
> >> commit: 477609336cc282eac2aff56f5071be42be208867 [24/33] erofs: introduce VLE decompression subsystem
> >> :::::: branch date: 13 hours ago
> >> :::::: commit date: 13 hours ago
> >>
> >>>> fs/erofs/unzip_vle.c:651:1-7: preceding lock on line 509
> >>
> >> # https://git.kernel.org/pub/scm/linux/kernel/git/chao/linux.git/commit/?id=477609336cc282eac2aff56f5071be42be208867
> >> git remote add chao-linux https://git.kernel.org/pub/scm/linux/kernel/git/chao/linux.git
> >> git remote update chao-linux
> >> git checkout 477609336cc282eac2aff56f5071be42be208867
> >> vim +651 fs/erofs/unzip_vle.c
> >>
> >> 47760933 Gao Xiang 2018-07-02  474
> >> 47760933 Gao Xiang 2018-07-02  475  static int z_erofs_vle_unzip(struct super_block *sb,
> >> 47760933 Gao Xiang 2018-07-02  476  	struct z_erofs_vle_work *work,
> >> 47760933 Gao Xiang 2018-07-02  477  	bool cached, struct list_head *page_pool)
> >> 47760933 Gao Xiang 2018-07-02  478  {
> >> 47760933 Gao Xiang 2018-07-02  479  	unsigned clusterpages = erofs_clusterpages(EROFS_SB(sb));
> >> 47760933 Gao Xiang 2018-07-02  480  	struct z_erofs_pagevec_ctor ctor;
> >> 47760933 Gao Xiang 2018-07-02  481  	unsigned nr_pages;
> >> 47760933 Gao Xiang 2018-07-02  482  	struct page *pages_onstack[Z_EROFS_VLE_VMAP_ONSTACK_PAGES];
> >> 47760933 Gao Xiang 2018-07-02  483  	struct page **pages, **compressed_pages, *page;
> >> 47760933 Gao Xiang 2018-07-02  484  	unsigned i, llen;
> >> 47760933 Gao Xiang 2018-07-02  485
> >> 47760933 Gao Xiang 2018-07-02  486  	enum z_erofs_page_type page_type;
> >> 47760933 Gao Xiang 2018-07-02  487  	bool overlapped;
> >> 47760933 Gao Xiang 2018-07-02  488  	struct z_erofs_vle_workgroup *grp;
> >> 47760933 Gao Xiang 2018-07-02  489  	void *vout;
> >> 47760933 Gao Xiang 2018-07-02  490  	int err;
> >> 47760933 Gao Xiang 2018-07-02  491
> >> 47760933 Gao Xiang 2018-07-02  492  	BUG_ON(!READ_ONCE(work->nr_pages));
> >> 47760933 Gao Xiang 2018-07-02  493  	might_sleep();
> >> 47760933 Gao Xiang 2018-07-02  494
> >> 47760933 Gao Xiang 2018-07-02  495  	mutex_lock(&work->lock);
> >> 47760933 Gao Xiang 2018-07-02  496  	nr_pages = work->nr_pages;
> >> 47760933 Gao Xiang 2018-07-02  497
> >> 47760933 Gao Xiang 2018-07-02  498  	if (likely(nr_pages <= Z_EROFS_VLE_VMAP_ONSTACK_PAGES))
> >> 47760933 Gao Xiang 2018-07-02  499  		pages = pages_onstack;
> >> 47760933 Gao Xiang 2018-07-02  500  	else if (nr_pages <= Z_EROFS_VLE_VMAP_GLOBAL_PAGES &&
> >> 47760933 Gao Xiang 2018-07-02  501  		mutex_trylock(&z_pagemap_global_lock))
> >> 47760933 Gao Xiang 2018-07-02  502  use_global_pagemap:
> >> 47760933 Gao Xiang 2018-07-02  503  		pages = z_pagemap_global;
> >> 47760933 Gao Xiang 2018-07-02  504  	else {
> >> 47760933 Gao Xiang 2018-07-02  505  		pages = kvmalloc(nr_pages, GFP_KERNEL | __GFP_NOFAIL);
> >> 47760933 Gao Xiang 2018-07-02  506
> >> 47760933 Gao Xiang 2018-07-02  507  		/* fallback to global pagemap for the lowmem scenario */
> >> 47760933 Gao Xiang 2018-07-02  508  		if (unlikely(pages == NULL)) {
> >> 47760933 Gao Xiang 2018-07-02 @509  			mutex_lock(&z_pagemap_global_lock);
> >> 47760933 Gao Xiang 2018-07-02  510  			goto use_global_pagemap;
> >> 47760933 Gao Xiang 2018-07-02  511  		}
> >> 47760933 Gao Xiang 2018-07-02  512  	}
> >> 47760933 Gao Xiang 2018-07-02  513
> >> 47760933 Gao Xiang 2018-07-02  514  	for (i = 0; i < nr_pages; ++i)
> >> 47760933 Gao Xiang 2018-07-02  515  		pages[i] = NULL;
> >> 47760933 Gao Xiang 2018-07-02  516
> >> 47760933 Gao Xiang 2018-07-02  517  	z_erofs_pagevec_ctor_init(&ctor,
> >> 47760933 Gao Xiang 2018-07-02  518  		Z_EROFS_VLE_INLINE_PAGEVECS, work->pagevec, 0);
> >> 47760933 Gao Xiang 2018-07-02  519
> >> 47760933 Gao Xiang 2018-07-02  520  	for (i = 0; i < work->vcnt; ++i) {
> >> 47760933 Gao Xiang 2018-07-02  521  		unsigned pagenr;
> >> 47760933 Gao Xiang 2018-07-02  522
> >> 47760933 Gao Xiang 2018-07-02  523  		page = z_erofs_pagevec_ctor_dequeue(&ctor, &page_type);
> >> 47760933 Gao Xiang 2018-07-02  524  		BUG_ON(!page);
> >> 47760933 Gao Xiang 2018-07-02  525
> >> 47760933 Gao Xiang 2018-07-02  526  		if (page->mapping == NULL) {
> >> 47760933 Gao Xiang 2018-07-02  527  			list_add(&page->lru, page_pool);
> >> 47760933 Gao Xiang 2018-07-02  528  			continue;
> >> 47760933 Gao Xiang 2018-07-02  529  		}
> >> 47760933 Gao Xiang 2018-07-02  530
> >> 47760933 Gao Xiang 2018-07-02  531  		if (page_type == Z_EROFS_VLE_PAGE_TYPE_HEAD)
> >> 47760933 Gao Xiang 2018-07-02  532  			pagenr = 0;
> >> 47760933 Gao Xiang 2018-07-02  533  		else
> >> 47760933 Gao Xiang 2018-07-02  534  			pagenr = z_erofs_onlinepage_index(page);
> >> 47760933 Gao Xiang 2018-07-02  535
> >> 47760933 Gao Xiang 2018-07-02  536  		BUG_ON(pagenr >= nr_pages);
> >> 47760933 Gao Xiang 2018-07-02  537
> >> 47760933 Gao Xiang 2018-07-02  538  #ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
> >> 47760933 Gao Xiang 2018-07-02  539  		BUG_ON(pages[pagenr] != NULL);
> >> 47760933 Gao Xiang 2018-07-02  540  #endif
> >> 47760933 Gao Xiang 2018-07-02  541  		pages[pagenr] = page;
> >> 47760933 Gao Xiang 2018-07-02  542  	}
> >> 47760933 Gao Xiang 2018-07-02  543
> >> 47760933 Gao Xiang 2018-07-02  544  	z_erofs_pagevec_ctor_exit(&ctor, true);
> >> 47760933 Gao Xiang 2018-07-02  545
> >> 47760933 Gao Xiang 2018-07-02  546  	overlapped = false;
> >> 47760933 Gao Xiang 2018-07-02  547  	if (cached) {
> >> 47760933 Gao Xiang 2018-07-02  548  		grp = z_erofs_vle_work_workgroup(work);
> >> 47760933 Gao Xiang 2018-07-02  549  		compressed_pages = z_erofs_vle_cached_managed(grp);
> >> 47760933 Gao Xiang 2018-07-02  550  	} else {
> >> 47760933 Gao Xiang 2018-07-02  551  		grp = z_erofs_vle_work_workgroup(work);
> >> 47760933 Gao Xiang 2018-07-02  552  		compressed_pages = z_erofs_vle_work_uncached_mux(work);
> >> 47760933 Gao Xiang 2018-07-02  553
> >> 47760933 Gao Xiang 2018-07-02  554  		for(i = 0; i < clusterpages; ++i) {
> >> 47760933 Gao Xiang 2018-07-02  555  			unsigned pagenr;
> >> 47760933 Gao Xiang 2018-07-02  556
> >> 47760933 Gao Xiang 2018-07-02  557  			BUG_ON(compressed_pages[i] == NULL);
> >> 47760933 Gao Xiang 2018-07-02  558  			page = compressed_pages[i];
> >> 47760933 Gao Xiang 2018-07-02  559
> >> 47760933 Gao Xiang 2018-07-02  560  			if (page->mapping == NULL)
> >> 47760933 Gao Xiang 2018-07-02  561  				continue;
> >> 47760933 Gao Xiang 2018-07-02  562
> >> 47760933 Gao Xiang 2018-07-02  563  			pagenr = z_erofs_onlinepage_index(page);
> >> 47760933 Gao Xiang 2018-07-02  564
> >> 47760933 Gao Xiang 2018-07-02  565  			BUG_ON(pagenr >= nr_pages);
> >> 47760933 Gao Xiang 2018-07-02  566  #ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
> >> 47760933 Gao Xiang 2018-07-02  567  			BUG_ON(pages[pagenr] != NULL);
> >> 47760933 Gao Xiang 2018-07-02  568  #endif
> >> 47760933 Gao Xiang 2018-07-02  569  			pages[pagenr] = page;
> >> 47760933 Gao Xiang 2018-07-02  570
> >> 47760933 Gao Xiang 2018-07-02  571  			overlapped = true;
> >> 47760933 Gao Xiang 2018-07-02  572  		}
> >> 47760933 Gao Xiang 2018-07-02  573  	}
> >> 47760933 Gao Xiang 2018-07-02  574
> >> 47760933 Gao Xiang 2018-07-02  575  	llen = (nr_pages << PAGE_SHIFT) - work->pageofs;
> >> 47760933 Gao Xiang 2018-07-02  576
> >> 47760933 Gao Xiang 2018-07-02  577  	if (z_erofs_vle_workgroup_fmt(grp) == Z_EROFS_WORK_FORMAT_PLAIN) {
> >> 47760933 Gao Xiang 2018-07-02  578  		BUG_ON(grp->llen != llen);
> >> 47760933 Gao Xiang 2018-07-02  579
> >> 47760933 Gao Xiang 2018-07-02  580  		err = z_erofs_vle_plain_copy(compressed_pages, clusterpages,
> >> 47760933 Gao Xiang 2018-07-02  581  			pages, nr_pages, work->pageofs);
> >> 47760933 Gao Xiang 2018-07-02  582  		goto out;
> >> 47760933 Gao Xiang 2018-07-02  583  	}
> >> 47760933 Gao Xiang 2018-07-02  584
> >> 47760933 Gao Xiang 2018-07-02  585  	if (llen > grp->llen)
> >> 47760933 Gao Xiang 2018-07-02  586  		llen = grp->llen;
> >> 47760933 Gao Xiang 2018-07-02  587
> >> 47760933 Gao Xiang 2018-07-02  588  	err = z_erofs_vle_unzip_fast_percpu(compressed_pages,
> >> 47760933 Gao Xiang 2018-07-02  589  		clusterpages, pages, llen, work->pageofs);
> >> 47760933 Gao Xiang 2018-07-02  590  	if (err != -ENOTSUPP)
> >> 47760933 Gao Xiang 2018-07-02  591  		goto out;
> >> 47760933 Gao Xiang 2018-07-02  592
> >> 47760933 Gao Xiang 2018-07-02  593  #ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
> >> 47760933 Gao Xiang 2018-07-02  594  	if (work->vcnt == nr_pages)
> >> 47760933 Gao Xiang 2018-07-02  595  		goto skip_allocpage;
> >> 47760933 Gao Xiang 2018-07-02  596  #endif
> >> 47760933 Gao Xiang 2018-07-02  597
> >> 47760933 Gao Xiang 2018-07-02  598  	for (i = 0; i < nr_pages; ++i) {
> >> 47760933 Gao Xiang 2018-07-02  599  		if (pages[i] != NULL)
> >> 47760933 Gao Xiang 2018-07-02  600  			continue;
> >> 47760933 Gao Xiang 2018-07-02  601  		pages[i] = erofs_allocpage(page_pool, GFP_KERNEL);
> >> 47760933 Gao Xiang 2018-07-02  602  	}
> >> 47760933 Gao Xiang 2018-07-02  603
> >> 47760933 Gao Xiang 2018-07-02  604  #ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
> >> 47760933 Gao Xiang 2018-07-02  605  skip_allocpage:
> >> 47760933 Gao Xiang 2018-07-02  606  #endif
> >> 47760933 Gao Xiang 2018-07-02  607  	vout = erofs_vmap(pages, nr_pages);
> >> 47760933 Gao Xiang 2018-07-02  608
> >> 47760933 Gao Xiang 2018-07-02  609  	err = z_erofs_vle_unzip_vmap(compressed_pages,
> >> 47760933 Gao Xiang 2018-07-02  610  		clusterpages, vout, llen, work->pageofs, overlapped);
> >> 47760933 Gao Xiang 2018-07-02  611
> >> 47760933 Gao Xiang 2018-07-02  612  	erofs_vunmap(vout, nr_pages);
> >> 47760933 Gao Xiang 2018-07-02  613
> >> 47760933 Gao Xiang 2018-07-02  614  out:
> >> 47760933 Gao Xiang 2018-07-02  615  	for (i = 0; i < nr_pages; ++i) {
> >> 47760933 Gao Xiang 2018-07-02  616  		page = pages[i];
> >> 47760933 Gao Xiang 2018-07-02  617
> >> 47760933 Gao Xiang 2018-07-02  618  		/* recycle all individual pages */
> >> 47760933 Gao Xiang 2018-07-02  619  		if (page->mapping == NULL) {
> >> 47760933 Gao Xiang 2018-07-02  620  			list_add(&page->lru, page_pool);
> >> 47760933 Gao Xiang 2018-07-02  621  			continue;
> >> 47760933 Gao Xiang 2018-07-02  622  		}
> >> 47760933 Gao Xiang 2018-07-02  623
> >> 47760933 Gao Xiang 2018-07-02  624  		if (unlikely(err < 0))
> >> 47760933 Gao Xiang 2018-07-02  625  			SetPageError(page);
> >> 47760933 Gao Xiang 2018-07-02  626
> >> 47760933 Gao Xiang 2018-07-02  627  		z_erofs_onlinepage_endio(page);
> >> 47760933 Gao Xiang 2018-07-02  628  	}
> >> 47760933 Gao Xiang 2018-07-02  629
> >> 47760933 Gao Xiang 2018-07-02  630  	for (i = 0; i < clusterpages; ++i) {
> >> 47760933 Gao Xiang 2018-07-02  631  		page = compressed_pages[i];
> >> 47760933 Gao Xiang 2018-07-02  632
> >> 47760933 Gao Xiang 2018-07-02  633  		/* recycle all individual pages */
> >> 47760933 Gao Xiang 2018-07-02  634  		if (page->mapping == NULL)
> >> 47760933 Gao Xiang 2018-07-02  635  			list_add(&page->lru, page_pool);
> >> 47760933 Gao Xiang 2018-07-02  636
> >> 47760933 Gao Xiang 2018-07-02  637  		if (!cached)
> >> 47760933 Gao Xiang 2018-07-02  638  			WRITE_ONCE(compressed_pages[i], NULL);
> >> 47760933 Gao Xiang 2018-07-02  639  	}
> >> 47760933 Gao Xiang 2018-07-02  640
> >> 47760933 Gao Xiang 2018-07-02  641  	if (pages == z_pagemap_global)
> >> 47760933 Gao Xiang 2018-07-02  642  		mutex_unlock(&z_pagemap_global_lock);
> >> 47760933 Gao Xiang 2018-07-02  643  	else if (unlikely(pages != pages_onstack))
> >> 47760933 Gao Xiang 2018-07-02  644  		kvfree(pages);
> >> 47760933 Gao Xiang 2018-07-02  645
> >> 47760933 Gao Xiang 2018-07-02  646  	work->nr_pages = 0;
> >> 47760933 Gao Xiang 2018-07-02  647  	work->vcnt = 0;
> >> 47760933 Gao Xiang 2018-07-02  648
> >> 47760933 Gao Xiang 2018-07-02  649  	WRITE_ONCE(work->next, Z_EROFS_WORK_TPTR_NIL);
> >> 47760933 Gao Xiang 2018-07-02  650  	mutex_unlock(&work->lock);
> >> 47760933 Gao Xiang 2018-07-02 @651  	return err;
> >> 47760933 Gao Xiang 2018-07-02  652  }
> >> 47760933 Gao Xiang 2018-07-02  653
> >>
> >> ---
> >> 0-DAY kernel test infrastructure                Open Source Technology Center
> >> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> >>
>
