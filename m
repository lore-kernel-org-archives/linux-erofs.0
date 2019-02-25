From: willy@infradead.org (Matthew Wilcox)
Date: Mon, 25 Feb 2019 08:04:17 -0800
Subject: [PATCH for-4.19 06/12] staging: erofs: fix race when the managed
 cache is enabled
In-Reply-To: <20190225155243.GB12525@kroah.com>
References: <20190220091854.19242-1-gaoxiang25@huawei.com>
 <20190220091854.19242-7-gaoxiang25@huawei.com>
 <20190225150449.GD16015@kroah.com>
 <20190225152548.GA2496@bombadil.infradead.org>
 <20190225155243.GB12525@kroah.com>
Message-ID: <20190225160417.GB2496@bombadil.infradead.org>

On Mon, Feb 25, 2019@04:52:43PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Feb 25, 2019@07:25:48AM -0800, Matthew Wilcox wrote:
> > Putting in all of 3159f943aafdbacb2f94c38fdaadabf2bbde2a14 would be a
> > bad idea; it actually ended up breaking m68k in a rather unexpected way
> > which required 66ee620f06f99d72475db6eb638559ba608c7dee, which in turn
> > caused a memory consumption regression ...
> 
> Where did the chain of regressions stop?  that would be good to know as
> we will have to deal with this over time :)

As far as I know, that terminated with
f32f004cddf86d63a9c42994bbce9f4e2f07c9fa but by the point you get there,
we've brought in the whole of the XArray which I, like you, would be
reluctant to do at this point.

It may make sense to bring in the whole of the XArray at some point to
make backporting other fixes easier, but I think we should give it a
few more months to be sure it's solid.
