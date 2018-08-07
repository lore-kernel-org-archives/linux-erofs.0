From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 7 Aug 2018 18:42:23 +0800
Subject: [PATCH v3] staging: erofs: disable compiling temporarile
In-Reply-To: <20180807091747.GA24468@kroah.com>
References: <20180802143455.9214-1-chao@kernel.org>
 <20180802173319.GB24125@kroah.com>
 <c89ff718-b88b-feb7-03e2-d0dc1c1cade1@huawei.com>
 <20180807091747.GA24468@kroah.com>
Message-ID: <309c110f-83ca-f79e-c8ff-201fe9a9f027@huawei.com>

On 2018/8/7 17:17, Greg KH wrote:
> On Mon, Aug 06, 2018@11:07:07AM +0800, Chao Yu wrote:
>> Hi Greg,
>>
>> On 2018/8/3 1:33, Greg KH wrote:
>>> Sorry, I already took the first version in my tree.  Don't worry about
>>
>> For staging-{test,next} maintaining thing, before merge window, if we want to
>> remove or replace one merged patch in staging tree, what we can do is:
>> a. ask you for help to remove/replace it directly; or
>> b. submit a revert-patch first, and then send another fixed patch.
> 
> Or better yet:
> 	- submit a follow-on patch that fixes things up properly.

Agreed, that will be more efficient, we will let erofs guys keep that rule. :)

I found that erofs-related patch was merged a little bit quickly, so that we may
miss Reviewed-by tag in that merged patch due to reviewer replied to the patch late.

Out of curiosity, is there any rule for picking up and merging patches in
staging-{test,next} tree? like merging the patch if there is at least one guy
replies an ACK or no one object for some time?

Thanks,

> 
> thanks
> 
> greg k-h
> 
> .
> 
