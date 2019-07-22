From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 22 Jul 2019 18:58:59 +0800
Subject: [PATCH v3 23/24] erofs: introduce cached decompression
In-Reply-To: <20190722101818.GN20977@twin.jikos.cz>
References: <20190722025043.166344-1-gaoxiang25@huawei.com>
 <20190722025043.166344-24-gaoxiang25@huawei.com>
 <20190722101818.GN20977@twin.jikos.cz>
Message-ID: <41f1659a-0d16-4316-34fc-335b7d142d5c@aol.com>

Hi David,

On 2019/7/22 ????6:18, David Sterba wrote:
> On Mon, Jul 22, 2019@10:50:42AM +0800, Gao Xiang wrote:
>> +choice
>> +	prompt "EROFS Data Decompression mode"
>> +	depends on EROFS_FS_ZIP
>> +	default EROFS_FS_ZIP_CACHE_READAROUND
>> +	help
>> +	  EROFS supports three options for decompression.
>> +	  "In-place I/O Only" consumes the minimum memory
>> +	  with lowest random read.
>> +
>> +	  "Cached Decompression for readaround" consumes
>> +	  the maximum memory with highest random read.
>> +
>> +	  If unsure, select "Cached Decompression for readaround"
>> +
>> +config EROFS_FS_ZIP_CACHE_DISABLED
>> +	bool "In-place I/O Only"
>> +	help
>> +	  Read compressed data into page cache and do in-place
>> +	  I/O decompression directly.
>> +
>> +config EROFS_FS_ZIP_CACHE_READAHEAD
>> +	bool "Cached Decompression for readahead"
>> +	help
>> +	  For each request, it caches the last compressed page
>> +	  for further reading.
>> +	  It still does in-place I/O for the rest compressed pages.
>> +
>> +config EROFS_FS_ZIP_CACHE_READAROUND
>> +	bool "Cached Decompression for readaround"
>> +	help
>> +	  For each request, it caches the both end compressed pages
>> +	  for further reading.
>> +	  It still does in-place I/O for the rest compressed pages.
>> +
>> +	  Recommended for performance priority.
> 
> The number of individual Kconfig options is quite high, are you sure you
> need them to be split like that?

You mean the above? these are 3 cache strategies, which impact the
runtime memory consumption and performance. I tend to leave the above
as it-is...

> 
> Eg. the xattrs, acls and security labels seem to be part of the basic
> set of features so I wonder who does not want to enable them by default.
> I think you copied ext4 as a skeleton for the options, but for a new
> filesystem it's not necessary copy the history where I think features
> were added over time.

I have no idea... Okay, I will enable them by default.

> 
> Then eg. the option EROFS_FS_IO_MAX_RETRIES looks like a runtime
> setting, the config help text does not explain anything about the change
> in behaviour leaving the user with 'if not sure take the defaut'.

Agreed, you are right. EROFS_FS_IO_MAX_RETRIES is quite a runtime
setting. I will remove it in the next version (I think I will remove it
as the first step) or turn it to a mount option.

> 
> EROFS_FS_USE_VM_MAP_RAM is IMO a very low implementation detail, why
> does it need to be config option at all?

I'm not sure vm_map_ram() is always better than vmap() for all
platforms (it has noticeable performance impact). However that
seems true for my test machines (x86-64, arm64).

If vm_map_ram() is always the optimal choice compared with vmap(),
I will remove vmap() entirely, that is OK. But I am not sure for
every platforms though.

> 
> And so on. I'd suggest to go through all the options and reconsider them
> to be built-in, or runtime settings. Debugging features like the fault
> injections could be useful on non-debugging builds too, so a separate
> option is fine, otherwise grouping other debugging options under the
> main EROFS_FS_DEBUG would look more logical.

The remaining one is EROFS_FS_CLUSTER_PAGE_LIMIT. It impacts the total
size of z_erofs_pcluster structure. It's a hard limit, and should be
configured as small as possible. I can remove it right now since multi-block
compression is not available now. However, it will be added again after
multi-block compression is supported.

So, How about leave it right now and use the default value?

Thanks,
Gao Xiang
