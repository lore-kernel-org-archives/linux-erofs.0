From: sashal@kernel.org (Sasha Levin)
Date: Sat, 30 Mar 2019 13:45:27 +0000
Subject: [PATCH] staging: erofs: keep corrupted fs from crashing kernel in
 erofs_readdir()
In-Reply-To: <20190328201458.30629-1-hsiangkao@aol.com>
References: <20190328201458.30629-1-hsiangkao@aol.com>
Message-ID: <20190330134528.7F9A62173C@mail.kernel.org>

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 3aa8ec716e52 staging: erofs: add directory operations.

The bot has tested the following trees: v5.0.5, v4.19.32.

v5.0.5: Build OK!
v4.19.32: Failed to apply! Possible dependencies:
    6e78901a9f23 ("staging: erofs: separate erofs_get_meta_page")
    7dd68b147d60 ("staging: erofs: use explicit unsigned int type")
    8be31270362b ("staging: erofs: introduce erofs_grab_bio")
    ab47dd2b0819 ("staging: erofs: cleanup z_erofs_vle_work_{lookup, register}")


How should we proceed with this patch?

--
Thanks,
Sasha
