From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Mon, 8 Oct 2018 16:22:28 +0200
Subject: [PATCH v2] staging: erofs: add SPDX identifer
In-Reply-To: <20181008141409.2624-1-loic.tourlonias.lkml@gmail.com>
References: <20181008141409.2624-1-loic.tourlonias.lkml@gmail.com>
Message-ID: <20181008142228.GB13359@kroah.com>

On Mon, Oct 08, 2018@04:14:09PM +0200, Loic Tourlonias wrote:
> Add SPDX identifier to simplify header and remove whole license text
> 
> v1 -> v2:
> 
> Move SPDX identifier to first line and change comment delimiter

The "changes" need to go below the --- line.

> 
> Signed-off-by: Loic Tourlonias <loic.tourlonias.lkml at gmail.com>
> ---
>  drivers/staging/erofs/lz4defs.h | 24 ++----------------------
>  1 file changed, 2 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/staging/erofs/lz4defs.h b/drivers/staging/erofs/lz4defs.h
> index 00a0b58a0871..cdacc57e6a08 100644
> --- a/drivers/staging/erofs/lz4defs.h
> +++ b/drivers/staging/erofs/lz4defs.h
> @@ -1,32 +1,12 @@
> +/* SPDX-License-Identifier: BSD-2-Clause*/
>  #ifndef __LZ4DEFS_H__
>  #define __LZ4DEFS_H__
> -
>  /*

Why delete that line?

But wait, why do we even have this file at all?  What's wrong with the
lib/lz4/ code that we have in the kernel today?  Shouldn't the code
using these files be moved over to use the lib/ code instead and this
file be deleted?

thanks,

greg k-h
