From: loic.tourlonias.lkml@gmail.com (Loic Tourlonias)
Date: Mon,  8 Oct 2018 16:14:09 +0200
Subject: [PATCH v2] staging: erofs: add SPDX identifer
Message-ID: <20181008141409.2624-1-loic.tourlonias.lkml@gmail.com>

Add SPDX identifier to simplify header and remove whole license text

v1 -> v2:

Move SPDX identifier to first line and change comment delimiter

Signed-off-by: Loic Tourlonias <loic.tourlonias.lkml at gmail.com>
---
 drivers/staging/erofs/lz4defs.h | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/erofs/lz4defs.h b/drivers/staging/erofs/lz4defs.h
index 00a0b58a0871..cdacc57e6a08 100644
--- a/drivers/staging/erofs/lz4defs.h
+++ b/drivers/staging/erofs/lz4defs.h
@@ -1,32 +1,12 @@
+/* SPDX-License-Identifier: BSD-2-Clause*/
 #ifndef __LZ4DEFS_H__
 #define __LZ4DEFS_H__
-
 /*
  * lz4defs.h -- common and architecture specific defines for the kernel usage
 
  * LZ4 - Fast LZ compression algorithm
  * Copyright (C) 2011-2016, Yann Collet.
- * BSD 2-Clause License (http://www.opensource.org/licenses/bsd-license.php)
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are
- * met:
- *	* Redistributions of source code must retain the above copyright
- *	  notice, this list of conditions and the following disclaimer.
- *	* Redistributions in binary form must reproduce the above
- * copyright notice, this list of conditions and the following disclaimer
- * in the documentation and/or other materials provided with the
- * distribution.
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
  * You can contact the author at :
  *	- LZ4 homepage : http://www.lz4.org
  *	- LZ4 source repository : https://github.com/lz4/lz4
-- 
2.17.1
