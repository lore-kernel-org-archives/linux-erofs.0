From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 24 Jul 2018 10:36:39 +0800
Subject: [RFC PATCH 19/25] staging: erofs: introduce a customized LZ4
 decompression
In-Reply-To: <1532399805-65674-1-git-send-email-gaoxiang25@huawei.com>
References: <1532399805-65674-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1532399805-65674-20-git-send-email-gaoxiang25@huawei.com>

We have to reduce the memory cost as much as possible,
so we don't want to decompress more data beyond
the output buffer size, however "LZ4_decompress_safe_partial"
doesn't guarantee to stop at the arbitary end position,
but stop just after its current LZ4 "sequence" is completed.

Link: https://groups.google.com/forum/#!topic/lz4c/_3kkz5N6n00

Therefore, I hacked the LZ4 decompression logic by hand,
probably NOT the fastest approach, and hope for better
implementation.

Signed-off-by: Miao Xie <miaoxie at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/Makefile    |   2 +-
 drivers/staging/erofs/lz4defs.h   | 227 ++++++++++++++++++++++++++++++++++
 drivers/staging/erofs/unzip_lz4.c | 251 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 479 insertions(+), 1 deletion(-)
 create mode 100644 drivers/staging/erofs/lz4defs.h
 create mode 100644 drivers/staging/erofs/unzip_lz4.c

diff --git a/drivers/staging/erofs/Makefile b/drivers/staging/erofs/Makefile
index 490fa6c..e409637 100644
--- a/drivers/staging/erofs/Makefile
+++ b/drivers/staging/erofs/Makefile
@@ -9,5 +9,5 @@ obj-$(CONFIG_EROFS_FS) += erofs.o
 ccflags-y += -I$(src)/include
 erofs-objs := super.o inode.o data.o namei.o dir.o utils.o
 erofs-$(CONFIG_EROFS_FS_XATTR) += xattr.o
-erofs-$(CONFIG_EROFS_FS_ZIP) += unzip_vle.o
+erofs-$(CONFIG_EROFS_FS_ZIP) += unzip_vle.o unzip_lz4.o
 
