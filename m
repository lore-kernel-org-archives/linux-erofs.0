From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 13 Nov 2018 08:38:29 +0800
Subject: [PATCH 1/3] staging: erofs: unzip_vle.c: Replace comparison to
 NULL.
In-Reply-To: <20181112234603.GB16079@kroah.com>
References: <1542055439-24444-1-git-send-email-sicilia.cristian@gmail.com>
 <1542055439-24444-2-git-send-email-sicilia.cristian@gmail.com>
 <20181112224636.GA12671@kroah.com>
 <CACU=YuX3U50uVaitV1Mhn3Dn8pXhPZt-1K7HX4Bn7MUCrgE35w@mail.gmail.com>
 <20181112234603.GB16079@kroah.com>
Message-ID: <f637a545-bcbb-c0a4-e95c-26e0294d3752@huawei.com>

Hi Greg,

On 2018/11/13 7:46, Greg Kroah-Hartman wrote:
> On Tue, Nov 13, 2018@12:31:58AM +0100, Cristian Sicilia wrote:
>> On Mon, Nov 12, 2018 at 11:46 PM Greg Kroah-Hartman <
>> gregkh@linuxfoundation.org> wrote:
>>
>>> On Mon, Nov 12, 2018@09:43:57PM +0100, Cristian Sicilia wrote:
>>>> Replace equal to NULL with logic unary operator,
>>>> and removing not equal to NULL comparison.
>>>>
>>>> Signed-off-by: Cristian Sicilia <sicilia.cristian at gmail.com>
>>>> ---
>>>>  drivers/staging/erofs/unzip_vle.c | 86
>>> +++++++++++++++++++--------------------
>>>>  1 file changed, 43 insertions(+), 43 deletions(-)
>>>>
>>>> diff --git a/drivers/staging/erofs/unzip_vle.c
>>> b/drivers/staging/erofs/unzip_vle.c
>>>> index 79d3ba6..1ffeeaa 100644
>>>> --- a/drivers/staging/erofs/unzip_vle.c
>>>> +++ b/drivers/staging/erofs/unzip_vle.c
>>>> @@ -20,8 +20,8 @@ static struct kmem_cache *z_erofs_workgroup_cachep
>>> __read_mostly;
>>>>
>>>>  void z_erofs_exit_zip_subsystem(void)
>>>>  {
>>>> -     BUG_ON(z_erofs_workqueue == NULL);
>>>> -     BUG_ON(z_erofs_workgroup_cachep == NULL);
>>>> +     BUG_ON(!z_erofs_workqueue);
>>>> +     BUG_ON(!z_erofs_workgroup_cachep);
>>>
>>> Long-term, all of these BUG_ON need to be removed as they imply that the
>>> developer has no idea what went wrong and can not recover.  For
>>> something like this, we "know" these will be fine and odds are they can
>>> just be removed entirely.
>>>
>>>
>> Right, I'm watching how replace the BUG_ON with WARN_ON and check who call
>> this functions
> 
> No, why would WARN_ON be any better?  Systems run with "panic on warn"
> enabled and this would cause the machine to reboot.  Why are these
> things even being checked in the first place if they are impossible to
> hit?
> 
> If they really are impossible, remove the check.  If they are not, then
> properly handle the logic if they are true.

I will remove the above BUG_ON()s since it looks redundant.

> 
> Linus said the other day something like "programmers who use BUG_ON()
> don't know what their code does", and I agree.  They are a crutch that
> we need to fix up in the whole kernel, not just staging.

I agree the phrase "programmers who use BUG_ON() don't know what their code does".
and some potential race I think it cannot happen in principle, but I also want to check them
on runtime via beta users, that should be avoided case by case.

erofs has another CONFIG_EROFS_FS_DEBUG switch to make some on-disk
assertions aggressively in development/debug mode, if CONFIG_EROFS_FS_DEBUG is on,
DBG_BUGON will be a BUG_ON; otherwise, it also has error handling paths to deal with them properly.
I have no idea whether I'm doing the right thing or not... such switch can also be found in f2fs called "F2FS_CHECK_FS".

config F2FS_CHECK_FS
	bool "F2FS consistency checking feature"
	depends on F2FS_FS
	help
	  Enables BUG_ONs which check the filesystem consistency in runtime.

	  If you want to improve the performance, say N.

Could you kindly give me some suggestions? Thanks..


> 
>>>>       destroy_workqueue(z_erofs_workqueue);
>>>>       kmem_cache_destroy(z_erofs_workgroup_cachep);
>>>> @@ -39,7 +39,7 @@ static inline int init_unzip_workqueue(void)
>>>>               WQ_UNBOUND | WQ_HIGHPRI | WQ_CPU_INTENSIVE,
>>>>               onlinecpus + onlinecpus / 4);
>>>>
>>>> -     return z_erofs_workqueue != NULL ? 0 : -ENOMEM;
>>>> +     return z_erofs_workqueue ? 0 : -ENOMEM;
>>>
>>> I hate ?: notation that is not in a function parameter, any way you can
>>> just change this to:
>>>         if (z_erofs_workqueue)
>>>                 return 0;
>>>         return -ENOMEM;

OK, I will avoid these unnecessary ?: notations.

>>>
>>>
>> I will replace the ?: too
>>
>>
>>> Christian, this isn't your fault at all, I'm not rejecting this patch,
>>> just providing hints on what else you can do here :)
>>>
>>
>>
>> but (if I well understand) I will send a different patch for both fix,
>> right?
> 
> Yes, nothing wrong with this one that I could see.  I'll let the erofs
> maintainers review it first before applying it in a few days to my tree
These patches look good to me, and I will avoid this BUG_ON case by case as I promised to Al
before moving out the staging tree.

Thanks,
Gao Xiang


> 
> thanks,
> 
> greg k-h
> 
