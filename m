From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 5 Nov 2018 23:43:48 +0800
Subject: [PATCH v3 2/2] staging: erofs: Modify conditional checks
In-Reply-To: <b36253c9dacce060a90e84f3e8d854749800d720.1541421259.git.digholebhagyashri@gmail.com>
References: <b14ab748b6c00632bb2234000d96a7e1912e2b1b.1541421259.git.digholebhagyashri@gmail.com>
 <b36253c9dacce060a90e84f3e8d854749800d720.1541421259.git.digholebhagyashri@gmail.com>
Message-ID: <3ac63350-6bfc-0dba-2649-ad7f91dd94c9@huawei.com>

Hi Bhagyashri,

On 2018/11/5 22:50, Bhagyashri P. Dighole wrote:
> Fix coding style alignment issues detected by checkpatch.pl
> Use ! for NULL test rather than explicitly comparing to NULL.
> 
> Signed-off-by: Bhagyashri P. Dighole <digholebhagyashri at gmail.com>
> ---
> Changes in v3:
> - Split patch in two patches. Each patch have similar       
>   kind of changes. One patch for all alignment fixes and 
>     second patch for all conditional check fixes.
> 
> Changes in v2:
> - Fix for one alignment issue and one conditional check issue.
> 
> Changes in v1:
> - Fix for all issues in data.c

As the Greg said before, there are too many patchset v3... :(
Apart from its content, could you please resend the whole patchset
by using a proper version number...

It is really confusing for me as well...

Thanks,
Gao Xiang
