From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 6 Aug 2018 00:05:16 +0800
Subject: [PATCH] staging: erofs: fix if assignment style issue
In-Reply-To: <20180805152101.11657-1-kristaps.civkulis@gmail.com>
References: <20180805152101.11657-1-kristaps.civkulis@gmail.com>
Message-ID: <78215373-c086-28bc-e35c-27f93d4e7dce@aol.com>

Hi Kristaps,

On 2018/8/5 23:21, Kristaps ?ivkulis wrote:
> Fix coding style issue "do not use assignment in if condition"
> detected by checkpatch.pl.
>
> Signed-off-by: Kristaps ?ivkulis <kristaps.civkulis at gmail.com>

I don't know whether this rule is mandatory or not for the current linux
kernel
when I checked the original patchset with checkpatch.pl.

Sometime I prefer to use assignment in if condition since the whole
statement
is more meaningful than separate to several statements...? although it
can lead to
some potential bugs.

Another case is use (!ptr) to replace (ptr == NULL) and use (ptr) to replace
(ptr != NULL) for pointers. Actually these expressions are equivalent in C,
but I personally like the nullptr concept... I also have no idea if it
is mandatory to fix
as the checkpatch.pl suggested or not...

Thanks for your patch :) if it is actually mandatory or strongly
recommend, you can add:

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang
