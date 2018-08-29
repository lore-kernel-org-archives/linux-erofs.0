From: hsiangkao@aol.com (Gao Xiang)
Date: Wed, 29 Aug 2018 09:37:25 +0800
Subject: [PATCH] Revert "staging: erofs: disable compiling temporarile"
In-Reply-To: <20180829094403.3a3bf19b@canb.auug.org.au>
References: <1535427588-69630-1-git-send-email-gaoxiang25@huawei.com>
 <20180828054444.GA4453@kroah.com>
 <0c701b3c-5553-cf4c-c0b3-ad151b84662c@huawei.com>
 <f12ae5df-3130-f293-5863-3d9ff0802e92@huawei.com>
 <20180828130559.GA5427@kroah.com>
 <16974cb6-2eed-7c12-9e27-c65a32b81673@huawei.com>
 <20180829094403.3a3bf19b@canb.auug.org.au>
Message-ID: <2f9ffbd8-b6e8-f5df-fb5e-f08f0b739070@aol.com>


On 2018/8/29 7:44, Stephen Rothwell wrote:
> Unfortunately, those vfs changes are still in the vfs tree in
> linux-next and cause a build failure in the erofs code.  I have
> disabled the build of erofs again for today.

feel a bit loss after hear that... :'(

> 
> Dave, Al, it would be good if you could add a patch/revise the series
> that adds the necessary erofs changes.

Hi Dave, Al, could you please kindly fix EROFS in vfs tree if it is
convenient...

Here is my patches which were intended for 4.19 (they could be rewritten
if needed...)
https://lists.ozlabs.org/pipermail/linux-erofs/2018-July/000282.html
https://lists.ozlabs.org/pipermail/linux-erofs/2018-July/000284.html

Thanks in advance...

Thanks,
Gao Xiang
