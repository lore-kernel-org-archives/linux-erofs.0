From: chao@kernel.org (Chao Yu)
Date: Sun, 4 Nov 2018 23:27:34 +0800
Subject: [PATCH chao/erofs-dev 1/2] staging: erofs: separate into
 init_once / always
In-Reply-To: <1adfe14f-f78e-656e-1558-3b80e768725e@aol.com>
References: <20181019064138.36549-1-gaoxiang25@huawei.com>
 <50241fb0-28b0-f90c-2725-dce1a0327a2a@huawei.com>
 <ab8f0d8d-ac0e-0c70-d7f7-1001cec7abeb@huawei.com>
 <af3deccf-5c3e-82a6-b10a-074a822643ad@huawei.com>
 <60fefb10-283d-d032-a974-8ea0ca547545@huawei.com>
 <1adfe14f-f78e-656e-1558-3b80e768725e@aol.com>
Message-ID: <ff2a929b-0593-0ffd-210a-64743668f1e5@kernel.org>

Hi Xiang,

On 2018-11-4 18:04, Gao Xiang via Linux-erofs wrote:
> Hi Chao,
> 
> On 2018/11/2 18:26, Chao Yu wrote:
>> Hi Xiang,
>>
>> On 2018/10/31 10:39, Gao Xiang wrote:
>>> Hi Chao,
>>>
>>> Could you please update chao/erofs-dev branch based on the linus tree and add the following patch?
>>>
>>> =====patchset======
>>> staging: erofs: fix `trace_erofs_readpage' position    <-- trivial
>>> [v2] staging: erofs: fix race when the managed cache is enabled
>>> staging: erofs: fix refcount assertion in erofs_register_workgroup
>>>
>>> staging: erofs: atomic_cond_read_relaxed on ref-locked workgroup
>>> staging: erofs: fix `erofs_workgroup_{try_to_freeze, unfreeze}'
>>> staging: erofs: add a full barrier in erofs_workgroup_unfreeze
>>>
>>> staging: erofs: separate into init_once / always
>>> staging: erofs: locked before registering for all new workgroups

There is merge conflict when applying above two patches, could you rebase them
on last udpated erofs-dev branch? :)

Thanks,

>>>
>>> [v2 RESEND] staging: erofs: decompress asynchronously if PG_readahead page at first
>>> =====end patchset======
>>>
>>>
>>> and
>>>
>>> "staging: erofs: managed pages could be locked at the time of decompression"
>>> could be dropped now since I will refactor the z_erofs_vle_unzip
>>> (currently, A serious bug in it, I have fixed it internally).
>>>
>>> I am working on the reset stability patches reported by the internal beta test,
>>> expected to finish this week. :)
>> No problem, let me update them at this weekend...
> 
> Thanks...could take some time to update this?...
> I need find a code-base to work on :)
> 
> Thanks,
> Gao Xiang
> 
>>
>> Thanks,
>>
