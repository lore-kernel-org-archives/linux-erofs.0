From: chao@kernel.org (Chao Yu)
Date: Mon, 13 Aug 2018 20:46:44 +0800
Subject: [PATCH 3/8] staging: erofs: add error handling for xattr submodule
In-Reply-To: <c14184af-6378-fd96-3b9b-52c9a7da8463@huawei.com>
References: <20180812140150.13397-1-chao@kernel.org>
 <20180812140150.13397-4-chao@kernel.org>
 <20180813114725.kgoupvppcwsw2vyj@mwanda>
 <c14184af-6378-fd96-3b9b-52c9a7da8463@huawei.com>
Message-ID: <961b0caf-7a22-1a15-9641-69b218396980@kernel.org>

On 2018/8/13 20:17, Gao Xiang wrote:
>> Generally the rule on likely/unlikely is that they hurt readability so
>> we should only add them if it makes a difference in benchmarking.
>>
> 
> In my opinion, return values other than 0 and ENOATTR(ENODATA) rarely happens,
> it should be in the slow path...

Hi Dan, thanks for the comments.

IMO, we should check and clean up all likely/unlikely in erofs, to make sure
they are used in the right place.

Thanks,
