Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAAC606A332
	for <linux-erofs@archiver.kernel.org>; Fri,  6 Nov 2026 14:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=n13D/HUQ
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jLhkN1Nr8z2y71;
	Sat, 07 Nov 2026 01:43:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=210.118.77.11
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793976204;
	cv=none; b=WfdbG2Ikc/tEhYYYWxA36dGJGuLSwcYSpb7F30xGlTR59tvMTS45HNRey1HqCzCx9I4iD1G2IlofAj8OMQd544105EJfnDjm+r3sP3gJRAoycT8cIyw4pKsJudg+f3Lxix3dkbJiUHvkkS1jJa8CprnBChsaoXPAU5CxJ8+/HEi8t+AlfY29h4wT0mMhrS7R9Os+NLRkm1fGycQOe2+Pwv2eoPRrWUJQ76Onb8L1RZN6+ct3qL5HRjmaUUypK7FiYQUco48oVgl5O+RcjHLQ/OnwhFBwt6Uhqc93v8JIIrdwpjuoYv1avrqe1DQFEK1u+kvRtiuVQc1et6QJUNpgew==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793976204; c=relaxed/relaxed;
	bh=up0bypD0w4MbuxMJmbcYp1qKVPmLDXcUCmPyh+TIxbU=;
	h=From:Date:Subject:MIME-Version:Message-Id:In-Reply-To:To:Cc:
	 Content-Type:References; b=GUSYE99I8NWXLa80C0FUWVcpf45jsaNPZeJQfwyERgSlyOiGmf6tlffrZKOso1UmWvvSTCD4NASCjKDWkK/tfRuQ8fozq4P7mDFX9qYpC3TGymoRslzC1Dd3CxmJxZO/2SMG8TkRTRsEDOcbY91pMVroeKm0QVfYLSpilWbcwW/KpFWzFm+uT2pidwDStzyQRyDo8kQ20LvJvoX5NZaD+nOf20iEBj3SxBHAFyjHmp/HM3r6DRnIfRiw4gZy2jhsGWtcljZjUv/4p1inANVfTGcExmgSNYXsvJmQdQH7AuLopaX7YNtRzq3Kfl1S4gzRWQmFnBMtKh/GDaYddjxP2Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com; dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=n13D/HUQ; dkim-atps=neutral; spf=pass (client-ip=210.118.77.11; helo=mailout1.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org) smtp.mailfrom=samsung.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=n13D/HUQ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=samsung.com (client-ip=210.118.77.11; helo=mailout1.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jLhkM189Nz2yDs
	for <linux-erofs@lists.ozlabs.org>; Sat, 07 Nov 2026 01:43:23 +1100 (AEDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261106144313euoutp01609be1926bb6af1c0e08a55213877a47~le9fWhqkE2134921349euoutp01I;
	Fri,  6 Nov 2026 14:43:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261106144313euoutp01609be1926bb6af1c0e08a55213877a47~le9fWhqkE2134921349euoutp01I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793976193;
	bh=up0bypD0w4MbuxMJmbcYp1qKVPmLDXcUCmPyh+TIxbU=;
	h=From:Date:Subject:In-Reply-To:To:Cc:References:From;
	b=n13D/HUQT4qG8TsybwN9p3MSA3PMoh7Jn7AHMiqfgv3mw6zDye1isI8+PO+xE6nRP
	 FeswtF6L761fRPLwwChHR9wM7agGc74cXBC8kujH7talPGggPwwtE3u0XTghLfMNQf
	 b6BBhHfA5SAmlqpsglXuUoN53JI9/Rd6CbWTS9kw=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261106144312eucas1p26109d26cecef034bf7734283cb04b211~le9eXhZVO3079930799eucas1p2r;
	Fri,  6 Nov 2026 14:43:12 +0000 (GMT)
Received: from AMDC4942.eu.corp.samsungelectronics.net (unknown
	[106.210.136.40]) by eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261106144310eusmtip1ef57e68a1a7cd88e3cc55dc4c661e6bc~le9cgyZ493253232532eusmtip1W;
	Fri,  6 Nov 2026 14:43:10 +0000 (GMT)
From: Michal Wilczynski <m.wilczynski@samsung.com>
Date: Fri, 06 Nov 2026 15:42:54 +0100
Subject: [PATCH v2 14/15] lib/lz4: replace lz4_kernel_api.h's prototypes
 with <linux/lz4.h>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-lz4-vendor-upstream-v2-14-ee04c3f0d7dc@samsung.com>
In-Reply-To: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
To: Michal Wilczynski <m.wilczynski@samsung.com>,  Nathan Chancellor
	<nathan@kernel.org>,  Nick Desaulniers <ndesaulniers@google.com>,  Bill
	Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,  Russell
	King <linux@armlinux.org.uk>,  Thomas Bogendoerfer
	<tsbogend@alpha.franken.de>,  "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,  Helge Deller <deller@gmx.de>,
	Heiko Carstens <hca@linux.ibm.com>,  Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>,  Christian Borntraeger
	<borntraeger@linux.ibm.com>,  Sven Schnelle <svens@linux.ibm.com>, Thomas
	Gleixner <tglx@kernel.org>,  Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>,  Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Minchan Kim <minchan@kernel.org>,  Sergey
	Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	linux-block@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>,  Nick
	Terrell <terrelln@meta.com>, Gao Xiang <xiang@kernel.org>,  Chao Yu
	<chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,  Eric Biggers
	<ebiggers@kernel.org>,  Herbert Xu <herbert@gondor.apana.org.au>,  David
	Laight <david.laight.linux@gmail.com>,  Sungguk <sungguk.na@samsung.com>,
	Jaehoon Chung <jh80.chung@samsung.com>,  Marek Szyprowski
	<m.szyprowski@samsung.com>, linux-erofs@lists.ozlabs.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=7312;
	i=m.wilczynski@samsung.com; h=from:subject:message-id;
	bh=evukEav2ZpAAeGL576jqRy7FW4GV2dVQQnisPOQ1yNI=;
	b=owGbwMvMwCGWumv6zndzRCIZT6slMWS9fZ6q3DhvMZ9VdZyu9bGM93wym+KneB2qvXpu/4595
	xjmOP8/21HKwiDGwSArpshydmO0keQ/hqflxx//gpnDygQyhIGLUwAmwqbCyLC5dJJdpvSZGU1X
	5BM1NwZmKOgaJW66N7Hk5FZusdeBa5UZ/sc6s8suuljt8Yb1b/zPor1HU+6a3ZmaL/PBcIbSW8F
	vd9gA
X-Developer-Key: i=m.wilczynski@samsung.com; a=openpgp;
	fpr=CDB15B3219FE00E577C7E3FA65BA97B9EE9C1459
X-CMS-MailID: 20261106144312eucas1p26109d26cecef034bf7734283cb04b211
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261106144312eucas1p26109d26cecef034bf7734283cb04b211
X-EPHeader: CA
X-CMS-RootMailID: 20261106144312eucas1p26109d26cecef034bf7734283cb04b211
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
	<CGME20261106144312eucas1p26109d26cecef034bf7734283cb04b211@eucas1p2.samsung.com>
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

lz4_kernel_api.h carried its own copy of the twenty public prototypes
because it could not include <linux/lz4.h>, which defined the stream
types that upstream's headers also define.

The types are incomplete now, so it can. Two prototype lists for one
ABI is a drift hazard: the entry points were built against one and their
callers against the other, so no compiler ever saw both, and MODVERSIONS
would not catch a mismatch either, since it hashes the exporter's view
only. Now there is one list.

It also puts the public constants in scope of the entry points, so the
size assertions can name them, and the HC level clamp can use
LZ4HC_CLAMP_CLEVEL, static_asserted equal to upstream's
LZ4HC_CLEVEL_OPT_MIN.

Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
---
 lib/lz4/lz4_compress.c   |  2 +-
 lib/lz4/lz4_decompress.c |  2 +-
 lib/lz4/lz4_kernel_api.h | 64 +++---------------------------------------------
 lib/lz4/lz4hc_compress.c |  8 +++---
 4 files changed, 11 insertions(+), 65 deletions(-)

diff --git a/lib/lz4/lz4_compress.c b/lib/lz4/lz4_compress.c
index 941e32a19ac972aef543c9a03b447a8a98bf5215..3e272584ea0c905b48b6bf0b7e77acfbad131bd1 100644
--- a/lib/lz4/lz4_compress.c
+++ b/lib/lz4/lz4_compress.c
@@ -30,7 +30,7 @@
 
 /* Catch any divergence from upstream's layout at build time. */
 static_assert(sizeof(LZ4_stream_t) == LZ4_STREAM_MINSIZE);
-static_assert(LZ4_STREAM_MINSIZE == 16416); /* LZ4_MEM_COMPRESS */
+static_assert(LZ4_STREAM_MINSIZE == LZ4_MEM_COMPRESS);
 
 /* LZ4_initStream() returns NULL for a misaligned state, which
  * LZ4_compress_fast_extState() dereferences and
diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index 60b57862a2e387aa89fa26f6f8e2b5485b5d9995..5d68a6f59a62ddb3701dd3531cf606c05ef4e607 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -31,7 +31,7 @@
 #endif
 
 static_assert(sizeof(LZ4_streamDecode_t) == LZ4_STREAMDECODE_MINSIZE);
-static_assert(LZ4_STREAMDECODE_MINSIZE == 32); /* LZ4_MEM_DECOMPRESS */
+static_assert(LZ4_STREAMDECODE_MINSIZE == LZ4_MEM_DECOMPRESS);
 
 int LZ4_decompress_safe(const char *source, char *dest, int compressedSize,
 			int maxDecompressedSize)
diff --git a/lib/lz4/lz4_kernel_api.h b/lib/lz4/lz4_kernel_api.h
index de75e5d976eb9dd318da5318a26b91d7aed81042..43605a0e4d7f543662af83251184968f0d1b70dd 100644
--- a/lib/lz4/lz4_kernel_api.h
+++ b/lib/lz4/lz4_kernel_api.h
@@ -3,19 +3,10 @@
  * Copyright (c) 2026 Samsung Electronics Co., Ltd.
  * Author: Michal Wilczynski <m.wilczynski@samsung.com>
  *
- * lz4_kernel_api.h -- the LZ4 API this directory exports
+ * lz4_kernel_api.h -- hand the LZ4 names back to the kernel
  *
- * lz4_deps.h renames upstream's entry points to __lz4_* so that the kernel's
- * own definitions can use the real names; this header undoes that renaming
- * and the optimize() override, and declares what lib/lz4 exports.
- *
- * The same functions are declared to callers in <linux/lz4.h>, in terms of
- * opaque stream types.  We cannot include that header here -- it and
- * upstream's lz4.h describe the same library and collide -- so the
- * declarations are repeated, expressed in upstream's own types.  Keep the two
- * in step; <linux/lz4.h> is the one callers compile against.
- *
- * Include after upstream/lz4.c or upstream/lz4hc.c.
+ * Undo lz4_deps.h's renaming and its optimize() override, and pull in
+ * <linux/lz4.h>.  Include after upstream/lz4.c or upstream/lz4hc.c.
  */
 
 #undef LZ4_compress_fast
@@ -40,51 +31,4 @@
 
 #undef optimize
 
-/*
- * The objects that do not build lz4hc.c never see this type, and it is only
- * ever used through a pointer here.  Upstream declares it the same way.
- */
-typedef union LZ4_streamHC_u LZ4_streamHC_t;
-
-/* Compression.  wrkmem is LZ4_MEM_COMPRESS bytes, supplied by the caller. */
-int LZ4_compress_default(const char *source, char *dest, int inputSize,
-			 int maxOutputSize, void *wrkmem);
-int LZ4_compress_fast(const char *source, char *dest, int inputSize,
-		      int maxOutputSize, int acceleration, void *wrkmem);
-int LZ4_compress_destSize(const char *source, char *dest, int *sourceSizePtr,
-			  int targetDestSize, void *wrkmem);
-
-/* Streaming compression. */
-void LZ4_resetStream(LZ4_stream_t *LZ4_stream);
-int LZ4_loadDict(LZ4_stream_t *streamPtr, const char *dictionary,
-		 int dictSize);
-int LZ4_saveDict(LZ4_stream_t *streamPtr, char *safeBuffer, int dictSize);
-int LZ4_compress_fast_continue(LZ4_stream_t *streamPtr, const char *src,
-			       char *dst, int srcSize, int maxDstSize,
-			       int acceleration);
-
-/* Decompression. */
-int LZ4_decompress_safe(const char *source, char *dest, int compressedSize,
-			int maxDecompressedSize);
-int LZ4_decompress_safe_partial(const char *source, char *dest,
-				int compressedSize, int targetOutputSize,
-				int maxDecompressedSize);
-int LZ4_setStreamDecode(LZ4_streamDecode_t *LZ4_streamDecode,
-			const char *dictionary, int dictSize);
-int LZ4_decompress_safe_continue(LZ4_streamDecode_t *LZ4_streamDecode,
-				 const char *source, char *dest,
-				 int compressedSize, int maxDecompressedSize);
-int LZ4_decompress_safe_usingDict(const char *source, char *dest,
-				  int compressedSize, int maxDecompressedSize,
-				  const char *dictStart, int dictSize);
-
-/* HC compression.  wrkmem is LZ4HC_MEM_COMPRESS bytes. */
-int LZ4_compress_HC(const char *src, char *dst, int srcSize, int dstCapacity,
-		    int compressionLevel, void *wrkmem);
-void LZ4_resetStreamHC(LZ4_streamHC_t *streamHCPtr, int compressionLevel);
-int LZ4_loadDictHC(LZ4_streamHC_t *streamHCPtr, const char *dictionary,
-		   int dictSize);
-int LZ4_compress_HC_continue(LZ4_streamHC_t *streamHCPtr, const char *src,
-			     char *dst, int srcSize, int maxDstSize);
-int LZ4_saveDictHC(LZ4_streamHC_t *streamHCPtr, char *safeBuffer,
-		   int maxDictSize);
+#include <linux/lz4.h>
diff --git a/lib/lz4/lz4hc_compress.c b/lib/lz4/lz4hc_compress.c
index 4d56d45028110805628be766b2758a8dffd56f0c..4f40a12df17cfed2bab7f5d87ac087b4d423cef7 100644
--- a/lib/lz4/lz4hc_compress.c
+++ b/lib/lz4/lz4hc_compress.c
@@ -39,7 +39,7 @@ static int LZ4_compressBound(int isize)
 
 /* Catch any divergence from upstream's layout at build time. */
 static_assert(sizeof(LZ4_streamHC_t) == LZ4_STREAMHC_MINSIZE);
-static_assert(LZ4_STREAMHC_MINSIZE == 262200); /* LZ4HC_MEM_COMPRESS */
+static_assert(LZ4_STREAMHC_MINSIZE == LZ4HC_MEM_COMPRESS);
 
 /* Levels >= LZ4HC_CLEVEL_OPT_MIN (10) reach the optimal parser, which needs
  * a ~64K opt[]: too big for a kernel stack, and in the heap mode lz4_deps.h
@@ -48,10 +48,12 @@ static_assert(LZ4_STREAMHC_MINSIZE == 262200); /* LZ4HC_MEM_COMPRESS */
  * working.  Levels 3..9 keep their meaning; 1 and 2 are upstream's lz4mid,
  * faster and weaker than the shallow hash chain the fork used for them.
  */
+static_assert(LZ4HC_CLAMP_CLEVEL == LZ4HC_CLEVEL_OPT_MIN);
+
 static int lz4hc_clamp_level(int compressionLevel)
 {
-	if (compressionLevel >= LZ4HC_CLEVEL_OPT_MIN)
-		return LZ4HC_CLEVEL_OPT_MIN - 1;
+	if (compressionLevel >= LZ4HC_CLAMP_CLEVEL)
+		return LZ4HC_CLAMP_CLEVEL - 1;
 
 	return compressionLevel;
 }

-- 
2.34.1


