From: richard@nod.at (Richard Weinberger)
Date: Mon, 19 Aug 2019 19:10:33 +0200 (CEST)
Subject: erofs: Question on unused fields in on-disk structs
Message-ID: <1323459733.69859.1566234633793.JavaMail.zimbra@nod.at>

Hi!

struct erofs_super_block has "checksum" and "features" fields,
but they are not used in the source.
What is the plan for these?

Same for i_checksum in erofs_inode_v1 and erofs_inode_v2.

At least the "features" field in the super block is something I'd
expect to be used.
...such that you can have new filesystem features in future.

Thanks,
//richard
