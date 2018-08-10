From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 10 Aug 2018 14:33:39 +0800
Subject: [PREVIEW] [PATCH 4/4] staging: erofs: add error handling for
 xattr submodule
In-Reply-To: <f8bba294-22b8-18cc-aca5-16d64719091b@huawei.com>
References: <1533103277-20856-1-git-send-email-gaoxiang25@huawei.com>
 <1533103277-20856-4-git-send-email-gaoxiang25@huawei.com>
 <26f27530-9b3c-8f78-22e2-04a2ec6c6e2d@huawei.com>
 <08596437-a69f-b809-157b-dca5865d4c1b@huawei.com>
 <62cbecc4-b16c-f45b-f6bf-809506a67b4f@huawei.com>
 <f8bba294-22b8-18cc-aca5-16d64719091b@huawei.com>
Message-ID: <a0f3fad0-3981-95cb-f88d-74cec926ee1f@huawei.com>

Hi Xiang,

On 2018/8/10 14:15, Gao Xiang wrote:
> Hi Chao,
> 
> On 2018/8/10 14:08, Chao Yu wrote:
>> Hi Xiang,
>>
>> On 2018/8/10 11:47, Gao Xiang wrote:
>>> Hi Chao,
>>>
>>> On 2018/8/10 11:40, Chao Yu wrote:
>>>> On 2018/8/1 14:01, Gao Xiang wrote:
>>>>> This patch enhances the missing error handling code for
>>>>> xattr submodule, which improves the stability for the rare cases.
>>>>>
>>>>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>>>>> ---
>>>>>  drivers/staging/erofs/xattr.c | 114 ++++++++++++++++++++++++++++--------------
>>>>>  1 file changed, 77 insertions(+), 37 deletions(-)
>>>>>
>>>>> diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
>>>>> index 702434b..bd911bb 100644
>>>>> --- a/drivers/staging/erofs/xattr.c
>>>>> +++ b/drivers/staging/erofs/xattr.c
>>>>> @@ -24,16 +24,25 @@ struct xattr_iter {
>>>>>  
>>>>>  static inline void xattr_iter_end(struct xattr_iter *it, bool atomic)
>>>>>  {
>>>>> -	/* only init_inode_xattrs use non-atomic once */
>>>>> +	/* the only user of kunmap() is 'init_inode_xattrs' */
>>>>>  	if (unlikely(!atomic))
>>>>>  		kunmap(it->page);
>>>>>  	else
>>>>>  		kunmap_atomic(it->kaddr);
>>>>> +
>>>>>  	unlock_page(it->page);
>>>>>  	put_page(it->page);
>>>>>  }
>>>>>  
>>>>> -static void init_inode_xattrs(struct inode *inode)
>>>>> +static inline void xattr_iter_end_final(struct xattr_iter *it)
>>>>> +{
>>>>> +	if (unlikely(it->page == NULL))
>>>>> +		return;
>>>>> +
>>>>> +	xattr_iter_end(it, true);
>>>>> +}
>>>>> +
>>>>> +static int init_inode_xattrs(struct inode *inode)
>>>>>  {
>>>>>  	struct xattr_iter it;
>>>>>  	unsigned i;
>>>>> @@ -44,7 +53,7 @@ static void init_inode_xattrs(struct inode *inode)
>>>>>  	bool atomic_map;
>>>>>  
>>>>>  	if (likely(inode_has_inited_xattr(inode)))
>>>>> -		return;
>>>>> +		return 0;
>>>>>  
>>>>>  	vi = EROFS_V(inode);
>>>>>  	BUG_ON(!vi->xattr_isize);
>>>>> @@ -55,7 +64,8 @@ static void init_inode_xattrs(struct inode *inode)
>>>>>  	it.ofs = erofs_blkoff(iloc(sbi, vi->nid) + vi->inode_isize);
>>>>>  
>>>>>  	it.page = erofs_get_inline_page_nofail(inode, it.blkaddr);
>>>> Need to introduce and use erofs_get_inline_page()?
>>>>
>>>>> -	BUG_ON(IS_ERR(it.page));
>>>>> +	if (unlikely(IS_ERR(it.page)))
>>>>> +		return PTR_ERR(it.page);
>>>>>  
>>>>>  	/* read in shared xattr array (non-atomic, see kmalloc below) */
>>>>>  	it.kaddr = kmap(it.page);
>>>>> @@ -64,9 +74,12 @@ static void init_inode_xattrs(struct inode *inode)
>>>>>  	ih = (struct erofs_xattr_ibody_header *)(it.kaddr + it.ofs);
>>>>>  
>>>>>  	vi->xattr_shared_count = ih->h_shared_count;
>>>>> -	vi->xattr_shared_xattrs = (unsigned *)kmalloc_array(
>>>>> -		vi->xattr_shared_count, sizeof(unsigned),
>>>>> -		GFP_KERNEL | __GFP_NOFAIL);
>>>>> +	vi->xattr_shared_xattrs = kmalloc_array(vi->xattr_shared_count,
>>>>> +						sizeof(unsigned), GFP_KERNEL);
>>>>> +	if (unlikely(vi->xattr_shared_xattrs == NULL)) {
>>>>> +		xattr_iter_end(&it, atomic_map);
>>>>> +		return -ENOMEM;
>>>>> +	}
>>>>>  
>>>>>  	/* let's skip ibody header */
>>>>>  	it.ofs += sizeof(struct erofs_xattr_ibody_header);
>>>>> @@ -79,7 +92,8 @@ static void init_inode_xattrs(struct inode *inode)
>>>>>  
>>>>>  			it.page = erofs_get_meta_page_nofail(sb,
>>>>>  				++it.blkaddr, S_ISDIR(inode->i_mode));
>>>> Need to use erofs_get_meta_page() instead?
>>>>
>>>> Thanks,
>>> My consideration is for example,
>>>
>>> init_inode_xattrs itself can be seen as a part of inode initialization (other fs does it in
>>> inode initialization, but erofs does it in the first xattr request), if it fail, the only way
>>> is to retry again...but with more overhead to retry...
>> I think we can easily return an error to user no matter we encounter -ENOMEM or
>> -EIO, so erofs_get_meta_page() is enough here, thoughts?
>>
> 
> OK, it depends on users (kernel / programs). I think they will simply retry again in the outer loop,
> which will cause more overhead therefore for inode metadata (not xattrs), I personally tend to retry inside.

Yes, both are okay, as there is no such restriction in manual or other documents
saying syscall should success any time, so I think let's take easy to let user
to handle this condition.

And one more concern is, for extremely environment, like with very few memory,
retrying in 'nofail' function, make syscall looks like hanging in kernel side,
result in apps can not respond to user, that's not a good experience for user.

Also like f2fs, nofail version function is abused, I think it needs to be
limited and it's better to be rectified like other filesystem.

Thanks,

> 
> That is just my personal opinion, will fix it.
> 
> Thanks,
> Gao Xiang
> 
>> Thanks,
>>
> 
> .
> 
