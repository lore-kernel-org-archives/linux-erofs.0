From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 3 Sep 2018 09:49:34 +0800
Subject: [PATCH 6/6] staging: erofs: fix 1 warning and 9 checks
In-Reply-To: <1535642042-5336-6-git-send-email-zemlyanoy@ispras.ru>
References: <1535642042-5336-1-git-send-email-zemlyanoy@ispras.ru>
 <1535642042-5336-6-git-send-email-zemlyanoy@ispras.ru>
Message-ID: <3c43c174-c805-32e2-ac8e-504604ef29ab@huawei.com>

On 2018/8/30 23:14, Pavel Zemlyanoy wrote:
> This patch does not change the logic, it only
> corrects the formatting and checkpatch checks by
> braces {} should be used on all arms of this statement,
> unbalanced braces around else statement and warning by
> braces {} are not necessary for any arm of this statement.
> 
> The patch fixes 9 checks of type:
> "Check: braces {} should be used on all arms of this statement";
> "Check: Unbalanced braces around else statement";
> 
> and 1 warning of type:
> "WARNING: braces {} are not necessary for any arm of this statement".
> 
> Signed-off-by: Pavel Zemlyanoy <zemlyanoy at ispras.ru>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
