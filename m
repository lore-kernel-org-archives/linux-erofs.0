From: luc.vanoostenryck@gmail.com (Luc Van Oostenryck)
Date: Mon, 10 Dec 2018 01:42:18 +0100
Subject: [PATCH] staging: erofs: Add braces to do-while statements
In-Reply-To: <20181209194029.GA31163@kroah.com>
References: <20181209155900.10164-1-laumann.thomas@gmail.com>
 <20181209162007.GA22432@kroah.com>
 <f741ac1808f05f2efe6532491e8b1eb6ac74e260.camel@perches.com>
 <20181209194029.GA31163@kroah.com>
Message-ID: <20181210004217.ufzvj4rvykiqoufd@ltop.local>

On Sun, Dec 09, 2018@08:40:29PM +0100, Greg KH wrote:
> On Sun, Dec 09, 2018@09:27:01AM -0800, Joe Perches wrote:
> > On Sun, 2018-12-09@17:20 +0100, Greg KH wrote:
> > > On Sun, Dec 09, 2018@04:59:00PM +0100, Thomas Jespersen wrote:
> > > > This fixes warning reported by sparse (with -Wsparse-all).
> > > 
> > > Why is sparse warning about this?
> > 
> > Probably because it's the kernel preferred style
> > to use single statement
> > 
> > 	do {
> > 		<foo>;
> > 	} while (<bar>);
> > 
> > over
> > 
> > by about a 20:1 ratio.
> 
> Sparse is spitting out coding style complaints now?

To my own surprise, it's effectively sparse that complained:
	warning: do-while statement is not a compound statement

with the flag -Wsparse-all (or -Wdo-while).
But -Wsparse-all is not a flag normally used for the kernel
(or normaly used on anything at all).

-- Luc
