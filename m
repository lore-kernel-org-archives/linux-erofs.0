From: cgxu519@gmx.com (cgxu519)
Date: Mon, 12 Nov 2018 09:51:36 +0800
Subject: How can I get user space tools of erofs?
In-Reply-To: <923d8f98-bd0c-47e1-63a5-512547d6a77d@huawei.com>
References: <cce741a4-8e15-a48c-070e-d16d71b864c3@gmx.com>
 <923d8f98-bd0c-47e1-63a5-512547d6a77d@huawei.com>
Message-ID: <24438b2f-1676-3718-18cc-7c99aa2a7741@gmx.com>


> Hi Chengguang,
>
> Good question! It's in the final stage of preparation to open source erofs-mkfs (actually they are now struggle at how to properly spilt
> into reasonable patches this week), hopefully the implementation could be released at the next week. (sorry I didn't mean to delay,
> I have to put it in the first place --- successfully launch our linux-erofs products to the market)
>
> @Guifu Li <bluce.liguifu at huawei.com> is the original author of erofs-mkfs, he will post the original mkfs source code to linux-erofs mailing list
> and he will maintain erofs-mkfs together with @Wei Fang <fangwei1 at huawei.com> later. You can contact them for further informations.
> ---  these piece of code is actually not clean enough (a lot hacked/dirty code compared to the kernel code) so a lot of cleanup will be done then.
>
> currently, you can get erofs-mkfs binary from (still sorry to say that...):
> https://github.com/hsiangkao/erofs_mkfs_binary
>
> erofs is now in productization for these months, if all things go well, you'll see that HUAWEI mobile phones on the market run in erofs in few months. :)
>
> These months I'm busy in solving bugs found by internal beta users and tuning memory policy in heavy memory workload for the best performance compared to ext4
> (we have native in-place decompression compared with squashfs/btrfs, thus less extra memory allocation results in lower memory memory reclaim / page-writeback
> for devices with limited memory, see: https://lists.ozlabs.org/pipermail/linux-erofs/2018-August/000494.html) in order to gain the competitive user experience
> comparing to uncompressed filesystem solutions. I will update a document to describe our core design and linux-erofs future roadmap in this linux-4.21 round.

Hi Xiang,

Thanks for your detail explanations!

Chengguang
