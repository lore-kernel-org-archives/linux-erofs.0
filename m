Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A88F606EEA7
	for <linux-erofs@archiver.kernel.org>; Fri,  6 Nov 2026 14:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=D7iVj3R3
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jLhkJ5W81z2yMK;
	Sat, 07 Nov 2026 01:43:20 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=210.118.77.12
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793976200;
	cv=none; b=UjVYS+6RmgNpW+mzXblJ5v06MnP7ac5VlfmMJaviNDPs5EpAfbGFV2WoipkqV/1P6JlGrzccP0rJ6PNKglRop6ppxv/4OVxS/GVK4NQ83euXS05nyTT8DT6NXHl+zgFRkFJwhajrEdfWkLGSgtW2H4xE1WBHb4+Z+cIl3qN46qKoyoMriGqiSAmwBTle1cJDb6CW+Xu9TeGFjAdXdM4sqndRrLJCIJdFyMy6XoEjntLU/2CIKYeBWXjw6uBmRF12oq2oP1P67cBIS3WYbIzr53YDv2FohujB8W4fn8XpfXYLIUBdzWJuAiYJHBG1g7UzJal9Pb7hemnsAEVVh1vQRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793976200; c=relaxed/relaxed;
	bh=5WAyfwxes97eXVKQ4WaEOycOnpyd2q1S7T7hoYmOWJ4=;
	h=From:Date:Subject:MIME-Version:Message-Id:In-Reply-To:To:Cc:
	 Content-Type:References; b=CZk7BDi71QeKriGPklq8y836Rg0hwc1YaG3Kd9EJ0wMCIghvbL1i47S3HBdavAudfLpgAKseCvWQFqQJVkBQdcDPu8BHyLnmpHs+/cYsaideqRKX1/PM6yRWvgd5IC9kGnnP4ZAGVlD0NRnsnpYyITk5muLoRAC9NQwi5+5ak2BjfPx1uTOpXpwQ+TqH+rYZ+wSih+/fpHoLSyGWcJy/zJyDgpT0lm+k7/oux7ly3rFFUrd/HHABTJTc1F9NkUXYb2GkWR5O8rtStRTeNKs6yes39fDhow/aftdh3bhfUK51vW2zwUgkBGFecMaJ8qYaJ91iJ2xWYcBRw3glmgcXdg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com; dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=D7iVj3R3; dkim-atps=neutral; spf=pass (client-ip=210.118.77.12; helo=mailout2.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org) smtp.mailfrom=samsung.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=D7iVj3R3;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=samsung.com (client-ip=210.118.77.12; helo=mailout2.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jLhkH61dQz2yLg
	for <linux-erofs@lists.ozlabs.org>; Sat, 07 Nov 2026 01:43:19 +1100 (AEDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261106144309euoutp02d3a45fbf182d4289338c041a54a30ba3~le9bpk8I61214112141euoutp029;
	Fri,  6 Nov 2026 14:43:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261106144309euoutp02d3a45fbf182d4289338c041a54a30ba3~le9bpk8I61214112141euoutp029
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793976189;
	bh=5WAyfwxes97eXVKQ4WaEOycOnpyd2q1S7T7hoYmOWJ4=;
	h=From:Date:Subject:In-Reply-To:To:Cc:References:From;
	b=D7iVj3R3EFBMCZfeWcnCC6O7h42HpAdgC15pTjtVCRsbOpbrJ1u7362+nBytnVZJo
	 GPaJoilZTC4GQb+X+MBgAo049VkMz1rY7KhTfaMWbYh+LVWzWOPpt+Dd40an5c0lvY
	 fZESEJO8U5ENXVpBrDS1XGbsnu08ctiWvS6Akuo0=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261106144309eucas1p2a9bfcc1cf81779d473fb073e7d9139b7~le9bJGw3w1206712067eucas1p2u;
	Fri,  6 Nov 2026 14:43:09 +0000 (GMT)
Received: from AMDC4942.eu.corp.samsungelectronics.net (unknown
	[106.210.136.40]) by eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261106144306eusmtip13eaf752873270c04345a32c3bd105a56~le9ZQns9S0066400664eusmtip1c;
	Fri,  6 Nov 2026 14:43:06 +0000 (GMT)
From: Michal Wilczynski <m.wilczynski@samsung.com>
Date: Fri, 06 Nov 2026 15:42:52 +0100
Subject: [PATCH v2 12/15] lib/lz4: widen LZ4_DECOMPRESS_INPLACE_MARGIN for
 the fast decode loop
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
Message-Id: <20261106-lz4-vendor-upstream-v2-12-ee04c3f0d7dc@samsung.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2274;
	i=m.wilczynski@samsung.com; h=from:subject:message-id;
	bh=Tpg9+ra3w5bOUJNOcaBr2j03QC+ZywHsirLjAFcMOMY=;
	b=owGbwMvMwCGWumv6zndzRCIZT6slMWS9fZ4qLJQjrZip3LipbJ+lgnfepgtXFNi+nNiwQ0m2O
	dxxwb2wjlIWBjEOBlkxRZazG6ONJP8xPC0//vgXzBxWJpAhDFycAjCRT6oM//O5StQshSrPZkpy
	fjtTf7732jPX8Cs37feWSKzLLZ5rrMfwPzhjjqNKzaZ1HX9+LzmrNWlPT3Obds6iHf/OOFvd/8j
	cyQ4A
X-Developer-Key: i=m.wilczynski@samsung.com; a=openpgp;
	fpr=CDB15B3219FE00E577C7E3FA65BA97B9EE9C1459
X-CMS-MailID: 20261106144309eucas1p2a9bfcc1cf81779d473fb073e7d9139b7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261106144309eucas1p2a9bfcc1cf81779d473fb073e7d9139b7
X-EPHeader: CA
X-CMS-RootMailID: 20261106144309eucas1p2a9bfcc1cf81779d473fb073e7d9139b7
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
	<CGME20261106144309eucas1p2a9bfcc1cf81779d473fb073e7d9139b7@eucas1p2.samsung.com>
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

erofs decompresses a pcluster in place when the slack after the output
is at least LZ4_DECOMPRESS_INPLACE_MARGIN(compressed size), upstream's
(compressedSize >> 8) + 32.

That holds for the fork, which overshoots its output by at most 8
bytes. Upstream's LZ4_FAST_DEC_LOOP, which the next patch brings in for
x86 and arm64, copies in 32-byte steps and can overwrite input it has
not read yet: of 172410 valid streams laid out as erofs does at exactly
that margin, 3660 fail to decode, none with the fork. The worst needs
(compressedSize >> 8) + 33. Images mkfs.erofs built did not hit this,
but nothing in the format rules it out.

Use (compressedSize >> 8) + (compressedSize >> 15) + 36, which takes a
4K pcluster's margin from 48 to 52 bytes. Upstream's lz4.h defines the
macro too, so undefine it first.

Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
---
 include/linux/lz4.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/lz4.h b/include/linux/lz4.h
index 05060b9790be4621ddbe744172fa0ae37f6191f4..e809149747c3dc97d129e42e0ce4385b5a219930 100644
--- a/include/linux/lz4.h
+++ b/include/linux/lz4.h
@@ -521,7 +521,18 @@ int LZ4_decompress_safe_usingDict(const char *source, char *dest,
 	int compressedSize, int maxDecompressedSize, const char *dictStart,
 	int dictSize);
 
-#define LZ4_DECOMPRESS_INPLACE_MARGIN(compressedSize)          (((compressedSize) >> 8) + 32)
+/*
+ * Slack needed after the decompressed data for LZ4_decompress_safe() to
+ * decode in place, with the compressed data at the end of the buffer.
+ * Upstream's (compressedSize >> 8) + 32 can be a few bytes short: its fast
+ * decode loop copies in 32-byte steps, which may overwrite input it has
+ * not read yet.  The >> 15 term is extra headroom for large pclusters.
+ * Upstream's lz4.h, which lib/lz4's objects also see, defines the macro
+ * too.
+ */
+#undef LZ4_DECOMPRESS_INPLACE_MARGIN
+#define LZ4_DECOMPRESS_INPLACE_MARGIN(compressedSize)	\
+	(((compressedSize) >> 8) + ((compressedSize) >> 15) + 36)
 
 #ifndef LZ4_DISTANCE_MAX	/* history window size; can be user-defined at compile time */
 #define LZ4_DISTANCE_MAX 65535	/* set to maximum value by default */

-- 
2.34.1


