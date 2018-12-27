From: bluce.liguifu@huawei.com (Li Guifu)
Date: Thu, 27 Dec 2018 20:10:54 +0800
Subject: [PATCH 2/2] erofs-utils: introduce a unique header for definitions
In-Reply-To: <20181225060744.31239-2-gaoxiang25@huawei.com>
References: <20181225060744.31239-1-gaoxiang25@huawei.com>
 <20181225060744.31239-2-gaoxiang25@huawei.com>
Message-ID: <afa34308-03cf-65d2-27dc-da41a0f82120@huawei.com>

On 2018/12/25 14:07, Gao Xiang wrote:
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
>  configure.ac                               | 13 +++++-
>  mkfs/erofs_types.h => include/erofs/defs.h | 66 ++++++++++++++++++++++--------
>  include/erofs/list.h                       |  9 +---
>  mkfs/Makefile.am                           |  1 -
>  mkfs/erofs_cache.c                         |  2 +-
>  mkfs/mkfs_erofs.h                          |  1 -
>  mkfs/mkfs_file.c                           |  1 -
>  7 files changed, 62 insertions(+), 31 deletions(-)
>  rename mkfs/erofs_types.h => include/erofs/defs.h (59%)
>
> diff --git a/configure.ac b/configure.ac
> index 524252f..d9d6e0b 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -76,7 +76,18 @@ AC_ARG_WITH(lz4,
>    ])
>  
>  # Checks for header files.
> -AC_CHECK_HEADERS([fcntl.h inttypes.h limits.h stddef.h stdint.h stdlib.h string.h sys/time.h unistd.h])
> +AC_CHECK_HEADERS(m4_flatten([
> +	fcntl.h
> +	inttypes.h
> +	linux/types.h
> +	limits.h
> +	stddef.h
> +	stdint.h
> +	stdlib.h
> +	string.h
> +	sys/time.h
> +	unistd.h
> +]))
>  
>  # Checks for typedefs, structures, and compiler characteristics.
>  AC_C_INLINE
> diff --git a/mkfs/erofs_types.h b/include/erofs/defs.h
> similarity index 59%
> rename from mkfs/erofs_types.h
> rename to include/erofs/defs.h
> index 11fa21b..f90aa19 100644
> --- a/mkfs/erofs_types.h
> +++ b/include/erofs/defs.h
> @@ -1,31 +1,60 @@
>  /* SPDX-License-Identifier: GPL-2.0+ */
>  /*
> - * erofs_types.h
> + * include/erofs/defs.h
>   *
>   * Copyright (C) 2018 HUAWEI, Inc.
>   *             http://www.huawei.com/
>   * Created by Li Guifu <bluce.liguifu at huawei.com>
> + * Modified by Gao Xiang <gaoxiang25 at huawei.com>
>   */
> -#ifndef __EROFS_TYPES_H
> -#define __EROFS_TYPES_H
> -#include <inttypes.h>
> -#include <endian.h>
> -#include <linux/types.h>
> -#include <sys/types.h>
> -#include <asm/types.h>
> +#ifndef __EROFS_DEFS_H
> +#define __EROFS_DEFS_H
> +
> +#include <stddef.h>
>  #include <stdint.h>
> -#include <sys/cdefs.h>
>  #include <assert.h>
> -#include <bits/byteswap.h>
> +#include <inttypes.h>
> +
> +#ifdef HAVE_CONFIG_H
> +#include <config.h>
> +#endif
> +
> +#ifdef HAVE_LINUX_TYPES_H
> +#include <linux/types.h>
> +#endif
> +
> +/*
> + * container_of - cast a member of a structure out to the containing structure
> + * @ptr:	the pointer to the member.
> + * @type:	the type of the container struct this is embedded in.
> + * @member:	the name of the member within the struct.
> + */
> +#define container_of(ptr, type, member) ({			\
> +	const typeof(((type *)0)->member) *__mptr = (ptr);	\
> +	(type *)((char *)__mptr - offsetof(type, member)); })
>  
> -#define u8  uint8_t
> -#define u16 uint16_t
> -#define u32 uint32_t
> -#define u64 uint64_t
> -#define s8  int8_t
> -#define s16 int16_t
> -#define s32 int32_t
> -#define s64 int64_t
> +typedef uint8_t         u8;
> +typedef uint16_t        u16;
> +typedef uint32_t        u32;
> +typedef uint64_t        u64;
> +
> +#ifndef HAVE_LINUX_TYPES_H
> +typedef u8	__u8;
> +typedef u16	__u16;
> +typedef u32	__u32;
> +typedef u64	__u64;
> +typedef u16	__le16;
> +typedef u32	__le32;
> +typedef u64	__le64;
> +typedef u16	__be16;
> +typedef u32	__be32;
> +typedef u64	__be64;
> +#endif
> +
> +typedef int8_t          s8;
> +typedef int16_t         s16;
> +typedef int32_t         s32;
> +typedef int64_t         s64;
>  
>  #if __BYTE_ORDER == __LITTLE_ENDIAN
>  /*
> @@ -68,3 +97,4 @@
>  #define BITS_TO_LONGS(nr)   DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
>  
>  #endif
> +
> diff --git a/include/erofs/list.h b/include/erofs/list.h
> index 8dcbc5b..aeef713 100644
> --- a/include/erofs/list.h
> +++ b/include/erofs/list.h
> @@ -9,20 +9,13 @@
>  #ifndef __EROFS_LIST_HEAD_H
>  #define __EROFS_LIST_HEAD_H
>  
> -#include <assert.h>
> -#include <stddef.h>
> +#include <erofs/defs.h>
>  
>  struct list_head {
>  	struct list_head *prev;
>  	struct list_head *next;
>  };
>  
> -#define container_of(ptr, type, member)                                        \
> -	({                                                                     \
> -		const typeof(((type *)0)->member) *__mptr = (ptr);             \
> -		(type *)((char *)__mptr - offsetof(type, member));             \
> -	})
> -
>  #define LIST_HEAD_INIT(name)                                                   \
>  	{                                                                      \
>  		&(name), &(name)                                               \
> diff --git a/mkfs/Makefile.am b/mkfs/Makefile.am
> index faddec1..a17cc8c 100644
> --- a/mkfs/Makefile.am
> +++ b/mkfs/Makefile.am
> @@ -19,7 +19,6 @@ noinst_HEADERS = erofs_config.h  \
>  		 mkfs_erofs.h \
>  		 erofs_compressor.h \
>  		 erofs_io.h \
> -		 erofs_types.h \
>  		 mkfs_file.h
>  
>  mkfs_erofs_CFLAGS = -Wall -Werror -DEROFS_MKFS_VERSION=\"v1.0\" -I$(top_srcdir)/include
> diff --git a/mkfs/erofs_cache.c b/mkfs/erofs_cache.c
> index c8af3de..aecca98 100644
> --- a/mkfs/erofs_cache.c
> +++ b/mkfs/erofs_cache.c
> @@ -11,7 +11,7 @@
>  #include <stdint.h>
>  #include <errno.h>
>  
> -#include "erofs_types.h"
> +#include <erofs/defs.h>
>  #include "erofs_cache.h"
>  #include "erofs_error.h"
>  #include "erofs_debug.h"
> diff --git a/mkfs/mkfs_erofs.h b/mkfs/mkfs_erofs.h
> index 26f891c..e8b6f1b 100644
> --- a/mkfs/mkfs_erofs.h
> +++ b/mkfs/mkfs_erofs.h
> @@ -12,7 +12,6 @@
>  
>  #include <linux/limits.h>
>  #include <erofs/list.h>
> -#include "erofs_types.h"
>  
>  typedef unsigned int __u32;
>  
> diff --git a/mkfs/mkfs_file.c b/mkfs/mkfs_file.c
> index bb9877e..382e9b6 100644
> --- a/mkfs/mkfs_file.c
> +++ b/mkfs/mkfs_file.c
> @@ -27,7 +27,6 @@
>  #ifndef O_BINARY
>  #define O_BINARY 0
>  #endif
> -#include "erofs_types.h"
>  #include <erofs/list.h>
>  #include "erofs_cache.h"
>  #include "erofs_compressor.h"

Reviewed-by: Li Guifu <bluce.liguifu at huawei.com>

Thanks,
