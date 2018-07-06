From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 6 Jul 2018 19:34:44 +0800
Subject: [PATCH] erofs: fix erofs_module_init & exit
In-Reply-To: <ada61dd7-791f-7bc1-d8da-32a360d50889@huawei.com>
References: <1530767030-86277-1-git-send-email-gaoxiang25@huawei.com>
 <b66fb258-e9af-1ad9-7613-92ad07ca75b3@kernel.org>
 <a3348541-c140-94fc-95ec-6334c827e09e@huawei.com>
 <c2dcf7f9-ab9e-29e5-4532-83ce5066d0c0@huawei.com>
 <ada61dd7-791f-7bc1-d8da-32a360d50889@huawei.com>
Message-ID: <987be359-1fdb-3ad9-bf58-15b83a43d934@huawei.com>

Hi Chao,

On 2018/7/6 10:09, Gao Xiang wrote:
>> Alright, it's trivial, let's keep the code as original state. :)
>>
>> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
>>
> :), Thanks for the review~
> 
> It seems that 'erofs_check_ondisk_layout_definations' is more proper than 'erofs_check_ondisk_layout',
> which seems used for the runtime sanity check..
> 
> Let me send the next version :)
> 
> 
> Thanks,
> Gao Xiang
> 

Too many chores today... Sorry for late response..
Could you check the v2 patch and merge it? :)

Thanks,
Gao Xiang
