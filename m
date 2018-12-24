From: hsiangkao@aol.com (Gao Xiang)
Date: Tue, 25 Dec 2018 00:46:39 +0800
Subject: [PATCH] erofs-utils: fix tab algin to 8 spaces in the Makefile.am
In-Reply-To: <20181224102850.11967-1-bluce.liguifu@huawei.com>
References: <20181224102850.11967-1-bluce.liguifu@huawei.com>
Message-ID: <1316e16c-b7bf-4908-c3aa-67d6c3094ac3@aol.com>

Hi Guifu,

On 2018/12/24 18:28, Li Guifu wrote:
> The tab isnot 8 spaces in the Makefile.am, one line has
> been exceed 80 spaces, fix them.
> 
> Signed-off-by: Li Guifu <bluce.liguifu at huawei.com>
> ---
>  mkfs/Makefile.am | 37 +++++++++++++++++++------------------
>  1 file changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/mkfs/Makefile.am b/mkfs/Makefile.am
> index a9240e4..4933069 100644
> --- a/mkfs/Makefile.am
> +++ b/mkfs/Makefile.am
> @@ -2,27 +2,28 @@
>  AUTOMAKE_OPTIONS = foreign
>  bin_PROGRAMS     = mkfs.erofs
>  mkfs_erofs_SOURCES = erofs_compressor.c \
> -					 mkfs_file.c \
> -					 erofs_lz4hc.c \
> -					 mkfs_main.c \
> -					 erofs_cache.c \
> -					 erofs_io.c \
> -					 mkfs_inode.c \
> -					 erofs_config.c
> +		     mkfs_file.c \
> +		     erofs_lz4hc.c \
> +		     mkfs_main.c \
> +		     erofs_cache.c \
> +		     erofs_io.c \
> +		     mkfs_inode.c \
> +		     erofs_config.c
>  
>  noinst_HEADERS = erofs_config.h  \
> -				 mkfs_inode.h \
> -				 erofs_error.h \
> -				 erofs_lz4hc.h \
> -				 erofs_cache.h \
> -				 erofs_debug.h \
> -				 mkfs_erofs.h \
> -				 erofs_compressor.h \
> -				 erofs_io.h \
> -				 erofs_types.h \
> -				 mkfs_file.h
> +		 mkfs_inode.h \
> +		 erofs_error.h \
> +		 erofs_lz4hc.h \
> +		 erofs_cache.h \
> +		 erofs_debug.h \
> +		 mkfs_erofs.h \
> +		 erofs_compressor.h \
> +		 erofs_io.h \
> +		 erofs_types.h \
> +		 mkfs_file.h
>  
> -mkfs_erofs_CFLAGS = -Wall -Werror -DEROFS_MKFS_VERSION=\"v1.0\" -I$(top_srcdir)/include
> +mkfs_erofs_CFLAGS = -Wall -Werror -DEROFS_MKFS_VERSION=\"v1.0\" \
> +		    -I$(top_srcdir)/include

One patch should fix one kind of issues.

In addition, It is preferred to remove EROFS_MKFS_VERSION in another patch
since PACKAGE_VERSION and VERSION is already defined.
I will send another patch to fix that.

Applied partially of this patch.

Thanks,
Gao Xiang

>  ACLOCAL_AMFLAGS = -I m4
>  
>  if SUPPORT_LARG_FILE_AT_BIT32
> 
