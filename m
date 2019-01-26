From: yuchao0@huawei.com (Chao Yu)
Date: Sat, 26 Jan 2019 14:43:15 +0800
Subject: [PATCH v3 2/2] staging: erofs: complete POSIX ACL support
In-Reply-To: <20190126034829.11586-2-hsiangkao@aol.com>
References: <20190126034829.11586-1-hsiangkao@aol.com>
 <20190126034829.11586-2-hsiangkao@aol.com>
Message-ID: <6240fd8c-f575-5fb7-6a4c-7d6f59063527@huawei.com>

On 2019/1/26 11:48, Gao Xiang wrote:
> From: Gao Xiang <gaoxiang25 at huawei.com>
> 
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
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
> change log v3:
>  - kvmalloc -> erofs_kmalloc suggested by Chao;
>  - update SB_POSIXACL for the remount case as well;

Oh, correct, remount case, I missed that one.

It looks good to me now. :)

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
