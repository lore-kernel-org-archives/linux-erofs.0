From: linux.bhar@gmail.com (Bharath Vedartham)
Date: Mon, 18 Mar 2019 21:30:56 +0530
Subject: [PATCH v3] staging: erofs: Add whitespace after declaration
In-Reply-To: <863a7266-0068-a751-bbe6-cea78caf9355@huawei.com>
References: <20190318153224.GA3596@bharath12345-Inspiron-5559>
 <20190318153816.GA15943@kroah.com>
 <863a7266-0068-a751-bbe6-cea78caf9355@huawei.com>
Message-ID: <20190318160056.GA4640@bharath12345-Inspiron-5559>

On Mon, Mar 18, 2019@11:40:35PM +0800, Gao Xiang wrote:
> 
> 
> On 2019/3/18 23:38, Greg KH wrote:
> > On Mon, Mar 18, 2019@09:02:24PM +0530, Bharath Vedartham wrote:
> >> Add whitespace after declaration. Fixed the checkpatch.pl warning.
> >>
> >> ---
> > 
> > No signed-off-by?
> > 
> >> changes since v2
> >> 	- mutt gave me a lot of problems. Hence 3 patches for a really
> >> 	  small problem.
> >> 	- Fixed the extra missing line.
> >>
> >> Signed-off-by: Bharath Vedartham <linux.bhar at gmail.com>
> > 
> > It needs to be above the --- line, otherwise it will be stripped off
> > when applied.
> > 
> > v4 please?
Missed that! Really sorry!
>
> Actually a duplicate commit, see:
> https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/commit/?h=staging-next&id=8af36478f9516d51fcfedf9b9ed8905a1c00d278
> 
> several people submit patches on this line in erofs_iget()....
> 
Oh alright then! I ll stop this patch here! Thank for your time! I have
noticed that there are a few functions and structs local to a file in erofs without static
declaration. I ll send a patch soon.
> Thanks,
> Gao Xiang
> 
> > 
> > thanks,
> > 
> > greg k-h
> > 
