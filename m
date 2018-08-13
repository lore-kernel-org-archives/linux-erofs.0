From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 13 Aug 2018 21:01:07 +0800
Subject: [PATCH 6/8] staging: erofs: fix vle_decompressed_index_clusterofs
In-Reply-To: <20180813120324.ibzrmftxji62ji6r@mwanda>
References: <20180812140150.13397-1-chao@kernel.org>
 <20180812140150.13397-7-chao@kernel.org>
 <20180813120324.ibzrmftxji62ji6r@mwanda>
Message-ID: <2b2e7678-b4c5-1b7a-0491-6bed02bfe119@huawei.com>

Hi Dan,

On 2018/8/13 20:03, Dan Carpenter wrote:
>> -static inline unsigned
>> -vle_compressed_index_clusterofs(unsigned clustersize,
>> -	struct z_erofs_vle_decompressed_index *di)
>> +static inline int
>> +vle_decompressed_index_clusterofs(unsigned int *clusterofs,
> 
> Not related to your patch, but don't make functions inline.  Leave it to
> the compiler to decide.

OK, thanks for your suggestion.

Thanks,
Gao Xiang

> 
> regards,
> dan carpenter
> 
> 
