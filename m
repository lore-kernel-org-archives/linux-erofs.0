From: viro@zeniv.linux.org.uk (Al Viro)
Date: Sun, 21 Jul 2019 05:05:53 +0100
Subject: [PATCH v2 03/24] erofs: add super block operations
In-Reply-To: <161cffc4-1d61-5dc6-45df-f1779ef03b0f@aol.com>
References: <20190711145755.33908-1-gaoxiang25@huawei.com>
 <20190711145755.33908-4-gaoxiang25@huawei.com>
 <20190720224955.GD17978@ZenIV.linux.org.uk>
 <161cffc4-1d61-5dc6-45df-f1779ef03b0f@aol.com>
Message-ID: <20190721040547.GF17978@ZenIV.linux.org.uk>

On Sun, Jul 21, 2019@11:08:42AM +0800, Gao Xiang wrote:

> It is for debugging use as you said below, mainly for our internal
> testers whose jobs are
> to read kmsg logs and catch kernel problems. sb->s_id (device number)
> maybe not
> straight-forward for them compared with dev_name...

Huh? ->s_id is something like "sdb7" - it's bdev_name(), not a device
number...

> The initial purpose of erofs_mount_private was to passing multi private
> data from erofs_mount
> to erofs_read_super, which was written before fs_contest was introduced.

That has nothing to do with fs_context (well, other than fs_context conversions
affecting the code very close to that).

> I agree with you, it seems better to just use s_id in community and
> delete erofs_mount_private stuffs...
> Yet I don't look into how to use new fs_context, could I keep using
> legacy mount interface and fix them all?

Sure.

> I guess if I don't misunderstand, that is another suggestion -- in
> short, leave all destructors to .kill_sb() and
> cleanup fill_super().

Just be careful with that iput() there - AFAICS, if fs went live (i.e.
if ->s_root is non-NULL), you really need it done only from put_super();
OTOH, for the case of NULL ->s_root ->put_super() won't be called at all,
so in that case you need it directly in ->kill_sb().
