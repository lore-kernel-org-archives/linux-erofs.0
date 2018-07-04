From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 4 Jul 2018 22:09:16 +0800
Subject: [preview] erofs_mkfs GNU/Linux x86 binary release
Message-ID: <441cf883-63eb-39bd-0aa9-d1b979db1e44@huawei.com>

From: Li Guifu <liguifu2@huawei.com>

Considering the different erofs-mkfs open source progress compared
with kernel opensource development, we decide to release the latest
binary version of the x86 platform (including x86_64 and i386)
erofs_mkfs in advance.

The tar archive includes:
  - mkfs_erofs/mkfs.erofs.i386
        x86 32-bit binary version
  - mkfs_erofs/mkfs.erofs.x86_64
        x86 64-bit binary version

Besides, compression mode is only enabled with "-z" input argument now,
which means no compression by default.

If you encounter any bug, feel free to report it to us. :)

Thanks,

To: linux-erofs at lists.ozlabs.org
Cc: Chao Yu <yuchao0 at huawei.com>
Cc: Miao Xie <miaoxie at huawei.com>
Signed-off-by: Li Guifu <liguifu2 at huawei.com>

-------------- next part --------------
A non-text attachment was scrubbed...
Name: mkfs_erofs.tar.xz
Type: application/octet-stream
Size: 597916 bytes
Desc: not available
URL: <http://lists.ozlabs.org/pipermail/linux-erofs/attachments/20180704/ba41ad87/attachment.obj>
