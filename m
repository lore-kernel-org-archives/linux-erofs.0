From: julia.lawall@lip6.fr (Julia Lawall)
Date: Mon, 5 Nov 2018 07:24:26 +0100 (CET)
Subject: [Outreachy kernel] Re: [PATCH v2 1/2] staging: erofs: Modify
 conditional check.
In-Reply-To: <CAOMPgjjF3_JYc6H8FuMXXmNHov30uxy2N+ZtTTtVhSxzmbsnFQ@mail.gmail.com>
References: <3db6ea6f3a7b1fab94e5dacc1ec4a026e38548c2.1541394756.git.digholebhagyashri@example.com>
 <5d7fc290-08ad-0c83-d030-de255de81c47@huawei.com>
 <CAOMPgjjF3_JYc6H8FuMXXmNHov30uxy2N+ZtTTtVhSxzmbsnFQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1811050721560.2654@hadrien>



On Mon, 5 Nov 2018, Bhagyashri Dighole wrote:

> Thanks Gao. As per discussion in previous mails, I thought we need to submit
> one change at a time in a patch that's why I modified accordingly. As you
> suggested it makes sense to fix all similar issues at once and create a
> single patch for those issues. I will update patch accordingly.

Sorry for not being clear.  It is one kind of change at a time.

julia

>
> ?Thanks?
>
> On Mon, Nov 5, 2018, 10:58 AM Gao Xiang <gaoxiang25@huawei.com> wrote:
>       Hi Bhagyashri,
>
>       On 2018/11/5 13:13, Bhagyashri P. Dighole wrote:
>       > Found issue using checkpatch.
>       > Use ! for NULL test rather than explicitly comparing to NULL.
>       >
>       > Signed-off-by: Bhagyashri P. Dighole
>       <digholebhagyashri at gmail.com>
>       > ---
>       >? drivers/staging/erofs/data.c | 2 +-
>       >? 1 file changed, 1 insertion(+), 1 deletion(-)
>       >
>       > diff --git a/drivers/staging/erofs/data.c
>       b/drivers/staging/erofs/data.c
>       > index 6384f73..a671ad4 100644
>       > --- a/drivers/staging/erofs/data.c
>       > +++ b/drivers/staging/erofs/data.c
>       > @@ -240,7 +240,7 @@ static inline struct bio
>       *erofs_read_raw_page(
>       >? ? ? ? ? ? ? ?bio = NULL;
>       >? ? ? ?}
>       >?
>       > -? ? ?if (bio == NULL) {
>       > +? ? ?if (!bio) {
>       >? ? ? ? ? ? ? ?struct erofs_map_blocks map = {
>       >? ? ? ? ? ? ? ? ? ? ? ?.m_la = blknr_to_addr(current_block),
>       >? ? ? ? ? ? ? ?};
>       >
>
>       Could you please fix pointer comparisons to NULL all in once?
>       at least for a specific file (eg. for the staging/erofs/data.c
>       only)?
>
>       It is somewhat weird to just fix one place only of data.c +243
>       as above,
>       this is my personal suggestion...
>
>       Thanks,
>       Gao Xiang
>
>       --
>       You received this message because you are subscribed to the
>       Google Groups "outreachy-kernel" group.
>       To unsubscribe from this group and stop receiving emails from
>       it, send an email to
>       outreachy-kernel+unsubscribe at googlegroups.com.
>       To post to this group, send email to
>       outreachy-kernel at googlegroups.com.
>       To view this discussion on the web visithttps://groups.google.com/d/msgid/outreachy-kernel/5d7fc290-08ad-0c83-d030-
>       de255de81c47%40huawei.com.
>       For more options, visit https://groups.google.com/d/optout.
>
> --
> You received this message because you are subscribed to the Google Groups
> "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an
> email to outreachy-kernel+unsubscribe at googlegroups.com.
> To post to this group, send email to outreachy-kernel at googlegroups.com.
> To view this discussion on the web visithttps://groups.google.com/d/msgid/outreachy-kernel/CAOMPgjjF3_JYc6H8FuMXXmN
> Hov30uxy2N%2BZtTTtVhSxzmbsnFQ%40mail.gmail.com.
> For more options, visit https://groups.google.com/d/optout.
>
>
