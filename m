From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 23 May 2019 13:37:01 +0800
Subject: [PATCH] erofs-utils: fix an uninitialized variable
In-Reply-To: <20190523045717.GA15346@hlj.localdomain>
References: <20190523045717.GA15346@hlj.localdomain>
Message-ID: <43a07df7-324f-eb40-b2bc-e1606d126986@huawei.com>

Hi Lianjun,

On 2019/5/23 12:57, Lianjun Huang wrote:
> This fixes a building failure caused by using a variable before initialization.
> 
> Signed-off-by: Lianjun Huang <huanglianjun at vivo.com>

Thanks for your patch. I will apply this patch to the current mkfs-dev branch this evening.

p.s. could you have some time to take a look at erofs-mkfs and do some test/fixes on the new code,
https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/log/?h=experimental

I plan to send new mkfs code to mailing list for review, and switch new erofs-mkfs from experimental
to dev branch, and mark the current mkfs obsoleted since the new mkfs is more cleaner, powerful
(with designs to support the upcoming erofs features) and seems already stable...

Thanks,
Gao Xiang

> ---
>  mkfs/erofs_cache.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/erofs_cache.c b/mkfs/erofs_cache.c
> index 5bb293b..0d7acf7 100644
> --- a/mkfs/erofs_cache.c
> +++ b/mkfs/erofs_cache.c
> @@ -142,7 +142,7 @@ int erofs_flush_all_blocks(void)
>  	char *erofs_blk_buf;
>  	char *pbuf;
>  	int count;
> -	int ret;
> +	int ret = 0;
>  
>  	erofs_blk_buf = malloc(EROFS_BLKSIZE);
>  	if (!erofs_blk_buf)
> 
