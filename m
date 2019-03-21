From: bhanusreemahesh@gmail.com (Bhanusree Mahesh)
Date: Thu, 21 Mar 2019 17:56:55 +0530
Subject: [Outreachy kernel] Re: [PATCH] Staging: erofs: Use !x in place of
 NULL comparision
In-Reply-To: <0a20b616-b2b9-9e38-3c0c-c8860cc41a0c@huawei.com>
References: <20190321093716.8236-1-bhanusreemahesh@gmail.com>
 <0a20b616-b2b9-9e38-3c0c-c8860cc41a0c@huawei.com>
Message-ID: <87F3F71C-D738-4051-A9FF-A9C60520660B@gmail.com>



> On Mar 21, 2019,@15:42, Gao Xiang <gaoxiang25@huawei.com> wrote:
> 
> Hi Bhanusree,
> 
>> On 2019/3/21 17:37, Bhanusree Pola wrote:
>> Test for NULL as !x instead of NULL comparisions for
>> functions that return NULL on failure are used.
>> Issue found using coccinelle
>> Semantic patch used to solve the problem is as follows
>> 
> 
> My personal idea...There are still several other places which use
> NULL comparisions introduced by the erofs original code, eg,
> super.c
> 53:     if (vi == NULL)
> 90:     if (bh == NULL) {
> ...
> 
> internal.h
> 480:                    if (unlikely(bio == NULL)) {
> 488:    } while (unlikely(bio == NULL));
> ...
> 
> Could you have time fix them as much as possible in a patch?
> 
> It will simplify erofs commit log since there are similar
> patches address the same reason but with few fixes...:
> 
> staging: erofs: unzip_vle.c: Replace comparison to NULL.
> staging: erofs: Modify conditional checks
> staging: erofs: formatting fix to NULL comparison
> 
> ... Thanks in advance...

Sure!! I?ll do that and resend.

Bhanusree
> 
> Thanks,
> Gao Xiang
> 
>> // <smpl>
>> @@
>> expression x;
>> statement S;
>> @@
>> 
>> x = (\(kmalloc\|devm_kzalloc\|kmalloc_array\|devm_ioremap\|
>> usb_alloc_urb\|alloc_netdev\|dev_alloc_skb\)(...));
>> 
>> -if(x==NULL)
>> +if(!x)
>> // </smpl>
>> 
>> Signed-off-by: Bhanusree Pola <bhanusreemahesh at gmail.com>
>> ---
>> drivers/staging/erofs/xattr.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
>> index f716ab0446e5..515b4b446491 100644
>> --- a/drivers/staging/erofs/xattr.c
>> +++ b/drivers/staging/erofs/xattr.c
>> @@ -107,7 +107,7 @@ static int init_inode_xattrs(struct inode *inode)
>>    vi->xattr_shared_count = ih->h_shared_count;
>>    vi->xattr_shared_xattrs = kmalloc_array(vi->xattr_shared_count,
>>                        sizeof(uint), GFP_KERNEL);
>> -    if (vi->xattr_shared_xattrs == NULL) {
>> +    if (!vi->xattr_shared_xattrs) {
>>        xattr_iter_end(&it, atomic_map);
>>        ret = -ENOMEM;
>>        goto out_unlock;
>> 
> 
> -- 
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe at googlegroups.com.
> To post to this group, send email to outreachy-kernel at googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/0a20b616-b2b9-9e38-3c0c-c8860cc41a0c%40huawei.com.
> For more options, visit https://groups.google.com/d/optout.
