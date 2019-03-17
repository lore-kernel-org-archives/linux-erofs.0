From: gregkh@linuxfoundation.org (Greg KH)
Date: Sun, 17 Mar 2019 12:11:12 +0100
Subject: [PATCH] [PATCH 1/1] staging: erofs: Add function comment for
 erofs/super.c
In-Reply-To: <20190312210640.2175-1-arshad.super@gmail.com>
References: <20190312210640.2175-1-arshad.super@gmail.com>
Message-ID: <20190317111112.GA4614@kroah.com>

On Wed, Mar 13, 2019@02:36:40AM +0530, Arshad Hussain wrote:
> This patch adds functions comment for file erofs/super.c in
> sphinx format.
> 
> Signed-off-by: Arshad Hussain <arshad.super at gmail.com>
> ---
>  drivers/staging/erofs/super.c | 135 ++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 131 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
> index 15c784fba879..60bfc3e8db7a 100644
> --- a/drivers/staging/erofs/super.c
> +++ b/drivers/staging/erofs/super.c
> @@ -30,6 +30,11 @@ static void init_once(void *ptr)
>  	inode_init_once(&vi->vfs_inode);
>  }
>  
> +/**
> + * erofs_init_inode_cache(): Create & initialize inode cache
> + *
> + * Returns: 0 on Success. Errno Otherwise.
> + */
>  static int __init erofs_init_inode_cache(void)

Why do you need kernel doc comments for local functions?  That should
not be needed.  No tool is going through this file to create
documentation, right?  And documentation is only needed for functions
that are called outside of the file at most, and usually only needed for
functions that other drivers/subsystems can call.

And for a function name like this, it is pretty obvious what it does, no
comment should be needed at all.

Same for the other changes here, I do not think it is needed at all.

thanks,

greg k-h
