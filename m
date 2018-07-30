From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 30 Jul 2018 14:56:28 +0800
Subject: [FOR INTERNAL REVIEW] [PATCH RESEND 1/3] staging: erofs: fix
 incorrect code in erofs_shrink_scan
In-Reply-To: <1532921694-23526-1-git-send-email-gaoxiang25@huawei.com>
References: <5a396128-822f-5232-f3ee-1c5ac6524380@huawei.com>
 <1532921694-23526-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <b9c49e46-dcfb-d751-d45e-47e9ca87c317@huawei.com>

On 2018/7/30 11:34, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao at aol.com>
> 
> This patch actually fixes incorrect code snippets due to spilt code
> into small patches by mistake, which can cause a compile error without
> built-in decompression support and potential abnormal runtime shrinking.
> 
> Link: https://lists.01.org/pipermail/kbuild-all/2018-July/050747.html
> Link: https://lists.01.org/pipermail/kbuild-all/2018-July/050750.html
> Reported-by: kbuild test robot <lkp at intel.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
