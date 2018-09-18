From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 18 Sep 2018 15:07:35 +0800
Subject: [PATCH v2 2/6] staging: erofs: code cleanup for option parsing of
 fault_injection
In-Reply-To: <20180917153426.16880-3-cgxu519@gmx.com>
References: <20180917153426.16880-1-cgxu519@gmx.com>
 <20180917153426.16880-3-cgxu519@gmx.com>
Message-ID: <04998eab-11f2-7d3b-166c-f481a4d5e8a0@huawei.com>

Hi Chengguang,

On 2018/9/17 23:34, Chengguang Xu wrote:
> Define a dummpy function of erofs_build_fault_attr() when macro
> CONFIG_EROFS_FAULT_INJECTION is disabled, so that we don't have to
> check the macro in calling place. Based on above adjustment,
> do proper code cleanup for option parsing of fault_injection.
> 
> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
> ---
>  drivers/staging/erofs/super.c | 33 ++++++++++++++++++++-------------
>  1 file changed, 20 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
> index 9e421536cbdf..7ce2fd3d49f3 100644
> --- a/drivers/staging/erofs/super.c
> +++ b/drivers/staging/erofs/super.c
> @@ -145,10 +145,14 @@ char *erofs_fault_name[FAULT_MAX] = {
>  	[FAULT_KMALLOC]		= "kmalloc",
>  };
>  
> -static void erofs_build_fault_attr(struct erofs_sb_info *sbi,
> -						unsigned int rate)
> +static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
> +					substring_t *args)
>  {
>  	struct erofs_fault_info *ffi = &sbi->fault_info;
> +	int rate = 0;
> +
> +	if (args->from && match_int(args, &rate))
> +		return -EINVAL;
>  
>  	if (rate) {
>  		atomic_set(&ffi->inject_ops, 0);
> @@ -157,6 +161,15 @@ static void erofs_build_fault_attr(struct erofs_sb_info *sbi,
>  	} else {
>  		memset(ffi, 0, sizeof(struct erofs_fault_info));
>  	}
> +
> +	set_opt(sbi, FAILt_INJECTION);
drivers/staging/erofs/super.c: In function ?__erofs_build_fault_attr?:
drivers/staging/erofs/internal.h:176:51: error: ?EROFS_MOUNT_FAILt_INJECTION? undeclared (first use in this function)
 #define set_opt(sbi, option) ((sbi)->mount_opt |= EROFS_MOUNT_##option)
                                                   ^
drivers/staging/erofs/super.c:166:2: note: in expansion of macro ?set_opt?
  set_opt(sbi, FAILt_INJECTION);
  ^
drivers/staging/erofs/internal.h:176:51: note: each undeclared identifier is reported only once for each function it appears in
 #define set_opt(sbi, option) ((sbi)->mount_opt |= EROFS_MOUNT_##option)
                                                   ^
drivers/staging/erofs/super.c:166:2: note: in expansion of macro ?set_opt?
  set_opt(sbi, FAILt_INJECTION);
  ^

Thanks,
Gao Xiang


> +}
> +#else
> +static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
> +					substring_t *args)
> +{
> +	infoln("fault_injection options not supported");
> +	return 0;
>  }
>  #endif
>  
> @@ -193,7 +206,7 @@ static int parse_options(struct super_block *sb, char *options)
>  {
>  	substring_t args[MAX_OPT_ARGS];
>  	char *p;
> -	int arg = 0;
> +	int err;
>  
>  	if (!options)
>  		return 0;
> @@ -238,18 +251,12 @@ static int parse_options(struct super_block *sb, char *options)
>  			infoln("noacl options not supported");
>  			break;
>  #endif
> -#ifdef CONFIG_EROFS_FAULT_INJECTION
> -		case Opt_fault_injection:
> -			if (args->from && match_int(args, &arg))
> -				return -EINVAL;
> -			erofs_build_fault_attr(EROFS_SB(sb), arg);
> -			set_opt(EROFS_SB(sb), FAULT_INJECTION);
> -			break;
> -#else
>  		case Opt_fault_injection:
> -			infoln("fault_injection options not supported");
> +			err = erofs_build_fault_attr(EROFS_SB(sb), args);
> +			if (err)
> +				return err;
>  			break;
> -#endif
> +
>  		default:
>  			errln("Unrecognized mount option \"%s\" "
>  					"or missing value", p);
> 
