From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 18 Feb 2019 10:41:36 +0800
Subject: [PATCH v2] staging: erofs: keep corrupted fs from crashing kernel
 in erofs_namei()
In-Reply-To: <20190215093503.GH2326@kadam>
References: <20190201121631.15179-1-gaoxiang25@huawei.com>
 <a9381c0d-9857-4d03-710d-80006d426bbc@huawei.com>
 <20190215075757.GG2326@kadam>
 <fb99bac2-2587-04fa-6ac2-f2e5f83af7c9@huawei.com>
 <20190215093503.GH2326@kadam>
Message-ID: <d5567c5c-7ceb-a9cc-0fb8-b6b04a4d42ca@huawei.com>

On 2019/2/15 17:35, Dan Carpenter wrote:
> On Fri, Feb 15, 2019@05:32:33PM +0800, Chao Yu wrote:
>> On 2019/2/15 15:57, Dan Carpenter wrote:
>>> On Fri, Feb 15, 2019@03:02:25PM +0800, Chao Yu wrote:
>>>> On 2019/2/1 20:16, Gao Xiang wrote:
>>>>> +	/*
>>>>> +	 * on-disk error, let's only BUG_ON in the debugging mode.
>>>>> +	 * otherwise, it will return 1 to just skip the invalid name
>>>>> +	 * and go on (in consideration of the lookup performance).
>>>>> +	 */
>>>>> +	DBG_BUGON(qd->name > qd->end);
>>>>
>>>> qd->name == qd->end is not allowed as well?
>>>>
>>>> So will it be better to return directly here?
>>>>
>>>> 	if (unlikely(qd->name >= qd->end)) {
>>>> 		DBG_BUGON(1);
>>>> 		return 1;
>>>> 	}
>>>
>>> Please don't add likely/unlikely() annotations unless you have
>>> benchmarked it and it makes a difference.
>>
>> Well, it only occur for corrupted image, since the image is readonly, so it
>> is really rare.
> 
> The likely/unlikely() annotations make the code harder to read.  It's

Well, I think unlikely here can imply this is a rare case which may help to
read...

> only worth it if it's is a speedup on a fast path.

I guess unlikely here can help pipeline to load/execute right branch codes
instead of that rare branch one with BUGON(), is that right?

Thanks,

> 
> regards,
> dan carpenter
> 
> 
> .
> 
