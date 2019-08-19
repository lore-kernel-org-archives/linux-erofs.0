From: sashal@kernel.org (Sasha Levin)
Date: Mon, 19 Aug 2019 00:08:57 +0000
Subject: [PATCH v4] staging: erofs: fix an error handling in
 erofs_readdir()
In-Reply-To: <20190818125457.25906-1-hsiangkao@aol.com>
References: <20190818125457.25906-1-hsiangkao@aol.com>
Message-ID: <20190819000858.4066721852@mail.kernel.org>

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 3aa8ec716e52 staging: erofs: add directory operations.

The bot has tested the following trees: v5.2.9, v4.19.67.

v5.2.9: Build failed! Errors:
    drivers/staging/erofs/dir.c:109:11: error: ???EFSCORRUPTED??? undeclared (first use in this function); did you mean ???FS_NRSUPER????

v4.19.67: Build failed! Errors:
    drivers/staging/erofs/dir.c:109:11: error: ???EFSCORRUPTED??? undeclared (first use in this function); did you mean ???FS_NRSUPER????


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
