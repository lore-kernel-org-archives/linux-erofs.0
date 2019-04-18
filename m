From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 18 Apr 2019 22:01:51 +0800
Subject: [RFC PATCH 05/62] erofs: switch to ->free_inode()
In-Reply-To: <20190416175340.21068-5-viro@ZenIV.linux.org.uk>
References: <20190416174900.GT2217@ZenIV.linux.org.uk>
 <20190416175340.21068-1-viro@ZenIV.linux.org.uk>
 <20190416175340.21068-5-viro@ZenIV.linux.org.uk>
Message-ID: <e6cddba8-7b0a-6f05-a71a-51b8219f2159@huawei.com>



On 2019/4/17 1:52, Al Viro wrote:
> From: Al Viro <viro at zeniv.linux.org.uk>
> 
> Signed-off-by: Al Viro <viro at zeniv.linux.org.uk>

It seems more clear than before :) Thanks for taking erofs into consideration as well,

Acked-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang

> ---
>  drivers/staging/erofs/super.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
> index 15c784fba879..700cbd460807 100644
> --- a/drivers/staging/erofs/super.c
> +++ b/drivers/staging/erofs/super.c
> @@ -57,9 +57,8 @@ static struct inode *alloc_inode(struct super_block *sb)
>  	return &vi->vfs_inode;
>  }
>  
> -static void i_callback(struct rcu_head *head)
> +static void free_inode(struct inode *inode)
>  {
> -	struct inode *inode = container_of(head, struct inode, i_rcu);
>  	struct erofs_vnode *vi = EROFS_V(inode);
>  
>  	/* be careful RCU symlink path (see ext4_inode_info->i_data)! */
> @@ -71,11 +70,6 @@ static void i_callback(struct rcu_head *head)
>  	kmem_cache_free(erofs_inode_cachep, vi);
>  }
>  
> -static void destroy_inode(struct inode *inode)
> -{
> -	call_rcu(&inode->i_rcu, i_callback);
> -}
> -
>  static int superblock_read(struct super_block *sb)
>  {
>  	struct erofs_sb_info *sbi;
> @@ -668,7 +662,7 @@ static int erofs_remount(struct super_block *sb, int *flags, char *data)
>  const struct super_operations erofs_sops = {
>  	.put_super = erofs_put_super,
>  	.alloc_inode = alloc_inode,
> -	.destroy_inode = destroy_inode,
> +	.free_inode = free_inode,
>  	.statfs = erofs_statfs,
>  	.show_options = erofs_show_options,
>  	.remount_fs = erofs_remount,
> 
