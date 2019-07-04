From: zbestahu@gmail.com (Yue Hu)
Date: Thu, 4 Jul 2019 09:59:03 +0800
Subject: [PATCH RESEND v3] staging: erofs: remove unsupported ->datamode
 check in fill_inline_data()
In-Reply-To: <20190703162038.GA31307@kroah.com>
References: <20190702025601.7976-1-zbestahu@gmail.com>
 <20190703162038.GA31307@kroah.com>
Message-ID: <20190704095903.0000565e.zbestahu@gmail.com>

On Wed, 3 Jul 2019 18:20:38 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Tue, Jul 02, 2019@10:56:01AM +0800, Yue Hu wrote:
> > From: Yue Hu <huyue2 at yulong.com>
> > 
> > Already check if ->datamode is supported in read_inode(), no need to check
> > again in the next fill_inline_data() only called by fill_inode().
> > 
> > Signed-off-by: Yue Hu <huyue2 at yulong.com>
> > Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
> > Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> > ---
> > no change
> > 
> >  drivers/staging/erofs/inode.c | 2 --
> >  1 file changed, 2 deletions(-)  
> 
> This is already in my tree, right?

Seems not, i have received notes about other 2 patches below mergerd:

```note1
This is a note to let you know that I've just added the patch titled

    staging: erofs: don't check special inode layout

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.
```

```note2
This is a note to let you know that I've just added the patch titled

    staging: erofs: return the error value if fill_inline_data() fails

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.
```

No this patch in below link checked:

https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/log/drivers/staging/erofs?h=staging-testing

Thanks.

> 
> confused,
> 
> greg k-h
