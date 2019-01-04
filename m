From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 4 Jan 2019 09:21:12 +0800
Subject: [PREVIEW] [PATCH v2 1/3] staging: erofs: fix fast symlink w/o
 xattr when fs xattr is on
In-Reply-To: <20181229140143.23352-1-gaoxiang25@huawei.com>
References: <20181229140143.23352-1-gaoxiang25@huawei.com>
Message-ID: <96377bca-4646-1d4c-5616-c48e41f487fb@huawei.com>

On 2018/12/29 22:01, Gao Xiang wrote:
> Currently, this will hit a BUG_ON for these symlinks as follows:
> 
> - kernel message
> ------------[ cut here ]------------
> kernel BUG at drivers/staging/erofs/xattr.c:59!
> SMP PTI
> CPU: 1 PID: 1170 Comm: getllxattr Not tainted 4.20.0-rc6+ #92
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-2.fc27 04/01/2014
> RIP: 0010:init_inode_xattrs+0x22b/0x270
> Code: 48 0f 45 ea f0 ff 4d 34 74 0d 41 83 4c 24 e0 01 31 c0 e9 00 fe ff ff 48 89 ef e8 e0 31 9e ff eb e9 89 e8 e9 ef fd ff ff 0f 0$
>  <0f> 0b 48 89 ef e8 fb f6 9c ff 48 8b 45 08 a8 01 75 24 f0 ff 4d 34
> RSP: 0018:ffffa03ac026bdf8 EFLAGS: 00010246
> ------------[ cut here ]------------
> ...
> Call Trace:
>  erofs_listxattr+0x30/0x2c0
>  ? selinux_inode_listxattr+0x5a/0x80
>  ? kmem_cache_alloc+0x33/0x170
>  ? security_inode_listxattr+0x27/0x40
>  listxattr+0xaf/0xc0
>  path_listxattr+0x5a/0xa0
>  do_syscall_64+0x43/0xf0
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> ...
> ---[ end trace 3c24b49408dc0c72 ]---
> 
> Fix it by checking ->xattr_isize in init_inode_xattrs(),
> and it also fixes improper return value -ENOTSUPP
> (it should be -ENODATA if xattr is enabled) for those inodes.
> 
> Fixes: b17500a0fdba ("staging: erofs: introduce xattr & acl support")
> Reported-by: Li Guifu <bluce.liguifu at huawei.com>
> Tested-by: Li Guifu <bluce.liguifu at huawei.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
