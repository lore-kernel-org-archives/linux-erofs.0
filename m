From: hsiangkao@aol.com (Gao Xiang)
Date: Sun, 18 Aug 2019 20:38:59 +0800
Subject: [PATCH v3 RESEND] staging: erofs: fix an error handling in
 erofs_readdir()
In-Reply-To: <20190818123314.GA29733@bombadil.infradead.org>
References: <20190818030109.GA8225@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20190818032111.9862-1-hsiangkao@aol.com>
 <20190818123314.GA29733@bombadil.infradead.org>
Message-ID: <20190818123858.GA24535@hsiangkao-HP-ZHAN-66-Pro-G1>

On Sun, Aug 18, 2019@05:33:14AM -0700, Matthew Wilcox wrote:
> On Sun, Aug 18, 2019@11:21:11AM +0800, Gao Xiang wrote:
> > +		if (dentry_page == ERR_PTR(-ENOMEM)) {
> > +			errln("no memory to readdir of logical block %u of nid %llu",
> > +			      i, EROFS_V(dir)->nid);
> 
> I don't think you need the error message.  If we get a memory allocation
> failure, there's already going to be a lot of spew in the logs from the
> mm system.  And if we do fail to allocate memory, we don't need to know
> the logical block number or the nid -- it has nothiing to do with those;
> the system simply ran out of memory.

OK, I agree with you. There is a messy of messages when
memory allocation fail.

Since I don't really care apart from crashing or hanging
the kernel, I will resend the patch to make you and Chao
happy... :)

Thanks,
Gao Xiang

> 
> > +			err = -ENOMEM;
> > +			break;
> > +		} else if (IS_ERR(dentry_page)) {
> > +			errln("fail to readdir of logical block %u of nid %llu",
> > +			      i, EROFS_V(dir)->nid);
> > +			err = -EFSCORRUPTED;
> > +			break;
> > +		}
> >  
> >  		de = (struct erofs_dirent *)kmap(dentry_page);
> >  
> > -- 
> > 2.17.1
> > 
