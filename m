From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 22 Jul 2019 13:01:44 +0800
Subject: [PATCH v3 12/24] erofs: introduce tagged pointer
In-Reply-To: <CAOQ4uxh04gwbM4yFaVpWHVwmJ4BJo4bZaU8A4_NQh2bO_xCHJg@mail.gmail.com>
References: <20190722025043.166344-1-gaoxiang25@huawei.com>
 <20190722025043.166344-13-gaoxiang25@huawei.com>
 <CAOQ4uxh04gwbM4yFaVpWHVwmJ4BJo4bZaU8A4_NQh2bO_xCHJg@mail.gmail.com>
Message-ID: <39fad3ab-c295-5f6f-0a18-324acab2f69e@huawei.com>

Hi Amir,

On 2019/7/22 12:39, Amir Goldstein wrote:
> On Mon, Jul 22, 2019@5:54 AM Gao Xiang <gaoxiang25@huawei.com> wrote:
>>
>> Currently kernel has scattered tagged pointer usages
>> hacked by hand in plain code, without a unique and
>> portable functionset to highlight the tagged pointer
>> itself and wrap these hacked code in order to clean up
>> all over meaningless magic masks.
>>
>> This patch introduces simple generic methods to fold
>> tags into a pointer integer. Currently it supports
>> the last n bits of the pointer for tags, which can be
>> selected by users.
>>
>> In addition, it will also be used for the upcoming EROFS
>> filesystem, which heavily uses tagged pointer pproach
>>  to reduce extra memory allocation.
>>
>> Link: https://en.wikipedia.org/wiki/Tagged_pointer
> 
> Well, it won't do much good for other kernel users in fs/erofs/ ;-)

Thanks for your reply and interest in this patch.... :)

Sigh... since I'm not sure kernel folks could have some interests in that stuffs.

Actually at the time once I coded EROFS I found tagged pointer had 2 main advantages:
1) it saves an extra field;
2) it can keep the whole stuff atomicly...
And I observed the current kernel uses tagged pointer all around but w/o a proper wrapper...
and EROFS heavily uses tagged pointer... So I made a simple tagged pointer wrapper
to avoid meaningless magic masks and type casts in the code...

> 
> I think now would be a right time to promote this facility to
> include/linux as you initially proposed.
> I don't recall you got any objections. No ACKs either, but I think
> that was the good kind of silence (?)

Yes, no NAK no ACK...(it seems the ordinary state for all EROFS stuffs... :'( sigh...)
Therefore I decided to leave it in fs/erofs/ in this series...

> 
> You might want to post the __fdget conversion patch [1] as a
> bonus patch on top of your series.

I am not sure if another potential users could be quite happy with my ("sane?" or not)
implementation... (Is there some use scenerios in overlayfs and fanotify?...)

and I'm not sure Al could accept __fdget conversion (I just wanted to give a example then...)

Therefore, I tend to keep silence and just promote EROFS... some better ideas?...

Thanks,
Gao Xiang
