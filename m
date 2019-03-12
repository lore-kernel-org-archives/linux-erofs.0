From: gregkh@linuxfoundation.org (gregkh@linuxfoundation.org)
Date: Tue, 12 Mar 2019 05:57:36 -0700
Subject: Patch "staging: erofs: fix memleak of inode's shared xattr array" has
 been added to the 4.19-stable tree
In-Reply-To: <20190311060858.28654-3-gaoxiang25@huawei.com>
Message-ID: <1552395456111117@kroah.com>


This is a note to let you know that I've just added the patch titled

    staging: erofs: fix memleak of inode's shared xattr array

to the 4.19-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     staging-erofs-fix-memleak-of-inode-s-shared-xattr-array.patch
and it can be found in the queue-4.19 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable at vger.kernel.org> know about it.


>From foo at baz Tue Mar 12 05:46:41 PDT 2019
From: Gao Xiang <gaoxiang25@huawei.com>
Date: Mon, 11 Mar 2019 14:08:56 +0800
Subject: staging: erofs: fix memleak of inode's shared xattr array
To: <stable at vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh at linuxfoundation.org>, LKML <linux-kernel at vger.kernel.org>, <linux-erofs at lists.ozlabs.org>, Chao Yu <yuchao0 at huawei.com>, Chao Yu <chao at kernel.org>, Miao Xie <miaoxie at huawei.com>, Fang Wei <fangwei1 at huawei.com>, Sheng Yong <shengyong1 at huawei.com>, Gao Xiang <gaoxiang25 at huawei.com>
Message-ID: <20190311060858.28654-3-gaoxiang25 at huawei.com>

From: Gao Xiang <gaoxiang25@huawei.com>

From: Sheng Yong <shengyong1@huawei.com>

commit 3b1b5291f79d040d549d7c746669fc30e8045b9b upstream.

If it fails to read a shared xattr page, the inode's shared xattr array
is not freed. The next time the inode's xattr is accessed, the previously
allocated array is leaked.

Signed-off-by: Sheng Yong <shengyong1 at huawei.com>
Fixes: b17500a0fdba ("staging: erofs: introduce xattr & acl support")
Cc: <stable at vger.kernel.org> # 4.19+
Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh at linuxfoundation.org>
---
 drivers/staging/erofs/xattr.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/staging/erofs/xattr.c
+++ b/drivers/staging/erofs/xattr.c
@@ -109,8 +109,11 @@ static int init_inode_xattrs(struct inod
 
 			it.page = erofs_get_meta_page(inode->i_sb,
 				++it.blkaddr, S_ISDIR(inode->i_mode));
-			if (IS_ERR(it.page))
+			if (IS_ERR(it.page)) {
+				kfree(vi->xattr_shared_xattrs);
+				vi->xattr_shared_xattrs = NULL;
 				return PTR_ERR(it.page);
+			}
 
 			it.kaddr = kmap_atomic(it.page);
 			atomic_map = true;


Patches currently in stable-queue which might be from gaoxiang25 at huawei.com are

queue-4.19/staging-erofs-fix-fast-symlink-w-o-xattr-when-fs-xattr-is-on.patch
queue-4.19/staging-erofs-fix-race-of-initializing-xattrs-of-a-inode-at-the-same-time.patch
queue-4.19/staging-erofs-add-error-handling-for-xattr-submodule.patch
queue-4.19/staging-erofs-keep-corrupted-fs-from-crashing-kernel-in-erofs_namei.patch
queue-4.19/staging-erofs-fix-memleak-of-inode-s-shared-xattr-array.patch
