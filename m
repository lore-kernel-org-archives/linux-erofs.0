From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 14 Aug 2019 17:49:43 +0800
Subject: [PATCH RESEND 2/2] staging: erofs: differentiate unsupported
 on-disk format
In-Reply-To: <108ee2f9-75dd-b8ab-8da7-b81c17bafbf6@huawei.com>
References: <20190814042525.4925-2-gaoxiang25@huawei.com>
 <20190814043208.15591-1-gaoxiang25@huawei.com>
 <20190814043208.15591-2-gaoxiang25@huawei.com>
 <108ee2f9-75dd-b8ab-8da7-b81c17bafbf6@huawei.com>
Message-ID: <20190814094943.GA17960@138>

Hi Chao,

On Wed, Aug 14, 2019@05:25:51PM +0800, Chao Yu wrote:
> On 2019/8/14 12:32, Gao Xiang wrote:
> > For some specific fields, use ENOTSUPP instead of EIO
> > for values which look sane but aren't supported right now.
> > 
> > Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> 
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> 
> > +		return -ENOTSUPP;
> 
> A little bit confused about when we need to use ENOTSUPP or EOPNOTSUPP, I
> checked several manual of syscall, it looks EOPNOTSUPP is widely used.

It seems that you are right, I didn't notice this.
Let me resend this patchset to fix them all...

Thanks,
Gao Xiang

> 
> Thanks,
