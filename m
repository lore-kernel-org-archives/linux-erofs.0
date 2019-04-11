From: hsiangkao@aol.com (Gao Xiang)
Date: Fri, 12 Apr 2019 00:25:19 +0800
Subject: Some new bio merging behaviors in __bio_try_merge_page
In-Reply-To: <20190411153411.GA16987@infradead.org>
References: <85c5fa1a-a506-e26f-c354-1554d47d8b2b@huawei.com>
 <20190411070807.GA421@ming.t460p>
 <cb392476-a00e-09ce-fa6b-9e088242ecc6@huawei.com>
 <20190411080953.GE421@ming.t460p> <20190411153411.GA16987@infradead.org>
Message-ID: <9aa607da-6ccb-8166-22df-735a3b127f2e@aol.com>



On 2019/4/11 23:34, Christoph Hellwig wrote:
> On Thu, Apr 11, 2019@04:09:54PM +0800, Ming Lei wrote:
>> I don't think it is a good behaviour to use bio->bi_max_vecs to limit
>> max allowed page, you may see the idea from the naming simply...
>>
>> If there were other such drivers, we may fix it easily, and the following
>> patch should fix your issue:
> 
> Yep.  Consumers of the block layer really have no business at all
> looking at bi_vcnt.

Thanks for pointing out, Ming's solution is enough to solve erofs issue.

Thanks,
Gao XIang

> 
