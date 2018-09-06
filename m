From: dhowells@redhat.com (David Howells)
Date: Thu, 06 Sep 2018 11:08:09 +0100
Subject: [PATCH 1/2 dhowells/mount-api] staging: erofs: rename superblock
 flags (MS_xyz -> SB_xyz)
In-Reply-To: <1536224508-66168-1-git-send-email-gaoxiang25@huawei.com>
References: <1536224508-66168-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <17402.1536228489@warthog.procyon.org.uk>

Gao Xiang <gaoxiang25@huawei.com> wrote:

> This patch follows commit 1751e8a6cb93 ("Rename superblock
> flags (MS_xyz -> SB_xyz)") and after commit ("vfs: Suppress
> MS_* flag defs within the kernel unless explicitly enabled"),
> there is no MS_RDONLY and MS_NOATIME at all.
> 
> Reported-by: Stephen Rothwell <sfr at canb.auug.org.au>
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

I recommend pushing this one to Linus now.  It's trivial enough.

Reviewed-by: David Howells <dhowells at redhat.com>
