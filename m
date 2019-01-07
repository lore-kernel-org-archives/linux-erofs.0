From: jeremy@azazel.net (Jeremy Sowden)
Date: Mon,  7 Jan 2019 18:25:14 +0000
Subject: [PATCH 0/2] staging: erofs: fixed -Wmissing-prototype warnings.
Message-ID: <20190107182516.21511-1-jeremy@azazel.net>

Fixes for -Wmissing-prototype warnings in the erofs driver.  One group of
functions have been made static; for the second, prototypes have been moved to a
head

Jeremy Sowden (2):
  staging: erofs: fixed -Wmissing-prototype warnings.
  staging: erofs: fixed -Wmissing-prototype warnings.

 drivers/staging/erofs/data.c          |  6 ------
 drivers/staging/erofs/internal.h      |  7 +++++++
 drivers/staging/erofs/unzip_vle.c     |  2 +-
 drivers/staging/erofs/unzip_vle_lz4.c |  2 +-
 drivers/staging/erofs/utils.c         | 14 ++++++--------
 5 files changed, 15 insertions(+), 16 deletions(-)


base-commit: c8c2702409430a6a2fd928e857f15773aaafcc99
-- 
2.20.1
