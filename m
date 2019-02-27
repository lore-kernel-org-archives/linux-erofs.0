From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 27 Feb 2019 20:43:37 +0800
Subject: [PATCH 1/3] staging: erofs: compressed_pages should not be
 accessed again after freed
In-Reply-To: <20190227053332.38504-1-gaoxiang25@huawei.com>
References: <20190227053332.38504-1-gaoxiang25@huawei.com>
Message-ID: <55e62c67-81db-e7c9-0ff0-fb4909e2fbc0@huawei.com>

On 2019/2/27 13:33, Gao Xiang wrote:
> This patch resolves the following page use-after-free issue,
> z_erofs_vle_unzip:
>     ...
>     for (i = 0; i < nr_pages; ++i) {
>         ...
>         z_erofs_onlinepage_endio(page);  (1)
>     }
> 
>     for (i = 0; i < clusterpages; ++i) {
>         page = compressed_pages[i];
> 
>         if (page->mapping == mngda)      (2)
>             continue;
>         /* recycle all individual staging pages */
>         (void)z_erofs_gather_if_stagingpage(page_pool, page); (3)
>         WRITE_ONCE(compressed_pages[i], NULL);
>     }
>     ...
> 
> After (1) is executed, page is freed and could be then reused, if
> compressed_pages is scanned after that, it could fall info (2) or
> (3) by mistake and that could finally be in a mess.
> 
> This patch aims to solve the above issue only with little changes
> as much as possible in order to make the fix backport easier.
> 
> Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
> Cc: <stable at vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
