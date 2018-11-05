From: digholebhagyashri@gmail.com (Bhagyashri Dighole)
Date: Mon, 5 Nov 2018 09:53:16 +0530
Subject: [Outreachy kernel] [PATCH] staging: erofs: Modify conditional
 check.
In-Reply-To: <alpine.DEB.2.21.1811042100420.2360@hadrien>
References: <20181104195701.GA18201@bhagyashri-Lenovo-G570>
 <alpine.DEB.2.21.1811042100420.2360@hadrien>
Message-ID: <CAOMPgjjQAGPb1Ed4BX5m3DromhM7OVxzr45HVR+Tuq8FUs8ANQ@mail.gmail.com>

Thanks Julia, I will update commit log message for patch and add version
for patch. I will also add series number if there are multiple changes on
the same file.

Bhagyashri

On Mon, Nov 5, 2018@1:36 AM Julia Lawall <julia.lawall@lip6.fr> wrote:

>
>
> On Mon, 5 Nov 2018, Bhagyashri P. Dighole wrote:
>
> > This patch includes modified condition to check for bio struct.
>
> The commit message is sort of wordy and imprecise.  Don't say "This patch
> includes".  The commit log message should be in the imperative.  That is,
> it should start with a verb.  Here, the first word could perhaps be
> Modify.  Afterwards, you should explain what was done and why.  Here you
> could say "Use ! for a NULL test rather than explicitly comparing to NULL,
> to be more concise and readable".  Then, if you came across this issue due
> to checkpatch, it would be nice to acknowledge that - Issue found using
> checkpatch.
>
> Finally, if you are going to send the other changes then they all need to
> be in a series.  On the other hand, for your first patch, it is fine to
> only send this change.  But in that case you have to work on something
> else until Greg picks this up.  If there are multiple changes on one file,
> he needs the series number to know in what order to apply them.
>
> julia
>
> >
> > Signed-off-by: Bhagyashri P. Dighole <digholebhagyashri at gmail.com>
> > ---
> >  drivers/staging/erofs/data.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
> > index 6384f73..a671ad4 100644
> > --- a/drivers/staging/erofs/data.c
> > +++ b/drivers/staging/erofs/data.c
> > @@ -240,7 +240,7 @@ static inline struct bio *erofs_read_raw_page(
> >               bio = NULL;
> >       }
> >
> > -     if (bio == NULL) {
> > +     if (!bio) {
> >               struct erofs_map_blocks map = {
> >                       .m_la = blknr_to_addr(current_block),
> >               };
> > --
> > 2.7.4
> >
> > --
> > You received this message because you are subscribed to the Google
> Groups "outreachy-kernel" group.
> > To unsubscribe from this group and stop receiving emails from it, send
> an email to outreachy-kernel+unsubscribe at googlegroups.com.
> > To post to this group, send email to outreachy-kernel at googlegroups.com.
> > To view this discussion on the web visit
> https://groups.google.com/d/msgid/outreachy-kernel/20181104195701.GA18201%40bhagyashri-Lenovo-G570
> .
> > For more options, visit https://groups.google.com/d/optout.
> >
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: <http://lists.ozlabs.org/pipermail/linux-erofs/attachments/20181105/02cba1c2/attachment.html>
