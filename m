From: digholebhagyashri@gmail.com (Bhagyashri Dighole)
Date: Mon, 5 Nov 2018 23:37:53 +0530
Subject: [Outreachy kernel] Re: [PATCH v3 2/2] staging: erofs: Modify
 conditional checks
In-Reply-To: <alpine.DEB.2.20.1811051650270.31780@hadrien>
References: <b14ab748b6c00632bb2234000d96a7e1912e2b1b.1541421259.git.digholebhagyashri@gmail.com>
 <b36253c9dacce060a90e84f3e8d854749800d720.1541421259.git.digholebhagyashri@gmail.com>
 <3ac63350-6bfc-0dba-2649-ad7f91dd94c9@huawei.com>
 <alpine.DEB.2.20.1811051650270.31780@hadrien>
Message-ID: <CAOMPgjgoseN=+1ezv+xDZSoWpUxnsA3f70NisjAwZN=113fj7w@mail.gmail.com>

Hi Gao,

In PATCH version v1 which is first stage of contribution, I modified data.c
for all alignment changes and all conditional checks. As per discussion on
email for this patch, It was concluded that I need to re-submit patch for
single change at a time.

So, I created PATCH v2. In this patch, I modified data.c only for single
conditional check and single alignment change and committed accordingly. As
per Gao?s suggestion to do all alignment change in a first patch and all
conditional changes in another patch, I modified and created PATCH v3.

PATCH v3 is divided into two patches.
1) PATCH v3 1/2 has all alignment changes.
2) PATCH v3 2/2 has all conditional changes.

Also, I mentioned what changes each version of patch represents under ??-?
symbol.

I am not able to understand, where I am making mistake? Can you please help
me?


@Julia Lawall <julia.lawall at lip6.fr>  How can I include Reviewed-by in
patch submission? we are allow to do that? If yes, then from where I can
get that information?

Regards

On Mon, Nov 5, 2018@9:21 PM Julia Lawall <julia.lawall@lip6.fr> wrote:

>
>
> On Mon, 5 Nov 2018, Gao Xiang wrote:
>
> > Hi Bhagyashri,
> >
> > On 2018/11/5 22:50, Bhagyashri P. Dighole wrote:
> > > Fix coding style alignment issues detected by checkpatch.pl
> > > Use ! for NULL test rather than explicitly comparing to NULL.
> > >
> > > Signed-off-by: Bhagyashri P. Dighole <digholebhagyashri at gmail.com>
> > > ---
> > > Changes in v3:
> > > - Split patch in two patches. Each patch have similar
> > >   kind of changes. One patch for all alignment fixes and
> > >     second patch for all conditional check fixes.
> > >
> > > Changes in v2:
> > > - Fix for one alignment issue and one conditional check issue.
> > >
> > > Changes in v1:
> > > - Fix for all issues in data.c
> >
> > As the Greg said before, there are too many patchset v3... :(
> > Apart from its content, could you please resend the whole patchset
> > by using a proper version number...
> >
> > It is really confusing for me as well...
>
> Bhagyashri,
>
> When you resend, you should include the Reviewed-by that you received.
>
> julia
>
>
> >
> > Thanks,
> > Gao Xiang
> >
> > --
> > You received this message because you are subscribed to the Google
> Groups "outreachy-kernel" group.
> > To unsubscribe from this group and stop receiving emails from it, send
> an email to outreachy-kernel+unsubscribe at googlegroups.com.
> > To post to this group, send email to outreachy-kernel at googlegroups.com.
> > To view this discussion on the web visit
> https://groups.google.com/d/msgid/outreachy-kernel/3ac63350-6bfc-0dba-2649-ad7f91dd94c9%40huawei.com
> .
> > For more options, visit https://groups.google.com/d/optout.
> >
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: <http://lists.ozlabs.org/pipermail/linux-erofs/attachments/20181105/37adce56/attachment.html>
