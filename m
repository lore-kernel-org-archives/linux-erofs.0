From: hsiangkao@aol.com (Gao Xiang)
Date: Thu, 31 Jan 2019 06:57:27 +0800
Subject: patch "staging: erofs: keep corrupted fs from crashing kernel in"
 added to staging-linus
In-Reply-To: <20190130200035.GC2010@kadam>
References: <15488587831390@kroah.com>
 <74cc60e3-eb87-d574-a106-305fb40ca54d@huawei.com>
 <1e5bad91-3d65-c086-d42c-f87d642e3204@huawei.com>
 <20190130200035.GC2010@kadam>
Message-ID: <d3994ffc-9e54-b577-6b18-74084495e05c@aol.com>

Hi Dan and Greg,

On 2019/1/31 4:00, Dan Carpenter wrote:
> On Wed, Jan 30, 2019@11:42:41PM +0800, Gao Xiang wrote:
>>
>> On 2019/1/30 23:05, Gao Xiang wrote:
>>> Hi Greg,
>>>
>>> Dan raised some suggestions to me. And I want to get some review ideas from Chao...
>>> Current EROFS works good for the normal image, this patch is used for corrupted image only...
>>>
>>> Could you kindly drop this patch temporarily and I want to get them reviewed...
>>> Not soon... Thanks!
>> It seems this patch is the top of staging-linus...Could you kindly drop it and
>> it is better to get "Reviewed-by:" tag for all EROFS bugfix patches from corresponding
>> people (Chao, Dan, or Al if possible) first... Thank you very much!
>>
>> sorry to trouble you...
>>
> Greg has already reverted this but for future reference there wasn't
> any need to panic or rush.  It was just the kunmap_atomic() which only
> affects corrupted filesystem on linux-next so it's not a big deal.  The
> rest was just my style grumblings and could have been addressed later or
> even ignored.
>
> regards,
> dan carpenter

Although I test many test images and do Android boot in my internal test with this patch,
I am afraid there are some potential issues which haven't found (The old implementation is
stable enough since it works good for months and it has been applied to our real products...
This patch was just written days ago)

It is better to get some "Reviewed-by" tag for such patches at least by EROFS guys, maybe
goto linux-next is better since I don't want to break the current EROFS stability in 5.0-rc round...


Thanks,

Gao Xiang
