From: chao@kernel.org (Chao Yu)
Date: Tue, 7 Aug 2018 22:23:30 +0800
Subject: [PATCH v3] staging: erofs: disable compiling temporarile
In-Reply-To: <20180807123149.GC9359@kroah.com>
References: <20180802143455.9214-1-chao@kernel.org>
 <20180802173319.GB24125@kroah.com>
 <c89ff718-b88b-feb7-03e2-d0dc1c1cade1@huawei.com>
 <20180807091747.GA24468@kroah.com>
 <309c110f-83ca-f79e-c8ff-201fe9a9f027@huawei.com>
 <20180807123149.GC9359@kroah.com>
Message-ID: <1170b33e-a5b7-2d48-df33-cdc9f7fb3c37@kernel.org>

Hi Greg,

On 2018/8/7 20:31, Greg KH wrote:
> On Tue, Aug 07, 2018@06:42:23PM +0800, Chao Yu wrote:
>> I found that erofs-related patch was merged a little bit quickly, so that we may
>> miss Reviewed-by tag in that merged patch due to reviewer replied to the patch late.
>>
>> Out of curiosity, is there any rule for picking up and merging patches in
>> staging-{test,next} tree? like merging the patch if there is at least one guy
>> replies an ACK or no one object for some time?
> 
> That's what normally happens, I just was processing staging patches very
> quickly for a few days and got to them before you were able to review
> it.  That is not the normal state of things :)

Alright, I just try to know and adjust the running rule of staging tree, and
committing habit, don't mind those question of newcomers.

> 
> And remember, anyone can end up merging changes to your code, being a
> maintainers is not a "gatekeeper", it is a role where you are
> responsible for the code, but if other "responsible" people change it,
> that is also fine.

Yeah, I will remember that, thanks for letting me know the point of maintaining
codes.

I and Xiang are not against code changing from others, instead, we are open and
welcome for any changes to keep erofs active, make it improved and become
better. Anyway, please continue helping to review and commit erofs patches from
different developers, appreciating for that. ;)

Thanks,

> 
> thanks,
> 
> greg k-h
> 
