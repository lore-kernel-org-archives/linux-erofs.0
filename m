From: gregkh@linuxfoundation.org (Greg KH)
Date: Wed, 30 Jan 2019 19:19:09 +0100
Subject: patch "staging: erofs: keep corrupted fs from crashing kernel
 in" added to staging-linus
In-Reply-To: <1e5bad91-3d65-c086-d42c-f87d642e3204@huawei.com>
References: <15488587831390@kroah.com>
 <74cc60e3-eb87-d574-a106-305fb40ca54d@huawei.com>
 <1e5bad91-3d65-c086-d42c-f87d642e3204@huawei.com>
Message-ID: <20190130181909.GA16326@kroah.com>

On Wed, Jan 30, 2019@11:42:41PM +0800, Gao Xiang wrote:
> 
> 
> On 2019/1/30 23:05, Gao Xiang wrote:
> > 
> > Hi Greg,
> > 
> > Dan raised some suggestions to me. And I want to get some review ideas from Chao...
> > Current EROFS works good for the normal image, this patch is used for corrupted image only...
> > 
> > Could you kindly drop this patch temporarily and I want to get them reviewed...
> > Not soon... Thanks!
> 
> It seems this patch is the top of staging-linus...Could you kindly drop it and
> it is better to get "Reviewed-by:" tag for all EROFS bugfix patches from corresponding
> people (Chao, Dan, or Al if possible) first... Thank you very much!
> 
> sorry to trouble you...

No problem, now reverted.

greg k-h
