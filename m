From: bluce.liguifu@huawei.com (Li Guifu)
Date: Thu, 20 Dec 2018 14:48:27 +0800
Subject: [PATCH v2 1/5] erofs-utils: introduce --with-lz4-include and
 --with-lz4-lib
In-Reply-To: <20181219043844.43451-1-gaoxiang25@huawei.com>
References: <20181219040516.21113-1-gaoxiang25@huawei.com>
 <20181219043844.43451-1-gaoxiang25@huawei.com>
Message-ID: <aa9bd29f-d7b6-f67b-aadf-652c61a57b12@huawei.com>

On 2018/12/19 12:38, Gao Xiang wrote:
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
> v1 -> v2:
>  - clean up configure.ac further.
>  - refine commit messages.
>
>  Makefile.am  |  1 -
>  configure.ac | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++---------
>  2 files changed, 61 insertions(+), 11 deletions(-)
>
> diff --git a/Makefile.am b/Makefile.am
> index b3dc472..cef847d 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -26,7 +26,6 @@ noinst_HEADERS = erofs_config.h  \
>  
>  mkfs_erofs_CFLAGS = -Wall -Werror -DEROFS_MKFS_VERSION=\"v1.0\"
>  mkfs_erofs_LDFLAGS  = --static
> -mkfs_erofs_LDADD   = $(LIBLZ4_STATIC)
>  ACLOCAL_AMFLAGS = -I m4
>  
>  if SUPPORT_LARG_FILE_AT_BIT32
> diff --git a/configure.ac b/configure.ac
> index 15974f8..4529576 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -12,27 +12,70 @@ AC_PROG_CC
>  AC_PROG_INSTALL
>  AC_PROG_LIBTOOL
>  
> +dnl EROFS_UTILS_PARSE_DIRECTORY
> +dnl Input:  $1 = a string to a relative or absolute directory
> +dnl Output: $2 = the variable to set with the absolute directory
> +AC_DEFUN([EROFS_UTILS_PARSE_DIRECTORY],
> +[
> + dnl Check if argument is a directory
> + if test -d $1 ; then
> +    dnl Get the absolute path of the directory
> +    dnl in case of relative directory.
> +    dnl If realpath is not a valid command,
> +    dnl an error is produced and we keep the given path.
> +    local_tmp=`realpath $1 2>/dev/null`
> +    if test "$local_tmp" != "" ; then
> +       if test -d "$local_tmp" ; then
> +           $2="$local_tmp"
> +       else
> +           $2=$1
> +       fi
> +    else
> +       $2=$1
> +    fi
> +    dnl Check for space in the directory
> +    if test `echo $1|cut -d' ' -f1` != $1 ; then
> +        AC_MSG_ERROR($1 directory shall not contain any space.)
> +    fi
> + else
> +    AC_MSG_ERROR($1 shall be a valid directory)
> + fi
> +])
>  
>  # checks system architecture firtly for enable support larg file
>  ARCH_BIT=`getconf LONG_BIT`
>  AM_CONDITIONAL([SUPPORT_LARG_FILE_AT_BIT32],[test x$ARCH_BIT = x32])
>  
>  # Checks for libraries.
> -# Ask user for path to liblz4.a stuff:.
> -AC_ARG_WITH(lz4,
> -    [ --with-lz4=<path> prefix of liblz4.a installation. e.g. /usr/local or /usr],
> -    [LIBLZ4_STATIC=$with_lz4/liblz4.a],
> -    AC_MSG_ERROR([You must call configure with the --with-lz4 option.
> -    This tells configure where to find the MySql C library and headers.
> -    e.g. --with-lz4=/usr/local or --with-lz4=/usr])
> -)
> +# Ask user for LZ4 library path if needed.
> +
> +AC_ARG_WITH(lz4_include,
> +   [  --with-lz4-include=DIR  LZ4 include directory ],
> +   EROFS_UTILS_PARSE_DIRECTORY(["$withval"],[withval])
> +   CPPFLAGS="$CPPFLAGS -I$withval")
> +
> +AC_ARG_WITH(lz4_lib,
> +   [  --with-lz4-lib=DIR      LZ4 lib directory ], [
> +   EROFS_UTILS_PARSE_DIRECTORY(["$withval"],[withval])
> +   LDFLAGS="$LDFLAGS -L$withval"
> +   lz4_lib_path="$withval"
> +  ])
>  
> -AC_SUBST(LIBLZ4_STATIC)
> +AC_ARG_WITH(lz4,
> +   [  --with-lz4=DIR          LZ4 install directory, e.g. /usr/local or /usr ], [
> +   EROFS_UTILS_PARSE_DIRECTORY(["$withval"],[withval])
> +   if test -z "$with_gmp_lib" && test -z "$with_gmp_include" ; then
> +      CPPFLAGS="$CPPFLAGS -I$withval/include"
> +      LDFLAGS="$LDFLAGS -L$withval/lib"
> +      lz4_lib_path="$withval/lib"
> +   else
> +      AC_MSG_FAILURE([Do not use --with-lz4 and --with-lz4-include/--with-lz4-lib options simultaneously.])
> +   fi
> +  ])
>  
>  # Checks for header files.
>  AC_CHECK_HEADERS([fcntl.h inttypes.h limits.h stddef.h stdint.h stdlib.h string.h sys/time.h unistd.h])
>  
> -
>  # Checks for typedefs, structures, and compiler characteristics.
>  AC_C_INLINE
>  AC_TYPE_INT64_T
> @@ -45,5 +88,13 @@ AC_TYPE_UINT64_T
>  AC_FUNC_MALLOC
>  AC_CHECK_FUNCS([ftruncate getcwd gettimeofday memset realpath strdup strerror strrchr strtoull])
>  
> +# Configure lz4.
> +have_lz4="1"
> +AC_CHECK_HEADERS([lz4.h], , [have_lz4="0"])
> +AC_CHECK_LIB(lz4, LZ4_versionNumber, [LIBS="-Wl,-Bstatic,-llz4,-Bdynamic $LIBS"] , [have_lz4="0"])
> +if test "x${have_lz4}" = "x0" ; then
> +  AC_MSG_ERROR([Cannot build without lz4])
> +fi
> +
>  AC_CONFIG_FILES([Makefile])
>  AC_OUTPUT

Reviewed-by: Li Guifu <bluce.liguifu at huawei.com>

Thanks,
