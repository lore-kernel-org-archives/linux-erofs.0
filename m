From: amir73il@gmail.com (Amir Goldstein)
Date: Mon, 22 Jul 2019 07:39:27 +0300
Subject: [PATCH v3 12/24] erofs: introduce tagged pointer
In-Reply-To: <20190722025043.166344-13-gaoxiang25@huawei.com>
References: <20190722025043.166344-1-gaoxiang25@huawei.com>
 <20190722025043.166344-13-gaoxiang25@huawei.com>
Message-ID: <CAOQ4uxh04gwbM4yFaVpWHVwmJ4BJo4bZaU8A4_NQh2bO_xCHJg@mail.gmail.com>

On Mon, Jul 22, 2019@5:54 AM Gao Xiang <gaoxiang25@huawei.com> wrote:
>
> Currently kernel has scattered tagged pointer usages
> hacked by hand in plain code, without a unique and
> portable functionset to highlight the tagged pointer
> itself and wrap these hacked code in order to clean up
> all over meaningless magic masks.
>
> This patch introduces simple generic methods to fold
> tags into a pointer integer. Currently it supports
> the last n bits of the pointer for tags, which can be
> selected by users.
>
> In addition, it will also be used for the upcoming EROFS
> filesystem, which heavily uses tagged pointer pproach
>  to reduce extra memory allocation.
>
> Link: https://en.wikipedia.org/wiki/Tagged_pointer

Well, it won't do much good for other kernel users in fs/erofs/ ;-)

I think now would be a right time to promote this facility to
include/linux as you initially proposed.
I don't recall you got any objections. No ACKs either, but I think
that was the good kind of silence (?)

You might want to post the __fdget conversion patch [1] as a
bonus patch on top of your series.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/1530543233-65279-2-git-send-email-gaoxiang25 at huawei.com/
