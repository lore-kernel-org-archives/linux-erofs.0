From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Wed, 1 Aug 2018 12:02:43 +0300
Subject: [PATCH 1/2] staging: erofs: add the missing break in
 z_erofs_map_blocks_iter
In-Reply-To: <1533105511-26197-1-git-send-email-gaoxiang25@huawei.com>
References: <1532915461-2512-1-git-send-email-gaoxiang25@huawei.com>
 <1533105511-26197-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <20180801090243.ah7lhj2h6hjtvn4a@mwanda>

On Wed, Aug 01, 2018@02:38:30PM +0800, Gao Xiang wrote:
> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
> index bd2d7a8..6d3ab31 100644
> --- a/drivers/staging/erofs/unzip_vle.c
> +++ b/drivers/staging/erofs/unzip_vle.c
> @@ -1596,10 +1596,10 @@ int z_erofs_map_blocks_iter(struct inode *inode,
>  	cluster_type = vle_cluster_type(di);
>  
>  	switch (cluster_type) {
> -	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
> +	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:	/* fallthrough */

This fallthrough comment is in the wrong place.  It should be at the end
where the break would have been.  Like this:

	switch (cluster_type) {
	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
		frob();
		frob();
		frob();
		/* fallthrough */
	case Z_EROFS_VLE_CLUSTER_TYPE_HEAD:
		frob();

regards,
dan carpenter
