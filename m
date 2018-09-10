From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 11 Sep 2018 00:37:06 +0800
Subject: [PATCH] erofs: surround fault_injection ralted option parsing
 using CONFIG_EROFS_FAULT_INJECTION
In-Reply-To: <20180910155247.GA17537@kroah.com>
References: <20180910154551.28922-1-cgxu519@gmx.com>
 <20180910155247.GA17537@kroah.com>
Message-ID: <fb0cf408-153f-b8d1-3ddb-210f96880e6a@huawei.com>

Hi Greg,

On 2018/9/10 23:52, Greg KH wrote:
> On Mon, Sep 10, 2018@11:45:51PM +0800, Chengguang Xu wrote:
>> It's a little bit strange when fault_injection related
>> option fail with -EINVAL which was already disabled
>> from config, so surround all fault_injection related option
>> parsing code using CONFIG_EROFS_FAULT_INJECTION. Meanwhile,
>> slightly change warning message to keep consistency with
>> option POSIX_ACL and FS_XATTR.
>>
>> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
>> ---
>>  drivers/staging/erofs/super.c | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
>> index 1aec509c805f..4004a00d150d 100644
>> --- a/drivers/staging/erofs/super.c
>> +++ b/drivers/staging/erofs/super.c
>> @@ -237,16 +237,18 @@ static int parse_options(struct super_block *sb, char *options)
>>  			infoln("noacl options not supported");
>>  			break;
>>  #endif
>> +#ifdef CONFIG_EROFS_FAULT_INJECTION
>>  		case Opt_fault_injection:
>>  			if (args->from && match_int(args, &arg))
>>  				return -EINVAL;
>> -#ifdef CONFIG_EROFS_FAULT_INJECTION
>>  			erofs_build_fault_attr(EROFS_SB(sb), arg);
>>  			set_opt(EROFS_SB(sb), FAULT_INJECTION);
>> +			break;
>>  #else
>> -			infoln("FAULT_INJECTION was not selected");
>> -#endif
>> +		case Opt_fault_injection:
>> +			infoln("FAULT_INJECTION not supported");
>>  			break;
>> +#endif
> 
> Ugh, that's hard to read.  Why not just hide all of this crazyness
> behind a single function that handles the #ifdef mess, like it should
> be.  Then just always call handle_fault_injection() or whatever you want
> to call it.
> 
> That makes it easier to read and understand and maintain over time.
> 
> I'll take this for now, but that should be something you work on
> eventually.  For the other #ifdef options in here as well.

Yeah, I agree your point and it needs to be cleaned up. :) it is now ext2/f2fs-like uhh...

fs/ext2/super.c
...
 293 #ifdef CONFIG_EXT2_FS_XATTR
 294         if (test_opt(sb, XATTR_USER))
 295                 seq_puts(seq, ",user_xattr");
 296         if (!test_opt(sb, XATTR_USER) &&
 297             (def_mount_opts & EXT2_DEFM_XATTR_USER)) {
 298                 seq_puts(seq, ",nouser_xattr");
 299         }
 300 #endif
 301
 302 #ifdef CONFIG_EXT2_FS_POSIX_ACL
 303         if (test_opt(sb, POSIX_ACL))
 304                 seq_puts(seq, ",acl");
 305         if (!test_opt(sb, POSIX_ACL) && (def_mount_opts & EXT2_DEFM_ACL))
 306                 seq_puts(seq, ",noacl");
 307 #endif
 308
...

fs/f2fs/super.c
...
 441 #ifdef CONFIG_F2FS_FS_XATTR
 442                 case Opt_user_xattr:
 443                         set_opt(sbi, XATTR_USER);
 444                         break;
 445                 case Opt_nouser_xattr:
 446                         clear_opt(sbi, XATTR_USER);
 447                         break;
 448                 case Opt_inline_xattr:
 449                         set_opt(sbi, INLINE_XATTR);
 450                         break;
 451                 case Opt_noinline_xattr:
 452                         clear_opt(sbi, INLINE_XATTR);
 453                         break;
 454                 case Opt_inline_xattr_size:
 455                         if (args->from && match_int(args, &arg))
 456                                 return -EINVAL;
 457                         set_opt(sbi, INLINE_XATTR_SIZE);
 458                         F2FS_OPTION(sbi).inline_xattr_size = arg;
 459                         break;
 460 #else
 461                 case Opt_user_xattr:
 462                         f2fs_msg(sb, KERN_INFO,
 463                                 "user_xattr options not supported");
 464                         break;
 465                 case Opt_nouser_xattr:
 466                         f2fs_msg(sb, KERN_INFO,
 467                                 "nouser_xattr options not supported");
 468                         break;
 469                 case Opt_inline_xattr:
 470                         f2fs_msg(sb, KERN_INFO,
 471                                 "inline_xattr options not supported");
 472                         break;
 473                 case Opt_noinline_xattr:
 474                         f2fs_msg(sb, KERN_INFO,
 475                                 "noinline_xattr options not supported");
 476                         break;
 477 #endif
...

p.s. The fault injection code was taken from f2fs.

and I saw that Chengguang Xu submits a similar patch to f2fs-devel.
https://sourceforge.net/p/linux-f2fs/mailman/message/36412022/

In the future, it could use the common #include <linux/fault-inject.h>
like other modules I guess?

mm/slab_common.c
1555 int should_failslab(struct kmem_cache *s, gfp_t gfpflags)
1556 {
1557         if (__should_failslab(s, gfpflags))
1558                 return -ENOMEM;
1559         return 0;
1560 }
1561 ALLOW_ERROR_INJECTION(should_failslab, ERRNO);

mm/failslab.c
 17 bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags)
 18 {
 19         /* No fault-injection for bootstrap cache */
 20         if (unlikely(s == kmem_cache))
 21                 return false;
 22
 23         if (gfpflags & __GFP_NOFAIL)
 24                 return false;
 25
 26         if (failslab.ignore_gfp_reclaim && (gfpflags & __GFP_RECLAIM))
 27                 return false;
 28
 29         if (failslab.cache_filter && !(s->flags & SLAB_FAILSLAB))
 30                 return false;
 31
 32         return should_fail(&failslab.attr, s->object_size);
 33 }


Thanks,
Gao Xiang

> 
> thanks,
> 
> greg k-h
> 
