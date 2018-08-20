From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 20 Aug 2018 19:17:37 +0800
Subject: [PATCH] staging: erofs: fix potential overflow in erofs_grab_bio()
In-Reply-To: <20180820110445.36811-1-yuchao0@huawei.com>
References: <20180820110445.36811-1-yuchao0@huawei.com>
Message-ID: <7f76136c-c3c8-0f29-7337-75a551a94a0a@huawei.com>

Hi Chao,

On 2018/8/20 19:04, Chao Yu wrote:
> As Dan reported in LKP's mailing list:
> 
> https://lists.01.org/pipermail/kbuild-all/2018-August/051419.html
> 
> New smatch warnings:
> drivers/staging/erofs/internal.h:446 erofs_grab_bio() warn: should 'blkaddr << (12 - 9)' be a 64 bit type?
> drivers/staging/erofs/data.c:78 __erofs_get_meta_page() error: 'bio' dereferencing possible ERR_PTR()
> drivers/staging/erofs/internal.h:446 erofs_grab_bio() warn: should 'blkaddr << (12 - 9)' be a 64 bit type?
> 
> Old smatch warnings:
> drivers/staging/erofs/unzip_vle.c:989 z_erofs_vle_unzip() error: double unlock 'mutex:&z_pagemap_global_lock'
> drivers/staging/erofs/unzip_vle.c:1318 z_erofs_vle_normalaccess_readpage() warn: should 'page->index << 12' be a 64 bit type?
> drivers/staging/erofs/unzip_vle.c:1351 __z_erofs_vle_normalaccess_readpages() warn: should '()->index << 12' be a 64 bit type?
> 
> It needs to cast varable's type to sector_t before left shifting.
> 
> Reported-by: Dan Carpenter <dan.carpenter at oracle.com>
> Signed-off-by: Chao Yu <yuchao0 at huawei.com>
> ---

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

It seems there is another issue reported in __erofs_get_meta_page...
https://git.kernel.org/pub/scm/linux/kernel/git/chao/linux.git/tree/drivers/staging/erofs/data.c?h=erofs-dev#n66

if (unlikely(bio == NULL)) { ===> if (IS_ERR(bio))

Thanks,
Gao Xiang
