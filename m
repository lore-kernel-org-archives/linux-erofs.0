Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A054606A336
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Nov 2026 18:35:58 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jV9K82Xrcz2xns;
	Thu, 19 Nov 2026 05:35:56 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=165.204.217.251
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795026956;
	cv=none; b=mLILOBQuAYPeWgNt/QyPgBM/eTRKtF+peS09Z6/K83jfElzrVYS5n9ojG0W/nNFERKQp9NmGv41mGWA83AfRAORaFV1+2PYcWhrpxzgs5ZWsJm31mOVPsBQZP0TjBTsYyZ3UuGbXAK5CQp6UWkkgdRXR920Ax62TojDTCKqMPCo0uyDw4/ylVke2ZH4UiTws3xXKMHl50RBYJVTjVLMDFUmPRHjJaSZsnR4v1rGRprm0DmCgLlnp4EVxdnJjFkOh5sTUc2hrAwIHlu394XL1Qv34/a0g4JeJE80fWwAENWUPlDqfp9aopHyQRNbHekGkgDBwoLijqnXyk3RJddX2CA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795026956; c=relaxed/relaxed;
	bh=IfTtvM/3+s40XCW0hkVAEdNiQuNayjBzRBn88skgIHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvkMlkeOIjNr1RBCqedxZEaMyGg4AsZmQ6yPswnDoX2iZGs//lUtP4UZ/RHPVNtUeJLZ9EJRL3z9ft7vssOG40wMLBIGnHuBdgboVEwcZSCH+d+UB7/pwN9xkwdUNUhmw1kXD3zc/7ZWF7O+qk1H5vtk5Kj62GicoIzcomCXRY18KQM9llAfXXpac+jrNhuyPX5CilQ2WlFsbJSJFJpco8V+PFzSW46BLaaIdy0GjYh1NOYYmT5tT3g/LFVFeK+Tfk57Hzbzwhf9ut8PvlRzPMbcC0A6L0l/pGYSfLJh8FMh943PjM/ZuR8aJncB+pJrTERgQzNI1yeu2ohfQ0dc2w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=none (client-ip=165.204.217.251; helo=aocl-turin-03-9e62.amd.com; envelope-from=amd@aocl-turin-03-9e62.amd.com; receiver=lists.ozlabs.org) smtp.mailfrom=aocl-turin-03-9e62.amd.com
Authentication-Results: lists.ozlabs.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=aocl-turin-03-9e62.amd.com (client-ip=165.204.217.251; helo=aocl-turin-03-9e62.amd.com; envelope-from=amd@aocl-turin-03-9e62.amd.com; receiver=lists.ozlabs.org)
Received: from aocl-turin-03-9e62.amd.com (unknown [165.204.217.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jV9K75jpRz2xL4
	for <linux-erofs@lists.ozlabs.org>; Thu, 19 Nov 2026 05:35:55 +1100 (AEDT)
Received: by aocl-turin-03-9e62.amd.com (Postfix, from userid 1000)
	id 29D6F1720679; Wed, 18 Nov 2026 18:35:54 +0000 (UTC)
From: "S. Biplab Raut" <Biplab.Raut@amd.com>
To: Michal Wilczynski <m.wilczynski@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Yann Collet <yann.collet.73@gmail.com>,
	Nick Terrell <terrelln@meta.com>,
	Gao Xiang <xiang@kernel.org>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	"S . Biplab Raut" <Biplab.Raut@amd.com>
Subject: Re: [PATCH v2 13/15] lib/lz4: switch the decompressor to the vendored sources
Date: Wed, 18 Nov 2026 18:35:52 +0000
Message-ID: <20261118183552.1670705-1-Biplab.Raut@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261106-lz4-vendor-upstream-v2-13-ee04c3f0d7dc@samsung.com>
References: <20261106-lz4-vendor-upstream-v2-13-ee04c3f0d7dc@samsung.com>
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
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With the whole of v2 applied on v7.3-rc4, the lz4_decompress cases of
the lib/lz4 KUnit tests I posted in this thread pass on UML, i386, and
x86_64 under QEMU with KASAN and KASAN_VMALLOC.  They cover round trips
through LZ4_decompress_safe() and LZ4_decompress_safe_partial(),
truncated and corrupted blocks, offset-0 matches, and overlong literal
and match lengths, with work memory allocated at exactly
LZ4_MEM_DECOMPRESS.

On i386 this also fixes a case mainline gets wrong: a match length
whose extension bytes sum to SIZE_MAX is now rejected, where v7.3-rc4
alone wraps it to 18 bytes and accepts the block.

Tested-by: S. Biplab Raut <Biplab.Raut@amd.com>

