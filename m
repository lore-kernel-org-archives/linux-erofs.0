From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Wed, 12 Sep 2018 17:25:31 +0300
Subject: [PATCH 4/7] staging: erofs: return -EINVAL when specifying fault
 rate to 0
In-Reply-To: <0bee6199-25b4-a4bc-0655-ceac650e482a@gmx.com>
References: <20180912051034.3463-1-cgxu519@gmx.com>
 <20180912051034.3463-5-cgxu519@gmx.com>
 <20180912091631.xgxx5zj457z7srlo@mwanda>
 <0bee6199-25b4-a4bc-0655-ceac650e482a@gmx.com>
Message-ID: <20180912142531.nccw2a7zoyolrcym@mwanda>

On Wed, Sep 12, 2018@10:05:26PM +0800, cgxu519 wrote:
> On 09/12/2018 05:16 PM, Dan Carpenter wrote:
> > On Wed, Sep 12, 2018@01:10:31PM +0800, Chengguang Xu wrote:
> > > Set fault rate to 0 is useless and confusable, so add check to
> > > avoid it.
> > > 
> > I would have assumed setting rate to zero just disabled it.
> 
> I think currently it is useless because we have not implemented
> option parsing in remount yet, maybe it's better adding another
> option 'no_fault_injection' to explicitly disable it.

That's like the AC on my car, where I can't turn the fan from one to
zero, I have to press disable.  I don't like the explicit disable, I
wish they would just remove that button.

But I also don't think most people will ever use the fault injection
interface so it doesn't really matter.  Do whatever seems good to you.

regards,
dan carpenter
