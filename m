From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sun, 16 Jun 2019 15:21:12 +0800
Subject: [PATCH v3 1/2] staging: erofs: add requirements field in
 superblock
In-Reply-To: <20190616071439.GA11880@kroah.com>
References: <20190611024220.86121-1-gaoxiang25@huawei.com>
 <20190613083541.67091-1-gaoxiang25@huawei.com>
 <a4d587eb-c4f0-b9e5-7ece-1ac38c2735f3@huawei.com>
 <20190616071439.GA11880@kroah.com>
Message-ID: <b2608d35-1d9f-0747-ce3c-ddfd6273e865@huawei.com>



On 2019/6/16 15:14, Greg Kroah-Hartman wrote:
> On Sun, Jun 16, 2019@03:00:38PM +0800, Gao Xiang wrote:
>> Hi Greg,
>>
>> Sorry for annoying... Could you help merge these two fixes? Thanks in advance...
> 
> It was only 3 days, please give me at the very least, a week or so for
> staging patches.
> 
>> decompression inplace optimization needs these two patches and I will integrate
>> erofs decompression inplace optimization later for linux-next 5.3, and try to start 
>> making effort on moving to fs/ directory on kernel 5.4...
> 
> You can always send follow-on patches, I apply them in the correct
> order.  I will get to these next week, thanks.

OK, I was actually just afraid of the appling order. I was thinking of merging
these two patches in advance since the new series has the dependency on these patches.

Thanks,
Gao Xiang

> 
> greg k-h
> 
