From: torvalds@linux-foundation.org (Linus Torvalds)
Date: Thu, 15 Aug 2019 09:18:12 -0700
Subject: [PATCH v8 00/24] erofs: promote erofs from staging v8
In-Reply-To: <20190815090603.GD4938@kroah.com>
References: <20190815044155.88483-1-gaoxiang25@huawei.com>
 <20190815090603.GD4938@kroah.com>
Message-ID: <CAHk-=wjKz7JLd=mj0w2LUiWC2_VOeNWhTTrw1j-i-KyEHH5g5w@mail.gmail.com>

On Thu, Aug 15, 2019 at 2:06 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> I know everyone is busy, but given the length this has been in staging,
> and the constant good progress toward cleaning it all up that has been
> happening, I want to get this moved out of staging soon.

Since it doesn't touch anything outside of its own filesystem, I have
no real objections. We've never had huge problems with odd
filesystems.

I read through the patches to look for syntactic stuff (ie very much
*not* looking at actual code working or not), and had only one
comment. It's not critical, but it would be nice to do as part of (or
before) the "get it out of staging".

                 Linus
