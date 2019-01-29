From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Tue, 29 Jan 2019 11:43:20 +0300
Subject: [PATCH v4 2/2] staging: erofs: complete POSIX ACL support
In-Reply-To: <20190129083520.28607-2-gaoxiang25@huawei.com>
References: <20190129083520.28607-1-gaoxiang25@huawei.com>
 <20190129083520.28607-2-gaoxiang25@huawei.com>
Message-ID: <20190129084320.GN1795@kadam>

On Tue, Jan 29, 2019@04:35:20PM +0800, Gao Xiang wrote:
> Let's add .get_acl() to read the file's acl from its xattrs
> to make POSIX ACL usable.
> 
> Here is the on-disk detail,
> fullname: system.posix_acl_access
> struct erofs_xattr_entry:
>         .e_name_len = 0
>         .e_name_index = EROFS_XATTR_INDEX_POSIX_ACL_ACCESS (2)
> 
> fullname: system.posix_acl_default
> struct erofs_xattr_entry:
> 	.e_name_len = 0
> 	.e_name_index = EROFS_XATTR_INDEX_POSIX_ACL_DEFAULT (3)
> 
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
> change log v4:
>  - leave kmalloc and wait the conclusion of fault injection
>    pointed out by Dan Carpenter;

I do think this is the right thing, but I also wasn't going to ask you
do redo v3.  Anyway, thanks!

regards,
dan carpenter
