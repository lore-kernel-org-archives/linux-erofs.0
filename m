From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 31 Jul 2019 15:11:38 +0800
Subject: [PATCH 08/22] staging: erofs: kill CONFIG_EROFS_FS_IO_MAX_RETRIES
In-Reply-To: <1c979e3f-54ec-cce8-650c-39e060e72169@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
 <20190729065159.62378-9-gaoxiang25@huawei.com>
 <1c979e3f-54ec-cce8-650c-39e060e72169@huawei.com>
Message-ID: <2d7abbad-61d0-df2b-6a42-26f2606d775a@huawei.com>

Hi Chao,

On 2019/7/31 15:05, Chao Yu wrote:
> On 2019/7/29 14:51, Gao Xiang wrote:
>> CONFIG_EROFS_FS_IO_MAX_RETRIES seems a runtime setting
>> and users have no idea about the change in behaviour.
>>
>> Let's remove the setting currently and fold it into code,
>> turn it into a module parameter if it's really needed.
>>
>> Suggested-by: David Sterba <dsterba at suse.cz>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> 
> It's fine to me, but I'd like to suggest to add this as a sys entry which can be
> more flexible for user to change.

I think it can be added in the later version, the original view
from David is that he had question how users using this option.

Maybe we can use the default value and leave it to users who
really need to modify this value (real requirement).

Thanks,
Gao Xiang

> 
> Thanks
> 