diff --git a/drivers/staging/erofs/lz4defs.h b/drivers/staging/erofs/lz4defs.h
new file mode 100644
index 0000000..00a0b58
--- /dev/null
+++ b/drivers/staging/erofs/lz4defs.h
@@ -0,0 +1,227 @@
+#ifndef __LZ4DEFS_H__
+#define __LZ4DEFS_H__
+
+/*
+ * lz4defs.h -- common and architecture specific defines for the kernel usage
+
+ * LZ4 - Fast LZ compression algorithm
+ * Copyright (C) 2011-2016, Yann Collet.
+ * BSD 2-Clause License (http://www.opensource.org/licenses/bsd-license.php)
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are
+ * met:
+ *	* Redistributions of source code must retain the above copyright
+ *	  notice, this list of conditions and the following disclaimer.
+ *	* Redistributions in binary form must reproduce the above
+ * copyright notice, this list of conditions and the following disclaimer
+ * in the documentation and/or other materials provided with the
+ * distribution.
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * You can contact the author at :
+ *	- LZ4 homepage : http://www.lz4.org
+ *	- LZ4 source repository : https://github.com/lz4/lz4
+ *
+ *	Changed for kernel usage by:
+ *	Sven Schmidt <4sschmid at informatik.uni-hamburg.de>
+ */
+
+#include <asm/unaligned.h>
+#include <linux/string.h>	 /* memset, memcpy */
+
+#define FORCE_INLINE __always_inline
+
+/*-************************************
+ *	Basic Types
+ **************************************/
+#include <linux/types.h>
+
+typedef	uint8_t BYTE;
+typedef uint16_t U16;
+typedef uint32_t U32;
+typedef	int32_t S32;
+typedef uint64_t U64;
+typedef uintptr_t uptrval;
+
+/*-************************************
+ *	Architecture specifics
+ **************************************/
+#if defined(CONFIG_64BIT)
+#define LZ4_ARCH64 1
+#else
+#define LZ4_ARCH64 0
+#endif
+
+#if defined(__LITTLE_ENDIAN)
+#define LZ4_LITTLE_ENDIAN 1
+#else
+#define LZ4_LITTLE_ENDIAN 0
+#endif
+
+/*-************************************
+ *	Constants
+ **************************************/
+#define MINMATCH 4
+
+#define WILDCOPYLENGTH 8
+#define LASTLITERALS 5
+#define MFLIMIT (WILDCOPYLENGTH + MINMATCH)
+
+/* Increase this value ==> compression run slower on incompressible data */
+#define LZ4_SKIPTRIGGER 6
+
+#define HASH_UNIT sizeof(size_t)
+
+#define KB (1 << 10)
+#define MB (1 << 20)
+#define GB (1U << 30)
+
+#define MAXD_LOG 16
+#define MAX_DISTANCE ((1 << MAXD_LOG) - 1)
+#define STEPSIZE sizeof(size_t)
+
+#define ML_BITS	4
+#define ML_MASK	((1U << ML_BITS) - 1)
+#define RUN_BITS (8 - ML_BITS)
+#define RUN_MASK ((1U << RUN_BITS) - 1)
+
+/*-************************************
+ *	Reading and writing into memory
+ **************************************/
+static FORCE_INLINE U16 LZ4_read16(const void *ptr)
+{
+	return get_unaligned((const U16 *)ptr);
+}
+
+static FORCE_INLINE U32 LZ4_read32(const void *ptr)
+{
+	return get_unaligned((const U32 *)ptr);
+}
+
+static FORCE_INLINE size_t LZ4_read_ARCH(const void *ptr)
+{
+	return get_unaligned((const size_t *)ptr);
+}
+
+static FORCE_INLINE void LZ4_write16(void *memPtr, U16 value)
+{
+	put_unaligned(value, (U16 *)memPtr);
+}
+
+static FORCE_INLINE void LZ4_write32(void *memPtr, U32 value)
+{
+	put_unaligned(value, (U32 *)memPtr);
+}
+
+static FORCE_INLINE U16 LZ4_readLE16(const void *memPtr)
+{
+	return get_unaligned_le16(memPtr);
+}
+
+static FORCE_INLINE void LZ4_writeLE16(void *memPtr, U16 value)
+{
+	return put_unaligned_le16(value, memPtr);
+}
+
+static FORCE_INLINE void LZ4_copy8(void *dst, const void *src)
+{
+#if LZ4_ARCH64
+	U64 a = get_unaligned((const U64 *)src);
+
+	put_unaligned(a, (U64 *)dst);
+#else
+	U32 a = get_unaligned((const U32 *)src);
+	U32 b = get_unaligned((const U32 *)src + 1);
+
+	put_unaligned(a, (U32 *)dst);
+	put_unaligned(b, (U32 *)dst + 1);
+#endif
+}
+
+/*
+ * customized variant of memcpy,
+ * which can overwrite up to 7 bytes beyond dstEnd
+ */
+static FORCE_INLINE void LZ4_wildCopy(void *dstPtr,
+	const void *srcPtr, void *dstEnd)
+{
+	BYTE *d = (BYTE *)dstPtr;
+	const BYTE *s = (const BYTE *)srcPtr;
+	BYTE *const e = (BYTE *)dstEnd;
+
+	do {
+		LZ4_copy8(d, s);
+		d += 8;
+		s += 8;
+	} while (d < e);
+}
+
+static FORCE_INLINE unsigned int LZ4_NbCommonBytes(register size_t val)
+{
+#if LZ4_LITTLE_ENDIAN
+	return __ffs(val) >> 3;
+#else
+	return (BITS_PER_LONG - 1 - __fls(val)) >> 3;
+#endif
+}
+
+static FORCE_INLINE unsigned int LZ4_count(
+	const BYTE *pIn,
+	const BYTE *pMatch,
+	const BYTE *pInLimit)
+{
+	const BYTE *const pStart = pIn;
+
+	while (likely(pIn < pInLimit - (STEPSIZE - 1))) {
+		size_t const diff = LZ4_read_ARCH(pMatch) ^ LZ4_read_ARCH(pIn);
+
+		if (!diff) {
+			pIn += STEPSIZE;
+			pMatch += STEPSIZE;
+			continue;
+		}
+
+		pIn += LZ4_NbCommonBytes(diff);
+
+		return (unsigned int)(pIn - pStart);
+	}
+
+#if LZ4_ARCH64
+	if ((pIn < (pInLimit - 3))
+		&& (LZ4_read32(pMatch) == LZ4_read32(pIn))) {
+		pIn += 4;
+		pMatch += 4;
+	}
+#endif
+
+	if ((pIn < (pInLimit - 1))
+		&& (LZ4_read16(pMatch) == LZ4_read16(pIn))) {
+		pIn += 2;
+		pMatch += 2;
+	}
+
+	if ((pIn < pInLimit) && (*pMatch == *pIn))
+		pIn++;
+
+	return (unsigned int)(pIn - pStart);
+}
+
+typedef enum { noLimit = 0, limitedOutput = 1 } limitedOutput_directive;
+typedef enum { byPtr, byU32, byU16 } tableType_t;
+
+typedef enum { noDict = 0, withPrefix64k, usingExtDict } dict_directive;
+typedef enum { noDictIssue = 0, dictSmall } dictIssue_directive;
+
+typedef enum { endOnOutputSize = 0, endOnInputSize = 1 } endCondition_directive;
+typedef enum { full = 0, partial = 1 } earlyEnd_directive;
+
+#endif
diff --git a/drivers/staging/erofs/unzip_lz4.c b/drivers/staging/erofs/unzip_lz4.c
new file mode 100644
index 0000000..b01a8d9
--- /dev/null
+++ b/drivers/staging/erofs/unzip_lz4.c
@@ -0,0 +1,251 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * linux/drivers/staging/erofs/unzip_lz4.c
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ *
+ * Original code taken from 'linux/lib/lz4/lz4_decompress.c'
+ */
+
+/*
+ * LZ4 - Fast LZ compression algorithm
+ * Copyright (C) 2011 - 2016, Yann Collet.
+ * BSD 2 - Clause License (http://www.opensource.org/licenses/bsd - license.php)
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are
+ * met:
+ *	* Redistributions of source code must retain the above copyright
+ *	  notice, this list of conditions and the following disclaimer.
+ *	* Redistributions in binary form must reproduce the above
+ * copyright notice, this list of conditions and the following disclaimer
+ * in the documentation and/or other materials provided with the
+ * distribution.
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * You can contact the author at :
+ *	- LZ4 homepage : http://www.lz4.org
+ *	- LZ4 source repository : https://github.com/lz4/lz4
+ *
+ *	Changed for kernel usage by:
+ *	Sven Schmidt <4sschmid at informatik.uni-hamburg.de>
+ */
+#include "internal.h"
+#include <asm/unaligned.h>
+#include "lz4defs.h"
+
+/*
+ * no public solution to solve our requirement yet.
+ * see: <required buffer size for LZ4_decompress_safe_partial>
+ *      https://groups.google.com/forum/#!topic/lz4c/_3kkz5N6n00
+ */
+static FORCE_INLINE int customized_lz4_decompress_safe_partial(
+	const void * const source,
+	void * const dest,
+	int inputSize,
+	int outputSize)
+{
+	/* Local Variables */
+	const BYTE *ip = (const BYTE *) source;
+	const BYTE * const iend = ip + inputSize;
+
+	BYTE *op = (BYTE *) dest;
+	BYTE * const oend = op + outputSize;
+	BYTE *cpy;
+
+	static const unsigned int dec32table[] = { 0, 1, 2, 1, 4, 4, 4, 4 };
+	static const int dec64table[] = { 0, 0, 0, -1, 0, 1, 2, 3 };
+
+	/* Empty output buffer */
+	if (unlikely(outputSize == 0))
+		return ((inputSize == 1) && (*ip == 0)) ? 0 : -1;
+
+	/* Main Loop : decode sequences */
+	while (1) {
+		size_t length;
+		const BYTE *match;
+		size_t offset;
+
+		/* get literal length */
+		unsigned int const token = *ip++;
+
+		length = token>>ML_BITS;
+
+		if (length == RUN_MASK) {
+			unsigned int s;
+
+			do {
+				s = *ip++;
+				length += s;
+			} while ((ip < iend - RUN_MASK) & (s == 255));
+
+			if (unlikely((size_t)(op + length) < (size_t)(op))) {
+				/* overflow detection */
+				goto _output_error;
+			}
+			if (unlikely((size_t)(ip + length) < (size_t)(ip))) {
+				/* overflow detection */
+				goto _output_error;
+			}
+		}
+
+		/* copy literals */
+		cpy = op + length;
+		if ((cpy > oend - WILDCOPYLENGTH) ||
+			(ip + length > iend - (2 + 1 + LASTLITERALS))) {
+			if (cpy > oend) {
+				memcpy(op, ip, length = oend - op);
+				op += length;
+				break;
+			}
+
+			if (unlikely(ip + length > iend)) {
+				/*
+				 * Error :
+				 * read attempt beyond
+				 * end of input buffer
+				 */
+				goto _output_error;
+			}
+
+			memcpy(op, ip, length);
+			ip += length;
+			op += length;
+
+			if (ip > iend - 2)
+				break;
+			/* Necessarily EOF, due to parsing restrictions */
+			/* break; */
+		} else {
+			LZ4_wildCopy(op, ip, cpy);
+			ip += length;
+			op = cpy;
+		}
+
+		/* get offset */
+		offset = LZ4_readLE16(ip);
+		ip += 2;
+		match = op - offset;
+
+		if (unlikely(match < (const BYTE *)dest)) {
+			/* Error : offset outside buffers */
+			goto _output_error;
+		}
+
+		/* get matchlength */
+		length = token & ML_MASK;
+		if (length == ML_MASK) {
+			unsigned int s;
+
+			do {
+				s = *ip++;
+
+				if (ip > iend - LASTLITERALS)
+					goto _output_error;
+
+				length += s;
+			} while (s == 255);
+
+			if (unlikely((size_t)(op + length) < (size_t)op)) {
+				/* overflow detection */
+				goto _output_error;
+			}
+		}
+
+		length += MINMATCH;
+
+		/* copy match within block */
+		cpy = op + length;
+
+		if (unlikely(cpy >= oend - WILDCOPYLENGTH)) {
+			if (cpy >= oend) {
+				while (op < oend)
+					*op++ = *match++;
+				break;
+			}
+			goto __match;
+		}
+
+		/* costs ~1%; silence an msan warning when offset == 0 */
+		LZ4_write32(op, (U32)offset);
+
+		if (unlikely(offset < 8)) {
+			const int dec64 = dec64table[offset];
+
+			op[0] = match[0];
+			op[1] = match[1];
+			op[2] = match[2];
+			op[3] = match[3];
+			match += dec32table[offset];
+			memcpy(op + 4, match, 4);
+			match -= dec64;
+		} else {
+			LZ4_copy8(op, match);
+			match += 8;
+		}
+
+		op += 8;
+
+		if (unlikely(cpy > oend - 12)) {
+			BYTE * const oCopyLimit = oend - (WILDCOPYLENGTH - 1);
+
+			if (op < oCopyLimit) {
+				LZ4_wildCopy(op, match, oCopyLimit);
+				match += oCopyLimit - op;
+				op = oCopyLimit;
+			}
+__match:
+			while (op < cpy)
+				*op++ = *match++;
+		} else {
+			LZ4_copy8(op, match);
+
+			if (length > 16)
+				LZ4_wildCopy(op + 8, match + 8, cpy);
+		}
+
+		op = cpy; /* correction */
+	}
+	DBG_BUGON((void *)ip - source > inputSize);
+	DBG_BUGON((void *)op - dest > outputSize);
+
+	/* Nb of output bytes decoded */
+	return (int) ((void *)op - dest);
+
+	/* Overflow error detected */
+_output_error:
+	return -ERANGE;
+}
+
+int z_erofs_unzip_lz4(void *in, void *out, size_t inlen, size_t outlen)
+{
+	int ret = customized_lz4_decompress_safe_partial(in,
+		out, inlen, outlen);
+
+	if (ret >= 0)
+		return ret;
+
+	/*
+	 * LZ4_decompress_safe will return an error code
+	 * (< 0) if decompression failed
+	 */
+	errln("%s, failed to decompress, in[%p, %lu] outlen[%p, %lu]",
+	      __func__, in, inlen, out, outlen);
+	WARN_ON(1);
+	print_hex_dump(KERN_DEBUG, "raw data [in]: ", DUMP_PREFIX_OFFSET,
+		16, 1, in, inlen, true);
+	print_hex_dump(KERN_DEBUG, "raw data [out]: ", DUMP_PREFIX_OFFSET,
+		16, 1, out, outlen, true);
+	return -EIO;
+}
+
-- 
1.9.1
