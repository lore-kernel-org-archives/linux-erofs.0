From: yuchao0@huawei.com (Chao Yu)
Date: Thu, 1 Aug 2019 09:33:30 +0800
Subject: [PATCH v2 08/22] staging: erofs: kill
 CONFIG_EROFS_FS_IO_MAX_RETRIES
In-Reply-To: <20190731155752.210602-9-gaoxiang25@huawei.com>
References: <20190731155752.210602-1-gaoxiang25@huawei.com>
 <20190731155752.210602-9-gaoxiang25@huawei.com>
Message-ID: <a5de6793-5926-156c-dd56-81afbbbbce4c@huawei.com>

On 2019/7/31 23:57, Gao Xiang wrote:
> CONFIG_EROFS_FS_IO_MAX_RETRIES seems a runtime setting
> and users have no idea about the change in behaviour.
> 
> Let's remove the setting currently and could turn it
> into a module parameter if it's really needed.
> 
> Suggested-by: David Sterba <dsterba at suse.cz>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
