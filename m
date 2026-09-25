Return-Path: <linux-erofs+bounces-4606-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E128DC98321
	for <linux-erofs@archiver.kernel.org>; Fri, 25 Sep 2026 11:41:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hrpgw5cWmz30V1;
	Fri, 25 Sep 2026 21:41:32 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=210.118.77.12
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790336492;
	cv=none; b=eYpZSYxjbmc/8864nHWxQWKO5POlFUHmkv1Zg8qpJ0gOYx2WjG59MnXk8Baphw86JsMs2VFGCkNNHjBFOdLXqaMD7J/RP1h3lNbRvuHttRi/h3IVpWcMxLcPY72CzBD9caoLnyLLiEfu2ZoBzMebt1dfz+HNsuq8FuUXDcuEOLzweDx76tkzDanzHphv8spbdd2LfqN3otv5RBAuEm4SPZKtIIVsV6fd499UA3Gar0fXKLZzGFkSeyr3ik7/rMqNr0Sh07uBdK5RO1YhmWVyr5irWUQQ3VlFbH2P6cknO1WCRKDhBGVA65eImi5WcZkIyrKZXWGVi0g8hIAqq8MqLg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790336492; c=relaxed/relaxed;
	bh=nO41lh/H4SzcoCdayvonqkq9okmqSnTubMvlLylaa1w=;
	h=From:Date:Subject:MIME-Version:Message-Id:In-Reply-To:To:Cc:
	 Content-Type:References; b=WyR5VO97vnUGnArcbRbVViMtYnuevTkKtcmbA28beWdThwUOa7SyXswMhIJZ6+YWGNB9ftV2zFrkkeiZaalRKjV5XIzoKTnQprwCGXcKPiaEhSswNavBDL5+aLQEDFXGS3alyXJMbMsdWzMLKfLWs/jJVajD+c4Rl/P61DRfmP2rtSnqmTzTisAlP+OfezUeQr0i4EgFKXnFKRsUqJ5WbUTOQZ5/i4zJKMgwMoZhgRxJ/y0o9DcE9prKP/47mpGuW04Llv6mUT4rJ/HDR0DqaL5rFaw9Edx61o76NY6N2js7qIb6wXX1E2V21aDlwIoUNtD3uxirfYf9bGFp/1ESfQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com; dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=HT2us8FY; dkim-atps=neutral; spf=pass (client-ip=210.118.77.12; helo=mailout2.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org) smtp.mailfrom=samsung.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=HT2us8FY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=samsung.com (client-ip=210.118.77.12; helo=mailout2.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hrpgs2dc1z3017
	for <linux-erofs@lists.ozlabs.org>; Fri, 25 Sep 2026 21:41:27 +1000 (AEST)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260925113454euoutp029aba4d7652769b32aa244658574edba9~YjTFViDYa0681106811euoutp02X;
	Fri, 25 Sep 2026 11:34:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260925113454euoutp029aba4d7652769b32aa244658574edba9~YjTFViDYa0681106811euoutp02X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1790336094;
	bh=nO41lh/H4SzcoCdayvonqkq9okmqSnTubMvlLylaa1w=;
	h=From:Date:Subject:In-Reply-To:To:Cc:References:From;
	b=HT2us8FYPCD02Bqr6zxqNELSXegcdUB71/GiSE79vPh0ddbcgSd4gYAdoEzE+9FfU
	 aXibiNf7aXZYzd8naEbWeqtRvgyMmH39N++134vhhtm7ENQIBAGk9Lb7PSqTDSnY5A
	 fdjlRPG2x+BJwq2hJNUpKlor5WltkEwRd9KhMQsU=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260925113454eucas1p1ffe6b62a29086943a60137ed7e1f42ef~YjTFCnGhF0249002490eucas1p1k;
	Fri, 25 Sep 2026 11:34:54 +0000 (GMT)
Received: from AMDC4942.eu.corp.samsungelectronics.net (unknown
	[106.210.136.40]) by eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260925113452eusmtip215fd236cce7ebc09bee5052a2af6141d~YjTDfNwYs0229302293eusmtip2L;
	Fri, 25 Sep 2026 11:34:52 +0000 (GMT)
From: Michal Wilczynski <m.wilczynski@samsung.com>
Date: Fri, 25 Sep 2026 13:27:32 +0200
Subject: [PATCH RFC 2/9] lib/lz4: backport upstream's -Wmissing-prototypes
 fix
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-lz4-vendor-upstream-v1-2-1c7ffbe21c4b@samsung.com>
In-Reply-To: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
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
	<chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,  Herbert Xu
	<herbert@gondor.apana.org.au>,  Phillip Lougher <phillip@squashfs.org.uk>,
	Sungguk <sungguk.na@samsung.com>,  Jaehoon Chung <jh80.chung@samsung.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, linux-erofs@lists.ozlabs.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2100;
	i=m.wilczynski@samsung.com; h=from:subject:message-id;
	bh=wMVojsfuYF9eT5q5rMs2c29qyYKzm0LcLr4isls1UTQ=;
	b=owEBbQGS/pANAwAKASw99I2nQptuAcsmYgBqtlxRhAkB7TyATBVr/4+ZvB5W43K313iDQp6Eo
	GaNSuSsmEuJATMEAAEKAB0WIQR2xBTdTO5XfoUTSOYsPfSNp0KbbgUCarZcUQAKCRAsPfSNp0Kb
	bqqICAChUCgNeDyv3RGoQ6NgJobTPJZsAhZENmNk+sFHRrRm6s6yXgvJuRHnzHz67u44q3G2aUJ
	/w62OUYZhnqPXdGHG01nPAl/of1ajK7KLqRJZtwlq76hT4q/T3bD7HTJyl07fgzoJcWA3FJeoQC
	1ODZi0rz3jnFdvvowe7eSTcTvlQ7A4X+H/saBtEhuoKsMAlE3scE8X1i/kj0dRRcx8yrOhXE433
	ExlndGyD/0UTmNLSkn9uACbJR7e7T83b1n4lRCzw5cW9WKelHdl7gxKHn3nCqO43ppJbweGga2A
	TmrhwDJsGXJ9NmpfsGfz7Gd6ImCi+0CtxVH3d3CbdbEGiCeL
X-Developer-Key: i=m.wilczynski@samsung.com; a=openpgp;
	fpr=76C414DD4CEE577E851348E62C3DF48DA7429B6E
X-CMS-MailID: 20260925113454eucas1p1ffe6b62a29086943a60137ed7e1f42ef
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260925113454eucas1p1ffe6b62a29086943a60137ed7e1f42ef
X-EPHeader: CA
X-CMS-RootMailID: 20260925113454eucas1p1ffe6b62a29086943a60137ed7e1f42ef
References: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
	<CGME20260925113454eucas1p1ffe6b62a29086943a60137ed7e1f42ef@eucas1p1.samsung.com>

v1.10.0 defines LZ4_loadDict_internal() in lz4.c and LZ4HC_searchExtDict()
in lz4hc.c with external linkage and no prototype, which the kernel's
-Wmissing-prototypes rejects. The first also prevents linking, since
lz4_compress.c and lz4_decompress.c both include lz4.c and would each
define it.

Neither can be forward declared static in lz4_deps.h like the other bare
helpers, because their signatures use types declared inside the .c files.

Take the two hunks of upstream commit 5ef1f16929b5
("fix -Wmissing-prototypes warnings") that apply to the files we vendor.
This is the only deviation from the tag, and goes away at the next
re-sync.

Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
---
 lib/lz4/upstream/lz4.c   | 2 +-
 lib/lz4/upstream/lz4hc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/lz4/upstream/lz4.c b/lib/lz4/upstream/lz4.c
index a2f7abee19fb9a5c768f2a6c266acf5b571f0855..0d474be0236a698d297ab9a430f5082485eb3709 100644
--- a/lib/lz4/upstream/lz4.c
+++ b/lib/lz4/upstream/lz4.c
@@ -1584,7 +1584,7 @@ int LZ4_freeStream (LZ4_stream_t* LZ4_stream)
 
 typedef enum { _ld_fast, _ld_slow } LoadDict_mode_e;
 #define HASH_UNIT sizeof(reg_t)
-int LZ4_loadDict_internal(LZ4_stream_t* LZ4_dict,
+static int LZ4_loadDict_internal(LZ4_stream_t* LZ4_dict,
                     const char* dictionary, int dictSize,
                     LoadDict_mode_e _ld)
 {
diff --git a/lib/lz4/upstream/lz4hc.c b/lib/lz4/upstream/lz4hc.c
index 4d8c36a6978fcae09e4c4a936572b4b271513466..32b29f382268d961d65383b24c7225494d9044ad 100644
--- a/lib/lz4/upstream/lz4hc.c
+++ b/lib/lz4/upstream/lz4hc.c
@@ -360,7 +360,7 @@ typedef struct {
     int back;  /* negative value */
 } LZ4HC_match_t;
 
-LZ4HC_match_t LZ4HC_searchExtDict(const BYTE* ip, U32 ipIndex,
+static LZ4HC_match_t LZ4HC_searchExtDict(const BYTE* ip, U32 ipIndex,
         const BYTE* const iLowLimit, const BYTE* const iHighLimit,
         const LZ4HC_CCtx_internal* dictCtx, U32 gDictEndIndex,
         int currentBestML, int nbAttempts)

-- 
2.34.1


