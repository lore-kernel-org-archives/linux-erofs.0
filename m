From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Thu, 4 Jul 2019 15:50:02 +0200
Subject: [PATCH] erofs: promote erofs from staging
In-Reply-To: <20190704133413.43012-1-gaoxiang25@huawei.com>
References: <20190704133413.43012-1-gaoxiang25@huawei.com>
Message-ID: <20190704135002.GB13609@kroah.com>

On Thu, Jul 04, 2019@09:34:13PM +0800, Gao Xiang wrote:
> EROFS file system has been in Linux-staging for about a year.
> It has been proved to be stable enough to move out of staging
> by 10+ millions of HUAWEI Android mobile phones on the market
> from EMUI 9.0.1, and it was promoted as one of the key features
> of EMUI 9.1 [1], including P30(pro).
> 
> EROFS is a read-only file system designed to save extra storage
> space with guaranteed end-to-end performance by applying
> fixed-size output compression, inplace I/O and decompression
> inplace technologies [2] to Linux filesystem.
> 
> In our observation, EROFS is one of the fastest Linux compression
> filesystem using buffered I/O in the world. It will support
> direct I/O in the future if needed. EROFS even has better read
> performance in a large CR range compared with generic uncompressed
> file systems with proper CPU-storage combination, which is
> a reason why erofs can be landed to speed up mobile phone
> performance, and which can be probably used for other use cases
> such as LiveCD and Docker image as well.
> 
> Currently erofs supports 4k LZ4 fixed-size output compression
> since LZ4 is the fastest widely-used decompression solution in
> the world and 4k leads to unnoticable read amplification for
> the worst case. More compression algorithms and cluster sizes
> could be added later, which depends on the real requirement.
> 
> More informations about erofs itself are available at:
>  Documentation/filesystems/erofs.txt
>  https://kccncosschn19eng.sched.com/event/Nru2/erofs-an-introduction-and-our-smartphone-practice-xiang-gao-huawei
> 
> erofs-utils (mainly mkfs.erofs now) is available at
> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git
> 
> Preliminary iomap support has been pending in erofs mailing
> list by Chao Yu. The key issue is that current iomap doesn't
> support tail-end packing inline data yet, it should be
> resolved later.
> 
> Thanks to many contributors in the last year, the code is more
> clean and improved. We hope erofs can be used in wider use cases
> so let's promote erofs out of staging and enhance it more actively.
> 
> Share comments about erofs! We think erofs is useful to
> community as a part of Linux upstream :)

I don't know if this format is easy for the linux-fsdevel people to
review, it forces them to look at the in-kernel code, which makes it
hard to quote.

Perhaps just make a patch that adds the filesystem to the tree and after
it makes it through review, I can delete the staging version?  We've
been doing that for wifi drivers that move out of staging as it seems to
be a bit easier.

thanks,

greg k-h
