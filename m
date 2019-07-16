From: hsiangkao@aol.com (Gao Xiang)
Date: Wed, 17 Jul 2019 01:03:44 +0800
Subject: [PATCH] staging: erofs: a few minor style fixes found using
 checkpatch
In-Reply-To: <1563294942-31395-1-git-send-email-karen.palacio.1994@gmail.com>
References: <1563294942-31395-1-git-send-email-karen.palacio.1994@gmail.com>
Message-ID: <1a0b5e37-a5a1-7a2f-0185-860a4aab4b2b@aol.com>



On 2019/7/17 ????12:35, Karen Palacio wrote:
> Fix camel case use in variable names,
> Fix multiple assignments done in a single line,
> Fix end of line containing '('.

One type one patch...

> 
> Signed-off-by: Karen Palacio <karen.palacio.1994 at gmail.com>
> ---
>  drivers/staging/erofs/super.c | 55 ++++++++++++++++++++++---------------------
>  1 file changed, 28 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
> index 5449441..e281125 100644
> --- a/drivers/staging/erofs/super.c
> +++ b/drivers/staging/erofs/super.c
> @@ -228,21 +228,21 @@ static void default_options(struct erofs_sb_info *sbi)
>  }
>  
>  enum {
> -	Opt_user_xattr,
> -	Opt_nouser_xattr,
> -	Opt_acl,
> -	Opt_noacl,
> -	Opt_fault_injection,
> -	Opt_err
> +	opt_user_xattr,
> +	opt_nouser_xattr,
> +	opt_acl,
> +	opt_noacl,
> +	opt_fault_injection,
> +	opt_err

NACK, all linux filesystems use Opt_xxx. EROFS should obey this practice.

fs/ext4/super.c
1436 enum {
1437         Opt_bsd_df, Opt_minix_df, Opt_grpid, Opt_nogrpid,
1438         Opt_resgid, Opt_resuid, Opt_sb, Opt_err_cont,
Opt_err_panic, Opt_err_ro,
1439         Opt_nouid32, Opt_debug, Opt_removed,
1440         Opt_user_xattr, Opt_nouser_xattr, Opt_acl, Opt_noacl,
1441         Opt_auto_da_alloc, Opt_noauto_da_alloc, Opt_noload,
1442         Opt_commit, Opt_min_batch_time, Opt_max_batch_time,
Opt_journal_dev,
1443         Opt_journal_path, Opt_journal_checksum,
Opt_journal_async_commit,
1444         Opt_abort, Opt_data_journal, Opt_data_ordered,
Opt_data_writeback,
1445         Opt_data_err_abort, Opt_data_err_ignore,
Opt_test_dummy_encryption,
1446         Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota,
Opt_offgrpjquota,
1447         Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,

fs/btrfs/super.c
 294 enum {
 295         Opt_acl, Opt_noacl,
 296         Opt_clear_cache,
 297         Opt_commit_interval,
 298         Opt_compress,
 299         Opt_compress_force,
 300         Opt_compress_force_type,
 301         Opt_compress_type,
 302         Opt_degraded,
 303         Opt_device,
 304         Opt_fatal_errors,

Thanks,
Gao Xiang


>  };
>  
>  static match_table_t erofs_tokens = {
> -	{Opt_user_xattr, "user_xattr"},
> -	{Opt_nouser_xattr, "nouser_xattr"},
> -	{Opt_acl, "acl"},
> -	{Opt_noacl, "noacl"},
> -	{Opt_fault_injection, "fault_injection=%u"},
> -	{Opt_err, NULL}
> +	{opt_user_xattr, "user_xattr"},
> +	{opt_nouser_xattr, "nouser_xattr"},
> +	{opt_acl, "acl"},
> +	{opt_noacl, "noacl"},
> +	{opt_fault_injection, "fault_injection=%u"},
> +	{opt_err, NULL}
>  };
>  
>  static int parse_options(struct super_block *sb, char *options)
> @@ -260,41 +260,42 @@ static int parse_options(struct super_block *sb, char *options)
>  		if (!*p)
>  			continue;
>  
> -		args[0].to = args[0].from = NULL;
> +		args[0].to = NULL;
> +		args[0].from = NULL;
>  		token = match_token(p, erofs_tokens, args);
>  
>  		switch (token) {
>  #ifdef CONFIG_EROFS_FS_XATTR
> -		case Opt_user_xattr:
> +		case opt_user_xattr:
>  			set_opt(EROFS_SB(sb), XATTR_USER);
>  			break;
> -		case Opt_nouser_xattr:
> +		case opt_nouser_xattr:
>  			clear_opt(EROFS_SB(sb), XATTR_USER);
>  			break;
>  #else
> -		case Opt_user_xattr:
> +		case opt_user_xattr:
>  			infoln("user_xattr options not supported");
>  			break;
> -		case Opt_nouser_xattr:
> +		case opt_nouser_xattr:
>  			infoln("nouser_xattr options not supported");
>  			break;
>  #endif
>  #ifdef CONFIG_EROFS_FS_POSIX_ACL
> -		case Opt_acl:
> +		case opt_acl:
>  			set_opt(EROFS_SB(sb), POSIX_ACL);
>  			break;
> -		case Opt_noacl:
> +		case opt_noacl:
>  			clear_opt(EROFS_SB(sb), POSIX_ACL);
>  			break;
>  #else
> -		case Opt_acl:
> +		case opt_acl:
>  			infoln("acl options not supported");
>  			break;
> -		case Opt_noacl:
> +		case opt_noacl:
>  			infoln("noacl options not supported");
>  			break;
>  #endif
> -		case Opt_fault_injection:
> +		case opt_fault_injection:
>  			err = erofs_build_fault_attr(EROFS_SB(sb), args);
>  			if (err)
>  				return err;
> @@ -525,7 +526,6 @@ static void erofs_put_super(struct super_block *sb)
>  	sb->s_fs_info = NULL;
>  }
>  
> -
>  struct erofs_mount_private {
>  	const char *dev_name;
>  	char *options;
> @@ -541,9 +541,9 @@ static int erofs_fill_super(struct super_block *sb,
>  		priv->options, silent);
>  }
>  
> -static struct dentry *erofs_mount(
> -	struct file_system_type *fs_type, int flags,
> -	const char *dev_name, void *data)
> +static struct dentry *erofs_mount(struct file_system_type *fs_type,
> +				  int flags,
> +				  const char *dev_name, void *data)
>  {
>  	struct erofs_mount_private priv = {
>  		.dev_name = dev_name,
> @@ -623,7 +623,8 @@ static int erofs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	buf->f_type = sb->s_magic;
>  	buf->f_bsize = EROFS_BLKSIZ;
>  	buf->f_blocks = sbi->blocks;
> -	buf->f_bfree = buf->f_bavail = 0;
> +	buf->f_bfree = 0;
> +	buf->f_bavail = 0;
>  
>  	buf->f_files = ULLONG_MAX;
>  	buf->f_ffree = ULLONG_MAX - sbi->inos;
> 
