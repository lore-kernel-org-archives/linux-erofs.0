From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Thu, 11 Oct 2018 13:18:08 +0300
Subject: [PATCH] staging: erofs: harden inode lookup for 32-bit platforms
In-Reply-To: <b6baf932-64e5-c902-7e7f-02094b96a8d6@huawei.com>
References: <20181009140713.29629-1-gaoxiang25@huawei.com>
 <20181011084413.3sovzgsj6pzyrml7@mwanda>
 <b6baf932-64e5-c902-7e7f-02094b96a8d6@huawei.com>
Message-ID: <20181011101807.hydncp6nhzjlzznr@mwanda>

On Thu, Oct 11, 2018@05:46:26PM +0800, Gao Xiang wrote:
> 
> 
> On 2018/10/11 16:44, Dan Carpenter wrote:
> > On Tue, Oct 09, 2018@10:07:13PM +0800, Gao Xiang wrote:
> >> This patch introduces inode hash function, test and set callbacks,
> >> and iget5_locked to find the right inode for 32-bit platforms.
> >>
> > 
> > The way I read this changelog, we're trying to deal with corrupt file
> > systems?  Is that correct?  Presumably in the current code it could lead
> > to a Oops or something?
> 
> No, this commit isn't trying to deal with corrupt file systems.
> In EROFS, the nid is not continuous and it represents the inode offset
> inode offset = nid * 32.
> Therefore the nid is 64-bit both for 32-bit and 64-bit platforms. However,
> i_ino is 'unsigned long', which means for 32-bit platforms, i_ino is not enough
> to contain the nid.
> 
> Therefore, we should use iget5_locked for this case.

I guess what I'm saying is, what are the user visible effects of this
patch?  It's hard for me to tell from the patch description.  Could you
please re-write the description and send a v2?

regards,
dan carpenter
