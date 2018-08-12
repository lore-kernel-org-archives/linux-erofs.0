From: hsiangkao@aol.com (Gao Xiang)
Date: Sun, 12 Aug 2018 19:28:28 +0800
Subject: [PREVIEW] [PATCH v3 2/3] staging: erofs: separate
 erofs_get_meta_page
In-Reply-To: <939470bb-4035-a9a0-7b3d-bb05da10d72e@kernel.org>
References: <cb3eadc7-c71e-6132-5189-ab34e247271b@huawei.com>
 <1533919730-117224-1-git-send-email-gaoxiang25@huawei.com>
 <939470bb-4035-a9a0-7b3d-bb05da10d72e@kernel.org>
Message-ID: <7b9d9b37-b880-927b-f1e3-083cff6233d8@aol.com>

Hi Chao,

On 2018/8/12 18:54, Chao Yu wrote:
> On 2018/8/11 0:48, Gao Xiang wrote:
>> This patch separates 'erofs_get_meta_page' into 'erofs_get_meta_page'
>> and 'erofs_get_meta_page_nofail'. The second one ensures that it
>> should not fail under memory pressure and should make best efforts
>> if IO errors occur.
>>
>> It also adds const variables in order to fulfill 80 character limit.
>>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>> ---
>> change log v3:
>>  - add EROFS_FS_IO_MAX_RETRIES to handle IO Error for nofail cases
>>    according to Chao's suggestion;
>>  - remove all 'unlikely' hints together with IS_ERR.
>>
>>  drivers/staging/erofs/Kconfig     |  9 +++++++
>>  drivers/staging/erofs/data.c      | 52 +++++++++++++++++++++++++--------------
>>  drivers/staging/erofs/internal.h  | 24 ++++++++++++++----
>>  drivers/staging/erofs/unzip_vle.c | 12 +++++----
>>  drivers/staging/erofs/xattr.c     | 23 ++++++++++-------
>>  5 files changed, 83 insertions(+), 37 deletions(-)
>>
>> diff --git a/drivers/staging/erofs/Kconfig b/drivers/staging/erofs/Kconfig
>> index 96f6149..7f209b3 100644
>> --- a/drivers/staging/erofs/Kconfig
>> +++ b/drivers/staging/erofs/Kconfig
>> @@ -78,6 +78,15 @@ config EROFS_FAULT_INJECTION
>>  	  Test EROFS to inject faults such as ENOMEM, EIO, and so on.
>>  	  If unsure, say N.
>>  
>> +config EROFS_FS_IO_MAX_RETRIES
>> +	int "EROFS IO Maximum Retries"
>> +	depends on EROFS_FS
>> +	default "5"
>> +	help
>> +	  Maximum retry count of IO Errors.
>> +
>> +	  If unsure, leave the default value (5 retries, 6 IOs at most).
>> +
>>  config EROFS_FS_ZIP
>>  	bool "EROFS Data Compresssion Support"
>>  	depends on EROFS_FS
>> diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
>> index e0c046d..908b774 100644
>> --- a/drivers/staging/erofs/data.c
>> +++ b/drivers/staging/erofs/data.c
>> @@ -39,31 +39,44 @@ static inline void read_endio(struct bio *bio)
>>  }
>>  
>>  /* prio -- true is used for dir */
>> -struct page *erofs_get_meta_page(struct super_block *sb,
>> -	erofs_blk_t blkaddr, bool prio)
>> +struct page *__erofs_get_meta_page(struct super_block *sb,
>> +	erofs_blk_t blkaddr, bool prio, bool nofail)
>>  {
>> -	struct inode *bd_inode = sb->s_bdev->bd_inode;
>> -	struct address_space *mapping = bd_inode->i_mapping;
>> +	struct inode *const bd_inode = sb->s_bdev->bd_inode;
>> +	struct address_space *const mapping = bd_inode->i_mapping;
>> +	/* prefer retrying in the allocator to blindly looping below */
>> +	const gfp_t gfp = mapping_gfp_constraint(mapping, ~__GFP_FS) |
>> +		(nofail ? __GFP_NOFAIL : 0);
>> +	unsigned int io_retries = nofail ? CONFIG_EROFS_FS_IO_MAX_RETRIES : 0;
> I failed to compile as below:
> 
> /home/yuchao/git/erofs/data.c: In function ?__erofs_get_meta_page?:
> /home/yuchao/git/erofs/data.c:50:37: error: ?CONFIG_EROFS_FS_IO_MAX_RETRIES?
> undeclared (first use in this function)
>   unsigned int io_retries = nofail ? CONFIG_EROFS_FS_IO_MAX_RETRIES : 0;
>                                      ^
> /home/yuchao/git/erofs/data.c:50:37: note: each undeclared identifier is
> reported only once for each function it appears in
> 
> It's better to change as below?
> 
> @@ -47,9 +47,14 @@ struct page *__erofs_get_meta_page(struct super_block *sb,
>         /* prefer retrying in the allocator to blindly looping below */
>         const gfp_t gfp = mapping_gfp_constraint(mapping, ~__GFP_FS) |
>                 (nofail ? __GFP_NOFAIL : 0);
> -       unsigned int io_retries = nofail ? CONFIG_EROFS_FS_IO_MAX_RETRIES : 0;
> +       unsigned int io_retries = 0;
>         struct page *page;
> 
> +#ifdef CONFIG_EROFS_FS_IO_MAX_RETRIES
> +       if (nofail)
> +               io_retires = CONFIG_EROFS_FS_IO_MAX_RETRIES;
> +#endif
> +
> 

Could you please check the patch I just sent? :)

Thanks,
Gao Xiang

> Thanks,
> 
