From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 11 Oct 2018 19:19:52 +0800
Subject: [PATCH] staging: erofs: harden inode lookup for 32-bit platforms
In-Reply-To: <20181011111204.zhxh5tw66pdxb3zh@mwanda>
References: <20181009140713.29629-1-gaoxiang25@huawei.com>
 <20181011084413.3sovzgsj6pzyrml7@mwanda>
 <b6baf932-64e5-c902-7e7f-02094b96a8d6@huawei.com>
 <20181011101807.hydncp6nhzjlzznr@mwanda>
 <6318156d-4a3d-e5d0-93c1-90be2345565b@huawei.com>
 <20181011111204.zhxh5tw66pdxb3zh@mwanda>
Message-ID: <97a7da46-212f-f1d3-548f-44cf8d9ee36d@huawei.com>

Hi Dan,

On 2018/10/11 19:12, Dan Carpenter wrote:
> On Thu, Oct 11, 2018@06:49:57PM +0800, Gao Xiang wrote:
>> Hi Dan,
>>
>> On 2018/10/11 18:18, Dan Carpenter wrote:
>>> On Thu, Oct 11, 2018@05:46:26PM +0800, Gao Xiang wrote:
>>>>
>>>>
>>>> On 2018/10/11 16:44, Dan Carpenter wrote:
>>>>> On Tue, Oct 09, 2018@10:07:13PM +0800, Gao Xiang wrote:
>>>>>> This patch introduces inode hash function, test and set callbacks,
>>>>>> and iget5_locked to find the right inode for 32-bit platforms.
>>>>>>
>>>>>
>>>>> The way I read this changelog, we're trying to deal with corrupt file
>>>>> systems?  Is that correct?  Presumably in the current code it could lead
>>>>> to a Oops or something?
>>>>
>>>> No, this commit isn't trying to deal with corrupt file systems.
>>>> In EROFS, the nid is not continuous and it represents the inode offset
>>>> inode offset = nid * 32.
>>>> Therefore the nid is 64-bit both for 32-bit and 64-bit platforms. However,
>>>> i_ino is 'unsigned long', which means for 32-bit platforms, i_ino is not enough
>>>> to contain the nid.
>>>>
>>>> Therefore, we should use iget5_locked for this case.
>>>
>>> I guess what I'm saying is, what are the user visible effects of this
>>> patch?  It's hard for me to tell from the patch description.  Could you
>>> please re-write the description and send a v2?
>>
>> Sorry for my just hurry reply. It seems I really misunderstood your point :-(
>>
>> If all nids are less than 32-bit, the user will see the correct inode/nid number
>> for all 32-bit platforms, but if some nids are greater than 32-bit, it could be
>> collisions without this patch for 32-bit platforms.
>>
>> This patch switch the inode number by XOR the high 32-bit and the low 32-bit,
>> use customized tester to avoid collisions for 32-bit platforms.
>>
>> I will send v2 to fix the commit message...but it seems Greg is already merged in
>> https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/commit/?h=staging-testing&id=2abd7814138774eb56319e9dcc0abd08ece45424
>>
> 
> Oh.  Then that's fine then.  If Greg already merged it, then it's too
> late to change.  Thanks for the explanation, though.

I appended the v2 patch in the end of this reply for reference...

Thanks,
Gao Xiang

> 
> regards,
> dan carpenter
> 


>From 175eb3f1c6e1cddf8292853ab0fb7644320c3ae2 Mon Sep 17 00:00:00 2001
From: Gao Xiang <gaoxiang25@huawei.com>
Date: Mon, 1 Oct 2018 12:32:55 +0800
Subject: [PATCH v2] staging: erofs: harden inode lookup for 32-bit platforms

Each erofs inode has a unique 64-bit nid to distinguish from others.
However, the inode number is usually defined as `unsigned long',
which means some collisions could happen if we directly use iget_locked
for 32-bit platforms.

Therefore, this patch introduces a inode hash function, test and set
callbacks, and iget5_locked to avoid potential collisions
for 32-bit platforms.

In addition, if the value of a nid is greater than 32-bit, users from
32-bit platforms will see XOR-ed inode numbers after this patch.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---

change log v2:
 - add more infos to the commit message as pointed out by Dan Carpenter.

Thanks,
Gao Xiang

 drivers/staging/erofs/inode.c    | 37 ++++++++++++++++++++++++++++++++++++-
 drivers/staging/erofs/internal.h |  9 +++++++++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index da8693a7c3d3..04c61a9d7b76 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -232,10 +232,45 @@ static int fill_inode(struct inode *inode, int isdir)
 	return err;
 }
 
+/*
+ * erofs nid is 64bits, but i_ino is 'unsigned long', therefore
+ * we should do more for 32-bit platform to find the right inode.
+ */
+#if BITS_PER_LONG == 32
+static int erofs_ilookup_test_actor(struct inode *inode, void *opaque)
+{
+	const erofs_nid_t nid = *(erofs_nid_t *)opaque;
+
+	return EROFS_V(inode)->nid == nid;
+}
+
+static int erofs_iget_set_actor(struct inode *inode, void *opaque)
+{
+	const erofs_nid_t nid = *(erofs_nid_t *)opaque;
+
+	inode->i_ino = erofs_inode_hash(nid);
+	return 0;
+}
+#endif
+
+static inline struct inode *erofs_iget_locked(struct super_block *sb,
+					      erofs_nid_t nid)
+{
+	const unsigned long hashval = erofs_inode_hash(nid);
+
+#if BITS_PER_LONG >= 64
+	/* it is safe to use iget_locked for >= 64-bit platform */
+	return iget_locked(sb, hashval);
+#else
+	return iget5_locked(sb, hashval, erofs_ilookup_test_actor,
+		erofs_iget_set_actor, &nid);
+#endif
+}
+
 struct inode *erofs_iget(struct super_block *sb,
 	erofs_nid_t nid, bool isdir)
 {
-	struct inode *inode = iget_locked(sb, nid);
+	struct inode *inode = erofs_iget_locked(sb, nid);
 
 	if (unlikely(inode == NULL))
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 5096b27bcf0d..57575c7f5635 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -517,6 +517,15 @@ erofs_get_inline_page(struct inode *inode,
 }
 
 /* inode.c */
+static inline unsigned long erofs_inode_hash(erofs_nid_t nid)
+{
+#if BITS_PER_LONG == 32
+	return (nid >> 32) ^ (nid & 0xffffffff);
+#else
+	return nid;
+#endif
+}
+
 extern struct inode *erofs_iget(struct super_block *sb,
 	erofs_nid_t nid, bool dir);
 
-- 
2.14.4
