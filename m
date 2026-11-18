Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0424606A32A
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Nov 2026 18:35:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jV9K72qdbz2xMt;
	Thu, 19 Nov 2026 05:35:55 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=165.204.217.251
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795026955;
	cv=none; b=I+8XfjMQ/RrA1uyCJzW7e+po3MHjxLwuvkTuSN6pILVmBDRiRjJtcD6xKrn0kQNwkMczHTCEjtXOnjTr7qKP1b0ISEYRygeolJgC0avOT7j34PpCTIyk9r5tcdEBm4yKJL2GR8Dnelcp+CHf2rKgYPgFoB3+8dEvFC3GZ7WGfSP34lMbpnX4gxtdh4X+PcrvwCtRnIiO0qbAhHOOqBUaLqF+W3o87B8et2RCS4Y7Qr6NeXFEsCaQZxltDRcowzJ2PjOAOXBew39D0OYeuPf3zo6uRGQ3VZUHFP99suK6H6upuIXOHb0zC1SALHNQamZCl8B9oH7OQdZJlbx3cp6+hw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795026955; c=relaxed/relaxed;
	bh=V23cxcuWzVaRdpJ+wIRz1kR8tN12Y6x1ZFT74cu7xO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccCcJXySFk7/tsFNA9Q1WfVUuc0xlIzGKFZMZee4oy3hQTCqto1suXlKGxKjIiiS6DQCCTCXMjyVRzr3Q5kp1XhYLij2oMp/UXAI8/4+sLMEfyuVeDgbHnBtNjbkXmCOjTt3kaQ/5TAJFxcNGT8HDO7WaniTf5a2vGKVm12XzpTswS/uLQ4iiupxs68kDEP1KoIAmsatnYs/MheqKFO52k3YfphSDZxkylirs07YanWjbU6GFp/xfPOi4N6SQ0MmS/RmCAVXryBFpuMT16cffz7kH0q5dJJDRsKSg5ZQn34EB8ttgPfbN2B1W35206vOSAzppJ0pV4+XPeU8myjZwQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=none (client-ip=165.204.217.251; helo=aocl-turin-03-9e62.amd.com; envelope-from=amd@aocl-turin-03-9e62.amd.com; receiver=lists.ozlabs.org) smtp.mailfrom=aocl-turin-03-9e62.amd.com
Authentication-Results: lists.ozlabs.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=aocl-turin-03-9e62.amd.com (client-ip=165.204.217.251; helo=aocl-turin-03-9e62.amd.com; envelope-from=amd@aocl-turin-03-9e62.amd.com; receiver=lists.ozlabs.org)
Received: from aocl-turin-03-9e62.amd.com (unknown [165.204.217.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jV9K65Ngkz2xL4
	for <linux-erofs@lists.ozlabs.org>; Thu, 19 Nov 2026 05:35:54 +1100 (AEDT)
Received: by aocl-turin-03-9e62.amd.com (Postfix, from userid 1000)
	id BDF481720567; Wed, 18 Nov 2026 18:35:52 +0000 (UTC)
From: "S. Biplab Raut" <Biplab.Raut@amd.com>
To: Michal Wilczynski <m.wilczynski@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Yann Collet <yann.collet.73@gmail.com>,
	Nick Terrell <terrelln@meta.com>,
	Gao Xiang <xiang@kernel.org>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	"S . Biplab Raut" <Biplab.Raut@amd.com>
Subject: Re: [PATCH v2 12/15] lib/lz4: widen LZ4_DECOMPRESS_INPLACE_MARGIN for the fast decode loop
Date: Wed, 18 Nov 2026 18:35:51 +0000
Message-ID: <20261118183551.1670675-1-Biplab.Raut@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261106-lz4-vendor-upstream-v2-12-ee04c3f0d7dc@samsung.com>
References: <20261106-lz4-vendor-upstream-v2-12-ee04c3f0d7dc@samsung.com>
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

With the whole of v2 applied on v7.3-rc4, the in-place cases of the
lib/lz4 KUnit tests I posted in this thread pass on UML, i386, and
x86_64 under QEMU with KASAN and KASAN_VMALLOC.  They include a fixed
block that corrupts in place with the old + 32 margin and decodes
cleanly with this patch's + 36.

In userspace, against the vendored v1.10.0 decoder, I saw no in-place
corruption at + 36 in 600000 random streams, nor in a port of upstream's
worst-case in-place test for any source size from 300 to 4096.

Tested-by: S. Biplab Raut <Biplab.Raut@amd.com>

