From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 1 Apr 2019 15:11:11 +0800
Subject: [PATCH] staging: erofs: keep corrupted fs from crashing kernel in
 erofs_readdir()
In-Reply-To: <20190330134528.7F9A62173C@mail.kernel.org>
References: <20190328201458.30629-1-hsiangkao@aol.com>
 <20190330134528.7F9A62173C@mail.kernel.org>
Message-ID: <68f56509-bdd8-2cff-579a-c7e8202d37a7@huawei.com>

Hi,

On 2019/3/30 21:45, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 3aa8ec716e52 staging: erofs: add directory operations.
> 
> The bot has tested the following trees: v5.0.5, v4.19.32.
> 
> v5.0.5: Build OK!
> v4.19.32: Failed to apply! Possible dependencies:
>     6e78901a9f23 ("staging: erofs: separate erofs_get_meta_page")
>     7dd68b147d60 ("staging: erofs: use explicit unsigned int type")
>     8be31270362b ("staging: erofs: introduce erofs_grab_bio")
>     ab47dd2b0819 ("staging: erofs: cleanup z_erofs_vle_work_{lookup, register}")
> 
> 
> How should we proceed with this patch?

I have made a 4.19 patch for this:
https://lore.kernel.org/lkml/20190401065309.68109-2-gaoxiang25 at huawei.com/

Thanks,
Gao Xiang

> 
> --
> Thanks,
> Sasha
> 
