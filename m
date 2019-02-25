From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Mon, 25 Feb 2019 16:51:20 +0100
Subject: [PATCH for-4.19 06/12] staging: erofs: fix race when the managed
 cache is enabled
In-Reply-To: <4efecbee-5e61-f8b4-a91a-3c14852bf574@huawei.com>
References: <20190220091854.19242-1-gaoxiang25@huawei.com>
 <20190220091854.19242-7-gaoxiang25@huawei.com>
 <20190225150449.GD16015@kroah.com>
 <4efecbee-5e61-f8b4-a91a-3c14852bf574@huawei.com>
Message-ID: <20190225155120.GA12525@kroah.com>

On Mon, Feb 25, 2019@11:07:19PM +0800, Gao Xiang wrote:
> 
> 
> On 2019/2/25 23:04, Greg Kroah-Hartman wrote:
> > On Wed, Feb 20, 2019@05:18:48PM +0800, Gao Xiang wrote:
> >> commit 51232df5e4b268936beccde5248f312a316800be upstream.
> >>
> >> When the managed cache is enabled, the last reference count
> >> of a workgroup must be used for its workstation.
> >>
> >> Otherwise, it could lead to incorrect (un)freezes in
> >> the reclaim path, and it would be harmful.
> >>
> >> A typical race as follows:
> >>
> >> Thread 1 (In the reclaim path)  Thread 2
> >> workgroup_freeze(grp, 1)                                refcnt = 1
> >> ...
> >> workgroup_unfreeze(grp, 1)                              refcnt = 1
> >>                                 workgroup_get(grp)      refcnt = 2 (x)
> >> workgroup_put(grp)                                      refcnt = 1 (x)
> >>                                 ...unexpected behaviors
> >>
> >> * grp is detached but still used, which violates cache-managed
> >>   freeze constraint.
> >>
> >> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> >> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> >> Signed-off-by: Greg Kroah-Hartman <gregkh at linuxfoundation.org>
> >> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> >>
> >> Conflicts:
> >> 	drivers/staging/erofs/utils.c
> >> Updates:
> >> 	include/linux/xarray.h:
> >> 		add xa_untag_pointer,xa_tag_pointer,xa_pointer_tag
> >> 		from upstream 3159f943aafd in order to reduce
> >> 		conflicts.
> > 
> > No, sorry, I don't want to add xarray.h to 4.19.y, that's crazy.
> 
> Or can I define these xa_untag_pointer,xa_tag_pointer,xa_pointer_tag in
> a erofs header internally? it is acceptable?

No, that's not ok.

If you want to backport a subset of the api, and Matthew agrees with it
(I think he did), then let's backport a subset, as a single patch, that
matches the original patch comments and git id.

thanks,

greg k-h
