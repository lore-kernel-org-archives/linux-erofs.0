From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 6 Aug 2018 10:07:56 +0800
Subject: [PATCH] drivers/staging: Remove some unneeded semicolon
In-Reply-To: <e80780ed-42c8-3f8c-9197-1c6ac386fb30@huawei.com>
References: <1533477429-17379-1-git-send-email-zhongjiang@huawei.com>
 <687229f8-549f-cec1-c83f-b8acfd32d767@huawei.com>
 <e80780ed-42c8-3f8c-9197-1c6ac386fb30@huawei.com>
Message-ID: <50b97db3-8cd3-fe68-e23a-d6366f9c014b@huawei.com>

Hi Chao,

On 2018/8/6 9:58, Chao Yu wrote:
> Hi Xiang,
> 
> On 2018/8/6 9:27, Gao Xiang wrote:
>> Hi Jiang,
>>
>> On 2018/8/5 21:57, zhong jiang wrote:
>>> That semicolons are unneeded, JUst remove them.
>>>
>>> Signed-off-by: zhong jiang <zhongjiang at huawei.com>
>>
>> Thanks for your patch. Since erofs and gasket are different feature, it is better to seperate into two patches.
>> and could you please cc linux-erofs mailing list <linux-erofs at lists.ozlabs.org> as well?
>>
>> Yes, there is an extra semicolon in z_erofs_vle_unzip_all, it was reported by Julia Lawall several days ago.
>> Actually, there is a patch in linux-erofs mailing list, but it seems that Chao hasn't reviewed it yet...
> 
> Oh, sorry, I missed this one, let me check/review all recent patches again and
> update them in tree later.
> 
> Thanks,

It is nothing. :) I will send v2 version of this patch if zhong jiang doesn't mind.

Thanks,
Gao Xiang

> 
>>
>> https://lists.ozlabs.org/pipermail/linux-erofs/2018-August/000303.html
>>
>> I will add Signed-off-by: zhong jiang <zhongjiang at huawei.com> to the original patch if if you don't mind, do you?
>>
>> Thanks,
>> Gao Xiang
>>
>> .
>>
> 
