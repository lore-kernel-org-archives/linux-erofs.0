From: loic.tourlonias@gmail.com (=?UTF-8?Q?lo=C3=AFc_tourlonias?=)
Date: Mon, 8 Oct 2018 17:00:18 +0200
Subject: [PATCH v2] staging: erofs: add SPDX identifer
In-Reply-To: <a460f98f-d566-1d9d-b395-e8604519b442@huawei.com>
References: <20181008141409.2624-1-loic.tourlonias.lkml@gmail.com>
 <20181008142228.GB13359@kroah.com>
 <e9620bf6-5f3f-108d-b9f1-91af1ad603d6@huawei.com>
 <20181008144335.GA15968@kroah.com>
 <a460f98f-d566-1d9d-b395-e8604519b442@huawei.com>
Message-ID: <CA+XxOSG+cJ3FZ4S7qcRWWDcktDpStuoa7nTuAUOr+U-uTTUcYg@mail.gmail.com>

Hi Gao,
On Mon, Oct 8, 2018@4:48 PM Gao Xiang <gaoxiang25@huawei.com> wrote:
>
> Hi Greg,
>
> On 2018/10/8 22:43, Greg Kroah-Hartman wrote:
> > On Mon, Oct 08, 2018@10:36:39PM +0800, Gao Xiang wrote:
> >> Hi Greg,
> >>
> >> On 2018/10/8 22:22, Greg Kroah-Hartman wrote:
> >>> Why delete that line?
> >>>
> >>> But wait, why do we even have this file at all?  What's wrong with the
> >>> lib/lz4/ code that we have in the kernel today?  Shouldn't the code
> >>> using these files be moved over to use the lib/ code instead and this
> >>> file be deleted?
> >>
> >> EROFS uses customized LZ4 decompression code for now (which has been offically
> >> supported in lz4 1.8.3, I have updated it in
> >> https://ozlabs.org/~akpm/mmots/broken-out/lib-lz4-update-lz4-decompressor-module.patch
> >> if it is shown up in Linux 4.20, I will remove all the customized LZ4 decompression code),
> >> but lib/ code lz4def.h isn't export to include/.
> >
> > It should show up in 4.20, so you should be able to remove this all
> > then.
>
> Yes, that is correct. I will fix it in 4.20 if the updated LZ4 is already there. :)

So no need to update the patch since the file will be removed. Am I correct?

Too bad, I'll make my first patch later... ^^

Thanks
Loic
>
> Thanks,
> Gao Xiang
>
> >
> > thanks,
> >
> > greg k-h
> >
