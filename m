From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 20 Aug 2018 23:36:41 +0800
Subject: [PATCH] staging: erofs: fix error handling in
 __erofs_get_meta_page
In-Reply-To: <8316478d-940b-abbb-ca6d-bc4283d06a66@kernel.org>
References: <1534771743-129893-1-git-send-email-gaoxiang25@huawei.com>
 <8316478d-940b-abbb-ca6d-bc4283d06a66@kernel.org>
Message-ID: <4c9d06ce-7a03-f99b-9691-2110ebf9b0b1@aol.com>

Hi Chao,

On 2018/8/20 22:59, Chao Yu wrote:
> On 2018/8/20 21:29, Gao Xiang wrote:
>> As Dan reported in LKP's mailing list:
>>
>> https://lists.01.org/pipermail/kbuild-all/2018-August/051419.html
>>
>> New smatch warnings:
>> drivers/staging/erofs/internal.h:446 erofs_grab_bio() warn: should 'blkaddr << (12 - 9)' be a 64 bit type?
>> drivers/staging/erofs/data.c:78 __erofs_get_meta_page() error: 'bio' dereferencing possible ERR_PTR()
>> drivers/staging/erofs/internal.h:446 erofs_grab_bio() warn: should 'blkaddr << (12 - 9)' be a 64 bit type?
>>
>> Old smatch warnings:
>> drivers/staging/erofs/unzip_vle.c:989 z_erofs_vle_unzip() error: double unlock 'mutex:&z_pagemap_global_lock'
>> drivers/staging/erofs/unzip_vle.c:1318 z_erofs_vle_normalaccess_readpage() warn: should 'page->index << 12' be a 64 bit type?
>> drivers/staging/erofs/unzip_vle.c:1351 __z_erofs_vle_normalaccess_readpages() warn: should '()->index << 12' be a 64 bit type?
>>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>> ---
>> Hi Chao,
>>
>> Could you please fold this patch in the previous patch if it is convenient?
>> `staging: erofs: separate erofs_get_meta_page'
>>
>> It seems v2 of these patches has not been sent out to the staging mailing list.
>> LINK: https://lore.kernel.org/lkml/ffd2748a-273f-792b-d418-2fcf85c3d45f at huawei.com/
> Hi Xiang,
> 
> Let me merge this into previous buggy one. :)
> 
> Thanks,
> 

Thanks for your quick patching :)

one more picky...
LINK:
https://git.kernel.org/pub/scm/linux/kernel/git/chao/linux.git/tree/drivers/staging/erofs/data.c?h=erofs&id=418b414392c2b6e588670a672489dfd015d80bc1#n66

if (unlikely(IS_ERR(bio))) {  ===>  if (IS_ERR(bio)) {

since

#define IS_ERR_VALUE(x) unlikely((unsigned long)(void *)(x) >= (unsigned
long)-MAX_ERRNO)

static inline bool __must_check IS_ERR(__force const void *ptr)
{
	return IS_ERR_VALUE((unsigned long)ptr);
}

Thanks,
Gao Xiang
