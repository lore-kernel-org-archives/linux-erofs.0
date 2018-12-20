From: bluce.liguifu@huawei.com (Li Guifu)
Date: Thu, 20 Dec 2018 14:49:50 +0800
Subject: [PATCH v2 4/5] erofs-utils: add autogen.sh
In-Reply-To: <20181219043844.43451-4-gaoxiang25@huawei.com>
References: <20181219040516.21113-1-gaoxiang25@huawei.com>
 <20181219043844.43451-1-gaoxiang25@huawei.com>
 <20181219043844.43451-4-gaoxiang25@huawei.com>
Message-ID: <4d35d98b-547b-9e0b-f8f6-b06fabbd89e3@huawei.com>

On 2018/12/19 12:38, Gao Xiang wrote:
> In order to avoid type too many commands by hand.
>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
>  README     | 2 +-
>  autogen.sh | 8 ++++++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
>  create mode 100755 autogen.sh
>
> diff --git a/README b/README
> index 79a1126..4e34159 100644
> --- a/README
> +++ b/README
> @@ -22,7 +22,7 @@ How to build with lz4 static library
>  eg. if lz4 lib has been installed into fold of /usr/local/lib
>  	./configure --with-lz4=/usr/local/lib && make
>  Maybe you should run this first:
> -	libtoolize && aclocal && autoconf && autoheader && automake --add-missing
> +	./autogen.sh
>  
>  Usage:
>  $ ./mkfs.erofs
> diff --git a/autogen.sh b/autogen.sh
> new file mode 100755
> index 0000000..117f4bd
> --- /dev/null
> +++ b/autogen.sh
> @@ -0,0 +1,8 @@
> +#!/bin/sh
> +
> +aclocal && \
> +autoheader && \
> +autoconf && \
> +libtoolize && \
> +automake -a -c
> +

Reviewed-by: Li Guifu <bluce.liguifu at huawei.com>

Thanks,
