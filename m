Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDCC606A330
	for <linux-erofs@archiver.kernel.org>; Fri,  6 Nov 2026 14:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=WQgmkKbc
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jLhkP0qq7z2yDs;
	Sat, 07 Nov 2026 01:43:25 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=210.118.77.11
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793976205;
	cv=none; b=MFT2GUNkHYQwR6Sr7Chxm6vFNWrk7s4Q4nsVLPhRoQEdyF7aG0QlXw+gCCJX0gtq9G7+Jczm4wDbPZgVmig2zriEvSlZMRI/z7IyYQOPQpDMtY9VYZAW8QpNwFY4QVQgBaJmb9gJR15TUN1PqMMfTzzp5pInYWMs/+HpBjQVZgeX9DLOMONLMp/4Buy5xPFdD1MowBLAl+Nn/mPECUUQPPb9BE+HwpIc6BzCZXhOj+zFPc9EnX4hJbOvLpvfIVWyKBZMiDzWGUqJlU5snY/zeV09b3wMALAvdSVTZ4kmGEsRArmPLymNf1+ZAq9r2Pf9A8yaIwrHLQroUKENTDp/jg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793976205; c=relaxed/relaxed;
	bh=GYgm5u58bPQ8KjrBy/61xpOFxkMjgCoTnwcTVNwoqbk=;
	h=From:Date:Subject:MIME-Version:Message-Id:In-Reply-To:To:Cc:
	 Content-Type:References; b=U62T9i4BnK7SqfTH/GzusLWRdoyKfwnz2wO26fKBfTeFysi4CuK/s/43zgozWaJU/ZQep5Bc18THuvjrPt9jLXWz1k+5HLkCIbdf/YIvzQE/r/tYfwezGuKSo7YlbPuLxgiUsyEL5JDnbtEOMcMAd5c74rkQ2KX1hh8sAZdODZAC/4vWFp1e3Bq90wF5918bJScQf3EVKusBGhw+R+vkzlzUEsvtLgInkUNtGH/wBn0RxtCgh5qZ9ATLGbch3nFFFfIXzEouIHGLdY/Z/adwz3kzAJv7Iq3L6U6tmk/+jgtrwSfUVGlB/VtzgmVmIgmTNd4r2f5HM11p4tT7mY0Xwg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com; dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=WQgmkKbc; dkim-atps=neutral; spf=pass (client-ip=210.118.77.11; helo=mailout1.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org) smtp.mailfrom=samsung.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=WQgmkKbc;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=samsung.com (client-ip=210.118.77.11; helo=mailout1.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jLhkN1lLPz2yLg
	for <linux-erofs@lists.ozlabs.org>; Sat, 07 Nov 2026 01:43:24 +1100 (AEDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261106144314euoutp01bf87a536a63373af7576bde678d1ddb8~le9gTt12I2284222842euoutp01h;
	Fri,  6 Nov 2026 14:43:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261106144314euoutp01bf87a536a63373af7576bde678d1ddb8~le9gTt12I2284222842euoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793976194;
	bh=GYgm5u58bPQ8KjrBy/61xpOFxkMjgCoTnwcTVNwoqbk=;
	h=From:Date:Subject:In-Reply-To:To:Cc:References:From;
	b=WQgmkKbcpS0E5IppfyivxuipWCQVcrj3wQBhcG7mppmAFCb61WSuWQLycNnw2LszB
	 QBV9gIdHH1YOykat4PVKvqUj106DRrp0MQYKnvtWt+9iAlpffLU8njplSMEPRaxEUg
	 Zi2lTJLd/b+PgKD4zjnk6WRW355DOUz0XqSi+Au0=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261106144313eucas1p18ebd11c40d0e1e68730aac1800b2502f~le9foEAZZ0320803208eucas1p1z;
	Fri,  6 Nov 2026 14:43:13 +0000 (GMT)
Received: from AMDC4942.eu.corp.samsungelectronics.net (unknown
	[106.210.136.40]) by eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261106144312eusmtip1f828cc3d3bce0595deabb51a9c76f7a7~le9eGMPzl0111901119eusmtip1B;
	Fri,  6 Nov 2026 14:43:12 +0000 (GMT)
From: Michal Wilczynski <m.wilczynski@samsung.com>
Date: Fri, 06 Nov 2026 15:42:55 +0100
Subject: [PATCH v2 15/15] MAINTAINERS: add an entry for the LZ4 compression
 library
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
Message-Id: <20261106-lz4-vendor-upstream-v2-15-ee04c3f0d7dc@samsung.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1482;
	i=m.wilczynski@samsung.com; h=from:subject:message-id;
	bh=HGm8Ef+oh1jjJf2rH2pR5MHSsxC9Nek4TB/eJTDN4oQ=;
	b=owGbwMvMwCGWumv6zndzRCIZT6slMWS9fZ46abfJ/e19IaxMGW5HdnJahax7qPTqucTmL61LK
	yVunnzF2VHKwiDGwSArpshydmO0keQ/hqflxx//gpnDygQyhIGLUwAmMkuZ4b8H27vww+aTf9sr
	N3XbHLz3N8hwUuGtw780TzbOOCOjvSmPkeGmlHH30XVnPxqo96y+mbnccFpp95ySRF5/txDPTl+
	eX2wA
X-Developer-Key: i=m.wilczynski@samsung.com; a=openpgp;
	fpr=CDB15B3219FE00E577C7E3FA65BA97B9EE9C1459
X-CMS-MailID: 20261106144313eucas1p18ebd11c40d0e1e68730aac1800b2502f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261106144313eucas1p18ebd11c40d0e1e68730aac1800b2502f
X-EPHeader: CA
X-CMS-RootMailID: 20261106144313eucas1p18ebd11c40d0e1e68730aac1800b2502f
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
	<CGME20261106144313eucas1p18ebd11c40d0e1e68730aac1800b2502f@eucas1p1.samsung.com>
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

lib/lz4/ has never had one: get_maintainer.pl returns only the LKML
fallback for every file in it, including include/linux/lz4.h, which eight
subsystems build against.

The entry also takes lib/decompress_unlz4.c and its header, which
decode LZ4 kernel images and initramfs through lib/lz4, the way XZ
EMBEDDED covers its own equivalents, and crypto/lz4.c and crypto/lz4hc.c,
the crypto API wrappers zswap uses, as ZSTD takes crypto/zstd.c.

This matters more now than it did. With the previous patches lib/lz4 is
vendored upstream sources, and someone has to bump them to new upstream
releases and decide what the kernel-side glue may do. I am willing to do
that, so add myself as its maintainer.

Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index cc3cae2e378b34aeb705cef654c720ca9f2ba223..598d87ca772eecbb1ed169d51ff0eb8cdd2e50ad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15606,6 +15606,16 @@ S:	Supported
 F:	drivers/net/pcs/pcs-lynx.c
 F:	include/linux/pcs-lynx.h
 
+LZ4 COMPRESSION LIBRARY
+M:	Michal Wilczynski <m.wilczynski@samsung.com>
+S:	Maintained
+F:	crypto/lz4.c
+F:	crypto/lz4hc.c
+F:	include/linux/decompress/unlz4.h
+F:	include/linux/lz4.h
+F:	lib/decompress_unlz4.c
+F:	lib/lz4/
+
 M68K ARCHITECTURE
 M:	Geert Uytterhoeven <geert@linux-m68k.org>
 L:	linux-m68k@lists.linux-m68k.org

-- 
2.34.1


