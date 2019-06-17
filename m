From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 17 Jun 2019 21:45:09 +0800
Subject: [PATCH] staging: erofs: clean up initialization of pointer de
In-Reply-To: <20190617125529.28327-1-colin.king@canonical.com>
References: <20190617125529.28327-1-colin.king@canonical.com>
Message-ID: <470b93fd-ef5e-0019-b58d-8e38e7944e13@huawei.com>



On 2019/6/17 20:55, Colin King wrote:
> From: Colin Ian King <colin.king at canonical.com>
> 
> Currently pointer de is being initialized with a value that is
> never read and a few statements later de is being re-assigned. Clean
> this up by ininitialzing de and removing the re-assignment.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king at canonical.com>

Loods good for me,

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang
