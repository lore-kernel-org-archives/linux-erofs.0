From: julia.lawall@lip6.fr (Julia Lawall)
Date: Mon, 5 Nov 2018 16:50:56 +0100 (CET)
Subject: [Outreachy kernel] Re: [PATCH v3 2/2] staging: erofs: Modify
 conditional checks
In-Reply-To: <3ac63350-6bfc-0dba-2649-ad7f91dd94c9@huawei.com>
References: <b14ab748b6c00632bb2234000d96a7e1912e2b1b.1541421259.git.digholebhagyashri@gmail.com>
 <b36253c9dacce060a90e84f3e8d854749800d720.1541421259.git.digholebhagyashri@gmail.com>
 <3ac63350-6bfc-0dba-2649-ad7f91dd94c9@huawei.com>
Message-ID: <alpine.DEB.2.20.1811051650270.31780@hadrien>



On Mon, 5 Nov 2018, Gao Xiang wrote:

> Hi Bhagyashri,
>
> On 2018/11/5 22:50, Bhagyashri P. Dighole wrote:
> > Fix coding style alignment issues detected by checkpatch.pl
> > Use ! for NULL test rather than explicitly comparing to NULL.
> >
> > Signed-off-by: Bhagyashri P. Dighole <digholebhagyashri at gmail.com>
> > ---
> > Changes in v3:
> > - Split patch in two patches. Each patch have similar
> >   kind of changes. One patch for all alignment fixes and
> >     second patch for all conditional check fixes.
> >
> > Changes in v2:
> > - Fix for one alignment issue and one conditional check issue.
> >
> > Changes in v1:
> > - Fix for all issues in data.c
>
> As the Greg said before, there are too many patchset v3... :(
> Apart from its content, could you please resend the whole patchset
> by using a proper version number...
>
> It is really confusing for me as well...

Bhagyashri,

When you resend, you should include the Reviewed-by that you received.

julia


>
> Thanks,
> Gao Xiang
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe at googlegroups.com.
> To post to this group, send email to outreachy-kernel at googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/3ac63350-6bfc-0dba-2649-ad7f91dd94c9%40huawei.com.
> For more options, visit https://groups.google.com/d/optout.
>
