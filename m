From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 10 Aug 2018 14:17:24 +0800
Subject: [WIP] [PATCH 1/2] staging: erofs: rearrange vle clustertype
 definitions
In-Reply-To: <1533639572-20153-1-git-send-email-gaoxiang25@huawei.com>
References: <1533639572-20153-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <d0d0149a-0737-b326-79b6-2f5a470835b2@huawei.com>

On 2018/8/7 18:59, Gao Xiang wrote:
> This patch moves vle clustertype definitions to erofs_fs.h
> since they are part of on-disk format.
> 
> It also adds compile time check for Z_EROFS_VLE_DI_CLUSTER_TYPE_BITS
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
