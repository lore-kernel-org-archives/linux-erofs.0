From: chao@kernel.org (Chao Yu)
Date: Sun, 19 Aug 2018 21:52:30 +0800
Subject: [PREVIEW] [PATCH v2 10/10] staging: erofs: complete error handing
 of z_erofs_do_read_page
In-Reply-To: <1533931838-47642-10-git-send-email-gaoxiang25@huawei.com>
References: <1533931838-47642-1-git-send-email-gaoxiang25@huawei.com>
 <1533931838-47642-10-git-send-email-gaoxiang25@huawei.com>
Message-ID: <ef58ee72-194b-3452-b083-6650fd6e83d4@kernel.org>

On 2018/8/11 4:10, Gao Xiang wrote:
> This patch completes error handing code of z_erofs_do_read_page.
> PG_error will be set when some read error happens, therefore
> z_erofs_onlinepage_endio will unlock this page without setting
> PG_uptodate.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
