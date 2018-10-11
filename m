From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Thu, 11 Oct 2018 14:12:04 +0300
Subject: [PATCH] staging: erofs: harden inode lookup for 32-bit platforms
In-Reply-To: <6318156d-4a3d-e5d0-93c1-90be2345565b@huawei.com>
References: <20181009140713.29629-1-gaoxiang25@huawei.com>
 <20181011084413.3sovzgsj6pzyrml7@mwanda>
 <b6baf932-64e5-c902-7e7f-02094b96a8d6@huawei.com>
 <20181011101807.hydncp6nhzjlzznr@mwanda>
 <6318156d-4a3d-e5d0-93c1-90be2345565b@huawei.com>
Message-ID: <20181011111204.zhxh5tw66pdxb3zh@mwanda>

On Thu, Oct 11, 2018@06:49:57PM +0800, Gao Xiang wrote:
> Hi Dan,
> 
> On 2018/10/11 18:18, Dan Carpenter wrote:
> > On Thu, Oct 11, 2018@05:46:26PM +0800, Gao Xiang wrote:
> >>
> >>
> >> On 2018/10/11 16:44, Dan Carpenter wrote:
> >>> On Tue, Oct 09, 2018@10:07:13PM +0800, Gao Xiang wrote:
> >>>> This patch introduces inode hash function, test and set callbacks,
> >>>> and iget5_locked to find the right inode for 32-bit platforms.
> >>>>
> >>>
> >>> The way I read this changelog, we're trying to deal with corrupt file
> >>> systems?  Is that correct?  Presumably in the current code it could lead
> >>> to a Oops or something?
> >>
> >> No, this commit isn't trying to deal with corrupt file systems.
> >> In EROFS, the nid is not continuous and it represents the inode offset
> >> inode offset = nid * 32.
> >> Therefore the nid is 64-bit both for 32-bit and 64-bit platforms. However,
> >> i_ino is 'unsigned long', which means for 32-bit platforms, i_ino is not enough
> >> to contain the nid.
> >>
> >> Therefore, we should use iget5_locked for this case.
> > 
> > I guess what I'm saying is, what are the user visible effects of this
> > patch?  It's hard for me to tell from the patch description.  Could you
> > please re-write the description and send a v2?
> 
> Sorry for my just hurry reply. It seems I really misunderstood your point :-(
> 
> If all nids are less than 32-bit, the user will see the correct inode/nid number
> for all 32-bit platforms, but if some nids are greater than 32-bit, it could be
> collisions without this patch for 32-bit platforms.
> 
> This patch switch the inode number by XOR the high 32-bit and the low 32-bit,
> use customized tester to avoid collisions for 32-bit platforms.
> 
> I will send v2 to fix the commit message...but it seems Greg is already merged in
> https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/commit/?h=staging-testing&id=2abd7814138774eb56319e9dcc0abd08ece45424
> 

Oh.  Then that's fine then.  If Greg already merged it, then it's too
late to change.  Thanks for the explanation, though.

regards,
dan carpenter
