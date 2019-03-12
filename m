From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Tue, 12 Mar 2019 05:48:36 -0700
Subject: [PATCH 4.19 1/5] staging: erofs: add error handling for xattr
 submodule
In-Reply-To: <20190311060858.28654-1-gaoxiang25@huawei.com>
References: <20190311060858.28654-1-gaoxiang25@huawei.com>
Message-ID: <20190312124836.GA23414@kroah.com>

On Mon, Mar 11, 2019@02:08:54PM +0800, Gao Xiang wrote:
> commit cadf1ccf1b0021d0b7a9347e102ac5258f9f98c8 upstream.
> 
> This patch enhances the missing error handling code for
> xattr submodule, which improves the stability for the rare cases.
> 
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> Signed-off-by: Chao Yu <yuchao0 at huawei.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
> 
> This series resolves the following conflicts:
>  FAILED: patch "[PATCH] staging: erofs: fix fast symlink w/o xattr when fs xattr is" failed to apply to 4.19-stable tree
>  FAILED: patch "[PATCH] staging: erofs: fix memleak of inode's shared xattr array" failed to apply to 4.19-stable tree
>  FAILED: patch "[PATCH] staging: erofs: fix race of initializing xattrs of a inode at" failed to apply to 4.19-stable tree
>  FAILED: patch "[PATCH] staging: erofs: keep corrupted fs from crashing kernel in" failed to apply to 4.19-stable tree
> 
> In addition, there is another patch called
>  staging: erofs: add error handling for xattr submodule
> that needs to be backported to 4.19 as well (4.20+ already has this patch.)
> 
>  drivers/staging/erofs/internal.h |   5 +-
>  drivers/staging/erofs/xattr.c    | 112 +++++++++++++++++++++++++++------------
>  2 files changed, 81 insertions(+), 36 deletions(-)

All now queued up, thanks.

greg k-h
