From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Mon, 18 Mar 2019 09:07:17 +0100
Subject: [PATCH v3 for-4.19] staging: erofs: fix race when the managed
 cache is enabled
In-Reply-To: <20190318072634.1940-1-gaoxiang25@huawei.com>
References: <20190318072634.1940-1-gaoxiang25@huawei.com>
Message-ID: <20190318080717.GB4746@kroah.com>

On Mon, Mar 18, 2019@03:26:34PM +0800, Gao Xiang wrote:
> commit 51232df5e4b268936beccde5248f312a316800be upstream.
> 
> When the managed cache is enabled, the last reference count
> of a workgroup must be used for its workstation.
> 
> Otherwise, it could lead to incorrect (un)freezes in
> the reclaim path, and it would be harmful.
> 
> A typical race as follows:
> 
> Thread 1 (In the reclaim path)  Thread 2
> workgroup_freeze(grp, 1)                                refcnt = 1
> ...
> workgroup_unfreeze(grp, 1)                              refcnt = 1
>                                 workgroup_get(grp)      refcnt = 2 (x)
> workgroup_put(grp)                                      refcnt = 1 (x)
>                                 ...unexpected behaviors
> 
> * grp is detached but still used, which violates cache-managed
>   freeze constraint.
> 
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
> 
> change log v3:
>  - avoid using xa_tag apis since Matthew refuses the first XArray patch
>    in the previous version again;
> 
> RESEND in order to ping due to lack of response from Matthew and Greg
> for half a month, patch 2/2 is needed to be backported to linux-4.19.

I've queued this up now, thanks.

greg k-h
