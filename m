From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 21 Jun 2019 15:57:23 +0800
Subject: [PATCH v2 3/8] staging: erofs: move per-CPU buffers
 implementation to utils.c
In-Reply-To: <20190620160719.240682-4-gaoxiang25@huawei.com>
References: <20190620160719.240682-1-gaoxiang25@huawei.com>
 <20190620160719.240682-4-gaoxiang25@huawei.com>
Message-ID: <1d296b86-69e2-4888-2ac9-1d77f38ac3e3@huawei.com>

On 2019/6/21 0:07, Gao Xiang wrote:
> +static inline void *erofs_get_pcpubuf(unsigned int pagenr)
> +{
> +	return ERR_PTR(-ENOTSUPP);
> +}

[snip]

> +	percpu_data = erofs_get_pcpubuf(0);

If erofs_get_pcpubuf may return error once EROFS_PCPUBUF_NR_PAGES equals to
zero, we'd better to check the error number here.

Thanks,
