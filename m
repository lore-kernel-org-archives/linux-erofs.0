From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 31 Jul 2018 15:13:34 +0800
Subject: [FOR INTERNAL REVIEW] [PATCH 2/4] staging: erofs: fix
 superblock/inode flags (MS_RDONLY -> SB_RDONLY, S_NOATIME)
In-Reply-To: <1532942311-33785-2-git-send-email-gaoxiang25@huawei.com>
References: <1532942311-33785-1-git-send-email-gaoxiang25@huawei.com>
 <1532942311-33785-2-git-send-email-gaoxiang25@huawei.com>
Message-ID: <278acb38-66c8-1510-6fe4-9da4ef5aa39c@huawei.com>

On 2018/7/30 17:18, Gao Xiang wrote:
> After commit 0a43a939c77e ("vfs: Suppress MS_* flag defs within
> the kernel unless explicitly enabled"), there is no MS_RDONLY
> and MS_NOATIME at all.
> 
> Reported-by: Stephen Rothwell <sfr at canb.auug.org.au>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
