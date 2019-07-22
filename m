From: hsiangkao@aol.com (Gao Xiang)
Date: Tue, 23 Jul 2019 00:27:16 +0800
Subject: [PATCH v3 23/24] erofs: introduce cached decompression
In-Reply-To: <20190722151226.GC5172@mit.edu>
References: <20190722025043.166344-1-gaoxiang25@huawei.com>
 <20190722025043.166344-24-gaoxiang25@huawei.com>
 <20190722101818.GN20977@twin.jikos.cz>
 <41f1659a-0d16-4316-34fc-335b7d142d5c@aol.com>
 <20190722132513.GA5172@mit.edu>
 <db672675-c471-5bc8-af15-91c1859e9008@aol.com>
 <20190722151226.GC5172@mit.edu>
Message-ID: <a5001fe8-217a-42bc-9257-45bef544762e@aol.com>



On 2019/7/22 ????11:12, Theodore Y. Ts'o wrote:
> On Mon, Jul 22, 2019@10:16:44PM +0800, Gao Xiang wrote:
>> OK, I will give a try. One point I think is how to deal with the case
>> if there is already cached information when remounting as well as you said.
>>
>> As the first step, maybe the mount option can be defined as
>> allowing/forbiding caching from now on, which can be refined later.
> 
> Yes; possible solutions include ignoring the issue (assuming that
> cached data structures that "shouldn't" be in the cache given the new
> cache strategy will fall out of the cache over time), forcibly
> flushing the cache when the caching strategy has changed, and of
> course, forbidding caching strategy change at remount time.

Okay, thanks for your kindly suggestion :)

will do, hopefully resend this week (I agree less bugs with less
kernel configs.).

Thanks,
Gao Xiang

> 
> Cheers,
> 
> 					- Ted
> 
