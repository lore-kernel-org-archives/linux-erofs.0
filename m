From: sicilia.cristian@gmail.com (Cristian Sicilia)
Date: Mon, 12 Nov 2018 21:43:56 +0100
Subject: [PATCH 0/3] Clean up some syntax issue on unzip_vle.c
Message-ID: <1542055439-24444-1-git-send-email-sicilia.cristian@gmail.com>

This patch will do some syntax fix on unzip_vle.c file.
The first patch will produce the removeal of all comparison
with NULL constant prepending not operator for equals comparision.
The second patch move the constant comparison to the right side.
The third align some parameter with the previous parenthesis.

Cristian Sicilia (3):
  staging: erofs: unzip_vle.c: Replace comparison to NULL.
  staging: erofs: unzip_vle.c: Constant in comparison on right side
  staging: erofs: unzip_vle.c: Align parameter to the parentesis

 drivers/staging/erofs/unzip_vle.c | 105 +++++++++++++++++++-------------------
 1 file changed, 53 insertions(+), 52 deletions(-)

-- 
2.7.4
