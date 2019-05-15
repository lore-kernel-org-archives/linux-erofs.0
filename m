From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 15 May 2019 13:18:43 +0800
Subject: [PATCH] staging: erofs: drop unneeded -Wall addition
In-Reply-To: <20190515043123.9106-1-yamada.masahiro@socionext.com>
References: <20190515043123.9106-1-yamada.masahiro@socionext.com>
Message-ID: <1a69420a-95c1-bd96-4382-229bcae391b0@huawei.com>



On 2019/5/15 12:31, Masahiro Yamada wrote:
> The top level Makefile adds -Wall globally:
> 
>   KBUILD_CFLAGS   := -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs \
> 
> I see two "-Wall" added for compiling objects in drivers/staging/erofs/.
> 
> Signed-off-by: Masahiro Yamada <yamada.masahiro at socionext.com>

Looks good to me and sorry about adding this flag...

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang

> ---
> 
>  drivers/staging/erofs/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/erofs/Makefile b/drivers/staging/erofs/Makefile
> index 38ab344a285e..a34248a2a16a 100644
> --- a/drivers/staging/erofs/Makefile
> +++ b/drivers/staging/erofs/Makefile
> @@ -2,7 +2,7 @@
>  
>  EROFS_VERSION = "1.0pre1"
>  
> -ccflags-y += -Wall -DEROFS_VERSION=\"$(EROFS_VERSION)\"
> +ccflags-y += -DEROFS_VERSION=\"$(EROFS_VERSION)\"
>  
>  obj-$(CONFIG_EROFS_FS) += erofs.o
>  # staging requirement: to be self-contained in its own directory
> 
