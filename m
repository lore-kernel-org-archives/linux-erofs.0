From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 12 Mar 2019 13:33:24 +0800
Subject: [PATCH] staging: erofs: fix parenthesis alignment
In-Reply-To: <20190312041827.6176-1-julianmr97@gmail.com>
References: <20190312041827.6176-1-julianmr97@gmail.com>
Message-ID: <96d9a856-8517-1ec5-608d-cea2ace6d1c3@huawei.com>

Hi Julian,

On 2019/3/12 12:18, Julian Merida wrote:
>  static void __z_erofs_vle_work_release(struct z_erofs_vle_workgroup *grp,
> -	struct z_erofs_vle_work *work __maybe_unused)
> +				       struct z_erofs_vle_work
> +				       *work __maybe_unused)
>  {
>  	erofs_workgroup_put(&grp->obj);
>  }

probably the following be better?

static void
__z_erofs_vle_work_release(struct z_erofs_vle_workgroup *grp,
			   struct z_erofs_vle_work *work __maybe_unused)
{
	erofs_workgroup_put(&grp->obj);
}

could you please fix that?

Thanks,
Gao Xiang
