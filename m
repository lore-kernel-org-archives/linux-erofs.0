From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Sat, 28 Jul 2018 09:25:48 +0200
Subject: [PATCH 00/25] staging: erofs: introduce erofs file system
In-Reply-To: <1532607728-103372-1-git-send-email-gaoxiang25@huawei.com>
References: <1527764767-22190-1-git-send-email-gaoxiang25@huawei.com>
 <1532607728-103372-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <20180728072548.GA1500@kroah.com>

On Thu, Jul 26, 2018@08:21:43PM +0800, Gao Xiang wrote:
> Hi,
> 
> This is actually the 2nd patchset of erofs file system,
> the original patchset can be found at
> 
> Link: https://marc.info/?l=linux-fsdevel&m=152776480425624
> 
> In order to keep up with the mainline linux-kernel changes and
> improve it in a more active and timely manner, we put forword
> this upstream proposal for linux-staging.
> 
> EROFS file system is a read-only file system with compression
> support designed for certain devices (especially embeded
> devices) with very limited physical memory and lots of memory
> consumers, such as Android devices. It aimes to provide
> a complete compression solution for such devices focuing
> on high performance and little extra memory overhead.
> 
> It is perferred to select larger compressed cluster sizes
> (generally >= 128k) for traditional compression file systems.
> It reads and decompresses a large compressed cluster at once,
> which has a good-looking random read number when memory
> is sufficient because all historial decompressed data
> is expected to be cached in memory. However, it also
> induces destructive effects when such devices have no enough
> spare memory for caching and decompression.
> 
> EROFS file system acts in some different way. It uses
> fixed-sized compressed size rather than fixed-sized input
> size, namely VLE (variable-length extent) compression,
> which has at least three adventages:
> 
>  1) all data read from block device at once can be
>     utilized, and read amplification can be easier to
>     estimate and control;
>  2) generally, it has a better compression ratio than
>     fixed-sized input compression approaches configured
>     with the same size;
>  3) aggressively optimized paths such as partial page
>     read can be implemented to gain better performance
>     for page-unaligned read (unimplemented yet, in TODO list).
> 
> As can be seen, VLE compression does a great job in small
> compressed cluster sizes, which is of course suitable for
> devices with limited memory. In this patchset, an in-place
> decompresion is also introduced to minimize extra memory usage.
> 
> 
> Apart from compression, EROFS also has the following features
> available and some limits:
>  o page-sized block support (currently, and no buffer-head);
>  o 32-bit block address (16TB for 4KB block);
>  o selectable v1 (32 bytes) / v2 (64 bytes) inode;
>  o 32-bit / 64-bit file size;
>  o 64-bit node number for addressing inodes;
>  o 64-bit s and 32-bit ns timestamps;
>  o inline data support;
>  o inline and shared xattr support;
>  o metadata and data can be mixed (optional);
>  o special inode support;
>  o posix acl support.
> 
> 
> The file system is still actively WIP, see _TODO_ for more details.
> 
> Any comments are welcome. :)

Thanks for submitting this, the filesystem looks very interesting.  I've
queued it all up now in the staging-next tree.

greg k-h
