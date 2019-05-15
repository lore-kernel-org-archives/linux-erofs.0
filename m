From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 15 May 2019 14:52:44 +0800
Subject: [PATCH] staging: erofs: drop unneeded -Wall addition
In-Reply-To: <20190515043123.9106-1-yamada.masahiro@socionext.com>
References: <20190515043123.9106-1-yamada.masahiro@socionext.com>
Message-ID: <8e8baf6c-b604-5546-7530-53d0fa8dcea1@huawei.com>

On 2019/5/15 12:31, Masahiro Yamada wrote:
> The top level Makefile adds -Wall globally:
> 
>   KBUILD_CFLAGS   := -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs \
> 
> I see two "-Wall" added for compiling objects in drivers/staging/erofs/.
> 
> Signed-off-by: Masahiro Yamada <yamada.masahiro at socionext.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
