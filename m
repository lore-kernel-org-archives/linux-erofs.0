From: himanshujha199640@gmail.com (Himanshu Jha)
Date: Tue, 6 Nov 2018 00:38:17 +0530
Subject: [Outreachy kernel] Re: [PATCH v3 2/2] staging: erofs: Modify
 conditional checks
In-Reply-To: <CAOMPgjgoseN=+1ezv+xDZSoWpUxnsA3f70NisjAwZN=113fj7w@mail.gmail.com>
References: <b14ab748b6c00632bb2234000d96a7e1912e2b1b.1541421259.git.digholebhagyashri@gmail.com>
 <b36253c9dacce060a90e84f3e8d854749800d720.1541421259.git.digholebhagyashri@gmail.com>
 <3ac63350-6bfc-0dba-2649-ad7f91dd94c9@huawei.com>
 <alpine.DEB.2.20.1811051650270.31780@hadrien>
 <CAOMPgjgoseN=+1ezv+xDZSoWpUxnsA3f70NisjAwZN=113fj7w@mail.gmail.com>
Message-ID: <20181105190817.GB9326@himanshu-Vostro-3559>

On Mon, Nov 05, 2018@11:37:53PM +0530, Bhagyashri Dighole wrote:
> Hi Gao,
> 
> In PATCH version v1 which is first stage of contribution, I modified data.c
> for all alignment changes and all conditional checks. As per discussion on
> email for this patch, It was concluded that I need to re-submit patch for
> single change at a time.
> 
> So, I created PATCH v2. In this patch, I modified data.c only for single
> conditional check and single alignment change and committed accordingly. As
> per Gao?s suggestion to do all alignment change in a first patch and all
> conditional changes in another patch, I modified and created PATCH v3.
> 
> PATCH v3 is divided into two patches.
> 1) PATCH v3 1/2 has all alignment changes.
> 2) PATCH v3 2/2 has all conditional changes.

I saw two variants for 2)

check your `sent` box once and you will understand what the problem is.

> Also, I mentioned what changes each version of patch represents under ??-?
> symbol.

But I didn't see for one of the variants for 2)

> I am not able to understand, where I am making mistake? Can you please help
> me?

When someone says to resend a patch use subject as [RESEND PATCH ... ..]

See how development goes out here https://lkml.org/

> @Julia Lawall <julia.lawall at lip6.fr>  How can I include Reviewed-by in
> patch submission? we are allow to do that? If yes, then from where I can
> get that information?

Julia misunderstood I guess due identical patches and now when you send
a new version add Gao's `Reviewed-by` tag with proper changelog and
versioning.

Lastly, Please don't top-post and don't bomb the outreachy mailing list.


@Ioannis Valasakis,

If you're following the list, then please understand what reviews you
get carefully. You made the exactly same mistake in new series as Julia
pointed and was earlier pointed by me.

You're lucky to have Julia, Greg, Sasha *patiently* replying and perhaps you
know about their mainline work. So, please rest their time and effort.


Otherwise, in future very likely :P 
=> => https://lore.kernel.org/lkml/20170829142011.76w67w64a7lheef4 at piout.net/


Thanks!
-- 
Himanshu Jha
Undergraduate Student
Department of Electronics & Communication
Guru Tegh Bahadur Institute of Technology
