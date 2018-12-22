From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 22 Dec 2018 09:27:51 +0800
Subject: [PATCH v2] erofs-utils: fix the missing trailing '\0' of the last
 dirent name
In-Reply-To: <20181221022217.21563-1-bluce.liguifu@huawei.com>
References: <20181221022217.21563-1-bluce.liguifu@huawei.com>
Message-ID: <72414d4d-d345-868a-92e7-700c12f14563@huawei.com>

Hi Guifu,

On 2018/12/21 10:22, Li Guifu wrote:
> caused by the buffer is not cleanned before using, fix it.
> 

Fixes: 1d70c7468b3a ("erofs-mkfs: support to build a image from the specific root directory")

> Signed-off-by: Li Guifu <bluce.liguifu at huawei.com>

Applied to the tree.

Thanks,
Gao Xiang
