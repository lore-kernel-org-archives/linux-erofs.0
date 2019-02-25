From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 25 Feb 2019 09:35:22 +0800
Subject: [PATCH 1/2] staging: erofs: no need to take page lock in readdir
In-Reply-To: <20190221023411.2980-1-gaoxiang25@huawei.com>
References: <20190221023411.2980-1-gaoxiang25@huawei.com>
Message-ID: <119597fc-c456-b893-4e42-2cf038e3f766@huawei.com>

On 2019/2/21 10:34, Gao Xiang wrote:
> VFS will take inode_lock for readdir, therefore no need to
> take page lock in readdir at all just as the majority of
> other generic filesystems.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
