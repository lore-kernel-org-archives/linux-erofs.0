From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 25 Jan 2019 21:54:42 +0800
Subject: [PATCH 2/2] staging: erofs: complete POSIX ACL support
In-Reply-To: <20190125133044.GC1795@kadam>
References: <20190125115103.47250-1-gaoxiang25@huawei.com>
 <20190125120104.15604-1-gaoxiang25@huawei.com> <20190125133044.GC1795@kadam>
Message-ID: <c3007962-c73f-ddfc-eb39-d8d8b5fef832@huawei.com>

Hi Dan,

On 2019/1/25 21:30, Dan Carpenter wrote:
> On Fri, Jan 25, 2019@08:01:04PM +0800, Gao Xiang wrote:
>> Let's add .get_acl() to read the file's acl
>> from its xattrs to make POSIX ACL usable.
>>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>> ---
>>  This [PATCH 2/2] currently hasn't tested, please ignore temporarily...
>>  I will test it asap...
> 
> This is an awkward thing.
> 
> Just don't send it until after you test it.  We also ignore RFC patches
> so if you mark it as RFC that will be ignored if you want.

Yes, you are right.

Actually I just want to send the only [PATCH 1/2], but I missed to
change the subject of [PATCH 1/2] -> [PATCH]...Therefore I have to
send this incomplete one to complete this "patchset" by mistake...

Thanks,
Gao Xiang

> 
> regards,
> dan carpenter
> 
