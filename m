From: hsiangkao@aol.com (Gao Xiang)
Date: Wed, 19 Sep 2018 00:58:24 +0800
Subject: [PATCH v3 4/4] staging: erofs: option validation in remount
In-Reply-To: <20180918151058.25041-5-cgxu519@gmx.com>
References: <20180918151058.25041-1-cgxu519@gmx.com>
 <20180918151058.25041-5-cgxu519@gmx.com>
Message-ID: <79e182ea-9571-8c20-aafe-59e55b7db638@aol.com>

Hi Chengguang,

On 2018/9/18 23:10, Chengguang Xu wrote:
> Add option validation in remount. After this patch, remount
> can change recognized options, and for unknown options remount
> will fail and report error.
> 
> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> ---
>  drivers/staging/erofs/super.c | 38 ++++++++++++++++++++++++++++-------
>  1 file changed, 31 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
> index a091b93190e1..30b6b44dc6c4 100644
> --- a/drivers/staging/erofs/super.c
> +++ b/drivers/staging/erofs/super.c
> @@ -145,14 +145,10 @@ char *erofs_fault_name[FAULT_MAX] = {
>  	[FAULT_KMALLOC]		= "kmalloc",
>  };
>  
> -static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
> -					substring_t *args)
> +static void __erofs_build_fault_attr(struct erofs_sb_info *sbi,
> +						unsigned int rate)
>  {
>  	struct erofs_fault_info *ffi = &sbi->fault_info;
> -	int rate = 0;
> -
> -	if (args->from && match_int(args, &rate))
> -		return -EINVAL;
>  
>  	if (rate) {
>  		atomic_set(&ffi->inject_ops, 0);
> @@ -163,14 +159,29 @@ static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
>  	}
>  
>  	set_opt(sbi, FAULT_INJECTION);
> -	return 0;
>  }
>  
>  static unsigned int erofs_get_fault_rate(struct erofs_sb_info *sbi)
>  {
>  	return sbi->fault_info.inject_rate;
>  }
> +
> +static int erofs_build_fault_attr(struct erofs_sb_info *sbi, substring_t *args)
> +{
> +	int rate = 0;
> +
> +	if (args->from && match_int(args, &rate))
> +		return -EINVAL;
> +
> +	__erofs_build_fault_attr(sbi, rate);
> +	return 0;
> +}
>  #else
> +static void __erofs_build_fault_attr(struct erofs_sb_info *sbi,
> +						unsigned int rate)
> +{
> +}
> +
>  static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
>  					substring_t *args)
>  {
> @@ -644,10 +655,23 @@ static int erofs_show_options(struct seq_file *seq, struct dentry *root)
>  
>  static int erofs_remount(struct super_block *sb, int *flags, char *data)
>  {
> +	struct erofs_sb_info *sbi = EROFS_SB(sb);
> +	unsigned int org_mnt_opt = sbi->mount_opt;
> +	unsigned int org_inject_rate = erofs_get_fault_rate(sbi);
> +	int err;
> +
>  	BUG_ON(!sb_rdonly(sb));
> +	err = parse_options(sb, data);
> +	if (err)
> +		goto out;
>  
>  	*flags |= MS_RDONLY;

I cannot apply this patch since the above line has been changed in
5f0abea6ab6d("staging: erofs: rename superblock flags (MS_xyz -> SB_xyz)").


And two more checkpatch CHECKs as [PATCH v3 2/4]

CHECK: Alignment should match open parenthesis
#141: FILE: drivers/staging/erofs/super.c:149:
+static void __erofs_build_fault_attr(struct erofs_sb_info *sbi,
+                                               unsigned int rate)

CHECK: Alignment should match open parenthesis
#175: FILE: drivers/staging/erofs/super.c:181:
+static void __erofs_build_fault_attr(struct erofs_sb_info *sbi,
+                                               unsigned int rate)

And I think I need to test the basic erofs remount function tomorrow
before merging... it is too late and I have to go to sleep now...

Thanks,
Gao Xiang

>  	return 0;
> +out:
> +	__erofs_build_fault_attr(sbi, org_inject_rate);
> +	sbi->mount_opt = org_mnt_opt;
> +
> +	return err;
>  }
>  
>  const struct super_operations erofs_sops = {
> 
