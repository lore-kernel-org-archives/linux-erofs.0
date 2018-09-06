From: yuchao0@huawei.com (Chao Yu)
Date: Thu, 6 Sep 2018 17:39:09 +0800
Subject: [PATCH 2/2 dhowells/mount-api] staging: erofs: update .mount and
 .remount_sb
In-Reply-To: <1536224508-66168-2-git-send-email-gaoxiang25@huawei.com>
References: <1536224508-66168-1-git-send-email-gaoxiang25@huawei.com>
 <1536224508-66168-2-git-send-email-gaoxiang25@huawei.com>
Message-ID: <d83744d1-2806-4770-57be-832c502c09ea@huawei.com>

On 2018/9/6 17:01, Gao Xiang wrote:
> This patch updates .mount and .remount_sb after
> commit ("vfs: Require specification of size of
> mount data for internal mounts") in reference to
> drivers/usb/gadget/function/f_fs.c.
> 
> Reported-by: Stephen Rothwell <sfr at canb.auug.org.au>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
