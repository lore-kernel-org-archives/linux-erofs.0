From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 13 Aug 2019 20:23:32 +0800
Subject: [PATCH v7 08/24] erofs: add namei functions
In-Reply-To: <20190813114821.GB11559@amd>
References: <20190813091326.84652-1-gaoxiang25@huawei.com>
 <20190813091326.84652-9-gaoxiang25@huawei.com>
 <20190813114821.GB11559@amd>
Message-ID: <20190813122332.GA17429@138>

Hi Pavel,

On Tue, Aug 13, 2019@01:48:21PM +0200, Pavel Machek wrote:
> Hi!
> 
> > +	/*
> > +	 * on-disk error, let's only BUG_ON in the debugging mode.
> > +	 * otherwise, it will return 1 to just skip the invalid name
> > +	 * and go on (in consideration of the lookup performance).
> > +	 */
> > +	DBG_BUGON(qd->name > qd->end);
> 
> I believe you should check for errors in non-debug mode, too.

Thanks for your kindly reply!

The following is just my personal thought... If I am wrong, please
kindly point out...

As you can see, this is a new prefixed string binary search algorithm
which can provide similar performance with hashed approach (but no
need to store hash value at all), so I really care about its lookup
performance.

There is something needing to be concerned, is, whether namei() should
report any potential on-disk issues or just return -ENOENT for these
corrupted dirs, I think I tend to use the latter one.

The reason (in my opinion) is if you consider another some another
complicated non-transverse ondisk implementation, it cannot transverse
all the entires so they could/couldn't report all potential issues
in namei() (For such corrupted dir, they can return -ENOENT due
to lack of information of course, just avoiding crashing the kernel
is OK).

Therefore, in my thought, such issue can be reported by fsck-like
tools such as erofs.fsck. And actually readdir() will also report
all issues as well, thus we can have performance gain on lookup.

> 
> 
> > +			if (unlikely(!ndirents)) {
> > +				DBG_BUGON(1);
> > +				kunmap_atomic(de);
> > +				put_page(page);
> > +				page = ERR_PTR(-EIO);
> > +				goto out;
> > +			}
> 
> -EUCLEAN is right error code for corrupted filesystem. (And you
>  probably want to print something to the syslog, too).

Yes, you are right :) -EUCLEAN/EFSCORRUPTED is actually for such thing,
nowadays, EROFS treats all EFSCORRUPTED cases into EIO, and I will
update that in one patch... (Yes, it needs to print something of course :))

Thanks,
Gao Xiang

> 
> 								Pavel
> -- 
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
