From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 22 Nov 2018 18:35:00 +0800
Subject: [PATCH 08/10] staging: erofs: locked before registering for all
 new workgroups
In-Reply-To: <20181122102431.GH3189@kroah.com>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-9-gaoxiang25@huawei.com>
 <20181122102431.GH3189@kroah.com>
Message-ID: <e0b4773c-36a1-cb02-e87f-a164cfbf3633@huawei.com>

Hi Greg,

On 2018/11/22 18:24, Greg Kroah-Hartman wrote:
>> +	/* lock all primary followed works before visible to others */
>> +	if (unlikely(!mutex_trylock(&work->lock)))
>> +		/* for a new workgroup, try_lock *never* fails */
>> +		DBG_BUGON(1);
> Again, drop this, if it never fails, then there's no need for this.  If
> it can fail, then properly handle it.
> 
> And trylock can fail, so this needs to be fixed.

OK, I will drop this.

Thanks,
Gao Xiang

> 
> thanks,
