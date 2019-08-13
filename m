From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 13 Aug 2019 11:57:57 +0800
Subject: [PATCH 3/3] staging: erofs: xattr.c: avoid BUG_ON
In-Reply-To: <84f50ca2-3411-36a6-049a-0d343d8df325@huawei.com>
References: <20190813023054.73126-1-gaoxiang25@huawei.com>
 <20190813023054.73126-3-gaoxiang25@huawei.com>
 <84f50ca2-3411-36a6-049a-0d343d8df325@huawei.com>
Message-ID: <20190813035754.GA23614@138>

Hi Chao,

On Tue, Aug 13, 2019@11:20:22AM +0800, Chao Yu wrote:
> On 2019/8/13 10:30, Gao Xiang wrote:
> > Kill all the remaining BUG_ON in EROFS:
> >  - one BUG_ON was used to detect xattr on-disk corruption,
> >    proper error handling should be added for it instead;
> >  - the other BUG_ONs are used to detect potential issues,
> >    use DBG_BUGON only in (eng) debugging version.
> 
> BTW, do we need add WARN_ON() into DBG_BUGON() to show some details function or
> call stack in where we encounter the issue?

Thanks for kindly review :)

Agreed, it seems much better. If there are no other considerations
here, I can submit another patch addressing it later or maybe we
can change it in the next linux version since I'd like to focusing
on moving out of staging for this round...

Thanks,
Gao Xiang

> 
> > 
> > Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> 
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> 
> Thanks,
