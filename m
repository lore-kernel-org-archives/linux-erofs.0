From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 31 Jul 2019 20:55:10 +0800
Subject: [PATCH 08/22] staging: erofs: kill CONFIG_EROFS_FS_IO_MAX_RETRIES
In-Reply-To: <985b3ca7-afee-006e-a367-98a865995246@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
 <20190729065159.62378-9-gaoxiang25@huawei.com>
 <1c979e3f-54ec-cce8-650c-39e060e72169@huawei.com>
 <2d7abbad-61d0-df2b-6a42-26f2606d775a@huawei.com>
 <985b3ca7-afee-006e-a367-98a865995246@huawei.com>
Message-ID: <845b43cb-3b9e-1b97-babe-a433078c4f9c@huawei.com>



On 2019/7/31 20:10, Chao Yu wrote:
> Hi Xiang,
> 
> On 2019/7/31 15:11, Gao Xiang wrote:
>> Hi Chao,
>>
>> On 2019/7/31 15:05, Chao Yu wrote:
>>> On 2019/7/29 14:51, Gao Xiang wrote:
>>>> CONFIG_EROFS_FS_IO_MAX_RETRIES seems a runtime setting
>>>> and users have no idea about the change in behaviour.
>>>>
>>>> Let's remove the setting currently and fold it into code,
>>>> turn it into a module parameter if it's really needed.
>>>>
>>>> Suggested-by: David Sterba <dsterba at suse.cz>
>>>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>>>
>>> It's fine to me, but I'd like to suggest to add this as a sys entry which can be
>>> more flexible for user to change.
>>
>> I think it can be added in the later version, the original view
>> from David is that he had question how users using this option.
>>
>> Maybe we can use the default value and leave it to users who
>> really need to modify this value (real requirement).
> 
> I think we need to decide it in this version, otherwise it may face backward
> compatibility issue if we change module argument to sys entry later.
> 
> Maybe just leave it as an fixed macro is fine, since there is actually no
> requirement on this.

OK, will fix it --- leave the fixed macro.

Thanks,
Gao Xiang

> 
> Thanks,
> 
>>
>> Thanks,
>> Gao Xiang
>>
>>>
>>> Thanks
>>>
>> .
>>
