From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 20 Feb 2019 18:33:45 +0800
Subject: [PATCH] staging: erofs: remove rcu_read_lock() in
 erofs_try_to_free_cached_page
In-Reply-To: <20190220102026.GA32312@kroah.com>
References: <20190216084650.33841-1-gaoxiang25@huawei.com>
 <fc058e45-a645-c680-2ce0-19de83fffc2e@huawei.com>
 <20190220102026.GA32312@kroah.com>
Message-ID: <d26afca8-6efb-adfa-42ba-542b7949d4d8@huawei.com>



On 2019/2/20 18:20, Greg Kroah-Hartman wrote:
> On Wed, Feb 20, 2019@10:38:53AM +0800, Gao Xiang wrote:
>> Hi Greg,
>>
>> Could you consider take some time on these two patches for linux-5.1-rc1?
>>  1) staging: erofs: fix race of initializing xattrs of a inode at the same time
>>  2) staging: erofs: remove rcu_read_lock() in erofs_try_to_free_cached_page
>>
>> It will be of great help, especially patch 1 (it could cause potential memleak
>> in the race condition without it).
> 
> Ok, I'll queue them up now, I was waiting for reviewed-by tags from
> others to show up :)

Thanks! :)
Gao Xiang

> 
> greg k-h
> 
