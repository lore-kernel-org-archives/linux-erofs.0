From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 22 Nov 2018 19:37:17 +0800
Subject: [PATCH 07/10] staging: erofs: separate into init_once / always
In-Reply-To: <20181122112645.GA7527@kroah.com>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-8-gaoxiang25@huawei.com>
 <20181122102339.GG3189@kroah.com>
 <66b90226-5d0e-7344-5220-908aa243b014@huawei.com>
 <20181122110500.GC5287@kroah.com>
 <ef49bf11-b937-46b4-1b9a-c068182aa7d9@huawei.com>
 <20181122112645.GA7527@kroah.com>
Message-ID: <4a501e48-e2a9-45ea-554b-8dc1163721fb@huawei.com>

Hi Greg,

On 2018/11/22 19:26, Greg Kroah-Hartman wrote:
> On Thu, Nov 22, 2018@07:11:08PM +0800, Gao Xiang wrote:
>> Hi Greg,
>>
>> On 2018/11/22 19:05, Greg Kroah-Hartman wrote:
>>> On Thu, Nov 22, 2018@06:34:10PM +0800, Gao Xiang wrote:
>>>> Hi Greg,
>>>>
>>>> On 2018/11/22 18:23, Greg Kroah-Hartman wrote:
>>>>>> +
>>>>>> +	DBG_BUGON(work->nr_pages);
>>>>>> +	DBG_BUGON(work->vcnt);
>>>>> How can these ever be triggered?  I understand the need for debugging
>>>>> code when you are writing code, but at this point it shouldn't be needed
>>>>> anymore, right?
>>>>
>>>> I need to avoid some fields is not 0 when the new workgroup is created (because
>>>> work->nr_pages and work->vcnt == 0 usually after the previous workgroup is freed).
>>>> But that is not obvious, it is promised by the current logic.
>>>
>>> Then delete these lines if they can never happen :)
>>
>> I don't know how to observe such a race in our beta test and community users.
> 
> 	/*
> 	 * Let developers know something went really wrong with their
> 	 * initialization code
> 	 */
> 	if (!work->nr_pages) {
> 		pr_err("nr_pages == NULL!");
> 		WARN_ON(1);
> 	}
> 	if (!work->vcnt) {
> 		pr_err("vcnt == NULL!");
> 		WARN_ON(1);
> 	}
> 
> or something like that.
> 
> Don't make people rebuild your code with different options for
> debugging.  That will never work in the 'real world' when people start
> using the code.  You need to have things enabled for people all the
> time, which is why we have dynamic debugging in the kernel now, and not
> a zillion different "DRIVER_DEBUG" build options anymore.
> 
>> Because if the kernel is crashed, we could collect the whole kernel dump to observe the memory
>> and all registers, if we only have some warning, it will be not easy to get the state as early as possible.
> 
> When the kernel crashes, geting a dump is hard on almost all hardware.
> It is only rare systems that you can get a kernel dump.

This piece of code is already used in our hisilicon beta test, all memorydump,
registers, stack can be collected.

Apart from that, I observed many f2fs bugs are observed in this way and
many erofs bugs are collected in that way...sigh...

Thanks,
Gao Xiang


> 
> thanks,
> 
> greg k-h
> 
