From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 18 Mar 2019 10:33:22 +0800
Subject: [PATCH v2 for-4.19 RESEND 2/2] staging: erofs: fix race when the
 managed cache is enabled
In-Reply-To: <20190318022704.GP19508@bombadil.infradead.org>
References: <20190314044253.2944-1-gaoxiang25@huawei.com>
 <20190314044253.2944-2-gaoxiang25@huawei.com>
 <d1f70678-2215-d626-ed87-b024d6e5763c@huawei.com>
 <20190318022704.GP19508@bombadil.infradead.org>
Message-ID: <9de1ed49-d588-54c7-3ad6-375a7213cd2c@huawei.com>



On 2019/3/18 10:27, Matthew Wilcox wrote:
> On Mon, Mar 18, 2019@09:59:19AM +0800, Gao Xiang wrote:
>> ping?
>>
>> Hi Greg,
>> I have no idea of this patch since Matthew makes no response after
>> modification... And this series is still not backported to 4.19 till now...
>>
>> What should I do next? Can this series be accepted for linux-4.19? :(
> 
> I don't understand why we're trying to backport a piece of core kernel
> infrastructure for the benefit of a driver that's still in staging.
> 

I try to enable erofs to Android which will start at linux-4.19.

erofs has been successfully used by several HUAWEI mobile phones from low-end to high-end,
which squashfs cannot since we fails to use it even on highest phone HUAWEI Mate 9 since it has poor performance.

Add a word, is any staging driver no use to be backported?

Thanks,
Gao Xiang
