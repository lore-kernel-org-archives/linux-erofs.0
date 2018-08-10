From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 10 Aug 2018 14:06:25 +0800
Subject: [PREVIEW] [PATCH 3/4] staging: erofs: seperate erofs_get_meta_page
In-Reply-To: <173e0b85-0553-1660-c7bf-14be69d487a8@huawei.com>
References: <1533103277-20856-1-git-send-email-gaoxiang25@huawei.com>
 <1533103277-20856-3-git-send-email-gaoxiang25@huawei.com>
 <fbe65718-efdd-07bc-3006-6b4d603b7f36@huawei.com>
 <7ce60f37-5084-8762-b99b-eb3d8c1e3a5a@huawei.com>
 <173e0b85-0553-1660-c7bf-14be69d487a8@huawei.com>
Message-ID: <cb3eadc7-c71e-6132-5189-ab34e247271b@huawei.com>

Hi Chao,

On 2018/8/10 14:02, Chao Yu wrote:
> IMO, the purpose of introducing 'nofail' function is to make caller simplifying
> its error handling, since callee can handle any error insidely, if callee still
> can fail due to other reason like -EIO, we still need another handling in caller.
> 
> So here, if we encounter -EIO, how about retrying several time in
> erofs_get_meta_page_nofail like f2fs did now?
> 

So it can be, let me introducing another io retry count in Kconfig to handle that,
will see in the next patch :)

Thanks,
Gao Xiang

> Thanks,
