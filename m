From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sun, 16 Jun 2019 15:00:38 +0800
Subject: [PATCH v3 1/2] staging: erofs: add requirements field in
 superblock
In-Reply-To: <20190613083541.67091-1-gaoxiang25@huawei.com>
References: <20190611024220.86121-1-gaoxiang25@huawei.com>
 <20190613083541.67091-1-gaoxiang25@huawei.com>
Message-ID: <a4d587eb-c4f0-b9e5-7ece-1ac38c2735f3@huawei.com>

Hi Greg,

Sorry for annoying... Could you help merge these two fixes? Thanks in advance...
decompression inplace optimization needs these two patches and I will integrate
erofs decompression inplace optimization later for linux-next 5.3, and try to start 
making effort on moving to fs/ directory on kernel 5.4...

Thanks,
Gao Xiang

On 2019/6/13 16:35, Gao Xiang wrote:
> There are some backward incompatible features pending
> for months, mainly due to on-disk format expensions.
> 
> However, we should ensure that it cannot be mounted with
> old kernels. Otherwise, it will causes unexpected behaviors.
> 
> Fixes: ba2b77a82022 ("staging: erofs: add super block operations")
> Cc: <stable at vger.kernel.org> # 4.19+
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
> change log v3:
>  - record requirements in erofs_sb_info for runtime use as well;
> 
> change log v2:
>  - update printed message
> 
>  drivers/staging/erofs/erofs_fs.h | 13 ++++++++++---
>  drivers/staging/erofs/internal.h |  2 ++
>  drivers/staging/erofs/super.c    | 19 +++++++++++++++++++
>  3 files changed, 31 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/erofs/erofs_fs.h b/drivers/staging/erofs/erofs_fs.h
> index fa52898df006..8ddb2b3e7d39 100644
> --- a/drivers/staging/erofs/erofs_fs.h
> +++ b/drivers/staging/erofs/erofs_fs.h
> @@ -17,10 +17,16 @@
>  #define EROFS_SUPER_MAGIC_V1    0xE0F5E1E2
>  #define EROFS_SUPER_OFFSET      1024
>  
> +/*
> + * Any bits that aren't in EROFS_ALL_REQUIREMENTS should be
> + * incompatible with this kernel version.
> + */
> +#define EROFS_ALL_REQUIREMENTS  0
> +
>  struct erofs_super_block {
>  /*  0 */__le32 magic;           /* in the little endian */
>  /*  4 */__le32 checksum;        /* crc32c(super_block) */
> -/*  8 */__le32 features;
> +/*  8 */__le32 features;        /* (aka. feature_compat) */
>  /* 12 */__u8 blkszbits;         /* support block_size == PAGE_SIZE only */
>  /* 13 */__u8 reserved;
>  
> @@ -34,9 +40,10 @@ struct erofs_super_block {
>  /* 44 */__le32 xattr_blkaddr;
>  /* 48 */__u8 uuid[16];          /* 128-bit uuid for volume */
>  /* 64 */__u8 volume_name[16];   /* volume name */
> +/* 80 */__le32 requirements;    /* (aka. feature_incompat) */
>  
> -/* 80 */__u8 reserved2[48];     /* 128 bytes */
> -} __packed;
> +/* 84 */__u8 reserved2[44];
> +} __packed;                     /* 128 bytes */
>  
>  /*
>   * erofs inode data mapping:
> diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
> index 911333cdeef4..fc732c86ecd8 100644
> --- a/drivers/staging/erofs/internal.h
> +++ b/drivers/staging/erofs/internal.h
> @@ -115,6 +115,8 @@ struct erofs_sb_info {
>  
>  	u8 uuid[16];                    /* 128-bit uuid for volume */
>  	u8 volume_name[16];             /* volume name */
> +	u32 requirements;
> +
>  	char *dev_name;
>  
>  	unsigned int mount_opt;
> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
> index f580d4ef77a1..cadbcc11702a 100644
> --- a/drivers/staging/erofs/super.c
> +++ b/drivers/staging/erofs/super.c
> @@ -71,6 +71,22 @@ static void free_inode(struct inode *inode)
>  	kmem_cache_free(erofs_inode_cachep, vi);
>  }
>  
> +static bool check_layout_compatibility(struct super_block *sb,
> +				       struct erofs_super_block *layout)
> +{
> +	const unsigned int requirements = le32_to_cpu(layout->requirements);
> +
> +	EROFS_SB(sb)->requirements = requirements;
> +
> +	/* check if current kernel meets all mandatory requirements */
> +	if (requirements & (~EROFS_ALL_REQUIREMENTS)) {
> +		errln("unidentified requirements %x, please upgrade kernel version",
> +		      requirements & ~EROFS_ALL_REQUIREMENTS);
> +		return false;
> +	}
> +	return true;
> +}
> +
>  static int superblock_read(struct super_block *sb)
>  {
>  	struct erofs_sb_info *sbi;
> @@ -104,6 +120,9 @@ static int superblock_read(struct super_block *sb)
>  		goto out;
>  	}
>  
> +	if (!check_layout_compatibility(sb, layout))
> +		goto out;
> +
>  	sbi->blocks = le32_to_cpu(layout->blocks);
>  	sbi->meta_blkaddr = le32_to_cpu(layout->meta_blkaddr);
>  #ifdef CONFIG_EROFS_FS_XATTR
> 
