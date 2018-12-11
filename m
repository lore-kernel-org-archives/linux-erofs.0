From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 11 Dec 2018 17:18:27 +0800
Subject: [PATCH] drivers: staging: erofs: Fix styling issues
In-Reply-To: <20181211090627.2194-1-aaron.strahlberger@posteo.de>
References: <20181211090627.2194-1-aaron.strahlberger@posteo.de>
Message-ID: <0ed9f3e7-9081-4a8a-06b0-e5ad14e2c872@huawei.com>

Hi Aaron,

On 2018/12/11 17:06, Aaron Strahlberger wrote:
> Fixed following checkpatch.pl styling issues:
> 
> - 17x CHECK: Alignment should match open parenthesis
> -  7x CHECK: Comparison to NULL could be written ...
> -  1x CHECK: Lines should not end with a '('
> -  1x CHECK: Please use a blank line after ...
> 
> Signed-off-by: Aaron Strahlberger <aaron.strahlberger at posteo.de>
> Signed-off-by: Julius Wiedmann <julius.wiedmann at fau.de>
> Signed-off-by: Dominik Huber <domi250 at gmx.de>

Thanks for taking time to work on this submitted patch. :)

As a matter of practice, it is perfered to keep each patch
fixes one kind of these issues you found...separate into 4 patches could be better...

In addition, you need send to Greg Kroah-Hartman <gregkh at linuxfoundation.org>
for upstream...

Thanks,
Gao Xiang
