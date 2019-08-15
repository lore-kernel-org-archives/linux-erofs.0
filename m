From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Thu, 15 Aug 2019 11:06:03 +0200
Subject: [PATCH v8 00/24] erofs: promote erofs from staging v8
In-Reply-To: <20190815044155.88483-1-gaoxiang25@huawei.com>
References: <20190815044155.88483-1-gaoxiang25@huawei.com>
Message-ID: <20190815090603.GD4938@kroah.com>

On Thu, Aug 15, 2019@12:41:31PM +0800, Gao Xiang wrote:
> [I strip the previous cover letter, the old one can be found in v6:
>  https://lore.kernel.org/r/20190802125347.166018-1-gaoxiang25 at huawei.com/]
> 
> We'd like to submit a formal moving patch applied to staging tree
> for 5.4, before that we'd like to hear if there are some ACKs,
> suggestions or NAKs, objections of EROFS. Therefore, we can improve
> it in this round or rethink about the whole thing.
> 
> As related materials mentioned [1] [2], the goal of EROFS is to
> save extra storage space with guaranteed end-to-end performance
> for read-only files, which has better performance over exist Linux
> compression filesystems based on fixed-sized output compression
> and inplace decompression. It even has better performance in
> a large compression ratio range compared with generic uncompressed
> filesystems with proper CPU-storage combinations. And we think this
> direction is correct and a dedicated kernel team is continuously /
> actively working on improving it, enough testers and beta / end
> users using it.
> 
> EROFS has been applied to almost all in-service HUAWEI smartphones
> (Yes, the number is still increasing by time) and it seems like
> a success. It can be used in more wider scenarios. We think it's
> useful for Linux / Android OS community and it's the time moving
> out of staging.
> 
> In order to get started, latest stable mkfs.erofs is available at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git -b dev
> 
> with README in the repository.
> 
> We are still tuning sequential read performance for ultra-fast
> speed NVME SSDs like Samsung 970PRO, but at least now you can
> try on your PC with some data with proper compression ratio,
> the latest Linux kernel, USB stick for convenience sake and
> a not very old-fashioned CPU. There are also benchmarks available
> in the above materials mentioned.
> 
> EROFS is a self-contained filesystem driver. Although there are
> still some TODOs to be more generic, we will actively keep on
> developping / tuning EROFS with the evolution of Linux kernel
> as the other in-kernel filesystems.
> 
> As I mentioned before in LSF/MM 2019, in the future, we'd like
> to generalize the decompression engine into a library for other
> fses to use after the whole system is mature like fscrypt.
> However, such metadata should be designed respectively for
> each fs, and synchronous metadata read cost will be larger
> than EROFS because of those ondisk limitation. Therefore EROFS
> is still a better choice for read-only scenarios.
> 
> EROFS is now ready for reviewing and moving, and the code is
> already cleaned up as shiny floors... Please kindly take some
> precious time, share your comments about EROFS and let us know
> your opinion about this. It's really important for us since
> generally speaking, we like to use Linux _in-tree_ stuffs rather
> than lack of supported out-of-tree / orphan stuffs as well.

I know everyone is busy, but given the length this has been in staging,
and the constant good progress toward cleaning it all up that has been
happening, I want to get this moved out of staging soon.

So, unless there are any objections, I'll take this patchset in a week
into my staging tree to move the filesystem into the "real" part of the
kernel.

thanks,

greg k-h
