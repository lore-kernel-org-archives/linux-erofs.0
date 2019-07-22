From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 22 Jul 2019 22:16:44 +0800
Subject: [PATCH v3 23/24] erofs: introduce cached decompression
In-Reply-To: <20190722132513.GA5172@mit.edu>
References: <20190722025043.166344-1-gaoxiang25@huawei.com>
 <20190722025043.166344-24-gaoxiang25@huawei.com>
 <20190722101818.GN20977@twin.jikos.cz>
 <41f1659a-0d16-4316-34fc-335b7d142d5c@aol.com>
 <20190722132513.GA5172@mit.edu>
Message-ID: <db672675-c471-5bc8-af15-91c1859e9008@aol.com>

Hi Ted,

On 2019/7/22 ????9:25, Theodore Y. Ts'o wrote,
> On Mon, Jul 22, 2019@06:58:59PM +0800, Gao Xiang wrote:
>>> The number of individual Kconfig options is quite high, are you sure you
>>> need them to be split like that?
>>
>> You mean the above? these are 3 cache strategies, which impact the
>> runtime memory consumption and performance. I tend to leave the above
>> as it-is...
> 
> Unless cache strategies involve a huge amount of kernel code, I'd
> recommend always compiling all of the cache strategies, and then have
> a way to change the cache strategy via a mount option (and possibly
> remount, although that can get tricky if there is already cached
> information).  You could also specify a default in the erofs
> superblock, you think that would be useful.
OK, I will give a try. One point I think is how to deal with the case
if there is already cached information when remounting as well as you said.

As the first step, maybe the mount option can be defined as
allowing/forbiding caching from now on, which can be refined later.

Thanks,
Gao Xiang

> 
> 	    	      	   	    - Ted
> 
