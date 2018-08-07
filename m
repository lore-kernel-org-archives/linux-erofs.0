From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 7 Aug 2018 22:12:48 +0800
Subject: [PATCH v3] staging: erofs: disable compiling temporarile
In-Reply-To: <20180807123149.GC9359@kroah.com>
References: <20180802143455.9214-1-chao@kernel.org>
 <20180802173319.GB24125@kroah.com>
 <c89ff718-b88b-feb7-03e2-d0dc1c1cade1@huawei.com>
 <20180807091747.GA24468@kroah.com>
 <309c110f-83ca-f79e-c8ff-201fe9a9f027@huawei.com>
 <20180807123149.GC9359@kroah.com>
Message-ID: <adab88fd-9a3c-d578-5b05-2c234c97ec6e@huawei.com>

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

Actually we are guessing the merging magic from Greg these days :)

> 
> And remember, anyone can end up merging changes to your code, being a
> maintainers is not a "gatekeeper", it is a role where you are
> responsible for the code, but if other "responsible" people change it,
> that is also fine.

OK, I get the merging policy, and I totally agree and support it. And yes,
any patch from anyone are welcome.
It is a nice thing which means someone is interested in it, especially
for the filesystem actively under development. :)

We are quite happy more people could blame us, and join us to improve it (although
currently source code of mkfs is missing for some business reasons, I am using my best
effort to push this forward), and we will tell guys who are interested in erofs what we are
doing now (what we are focusing on) and what we will do next regularly.

Thanks,
Gao Xiang

> 
> thanks,
> 
> greg k-h
> 
