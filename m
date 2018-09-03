From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 3 Sep 2018 12:23:17 +0800
Subject: [PATCH 2/6] staging: erofs: formatting fix to NULL comparison
In-Reply-To: <9172e7b7-ff42-85ca-f546-a369b8698d27@huawei.com>
References: <1535642042-5336-1-git-send-email-zemlyanoy@ispras.ru>
 <1535642042-5336-2-git-send-email-zemlyanoy@ispras.ru>
 <747d9c74-02cd-fa39-9870-ae17dbddf366@aol.com>
 <44d6e603-fe1d-6853-c474-760c0a2ed4ec@aol.com>
 <47c7d469-c807-760d-7e28-ae8108a46af5@huawei.com>
 <20180831094106.sxwsd5v2mmn3cux6@mwanda>
 <9172e7b7-ff42-85ca-f546-a369b8698d27@huawei.com>
Message-ID: <83ebc210-63cf-993c-4204-6860edf205f5@aol.com>

Hi,

On 2018/9/3 9:59, Chao Yu wrote:
> On 2018/8/31 17:41, Dan Carpenter wrote:
>> On Fri, Aug 31, 2018@11:29:03AM +0800, Chao Yu wrote:
>>>
>>> Hi Xiang,
>>>
>>> I'm not against this change which follows checkpatch's rule, since I think this
>>> can help to unify coding style in different modules of Linux. Maybe cleanup in
>>> other filesystem is needed as well.
>>>
>>
>> That code is old, and those filesystems are not in staging so we're not
>> going to change them.
> 
> Yup, anyway, it can be decided by their maintainer if they want the cleanup.
> 
>>
>> Let's just apply the patch and not spend any time thinking about it.
>> Part of the point of style guidelines is so that we don't have to
>> repeat all these discussions over and over...
>>
>> Btw, I have a rename_rev.pl patch for reviewing these.  I've attached
>> it.  rename_rev.pl -r NULL.  I've seen some people screw up the
>> conversion so having an automated review is nice.
> 
> Cool, thanks very much for providing this tools, it actually can help to save
> some time during review. :)
> 

I am traveling in Tibet. Sorry for the late response.

OK, that is fine. I will follow the new kernel coding style strictly
for the upcoming code.

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang

>>
>> regards,
>> dan carpenter
>>
> 
