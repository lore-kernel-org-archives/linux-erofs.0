From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 5 Nov 2018 13:54:15 +0800
Subject: [Outreachy kernel] Re: [PATCH v2 1/2] staging: erofs: Modify
 conditional check.
In-Reply-To: <CAOMPgjjF3_JYc6H8FuMXXmNHov30uxy2N+ZtTTtVhSxzmbsnFQ@mail.gmail.com>
References: <3db6ea6f3a7b1fab94e5dacc1ec4a026e38548c2.1541394756.git.digholebhagyashri@example.com>
 <5d7fc290-08ad-0c83-d030-de255de81c47@huawei.com>
 <CAOMPgjjF3_JYc6H8FuMXXmNHov30uxy2N+ZtTTtVhSxzmbsnFQ@mail.gmail.com>
Message-ID: <1c3fa76d-349a-1ea8-09f7-734584282499@huawei.com>

Hi Bhagyashri,

On 2018/11/5 13:44, Bhagyashri Dighole wrote:
> Thanks Gao. As per discussion in previous mails, I thought we need to submit one change at a time in a patch that's why I modified accordingly. As you suggested it makes sense to fix all similar issues at once and create a single patch for those issues. I will update patch accordingly.
>

hmmm...I think you could make one similar kind of change at once...
For example you can fix all "fix pointer comparisons to NULL" in one patch and fix some else in another patch...

It seems no reason to just fix such one place with a independent patch, right?
Just my personal thought and understanding, you could ignore me if I am wrong. :)

Thanks,
Gao Xiang

> ?Thanks?
