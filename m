From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Mon, 13 Aug 2018 15:03:24 +0300
Subject: [PATCH 6/8] staging: erofs: fix vle_decompressed_index_clusterofs
In-Reply-To: <20180812140150.13397-7-chao@kernel.org>
References: <20180812140150.13397-1-chao@kernel.org>
 <20180812140150.13397-7-chao@kernel.org>
Message-ID: <20180813120324.ibzrmftxji62ji6r@mwanda>

> -static inline unsigned
> -vle_compressed_index_clusterofs(unsigned clustersize,
> -	struct z_erofs_vle_decompressed_index *di)
> +static inline int
> +vle_decompressed_index_clusterofs(unsigned int *clusterofs,

Not related to your patch, but don't make functions inline.  Leave it to
the compiler to decide.

regards,
dan carpenter
