From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Tue, 18 Sep 2018 14:14:13 +0200
Subject: [PATCH 0/8] staging: erofs: error handing and more tracepoints
In-Reply-To: <aab26d0e-f8dc-cc83-46eb-7a93a833eaae@huawei.com>
References: <1536936030-62362-1-git-send-email-gaoxiang25@huawei.com>
 <20180918111953.GA3585@kroah.com>
 <aab26d0e-f8dc-cc83-46eb-7a93a833eaae@huawei.com>
Message-ID: <20180918121413.GA499@kroah.com>

On Tue, Sep 18, 2018@08:02:30PM +0800, Gao Xiang wrote:
> Hi Greg,
> 
> On 2018/9/18 19:19, Greg Kroah-Hartman wrote:
> > On Fri, Sep 14, 2018@10:40:22PM +0800, Gao Xiang wrote:
> >> In order to avoid conflicts with cleanup patches, Chao and I think
> >> it is better to send reviewed preview patches in the erofs mailing list
> >> to the community in time.
> >>
> >> So here is reviewed & tested patches right now, which clean up and
> >> enhance the error handing and add some tracepoints for decompression.
> >>
> >> Note that in this patchset, bare use of 'unsigned' and NULL comparison are
> >> also fixed compared with the preview patches according to the previous
> >> discussion in the staging mailing list.
> > 
> > I applied this, but I need to go delete it as this patch series adds a
> > build warning to the system:
> > 
> > In file included from drivers/staging/erofs/unzip_vle.h:16:0,
> >                  from drivers/staging/erofs/unzip_vle.c:13:
> > drivers/staging/erofs/unzip_vle.c: In function ?z_erofs_map_blocks_iter?:
> > drivers/staging/erofs/internal.h:303:34: warning: ?pblk? may be used uninitialized in this function [-Wmaybe-uninitialized]
> >  #define blknr_to_addr(nr)       ((erofs_off_t)(nr) * EROFS_BLKSIZ)
> >                                   ^
> > drivers/staging/erofs/unzip_vle.c:1574:20: note: ?pblk? was declared here
> >   erofs_blk_t mblk, pblk;
> >                     ^~~~
> > 
> > Please fix that up and resend.
> 
> strange... my compiler (4.8.4) and huawei internal CI don't report that,
> and this patchset has been in Chao's tree for a while, I don't get any report so far...
> 
> I just looked into that code again and it seems a false warning since
> 1) this code is heavily running on the products and working fine till now.
> 2) pblk gets a proper value before unzip_vle.c:1690 map->m_pa = blknr_to_addr(pblk);
> 
> so I think I need to silence this warning for now and check if there is a really issue....

Don't just silent the warning.  Usually gcc now properly detects where
there really is a problem, it should not be a false-positive.  And in
looking at the code, it does seem that pblk could not be set if one of
the different case statements is taken and then exact_hitted: is jumped
to, right?

Or is gcc just being "dumb" here?  What about clang, have you tried
building it with that compiler as well?

thanks,

greg k-h
