From: bluce.liguifu@huawei.com (Li Guifu)
Date: Sat, 12 Jan 2019 13:36:04 +0800
Subject: [PATCH 1/2] erofs-utils: remove redundant EROFS_MKFS_VERSION
In-Reply-To: <20190111132836.16001-1-hsiangkao@aol.com>
References: <20190111132836.16001-1-hsiangkao@aol.com>
Message-ID: <5f1c0d9d-6e6a-1ce2-6d8f-b986c1b4d71f@huawei.com>

On 2019/1/11 21:28, Gao Xiang wrote:
> Let's use PACKAGE_VERSION exported by autoconf instead.
> Reset the version to 0.5 since there are still some stuffs to do.
>
> Signed-off-by: Gao Xiang <hsiangkao at aol.com>
> ---
>  configure.ac        | 2 +-
>  mkfs/Makefile.am    | 2 +-
>  mkfs/erofs_config.c | 3 ++-
>  mkfs/erofs_config.h | 4 ++--
>  4 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/configure.ac b/configure.ac
> index d9d6e0b..74ad0c0 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -2,7 +2,7 @@
>  # Process this file with autoconf to produce a configure script.
>  
>  AC_PREREQ([2.69])
> -AC_INIT([mkfs.erofs], [0.0.1], [bluce.liguifu at huawei.com])
> +AC_INIT([mkfs.erofs], [0.1], [bluce.liguifu at huawei.com])
>  AC_CONFIG_MACRO_DIR([m4])
>  AC_CONFIG_AUX_DIR(config)
>  AM_INIT_AUTOMAKE([foreign -Wall -Werror])
> diff --git a/mkfs/Makefile.am b/mkfs/Makefile.am
> index a17cc8c..9865f04 100644
> --- a/mkfs/Makefile.am
> +++ b/mkfs/Makefile.am
> @@ -21,7 +21,7 @@ noinst_HEADERS = erofs_config.h  \
>  		 erofs_io.h \
>  		 mkfs_file.h
>  
> -mkfs_erofs_CFLAGS = -Wall -Werror -DEROFS_MKFS_VERSION=\"v1.0\" -I$(top_srcdir)/include
> +mkfs_erofs_CFLAGS = -Wall -Werror -I$(top_srcdir)/include
>  ACLOCAL_AMFLAGS = -I m4
>  
>  if SUPPORT_LARG_FILE_AT_BIT32
> diff --git a/mkfs/erofs_config.c b/mkfs/erofs_config.c
> index e77f7cd..b4d969a 100644
> --- a/mkfs/erofs_config.c
> +++ b/mkfs/erofs_config.c
> @@ -9,6 +9,7 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> +#include "config.h"
>  #include "erofs_config.h"
>  #include "erofs_debug.h"
>  
> @@ -19,7 +20,7 @@ void mkfs_init_configure(void)
>  	memset(&erofs_cfg, 0, sizeof(erofs_cfg));
>  	erofs_cfg.c_alg_name = "none";
>  	erofs_cfg.c_dbg_lvl  = 0;
> -	erofs_cfg.c_version  = EROFS_MKFS_VERSION "   " __DATE__ " " __TIME__;
> +	erofs_cfg.c_version  = PACKAGE_VERSION "   " __DATE__ " " __TIME__;
>  }
>  
>  void mkfs_dump_config(void)
> diff --git a/mkfs/erofs_config.h b/mkfs/erofs_config.h
> index 34b2dee..7e38f87 100644
> --- a/mkfs/erofs_config.h
> +++ b/mkfs/erofs_config.h
> @@ -6,8 +6,8 @@
>   *             http://www.huawei.com/
>   * Created by Li Guifu <bluce.liguifu at huawei.com>
>   */
> -#ifndef __EROFS_CONFIG_H
> -#define __EROFS_CONFIG_H
> +#ifndef __EROFS_MKFS_CONFIG_H
> +#define __EROFS_MKFS_CONFIG_H
>  
>  /* workaround of a lz4 native compression issue, which can crash the program */
>  /* #define EROFS_CONFIG_COMPR_MAX_SZ        (1024 * 1024) */

It runs well
Reviewd-by bluce.liguifu at huawei.com
