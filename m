From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 28 Dec 2018 09:59:34 +0800
Subject: [PREVIEW] [PATCH 1/3] staging: erofs: fix fast symlink w/o xattr
 if xattr is enabled
In-Reply-To: <b00d2f13-e24b-83d1-1efe-caaeaac27515@huawei.com>
References: <20181226093113.8942-1-gaoxiang25@huawei.com>
 <b00d2f13-e24b-83d1-1efe-caaeaac27515@huawei.com>
Message-ID: <e1e04b00-cdc2-4ec6-8254-54fdb0291582@huawei.com>

Hi Chao,

On 2018/12/28 9:57, Chao Yu wrote:
> vi->xattr_isize <= sizeof(struct erofs_xattr_ibody_header)?
> 
> Thanks,

Correct... Thanks for review. I will fix it later...

Thanks,
Gao Xiang
