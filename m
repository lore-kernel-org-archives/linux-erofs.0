From: yuchao0@huawei.com (Chao Yu)
Date: Thu, 13 Sep 2018 10:15:46 +0800
Subject: [PATCH 2/7] staging: erofs: code cleanup for option parsing of
 fault_injection
In-Reply-To: <20180912051034.3463-3-cgxu519@gmx.com>
References: <20180912051034.3463-1-cgxu519@gmx.com>
 <20180912051034.3463-3-cgxu519@gmx.com>
Message-ID: <8402ea38-0918-170e-34d9-ccdaf518bc34@huawei.com>

On 2018/9/12 13:10, Chengguang Xu wrote:
> Define a dummpy function of erofs_build_fault_attr() when macro
> CONFIG_EROFS_FAULT_INJECTION is disabled, so that we don't have to
> check the macro in calling place. Based on above adjustment,
> do proper code cleanup for option parsing of fault_injection.
> 
> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
> ---
>  drivers/staging/erofs/super.c | 33 ++++++++++++++++++++++-----------
>  1 file changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
> index 1aec509c805f..14dbb6517b8d 100644
> --- a/drivers/staging/erofs/super.c
> +++ b/drivers/staging/erofs/super.c
> @@ -144,18 +144,33 @@ char *erofs_fault_name[FAULT_MAX] = {
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
>  		ffi->inject_rate = rate;
>  		ffi->inject_type = (1 << FAULT_MAX) - 1;
> +		set_opt(sbi, FAULT_INJECTION);
>  	} else {
>  		memset(ffi, 0, sizeof(struct erofs_fault_info));
> +		clear_opt(sbi, FAULT_INJECTION);

Hmmm, if user mounts/remounts image with -o fault_injection=0, user can not
check such info in anywhere, as we skip showing this option due to lack of
EROFS_MOUNT_FAULT_INJECTION bit. How about keeping this bit?

Thanks,

>  	}
> +
> +	return 0;
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
> @@ -192,7 +207,7 @@ static int parse_options(struct super_block *sb, char *options)
>  {
>  	substring_t args[MAX_OPT_ARGS];
>  	char *p;
> -	int arg = 0;
> +	int err;
>  
>  	if (!options)
>  		return 0;
> @@ -238,15 +253,11 @@ static int parse_options(struct super_block *sb, char *options)
>  			break;
>  #endif
>  		case Opt_fault_injection:
> -			if (args->from && match_int(args, &arg))
> -				return -EINVAL;
> -#ifdef CONFIG_EROFS_FAULT_INJECTION
> -			erofs_build_fault_attr(EROFS_SB(sb), arg);
> -			set_opt(EROFS_SB(sb), FAULT_INJECTION);
> -#else
> -			infoln("FAULT_INJECTION was not selected");
> -#endif
> +			err = erofs_build_fault_attr(EROFS_SB(sb), args);
> +			if (err)
> +				return err;
>  			break;
> +
>  		default:
>  			errln("Unrecognized mount option \"%s\" "
>  					"or missing value", p);
> 
