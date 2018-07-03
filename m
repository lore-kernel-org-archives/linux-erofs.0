From: chao@kernel.org (Chao Yu)
Date: Tue, 3 Jul 2018 21:48:19 +0800
Subject: [PATCH 08/11] erofs: support special inode
In-Reply-To: <10330ccf-3f96-b5dd-0de9-1aa986af47e6@huawei.com>
References: <20180622020131.65525-1-yuchao0@huawei.com>
 <20180622020131.65525-8-yuchao0@huawei.com>
 <10330ccf-3f96-b5dd-0de9-1aa986af47e6@huawei.com>
Message-ID: <c2d24dcc-3dbf-7c9d-ffda-dc9b3dbe7a1e@kernel.org>

Hi Xiang,

On 2018/7/3 13:31, Gao Xiang wrote:
> Hi Guifu and Chao,
> 
> On 2018/6/22 10:01, Chao Yu wrote:
>> This patch adds to support special inode, such as block dev, char,
>> socket, pipe inode.
>>
> 
> To Guifu,
> 
> Could you test this patch based on your latest _erofs_mkfs_ which supports special inodes?
> --- either for device files, named pipe files or socket files.
> 
> If this patch works fine, could you also reply with a "Tested-by:" tag?
> 
>> Signed-off-by: Chao Yu <yuchao0 at huawei.com>
>> ---
>>  fs/erofs/inode.c    | 33 +++++++++++++++++++++++++++++++--
>>  fs/erofs/internal.h |  1 +
>>  2 files changed, 32 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
>> index 94e827b57a5b..3dbce0cf41ff 100644
>> --- a/fs/erofs/inode.c
>> +++ b/fs/erofs/inode.c
>> @@ -30,8 +30,16 @@ static int read_inode(struct inode *inode, void *data)
>>  		vi->inode_isize = sizeof(struct erofs_inode_v2);
>>  		vi->xattr_isize = ondisk_xattr_ibody_size(v2->i_xattr_icount);
>>  
>> -		vi->raw_blkaddr = le32_to_cpu(v2->i_u.raw_blkaddr);
>>  		inode->i_mode = le16_to_cpu(v2->i_mode);
>> +		if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
>> +						S_ISLNK(inode->i_mode)) {
>> +			vi->raw_blkaddr = le32_to_cpu(v2->i_u.raw_blkaddr);
>> +		} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
>> +			inode->i_rdev =
>> +				new_decode_dev(le32_to_cpu(v2->i_u.rdev));
>> +		} else if (S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
>> +			inode->i_rdev = 0;
>> +		}
> To Chao,
> 
> It seems a default case missing here, and an error handling could be also added...

Yes, that's right, let me add it.

> 
> How about returning -EIO and furthermore
> BUG_ON if CONFIG_EROFS_FS_DEBUG is enabled as well ?
> (for commercial integrated test, it is hard to detect those error if just -EIO is returned.)
> 
>  18 config EROFS_FS_DEBUG
>  19         bool "EROFS debugging feature"
>  20         depends on EROFS_FS
>  21         help
>  22           Print erofs debugging messages and enable more BUG_ONs
>  23           which check the filesystem consistency aggressively.
>  24
>  25           For daily use, say N.
> 
> So will the rest error handling code, I think.
> How do you think?
> If you also agree with that, let's add them gradually in the future.

Yes, agree, that will be kind to erofs developers or testers to find bugs,
please go ahead. :)

> 
>>  
>>  		i_uid_write(inode, le32_to_cpu(v2->i_uid));
>>  		i_gid_write(inode, le32_to_cpu(v2->i_gid));
>> @@ -50,8 +58,16 @@ static int read_inode(struct inode *inode, void *data)
>>  		vi->inode_isize = sizeof(struct erofs_inode_v1);
>>  		vi->xattr_isize = ondisk_xattr_ibody_size(v1->i_xattr_icount);
>>  
>> -		vi->raw_blkaddr = le32_to_cpu(v1->i_u.raw_blkaddr);
>>  		inode->i_mode = le16_to_cpu(v1->i_mode);
>> +		if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
>> +						S_ISLNK(inode->i_mode)) {
>> +			vi->raw_blkaddr = le32_to_cpu(v1->i_u.raw_blkaddr);
>> +		} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
>> +			inode->i_rdev =
>> +				new_decode_dev(le32_to_cpu(v1->i_u.rdev));
>> +		} else if (S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
>> +			inode->i_rdev = 0;
>> +		}
> 
> ditto,

Right.

> 
> 
> The other code looks fine for me,
> I think a basic test is needed for the function of this patch tho.

Yeah, I hope Guifu will leave the time for testing the patch.

> 
> If you send out the next patch, you could add:
> Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks for the review.

Thanks,

> 
> Thanks,
> Gao Xiang
> 
>>  
>>  		i_uid_write(inode, le16_to_cpu(v1->i_uid));
>>  		i_gid_write(inode, le16_to_cpu(v1->i_gid));
>> @@ -168,6 +184,12 @@ int fill_inode(struct inode *inode, int isdir)
>>  				&page_symlink_inode_operations;
>>  #endif
>>  			inode_nohighmem(inode);
>> +		} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
>> +			S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
>> +#ifdef CONFIG_EROFS_FS_XATTR
>> +			inode->i_op = &erofs_special_inode_operations;
>> +#endif
>> +			init_special_inode(inode, inode->i_mode, inode->i_rdev);
>>  		} else {
>>  			err = -EIO;
>>  			goto out_unlock;
>> @@ -244,6 +266,13 @@ const struct inode_operations erofs_symlink_xattr_iops = {
>>  	.listxattr = erofs_listxattr,
>>  #endif
>>  };
>> +
>> +const struct inode_operations erofs_special_inode_operations = {
>> +#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 9, 0))
>> +		.listxattr = erofs_listxattr,
>> +#endif
>> +};
>> +
>>  #endif
>>  
>>  #if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 2, 0))
>> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
>> index 7670c2ed53d2..43620c07044d 100644
>> --- a/fs/erofs/internal.h
>> +++ b/fs/erofs/internal.h
>> @@ -364,6 +364,7 @@ extern const struct inode_operations simple_symlink_inode_operations;
>>  #ifdef CONFIG_EROFS_FS_XATTR
>>  extern const struct inode_operations erofs_symlink_xattr_iops;
>>  extern const struct inode_operations erofs_fast_symlink_xattr_iops;
>> +extern const struct inode_operations erofs_special_inode_operations;
>>  #endif
>>  
>>  static inline void set_inode_fast_symlink(struct inode *inode)
>>
