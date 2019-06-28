From: zbestahu@gmail.com (Yue Hu)
Date: Fri, 28 Jun 2019 12:19:52 +0800
Subject: [PATCH] staging: erofs: don't check special inode layout
In-Reply-To: <276837dc-b18a-6f20-fc33-d988dff5ae9f@huawei.com>
References: <20190628034234.8832-1-zbestahu@gmail.com>
 <276837dc-b18a-6f20-fc33-d988dff5ae9f@huawei.com>
Message-ID: <20190628121952.000028fc.zbestahu@gmail.com>

On Fri, 28 Jun 2019 11:50:21 +0800
Gao Xiang <gaoxiang25@huawei.com> wrote:

> Hi Yue,
> 
> On 2019/6/28 11:42, Yue Hu wrote:
> > From: Yue Hu <huyue2 at yulong.com>
> > 
> > Currently, we will check if inode layout is compression or inline if
> > the inode is special in fill_inode(). Also set ->i_mapping->a_ops for
> > it. That is pointless since the both modes won't be set for special
> > inode when creating EROFS filesystem image. So, let's avoid it.
> > 
> > Signed-off-by: Yue Hu <huyue2 at yulong.com>  
> 
> Have you test this patch with some actual image with legacy mkfs since
> new mkfs framework have not supported special inode...

Hi Xiang,

I'm studying the testing :)

However, already check the code handling for special inode in leagcy mkfs as below:

```c
                break;
        case EROFS_FT_BLKDEV:
        case EROFS_FT_CHRDEV:
        case EROFS_FT_FIFO:
        case EROFS_FT_SOCK:
                mkfs_rank_inode(d);
                break;

        default:
                erofs_err("inode[%s] file_type error =%d",
                          d->i_fullpath,
```

No special inode layout operations, so this change should be fine.

Thx.

> 
> I think that is fine in priciple, however, in case to introduce some potential
> issues, I will test this patch later. I will give a Reviewed-by tag after I tested
> this patch.

Thanks.

> 
> Thanks,
> Gao Xiang
> 
> > ---
> >  drivers/staging/erofs/inode.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
> > index 1433f25..2fe0f6d 100644
> > --- a/drivers/staging/erofs/inode.c
> > +++ b/drivers/staging/erofs/inode.c
> > @@ -205,6 +205,7 @@ static int fill_inode(struct inode *inode, int isdir)
> >  			S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
> >  			inode->i_op = &erofs_generic_iops;
> >  			init_special_inode(inode, inode->i_mode, inode->i_rdev);
> > +			goto out_unlock;
> >  		} else {
> >  			err = -EIO;
> >  			goto out_unlock;
> >   
