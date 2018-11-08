From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 8 Nov 2018 14:18:15 +0800
Subject: [PATCH] staging: erofs: use the new LZ4_decompress_safe_partial()
In-Reply-To: <a3b6d2dc-43e3-ed30-a209-55523671a0b0@huawei.com>
References: <20181108040036.13671-1-gaoxiang25@huawei.com>
 <a3b6d2dc-43e3-ed30-a209-55523671a0b0@huawei.com>
Message-ID: <056249f9-e607-af3b-e73c-fbadf68aacfe@huawei.com>

Hi Chao,

On 2018/11/8 14:11, Chao Yu wrote:
> On 2018/11/8 12:00, Gao Xiang wrote:
>> LZ4_decompress_safe_partial() can now decode exactly the nb of bytes
>> requested after the upstreamed commit 2209fda323e2 ("lib/lz4: update LZ4
>> decompressor module"), remove the erofs hacked lz4 decompression code.
>>
>> A more cleaned compressor wrapper will be introduced in the subsequent
>> patches in order to prepare for supporting multiple compression algorithms.
>>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>> ---
>>
>> Hi Chao,
>>  Could you please kindly confirm (review) this before merging into the staging tree?
> 
> Looks good to me.
> 
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
>
Thanks for quickly confirming this :)

Thanks,
Gao Xiang

> Thanks,
> 
