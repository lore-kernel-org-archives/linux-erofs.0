From: jeremy@azazel.net (Jeremy Sowden)
Date: Tue,  8 Jan 2019 11:31:46 +0000
Subject: [PATCH v2 0/2] staging: erofs: fixed -Wmissing-prototype warnings.
Message-ID: <20190108113148.31166-1-jeremy@azazel.net>

Fixes for -Wmissing-prototype warnings in the erofs driver.  One group
of functions have been made static; for the second, prototypes have been
moved to a header file.

Changes since v1:

 * amended commit messages to ensure distinct e-mail subjects.

Jeremy Sowden (2):
  staging: erofs: fixed -Wmissing-prototype warnings by making functions
    static.
  staging: erofs: fixed -Wmissing-prototype warnings by moving
    prototypes to header file.

 drivers/staging/erofs/data.c          |  6 ------
 drivers/staging/erofs/internal.h      |  7 +++++++
 drivers/staging/erofs/unzip_vle.c     |  2 +-
 drivers/staging/erofs/unzip_vle_lz4.c |  2 +-
 drivers/staging/erofs/utils.c         | 14 ++++++--------
 5 files changed, 15 insertions(+), 16 deletions(-)

base-commit: c8c2702409430a6a2fd928e857f15773aaafcc99
-- 
2.20.1
