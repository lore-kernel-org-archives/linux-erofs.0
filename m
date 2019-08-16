From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 16 Aug 2019 15:37:21 +0800
Subject: [PATCH] erofs-utils : Fail the image creation when source path
 is not a directory file.
In-Reply-To: <20190816070846.21557-1-pratikshinde320@gmail.com>
References: <20190816070846.21557-1-pratikshinde320@gmail.com>
Message-ID: <20190816073721.GA26737@138>

Hi Pratik,

On Fri, Aug 16, 2019@12:38:46PM +0530, Pratik Shinde wrote:
> In the erofs.mkfs utility, if the source path is not a directory,image
> creation should not proceed.since root of the filesystem needs to be a directory.
> 
> In the erofs kernel code, we return error in case root inode(read from disk) is not
> a directory.But the mkfs utility lets you create an image based on Regular file
> (S_IFREG) too.

Yes, You are right. :)

Just a minor suggestion, how about moving the logic to main()?

194         err = mkfs_parse_options_cfg(argc, argv);
195         if (err) {
196                 if (err == -EINVAL)
197                         usage();
198                 return 1;
199         }

            ^ here
200
201         err = dev_open(cfg.c_img_path);
202         if (err) {
203                 usage();
204                 return 1;
205         }

Does it sound good to you? and I will test this patch later :)

Thanks,
Gao Xiang

> 
> Signed-off-by: Pratik Shinde <pratikshinde320 at gmail.com>
> ---
>  mkfs/main.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs/main.c b/mkfs/main.c
> index 93cacca..e72b9e2 100644
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
> @@ -76,8 +77,8 @@ static int parse_extended_opts(const char *opts)
>  
>  static int mkfs_parse_options_cfg(int argc, char *argv[])
>  {
> -	int opt, i;
> -
> +	int opt, i, ret;
> +	struct stat64 st;
>  	while ((opt = getopt(argc, argv, "d:z:E:")) != -1) {
>  		switch (opt) {
>  		case 'z':
> @@ -135,7 +136,14 @@ static int mkfs_parse_options_cfg(int argc, char *argv[])
>  			  erofs_strerror(-errno));
>  		return -ENOENT;
>  	}
> -
> +	ret = lstat64(cfg.c_src_path, &st);
> +	if (ret)
> +		return -EINVAL;
> +	if ((st.st_mode & S_IFMT) != S_IFDIR) {
> +		erofs_err("root of the filesystem is not a directory - %s",
> +			  cfg.c_src_path);
> +		return -EINVAL;
> +	}
>  	if (optind < argc) {
>  		erofs_err("Unexpected argument: %s\n", argv[optind]);
>  		return -EINVAL;
> -- 
> 2.9.3
> 
