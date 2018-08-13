From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Mon, 13 Aug 2018 15:40:14 +0300
Subject: [PATCH 3/8] staging: erofs: add error handling for xattr submodule
In-Reply-To: <c14184af-6378-fd96-3b9b-52c9a7da8463@huawei.com>
References: <20180812140150.13397-1-chao@kernel.org>
 <20180812140150.13397-4-chao@kernel.org>
 <20180813114725.kgoupvppcwsw2vyj@mwanda>
 <c14184af-6378-fd96-3b9b-52c9a7da8463@huawei.com>
Message-ID: <20180813124014.iivbtjrsdv5odnuu@mwanda>

On Mon, Aug 13, 2018@08:17:27PM +0800, Gao Xiang wrote:
> >> @@ -294,8 +322,11 @@ static int inline_getxattr(struct inode *inode, struct getxattr_iter *it)
> >>  		ret = xattr_foreach(&it->it, &find_xattr_handlers, &remaining);
> >>  		if (ret >= 0)
> >>  			break;
> >> +
> >> +		if (unlikely(ret != -ENOATTR))	/* -ENOMEM, -EIO, etc. */
> > 
> > I have held off commenting on all the likely/unlikely annotations we
> > are adding because I don't know what the fast paths are in this code.
> > However, this is clearly an error path here, not on a fast path.
> > 
> > Generally the rule on likely/unlikely is that they hurt readability so
> > we should only add them if it makes a difference in benchmarking.
> > 
> 
> In my opinion, return values other than 0 and ENOATTR(ENODATA) rarely happens,
> it should be in the slow path...
> 

What I'm trying to say is please stop adding so many likely/unlikely
annotations.  You should only add them if you have the benchmark data to
show the it really is required.


regards,
dan carpenter
