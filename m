From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 18 Mar 2019 23:40:35 +0800
Subject: [PATCH v3] staging: erofs: Add whitespace after declaration
In-Reply-To: <20190318153816.GA15943@kroah.com>
References: <20190318153224.GA3596@bharath12345-Inspiron-5559>
 <20190318153816.GA15943@kroah.com>
Message-ID: <863a7266-0068-a751-bbe6-cea78caf9355@huawei.com>



On 2019/3/18 23:38, Greg KH wrote:
> On Mon, Mar 18, 2019@09:02:24PM +0530, Bharath Vedartham wrote:
>> Add whitespace after declaration. Fixed the checkpatch.pl warning.
>>
>> ---
> 
> No signed-off-by?
> 
>> changes since v2
>> 	- mutt gave me a lot of problems. Hence 3 patches for a really
>> 	  small problem.
>> 	- Fixed the extra missing line.
>>
>> Signed-off-by: Bharath Vedartham <linux.bhar at gmail.com>
> 
> It needs to be above the --- line, otherwise it will be stripped off
> when applied.
> 
> v4 please?

Actually a duplicate commit, see:
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/commit/?h=staging-next&id=8af36478f9516d51fcfedf9b9ed8905a1c00d278

several people submit patches on this line in erofs_iget()....

Thanks,
Gao Xiang

> 
> thanks,
> 
> greg k-h
> 
