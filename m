From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 6 Jul 2018 00:39:37 +0800
Subject: [PATCH] erofs: fix erofs_module_init & exit
In-Reply-To: <b66fb258-e9af-1ad9-7613-92ad07ca75b3@kernel.org>
References: <1530767030-86277-1-git-send-email-gaoxiang25@huawei.com>
 <b66fb258-e9af-1ad9-7613-92ad07ca75b3@kernel.org>
Message-ID: <a3348541-c140-94fc-95ec-6334c827e09e@huawei.com>

Hi Chao,

On 2018/7/6 0:19, Chao Yu wrote:
> Hi Xiang,
> 
> On 2018/7/5 13:03, Gao Xiang wrote:
>> This patch adds missing parts and EROFS ondisk
>> layout check as well.
>>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>> ---
>>  fs/erofs/erofs_fs.h | 13 +++++++++++++
>>  fs/erofs/super.c    | 28 +++++++++++++++++++++-------
>>  2 files changed, 34 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/erofs/erofs_fs.h b/fs/erofs/erofs_fs.h
>> index ed943d4..0dbf08d 100644
>> --- a/fs/erofs/erofs_fs.h
>> +++ b/fs/erofs/erofs_fs.h
>> @@ -253,5 +253,18 @@ enum {
>>  
>>  #define EROFS_NAME_LEN      255
>>  
>> +/* check the EROFS on-disk layout strictly at compile time */
>> +static inline void erofs_check_ondisk_layout(void)
>> +{
>> +	BUILD_BUG_ON(sizeof(struct erofs_super_block) != 128);
>> +	BUILD_BUG_ON(sizeof(struct erofs_inode_v1) != 32);
>> +	BUILD_BUG_ON(sizeof(struct erofs_inode_v2) != 64);
>> +	BUILD_BUG_ON(sizeof(struct erofs_xattr_ibody_header) != 12);
>> +	BUILD_BUG_ON(sizeof(struct erofs_xattr_entry) != 4);
>> +	BUILD_BUG_ON(sizeof(struct erofs_extent_header) != 16);
>> +	BUILD_BUG_ON(sizeof(struct erofs_decompressed_index_vle) != 8);
>> +	BUILD_BUG_ON(sizeof(struct erofs_dirent) != 12);
> 
> We'd better define some macros include above constants.
> 
> Other parts look good to me.
> 
> Thanks,
> 

I was also thinking of wrapping in macros, but I thought over again,
it seems not too necessary because:

1) the above code is already well straight-forward to view and change if needed...

BUILD_BUG_ON(sizeof(struct erofs_super_block) != 128);
   <==> #define EROFS_SUPER_BLOCK_ONDISK_SIZE  128

EROFS_SUPER_BLOCK_ONDISK_SIZE is not really needed since
we could use sizeof(struct erofs_super_block) directly in code.

2) Besides, I also observed the other file systems, such as xfs, sysv, minix, and ubifs, eg.

fs/jffs2/super.c:
366         /* Paranoia checks for on-medium structures. If we ask GCC
367            to pack them with __attribute__((packed)) then it _also_
368            assumes that they're not aligned -- so it emits crappy
369            code on some architectures. Ideally we want an attribute
370            which means just 'no padding', without the alignment
371            thing. But GCC doesn't have that -- we have to just
372            hope the structs are the right sizes, instead. */
373         BUILD_BUG_ON(sizeof(struct jffs2_unknown_node) != 12);
374         BUILD_BUG_ON(sizeof(struct jffs2_raw_dirent) != 40);
375         BUILD_BUG_ON(sizeof(struct jffs2_raw_inode) != 68);
376         BUILD_BUG_ON(sizeof(struct jffs2_raw_summary) != 32);

fs/minix/inode.c:
174         BUILD_BUG_ON(32 != sizeof (struct minix_inode));
175         BUILD_BUG_ON(64 != sizeof(struct minix2_inode));

