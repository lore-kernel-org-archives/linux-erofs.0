From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 6 Aug 2018 10:16:21 +0800
Subject: [PATCH] drivers/staging: Remove some unneeded semicolon
In-Reply-To: <5B67AE47.4080307@huawei.com>
References: <1533477429-17379-1-git-send-email-zhongjiang@huawei.com>
 <687229f8-549f-cec1-c83f-b8acfd32d767@huawei.com>
 <5B67AE47.4080307@huawei.com>
Message-ID: <af5a1b0e-1aad-abef-d877-8cee3e41e845@huawei.com>


On 2018/8/6 10:11, zhong jiang wrote:
> On 2018/8/6 9:27, Gao Xiang wrote:
>> Hi Jiang,
>>
>> On 2018/8/5 21:57, zhong jiang wrote:
>>> That semicolons are unneeded, JUst remove them.
>>>
>>> Signed-off-by: zhong jiang <zhongjiang at huawei.com>
>> Thanks for your patch. Since erofs and gasket are different feature, it is better to seperate into two patches.
>> and could you please cc linux-erofs mailing list <linux-erofs at lists.ozlabs.org> as well?
>>
>> Yes, there is an extra semicolon in z_erofs_vle_unzip_all, it was reported by Julia Lawall several days ago.
>> Actually, there is a patch in linux-erofs mailing list, but it seems that Chao hasn't reviewed it yet...
>>
>> https://lists.ozlabs.org/pipermail/linux-erofs/2018-August/000303.html
>>
>> I will add Signed-off-by: zhong jiang <zhongjiang at huawei.com> to the original patch if if you don't mind, do you?
>  do it.  Thanks.  Then I will just resend the gasket feature separately.
> 

Thanks for your understanding :)

Thanks,
Gao Xiang

>  Thanks,
>  zhong jiang
>> Thanks,
>> Gao Xiang
>>
>> .
>>
> 
> 
