From: hsiangkao@aol.com (Gao Xiang)
Date: Thu, 30 May 2019 23:32:44 +0800
Subject: [PATCH] erofs-utils: remove AC_FUNC_MALLOC check
In-Reply-To: <20190530095850.5260-1-zbestahu@gmail.com>
References: <20190530095850.5260-1-zbestahu@gmail.com>
Message-ID: <82e79e9a-5c90-677b-376e-f4c04e580f23@aol.com>

Hi Yue,

On 2019/5/30 ??????5:58, Yue Hu wrote:
> From: Yue Hu <huyue2 at yulong.com>
> 
> Below erros happened when building for ARM64, rpl_malloc is not
> supplied in that case, remove AC_FUNC_MALLOC can fix the errors.
> 
> mkfs_file.c: In function 'erofs_compress_file':
> mkfs_file.c:600:2: error: implicit declaration of function 'rpl_malloc' [-Werror=implicit-function-declaration]
>   inode->i_inline_data = malloc(EROFS_BLKSIZE);
>   ^
> mkfs_file.c:600:23: error: assignment makes pointer from integer without a cast [-Werror]
>   inode->i_inline_data = malloc(EROFS_BLKSIZE);
>                        ^
> mkfs_file.c: In function 'erofs_init_compress_context':
> mkfs_file.c:874:17: error: assignment makes pointer from integer without a cast [-Werror]
>   ctx->cc_srcbuf = malloc(erofs_cfg.c_compr_maxsz);
>                  ^
> mkfs_file.c:875:17: error: assignment makes pointer from integer without a cast [-Werror]
>   ctx->cc_dstbuf = malloc(erofs_cfg.c_compr_maxsz * 2);
>                  ^
> cc1: all warnings being treated as errors
> make[2]: *** [mkfs_erofs-mkfs_file.o] Error 1
> 
> Signed-off-by: Yue Hu <huyue2 at yulong.com>

Thanks for your report and patch, applied to mkfs-dev branch.
And as for new erofs-utils, it will be folded into the original patch
and I will send the whole series soon.

Thanks,
Gao Xiang

> ---
>  configure.ac | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 8e3f703..40ee765 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -98,7 +98,6 @@ AC_CHECK_MEMBERS([struct stat.st_rdev])
>  AC_TYPE_UINT64_T
>  
>  # Checks for library functions.
> -AC_FUNC_MALLOC
>  AC_CHECK_FUNCS([ftruncate getcwd gettimeofday memset realpath strdup strerror strrchr strtoull])
>  
>  # Configure lz4.
> 
