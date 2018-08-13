From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 13 Aug 2018 21:19:16 +0800
Subject: [PATCH 4/8] staging: erofs: cleanup z_erofs_vle_work_{lookup,
 register}
In-Reply-To: <20180813130541.hzjgb6wznkxcnajg@mwanda>
References: <20180812140150.13397-1-chao@kernel.org>
 <20180812140150.13397-5-chao@kernel.org>
 <20180813120057.6grkpue6h7dtmpt2@mwanda>
 <f162748e-cc02-8578-2a0b-af16d982e0b3@huawei.com>
 <20180813130541.hzjgb6wznkxcnajg@mwanda>
Message-ID: <1b095571-ba5e-c85a-2e9b-285cb2b8448d@huawei.com>

Hi Dan,

On 2018/8/13 21:05, Dan Carpenter wrote:
> Yeah.  You'd have to remove the const.
> 
> Anyway, on looking at it more, I guess this patch is fine for now.  We
> will probably end up changing z_erofs_vle_work_lookup() and
> z_erofs_vle_work_register() some more in the future.
> 

Thanks for review, I personally tend to leave this patch unmodified for now :( .........

The struct is wrote in order to read-only or assign and read at once, and let compilers notice that
(all modifications are local so compilers can handle them safely)...

Thanks,
Gao Xiang

> regards,
> dan carpenter
> 
