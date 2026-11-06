Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3361F606EE9A
	for <linux-erofs@archiver.kernel.org>; Fri,  6 Nov 2026 14:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=EN46cMg4
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jLhjz0ncMz2xSS;
	Sat, 07 Nov 2026 01:43:03 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=210.118.77.12
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793976183;
	cv=none; b=iJ2sT04W3dORAkU3FYJ6QEcQ6wE71ymcmJ0qrJaHCH5wCCn4U6B47C2KvklNojVBh1Iw8KfnZx8aO/WTjwDIlnEigta9eHX/Y1PkIUI2XM67QSYv4Y/O4wBrjXOgyKzXvpNn8ZqWtzdsUE8TKR4ViNnCHllAfTsEsmaYKYn4IYwHiVcQ82kJIvy0hem2rksfd+R71tCDOUrgiYskJbaHpmqAqSJu9zK93e39JVhGoeBcf2SQBQt8aZYI0DghVDE32l9F12aBc7ZUE8uk1bhNoOXfODyxKBcaEq1/+uKhDWTkiMvoZ4cdisBzWnC+RTarAnxWUqczGa6UImIIOp0K7w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793976183; c=relaxed/relaxed;
	bh=ZukkpYT3qCCda2Jxa+XkaNLKI/uzan+hwGewF/8rdTw=;
	h=From:Date:Subject:MIME-Version:Message-Id:In-Reply-To:To:Cc:
	 Content-Type:References; b=FOwkXVkKlXKwAJUM7ISS6gyrTgG9Qi7PE1/FCILfSXD0UPYGB23mVYYnSioP7NXtUGwYX61cJmjXEyzbp/dRyCPZ0wwiam+0IL7nWMU7OIo/pgqcRnklp1jveSAjb/WbBiy996c/Tht5/7E3IeUe1cfbh98dD7Ju9stUU1MZPF6jPMjZmtQwCQ418ANorOcfvme0VBf8UTzmUP1bxJz9kqgIUejXbBdXXYC/idScov0hs2VXp3VGabGMEDE69MSTPRwWcMFXtpA/KDoKbXId7TV9iB6u6g3xkjx4AyVuEA6VhVoUDRLqx3vDTflUieA2Zx3ZUe3xkROeyftowu7kxQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com; dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=EN46cMg4; dkim-atps=neutral; spf=pass (client-ip=210.118.77.12; helo=mailout2.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org) smtp.mailfrom=samsung.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=EN46cMg4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=samsung.com (client-ip=210.118.77.12; helo=mailout2.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jLhjw64ZNz2xPb
	for <linux-erofs@lists.ozlabs.org>; Sat, 07 Nov 2026 01:43:00 +1100 (AEDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261106144250euoutp022e1a6a3073d383bd646015487e8568c9~le9JpKhy81199311993euoutp02D;
	Fri,  6 Nov 2026 14:42:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261106144250euoutp022e1a6a3073d383bd646015487e8568c9~le9JpKhy81199311993euoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793976170;
	bh=ZukkpYT3qCCda2Jxa+XkaNLKI/uzan+hwGewF/8rdTw=;
	h=From:Date:Subject:In-Reply-To:To:Cc:References:From;
	b=EN46cMg4Z5AshlKXcWj6iq9nVx+1cEFRUR3OeEX1SELWiBSHo0MXSd8R+ZRpXPqPo
	 5J9fZGzBi/ektMzl9T564UxSBe3S67f6f+YsOPNBKFF7rocyARFmA/WbDBCKVPMy1l
	 grLUbbLxfYwtJc30nNwsRnyAAGoxoUyejvqHmnV0=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261106144249eucas1p1ca5f03b764c6305120da3e8b65f76ed1~le9JAlvFx2626526265eucas1p1j;
	Fri,  6 Nov 2026 14:42:49 +0000 (GMT)
Received: from AMDC4942.eu.corp.samsungelectronics.net (unknown
	[106.210.136.40]) by eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261106144247eusmtip1bdfc91f54320939f93a2226da03397ef~le9G89u5c0161401614eusmtip13;
	Fri,  6 Nov 2026 14:42:47 +0000 (GMT)
From: Michal Wilczynski <m.wilczynski@samsung.com>
Date: Fri, 06 Nov 2026 15:42:41 +0100
Subject: [PATCH v2 01/15] lib/decompress_unlz4: use
 LZ4_decompress_safe_partial() before boot
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
Message-Id: <20261106-lz4-vendor-upstream-v2-1-ee04c3f0d7dc@samsung.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1628;
	i=m.wilczynski@samsung.com; h=from:subject:message-id;
	bh=i98BIOEMfPRofAmIfLEP+RTKtUlRGNT17p8zNX3eSM8=;
	b=owGbwMvMwCGWumv6zndzRCIZT6slMWS9fZ6ynW99606dIwL7ulQ6Bbe9jN7M8lqzVe7sNB/dw
	JkrA5JWdZSyMIhxMMiKKbKc3RhtJPmP4Wn58ce/YOawMoEMYeDiFICJrAtn+Kd4oT3eQJe/yUhy
	6odrlWpckv+rc3a+M/rqfupkEZNc9AyG/453bnjdSWxq+LLd5e7mt6pKC87ZPImexDM9MuXEZx3
	FWh4A
X-Developer-Key: i=m.wilczynski@samsung.com; a=openpgp;
	fpr=CDB15B3219FE00E577C7E3FA65BA97B9EE9C1459
X-CMS-MailID: 20261106144249eucas1p1ca5f03b764c6305120da3e8b65f76ed1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261106144249eucas1p1ca5f03b764c6305120da3e8b65f76ed1
X-EPHeader: CA
X-CMS-RootMailID: 20261106144249eucas1p1ca5f03b764c6305120da3e8b65f76ed1
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
	<CGME20261106144249eucas1p1ca5f03b764c6305120da3e8b65f76ed1@eucas1p1.samsung.com>
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The pre-boot decompressor is the only in-tree user of
LZ4_decompress_fast(), which upstream has deprecated since v1.9. It
never checks the input against the chunk length in the header.

Decode with LZ4_decompress_safe_partial() instead, bounded by the chunk
length and by the expected output length. Count every chunk against the
size the image ends with, and fail a chunk that decodes short or comes
after that size is reached.

x86 decompresses in place; the margin arch/x86/boot/header.S reserves,
(output >> 8) + 128K, covers the safe decoder's 32-byte overshoot.

Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
---
 lib/decompress_unlz4.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/lib/decompress_unlz4.c b/lib/decompress_unlz4.c
index c0dbb3cea915eb91d8f4ac26c38c4785bbf19770..dc20c22e087900e21da49f9fcb267e6b511e1072 100644
--- a/lib/decompress_unlz4.c
+++ b/lib/decompress_unlz4.c
@@ -151,14 +151,17 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
 			}
 		}
 #ifdef PREBOOT
-		if (out_len >= uncomp_chunksize) {
+		if (out_len >= uncomp_chunksize)
 			dest_len = uncomp_chunksize;
-			out_len -= dest_len;
-		} else
+		else
 			dest_len = out_len;
+		out_len -= dest_len;
 
-		ret = LZ4_decompress_fast(inp, outp, dest_len);
-		chunksize = ret;
+		ret = LZ4_decompress_safe_partial(inp, outp, chunksize,
+						  dest_len, dest_len);
+		/* A chunk once the image's stated size is reached is corrupt. */
+		if (!dest_len || ret != (int)dest_len)
+			ret = -1;
 #else
 		dest_len = uncomp_chunksize;
 

-- 
2.34.1


