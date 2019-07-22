From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 22 Jul 2019 23:33:53 +0800
Subject: [PATCH v3 12/24] erofs: introduce tagged pointer
In-Reply-To: <20190722104048.463397a0@gandalf.local.home>
References: <20190722025043.166344-1-gaoxiang25@huawei.com>
 <20190722025043.166344-13-gaoxiang25@huawei.com>
 <CAOQ4uxh04gwbM4yFaVpWHVwmJ4BJo4bZaU8A4_NQh2bO_xCHJg@mail.gmail.com>
 <39fad3ab-c295-5f6f-0a18-324acab2f69e@huawei.com>
 <CAOQ4uxgo5kvgoEn7SbuwF9+B1W9Qg1-2jSUm5+iKZdT6-wDEog@mail.gmail.com>
 <20190722104048.463397a0@gandalf.local.home>
Message-ID: <0c2cdd4f-8fe7-6084-9c2d-c2e475e6806e@aol.com>

Hi Steven,

On 2019/7/22 ????10:40, Steven Rostedt wrote:
>>> and I'm not sure Al could accept __fdget conversion (I just wanted to give a example then...)
>>>
>>> Therefore, I tend to keep silence and just promote EROFS... some better ideas?...
>>>  
>> Writing example conversion patches to demonstrate cleaner code
>> and perhaps reduce LOC seems the best way.
> Yes, I would be more interested in seeing patches that clean up the
> code than just talking about it.
> 

I guess that is related to me, though I didn't plan to promote
a generic tagged pointer implementation in this series...

I try to describe what erofs met and my own implementation,
assume that we have 3 tagged pointers, a, b, c, and one
potential user only (no need to ACCESS_ONCE).

One way is

#define A_MASK		1
#define B_MASK		1
#define C_MASK		3

/* now we have 3 mask there, A, B, C is simple,
   the real name could be long... */

void *a;
void *b;
void *c;		/* and some pointers */

In order to decode the tag, we have to
	((unsigned long)a & A_MASK)

to decode the ptr, we have to
	((unsigned long)a & ~A_MASK)

In order to fold the tagged pointer...
	(void *)((unsigned long)a | tag)

You can see the only meaning of these masks is the bitlength of tags,
but there are many masks (or we have to do open-coded a & 3,
if bitlength is changed, we have to fix them all)...

therefore my approach is

typedef tagptr1_t ta;	/* tagptr type a with 1-bit tag */
typedef tagptr1_t tb;	/* tagptr type b with 1-bit tag */
typedef tagptr2_t tc;	/* tagptr type c with 2-bit tag */

and ta a; tb b; tc c;

the type will represent its bitlength of tags and we can use ta, tb, tc
to avoid masks or open-coded bitlength.

In order to decode the tag, we can
	tagptr_unfold_tags(a)

In order to decode the ptr, we can
	tagptr_unfold_ptr(a)

In order to fold the tagged pointer...
	a = tagptr_fold(ta, ptr, tag)


ACCESS_ONCE stuff is another thing... If my approach seems cleaner,
we could move to include/linux later after EROFS stuffs is done...
Or I could use a better tagptr approach later if any...

Thanks,
Gao XIang
