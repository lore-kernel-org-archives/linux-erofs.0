From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 8 Jan 2019 09:46:18 +0800
Subject: [PATCH 0/2] staging: erofs: fixed -Wmissing-prototype warnings.
In-Reply-To: <20190107182516.21511-1-jeremy@azazel.net>
References: <20190107182516.21511-1-jeremy@azazel.net>
Message-ID: <5b305a6a-b50d-fd27-4675-88cdeffa577b@huawei.com>

Hi Jeremy,

On 2019/1/8 2:25, Jeremy Sowden wrote:
> Fixes for -Wmissing-prototype warnings in the erofs driver.  One group of
> functions have been made static; for the second, prototypes have been moved to a
> head

Is -Wmissing-prototypes required for the current linux kernel?
I cannot see this warning in my personal kernel compilation...

Functions your fix have already been added proper erofs prefix,
therefore it wouldn't pollute the global namespace:
z_erofs_vle_work_release
z_erofs_unzip_lz4
erofs_try_to_release_workgroup

erofs_workgroup_free_rcu
z_erofs_map_blocks_iter

some thought?

Thanks,
Gao Xiang
