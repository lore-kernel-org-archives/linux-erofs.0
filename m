From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Fri, 15 Feb 2019 12:35:03 +0300
Subject: [PATCH v2] staging: erofs: keep corrupted fs from crashing
 kernel in erofs_namei()
In-Reply-To: <fb99bac2-2587-04fa-6ac2-f2e5f83af7c9@huawei.com>
References: <20190201121631.15179-1-gaoxiang25@huawei.com>
 <a9381c0d-9857-4d03-710d-80006d426bbc@huawei.com>
 <20190215075757.GG2326@kadam>
 <fb99bac2-2587-04fa-6ac2-f2e5f83af7c9@huawei.com>
Message-ID: <20190215093503.GH2326@kadam>

On Fri, Feb 15, 2019@05:32:33PM +0800, Chao Yu wrote:
> On 2019/2/15 15:57, Dan Carpenter wrote:
> > On Fri, Feb 15, 2019@03:02:25PM +0800, Chao Yu wrote:
> >> On 2019/2/1 20:16, Gao Xiang wrote:
> >>> +	/*
> >>> +	 * on-disk error, let's only BUG_ON in the debugging mode.
> >>> +	 * otherwise, it will return 1 to just skip the invalid name
> >>> +	 * and go on (in consideration of the lookup performance).
> >>> +	 */
> >>> +	DBG_BUGON(qd->name > qd->end);
> >>
> >> qd->name == qd->end is not allowed as well?
> >>
> >> So will it be better to return directly here?
> >>
> >> 	if (unlikely(qd->name >= qd->end)) {
> >> 		DBG_BUGON(1);
> >> 		return 1;
> >> 	}
> > 
> > Please don't add likely/unlikely() annotations unless you have
> > benchmarked it and it makes a difference.
> 
> Well, it only occur for corrupted image, since the image is readonly, so it
> is really rare.

The likely/unlikely() annotations make the code harder to read.  It's
only worth it if it's is a speedup on a fast path.

regards,
dan carpenter
