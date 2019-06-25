From: zbestahu@gmail.com (Yue Hu)
Date: Tue, 25 Jun 2019 15:19:36 +0800
Subject: [PATCH] staging: erofs: remove unsupported ->datamode check in
 fill_inline_data()
In-Reply-To: <afd234f8-4cb3-4481-695b-1726ea7ad71e@aol.com>
References: <20190625061431.3964-1-zbestahu@gmail.com>
 <afd234f8-4cb3-4481-695b-1726ea7ad71e@aol.com>
Message-ID: <20190625151936.00005a26.zbestahu@gmail.com>

On Tue, 25 Jun 2019 15:13:49 +0800
Gao Xiang <hsiangkao@aol.com> wrote:

> Hi Yue,
> 
> On 2019/6/25 ????2:14, Yue Hu Wrote:
> > From: Yue Hu <huyue2 at yulong.com>
> > 
> > Already check if ->datamode is supported in read_inode(), no need to check
> > again in the next fill_inline_data() only called by fill_inode().
> > 
> > Signed-off-by: Yue Hu <huyue2 at yulong.com>
> > ---  
> 
> Is there any difference between two patches?

No. Sorry to send twice due to unstable network enviroment in my side.

Thx. 

> 
> Thanks,
> Gao Xiang
> 
> >  drivers/staging/erofs/inode.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
> > index e51348f..d6e1e16 100644
> > --- a/drivers/staging/erofs/inode.c
> > +++ b/drivers/staging/erofs/inode.c
> > @@ -129,8 +129,6 @@ static int fill_inline_data(struct inode *inode, void *data,
> >  	struct erofs_sb_info *sbi = EROFS_I_SB(inode);
> >  	const int mode = vi->datamode;
> >  
> > -	DBG_BUGON(mode >= EROFS_INODE_LAYOUT_MAX);
> > -
> >  	/* should be inode inline C */
> >  	if (mode != EROFS_INODE_LAYOUT_INLINE)
> >  		return 0;
> >   
