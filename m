From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 4 Jul 2019 18:31:33 +0800
Subject: [PATCH RESEND v3] staging: erofs: remove unsupported ->datamode
 check in fill_inline_data()
In-Reply-To: <20190704180207.0000374e.zbestahu@gmail.com>
References: <20190702025601.7976-1-zbestahu@gmail.com>
 <20190703162038.GA31307@kroah.com>
 <20190704095903.0000565e.zbestahu@gmail.com>
 <20190704052649.GA7454@kroah.com>
 <20190704180207.0000374e.zbestahu@gmail.com>
Message-ID: <fd781a85-10f9-9cbb-9e14-1757153bb9ff@huawei.com>



On 2019/7/4 18:02, Yue Hu wrote:
> On Thu, 4 Jul 2019 07:26:49 +0200
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
>> On Thu, Jul 04, 2019@09:59:03AM +0800, Yue Hu wrote:
>>> On Wed, 3 Jul 2019 18:20:38 +0200
>>> Greg KH <gregkh@linuxfoundation.org> wrote:
>>>   
>>>> On Tue, Jul 02, 2019 at 10:56:01AM +0800, Yue Hu wrote:  
>>>>> From: Yue Hu <huyue2 at yulong.com>
>>>>>
>>>>> Already check if ->datamode is supported in read_inode(), no need to check
>>>>> again in the next fill_inline_data() only called by fill_inode().
>>>>>
>>>>> Signed-off-by: Yue Hu <huyue2 at yulong.com>
>>>>> Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
>>>>> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
>>>>> ---
>>>>> no change
>>>>>
>>>>>  drivers/staging/erofs/inode.c | 2 --
>>>>>  1 file changed, 2 deletions(-)    
>>>>
>>>> This is already in my tree, right?  
>>>
>>> Seems not, i have received notes about other 2 patches below mergerd:
>>>
>>> ```note1
>>> This is a note to let you know that I've just added the patch titled
>>>
>>>     staging: erofs: don't check special inode layout
>>>
>>> to my staging git tree which can be found at
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
>>> in the staging-next branch.
>>> ```
>>>
>>> ```note2
>>> This is a note to let you know that I've just added the patch titled
>>>
>>>     staging: erofs: return the error value if fill_inline_data() fails
>>>
>>> to my staging git tree which can be found at
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
>>> in the staging-next branch.
>>> ```
>>>
>>> No this patch in below link checked:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/log/drivers/staging/erofs?h=staging-testing  
>>
>> Then if it is not present, it needs to be rebased as it does not apply.
>>
>> Please do so and resend it.
> 
> Hm, no need to resend since it's included in another patch below.
> 
> ec8c244 staging: erofs: add compacted ondisk compression indexes.

Yes, it seems it was modified by the following patch occasionally months ago.
https://lore.kernel.org/lkml/20190614181619.64905-2-gaoxiang25 at huawei.com/

Anyway, thanks for your patch. :)

Thanks,
Gao Xiang

> 
> Thanks.
> 
>>
>> thanks,
>>
>> greg k-h
> 
> _______________________________________________
> devel mailing list
> devel at linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
> 
