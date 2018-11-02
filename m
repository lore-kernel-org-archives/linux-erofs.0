From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 2 Nov 2018 18:26:35 +0800
Subject: [PATCH chao/erofs-dev 1/2] staging: erofs: separate into
 init_once / always
In-Reply-To: <af3deccf-5c3e-82a6-b10a-074a822643ad@huawei.com>
References: <20181019064138.36549-1-gaoxiang25@huawei.com>
 <50241fb0-28b0-f90c-2725-dce1a0327a2a@huawei.com>
 <ab8f0d8d-ac0e-0c70-d7f7-1001cec7abeb@huawei.com>
 <af3deccf-5c3e-82a6-b10a-074a822643ad@huawei.com>
Message-ID: <60fefb10-283d-d032-a974-8ea0ca547545@huawei.com>

Hi Xiang,

On 2018/10/31 10:39, Gao Xiang wrote:
> Hi Chao,
> 
> Could you please update chao/erofs-dev branch based on the linus tree and add the following patch?
> 
> =====patchset======
> staging: erofs: fix `trace_erofs_readpage' position    <-- trivial
> [v2] staging: erofs: fix race when the managed cache is enabled
> staging: erofs: fix refcount assertion in erofs_register_workgroup
> 
> staging: erofs: atomic_cond_read_relaxed on ref-locked workgroup
> staging: erofs: fix `erofs_workgroup_{try_to_freeze, unfreeze}'
> staging: erofs: add a full barrier in erofs_workgroup_unfreeze
> 
> staging: erofs: separate into init_once / always
> staging: erofs: locked before registering for all new workgroups
> 
> [v2 RESEND] staging: erofs: decompress asynchronously if PG_readahead page at first
> =====end patchset======
> 
> 
> and
> 
> "staging: erofs: managed pages could be locked at the time of decompression"
> could be dropped now since I will refactor the z_erofs_vle_unzip
> (currently, A serious bug in it, I have fixed it internally).
> 
> I am working on the reset stability patches reported by the internal beta test,
> expected to finish this week. :)

No problem, let me update them at this weekend...

Thanks,

> 
> Thanks,
> Gao Xiang
> 
> On 2018/10/31 10:11, Gao Xiang wrote:
>> Hi Chao,
>>
>> On 2018/10/31 10:04, Chao Yu wrote:
>>> On 2018/10/19 14:41, Gao Xiang wrote:
>>>> `z_erofs_vle_workgroup' is heavily generated in the decompression,
>>>> for example, it resets 32 bytes redundantly for 64-bit platforms
>>>> even through Z_EROFS_VLE_INLINE_PAGEVECS + Z_EROFS_CLUSTER_MAX_PAGES,
>>>> default 4, pages are stored in `z_erofs_vle_workgroup'.
>>>>
>>>> As an another example, `struct mutex' takes 72 bytes for our kirin
>>>> 64-bit platforms, it's unnecessary to be reseted at first and
>>>> be initialized each time.
>>>>
>>>> Let's avoid filling all `z_erofs_vle_workgroup' with 0 at first
>>>> since most fields are reinitialized to meaningful values later,
>>>> and pagevec is no need to initialized at all.
>>>>
>>>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>>>> ---
>>>>  drivers/staging/erofs/unzip_vle.c | 34 +++++++++++++++++++++++++++++-----
>>>>  1 file changed, 29 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
>>>> index 79d3ba62b298..7aa26818054a 100644
>>>> --- a/drivers/staging/erofs/unzip_vle.c
>>>> +++ b/drivers/staging/erofs/unzip_vle.c
>>>> @@ -42,12 +42,38 @@ static inline int init_unzip_workqueue(void)
>>>>  	return z_erofs_workqueue != NULL ? 0 : -ENOMEM;
>>>>  }
>>>>  
>>>> +static void init_once(void *ptr)
>>> How about rename it to init_vle_workgroup() for better readability?
>> The name convension is borrowed from inode_init_always/inode_init_once of fs/inode.c...
>> since it is pure static, I don't add the prefix(such as z_erofs_vle_workgroup or etc.. too long...).
>>
>> p.s. These days I think "vle_" is redundant... It could be renamed at a proper time...
>>
>>
>>>
>>>> +{
>>>> +	struct z_erofs_vle_workgroup *grp = ptr;
>>>> +	struct z_erofs_vle_work *const work =
>>>> +		z_erofs_vle_grab_primary_work(grp);
>>>> +	unsigned int i;
>>>> +
>>>> +	mutex_init(&work->lock);
>>>> +	work->nr_pages = 0;
>>>> +	work->vcnt = 0;
>>>> +	for (i = 0; i < Z_EROFS_CLUSTER_MAX_PAGES; ++i)
>>>> +		grp->compressed_pages[i] = NULL;
>>>> +}
>>>> +
>>>> +static void init_always(struct z_erofs_vle_workgroup *grp)
>>> Ditto, maybe reset_vle_workgroup().
>>>
>>> Otherwise, it looks good to me.
>>>
>>> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
>>
>> Thanks for the review :)
>>
>> Thanks,
>> Gao Xiang
>>
>>
>>>
>>> Thanks,
>>>
> 
> .
> 
