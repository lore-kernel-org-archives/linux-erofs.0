From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 11 Jun 2019 09:41:13 +0800
Subject: [PATCH] staging: erofs: make use of DBG_BUGON
In-Reply-To: <20190608094918.GA11605@hari-Inspiron-1545>
References: <20190608094918.GA11605@hari-Inspiron-1545>
Message-ID: <f35ac2bf-14e2-2fff-cb89-caca4f790298@huawei.com>

On 2019/6/8 17:49, Hariprasad Kelam wrote:
> DBG_BUGON is introduced and it could only crash when EROFS_FS_DEBUG
> (EROFS developping feature) is on.
> replace BUG_ON with DBG_BUGON.
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam at gmail.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
