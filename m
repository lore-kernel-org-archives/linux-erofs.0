From: loic.tourlonias.lkml@gmail.com (loic tourlonias)
Date: Mon, 8 Oct 2018 15:51:48 +0200
Subject: [PATCH] staging: erofs: add SPDX identifer
In-Reply-To: <fe0ab9ae-3b71-7d63-053c-53b6dab95ef6@huawei.com>
References: <20181008104100.2369-1-loic.tourlonias.lkml@gmail.com>
 <fe0ab9ae-3b71-7d63-053c-53b6dab95ef6@huawei.com>
Message-ID: <CAGy1LdS=OEtS=z-zgW=HFqe+sKhW32O1OyF4hzMQdUsVvtYZpQ@mail.gmail.com>

Hi,

On Mon, Oct 8, 2018@3:21 PM Gao Xiang <gaoxiang25@huawei.com> wrote:

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
> > diff --git a/drivers/staging/erofs/lz4defs.h
> b/drivers/staging/erofs/lz4defs.h
> > index 00a0b58a0871..bdb1022981d8 100644
> > --- a/drivers/staging/erofs/lz4defs.h
> > +++ b/drivers/staging/erofs/lz4defs.h
> > @@ -1,32 +1,13 @@
> >  #ifndef __LZ4DEFS_H__
> >  #define __LZ4DEFS_H__
> >
> > +// SPDX-License-Identifier: BSD-2-Clause
>
> For *.h files, it seems SPDX Identifier should be /*
> SPDX-License-Identifier: */
> rather than // SPDX-License-Identifier:
>
> And I think it should be placed at the first line of the line, but I am
> not sure of that.
>
> I would make the change and resubmit my patch in V2

Thanks,
> Gao Xiang
>
> Thanks,
Loic

> >  /*
> >   * lz4defs.h -- common and architecture specific defines for the kernel
> usage
> >
> >   * LZ4 - Fast LZ compression algorithm
> >   * Copyright (C) 2011-2016, Yann Collet.
> > - * BSD 2-Clause License (
> http://www.opensource.org/licenses/bsd-license.php)
> > - * Redistribution and use in source and binary forms, with or without
> > - * modification, are permitted provided that the following conditions
> are
> > - * met:
> > - *   * Redistributions of source code must retain the above copyright
> > - *     notice, this list of conditions and the following disclaimer.
> > - *   * Redistributions in binary form must reproduce the above
> > - * copyright notice, this list of conditions and the following
> disclaimer
> > - * in the documentation and/or other materials provided with the
> > - * distribution.
> > - * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> > - * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> > - * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
> > - * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> > - * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
> > - * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> > - * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> > - * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
> > - * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> > - * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
> > - * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> > + *
> >   * You can contact the author at :
> >   *   - LZ4 homepage : http://www.lz4.org
> >   *   - LZ4 source repository : https://github.com/lz4/lz4
> >
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: <http://lists.ozlabs.org/pipermail/linux-erofs/attachments/20181008/803e0fb6/attachment.html>
