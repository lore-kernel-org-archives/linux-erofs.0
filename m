From: sashal@kernel.org (Sasha Levin)
Date: Sun, 18 Aug 2019 11:52:54 +0000
Subject: [PATCH v3 RESEND] staging: erofs: fix an error handling in
 erofs_readdir()
In-Reply-To: <20190818032111.9862-1-hsiangkao@aol.com>
References: <20190818032111.9862-1-hsiangkao@aol.com>
Message-ID: <20190818115254.F17FA2173B@mail.kernel.org>

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 3aa8ec716e52 staging: erofs: add directory operations.

The bot has tested the following trees: v5.2.9, v4.19.67.

v5.2.9: Build failed! Errors:
    drivers/staging/erofs/dir.c:111:11: error: ???EFSCORRUPTED??? undeclared (first use in this function); did you mean ???FS_NRSUPER????

v4.19.67: Build failed! Errors:
    drivers/staging/erofs/dir.c:111:11: error: ???EFSCORRUPTED??? undeclared (first use in this function); did you mean ???FS_NRSUPER????


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
