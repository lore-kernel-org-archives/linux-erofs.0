Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669BC606A326
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Nov 2026 19:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=NRZI0/g0
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jVpnF0Tb9z3c1S;
	Fri, 20 Nov 2026 06:44:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=210.118.77.11
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795117440;
	cv=none; b=o0YufTNi/Uq35pBljeldi1cW6o31h19a5kXaSVPSat9zXgQ8iLdfUB7eNDLpSHd1MnpAfmbkHyQkn28VzmaAiklccCHGyVYaYR2c/SbCWQstBSMGeeNDfpWyIgJXFXbUpKqML82N0yLrIExy3G9PHrmiU/oSTMKOwgHqhPCPfx/qoF42ptGpD7C2RDTqRDKZcrTJeBb3CC9uosyBD9m1SqxYmCRSas5M7VDG7a39I6/6nsECElA9RN4Kx4yvs8rYRGkGdA8usRMJXnmt8lTzqrXjd89BZ4ayyU4YBcQZ6Q4otjivd/EJjGlIWfoTUrgWyEdw5L2ww19rgZGIQ5afag==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795117440; c=relaxed/relaxed;
	bh=090F43O6xwbTXOOBTz6I2219/meRL0E1+FYz/xdX8XU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=kl+DJPwce41Qtk606T/htFUFswyI0z8FFmcph4BCTOf3y73JfOdwh4QglvqZ1iPhH0ZvZkvvD0mbCRPIupSbahBk4bkcxxxgLIHwDxX0TqHwkGB0NZoqnNQGGwtcRZHvGt3etgA39aQwqe8uHUicic3ljqIQ75KxPevwJS9nPK6MOEiWv6Bfy2lJgGU55CiTSsfADIBa9tr5WH1B1sqT+N0QTMq6Vu2KHSrwPSmMTwTx4b4skfL3xaIIGKqX00Wh6mvecWspcIOPryFNy2g1tu0afTQDePTJBS56y5PmGGNPPPwc277LGR+9KqAsnntGKAYmHRKTNd0ryF3M3rkzPw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com; dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=NRZI0/g0; dkim-atps=neutral; spf=pass (client-ip=210.118.77.11; helo=mailout1.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org) smtp.mailfrom=samsung.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=NRZI0/g0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=samsung.com (client-ip=210.118.77.11; helo=mailout1.w1.samsung.com; envelope-from=m.wilczynski@samsung.com; receiver=lists.ozlabs.org)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jVpnB1C2Zz3c1Q
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Nov 2026 06:43:57 +1100 (AEDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261119194346euoutp0163a395cf97b79c6c9b53059c629d5c80~picnFnwQW1211312113euoutp01w
	for <linux-erofs@lists.ozlabs.org>; Thu, 19 Nov 2026 19:43:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261119194346euoutp0163a395cf97b79c6c9b53059c629d5c80~picnFnwQW1211312113euoutp01w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795117426;
	bh=090F43O6xwbTXOOBTz6I2219/meRL0E1+FYz/xdX8XU=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=NRZI0/g0ShOOBLLsJPWC86qh3P8zV1Hh4g+2gBGi5NcIr4nz5+tTS5Rf/2EsfIxuS
	 3LPdhpTuMT62WSRpGp7tP8ct7nFDtwFvblFIV1fUXyZhU8CfOtLn/2+tOQ8a8YMKqw
	 dbWTXP1P+rpYp8VaTsCbEbeLXkttRKfeXqS0Ew4I=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261119194345eucas1p19bddf3b3f2155b0f4777a822db00aec1~picm3UpHR0237702377eucas1p1Y;
	Thu, 19 Nov 2026 19:43:45 +0000 (GMT)
Received: from [192.168.1.44] (unknown [106.210.136.40]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261119194345eusmtip1e59aab635f10627422e5da54c5d41eaa~picmWhHfe0313403134eusmtip13;
	Thu, 19 Nov 2026 19:43:45 +0000 (GMT)
Message-ID: <e8235bd4-ad04-49d2-a5f6-f83463a8f8b6@samsung.com>
Date: Thu, 19 Nov 2026 20:43:45 +0100
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
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lib/lz4: add KUnit tests for compression and
 decompression
To: "S. Biplab Raut" <Biplab.Raut@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Gao Xiang <xiang@kernel.org>,
	linux-erofs@lists.ozlabs.org, Yann Collet <yann.collet.73@gmail.com>, Nick
	Terrell <terrelln@meta.com>, Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>,
	kunit-dev@googlegroups.com, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Content-Language: en-US
From: Michal Wilczynski <m.wilczynski@samsung.com>
In-Reply-To: <20261118182343.1628236-1-Biplab.Raut@amd.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261119194345eucas1p19bddf3b3f2155b0f4777a822db00aec1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261118182347eucas1p2f85df57ccf85e78fd2c104d4046f5295
X-EPHeader: CA
X-CMS-RootMailID: 20261118182347eucas1p2f85df57ccf85e78fd2c104d4046f5295
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
	<CGME20261118182347eucas1p2f85df57ccf85e78fd2c104d4046f5295@eucas1p2.samsung.com>
	<20261118182343.1628236-1-Biplab.Raut@amd.com>
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/18/26 19:23, S. Biplab Raut wrote:
> lib/lz4 has no in-tree tests, and this series replaces both the
> compressor and the decompressor.  Add KUnit suites for the behaviour
> callers rely on.
> 
> lz4_decompress:
>  - round-trips through LZ4_decompress_safe() and
>    LZ4_decompress_safe_partial() with exact, oversized and partial
>    capacities;
>  - truncated and corrupted blocks never write past the destination,
>    through either entry point.  The input sits at the end of its
>    allocation, so KASAN also reports over-reads;
>  - an offset-0 match decodes the same whatever the buffer held before;
>  - literal and match lengths longer than the output are rejected.  On
>    32-bit, lengths whose extension bytes sum to SIZE_MAX are rejected
>    rather than wrapped;
>  - in-place decoding within LZ4_DECOMPRESS_INPLACE_MARGIN() leaves the
>    output intact.  A fixed block that corrupts with the old +32 margin
>    covers the vendored decoder's 32-byte wild copies, and a port of
>    upstream's worst-case test covers the 64-byte copies its decoder
>    makes since v1.11.0.
> 
> lz4_compress:
>  - LZ4_compress_default() fits LZ4_COMPRESSBOUND(), and with a smaller
>    buffer fails rather than overflowing;
>  - LZ4_compress_fast() across documented acceleration boundaries;
>  - LZ4_compress_destSize() output decodes to exactly the consumed
>    prefix;
>  - the dictionary paths of zram's lz4 and lz4hc backends;
>  - LZ4_compress_HC() across supported levels, including the kernel's
>    clamp boundary, with full and limited output.
> 
> Work memory is allocated at exactly LZ4_MEM_COMPRESS, LZ4HC_MEM_COMPRESS
> and LZ4_MEM_DECOMPRESS bytes, so KASAN reports an implementation that
> outgrows them.
> 
> Without this series, the 32-bit length case fails on i386 ("long match
> accepted: ret=31"): the old decoder wraps the match length to 18 bytes
> and accepts the block.
> 
> Signed-off-by: S. Biplab Raut <Biplab.Raut@amd.com>
> ---
> 
> Michal, this goes on top of your v2: it uses LZ4_MEM_DECOMPRESS and the
> opaque stream types, so please fold it into v3 if you find it useful.
> 
> The tests are deterministic regression tests.  Every randomized case
> uses a fixed seed, so each run checks the same inputs and any failure
> reproduces exactly.  The in-place suite has two fixed cases:
> 
>  - a block that corrupts with the old (compressedSize >> 8) + 32 margin
>    under a 32-byte fast loop, the case patch 12 fixes;
> 
>  - a port of upstream's decompress_safe_inPlace_worstCase test [1]:
>    fixed noise with a 65-byte match at offset 65, for every source size
>    from 300 to 4096.
> 
> On patch 12 and the +65 margin: since v1.11.0, upstream's decoder makes
> 64-byte wild copies on x86-64, aarch64 and ppc64, and upstream has raised
> its margin to (compressedSize >> 8) + 65 to match [1].  That fix is on
> the dev branch for v1.11.2; the released v1.11.0 and v1.11.1 headers
> still say +32.  Your v1.10.0 import uses the 32-byte loop, so +36 is
> right for this series.  A later re-sync to v1.11.0 or newer needs the
> kernel's margin raised to +65 in the same patch, whatever the upstream
> header at that tag says.
> 
> I checked that the worst-case test catches this, using a userspace
> build of the same test.  Against upstream dev's decoder, all 3797 sizes
> fail at +36 and none fail at +65.  Against your vendored v1.10.0
> decoder, none fail at +36.
> 
> The HC cases are built only when LZ4HC_COMPRESS is reachable.
> 
> With your v2 applied on v7.3-rc4, the suite passes on UML (17 passed,
> one 32-bit-only skip), on i386 (18 passed), and on x86_64 with KASAN and
> KASAN_VMALLOC (17 passed, the same skip).  A UML build without
> LZ4HC_COMPRESS passes 15 tests with the same skip.
> 
> [1] https://protect2.fireeye.com/v1/url?k=f02093a2-91ab868d-f02118ed-74fe485cbfe7-df7f89af9c73957c&q=1&e=79e95ae8-ccd9-4aaa-b235-c5f62451957b&u=https%3A%2F%2Fgithub.com%2Flz4%2Flz4%2Fpull%2F2104
> 
>  lib/Kconfig               |  15 +
>  lib/lz4/.kunitconfig      |   5 +
>  lib/lz4/Makefile          |   1 +
>  lib/lz4/tests/Makefile    |   2 +
>  lib/lz4/tests/lz4_kunit.c | 911 ++++++++++++++++++++++++++++++++++++++
>  5 files changed, 934 insertions(+)
>  create mode 100644 lib/lz4/.kunitconfig
>  create mode 100644 lib/lz4/tests/Makefile
>  create mode 100644 lib/lz4/tests/lz4_kunit.c
> 

Hi Biplab,

Thanks for the tests and for testing v2

v3 is coming in a couple of days. It vendors v1.11.1 instead of v1.10.0,
so it already has the 64-byte copies, and the in-place margin is
(compressedSize >> 8) + 68.

I ran your suite on v3. Everything passes except
lz4hc_compress_test_levels. That's because v3 no longer clamps HC levels
to 9: levels 10-12 need a bigger state, sized with the new
lz4hc_mem_compress(level). Allocating wrkmem per level with it fixes the
test.

If that's OK with you, I'll carry your patch in v3 with that small
change keeping you as the author. Since patches 10, 11 and 13 changed
a lot I'll drop your Tested-by - a re-test on v3 would be great.

Best regards,
-- 
Michal Wilczynski <m.wilczynski@samsung.com>

