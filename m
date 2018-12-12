From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 12 Dec 2018 20:18:05 +0800
Subject: [PATCH v2] staging:erofs: Remove __EROFS_BIT macro
In-Reply-To: <20181212120209.16304-1-aaron.strahlberger@posteo.de>
References: <9d324f50-e632-c020-04b9-57269ff7bdca@aol.com>
 <20181212120209.16304-1-aaron.strahlberger@posteo.de>
Message-ID: <6db43c9b-f668-167c-cc08-b19689329a27@huawei.com>

Hi Aaron,

On 2018/12/12 20:02, Aaron Strahlberger wrote:
> The `__EROFS_BIT` macro is used only once, do define the
> `EROFS_I_DATA_MAPPING_BIT` constant. This Patch removes this
> macro and expands it in the place it is used.
> 
> Signed-off-by: Aaron Strahlberger <aaron.strahlberger at posteo.de>
> Signed-off-by: Julius Wiedmann <julius.wiedmann at fau.de>
> Signed-off-by: Dominik Huber <domi250 at gmx.de>
> ---
>  drivers/staging/erofs/erofs_fs.h | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

> +
>  #define EROFS_I_VERSION_BITS            1
>  #define EROFS_I_DATA_MAPPING_BITS       3
>  
>  #define EROFS_I_VERSION_BIT             0
> -__EROFS_BIT(EROFS_I_, DATA_MAPPING, VERSION);
> +enum {
> +	EROFS_I_DATA_MAPPING_BIT = EROFS_I_VERSION_BIT + EROFS_I_VERSION_BITS
> +}

Thanks for your patch. I have fixed it yesterday,
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/commit/drivers/staging/erofs?h=staging-testing&id=ccd9c19c7ae165c70221b0a4927c31a56e395658

EROFS_I_DATA_MAPPING_BIT = EROFS_I_VERSION_BIT + EROFS_I_VERSION_BITS is not straight-forward as well for erofs on-disk format definition,
fix it to a plain number.

Thanks,
Gao Xiang

>  
>  struct erofs_inode_v1 {
>  /*  0 */__le16 i_advise;
> 
