From: hsiangkao@aol.com (Gao Xiang)
Date: Wed, 12 Dec 2018 01:05:13 +0800
Subject: [PATCH 4/5] drivers: staging: erofs: Fix parentheses error in
 macro
In-Reply-To: <df69ac6826a2ec20e29d1ded7a8e7ec63c73c2c4.camel@perches.com>
References: <0ed9f3e7-9081-4a8a-06b0-e5ad14e2c872@huawei.com>
 <20181211105443.21826-1-aaron.strahlberger@posteo.de>
 <20181211105443.21826-5-aaron.strahlberger@posteo.de>
 <dc56553c-a5ea-5265-5820-4bb481b0b948@huawei.com>
 <df69ac6826a2ec20e29d1ded7a8e7ec63c73c2c4.camel@perches.com>
Message-ID: <9d324f50-e632-c020-04b9-57269ff7bdca@aol.com>

Hi Joe,

On 2018/12/11 23:48, Joe Perches wrote:
> This macro is used only once and is merely obfuscation
> for that one use.  Please remove the macro and expand
> it in the one place it is used.

I am also considering to replace it in a plain way,
it will be more straight-forward to describe its on-disk format.

Thanks for your suggestion.

Thanks,
Gao Xiang
