From: linux@weissschuh.net (=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?=)
Date: Sun,  9 Sep 2018 20:34:32 +0200
Subject: [PATCH] MAINTAINERS: add tree location for staging/erofs
In-Reply-To: <5c44a63b-041d-1fce-0748-53c0b44f5983@huawei.com>
References: <5c44a63b-041d-1fce-0748-53c0b44f5983@huawei.com>
Message-ID: <20180909183432.9752-1-linux@weissschuh.net>

Hi Chao, hi Gao,

On Sun, 2018-09-09T23:16+0800, Chao Yu wrote:
> Hi Thomas,
>
> On 2018/9/8 11:28, Gao Xiang wrote:
>> Hi Thomas,
>>
>> Thanks for your new patch.
>>
>> It seems that this patch also introduces 2 new 'WARNING: line over 80 characters',
>> could you please fix it in the patch?

@Chao,Gao: For some reason there seems to be a problem when receiving mails
from you. The one I received now was the first one from you that reached me
directly. Before I only got your messages in the quotes from Dan and now in the
quotes from the mail I am responding to.
(I will try to investigate the reason for this)

Sorry for my slow responses before.

> It will be better to fix that.

A new patch will shortly follow.

> Some reviewed cleanup patches are merged before this patch, then I failed to add
> this one, so could you rebase on top of erofs dev branch in below link:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/chao/linux.git/log/?h=erofs

I was not aware of this tree and worked off of staging / next.
A patch is attached to this message that adds the tree to the MAINTAINERS file.

-- >8 --

Currently this location is not documented.

Signed-off-by: Thomas Wei?schuh <linux at weissschuh.net>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a5b256b25905..9087e0b74821 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13747,6 +13747,7 @@ F:	drivers/staging/comedi/
 STAGING - EROFS FILE SYSTEM
 M:	Gao Xiang <gaoxiang25 at huawei.com>
 M:	Chao Yu <yuchao0 at huawei.com>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/chao/linux.git erofs
 L:	linux-erofs at lists.ozlabs.org
 S:	Maintained
 F:	drivers/staging/erofs/
-- 
2.18.0
