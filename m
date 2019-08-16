From: hsiangkao@aol.com (Gao Xiang)
Date: Fri, 16 Aug 2019 20:32:25 +0800
Subject: [PATCH] erofs-utils: Fail the image creation when source path is
 not a directory file.
In-Reply-To: <20190816085620.22266-1-pratikshinde320@gmail.com>
References: <20190816085620.22266-1-pratikshinde320@gmail.com>
Message-ID: <20190816123224.GA24479@hsiangkao-HP-ZHAN-66-Pro-G1>

On Fri, Aug 16, 2019@02:26:20PM +0530, Pratik Shinde wrote:
> In the erofs.mkfs utility, if the source path is not a directory,image
> creation should not proceed.since root of the filesystem needs to be a directory.
> 
> moving the check to main function.
> 
> Signed-off-by: Pratik Shinde <pratikshinde320 at gmail.com>

Applied to dev branch, thank you!

Thanks,
Gao Xiang

> ---
>  mkfs/main.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/mkfs/main.c b/mkfs/main.c
> index 93cacca..8fbfced 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -12,6 +12,7 @@
>  #include <stdlib.h>
>  #include <limits.h>
>  #include <libgen.h>
> +#include <sys/stat.h>
>  #include "erofs/config.h"
>  #include "erofs/print.h"
>  #include "erofs/cache.h"
> @@ -187,6 +188,7 @@ int main(int argc, char **argv)
>  	struct erofs_buffer_head *sb_bh;
>  	struct erofs_inode *root_inode;
>  	erofs_nid_t root_nid;
> +	struct stat64 st;
>  
>  	erofs_init_configure();
>  	fprintf(stderr, "%s %s\n", basename(argv[0]), cfg.c_version);
> @@ -197,6 +199,15 @@ int main(int argc, char **argv)
>  			usage();
>  		return 1;
>  	}
> +	err = lstat64(cfg.c_src_path, &st);
> +	if (err)
> +		return 1;
> +	if ((st.st_mode & S_IFMT) != S_IFDIR) {
> +		erofs_err("root of the filesystem is not a directory - %s",
> +			  cfg.c_src_path);
> +		usage();
> +		return 1;
> +	}
>  
>  	err = dev_open(cfg.c_img_path);
>  	if (err) {
> -- 
> 2.9.3
> 
