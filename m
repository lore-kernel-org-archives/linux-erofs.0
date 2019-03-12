From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 12 Mar 2019 13:35:09 +0800
Subject: [PATCH] staging: erofs: fix parenthesis alignment
In-Reply-To: <20190312041827.6176-1-julianmr97@gmail.com>
References: <20190312041827.6176-1-julianmr97@gmail.com>
Message-ID: <df0b465d-22d1-1356-f493-6c4910513781@huawei.com>



On 2019/3/12 12:18, Julian Merida wrote:
> -		err = z_erofs_vle_work_add_page(builder,
> -			newpage, Z_EROFS_PAGE_TYPE_EXCLUSIVE);
> +		err =
> +		z_erofs_vle_work_add_page(builder, newpage,
> +					  Z_EROFS_PAGE_TYPE_EXCLUSIVE);

Why not ?
		err = z_erofs_vle_work_add_page(builder, newpage,
						Z_EROFS_PAGE_TYPE_EXCLUSIVE);
