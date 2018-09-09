From: chao@kernel.org (Chao Yu)
Date: Sun, 9 Sep 2018 23:16:18 +0800
Subject: [PATCH v2] staging: erofs: use explicit unsigned int type
In-Reply-To: <5c44a63b-041d-1fce-0748-53c0b44f5983@huawei.com>
References: <20180830205605.19492-1-linux@weissschuh.net>
 <20180907163912.3686-1-linux@weissschuh.net>
 <5c44a63b-041d-1fce-0748-53c0b44f5983@huawei.com>
Message-ID: <9f2c06f5-05db-a117-bb11-92c1ae517b09@kernel.org>

Hi Thomas,

On 2018/9/8 11:28, Gao Xiang wrote:
> Hi Thomas,
> 
> Thanks for your new patch.
> 
> It seems that this patch also introduces 2 new 'WARNING: line over 80 characters',
> could you please fix it in the patch?

It will be better to fix that.

Some reviewed cleanup patches are merged before this patch, then I failed to add
this one, so could you rebase on top of erofs dev branch in below link:

https://git.kernel.org/pub/scm/linux/kernel/git/chao/linux.git/log/?h=erofs

Thanks,

> 
> On 2018/9/8 0:39, Thomas Wei?schuh wrote:
>> Changes since v1:
>>
>> * Removed changes that conflicted with
>>   [PATCH 1/6] staging: erofs: formatting fix in unzip_vle_lz4.c
>> * Added patch description
>>
>> -- >8 --
>>
>> Fix coding style issue "Prefer 'unsigned int' to bare use of 'unsigned'"
>> detected by checkpatch.pl
>>
>> Signed-off-by: Thomas Wei?schuh <linux at weissschuh.net>
>>
>> ---
>>  drivers/staging/erofs/data.c      |  4 +--
>>  drivers/staging/erofs/dir.c       | 14 ++++-----
>>  drivers/staging/erofs/inode.c     |  6 ++--
>>  drivers/staging/erofs/namei.c     | 28 +++++++++---------
>>  drivers/staging/erofs/super.c     |  2 +-
>>  drivers/staging/erofs/unzip_vle.c | 48 +++++++++++++++----------------
>>  drivers/staging/erofs/utils.c     |  2 +-
>>  drivers/staging/erofs/xattr.c     | 40 +++++++++++++-------------
>>  8 files changed, 72 insertions(+), 72 deletions(-)
>>
>> diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
>> index 3c0d9159514e..e1916101ad75 100644
>> --- a/drivers/staging/erofs/data.c
>> +++ b/drivers/staging/erofs/data.c
>> @@ -202,7 +202,7 @@ static inline struct bio *erofs_read_raw_page(
>>  	struct address_space *mapping,
>>  	struct page *page,
>>  	erofs_off_t *last_block,
>> -	unsigned nblocks,
>> +	unsigned int nblocks,
>>  	bool ra)
>>  {
>>  	struct inode *inode = mapping->host;
>> @@ -236,7 +236,7 @@ static inline struct bio *erofs_read_raw_page(
>>  			.m_la = blknr_to_addr(current_block),
>>  		};
>>  		erofs_blk_t blknr;
>> -		unsigned blkoff;
>> +		unsigned int blkoff;
>>  
>>  		err = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_RAW);
>>  		if (unlikely(err))
>> diff --git a/drivers/staging/erofs/dir.c b/drivers/staging/erofs/dir.c
>> index be6ae3b1bdbe..87f12b0f983f 100644
>> --- a/drivers/staging/erofs/dir.c
>> +++ b/drivers/staging/erofs/dir.c
>> @@ -24,8 +24,8 @@ static const unsigned char erofs_filetype_table[EROFS_FT_MAX] = {
>>  };
>>  
>>  static int erofs_fill_dentries(struct dir_context *ctx,
>> -	void *dentry_blk, unsigned *ofs,
>> -	unsigned nameoff, unsigned maxsize)
>> +	void *dentry_blk, unsigned int *ofs,
>> +	unsigned int nameoff, unsigned int maxsize)
>>  {
>>  	struct erofs_dirent *de = dentry_blk;
>>  	const struct erofs_dirent *end = dentry_blk + nameoff;
>> @@ -36,7 +36,7 @@ static int erofs_fill_dentries(struct dir_context *ctx,
>>  		int de_namelen;
>>  		unsigned char d_type;
>>  #ifdef CONFIG_EROFS_FS_DEBUG
>> -		unsigned dbg_namelen;
>> +		unsigned int dbg_namelen;
>>  		unsigned char dbg_namebuf[EROFS_NAME_LEN];
>>  #endif
>>  
>> @@ -81,15 +81,15 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
>>  	struct inode *dir = file_inode(f);
>>  	struct address_space *mapping = dir->i_mapping;
>>  	const size_t dirsize = i_size_read(dir);
>> -	unsigned i = ctx->pos / EROFS_BLKSIZ;
>> -	unsigned ofs = ctx->pos % EROFS_BLKSIZ;
>> +	unsigned int i = ctx->pos / EROFS_BLKSIZ;
>> +	unsigned int ofs = ctx->pos % EROFS_BLKSIZ;
>>  	int err = 0;
>>  	bool initial = true;
>>  
>>  	while (ctx->pos < dirsize) {
>>  		struct page *dentry_page;
>>  		struct erofs_dirent *de;
>> -		unsigned nameoff, maxsize;
>> +		unsigned int nameoff, maxsize;
>>  
>>  		dentry_page = read_mapping_page(mapping, i, NULL);
>>  		if (IS_ERR(dentry_page))
>> @@ -109,7 +109,7 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
>>  			goto skip_this;
>>  		}
>>  
>> -		maxsize = min_t(unsigned, dirsize - ctx->pos + ofs, PAGE_SIZE);
>> +		maxsize = min_t(unsigned int, dirsize - ctx->pos + ofs, PAGE_SIZE);
> 
> WARNING: line over 80 characters
> #102: FILE: drivers/staging/erofs/dir.c:112:
> +               maxsize = min_t(unsigned int, dirsize - ctx->pos + ofs, PAGE_SIZE);
> 
> 
>>  
>>  		/* search dirents at the arbitrary position */
>>  		if (unlikely(initial)) {
>> diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
>> index fbf6ff25cd1b..70d34b0a97fe 100644
>> --- a/drivers/staging/erofs/inode.c
>> +++ b/drivers/staging/erofs/inode.c
>> @@ -19,7 +19,7 @@ static int read_inode(struct inode *inode, void *data)
>>  {
>>  	struct erofs_vnode *vi = EROFS_V(inode);
>>  	struct erofs_inode_v1 *v1 = data;
>> -	const unsigned advise = le16_to_cpu(v1->i_advise);
>> +	const unsigned int advise = le16_to_cpu(v1->i_advise);
>>  
>>  	vi->data_mapping_mode = __inode_data_mapping(advise);
>>  
>> @@ -112,7 +112,7 @@ static int read_inode(struct inode *inode, void *data)
>>   * try_lock since it takes no much overhead and
>>   * will success immediately.
>>   */
>> -static int fill_inline_data(struct inode *inode, void *data, unsigned m_pofs)
>> +static int fill_inline_data(struct inode *inode, void *data, unsigned int m_pofs)
> 
> WARNING: line over 80 characters
> #124: FILE: drivers/staging/erofs/inode.c:115:
> +static int fill_inline_data(struct inode *inode, void *data, unsigned int m_pofs)
> 
> Thanks,
> Gao Xiang
> 
