From: sashal@kernel.org (Sasha Levin)
Date: Wed, 23 Jan 2019 22:57:49 +0000
Subject: [PREVIEW] [PATCH] staging: erofs: fix mis-acted TAIL merging
 behavior
In-Reply-To: <20190122124530.5621-1-gaoxiang25@huawei.com>
References: <20190122124530.5621-1-gaoxiang25@huawei.com>
Message-ID: <20190123225749.DDDF6218A4@mail.kernel.org>

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 3883a79abd02 staging: erofs: introduce VLE decompression support.

The bot has tested the following trees: v4.20.3, v4.19.16.

v4.20.3: Build OK!
v4.19.16: Failed to apply! Possible dependencies:
    ab47dd2b0819 ("staging: erofs: cleanup z_erofs_vle_work_{lookup, register}")


How should we proceed with this patch?

--
Thanks,
Sasha
