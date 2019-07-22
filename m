From: amir73il@gmail.com (Amir Goldstein)
Date: Mon, 22 Jul 2019 09:16:22 +0300
Subject: [PATCH v3 12/24] erofs: introduce tagged pointer
In-Reply-To: <39fad3ab-c295-5f6f-0a18-324acab2f69e@huawei.com>
References: <20190722025043.166344-1-gaoxiang25@huawei.com>
 <20190722025043.166344-13-gaoxiang25@huawei.com>
 <CAOQ4uxh04gwbM4yFaVpWHVwmJ4BJo4bZaU8A4_NQh2bO_xCHJg@mail.gmail.com>
 <39fad3ab-c295-5f6f-0a18-324acab2f69e@huawei.com>
Message-ID: <CAOQ4uxgo5kvgoEn7SbuwF9+B1W9Qg1-2jSUm5+iKZdT6-wDEog@mail.gmail.com>

On Mon, Jul 22, 2019@8:02 AM Gao Xiang <gaoxiang25@huawei.com> wrote:
>
> Hi Amir,
>
> On 2019/7/22 12:39, Amir Goldstein wrote:
> > On Mon, Jul 22, 2019@5:54 AM Gao Xiang <gaoxiang25@huawei.com> wrote:
> >>
> >> Currently kernel has scattered tagged pointer usages
> >> hacked by hand in plain code, without a unique and
> >> portable functionset to highlight the tagged pointer
> >> itself and wrap these hacked code in order to clean up
> >> all over meaningless magic masks.
> >>
> >> This patch introduces simple generic methods to fold
> >> tags into a pointer integer. Currently it supports
> >> the last n bits of the pointer for tags, which can be
> >> selected by users.
> >>
> >> In addition, it will also be used for the upcoming EROFS
> >> filesystem, which heavily uses tagged pointer pproach
> >>  to reduce extra memory allocation.
> >>
> >> Link: https://en.wikipedia.org/wiki/Tagged_pointer
> >
> > Well, it won't do much good for other kernel users in fs/erofs/ ;-)
>
> Thanks for your reply and interest in this patch.... :)
>
> Sigh... since I'm not sure kernel folks could have some interests in that stuffs.
>
> Actually at the time once I coded EROFS I found tagged pointer had 2 main advantages:
> 1) it saves an extra field;
> 2) it can keep the whole stuff atomicly...
> And I observed the current kernel uses tagged pointer all around but w/o a proper wrapper...
> and EROFS heavily uses tagged pointer... So I made a simple tagged pointer wrapper
> to avoid meaningless magic masks and type casts in the code...
>
> >
> > I think now would be a right time to promote this facility to
> > include/linux as you initially proposed.
> > I don't recall you got any objections. No ACKs either, but I think
> > that was the good kind of silence (?)
>
> Yes, no NAK no ACK...(it seems the ordinary state for all EROFS stuffs... :'( sigh...)
> Therefore I decided to leave it in fs/erofs/ in this series...
>
> >
> > You might want to post the __fdget conversion patch [1] as a
> > bonus patch on top of your series.
>
> I am not sure if another potential users could be quite happy with my ("sane?" or not)
> implementation...

Well, let's ask potential users then.

CC kernel/trace maintainers for RB_PAGE_HEAD/RB_PAGE_UPDATE
and kernel/locking maintainers for RT_MUTEX_HAS_WAITERS

> (Is there some use scenerios in overlayfs and fanotify?...)

We had one in overlayfs once. It is gone now.

>
> and I'm not sure Al could accept __fdget conversion (I just wanted to give a example then...)
>
> Therefore, I tend to keep silence and just promote EROFS... some better ideas?...
>

Writing example conversion patches to demonstrate cleaner code
and perhaps reduce LOC seems the best way.

Also pointing out that fixing potential bugs in one implementation is preferred
to having to patch all copied implementations.

I wonder if tagptr_unfold_tags() doesn't need READ_ONCE() as per:
1be5d4fa0af3 locking/rtmutex: Use READ_ONCE() in rt_mutex_owner()

rb_list_head() doesn't have READ_ONCE()
Nor does hlist_bl_first() and BPF_MAP_PTR().

Are those all safe due to safe call sites? or potentially broken?

Thanks,
Amir.
