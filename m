From: willy@infradead.org (Matthew Wilcox)
Date: Thu, 28 Jun 2018 02:23:03 -0700
Subject: [RFC PATCH] <linux/taggedptr.h>: Introduce tagged pointer
In-Reply-To: <1530176789-107541-1-git-send-email-gaoxiang25@huawei.com>
References: <1530176789-107541-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <20180628092303.GD7646@bombadil.infradead.org>

On Thu, Jun 28, 2018@05:06:29PM +0800, Gao Xiang wrote:
> Therefore, this patch introduces simple generic methods to fold
> tags into a pointer integer. It currently reuses the last 2 bits
> of the pointer for tags, which are safely for all modern platforms.

The m68k people will have your head.  alignof(unsigned long) == 2 on
m68k.  Now, kmalloc always returns 8-byte aligned quantities, but
if you have:

static unsigned long foo;

then ((unsigned long)&foo & 2) may be non-zero.

> +/*
> + * mark these special integers as another type
> + * in order to highlight the tagged pointer usage.
> + */
> +typedef uintptr_t	taggedptr_t;

I find this a bit verbose.  How about tagptr_t ?
