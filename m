From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 3 Sep 2018 09:47:49 +0800
Subject: [PATCH 1/6] staging: erofs: formatting fix in unzip_vle_lz4.c
In-Reply-To: <1535642042-5336-1-git-send-email-zemlyanoy@ispras.ru>
References: <1535642042-5336-1-git-send-email-zemlyanoy@ispras.ru>
Message-ID: <2ab6d363-1be6-d616-dd66-e81eea6bd31d@huawei.com>

On 2018/8/30 23:13, Pavel Zemlyanoy wrote:
> 
> This patch does not change the logic, it only
> corrects the formatting and checkpatch warnings by
> adding "int" to the unsigned type.
> 
> The patch fixes 11 warnings of the type:
> "WARNING: Prefer 'unsigned int' to bare use of 'unsigned'"
> 
> Signed-off-by: Pavel Zemlyanoy <zemlyanoy at ispras.ru>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
