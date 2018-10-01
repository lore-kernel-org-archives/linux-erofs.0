From: chao@kernel.org (Chao Yu)
Date: Mon, 1 Oct 2018 11:04:46 +0800
Subject: [PREVIEW] [PATCH chao/erofs-dev 1/3] staging: erofs: harden inode
 lookup for 32-bit platforms
In-Reply-To: <a3f994a3-f38e-5e20-775e-63bbef343073@aol.com>
References: <1537501415-70936-1-git-send-email-gaoxiang25@huawei.com>
 <72499322-10d4-b9af-3eb1-1787f451b5c8@kernel.org>
 <a3f994a3-f38e-5e20-775e-63bbef343073@aol.com>
Message-ID: <ffcc88b5-bb18-047a-6dcd-639bf8647890@kernel.org>

On 2018-10-1 10:40, Gao Xiang wrote:
> Hi Chao,
> 
> On 2018/10/1 9:57, Chao Yu wrote:
>> On 2018-9-21 11:43, Gao Xiang wrote:
>>> This patch introduces inode hash function, test and set callbacks,
>>> and iget5_locked to find the right inode for 32-bit platforms.
>>>
>>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>>> ---
>>>  drivers/staging/erofs/inode.c    | 37 ++++++++++++++++++++++++++++++++++++-
>>>  drivers/staging/erofs/internal.h | 10 ++++++++++
>>>  2 files changed, 46 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
>>> index da8693a..a2fa2aa 100644
>>> --- a/drivers/staging/erofs/inode.c
>>> +++ b/drivers/staging/erofs/inode.c
>>> @@ -232,10 +232,45 @@ static int fill_inode(struct inode *inode, int isdir)
>>>  	return err;
>>>  }
>>>  
>>> +/*
>>> + * erofs nid is 64bits, but i_ino is 'unsigned long', therefore
>>> + * we should do more for 32-bit platform to find the right inode.
>>> + */
>>> +#if BITS_PER_LONG < 64
>>
>> #if BITS_PER_LOG == 32
> 
> OK.
> 
>>
>>> +static int erofs_ilookup_test_actor(struct inode *inode, void *opaque)
>>> +{
>>> +	const erofs_nid_t nid = *(erofs_nid_t *)opaque;
>>> +
>>> +	return EROFS_V(inode)->nid == nid;
>>> +}
>>> +
>>> +static int erofs_iget_set_actor(struct inode *inode, void *opaque)
>>> +{
>>> +	const erofs_nid_t nid = *(erofs_nid_t *)opaque;
>>> +
>>> +	inode->i_ino = erofs_inode_hash(nid);
>>> +	return 0;
>>> +}
>>> +#endif
>>> +
>>> +static inline struct inode *erofs_iget_locked(struct super_block *sb,
>>> +					      erofs_nid_t nid)
>>> +{
>>> +	const unsigned long hashval = erofs_inode_hash(nid);
>>> +
>>> +#if BITS_PER_LONG >= 64
>>> +	/* it is safe to use iget_locked for >= 64-bit platform */
>>> +	return iget_locked(sb, hashval);
>>> +#else
>>> +	return iget5_locked(sb, hashval, erofs_ilookup_test_actor,
>>> +		erofs_iget_set_actor, &nid);
>>
>> How about just using iget5_locked? and then we can only handle 32/64-bit
>> platforms difference in erofs_inode_hash()?
> 
> It seems iget_locked is faster than iget5_locked because it has
> more fast paths and no indirect callbacks for each inode...

That's trivial cleanup. Well, if you are worried about the performance of
erofs_iget(), let's keep it as it is. :)

Thanks,

> 
>>
>>> +#endif
>>> +}
>>> +
>>>  struct inode *erofs_iget(struct super_block *sb,
>>>  	erofs_nid_t nid, bool isdir)
>>>  {
>>> -	struct inode *inode = iget_locked(sb, nid);
>>> +	struct inode *inode = erofs_iget_locked(sb, nid);
>>>  
>>>  	if (unlikely(inode == NULL))
>>>  		return ERR_PTR(-ENOMEM);
>>> diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
>>> index c2cc4a016..823929a 100644
>>> --- a/drivers/staging/erofs/internal.h
>>> +++ b/drivers/staging/erofs/internal.h
>>> @@ -511,6 +511,16 @@ struct erofs_map_blocks_iter {
>>>  }
>>>  
>>>  /* inode.c */
>>> +static inline unsigned long erofs_inode_hash(erofs_nid_t nid)
>>> +{
>>> +	u64 h = nid;
>>
>> unsigned long h;
>>
>>> +
>>> +#if BITS_PER_LONG == 32
>>> +	h = (h >> 32) ^ (h & 0xffffffff);
>>
>> h = (nid >> 32) ^ (nid & 0xffffffff);
>>
>>> +#endif
>>> +	return (unsigned long)h;
>>
>> return h;
> 
> OK, will fix soon.
> 
> Thanks,
> Gao Xiang
> 
>>
>> Thanks,
>>
>>> +}
>>> +
>>>  extern struct inode *erofs_iget(struct super_block *sb,
>>>  	erofs_nid_t nid, bool dir);
>>>  
>>>
