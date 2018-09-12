From: sfr@canb.auug.org.au (Stephen Rothwell)
Date: Wed, 12 Sep 2018 17:34:04 +1000
Subject: [PATCH] Revert "staging: erofs: disable compiling temporarile"
In-Reply-To: <58dbf050-ac24-9d8a-bbf3-0e28e10149ff@huawei.com>
References: <1535427588-69630-1-git-send-email-gaoxiang25@huawei.com>
 <20180828054444.GA4453@kroah.com>
 <0c701b3c-5553-cf4c-c0b3-ad151b84662c@huawei.com>
 <f12ae5df-3130-f293-5863-3d9ff0802e92@huawei.com>
 <20180828130559.GA5427@kroah.com>
 <16974cb6-2eed-7c12-9e27-c65a32b81673@huawei.com>
 <20180829094403.3a3bf19b@canb.auug.org.au>
 <20180906092504.282d5f62@canb.auug.org.au>
 <58dbf050-ac24-9d8a-bbf3-0e28e10149ff@huawei.com>
Message-ID: <20180912173404.288ea2e5@canb.auug.org.au>

Hi Chao,

On Wed, 12 Sep 2018 15:19:16 +0800 Chao Yu <yuchao0@huawei.com> wrote:
>
> To make sure, did -next tree enable erofs compiling now?

Yes, from yesterday.

> Xiang has made two patches to fix integration issue with other vfs changes,
> and Greg and David have already picked them in their tree.
> 
> staging: erofs: rename superblock flags (MS_xyz -> SB_xyz)
> staging: erofs: update .mount and .remount_sb

I noticed, thanks.

-- 
Cheers,
Stephen Rothwell
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 488 bytes
Desc: OpenPGP digital signature
URL: <http://lists.ozlabs.org/pipermail/linux-erofs/attachments/20180912/18acb99c/attachment.sig>
