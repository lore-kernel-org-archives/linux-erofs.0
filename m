From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 3 Jul 2018 22:22:01 +0800
Subject: [PATCH 11/11] erofs: support tracepoint
In-Reply-To: <080d2c39-83ee-9643-4ec6-0991ae31769c@kernel.org>
References: <20180622020131.65525-1-yuchao0@huawei.com>
 <20180622020131.65525-11-yuchao0@huawei.com>
 <ad8b5812-699e-9c99-3d76-02fa65635c6c@huawei.com>
 <080d2c39-83ee-9643-4ec6-0991ae31769c@kernel.org>
Message-ID: <d99617dd-b165-9e18-db16-2c34521f4d8a@huawei.com>


On 2018/7/3 21:52, Chao Yu wrote:
> Hi Xiang,
> 
> On 2018/7/3 17:44, Gao Xiang wrote:
>> Hi Chao,
>>
>> On 2018/6/22 10:01, Chao Yu wrote:
>>> Add tracepoints for ->readpage{,s}, ->lookup.
>>>
>>> Signed-off-by: Chao Yu <yuchao0 at huawei.com> ---
>> Very useful feature (I could use it for the new unzip implementation :) )
> It seems we need more tracepoints for debug or accounting, but now I just add
> basic ones, let's add more. ;)
> 

I am transfering some useful map_blocks debug messages to tracepoints, which
seems more suitable :)

Thanks,
Gao Xiang
