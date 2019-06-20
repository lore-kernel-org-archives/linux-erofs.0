From: yuchao0@huawei.com (Chao Yu)
Date: Thu, 20 Jun 2019 16:54:06 +0800
Subject: [PATCH] staging: erofs: clean up initialization of pointer de
In-Reply-To: <20190617125529.28327-1-colin.king@canonical.com>
References: <20190617125529.28327-1-colin.king@canonical.com>
Message-ID: <63acf133-b0b5-aafa-6880-bb9517ef6be9@huawei.com>

On 2019/6/17 20:55, Colin King wrote:
> From: Colin Ian King <colin.king at canonical.com>
> 
> Currently pointer de is being initialized with a value that is
> never read and a few statements later de is being re-assigned. Clean
> this up by ininitialzing de and removing the re-assignment.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king at canonical.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
