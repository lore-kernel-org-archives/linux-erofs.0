From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Wed, 20 Feb 2019 11:20:26 +0100
Subject: [PATCH] staging: erofs: remove rcu_read_lock() in
 erofs_try_to_free_cached_page
In-Reply-To: <fc058e45-a645-c680-2ce0-19de83fffc2e@huawei.com>
References: <20190216084650.33841-1-gaoxiang25@huawei.com>
 <fc058e45-a645-c680-2ce0-19de83fffc2e@huawei.com>
Message-ID: <20190220102026.GA32312@kroah.com>

On Wed, Feb 20, 2019@10:38:53AM +0800, Gao Xiang wrote:
> Hi Greg,
> 
> Could you consider take some time on these two patches for linux-5.1-rc1?
>  1) staging: erofs: fix race of initializing xattrs of a inode at the same time
>  2) staging: erofs: remove rcu_read_lock() in erofs_try_to_free_cached_page
> 
> It will be of great help, especially patch 1 (it could cause potential memleak
> in the race condition without it).

Ok, I'll queue them up now, I was waiting for reviewed-by tags from
others to show up :)

greg k-h
