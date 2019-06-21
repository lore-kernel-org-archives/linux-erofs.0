From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 21 Jun 2019 16:32:31 +0800
Subject: [PATCH v2 3/8] staging: erofs: move per-CPU buffers
 implementation to utils.c
In-Reply-To: <1d296b86-69e2-4888-2ac9-1d77f38ac3e3@huawei.com>
References: <20190620160719.240682-1-gaoxiang25@huawei.com>
 <20190620160719.240682-4-gaoxiang25@huawei.com>
 <1d296b86-69e2-4888-2ac9-1d77f38ac3e3@huawei.com>
Message-ID: <abe96e3d-cda7-e71e-68b1-9669fe2f2241@huawei.com>

Hi Chao,

On 2019/6/21 15:57, Chao Yu wrote:
> On 2019/6/21 0:07, Gao Xiang wrote:
>> +static inline void *erofs_get_pcpubuf(unsigned int pagenr)
>> +{
>> +	return ERR_PTR(-ENOTSUPP);
>> +}
> 
> [snip]
> 
>> +	percpu_data = erofs_get_pcpubuf(0);
> 
> If erofs_get_pcpubuf may return error once EROFS_PCPUBUF_NR_PAGES equals to
> zero, we'd better to check the error number here.

decompressor.c will be built-in only when decompression is enabled
and if decompression is enabled EROFS_PCPUBUF_NR_PAGES is not zero.

But I think introducing some error handling logic is not bad as well.
Will fix in the next version.

Thanks,
Gao Xiang

> 
> Thanks,
> 
