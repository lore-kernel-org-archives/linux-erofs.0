From: gregkh@linuxfoundation.org (Greg KH)
Date: Wed, 3 Jul 2019 18:20:38 +0200
Subject: [PATCH RESEND v3] staging: erofs: remove unsupported ->datamode
 check in fill_inline_data()
In-Reply-To: <20190702025601.7976-1-zbestahu@gmail.com>
References: <20190702025601.7976-1-zbestahu@gmail.com>
Message-ID: <20190703162038.GA31307@kroah.com>

On Tue, Jul 02, 2019@10:56:01AM +0800, Yue Hu wrote:
> From: Yue Hu <huyue2 at yulong.com>
> 
> Already check if ->datamode is supported in read_inode(), no need to check
> again in the next fill_inline_data() only called by fill_inode().
> 
> Signed-off-by: Yue Hu <huyue2 at yulong.com>
> Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> ---
> no change
> 
>  drivers/staging/erofs/inode.c | 2 --
>  1 file changed, 2 deletions(-)

This is already in my tree, right?

confused,

greg k-h
