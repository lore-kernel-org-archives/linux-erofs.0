From: hsiangkao@aol.com (Gao Xiang)
Date: Wed, 7 Aug 2019 01:02:58 +0800
Subject: [PATCH RFC] erofs: move erofs out of staging
In-Reply-To: <20190807013423.02fd6990@canb.auug.org.au>
References: <20190806094925.228906-1-gaoxiang25@huawei.com>
 <20190807013423.02fd6990@canb.auug.org.au>
Message-ID: <20190806170252.GB29093@hsiangkao-HP-ZHAN-66-Pro-G1>

Hi Stephen,

On Wed, Aug 07, 2019@01:34:23AM +1000, Stephen Rothwell wrote:
> Hi Gao,
> 
> One small suggestion: just remove the file names from the comments at
> the top of the files rather than change them to reflect that they have
> moved.  We can usually tell the name of a file by its name :-)

Thanks for your reply :)

For this part, EROFS initially followed what ext4, f2fs, even fsverity do,
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/ext4/namei.c
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/f2fs/namei.c
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/tree/fs/verity/verify.c?h=fsverity

I think I can remove these filenames as you suggested in the next version.
I thought these are some common practice and there is no obvious right or
wrong of this kind of stuffs.

Thanks,
Gao Xiang


> 
> -- 
> Cheers,
> Stephen Rothwell
