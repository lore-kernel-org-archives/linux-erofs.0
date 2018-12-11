From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 11 Dec 2018 19:22:04 +0800
Subject: [PATCH 2/5] drivers: staging: erofs: Fix comparison to NULL
 issues.
In-Reply-To: <20181211105443.21826-3-aaron.strahlberger@posteo.de>
References: <0ed9f3e7-9081-4a8a-06b0-e5ad14e2c872@huawei.com>
 <20181211105443.21826-1-aaron.strahlberger@posteo.de>
 <20181211105443.21826-3-aaron.strahlberger@posteo.de>
Message-ID: <fcfd717b-13ed-a189-a056-13edca9b08b7@huawei.com>

Hi Aaron,

On 2018/12/11 18:54, Aaron Strahlberger wrote:
> Fix of 7 `CHECK: Comparison to NULL could be written ...` issues.
> 
> Signed-off-by: Aaron Strahlberger <aaron.strahlberger at posteo.de>
> Signed-off-by: Julius Wiedmann <julius.wiedmann at fau.de>
> Signed-off-by: Dominik Huber <domi250 at gmx.de>
> ---
>  drivers/staging/erofs/data.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)

It has been fixed in the following upstreamed commit...
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/commit/drivers/staging/erofs/data.c?h=staging-next&id=d1ab82443bed2b2562e5331d6aa53e3b878b16d0

and the "git am -k -3" log
[gaoxiang at 138 linux-staging]$ git am -k -3 1.patch
Applying: Fix of 7 `CHECK: Comparison to NULL could be written ...` issues.
Using index info to reconstruct a base tree...
M       drivers/staging/erofs/data.c
Falling back to patching base and 3-way merge...
No changes -- Patch already applied.


Thanks,
Gao Xiang
