From: aaron.strahlberger@posteo.de (Aaron Strahlberger)
Date: Tue, 11 Dec 2018 11:54:38 +0100
Subject: [PATCH 0/5] drivers: staging: erofs: Fix styling issues
In-Reply-To: <0ed9f3e7-9081-4a8a-06b0-e5ad14e2c872@huawei.com>
References: <0ed9f3e7-9081-4a8a-06b0-e5ad14e2c872@huawei.com>
Message-ID: <20181211105443.21826-1-aaron.strahlberger@posteo.de>

Fixed several styling issues and one error, reported by checkpatch.pl.

Signed-off-by: Aaron Strahlberger <aaron.strahlberger at posteo.de>
Signed-off-by: Julius Wiedmann <julius.wiedmann at fau.de>
Signed-off-by: Dominik Huber <domi250 at gmx.de>

Aaron Strahlberger (5):
  drivers: staging: erofs: Fix alignment.
  drivers: staging: erofs: Fix comparison to NULL issues.
  drivers: staging: erofs: Fix spelling issue
  drivers: staging: erofs: Fix parentheses error in macro
  drivers: staging: erofs: Add blank line after function

 drivers/staging/erofs/data.c     | 65 ++++++++++++++++----------------
 drivers/staging/erofs/dir.c      | 12 +++---
 drivers/staging/erofs/erofs_fs.h |  5 ++-
 3 files changed, 42 insertions(+), 40 deletions(-)

-- 
2.19.2
