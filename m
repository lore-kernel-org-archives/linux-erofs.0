From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 27 Jul 2018 09:39:54 +0800
Subject: [PATCH 00/25] staging: erofs: introduce erofs file system
In-Reply-To: <alpine.DEB.2.21.999.1807261707460.11672@trent.utfs.org>
References: <1527764767-22190-1-git-send-email-gaoxiang25@huawei.com>
 <1532607728-103372-1-git-send-email-gaoxiang25@huawei.com>
 <alpine.DEB.2.21.999.1807261707460.11672@trent.utfs.org>
Message-ID: <bcb9e620-f73b-4dbc-630b-af925c3d8ebd@huawei.com>

Hi Christian, 

On 2018/7/27 8:25, Christian Kujau wrote:
> On Thu, 26 Jul 2018, Gao Xiang wrote:
>> EROFS file system is a read-only file system with compression
>> support designed for certain devices (especially embeded
>> devices) with very limited physical memory and lots of memory
> Out of curiousity, and as Richard already asked[0] - what about existing 
> file system, why can't they be used or extended instead of introducing yet 
> another file system into the kernel? JFFS2? UBIFS? CramFs? SquashFS? 
> ROMFS? F2FS? YAFFS?
> 
> Christian.
> 

Every file system has its typical usage case.

I don't think there exists a silver bullet solving all usage cases optimally.
JFFS2, YAFFS and UBIFS are designed for raw flash, we use UFS or eMMC solution
rather than raw nand flash.

Cramfs and ROMFS are too simple for us, and it is actually useless because no
similar & duplicate code with EROFS.

We can save about 200MB+ metadata space than EXT4 by just using EROFS
_without_ compression support in our products, which could be more compared
with F2FS(F2FS has more useless metadata for read-only use such as SIT, and SSA).
Since we are a read-only file system, we could use aggressive inline(compact) and data
deduplication approach. It is not a small number storage space because we
leave some compression ratio for better performance in low memory scenario.

and I don't think SquashFS is optimal for us, 1) it doesn't have the inline
consideration by design (inline could save storage space also reduce extra data IOs),
2) it is designed for saving more storage space rather than keeping high performance
for limited physical memory scenario; 3) it has many compatible code for its historial
design, actually its on-disk layout design is hard to be extended considering its
historial images 4) It is not designed for VLE, we need to rewrite more than half of
its current code 5) EROFS has no similar code with the current SquashFS.

In the end, I don't think F2FS could be an expansion of NILFS2, BTRFS
is an b-tree expansion of some read-write file system. You could call EROFS
as ROMFS2 or Squashfs+ but EROFS is a completely different solution.
We need to evaluate the optimal file system for each specific usage case (actually
we think erofs almost reaches our requirements for our Android products rather
than SquashFS) and KISS for each solution.


Thanks for your reply :)

Thanks,
Gao Xiang

> [0] https://marc.info/?l=linux-kernel&m=152783930418348&w=2
