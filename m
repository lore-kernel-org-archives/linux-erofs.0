From: linux@weissschuh.net (Thomas =?utf-8?Q?Wei=C3=9Fschuh?=)
Date: Mon, 10 Sep 2018 21:15:28 +0200
Subject: [PATCH v3] staging: erofs: use explicit unsigned int type
In-Reply-To: <20180910081027.GA31845@kroah.com>
References: <5c44a63b-041d-1fce-0748-53c0b44f5983@huawei.com>
 <20180909183753.11021-1-linux@weissschuh.net>
 <20180910081027.GA31845@kroah.com>
Message-ID: <f3369321-d5b5-4b9e-87e4-b8ce341ec5e3@t-8ch.de>

Hi Greg,

On Mon, 2018-09-10T10:10+0200, Greg Kroah-Hartman wrote:
> On Sun, Sep 09, 2018@08:37:53PM +0200, Thomas Wei?schuh wrote:
> > Changes since v1:
> > 
> > * Removed changes that conflicted with
> >   [PATCH 1/6] staging: erofs: formatting fix in unzip_vle_lz4.c
> > * Added patch description
> > 
> > Changes since v2:
> > 
> > * Fixed conflicts with other patchsets
> > * Don't introduce new style issues
> > 
> 
> These changes belong below the --- line, not above it.  I'm not sure if
> git will handle this line:

> 
> > -- >8 --

The patch was supposed to be applied with "git am --scissors".
To be honest, I am not sure if the scissors feature of git is to be used for
kernel development, or if I should have announced it.
If is not applicable I will be happy to resend the patch in another format.

The documentation for git-mailinfo(1) sounded it would fit my usecase perfectly:

   ...
   This is useful if you want to begin your message in a discussion thread with comments and suggestions on the message you are responding to, and to conclude it with a
   patch submission, separating the discussion and the beginning of the proposed commit log message with a scissors line.
   ...

> Correctly or not, have you tried it?

I tried to both apply and compile the patch, both succeeded.

Thomas
