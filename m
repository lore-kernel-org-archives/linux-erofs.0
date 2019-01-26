From: hsiangkao@aol.com (Gao Xiang)
Date: Sat, 26 Jan 2019 11:06:07 +0800
Subject: [PATCH v2 2/2] staging: erofs: complete POSIX ACL support
In-Reply-To: <94daa491-40c8-4a09-a0b5-55a7e92dc3fc@huawei.com>
References: <20190125161007.4447-1-gaoxiang25@huawei.com>
 <20190125161007.4447-2-gaoxiang25@huawei.com>
 <94daa491-40c8-4a09-a0b5-55a7e92dc3fc@huawei.com>
Message-ID: <531700c1-31b4-1a9d-d3f8-4ca4e85bfdff@aol.com>

Hi Chao,

On 2019/1/26 10:48, Chao Yu wrote:
> On 2019/1/26 0:10, Gao Xiang wrote:
>> Let's add .get_acl() to read the file's acl from its xattrs
>> to make POSIX ACL usable.
>>
>> Here is the on-disk detail,
>> fullname: system.posix_acl_access
>> struct erofs_xattr_entry:
>>         .e_name_len = 0
>>         .e_name_index = EROFS_XATTR_INDEX_POSIX_ACL_ACCESS (2)
>>
>> fullname: system.posix_acl_default
>> struct erofs_xattr_entry:
>> 	.e_name_len = 0
>> 	.e_name_index = EROFS_XATTR_INDEX_POSIX_ACL_DEFAULT (3)
>>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>> ---
>> change log v2:
>>  - add the missing SB_POSIXACL flag;
>>  - fix the on-disk detail, use .e_name_len == 0 and proper prefix value;
>>  - tested ok with xattr enabled erofs_mkfs;
>>
>>  .../erofs/Documentation/filesystems/erofs.txt      |  2 ++
>>  drivers/staging/erofs/inode.c                      |  3 ++
>>  drivers/staging/erofs/namei.c                      |  1 +
>>  drivers/staging/erofs/super.c                      |  8 +++++
>>  drivers/staging/erofs/xattr.c                      | 37 ++++++++++++++++++++++
>>  drivers/staging/erofs/xattr.h                      |  6 ++++
>>  6 files changed, 57 insertions(+)
>>
>> diff --git a/drivers/staging/erofs/Documentation/filesystems/erofs.txt b/drivers/staging/erofs/Documentation/filesystems/erofs.txt
>> index 803988d74c21..961ec4da7705 100644
>> --- a/drivers/staging/erofs/Documentation/filesystems/erofs.txt
>> +++ b/drivers/staging/erofs/Documentation/filesystems/erofs.txt
>> @@ -36,6 +36,8 @@ Here is the main features of EROFS:
>>  
>>   - Support xattr inline and tail-end data inline for all files;
>>  
>> + - Support POSIX.1e ACLs by using xattrs;
>> +
>>   - Support transparent file compression as an option:
>>     LZ4 algorithm with 4 KB fixed-output compression for high performance;
>>  
>> diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
>> index 4f04f7c38cf2..924b8dfc7a8f 100644
>> --- a/drivers/staging/erofs/inode.c
>> +++ b/drivers/staging/erofs/inode.c
>> @@ -287,6 +287,7 @@ const struct inode_operations erofs_generic_iops = {
>>  #ifdef CONFIG_EROFS_FS_XATTR
>>  	.listxattr = erofs_listxattr,
>>  #endif
>> +	.get_acl = erofs_get_acl,
>>  };
>>  
>>  const struct inode_operations erofs_symlink_iops = {
>> @@ -294,6 +295,7 @@ const struct inode_operations erofs_symlink_iops = {
>>  #ifdef CONFIG_EROFS_FS_XATTR
>>  	.listxattr = erofs_listxattr,
>>  #endif
>> +	.get_acl = erofs_get_acl,
>>  };
>>  
>>  const struct inode_operations erofs_fast_symlink_iops = {
>> @@ -301,5 +303,6 @@ const struct inode_operations erofs_fast_symlink_iops = {
>>  #ifdef CONFIG_EROFS_FS_XATTR
>>  	.listxattr = erofs_listxattr,
>>  #endif
>> +	.get_acl = erofs_get_acl,
>>  };
>>  
>> diff --git a/drivers/staging/erofs/namei.c b/drivers/staging/erofs/namei.c
>> index 7fed1f996ab0..b1752adc5934 100644
>> --- a/drivers/staging/erofs/namei.c
>> +++ b/drivers/staging/erofs/namei.c
>> @@ -238,5 +238,6 @@ const struct inode_operations erofs_dir_iops = {
>>  #ifdef CONFIG_EROFS_FS_XATTR
>>  	.listxattr = erofs_listxattr,
>>  #endif
>> +	.get_acl = erofs_get_acl,
>>  };
>>  
>> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
>> index 176fca2af379..54cd7dac0a1f 100644
>> --- a/drivers/staging/erofs/super.c
>> +++ b/drivers/staging/erofs/super.c
>> @@ -398,6 +398,14 @@ static int erofs_read_super(struct super_block *sb,
>>  	if (!silent)
>>  		infoln("root inode @ nid %llu", ROOT_NID(sbi));
>>  
>> +#ifdef CONFIG_EROFS_FS_POSIX_ACL
>> +	/* Update the POSIXACL Flag */
>> +	if (test_opt(sbi, POSIX_ACL))
>> +		sb->s_flags |= SB_POSIXACL;
>> +	else
>> +		sb->s_flags &= ~SB_POSIXACL;
>> +#endif
>> +
>>  #ifdef CONFIG_EROFS_FS_ZIP
>>  	INIT_RADIX_TREE(&sbi->workstn_tree, GFP_ATOMIC);
>>  #endif
>> diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
>> index 7de46690d972..6759485ae862 100644
>> --- a/drivers/staging/erofs/xattr.c
>> +++ b/drivers/staging/erofs/xattr.c
>> @@ -643,3 +643,40 @@ ssize_t erofs_listxattr(struct dentry *dentry,
>>  	return shared_listxattr(&it);
>>  }
>>  
>> +#ifdef CONFIG_EROFS_FS_POSIX_ACL
>> +struct posix_acl *erofs_get_acl(struct inode *inode, int type)
>> +{
>> +	struct posix_acl *acl;
>> +	int ea_prefix, rc;
>> +	char *value = NULL;
>> +
>> +	switch(type) {
>> +	case ACL_TYPE_ACCESS:
>> +		ea_prefix = EROFS_XATTR_INDEX_POSIX_ACL_ACCESS;
>> +		break;
>> +	case ACL_TYPE_DEFAULT:
>> +		ea_prefix = EROFS_XATTR_INDEX_POSIX_ACL_DEFAULT;
>> +		break;
>> +	default:
>> +		return ERR_PTR(-EINVAL);
>> +	}
>> +
>> +	rc = erofs_getxattr(inode, ea_prefix, "", NULL, 0);
>> +	if (rc > 0) {
>> +		value = kvmalloc(rc, GFP_KERNEL);
> 
> erofs_kmalloc() is enough?

I think kmalloc is enough for this case, but I think kvmalloc is not
bad as well.

Actually I want to introduce erofs_kvmalloc() in the later patch and
use it in general except for the context which is unsuitable for vmalloc..

Let me send v3 if it is unnecessary...

Thanks,
Gao Xiang

> 
> Thanks,
> 
>> +		if (!value)
>> +			return ERR_PTR(-ENOMEM);
>> +		rc = erofs_getxattr(inode, ea_prefix, "", value, rc);
>> +	}
>> +
>> +	if (rc == -ENOATTR)
>> +		acl = NULL;
>> +	else if (rc < 0)
>> +		acl = ERR_PTR(rc);
>> +	else
>> +		acl = posix_acl_from_xattr(&init_user_ns, value, rc);
>> +	kvfree(value);
>> +	return acl;
>> +}
>> +#endif
>> +
>> diff --git a/drivers/staging/erofs/xattr.h b/drivers/staging/erofs/xattr.h
>> index 634dae9aaa0b..35ba5ac2139a 100644
>> --- a/drivers/staging/erofs/xattr.h
>> +++ b/drivers/staging/erofs/xattr.h
>> @@ -87,5 +87,11 @@ static ssize_t __maybe_unused erofs_listxattr(struct dentry *dentry,
>>  }
>>  #endif
>>  
>> +#ifdef CONFIG_EROFS_FS_POSIX_ACL
>> +struct posix_acl *erofs_get_acl(struct inode *inode, int type);
>> +#else
>> +#define erofs_get_acl	(NULL)
>> +#endif
>> +
>>  #endif
>>  
>>
> 
