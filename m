From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 18 Sep 2018 21:50:01 +0800
Subject: [PATCH v2 1/6] staging: erofs: code cleanup for erofs_kmalloc()
In-Reply-To: <06c4e147-fee7-f94c-7b57-72b60eaf1f2a@huawei.com>
References: <20180917153426.16880-1-cgxu519@gmx.com>
 <20180917153426.16880-2-cgxu519@gmx.com>
 <06c4e147-fee7-f94c-7b57-72b60eaf1f2a@huawei.com>
Message-ID: <3dc5cce0-3388-4621-2bd1-148079799435@huawei.com>



On 2018/9/18 18:41, Chao Yu wrote:
> On 2018/9/17 23:34, Chengguang Xu wrote:
>> Define a dummy function of time_to_inject()/erofs_show_injection_info(),
>> so that we don't have to check macro CONFIG_EROFS_FAULT_INJECTION in
>> calling place.
>>
>> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
> 
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> 

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang

> Thanks,
> 
