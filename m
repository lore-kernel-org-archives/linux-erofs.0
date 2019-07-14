From: pavel@ucw.cz (Pavel Machek)
Date: Sun, 14 Jul 2019 12:49:40 +0200
Subject: [PATCH v2 00/24] erofs: promote erofs from staging
In-Reply-To: <20190711145755.33908-1-gaoxiang25@huawei.com>
References: <20190711145755.33908-1-gaoxiang25@huawei.com>
Message-ID: <20190714104940.GA1282@xo-6d-61-c0.localdomain>

On Thu 2019-07-11 22:57:31, Gao Xiang wrote:
> Changelog from v1:
>  o resend the whole filesystem into a patchset suggested by Greg;
>  o code is more cleaner, especially for decompression frontend.
> 
> --8<----------
> 
> Hi,
> 
> EROFS file system has been in Linux-staging for about a year.
> It has been proved to be stable enough to move out of staging
> by 10+ millions of HUAWEI Android mobile phones on the market
> from EMUI 9.0.1, and it was promoted as one of the key features
> of EMUI 9.1 [1], including P30(pro).

Ok, maybe it is ready to be moved to kernel proper, but as git can
do moves, would it be better to do it as one commit?

Separate patches are still better for review, I guess.
							Pavel
