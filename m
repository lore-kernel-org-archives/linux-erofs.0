From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 25 Feb 2019 14:58:55 +0800
Subject: [PATCH 2/2] staging: erofs: switch to ->iterate_shared()
In-Reply-To: <9ba14947-f891-33c6-278c-7d75bd07befd@huawei.com>
References: <20190221023411.2980-1-gaoxiang25@huawei.com>
 <20190221023411.2980-2-gaoxiang25@huawei.com>
 <9ba14947-f891-33c6-278c-7d75bd07befd@huawei.com>
Message-ID: <28d42ed8-8e6d-1eeb-76f3-1f0503aae9d0@huawei.com>



On 2019/2/25 9:36, Chao Yu wrote:
> On 2019/2/21 10:34, Gao Xiang wrote:
>> After commit 6192269444eb ("introduce a parallel variant of ->iterate()"),
>> readdir can be done without taking exclusive inode lock of course.
>>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> 
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks for review :)

> 
> Thanks,
> 
