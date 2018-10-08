From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Mon, 8 Oct 2018 15:49:28 +0200
Subject: [PATCH] staging: erofs: add SPDX identifer
In-Reply-To: <fe0ab9ae-3b71-7d63-053c-53b6dab95ef6@huawei.com>
References: <20181008104100.2369-1-loic.tourlonias.lkml@gmail.com>
 <fe0ab9ae-3b71-7d63-053c-53b6dab95ef6@huawei.com>
Message-ID: <20181008134928.GA31820@kroah.com>

On Mon, Oct 08, 2018@09:20:55PM +0800, Gao Xiang wrote:
> Hi Loic,
> 
> On 2018/10/8 18:41, Loic Tourlonias wrote:
> > Add SPDX identifier to simplify header and remove whole license text
> > 
> > Signed-off-by: Loic Tourlonias <loic.tourlonias.lkml at gmail.com>
> > ---
> >  drivers/staging/erofs/lz4defs.h | 23 ++---------------------
> >  1 file changed, 2 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/staging/erofs/lz4defs.h b/drivers/staging/erofs/lz4defs.h
> > index 00a0b58a0871..bdb1022981d8 100644
> > --- a/drivers/staging/erofs/lz4defs.h
> > +++ b/drivers/staging/erofs/lz4defs.h
> > @@ -1,32 +1,13 @@
> >  #ifndef __LZ4DEFS_H__
> >  #define __LZ4DEFS_H__
> >  
> > +// SPDX-License-Identifier: BSD-2-Clause
> 
> For *.h files, it seems SPDX Identifier should be /* SPDX-License-Identifier: */
> rather than // SPDX-License-Identifier:

That is correct.

> And I think it should be placed at the first line of the line, but I am not sure of that.

Yes, it has to be the first line.

The documentation for the SPDX lines in the kernel describe all of this.

thanks,

greg k-h
