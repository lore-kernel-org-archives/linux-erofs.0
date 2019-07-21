From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sun, 21 Jul 2019 12:12:15 +0800
Subject: [PATCH v2 03/24] erofs: add super block operations
In-Reply-To: <20190721040547.GF17978@ZenIV.linux.org.uk>
References: <20190711145755.33908-1-gaoxiang25@huawei.com>
 <20190711145755.33908-4-gaoxiang25@huawei.com>
 <20190720224955.GD17978@ZenIV.linux.org.uk>
 <161cffc4-1d61-5dc6-45df-f1779ef03b0f@aol.com>
 <20190721040547.GF17978@ZenIV.linux.org.uk>
Message-ID: <7774f181-a41c-f30a-3b2a-02d7438d3509@huawei.com>



On 2019/7/21 12:05, Al Viro wrote:
> On Sun, Jul 21, 2019@11:08:42AM +0800, Gao Xiang wrote:
> 
>> It is for debugging use as you said below, mainly for our internal
>> testers whose jobs are
>> to read kmsg logs and catch kernel problems. sb->s_id (device number)
>> maybe not
>> straight-forward for them compared with dev_name...
> 
> Huh? ->s_id is something like "sdb7" - it's bdev_name(), not a device
> number...

You are right. Forgive me, actually we use /dev/block/by-name/system
to mount fs... we have to do some lookup if using sdbX instead.


> 
>> The initial purpose of erofs_mount_private was to passing multi private
>> data from erofs_mount
>> to erofs_read_super, which was written before fs_contest was introduced.
> 
> That has nothing to do with fs_context (well, other than fs_context conversions
> affecting the code very close to that).

OK. That is fine.

> 
>> I agree with you, it seems better to just use s_id in community and
>> delete erofs_mount_private stuffs...
>> Yet I don't look into how to use new fs_context, could I keep using
>> legacy mount interface and fix them all?
> 
> Sure.
> 
>> I guess if I don't misunderstand, that is another suggestion -- in
>> short, leave all destructors to .kill_sb() and
>> cleanup fill_super().
> 
> Just be careful with that iput() there - AFAICS, if fs went live (i.e.
> if ->s_root is non-NULL), you really need it done only from put_super();
> OTOH, for the case of NULL ->s_root ->put_super() won't be called at all,
> so in that case you need it directly in ->kill_sb().

I got it. I will do a quick try now :) But in case of introducing issues,
I guess I need to do some fault injection by hand.....

Thanks,
Gao Xiang

> 
