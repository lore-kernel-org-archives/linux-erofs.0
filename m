From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 1 Aug 2018 20:08:46 +0800
Subject: [PATCH RESEND 1/2] staging: erofs: add the missing break in
 z_erofs_map_blocks_iter
In-Reply-To: <20180801113620.3ufakhg3z62q46mw@mwanda>
References: <ea978a27-efd4-9d58-e4c0-f9d00420304f@huawei.com>
 <1533116214-70017-1-git-send-email-gaoxiang25@huawei.com>
 <20180801113620.3ufakhg3z62q46mw@mwanda>
Message-ID: <69349ab1-e38f-c755-e966-6bf787ccc896@huawei.com>

Hi Dan,

On 2018/8/1 19:36, Dan Carpenter wrote:
> On Wed, Aug 01, 2018@05:36:54PM +0800, Gao Xiang wrote:
>> This patch adds a missing break after adding the default case.
>>
>> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>> ---
>> As pointed out by Dan Carpenter:
>>  - fix the wrong place of fallthrough comments
> Thanks.  Looks good.  Next time use [PATCH v2] instead of RESEND.  The
> word RESEND basically means you are resending a patch exactly the same
> as it was before.  You would only need to do that if we accidentally
> deleted your first patch or whatever...
> 
> regards,
> dan carpenter
> 
> 
OK, it should not be titled RESEND, and I will take care the next time.
Thanks for taking the time to review :)

Thanks,
Gao Xiang
