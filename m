From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 11 Dec 2018 19:06:11 +0800
Subject: [PATCH 4/5] drivers: staging: erofs: Fix parentheses error in
 macro
In-Reply-To: <20181211105443.21826-5-aaron.strahlberger@posteo.de>
References: <0ed9f3e7-9081-4a8a-06b0-e5ad14e2c872@huawei.com>
 <20181211105443.21826-1-aaron.strahlberger@posteo.de>
 <20181211105443.21826-5-aaron.strahlberger@posteo.de>
Message-ID: <dc56553c-a5ea-5265-5820-4bb481b0b948@huawei.com>

Hi Aaron,

On 2018/12/11 18:54, Aaron Strahlberger wrote:
> Fix of ERROR: Macros with complex values should be enclosed in parentheses
> from checkpatch.pl
> 
> Signed-off-by: Aaron Strahlberger <aaron.strahlberger at posteo.de>
> Signed-off-by: Julius Wiedmann <julius.wiedmann at fau.de>
> Signed-off-by: Dominik Huber <domi250 at gmx.de>
> ---
>  drivers/staging/erofs/erofs_fs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/erofs/erofs_fs.h b/drivers/staging/erofs/erofs_fs.h
> index d4bffa2852b3..892c913960c3 100644
> --- a/drivers/staging/erofs/erofs_fs.h
> +++ b/drivers/staging/erofs/erofs_fs.h
> @@ -38,9 +38,9 @@ struct erofs_super_block {
>  /* 80 */__u8 reserved2[48];     /* 128 bytes */
>  } __packed;
>  
> -#define __EROFS_BIT(_prefix, _cur, _pre)	enum {	\
> +#define __EROFS_BIT(_prefix, _cur, _pre)	(enum { \
>  	_prefix ## _cur ## _BIT = _prefix ## _pre ## _BIT + \
> -		_prefix ## _pre ## _BITS }
> +	_prefix ## _pre ## _BITS })

It seems not the valid C, here is the compiler error:

...

In file included from drivers/staging/erofs/internal.h:25:0,
                 from drivers/staging/erofs/xattr.h:16,
                 from drivers/staging/erofs/xattr.c:14:
drivers/staging/erofs/erofs_fs.h:41:43: error: expected identifier or ?(? before ?enum?
 #define __EROFS_BIT(_prefix, _cur, _pre) (enum { \
                                           ^
drivers/staging/erofs/erofs_fs.h:65:1: note: in expansion of macro ?__EROFS_BIT?
 __EROFS_BIT(EROFS_I_, DATA_MAPPING, VERSION);
 ^~~~~~~~~~~
make[3]: *** [scripts/Makefile.build:292: drivers/staging/erofs/xattr.o] Error 1

...


the __EROFS_BIT marco is used to define yyy_BIT according to xxx_BIT + xxx_BITS for cascade, eg.

__EROFS_BIT(EROFS_I_, DATA_MAPPING, VERSION);
it will defines EROFS_I_DATA_MAPPING_BIT = EROFS_I_VERSION_BIT + EROFS_I_VERSION_BITS;

__EROFS_BIT(EROFS_I_, FEATURE2, DATA_MAPPING);
it will defines EROFS_I_FEATURE2_BIT = EROFS_I_DATA_MAPPING_BIT + EROFS_I_DATA_MAPPING_BITS;


Thanks,
Gao Xiang

>  
>  /*
>   * erofs inode data mapping:
> 
