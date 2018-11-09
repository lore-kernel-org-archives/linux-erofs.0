From: hsiangkao@aol.com (Gao Xiang)
Date: Sat, 10 Nov 2018 02:06:53 +0800
Subject: [PATCH] staging: erofs: select LZ4_DECOMPRESS to fix build error
In-Reply-To: <e2365d5f-aabb-a631-1338-1e32f8c9bea6@infradead.org>
References: <e2365d5f-aabb-a631-1338-1e32f8c9bea6@infradead.org>
Message-ID: <fcee5841-70cd-d961-8bff-834d0cb2da94@aol.com>

Hi Randy,

Thanks for taking time, I have sent a patch to Greg fixing this issue. :)
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/commit/?h=staging-testing&id=7962e63a2f4140631ad10d475d96193a3bc8ec2f

Thanks,
Gao Xiang

On 2018/11/10 1:58, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap at infradead.org>
> 
> EROFS Data Compression support uses LZ4 decompression, so it
> should select LZ4_DECOMPRESS to prevent this build error:
> 
> drivers/staging/erofs/unzip_vle_lz4.o: In function `z_erofs_unzip_lz4':
> drivers/staging/erofs/unzip_vle_lz4.c:18: undefined reference to `LZ4_decompress_safe_partial'
> 
> Signed-off-by: Randy Dunlap <rdunlap at infradead.org>
> Reported-by: kbuild test robot <lkp at intel.com>
