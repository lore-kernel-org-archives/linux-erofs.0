From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 18 Feb 2019 10:50:31 +0800
Subject: [PATCH v2] staging: erofs: keep corrupted fs from crashing kernel
 in erofs_namei()
In-Reply-To: <56f03bdf-1817-6b3e-44d5-922637ac39f4@huawei.com>
References: <20190201121631.15179-1-gaoxiang25@huawei.com>
 <a9381c0d-9857-4d03-710d-80006d426bbc@huawei.com>
 <c742194d-4207-e7b9-b679-c1f207961f17@huawei.com>
 <31ba7d15-058e-1996-3482-65fbd1e83e26@huawei.com>
 <56f03bdf-1817-6b3e-44d5-922637ac39f4@huawei.com>
Message-ID: <2e8f710c-574e-6634-f412-c45337474190@huawei.com>

Hi Xiang,

On 2019/2/18 10:17, Gao Xiang wrote:
> Hi Chao,
> 
> On 2019/2/18 9:39, Chao Yu wrote:
>> If the image is corrupted, qn->name[i] may be anything, as you commented
>> above DBG_BUGON(), we really don't need to go through any later codes, it
>> can avoid potentially encoutnering wrong condition.
>>
>> * otherwise, it will return 1 to just skip the invalid name
>>
> 
> Just I commented in the following source code, qn is actually the user requested
> name allocated in __d_alloc, which can be guaranteed with the trailing '\0' and
> it is a valid string.

Alright, I agreed below codes can guarantee that. :)

Thanks,

> 
> Thanks,
> Gao Xiang
> 
>>>>> +
>>>>> +	/* qd could not have trailing '\0' */
>>>>> +	/* However it is absolutely safe if < qd->end */
>>>>> +	while (qd->name + i < qd->end && qd->name[i] != '\0') {
>>>>> +		if (qn->name[i] != qd->name[i]) {
>>>>> +			*matched = i;
>>>>> +			return qn->name[i] > qd->name[i] ? 1 : -1;
>>>>>  		}
>>>>> -		return (qn->len > qd->len);
>>>>> +		++i;
>>>>>  	}
>>>>> -
>>>>> -	if (qn->name[i] != qd->name[i]) {
>>>>> -		*matched = i;
>>>>> -		return qn->name[i] > qd->name[i] ? 1 : -1;
>>>>> -	}
>>>>> -
>>>>> -	++i;
>>>>> -	goto loop;
>>>>> +	*matched = i;
>>>>> +	/* See comments in __d_alloc on the terminating NUL character */
>>>>> +	return qn->name[i] == '\0' ? 0 : 1;
>>>>>  }
> 
> .
> 
