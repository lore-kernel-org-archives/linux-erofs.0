From: joe@perches.com (Joe Perches)
Date: Sun, 09 Dec 2018 09:30:02 -0800
Subject: [PATCH] staging: erofs: Add braces to do-while statements
In-Reply-To: <20181209162007.GA22432@kroah.com>
References: <20181209155900.10164-1-laumann.thomas@gmail.com>
 <20181209162007.GA22432@kroah.com>
Message-ID: <f461cdac6f3fd4502f9c061dcacd07cfee6503d9.camel@perches.com>

(mrph.  premature send)

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

	do
		<foo>;
	while (<bar>);

by about a 20:1 ratio.
