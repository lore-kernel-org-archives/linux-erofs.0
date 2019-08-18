From: willy@infradead.org (Matthew Wilcox)
Date: Sat, 17 Aug 2019 19:20:55 -0700
Subject: [PATCH v2] staging: erofs: fix an error handling in
 erofs_readdir()
In-Reply-To: <20190818015631.6982-1-hsiangkao@aol.com>
References: <20190818014835.5874-1-hsiangkao@aol.com>
 <20190818015631.6982-1-hsiangkao@aol.com>
Message-ID: <20190818022055.GA14592@bombadil.infradead.org>

On Sun, Aug 18, 2019@09:56:31AM +0800, Gao Xiang wrote:
> @@ -82,8 +82,12 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
>  		unsigned int nameoff, maxsize;
>  
>  		dentry_page = read_mapping_page(mapping, i, NULL);
> -		if (IS_ERR(dentry_page))
> -			continue;
> +		if (IS_ERR(dentry_page)) {
> +			errln("fail to readdir of logical block %u of nid %llu",
> +			      i, EROFS_V(dir)->nid);
> +			err = PTR_ERR(dentry_page);
> +			break;

I don't think you want to use the errno that came back from
read_mapping_page() (which is, I think, always going to be -EIO).
Rather you want -EFSCORRUPTED, at least if I understand the recent
patches to ext2/ext4/f2fs/xfs/...
