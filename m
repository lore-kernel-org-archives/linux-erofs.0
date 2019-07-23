From: hsiangkao@aol.com (Gao Xiang)
Date: Tue, 23 Jul 2019 21:30:09 +0800
Subject: [PATCH v3 23/24] erofs: introduce cached decompression
In-Reply-To: <20190723123104.GB2868@twin.jikos.cz>
References: <20190722025043.166344-1-gaoxiang25@huawei.com>
 <20190722025043.166344-24-gaoxiang25@huawei.com>
 <20190722101818.GN20977@twin.jikos.cz>
 <41f1659a-0d16-4316-34fc-335b7d142d5c@aol.com>
 <20190723123104.GB2868@twin.jikos.cz>
Message-ID: <b623d1bc-7cb5-e466-10e1-bb3bfefcae10@aol.com>



On 2019/7/23 ????8:31, David Sterba wrote:
> On Mon, Jul 22, 2019@06:58:59PM +0800, Gao Xiang wrote:
>> On 2019/7/22 ????6:18, David Sterba wrote:
>>> On Mon, Jul 22, 2019@10:50:42AM +0800, Gao Xiang wrote:
>>>> +choice
>>>> +	prompt "EROFS Data Decompression mode"
>>>> +	depends on EROFS_FS_ZIP
>>>> +	default EROFS_FS_ZIP_CACHE_READAROUND
>>>> +	help
>>>> +	  EROFS supports three options for decompression.
>>>> +	  "In-place I/O Only" consumes the minimum memory
>>>> +	  with lowest random read.
>>>> +
>>>> +	  "Cached Decompression for readaround" consumes
>>>> +	  the maximum memory with highest random read.
>>>> +
>>>> +	  If unsure, select "Cached Decompression for readaround"
>>>> +
>>>> +config EROFS_FS_ZIP_CACHE_DISABLED
>>>> +	bool "In-place I/O Only"
>>>> +	help
>>>> +	  Read compressed data into page cache and do in-place
>>>> +	  I/O decompression directly.
>>>> +
>>>> +config EROFS_FS_ZIP_CACHE_READAHEAD
>>>> +	bool "Cached Decompression for readahead"
>>>> +	help
>>>> +	  For each request, it caches the last compressed page
>>>> +	  for further reading.
>>>> +	  It still does in-place I/O for the rest compressed pages.
>>>> +
>>>> +config EROFS_FS_ZIP_CACHE_READAROUND
>>>> +	bool "Cached Decompression for readaround"
>>>> +	help
>>>> +	  For each request, it caches the both end compressed pages
>>>> +	  for further reading.
>>>> +	  It still does in-place I/O for the rest compressed pages.
>>>> +
>>>> +	  Recommended for performance priority.
>>>
>>> The number of individual Kconfig options is quite high, are you sure you
>>> need them to be split like that?
>>
>> You mean the above? these are 3 cache strategies, which impact the
>> runtime memory consumption and performance. I tend to leave the above
>> as it-is...
> 
> No, I mean all Kconfig options, they're scattered over several patches,
> best seen in the checked out branch. The cache strategies are actually
> just one config option (choice).

I will change the cache strategy at runtime as Ted suggested.
The cost is actually that erofs will always need a managed_cache inode
even though users just use in-place IO for their products.

However, I notice that using separated Kconfig will make test harder,
so that it leads to more bugs, that is what I really care about.

Therefore I think making it at runtime is OK for me.

> 
>> I'm not sure vm_map_ram() is always better than vmap() for all
>> platforms (it has noticeable performance impact). However that
>> seems true for my test machines (x86-64, arm64).
>>
>> If vm_map_ram() is always the optimal choice compared with vmap(),
>> I will remove vmap() entirely, that is OK. But I am not sure for
>> every platforms though.
> 
> You can select the implementation by platform, I don't know what are the
> criteria like cpu type etc, but I expect it's something that can be
> determined at module load time. Eventually a module parameter can be the
> the way to set it.

OK, module parameter makes sense for me, and the overhead may be
unnoticeable. I think it is fine to me.

> 
>>> And so on. I'd suggest to go through all the options and reconsider them
>>> to be built-in, or runtime settings. Debugging features like the fault
>>> injections could be useful on non-debugging builds too, so a separate
>>> option is fine, otherwise grouping other debugging options under the
>>> main EROFS_FS_DEBUG would look more logical.
>>
>> The remaining one is EROFS_FS_CLUSTER_PAGE_LIMIT. It impacts the total
>> size of z_erofs_pcluster structure. It's a hard limit, and should be
>> configured as small as possible. I can remove it right now since multi-block
>> compression is not available now. However, it will be added again after
>> multi-block compression is supported.
>>
>> So, How about leave it right now and use the default value?
> 
> From the Kconfig and build-time settings perspective I think it's
> misplaced. This affects testing, you'd have to rebuild and reinstall the
> module to test any change, while it's "just" a number that can be either
> module parameter, sysfs knob, mount option or special ioctl.
> 
> But I may be wrong, EROFS is a special purpose filesystem, so the
> fine-grained build options might make sense (eg. due to smaller code).
> The question should be how does each option affect typical production
> build targets. Fewer is IMHO better.
I have to admit, EROFS still has some special stuffs now (since we still
have some TODO), However, I don't think EROFS cannot be effectively used
for many productive uses right now.

Considering that using linux-staging stuff is dangerous / unsuitable for
most of companies, out of staging is better...

And we still have to improve it to be more generic by time like what other fses do
(IMO, writing a generic compression fs is not hard, many fses are there.
I need to think more carefully in case of some performance loss which is out of
too straight-forward generic code)...

To be more specific, as for EROFS_FS_CLUSTER_PAGE_LIMIT...

In the long term, I can introduce "struct biovec_slab"-like to erofs as
in block/bio.c to support variable-sized z_erofs_pcluster.

In the short term, I think EROFS_FS_CLUSTER_PAGE_LIMIT can be better set to
the default value. It is a hard uplimit of the structure z_erofs_pcluster,
which will greatly impact the memory consumption...

Even if EROFS_FS_CLUSTER_PAGE_LIMIT is removed in the later Linux version
by introducing biovec_slab-like stuff, I think it will have little influence
to users? so I think that is a minor thing? Or I misunderstand something?

Thanks,
Gao Xiang
