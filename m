From: zbestahu@gmail.com (Yue Hu)
Date: Tue, 25 Jun 2019 17:29:12 +0800
Subject: [PATCH] staging: erofs: return the error value if
 fill_inline_data() fails
In-Reply-To: <b724c331-5338-d827-6618-1bded956c41d@aol.com>
References: <20190625075943.2420-1-zbestahu@gmail.com>
 <b724c331-5338-d827-6618-1bded956c41d@aol.com>
Message-ID: <20190625172912.00002d55.zbestahu@gmail.com>

On Tue, 25 Jun 2019 17:19:36 +0800
Gao Xiang <hsiangkao@aol.com> wrote:

> On 2019/6/25 ????3:59, Yue Hu Wrote:
> > From: Yue Hu <huyue2 at yulong.com>
> > 
> > We should consider the error returned by fill_inline_data() when filling
> > last page in fill_inode(). If not getting inode will be successful even
> > though last page is bad. That is illogical. Also change -EAGAIN to 0 in
> > fill_inline_data() to stand for successful filling.
> > 
> > Signed-off-by: Yue Hu <huyue2 at yulong.com>  
> 
> looks good to me, yet I think you need to Cc staging mailing list at
> least if you want to upstream quickly (including your older patches...)
> 
> 
> Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
> 
> 
> (Don't forget to add 'PATCH RESEND' tag at the subject line if you
> resend these patches.)

Ok, got it.

Thx.

> 
> Thanks,
> Gao Xiang
> 
> 
> > ---
> >  drivers/staging/erofs/inode.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
> > index d6e1e16..1433f25 100644
> > --- a/drivers/staging/erofs/inode.c
> > +++ b/drivers/staging/erofs/inode.c
> > @@ -156,7 +156,7 @@ static int fill_inline_data(struct inode *inode, void *data,
> >  		inode->i_link = lnk;
> >  		set_inode_fast_symlink(inode);
> >  	}
> > -	return -EAGAIN;
> > +	return 0;
> >  }
> >  
> >  static int fill_inode(struct inode *inode, int isdir)
> > @@ -223,7 +223,7 @@ static int fill_inode(struct inode *inode, int isdir)
> >  		inode->i_mapping->a_ops = &erofs_raw_access_aops;
> >  
> >  		/* fill last page if inline data is available */
> > -		fill_inline_data(inode, data, ofs);
> > +		err = fill_inline_data(inode, data, ofs);
> >  	}
> >  
> >  out_unlock:
> >   
