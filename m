From: joe@perches.com (Joe Perches)
Date: Sun, 09 Dec 2018 09:27:01 -0800
Subject: [PATCH] staging: erofs: Add braces to do-while statements
In-Reply-To: <20181209162007.GA22432@kroah.com>
References: <20181209155900.10164-1-laumann.thomas@gmail.com>
 <20181209162007.GA22432@kroah.com>
Message-ID: <f741ac1808f05f2efe6532491e8b1eb6ac74e260.camel@perches.com>

On Sun, 2018-12-09@17:20 +0100, Greg KH wrote:
> On Sun, Dec 09, 2018@04:59:00PM +0100, Thomas Jespersen wrote:
> > This fixes warning reported by sparse (with -Wsparse-all).
> 
> Why is sparse warning about this?

Probably because it's the kernel preferred style
to use single statement

	do {
		<foo>;
	} while (<bar>);

over

by about a 20:1 ratio.

> > Signed-off-by: Thomas Jespersen <laumann.thomas at gmail.com>obab
> > ---
> >  drivers/staging/erofs/internal.h | 4 ++--
> >  drivers/staging/erofs/utils.c    | 4 ++--
> >  2 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
> > index 57575c7f5635..bf180a803446 100644
> > --- a/drivers/staging/erofs/internal.h
> > +++ b/drivers/staging/erofs/internal.h
> > @@ -232,9 +232,9 @@ static inline bool erofs_workgroup_get(struct erofs_workgroup *grp, int *ocnt)
> >  	/* spin if it is temporarily locked at the reclaim path */
> >  	if (unlikely(o == locked)) {
> >  #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
> > -		do
> > +		do {
> >  			cpu_relax();
> > -		while (atomic_read(&grp->refcount) == locked);
> > +		} while (atomic_read(&grp->refcount) == locked);
> 
> That looks like valid code to me, why change this?
> 
> greg k-h
