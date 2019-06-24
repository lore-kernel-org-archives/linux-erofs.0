From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 24 Jun 2019 15:34:46 +0800
Subject: [PATCH v3 0/8] staging: erofs: decompression inplace approach
In-Reply-To: <20190624072258.28362-1-hsiangkao@aol.com>
References: <20190624072258.28362-1-hsiangkao@aol.com>
Message-ID: <b07bc3f7-e85e-896a-c8ae-4800ca6c9816@huawei.com>

On 2019/6/24 15:22, Gao Xiang wrote:
> This is patch v3 of erofs decompression inplace approach, which is sent
> out by my personal email since I'm out of office to attend Open Source
> Summit China 2019 these days. No major change from PATCH v2 since no
> noticeable issue raised from landing to our products till now, mainly
> as a response to Chao's suggestions.
> 
> See the bottom lines which are taken from RFC PATCH v1 and describe
> the principle of these technologies.
> 
> The series is based on the latest staging-next since all dependencies
> have already been merged.
> 
> changelog from v2:
>  - wrap up some offsets as marcos;
>  - add some error handling for erofs_get_pcpubuf();
>  - move some decompression inplace stuffes from PATCH 5 -> 6.

Thanks for the update, those all changes look good to me. :)

Thanks,
