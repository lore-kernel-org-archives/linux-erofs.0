From: chao@kernel.org (Chao Yu)
Date: Sun, 18 Aug 2019 18:39:52 +0800
Subject: [PATCH v2] staging: erofs: fix an error handling in
 erofs_readdir()
In-Reply-To: <20190818025339.GB14592@bombadil.infradead.org>
References: <20190818014835.5874-1-hsiangkao@aol.com>
 <20190818015631.6982-1-hsiangkao@aol.com>
 <20190818022055.GA14592@bombadil.infradead.org>
 <20190818023240.GA7739@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20190818025339.GB14592@bombadil.infradead.org>
Message-ID: <c624d057-cd42-515c-cff8-cf68340401e0@kernel.org>

On 2019-8-18 10:53, Matthew Wilcox wrote:
> On Sun, Aug 18, 2019@10:32:45AM +0800, Gao Xiang wrote:
>> On Sat, Aug 17, 2019@07:20:55PM -0700, Matthew Wilcox wrote:
>>> On Sun, Aug 18, 2019@09:56:31AM +0800, Gao Xiang wrote:
>>>> @@ -82,8 +82,12 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
>>>>  		unsigned int nameoff, maxsize;
>>>>  
>>>>  		dentry_page = read_mapping_page(mapping, i, NULL);
>>>> -		if (IS_ERR(dentry_page))
>>>> -			continue;
>>>> +		if (IS_ERR(dentry_page)) {
>>>> +			errln("fail to readdir of logical block %u of nid %llu",
>>>> +			      i, EROFS_V(dir)->nid);
>>>> +			err = PTR_ERR(dentry_page);
>>>> +			break;
>>>
>>> I don't think you want to use the errno that came back from
>>> read_mapping_page() (which is, I think, always going to be -EIO).
>>> Rather you want -EFSCORRUPTED, at least if I understand the recent
>>> patches to ext2/ext4/f2fs/xfs/...
>>
>> Thanks for your reply and noticing this. :)
>>
>> Yes, as I talked with you about read_mapping_page() in a xfs related
>> topic earlier, I think I fully understand what returns here.
>>
>> I actually had some concern about that before sending out this patch.
>> You know the status is
>>    PG_uptodate is not set and PG_error is set here.
>>
>> But we cannot know it is actually a disk read error or due to
>> corrupted images (due to lack of page flags or some status, and
>> I think it could be a waste of page structure space for such
>> corrupted image or disk error)...
>>
>> And some people also like propagate errors from insiders...
>> (and they could argue about err = -EFSCORRUPTED as well..)
>>
>> I'd like hear your suggestion about this after my words above?
>> still return -EFSCORRUPTED?
> 
> I don't think it matters whether it's due to a disk error or a corrupted
> image.  We can't read the directory entry, so we should probably return
> -EFSCORRUPTED.  Thinking about it some more, read_mapping_page() can
> also return -ENOMEM, so it should probably look something like this:
> 
> 		err = 0;
> 		if (dentry_page == ERR_PTR(-ENOMEM))
> 			err = -ENOMEM;
> 		else if (IS_ERR(dentry_page)) {
> 			errln("fail to readdir of logical block %u of nid %llu",
> 			      i, EROFS_V(dir)->nid);
> 			err = -EFSCORRUPTED;

Well, if there is real IO error happen under filesystem, we should return -EIO
instead of EFSCORRUPTED?

The right fix may be that doing sanity check on on-disk blkaddr, and return
-EFSCORRUPTED if the blkaddr is invalid and propagate the error to its caller
erofs_readdir(), IIUC below error info.

> [36297.354090] attempt to access beyond end of device
> [36297.354098] loop17: rw=0, want=29887428984, limit=1953128
> [36297.354107] attempt to access beyond end of device
> [36297.354109] loop17: rw=0, want=29887428480, limit=1953128
> [36301.827234] attempt to access beyond end of device
> [36301.827243] loop17: rw=0, want=29887428480, limit=1953128

Thanks,

> 		}
> 
> 		if (err)
> 			break;
> 
