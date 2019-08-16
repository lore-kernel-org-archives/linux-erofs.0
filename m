From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 16 Aug 2019 15:25:33 +0800
Subject: [PATCH] staging: erofs: use common file type conversion
In-Reply-To: <20190816071142.8633-1-gaoxiang25@huawei.com>
References: <20190816071142.8633-1-gaoxiang25@huawei.com>
Message-ID: <bb4b3b82-18d4-fbd5-47ab-be13de148c39@huawei.com>

On 2019/8/16 15:11, Gao Xiang wrote:
> Deduplicate the EROFS file type conversion implementation and
> remove EROFS_FT_* definitions since it's the same as defined
> by POSIX, let's follow ext2 as Linus pointed out [1]
> commit e10892189428 ("ext2: use common file type conversion").
> 
> [1] https://lore.kernel.org/r/CAHk-=wiUs+b=iVKM3mVooXgVk7cmmC67KTmnAuL0cd_cMMVAKw at mail.gmail.com/
> 
> Reported-by: Linus Torvalds <torvalds at linux-foundation.org>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
