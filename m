From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 20 May 2019 10:19:24 +0800
Subject: [PATCH v2] staging: erofs: fix Warning Use BUG_ON instead of if
 condition followed by BUG
In-Reply-To: <20190519093557.20982-1-hsiangkao@aol.com>
References: <20190518173331.GA1069@hari-Inspiron-1545>
 <20190519093557.20982-1-hsiangkao@aol.com>
Message-ID: <fbda7165-1276-1fca-0206-de603d48b309@huawei.com>

On 2019/5/19 17:35, Gao Xiang wrote:
> From: Hariprasad Kelam <hariprasad.kelam at gmail.com>
> 
> fix below warning reported by  coccicheck
> 
> drivers/staging/erofs/unzip_pagevec.h:74:2-5: WARNING: Use BUG_ON
> instead of if condition followed by BUG.
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam at gmail.com>
> [ Gao Xiang: use DBG_BUGON instead of BUG_ON for eng version only. ]
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
