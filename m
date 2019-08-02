From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 2 Aug 2019 10:00:04 +0800
Subject: [PATCH] erofs-utils: error handling for incorrect dbg lvl &
 compression algorithm
In-Reply-To: <20190801191809.13675-1-pratikshinde320@gmail.com>
References: <20190801191809.13675-1-pratikshinde320@gmail.com>
Message-ID: <20190802014323.GA3911@138>

Hi Pratik,

On Fri, Aug 02, 2019@12:48:09AM +0530, Pratik Shinde wrote:
> handling the case of incorrect debug level.
> also, an early check for valid compression algorithm.
> 
> Signed-off-by: Pratik Shinde <pratikshinde320 at gmail.com>
> ---
>  mkfs/main.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/mkfs/main.c b/mkfs/main.c
> index fdb65fd..4231d13 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -105,10 +105,22 @@ static int mkfs_parse_options_cfg(int argc, char *argv[])
>  				}
>  			}
>  			cfg.c_compr_alg_master = strndup(optarg, i);
> +			if (strcmp(cfg.c_compr_alg_master, "lz4")
> +			    && strcmp(cfg.c_compr_alg_master, "lz4hc")) {
> +				erofs_err("invalid compressor algorithm %s",
> +					  cfg.c_compr_alg_master);
> +				return -EINVAL;
> +			}

It should be do in the compressors, and we have:
https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/tree/lib/compressor.c?h=dev#n74

I'd like to know if some problems are out with the above code...

>  			break;
>  
>  		case 'd':
>  			cfg.c_dbg_lvl = parse_num_from_str(optarg);
> +			if (cfg.c_dbg_lvl < 0 || cfg.c_dbg_lvl > 9) {

I think we cannot directly do like the above since
not all compression algorithm levels are 0~9 (and the default level could be -1).
take a look at struct erofs_compressor and it has
	int default_level;
	int best_level;
I think maybe we have to define "worst_level" as well, and
it could be better do the above check in "int z_erofs_compress_init(void)"

Thanks,
Gao Xiang

> +				fprintf(stderr,
> +					"invalid debug level %d\n",
> +					cfg.c_dbg_lvl);
> +				return -EINVAL;
> +			}
>  			break;
>  
>  		case 'E':
> -- 
> 2.9.3
> 