fs/ubifs/super.c:
359         BUILD_BUG_ON(1024 != sizeof (struct xenix_super_block));
360         BUILD_BUG_ON(512 != sizeof (struct sysv4_super_block));
361         BUILD_BUG_ON(512 != sizeof (struct sysv2_super_block));
362         BUILD_BUG_ON(500 != sizeof (struct coh_super_block));
363         BUILD_BUG_ON(64 != sizeof (struct sysv_inode));

fs/ubifs/super.c
2211         BUILD_BUG_ON(UBIFS_MAX_NODE_SZ      & 7);
2212         BUILD_BUG_ON(MIN_WRITE_SZ           & 7);
2213
2214         /* Check min. node size */
2215         BUILD_BUG_ON(UBIFS_INO_NODE_SZ  < MIN_WRITE_SZ);
2216         BUILD_BUG_ON(UBIFS_DENT_NODE_SZ < MIN_WRITE_SZ);
2217         BUILD_BUG_ON(UBIFS_XENT_NODE_SZ < MIN_WRITE_SZ);
2218         BUILD_BUG_ON(UBIFS_TRUN_NODE_SZ < MIN_WRITE_SZ);
2219
2220         BUILD_BUG_ON(UBIFS_MAX_DENT_NODE_SZ > UBIFS_MAX_NODE_SZ);
2221         BUILD_BUG_ON(UBIFS_MAX_XENT_NODE_SZ > UBIFS_MAX_NODE_SZ);
2222         BUILD_BUG_ON(UBIFS_MAX_DATA_NODE_SZ > UBIFS_MAX_NODE_SZ);
2223         BUILD_BUG_ON(UBIFS_MAX_INO_NODE_SZ  > UBIFS_MAX_NODE_SZ);
2224
2225         /* Defined node sizes */
2226         BUILD_BUG_ON(UBIFS_SB_NODE_SZ  != 4096);
2227         BUILD_BUG_ON(UBIFS_MST_NODE_SZ != 512);
2228         BUILD_BUG_ON(UBIFS_INO_NODE_SZ != 160);
2229         BUILD_BUG_ON(UBIFS_REF_NODE_SZ != 64);

how do you think? :) If you think it is necessary, I can change into marcos immediately~

Thanks,
Gao Xiang

>> +}
>> +
>>  #endif
>>  
>> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
>> index a1826b9..d104d88 100644
>> --- a/fs/erofs/super.c
>> +++ b/fs/erofs/super.c
>> @@ -37,6 +37,12 @@ static int erofs_init_inode_cache(void)
>>  	return erofs_inode_cachep != NULL ? 0 : -ENOMEM;
>>  }
>>  
>> +static void erofs_exit_inode_cache(void)
>> +{
>> +	BUG_ON(erofs_inode_cachep == NULL);
>> +	kmem_cache_destroy(erofs_inode_cachep);
>> +}
>> +
>>  static struct inode *alloc_inode(struct super_block *sb)
>>  {
>>  	struct erofs_vnode *vi =
>> @@ -398,22 +404,30 @@ int __init erofs_module_init(void)
>>  {
>>  	int err;
>>  
>> +	erofs_check_ondisk_layout();
>>  	infoln("Initializing erofs " EROFS_VERSION);
>>  
>>  	err = erofs_init_inode_cache();
>> -	if (!err) {
>> -		err = register_filesystem(&erofs_fs_type);
>> -		if (!err) {
>> -			infoln("Successfully to initialize erofs");
>> -			return 0;
>> -		}
>> -	}
>> +	if (err)
>> +		goto icache_err;
>> +
>> +	err = register_filesystem(&erofs_fs_type);
>> +	if (err)
>> +		goto fs_err;
>> +
>> +	infoln("Successfully to initialize erofs");
>> +	return 0;
>> +
>> +fs_err:
>> +	erofs_exit_inode_cache();
>> +icache_err:
>>  	return err;
>>  }
>>  
>>  void __exit erofs_module_exit(void)
>>  {
>>  	unregister_filesystem(&erofs_fs_type);
>> +	erofs_exit_inode_cache();
>>  	infoln("Successfully finalize erofs");
>>  }
>>  
>>
