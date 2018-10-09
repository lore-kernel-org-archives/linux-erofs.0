From: daeseok.youn@gmail.com (DaeSeok Youn)
Date: Tue, 9 Oct 2018 16:31:59 +0900
Subject: [PATCH] staging: erofs: adds a space around '*'
In-Reply-To: <61b485f4-539b-0f25-cf3d-574ebb17197c@embeddedor.com>
References: <20181008114518.GA2475@AD01277334>
 <61b485f4-539b-0f25-cf3d-574ebb17197c@embeddedor.com>
Message-ID: <CAHb8M2A1OSs=WmDKwy9F8H4jkLheiM89yJgzj9NnWZ7xF8RSmA@mail.gmail.com>

2018? 10? 8? (?) ?? 9:37, Gustavo A. R. Silva <gustavo at embeddedor.com>?? ??:
>
> Hi,
>
> On 10/8/18 1:45 PM, Daeseok Youn wrote:
> > fix checkpatch.pl error:
> > ERROR: need consistent spacing around '*' (ctx:WxV)
> > +                       memcpy(vin + PAGE_SIZE *i, t, PAGE_SIZE);
> >
> > Signed-off-by: Daeseok Youn <daeseok.youn at gmail.com>
> > ---
> >  drivers/staging/erofs/unzip_vle_lz4.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
> > index f5b665f..501cfe0 100644
> > --- a/drivers/staging/erofs/unzip_vle_lz4.c
> > +++ b/drivers/staging/erofs/unzip_vle_lz4.c
> > @@ -181,7 +181,7 @@ int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
> >               for (i = 0; i < clusterpages; ++i) {
> >                       void *t = kmap_atomic(compressed_pages[i]);
> >
> > -                     memcpy(vin + PAGE_SIZE *i, t, PAGE_SIZE);
> > +                     memcpy(vin + PAGE_SIZE * i, t, PAGE_SIZE);
> >                       kunmap_atomic(t);
> >               }
> >       } else if (clusterpages == 1)
> >
>
Hi Gustavo,

Thanks for letting me know the patch.
> This exact fix was applied to linux-next some days ago:
>
> commit ea0b2d429bd82ec152d286a0c026ebcaa4154ccc
yes, you're right.
>
> Make sure you are working from linux-next rather than from mainline.
I got the linux kernel source from the staging-next tree than
linux-next. I knew that the patches related to staging should be
merged into staging-tree first. But I didn't update the source tree to
get latest.
>
> See this link: https://www.kernel.org/doc/man-pages/linux-next.html
>
Thanks.
Regards,
Daeseok Youn.
> Thanks
> --
> Gustavo
