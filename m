From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 25 Sep 2018 09:13:25 +0800
Subject: [PATCH] staging: erofs: change inode related info in
 erofs_statfs()
In-Reply-To: <20180924234136.19465-1-cgxu519@gmx.com>
References: <20180924234136.19465-1-cgxu519@gmx.com>
Message-ID: <240e9d66-9063-3026-654f-e47be41e144d@huawei.com>

Hi Chengguang,

On 2018/9/25 7:41, Chengguang Xu wrote:
> As a read only filesystem, it's better to show available
> inode num as 0 in statfs.
> 
> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
> ---
>  drivers/staging/erofs/super.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
> index 51b076255988..6601a242071f 100644
> --- a/drivers/staging/erofs/super.c
> +++ b/drivers/staging/erofs/super.c
> @@ -627,8 +627,8 @@ static int erofs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	buf->f_blocks = sbi->blocks;
>  	buf->f_bfree = buf->f_bavail = 0;
>  
> -	buf->f_files = ULLONG_MAX;
> -	buf->f_ffree = ULLONG_MAX - sbi->inos;
> +	buf->f_files = sbi->inos;

For erofs, nid indicates the inode position rather than just a id, and it could not be continious.

The in-byte inode position is calculated by the following formula:
nid * 32(inode_v1) + meta_blkaddr * 4096

These two fields are defined as:
fsfilcnt_t    f_files    Total number of file serial numbers.
fsfilcnt_t    f_ffree    Total number of free file serial numbers.

I'm afraid if f_files == sbi->inos, the actual inode number (nid) could be larger than f_files.
I have no idea whether it could give undefined behavior to user program...

Thanks,
Gao Xiang


> +	buf->f_ffree = 0;
>  
>  	buf->f_namelen = EROFS_NAME_LEN;
>  
> 
