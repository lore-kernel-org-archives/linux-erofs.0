From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 22 Jul 2019 02:05:58 +0800
Subject: [PATCH v2 03/24] erofs: add super block operations
In-Reply-To: <7774f181-a41c-f30a-3b2a-02d7438d3509@huawei.com>
References: <20190711145755.33908-1-gaoxiang25@huawei.com>
 <20190711145755.33908-4-gaoxiang25@huawei.com>
 <20190720224955.GD17978@ZenIV.linux.org.uk>
 <161cffc4-1d61-5dc6-45df-f1779ef03b0f@aol.com>
 <20190721040547.GF17978@ZenIV.linux.org.uk>
 <7774f181-a41c-f30a-3b2a-02d7438d3509@huawei.com>
Message-ID: <bb571231-c080-a219-8368-855ff10055b8@aol.com>


On 2019/7/21 ??????12:12, Gao Xiang wrote:
> 
> 
> On 2019/7/21 12:05, Al Viro wrote:
>> On Sun, Jul 21, 2019@11:08:42AM +0800, Gao Xiang wrote:
>>
>>> It is for debugging use as you said below, mainly for our internal
>>> testers whose jobs are
>>> to read kmsg logs and catch kernel problems. sb->s_id (device number)
>>> maybe not
>>> straight-forward for them compared with dev_name...
>>
>> Huh? ->s_id is something like "sdb7" - it's bdev_name(), not a device
>> number...
> 
> You are right. Forgive me, actually we use /dev/block/by-name/system
> to mount fs... we have to do some lookup if using sdbX instead.
> 
> 
>>
>>> The initial purpose of erofs_mount_private was to passing multi private
>>> data from erofs_mount
>>> to erofs_read_super, which was written before fs_contest was introduced.
>>
>> That has nothing to do with fs_context (well, other than fs_context conversions
>> affecting the code very close to that).
> 
> OK. That is fine.
> 
>>
>>> I agree with you, it seems better to just use s_id in community and
>>> delete erofs_mount_private stuffs...
>>> Yet I don't look into how to use new fs_context, could I keep using
>>> legacy mount interface and fix them all?
>>
>> Sure.
>>
>>> I guess if I don't misunderstand, that is another suggestion -- in
>>> short, leave all destructors to .kill_sb() and
>>> cleanup fill_super().
>>
>> Just be careful with that iput() there - AFAICS, if fs went live (i.e.
>> if ->s_root is non-NULL), you really need it done only from put_super();
>> OTOH, for the case of NULL ->s_root ->put_super() won't be called at all,
>> so in that case you need it directly in ->kill_sb().
> 
> I got it. I will do a quick try now :) But in case of introducing issues,
> I guess I need to do some fault injection by hand.....

I try to fix them in

https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/tree/fs/erofs/super.c?h=erofs-outofstaging

, including:

1) remove unneeded sbi->dev_name;

2) remove all destructors in fill_super()
349         /* get the root inode */
350         inode = erofs_iget(sb, ROOT_NID(sbi), true);
351         if (IS_ERR(inode))
352                 return PTR_ERR(inode);
353
354         if (unlikely(!S_ISDIR(inode->i_mode))) {
355                 errln("rootino(nid %llu) is not a directory(i_mode %o)",
356                       ROOT_NID(sbi), inode->i_mode);
357                 iput(inode);
358                 return -EINVAL;
359         }
360
361         sb->s_root = d_make_root(inode);
362         if (unlikely(!sb->s_root))
363                 return -ENOMEM;
364
365         erofs_shrinker_register(sb);
366 #ifdef EROFS_FS_HAS_MANAGED_CACHE
367         /* sb->s_umount is locked here, SB_BORN and SB_ACTIVE are not set */
368         mc = erofs_init_managed_cache(sb);
369         if (IS_ERR(mc))
370                 return PTR_ERR(mc);
371         sbi->managed_cache = mc;
372 #endif

...

385 /*
386  * could be triggered after deactivate_locked_super()
387  * is called, thus including umount and failed to initialize.
388  */
389 static void erofs_kill_sb(struct super_block *sb)
390 {
391         struct erofs_sb_info *sbi;
392
393         WARN_ON(sb->s_magic != EROFS_SUPER_MAGIC);
394         infoln("unmounting erofs for %s", sb->s_id);
395
396         kill_block_super(sb);
397
398         sbi = EROFS_SB(sb);
399         if (!sbi)
400                 return;
401         kfree(sbi);
402         sb->s_fs_info = NULL;
403 }
404
405 /* called when ->s_root is non-NULL */
406 static void erofs_put_super(struct super_block *sb)
407 {
408         struct erofs_sb_info *const sbi = EROFS_SB(sb);
409
410         DBG_BUGON(!sbi);
411
412 #ifdef EROFS_FS_HAS_MANAGED_CACHE
413         iput(sbi->managed_cache);
414         sbi->managed_cache = NULL;
415 #endif
416         erofs_shrinker_unregister(sb);
417 }

...

and I injected some faults on error paths and it seems fine...
Could you kindly check whether it makes sense? (if I understand all correctly....)

The whole patchset will be resent this morning (a few hours later), I have to sleep...


Thanks,
Gao Xiang
