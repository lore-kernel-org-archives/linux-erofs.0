From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 25 Feb 2019 23:07:19 +0800
Subject: [PATCH for-4.19 06/12] staging: erofs: fix race when the managed
 cache is enabled
In-Reply-To: <20190225150449.GD16015@kroah.com>
References: <20190220091854.19242-1-gaoxiang25@huawei.com>
 <20190220091854.19242-7-gaoxiang25@huawei.com>
 <20190225150449.GD16015@kroah.com>
Message-ID: <4efecbee-5e61-f8b4-a91a-3c14852bf574@huawei.com>



On 2019/2/25 23:04, Greg Kroah-Hartman wrote:
> On Wed, Feb 20, 2019@05:18:48PM +0800, Gao Xiang wrote:
>> commit 51232df5e4b268936beccde5248f312a316800be upstream.
>>
>> When the managed cache is enabled, the last reference count
>> of a workgroup must be used for its workstation.
>>
>> Otherwise, it could lead to incorrect (un)freezes in
>> the reclaim path, and it would be harmful.
>>
>> A typical race as follows:
>>
>> Thread 1 (In the reclaim path)  Thread 2
>> workgroup_freeze(grp, 1)                                refcnt = 1
>> ...
>> workgroup_unfreeze(grp, 1)                              refcnt = 1
>>                                 workgroup_get(grp)      refcnt = 2 (x)
>> workgroup_put(grp)                                      refcnt = 1 (x)
>>                                 ...unexpected behaviors
>>
>> * grp is detached but still used, which violates cache-managed
>>   freeze constraint.
>>
>> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh at linuxfoundation.org>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>>
>> Conflicts:
>> 	drivers/staging/erofs/utils.c
>> Updates:
>> 	include/linux/xarray.h:
>> 		add xa_untag_pointer,xa_tag_pointer,xa_pointer_tag
>> 		from upstream 3159f943aafd in order to reduce
>> 		conflicts.
> 
> No, sorry, I don't want to add xarray.h to 4.19.y, that's crazy.

Or can I define these xa_untag_pointer,xa_tag_pointer,xa_pointer_tag in
a erofs header internally? it is acceptable?

Thanks,
Gao Xiang

> 
> And even if we did, you do not slip it in as part of a different patch,
> it should come in as its own patch, with the same git commit id that it
> landed in 4.20 with.
> 
> Please fix this up...
> 
> greg k-h
> 
