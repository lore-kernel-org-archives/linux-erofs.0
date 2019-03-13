From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 13 Mar 2019 14:50:21 +0800
Subject: [PATCH 1/1] staging: erofs: Add function comment for erofs/super.c
In-Reply-To: <26452.1552459280@turing-police>
References: <CAKsu7qwsSeN3XT=f-cz6wOMdwAHHhDJpWnNk_2epHu5J+F0+VA@mail.gmail.com>
 <2d0544aa-cc99-f1dd-3b83-9f06a307dfc7@aol.com>
 <26452.1552459280@turing-police>
Message-ID: <d46cf6a3-f068-979c-f32d-0472b327923d@huawei.com>

Hi Valdis,

On 2019/3/13 14:41, valdis.kletnieks@vt.edu wrote:
> On Wed, 13 Mar 2019 08:48:26 +0800, Gao Xiang said:
> (Reversing order of  comments)
>> "Release slab Memory" is not a very useful description for this function.
> 
> Agreed.
> 
>> i_callback is used to free inode structure and other memory related to this inode
> 
> However, that's not a bad description at all. :)
> 
> (Though I'd consider renaming the function to 'reap_inode_mem()' or something
> like that so no description is needed. :)

i_callback is an common function names for this usage, see:

reiserfs/super.c
653:static void reiserfs_i_callback(struct rcu_head *head)
661:    call_rcu(&inode->i_rcu, reiserfs_i_callback);

romfs/super.c
384:static void romfs_i_callback(struct rcu_head *head)
393:    call_rcu(&inode->i_rcu, romfs_i_callback);

hfsplus/super.c
631:static void hfsplus_i_callback(struct rcu_head *head)
640:    call_rcu(&inode->i_rcu, hfsplus_i_callback);

qnx4/inode.c
345:static void qnx4_i_callback(struct rcu_head *head)
353:    call_rcu(&inode->i_rcu, qnx4_i_callback);

gfs2/super.c
1740:static void gfs2_i_callback(struct rcu_head *head)
1748:   call_rcu(&inode->i_rcu, gfs2_i_callback);

minix/inode.c
71:static void minix_i_callback(struct rcu_head *head)
79:     call_rcu(&inode->i_rcu, minix_i_callback);

jfs/super.c
127:static void jfs_i_callback(struct rcu_head *head)
147:    call_rcu(&inode->i_rcu, jfs_i_callback);

udf/super.c
164:static void udf_i_callback(struct rcu_head *head)
172:    call_rcu(&inode->i_rcu, udf_i_callback);

ufs/super.c
1452:static void ufs_i_callback(struct rcu_head *head)
1460:   call_rcu(&inode->i_rcu, ufs_i_callback);

openpromfs/inode.c
339:static void openprom_i_callback(struct rcu_head *head)
347:    call_rcu(&inode->i_rcu, openprom_i_callback);

ubifs/super.c
275:static void ubifs_i_callback(struct rcu_head *head)
287:    call_rcu(&inode->i_rcu, ubifs_i_callback);

Therefore fs guy should know what it does by the name convension :)

Anyway, I think this patch is useful with some modification *thumb*

Thanks,
Gao Xiang

> 
> 
> 
