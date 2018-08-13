From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Mon, 13 Aug 2018 15:25:54 +0300
Subject: [PATCH 3/8] staging: erofs: add error handling for xattr submodule
In-Reply-To: <c14184af-6378-fd96-3b9b-52c9a7da8463@huawei.com>
References: <20180812140150.13397-1-chao@kernel.org>
 <20180812140150.13397-4-chao@kernel.org>
 <20180813114725.kgoupvppcwsw2vyj@mwanda>
 <c14184af-6378-fd96-3b9b-52c9a7da8463@huawei.com>
Message-ID: <20180813122553.jlavb6inwz3qad6x@mwanda>

On Mon, Aug 13, 2018@08:17:27PM +0800, Gao Xiang wrote:
> > 	/* we assume that ofs is aligned with 4 bytes */
> > 	it->ofs = EROFS_XATTR_ALIGN(it->ofs);
> > 	return err;
> > 

This might be cleaner if we wrote:

	return (err < 0) ? error : 0;

The callers all treate zero and one the same so there isn't any reason
to propogate the 1 back.

regards,
dan carpenter
