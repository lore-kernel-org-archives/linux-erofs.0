From: hsiangkao@aol.com (Gao Xiang)
Date: Fri, 16 Aug 2019 01:04:14 +0800
Subject: [PATCH v8 00/24] erofs: promote erofs from staging v8
In-Reply-To: <CAHk-=wjKz7JLd=mj0w2LUiWC2_VOeNWhTTrw1j-i-KyEHH5g5w@mail.gmail.com>
References: <20190815044155.88483-1-gaoxiang25@huawei.com>
 <20190815090603.GD4938@kroah.com>
 <CAHk-=wjKz7JLd=mj0w2LUiWC2_VOeNWhTTrw1j-i-KyEHH5g5w@mail.gmail.com>
Message-ID: <20190815170409.GB4958@hsiangkao-HP-ZHAN-66-Pro-G1>

Hi Linus,

On Thu, Aug 15, 2019@09:18:12AM -0700, Linus Torvalds wrote:
> On Thu, Aug 15, 2019 at 2:06 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > I know everyone is busy, but given the length this has been in staging,
> > and the constant good progress toward cleaning it all up that has been
> > happening, I want to get this moved out of staging soon.
> 
> Since it doesn't touch anything outside of its own filesystem, I have
> no real objections. We've never had huge problems with odd
> filesystems.
> 
> I read through the patches to look for syntactic stuff (ie very much
> *not* looking at actual code working or not), and had only one
> comment. It's not critical, but it would be nice to do as part of (or
> before) the "get it out of staging".

Thanks for your kind reply!

OK, I will submit a patch later to address your comment and
a pending formal moving patch with a suggestion by Stephen earlier
for Greg as well.

Thanks,
Gao Xiang

> 
>                  Linus
