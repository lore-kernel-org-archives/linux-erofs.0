From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 12 Sep 2018 19:22:43 +0800
Subject: [PATCH 3/7] staging: erofs: introduce a new helper
 __erofs_build_fault_attr()
In-Reply-To: <20180912051034.3463-4-cgxu519@gmx.com>
References: <20180912051034.3463-1-cgxu519@gmx.com>
 <20180912051034.3463-4-cgxu519@gmx.com>
Message-ID: <815bae09-2948-4bac-ef55-abf6d2595750@huawei.com>

Hi Chengguang,

On 2018/9/12 13:10, Chengguang Xu wrote:
> Introduce a new helper __erofs_build_fault_attr() to handle set/clear
> erofs_fault_info, we need this funciton for internal use case.
> for example, reset fault_injection option in remount.
> 
> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
> ---
>  drivers/staging/erofs/super.c | 26 ++++++++++++++++++--------
>  1 file changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
> index 14dbb6517b8d..d2dbc1fd3abb 100644
> --- a/drivers/staging/erofs/super.c
> +++ b/drivers/staging/erofs/super.c
> @@ -144,15 +144,9 @@ char *erofs_fault_name[FAULT_MAX] = {
>  	[FAULT_KMALLOC]		= "kmalloc",
>  };
>  
> -static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
> -					substring_t *args)
> +static void __erofs_build_fault_attr(struct erofs_sb_info *sbi,
> +					unsigned int rate)
>  {
> -	struct erofs_fault_info *ffi = &sbi->fault_info;
> -	int rate = 0;
> -
> -	if (args->from && match_int(args, &rate))
> -		return -EINVAL;
> -
>  	if (rate) {

I get some compile error of this patch...
drivers/staging/erofs/super.c: In function ?__erofs_build_fault_attr?:
drivers/staging/erofs/super.c:156:15: error: ?ffi? undeclared (first use in this function)
   atomic_set(&ffi->inject_ops, 0);
               ^
drivers/staging/erofs/super.c:156:15: note: each undeclared identifier is reported only once for each function it appears in
drivers/staging/erofs/super.c: In function ?erofs_build_fault_attr?:
drivers/staging/erofs/super.c:169:27: warning: unused variable ?ffi? [-Wunused-variable]
  struct erofs_fault_info *ffi = &sbi->fault_info;

p.s. could you please rebase your patch on Thomas's [PATCH v4] staging: erofs: use explicit unsigned int type ?
since I'm rebasing the rest PREVIEW patches on this commit now.

p.p.s. I'd like to get Chao's idea of this fault injection patchset first :)

Thanks,
Gao Xiang
