From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Tue, 18 Sep 2018 15:09:11 +0200
Subject: [PATCH 0/8] staging: erofs: error handing and more tracepoints
In-Reply-To: <20180918130337.jtq6ziqp6efr3fq4@mwanda>
References: <1536936030-62362-1-git-send-email-gaoxiang25@huawei.com>
 <20180918111953.GA3585@kroah.com>
 <aab26d0e-f8dc-cc83-46eb-7a93a833eaae@huawei.com>
 <20180918121413.GA499@kroah.com>
 <e940cdaf-faeb-7f60-b5ca-5f4d6af450be@huawei.com>
 <20180918130337.jtq6ziqp6efr3fq4@mwanda>
Message-ID: <20180918130911.GA16187@kroah.com>

On Tue, Sep 18, 2018@04:03:37PM +0300, Dan Carpenter wrote:
> On Tue, Sep 18, 2018@08:31:22PM +0800, Gao Xiang wrote:
> > (I have no clang environment to build kernel yet... :( I will try later, but I have no idea why it happens,
> > and it seems a false warning).
> > 
> > Thanks,
> > Gao Xiang
> > 
> > > 
> > > Or is gcc just being "dumb" here?  What about clang, have you tried
> > > building it with that compiler as well?
> 
> Yeah.  Gcc is wrong.  Gcc used to be extra conservative and missed a
> bunch of bugs, but I guess now they're going in to opposite direction?
> 
> Smatch gets this correct, but you have to rebuild the cross function DB
> twice to make the warning go away.  It could be because it starts out
> with the old vle_get_logical_extent_head() information so it thinks it
> knows how that function works.

Ok, thanks for checking (both of you).  Just initialize the variable to
keep gcc from printing foolish warnings.

thanks,

greg k-h
