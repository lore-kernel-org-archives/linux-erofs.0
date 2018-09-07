From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Fri, 7 Sep 2018 12:17:25 +0300
Subject: [PATCH] staging: erofs: use explicit unsigned int type
In-Reply-To: <30069a92-3181-d032-c6b8-694f04455789@huawei.com>
References: <20180830205605.19492-1-linux@weissschuh.net>
 <a3a13e77-bd81-1dbd-de5f-8e796c21921d@huawei.com>
 <30069a92-3181-d032-c6b8-694f04455789@huawei.com>
Message-ID: <20180907091725.ilig4jnygqgsr6d5@mwanda>

On Fri, Sep 07, 2018@04:48:44PM +0800, Gao Xiang wrote:
> Hi Thomas,
> 
> On 2018/9/3 9:53, Chao Yu wrote:
> > Hi,
> > 
> > It looks like there is another patch from Pavel Zemlyanoy changing the same
> > place, I think it needs to rebase this patch on that one.
> > 
> > [PATCH 1/6] staging: erofs: formatting fix in unzip_vle_lz4.c
> > 
> 
> Thanks for your patch.
> 
> Do you have some interest to fix this patch as Chao's suggestion?
> Or I could fix this patch based on your work, if you have no time to do...Thanks in advance.

Gao, don't worry about it...  It's not a bug fix.  These kinds of
patches are straight forward to review.  You either apply it instantly
or you respond and delete it from your brain.

We don't try to co-ordinate patches.  We just apply whatever comes in
the order that it arrives.

If it's a bugfix then it's another story.  In that case we do ask people
to redo it.  Sometimes for security patches, I have fixed patches for
people and given them authorship credit with the From: header in git.
Other times maintainers write their own patch and give Reported-by
credit instead.

For checkpatch.pl patches, if you decide to do the work yourself then
there is no Reported-by tag required.

If you try to keep track of everyone sending patches then it's too much
work...  Forget about it.

regards,
dan carpenter
