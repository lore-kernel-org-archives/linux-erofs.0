From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 5 Nov 2018 13:27:31 +0800
Subject: [PATCH v2 1/2] staging: erofs: Modify conditional check.
In-Reply-To: <3db6ea6f3a7b1fab94e5dacc1ec4a026e38548c2.1541394756.git.digholebhagyashri@example.com>
References: <3db6ea6f3a7b1fab94e5dacc1ec4a026e38548c2.1541394756.git.digholebhagyashri@example.com>
Message-ID: <5d7fc290-08ad-0c83-d030-de255de81c47@huawei.com>

Hi Bhagyashri,

On 2018/11/5 13:13, Bhagyashri P. Dighole wrote:
> Found issue using checkpatch.
> Use ! for NULL test rather than explicitly comparing to NULL.
> 
> Signed-off-by: Bhagyashri P. Dighole <digholebhagyashri at gmail.com>
> ---
>  drivers/staging/erofs/data.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
> index 6384f73..a671ad4 100644
> --- a/drivers/staging/erofs/data.c
> +++ b/drivers/staging/erofs/data.c
> @@ -240,7 +240,7 @@ static inline struct bio *erofs_read_raw_page(
>  		bio = NULL;
>  	}
>  
> -	if (bio == NULL) {
> +	if (!bio) {
>  		struct erofs_map_blocks map = {
>  			.m_la = blknr_to_addr(current_block),
>  		};
> 

Could you please fix pointer comparisons to NULL all in once?
at least for a specific file (eg. for the staging/erofs/data.c only)?

It is somewhat weird to just fix one place only of data.c +243 as above,
this is my personal suggestion...

Thanks,
Gao Xiang
