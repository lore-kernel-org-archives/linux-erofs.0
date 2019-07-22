From: dsterba@suse.cz (David Sterba)
Date: Mon, 22 Jul 2019 12:18:18 +0200
Subject: [PATCH v3 23/24] erofs: introduce cached decompression
In-Reply-To: <20190722025043.166344-24-gaoxiang25@huawei.com>
References: <20190722025043.166344-1-gaoxiang25@huawei.com>
 <20190722025043.166344-24-gaoxiang25@huawei.com>
Message-ID: <20190722101818.GN20977@twin.jikos.cz>

On Mon, Jul 22, 2019@10:50:42AM +0800, Gao Xiang wrote:
> +choice
> +	prompt "EROFS Data Decompression mode"
> +	depends on EROFS_FS_ZIP
> +	default EROFS_FS_ZIP_CACHE_READAROUND
> +	help
> +	  EROFS supports three options for decompression.
> +	  "In-place I/O Only" consumes the minimum memory
> +	  with lowest random read.
> +
> +	  "Cached Decompression for readaround" consumes
> +	  the maximum memory with highest random read.
> +
> +	  If unsure, select "Cached Decompression for readaround"
> +
> +config EROFS_FS_ZIP_CACHE_DISABLED
> +	bool "In-place I/O Only"
> +	help
> +	  Read compressed data into page cache and do in-place
> +	  I/O decompression directly.
> +
> +config EROFS_FS_ZIP_CACHE_READAHEAD
> +	bool "Cached Decompression for readahead"
> +	help
> +	  For each request, it caches the last compressed page
> +	  for further reading.
> +	  It still does in-place I/O for the rest compressed pages.
> +
> +config EROFS_FS_ZIP_CACHE_READAROUND
> +	bool "Cached Decompression for readaround"
> +	help
> +	  For each request, it caches the both end compressed pages
> +	  for further reading.
> +	  It still does in-place I/O for the rest compressed pages.
> +
> +	  Recommended for performance priority.

The number of individual Kconfig options is quite high, are you sure you
need them to be split like that?

Eg. the xattrs, acls and security labels seem to be part of the basic
set of features so I wonder who does not want to enable them by default.
I think you copied ext4 as a skeleton for the options, but for a new
filesystem it's not necessary copy the history where I think features
were added over time.

Then eg. the option EROFS_FS_IO_MAX_RETRIES looks like a runtime
setting, the config help text does not explain anything about the change
in behaviour leaving the user with 'if not sure take the defaut'.

EROFS_FS_USE_VM_MAP_RAM is IMO a very low implementation detail, why
does it need to be config option at all?

And so on. I'd suggest to go through all the options and reconsider them
to be built-in, or runtime settings. Debugging features like the fault
injections could be useful on non-debugging builds too, so a separate
option is fine, otherwise grouping other debugging options under the
main EROFS_FS_DEBUG would look more logical.
