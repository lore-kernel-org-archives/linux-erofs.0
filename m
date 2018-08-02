From: yuchao0@huawei.com (Chao Yu)
Date: Thu, 2 Aug 2018 17:30:13 +0800
Subject: [PATCH] staging: erofs: disable compiling temporarile
In-Reply-To: <20180802191259.3ecf0e6d@canb.auug.org.au>
References: <20180802081152.81527-1-yuchao0@huawei.com>
 <c2208e7a-abaa-a608-029f-4fe003d82441@aol.com>
 <20180802191259.3ecf0e6d@canb.auug.org.au>
Message-ID: <7c30816d-01ec-bc83-d5ba-55e7287ea450@huawei.com>

Hi Stephen,

On 2018/8/2 17:12, Stephen Rothwell wrote:
> Hi all,
> 
> On Thu, 2 Aug 2018 16:40:05 +0800 Gao Xiang <hsiangkao@aol.com> wrote:
>>
>> How about mark EROFS BROKEN and actually I have no idea how to do in
>> detail...
>> If I misunderstand or it is totally wrong, please ignore and you can add:
> 
> This is all you actually need (this is what I used before today):

Alright, let me change the patch, thanks for providing this. :)

Thanks,

> 
> From: Stephen Rothwell <sfr at canb.auug.org.au>
> Date: Mon, 30 Jul 2018 16:10:57 +1000
> Subject: [PATCH] disable erofs for now
> 
> Signed-off-by: Stephen Rothwell <sfr at canb.auug.org.au>
> ---
>  drivers/staging/erofs/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/erofs/Kconfig b/drivers/staging/erofs/Kconfig
> index 663b755bf2fb..b37d994aa687 100644
> --- a/drivers/staging/erofs/Kconfig
> +++ b/drivers/staging/erofs/Kconfig
> @@ -3,6 +3,7 @@
>  config EROFS_FS
>  	tristate "EROFS filesystem support"
>  	depends on BLOCK
> +	depends on BROKEN
>  	help
>  	  EROFS(Enhanced Read-Only File System) is a lightweight
>  	  read-only file system with modern designs (eg. page-sized
> 
