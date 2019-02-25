From: willy@infradead.org (Matthew Wilcox)
Date: Mon, 25 Feb 2019 07:25:48 -0800
Subject: [PATCH for-4.19 06/12] staging: erofs: fix race when the managed
 cache is enabled
In-Reply-To: <20190225150449.GD16015@kroah.com>
References: <20190220091854.19242-1-gaoxiang25@huawei.com>
 <20190220091854.19242-7-gaoxiang25@huawei.com>
 <20190225150449.GD16015@kroah.com>
Message-ID: <20190225152548.GA2496@bombadil.infradead.org>

On Mon, Feb 25, 2019@04:04:49PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Feb 20, 2019@05:18:48PM +0800, Gao Xiang wrote:
> > commit 51232df5e4b268936beccde5248f312a316800be upstream.
> > Updates:
> > 	include/linux/xarray.h:
> > 		add xa_untag_pointer,xa_tag_pointer,xa_pointer_tag
> > 		from upstream 3159f943aafd in order to reduce
> > 		conflicts.
> 
> No, sorry, I don't want to add xarray.h to 4.19.y, that's crazy.

I gave this a quick look when it came past, and I don't particularly
object to this piece going into 4.19.y.  A full-on backport of XArray
to 4.19 will be ... interesting, but essentially this is just some
boilerplate.

> And even if we did, you do not slip it in as part of a different patch,
> it should come in as its own patch, with the same git commit id that it
> landed in 4.20 with.

Putting in all of 3159f943aafdbacb2f94c38fdaadabf2bbde2a14 would be a
bad idea; it actually ended up breaking m68k in a rather unexpected way
which required 66ee620f06f99d72475db6eb638559ba608c7dee, which in turn
caused a memory consumption regression ...

But putting in the xa_tag_pointer() API doesn't concern me.

> Please fix this up...
> 
> greg k-h
