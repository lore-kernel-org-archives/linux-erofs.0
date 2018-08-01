From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Wed, 1 Aug 2018 14:36:20 +0300
Subject: [PATCH RESEND 1/2] staging: erofs: add the missing break in
 z_erofs_map_blocks_iter
In-Reply-To: <1533116214-70017-1-git-send-email-gaoxiang25@huawei.com>
References: <ea978a27-efd4-9d58-e4c0-f9d00420304f@huawei.com>
 <1533116214-70017-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <20180801113620.3ufakhg3z62q46mw@mwanda>

On Wed, Aug 01, 2018@05:36:54PM +0800, Gao Xiang wrote:
> This patch adds a missing break after adding the default case.
> 
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
> As pointed out by Dan Carpenter:
>  - fix the wrong place of fallthrough comments

Thanks.  Looks good.  Next time use [PATCH v2] instead of RESEND.  The
word RESEND basically means you are resending a patch exactly the same
as it was before.  You would only need to do that if we accidentally
deleted your first patch or whatever...

regards,
dan carpenter
