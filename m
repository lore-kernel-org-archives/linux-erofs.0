From: hch@lst.de (Christoph Hellwig)
Date: Fri, 16 Nov 2018 14:53:40 +0100
Subject: [PATCH V10 15/19] block: always define BIO_MAX_PAGES as 256
In-Reply-To: <20181115085306.9910-16-ming.lei@redhat.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-16-ming.lei@redhat.com>
Message-ID: <20181116135340.GL3165@lst.de>

> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 5040e9a2eb09..277921ad42e7 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -34,15 +34,7 @@
>  #define BIO_BUG_ON
>  #endif
>  
> -#ifdef CONFIG_THP_SWAP
> -#if HPAGE_PMD_NR > 256
> -#define BIO_MAX_PAGES		HPAGE_PMD_NR
> -#else
>  #define BIO_MAX_PAGES		256
> -#endif
> -#else
> -#define BIO_MAX_PAGES		256
> -#endif

Looks good.  This mess should have never gone in.

Reviewed-by: Christoph Hellwig <hch at lst.de>
