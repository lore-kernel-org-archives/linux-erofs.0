From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 18 Sep 2018 22:38:22 +0800
Subject: [PATCH v2 0/8] staging: erofs: error handing and more tracepoints
In-Reply-To: <20180918143605.GA19347@kroah.com>
References: <1537280740-122019-1-git-send-email-gaoxiang25@huawei.com>
 <20180918143605.GA19347@kroah.com>
Message-ID: <744aeccc-8a8e-072a-501b-2208d0888240@huawei.com>

Hi Greg,

On 2018/9/18 22:36, Greg Kroah-Hartman wrote:
> On Tue, Sep 18, 2018@10:25:32PM +0800, Gao Xiang wrote:
>> change log v2:
>>   - fix a gcc warning reported by Greg for the patch
>>         staging: erofs: clean up z_erofs_map_blocks_iter
>>
>>
>> In order to avoid conflicts with cleanup patches, Chao and I think
>> it is better to send reviewed preview patches in the erofs mailing list
>> to the community in time.
>>
>> So here is reviewed & tested patches right now, which clean up and
>> enhance the error handing and add some tracepoints for decompression.
>>
>> Note that in this patchset, bare use of 'unsigned' and NULL comparison are
>> also fixed compared with the preview patches according to the previous
>> discussion in the staging mailing list.
> 
> Thanks for the resend, looks good.

Thanks for applying...
p.s. sorry for just expression... I mean "with my pleasure", sorry about my english...

Thanks,
Gao Xiang

> 
> greg k-h
> 
