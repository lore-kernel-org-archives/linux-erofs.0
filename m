From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 1 Oct 2018 00:22:43 +0800
Subject: [PREVIEW] [PATCH chao/erofs-dev 1/3] staging: erofs: harden inode
 lookup for 32-bit platforms
In-Reply-To: <1537501415-70936-1-git-send-email-gaoxiang25@huawei.com>
References: <1537501415-70936-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <a3d758de-cf1a-faf9-6df7-fc0f50bb0ae5@aol.com>

Hi Chao,

Could you help merge these patches into erofs-dev (rebased on the latest erofs-master)?
I need to fix several issues reported these days formally.

If you have time, could you also take some time review these patches?

Thanks,
Gao Xiang

On 2018/9/21 11:43, Gao Xiang wrote:
> This patch introduces inode hash function, test and set callbacks,
> and iget5_locked to find the right inode for 32-bit platforms.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
