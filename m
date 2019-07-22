From: rostedt@goodmis.org (Steven Rostedt)
Date: Mon, 22 Jul 2019 10:40:48 -0400
Subject: [PATCH v3 12/24] erofs: introduce tagged pointer
In-Reply-To: <CAOQ4uxgo5kvgoEn7SbuwF9+B1W9Qg1-2jSUm5+iKZdT6-wDEog@mail.gmail.com>
References: <20190722025043.166344-1-gaoxiang25@huawei.com>
 <20190722025043.166344-13-gaoxiang25@huawei.com>
 <CAOQ4uxh04gwbM4yFaVpWHVwmJ4BJo4bZaU8A4_NQh2bO_xCHJg@mail.gmail.com>
 <39fad3ab-c295-5f6f-0a18-324acab2f69e@huawei.com>
 <CAOQ4uxgo5kvgoEn7SbuwF9+B1W9Qg1-2jSUm5+iKZdT6-wDEog@mail.gmail.com>
Message-ID: <20190722104048.463397a0@gandalf.local.home>

On Mon, 22 Jul 2019 09:16:22 +0300
Amir Goldstein <amir73il@gmail.com> wrote:

> CC kernel/trace maintainers for RB_PAGE_HEAD/RB_PAGE_UPDATE
> and kernel/locking maintainers for RT_MUTEX_HAS_WAITERS

Interesting.

> 
> > (Is there some use scenerios in overlayfs and fanotify?...)  
> 
> We had one in overlayfs once. It is gone now.
> 
> >
> > and I'm not sure Al could accept __fdget conversion (I just wanted to give a example then...)
> >
> > Therefore, I tend to keep silence and just promote EROFS... some better ideas?...
> >  
> 
> Writing example conversion patches to demonstrate cleaner code
> and perhaps reduce LOC seems the best way.

Yes, I would be more interested in seeing patches that clean up the
code than just talking about it.

> 
> Also pointing out that fixing potential bugs in one implementation is preferred
> to having to patch all copied implementations.
> 
> I wonder if tagptr_unfold_tags() doesn't need READ_ONCE() as per:
> 1be5d4fa0af3 locking/rtmutex: Use READ_ONCE() in rt_mutex_owner()
> 
> rb_list_head() doesn't have READ_ONCE()

Hmm, even if the compiler decided to reread the data, it would still
need to clear the extra bits wouldn't it? Or am I missing something?

-- Steve

> Nor does hlist_bl_first() and BPF_MAP_PTR().
> 
> Are those all safe due to safe call sites? or potentially broken?
