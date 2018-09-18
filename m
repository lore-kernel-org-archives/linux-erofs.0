From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 18 Sep 2018 21:20:52 +0800
Subject: [PATCH 0/8] staging: erofs: error handing and more tracepoints
In-Reply-To: <20180918130911.GA16187@kroah.com>
References: <1536936030-62362-1-git-send-email-gaoxiang25@huawei.com>
 <20180918111953.GA3585@kroah.com>
 <aab26d0e-f8dc-cc83-46eb-7a93a833eaae@huawei.com>
 <20180918121413.GA499@kroah.com>
 <e940cdaf-faeb-7f60-b5ca-5f4d6af450be@huawei.com>
 <20180918130337.jtq6ziqp6efr3fq4@mwanda> <20180918130911.GA16187@kroah.com>
Message-ID: <173c5e62-6e4f-066c-5526-afd12c53c051@huawei.com>



On 2018/9/18 21:09, Greg Kroah-Hartman wrote:
> On Tue, Sep 18, 2018@04:03:37PM +0300, Dan Carpenter wrote:
>> On Tue, Sep 18, 2018@08:31:22PM +0800, Gao Xiang wrote:
>>> (I have no clang environment to build kernel yet... :( I will try later, but I have no idea why it happens,
>>> and it seems a false warning).
>>>
>>> Thanks,
>>> Gao Xiang
>>>
>>>>
>>>> Or is gcc just being "dumb" here?  What about clang, have you tried
>>>> building it with that compiler as well?
>>
>> Yeah.  Gcc is wrong.  Gcc used to be extra conservative and missed a
>> bunch of bugs, but I guess now they're going in to opposite direction?
>>
>> Smatch gets this correct, but you have to rebuild the cross function DB
>> twice to make the warning go away.  It could be because it starts out
>> with the old vle_get_logical_extent_head() information so it thinks it
>> knows how that function works.

Hi Dan,
Thanks for taking time to confirm this and the detailed explanation ;)

> 
> Ok, thanks for checking (both of you).  Just initialize the variable to
> keep gcc from printing foolish warnings.

Hi Greg,

Ok, if you don't tend to use `uninitialized_var(...)', I will initialize a 
dumb value...but I think it is really useless to initialize it... :(

I will resend the related false warning patch independently soon...

Thanks,
Gao Xiang

> 
> thanks,
> 
> greg k-h
> 
