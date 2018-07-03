From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 3 Jul 2018 15:43:56 +0800
Subject: [chao-linux:erofs-dev 24/33] fs/erofs/unzip_vle.c:651:1-7:
 preceding lock on line 509
In-Reply-To: <alpine.DEB.2.20.1807030911350.3965@hadrien>
References: <201807031201.90hBVFTJ%fengguang.wu@intel.com>
 <alpine.DEB.2.20.1807030724250.2333@hadrien>
 <923d1ae9-3bc7-f070-050b-087a356c7702@huawei.com>
 <alpine.DEB.2.20.1807030911350.3965@hadrien>
Message-ID: <890665f7-3007-cb78-0f80-c1e1d591f12c@huawei.com>

Hi Julia,

On 2018/7/3 15:13, Julia Lawall wrote:
> 
> On Tue, 3 Jul 2018, Gao Xiang wrote:
> 
>> Hi Julia,
>>
>> On 2018/7/3 13:27, Julia Lawall wrote:
>>> Hello,
>>>
>>> There is not actually a bug here, but I wonder if the backwards goto int
>>> another if branch (use_global_pagemap) is really the best way to do this?
>>> I found it rather confusing to think about.  It could be better to just
>>> duplicate the assignment to pages, or make a flag that would be tested
>>> after the if-else.
>>>
>> I wrote this code just because of the designed pagemap allocation policy:
>>
>> If the pagemap is too large enough to alloc onstack, then
>>     I try to use the global pagemap with "trylock" if the global pagemap is not occupied.
>>     or if the global pagemap is occupied,
>>          alloc a pagemap if the corresponding memory allocation is ok,
>>          or if the memory allocation is failed, fall back to use the global pagemap with sleeping "lock" again.
>>
>> If the code style makes automatic testing confused, I could use alternative way to replace it in the next version.
> In the end, I understood the structure, but I think that a backwards goto
> into another if branch is a bit of mental overload.

In that case you are absolutely right. :)

However, in my opinion, if the use case is more complicated than just one statement
	"pages = z_pagemap_global;"

I personally tend to leave a common label to merge these two if-s into a common snippet
(if and only if the snippet has understandable meaning), either backward or afterward is ok for me.

eg.
   if (a) {
       (diff)
       goto common;
   } else if (b) {
       (diff)

/* iff it is a meaningful and understandable snippet */
common:
       (more than one statements)
   }

Using an extra flag is another way, it also has no runtime overhead.

But if functions already has too many local variables and if it is not a good idea to seperate it into sub-functions,
I think avoid more local variables is also good for understanding.

That is my personal code style tho. I could take care and use another way if needed.


Thanks,
Gao Xiang

> 
> julia
> 
