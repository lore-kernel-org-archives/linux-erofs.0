From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 18 Mar 2019 10:50:51 +0800
Subject: [PATCH v2 for-4.19 RESEND 2/2] staging: erofs: fix race when the
 managed cache is enabled
In-Reply-To: <9de1ed49-d588-54c7-3ad6-375a7213cd2c@huawei.com>
References: <20190314044253.2944-1-gaoxiang25@huawei.com>
 <20190314044253.2944-2-gaoxiang25@huawei.com>
 <d1f70678-2215-d626-ed87-b024d6e5763c@huawei.com>
 <20190318022704.GP19508@bombadil.infradead.org>
 <9de1ed49-d588-54c7-3ad6-375a7213cd2c@huawei.com>
Message-ID: <d7dfdb7f-de54-3452-eda9-cb485f2c02c6@huawei.com>



On 2019/3/18 10:33, Gao Xiang wrote:
> I don't understand why we're trying to backport a piece of core kernel
> infrastructure for the benefit of a driver that's still in staging.

BTW, I thought you agreed to backport such an unimportant piece of XArray
since some ambiguous words in the previous emails eg:

> I gave this a quick look when it came past, and I don't particularly
> object to this piece going into 4.19.y.  A full-on backport of XArray
> to 4.19 will be ... interesting, but essentially this is just some
> boilerplate.

and

> I think we have to diverge from upstream here.  Part of the original
> commit is changing the format of internal & exceptional entries to give
> us an extra bit.  This implementation of xa_tag_pointer would transform
> a pointer tagged with value 1 into an internal pointer, which would
> break the radix tree.

If you changed your idea at some time I will redo this patch in
radix tree implementation instead.

It of course will make more conflicts since it seems that radix tree
will be taken place later in the Linux upstream.

Thanks,
Gao Xiang
