From: hsiangkao@aol.com (Gao Xiang)
Date: Tue, 6 Nov 2018 02:22:36 +0800
Subject: [Outreachy kernel] Re: [PATCH v3 2/2] staging: erofs: Modify
 conditional checks
In-Reply-To: <CAOMPgjgoseN=+1ezv+xDZSoWpUxnsA3f70NisjAwZN=113fj7w@mail.gmail.com>
References: <b14ab748b6c00632bb2234000d96a7e1912e2b1b.1541421259.git.digholebhagyashri@gmail.com>
 <b36253c9dacce060a90e84f3e8d854749800d720.1541421259.git.digholebhagyashri@gmail.com>
 <3ac63350-6bfc-0dba-2649-ad7f91dd94c9@huawei.com>
 <alpine.DEB.2.20.1811051650270.31780@hadrien>
 <CAOMPgjgoseN=+1ezv+xDZSoWpUxnsA3f70NisjAwZN=113fj7w@mail.gmail.com>
Message-ID: <30e72aa4-e605-d087-364c-3b9f606edaec@aol.com>

Hi Bhagyashri,

On 2018/11/6 2:07, Bhagyashri Dighole wrote:
> Hi Gao,
> 
> In PATCH version v1 which is first stage of contribution, I modified data.c for all alignment changes and all conditional checks.?As per discussion on email for this patch, It was concluded that I need to re-submit patch for single change at a time.
> 
> So, I created PATCH v2. In this patch, I modified data.c only for single conditional check and single alignment change and committed accordingly. As per Gao?s suggestion to do all alignment change in a first patch and all conditional changes in another patch, I modified and created PATCH v3.
> 
> PATCH v3 is divided into two patches.
> 1) PATCH v3 1/2 has all alignment changes.
> 2) PATCH v3 2/2 has all conditional changes.

That is correct. However, you send two patchset of v3, see:

v3. the first time
1) https://lists.ozlabs.org/pipermail/linux-erofs/2018-November/000796.html
2) https://lists.ozlabs.org/pipermail/linux-erofs/2018-November/000797.html
2.1) https://lists.ozlabs.org/pipermail/linux-erofs/2018-November/000798.html
v3. the second time
1) https://lists.ozlabs.org/pipermail/linux-erofs/2018-November/000800.html
2) https://lists.ozlabs.org/pipermail/linux-erofs/2018-November/000801.html

It is hard for me to know which one is the latest version of your patchset.
If you send a newer version, you should use v4 instead of v3 (even if you
decide to add a changelog), or

If you resend the patchset (same as the previous one, just to remind us to review),
  you should use [PATCH v3 RESEND] for this case.

> 
> Also, I mentioned what changes each version of patch represents under ??-? symbol.

Yes, but I think you should use v4 rather than v3 to add a changelog as Greg mentioned.

> 
> I am not able to understand, where I am making mistake??Can you please help me?

That is my personal suggestion, maybe of some help for you...

Thanks,
Gao Xiang
