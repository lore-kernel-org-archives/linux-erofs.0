From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 3 Aug 2018 09:35:59 +0800
Subject: [PATCH v3] staging: erofs: disable compiling temporarile
In-Reply-To: <20180802173319.GB24125@kroah.com>
References: <20180802143455.9214-1-chao@kernel.org>
 <20180802173319.GB24125@kroah.com>
Message-ID: <4f4df005-b894-e64b-e7f0-a0415db56109@huawei.com>

On 2018/8/3 1:33, Greg KH wrote:
> On Thu, Aug 02, 2018@10:34:55PM +0800, Chao Yu wrote:
>> From: Chao Yu <yuchao0 at huawei.com>
>>
>> As Stephen Rothwell reported:
>>
>> "After merging the staging tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> drivers/staging/erofs/super.c: In function 'erofs_read_super':
>> drivers/staging/erofs/super.c:343:17: error: 'MS_RDONLY' undeclared (first use in this function); did you mean 'IS_RDONLY'?
>>   sb->s_flags |= MS_RDONLY | MS_NOATIME;
>>                  ^~~~~~~~~
>>                  IS_RDONLY
>> drivers/staging/erofs/super.c:343:17: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/staging/erofs/super.c:343:29: error: 'MS_NOATIME' undeclared (first use in this function); did you mean 'S_NOATIME'?
>>   sb->s_flags |= MS_RDONLY | MS_NOATIME;
>>                              ^~~~~~~~~~
>>                              S_NOATIME
>> drivers/staging/erofs/super.c: In function 'erofs_mount':
>> drivers/staging/erofs/super.c:501:10: warning: passing argument 5 of 'mount_bdev' makes integer from pointer without a cast [-Wint-conversion]
>>    &priv, erofs_fill_super);
>>           ^~~~~~~~~~~~~~~~
>> In file included from include/linux/buffer_head.h:12:0,
>>                  from drivers/staging/erofs/super.c:14:
>> include/linux/fs.h:2151:23: note: expected 'size_t {aka long unsigned int}' but argument is of type 'int (*)(struct super_block *, void *, int)'
>>  extern struct dentry *mount_bdev(struct file_system_type *fs_type,
>>                        ^~~~~~~~~~
>> drivers/staging/erofs/super.c:500:9: error: too few arguments to function 'mount_bdev'
>>   return mount_bdev(fs_type, flags, dev_name,
>>          ^~~~~~~~~~
>> In file included from include/linux/buffer_head.h:12:0,
>>                  from drivers/staging/erofs/super.c:14:
>> include/linux/fs.h:2151:23: note: declared here
>>  extern struct dentry *mount_bdev(struct file_system_type *fs_type,
>>                        ^~~~~~~~~~
>> drivers/staging/erofs/super.c: At top level:
>> drivers/staging/erofs/super.c:518:20: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
>>   .mount          = erofs_mount,
>>                     ^~~~~~~~~~~
>> drivers/staging/erofs/super.c:518:20: note: (near initialization for 'erofs_fs_type.mount')
>> drivers/staging/erofs/super.c: In function 'erofs_remount':
>> drivers/staging/erofs/super.c:630:12: error: 'MS_RDONLY' undeclared (first use in this function); did you mean 'IS_RDONLY'?
>>   *flags |= MS_RDONLY;
>>             ^~~~~~~~~
>>             IS_RDONLY
>> drivers/staging/erofs/super.c: At top level:
>> drivers/staging/erofs/super.c:640:16: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
>>   .remount_fs = erofs_remount,
>>                 ^~~~~~~~~~~~~
>>
>> Caused by various commits creating erofs in the staging tree interacting
>> with various commits redoing the mount infrastructure in the vfs tree.
>>
>> I have disabed CONFIG_EROFS_FS for now:"
>>
>> The reason of compiling error is:
>>
>> Since -next collects and merges developing patches including common vfs
>> stuff from multi-trees, but those patches didn't cover erofs, such as:
>>
>> ('vfs: Suppress MS_* flag defs within the kernel unless explicitly enabled")
>> https://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git/commit/?h=for-next&id=109b45090d7d3ce2797bb1ef7f70eead5bfe0ff3
>>
>> ("vfs: Require specification of size of mount data for internal mounts")
>> https://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git/commit/?h=for-next&id=0a191e4505a4f255e6513b49426213da69bf0e80
>>
>> Above vfs related patches has not been merged in staging tree, if we
>> submit those erofs patches to staging mailing list and after including
>> them in staging-{test,nexts} tree, it can easily cause compiling error.
>>
>> We worked out some patches to adjust those vfs change, but now we just
>> submit them to -next tree temporarily to avoid compiling error.
>>
>> For potentail conflict in between erofs and vfs changes in incoming
>> merge window, Stephen suggested that we can disable CONFIG_EROFS_FS
>> temporarily to pass merge window, and after that we can do restore by
>> reenabling CONFIG_EROFS_FS and applying those fixing patches. Also
>> Greg confirmed this solution.
>>
>> So, let's disable compiling erofs for a while.
>>
>> Suggested-by: Stephen Rothwell <sfr at canb.auug.org.au>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>> Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
>> Signed-off-by: Chao Yu <yuchao0 at huawei.com>
>> ---
>> v3: remain "depends on BLOCK".
>>  drivers/staging/erofs/Kconfig | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/staging/erofs/Kconfig b/drivers/staging/erofs/Kconfig
>> index 663b755bf2fb..b37d994aa687 100644
>> --- a/drivers/staging/erofs/Kconfig
>> +++ b/drivers/staging/erofs/Kconfig
>> @@ -3,6 +3,7 @@
>>  config EROFS_FS
>>  	tristate "EROFS filesystem support"
>>  	depends on BLOCK
>> +	depends on BROKEN
>>  	help
>>  	  EROFS(Enhanced Read-Only File System) is a lightweight
>>  	  read-only file system with modern designs (eg. page-sized
> 
> Sorry, I already took the first version in my tree.  Don't worry about

I can see it in staging tree, thanks for quickly applying.

> it for now you can fix this up after 4.19-rc1 is out when we enable the
> filesystem again.

OK, we will prepare for it.

Thanks,

> 
> thanks,
> 
> greg k-h
> 
> .
> 
