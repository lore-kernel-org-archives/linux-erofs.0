From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Tue, 18 Jun 2019 08:45:23 +0200
Subject: [RFC PATCH 0/8] staging: erofs: decompression inplace approach
In-Reply-To: <df18d7f9-f65a-5697-c7c4-edb1ad846c3e@huawei.com>
References: <20190614181619.64905-1-gaoxiang25@huawei.com>
 <20190617203609.GA22034@kroah.com>
 <c86d3fc0-8b4a-6583-4309-911960fbe862@huawei.com>
 <20190618054709.GA4271@kroah.com>
 <df18d7f9-f65a-5697-c7c4-edb1ad846c3e@huawei.com>
Message-ID: <20190618064523.GA6015@kroah.com>

On Tue, Jun 18, 2019@02:18:00PM +0800, Gao Xiang wrote:
> 
> 
> On 2019/6/18 13:47, Greg Kroah-Hartman wrote:
> > On Tue, Jun 18, 2019@09:47:08AM +0800, Gao Xiang wrote:
> >>
> >>
> >> On 2019/6/18 4:36, Greg Kroah-Hartman wrote:
> >>> On Sat, Jun 15, 2019@02:16:11AM +0800, Gao Xiang wrote:
> >>>> At last, this is RFC patch v1, which means it is not suitable for
> >>>> merging soon... I'm still working on it, testing its stability
> >>>> these days and hope these patches get merged for 5.3 LTS
> >>>> (if 5.3 is a LTS version).
> >>>
> >>> Why would 5.3 be a LTS kernel?
> >>>
> >>> curious as to how you came up with that :)
> >>
> >> My personal thought is about one LTS kernel one year...
> >> Usually 5 versions after the previous kernel...(4.4 -> 4.9 -> 4.14 -> 4.19),
> >> which is not suitable for all historical LTSs...just prepare for 5.3...
> > 
> > I try to pick the "last" kernel that is released each year, which
> > sometimes is 5 kernels, sometimes 4, sometimes 6, depending on the
> > release cycle.
> > 
> > So odds are it will be 5.4 for the next LTS kernel, but we will not know
> > more until it gets closer to release time.
> 
> Thanks for kindly explanation :)
> 
> Anyway, I will test these patches, land to our commerical products and try the best
> efforts on making it more stable for Linux upstream to merge.

Sounds great.

But why do you need to add compression to get this code out of staging?
Why not move it out now and then add compression and other new features
to it then?

thanks,

greg k-h
