From: hsiangkao@aol.com (Gao Xiang)
Date: Sun, 18 Aug 2019 08:04:12 +0800
Subject: [PATCH] erofs: move erofs out of staging
In-Reply-To: <20190817233843.GA16991@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20190817082313.21040-1-hsiangkao@aol.com>
 <1746679415.68815.1566076790942.JavaMail.zimbra@nod.at>
 <20190817220706.GA11443@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1163995781.68824.1566084358245.JavaMail.zimbra@nod.at>
 <20190817233843.GA16991@hsiangkao-HP-ZHAN-66-Pro-G1>
Message-ID: <20190818000408.GA20778@hsiangkao-HP-ZHAN-66-Pro-G1>

On Sun, Aug 18, 2019@07:38:47AM +0800, Gao Xiang wrote:
> Hi Richard,
> 
> On Sun, Aug 18, 2019@01:25:58AM +0200, Richard Weinberger wrote:

[]

> > 
> > While digging a little into the code I noticed that you have very few
> > checks of the on-disk data.
> > For example ->u.i_blkaddr. I gave it a try and created a
> > malformed filesystem where u.i_blkaddr is 0xdeadbeef, it causes the kernel
> > to loop forever around erofs_read_raw_page().
> 
> I don't fuzz all the on-disk fields for EROFS, I will do later..
> You can see many in-kernel filesystems are still hardening the related
> stuff. Anyway, I will dig into this field you mentioned recently, but
> I think it can be fixed easily later.

...I take a simple try with the following erofs-utils diff and
a directory containing enwik9 only, with the latest kernel (5.3-rc)
and command line is
mkfs/mkfs.erofs -d9 enwik9.img testdir.

diff --git a/lib/inode.c b/lib/inode.c
index 581f263..2540338 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -388,8 +388,7 @@ static bool erofs_bh_flush_write_inode(struct erofs_buffer_head *bh)
 			v1.i_u.compressed_blocks =
 				cpu_to_le32(inode->u.i_blocks);
 		else
-			v1.i_u.raw_blkaddr =
-				cpu_to_le32(inode->u.i_blkaddr);
+			v1.i_u.raw_blkaddr = 0xdeadbeef;
 		break;
 	}

I tested the corrupted image with looped device and real blockdevice
by dd, and it seems fine....
[36283.012381] erofs: initializing erofs 1.0
[36283.012510] erofs: successfully to initialize erofs
[36283.012975] erofs: read_super, device -> /dev/loop17
[36283.012976] erofs: options -> (null)
[36283.012983] erofs: root inode @ nid 36
[36283.012995] erofs: mounted on /dev/loop17 with opts: (null).
[36297.354090] attempt to access beyond end of device
[36297.354098] loop17: rw=0, want=29887428984, limit=1953128
[36297.354107] attempt to access beyond end of device
[36297.354109] loop17: rw=0, want=29887428480, limit=1953128
[36301.827234] attempt to access beyond end of device
[36301.827243] loop17: rw=0, want=29887428480, limit=1953128
[36371.426889] erofs: unmounted for /dev/loop17
[36518.156114] erofs: read_super, device -> /dev/nvme0n1p4
[36518.156115] erofs: options -> (null)
[36518.156260] erofs: root inode @ nid 36
[36518.156384] erofs: mounted on /dev/nvme0n1p4 with opts: (null).
[36522.818884] attempt to access beyond end of device
[36522.818889] nvme0n1p4: rw=0, want=29887428984, limit=62781440
[36522.818895] attempt to access beyond end of device
[36522.818896] nvme0n1p4: rw=0, want=29887428480, limit=62781440
[36524.072018] attempt to access beyond end of device
[36524.072028] nvme0n1p4: rw=0, want=29887428480, limit=62781440

Could you give me more hints how to reproduce that? and I will
dig into more maybe it needs more conditions...

Thanks,
Gao Xiang

> 
> Thanks,
> Gao Xiang 
> 
> > 
> > Thanks,
> > //richard
