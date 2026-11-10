Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB101607FB5D
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XaFZlFw/
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1LB1N59z3cZV;
	Tue, 10 Nov 2026 20:18:58 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302338;
	cv=none; b=AvTANxmmbEwu1tmEe1U9fiDaGE23kIepzAQPwcqhLRMd5pftrgw0pAyDuPMvRnE+ejhJQzPnNzcbqgkYb5emzsDxTf5WUC/inhkQea2V9R8HtzRW8sq9ndM8RpE7edwfJVwWaVRv0YnrXKuvW25NiscDpT7aXgJfgHrjbBp9frZijGsZZzRJy2rlpxMhtp/QlsbwD/wrQ4tcdSjfJU7bplo8a3l+bsCQTFQjJvo6Ujki6vY7m3VEB8u3zGlfeN2BS/5kjswQxjPa3//BgVKHEUjmOecXaVv7yXUrLqlN9ba332xIie41XtEQ4ag2tSu7HHSAEuvSSc4DhqGNo+nqWw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302338; c=relaxed/relaxed;
	bh=3vbBpJ70QQUgTHc+9S4BdJlbLsLxsrAejDAnX1SbNic=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iUdIibDB2ozpzg9XTejUBZtul5VFSH3F9+rzCg6U1CTvR7CW5b6Udi4Wqt8cAFZl2/csRp1/9yqVodLyKwEKJdWdGpvpp6pdluYZG2eJGM4XmrBEArkZP8K02iMvGLnoT1DuYjCakjUSjCqKYGGCkwaGB5fIcEowDFBmvl7xc/gdxeLq8E1Edy4Ffi8vO3sPo0Q/A0iQwXTk5F+rzfDqWZXpgAQD/T6KTNlvZtOfGrYMn+AAER4I5hm6JgsA8rzen31NS1R0z4+6qdJ8jnJRvmNFNfLwr5bD/IQxAGnrloxfqZaJOt7D4yC3byP276UtHy4DW7Shgx6S4K5HeL3FUQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XaFZlFw/; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XaFZlFw/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1L945xQz3cZQ;
	Tue, 10 Nov 2026 20:18:57 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ABE826380F;
	Tue, 10 Nov 2026 09:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4BE1F0089F;
	Tue, 10 Nov 2026 09:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302335;
	bh=3vbBpJ70QQUgTHc+9S4BdJlbLsLxsrAejDAnX1SbNic=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XaFZlFw/DdnrRtOVsZEGp6QUGtmIPGuUZ+N4Hdx0OM0hwO0dbNjERxcTuZMYTcqjH
	 niXGeBr0dTqT4XuSBUJ4fHJ8LPa5mQ0gDOgO3p3iTEzXRwE29SgFUYzxoeoORUG48o
	 4DJ6Rk3Cvuwko+rTIDQL/lX2vrxaez+zErrVL/jJfRbWQLh2oJpIux07YdOMODEWT1
	 AOcuJ+CDnO6LeM9EEmN9aS0LHpgFim9TfKS15MTiXRxDbWwt1Q2uZLl1zL9z5geSoA
	 YWA/+bXNEPPKIhhzJ78YCVVL+ahtQQQJ2oXlHwFAREVtyR2al+Mwd8OYF0Lie832Vc
	 YrFaKf6APBZQQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:42 +0100
Subject: [PATCH RFC 26/41] xenfs: use fc_init_pseudo()
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-26-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
In-Reply-To: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1017; i=brauner@kernel.org;
 h=from:subject:message-id; bh=xO/6EKTyizodOr3jpQQP+lr/++u9/c+Tcs9J04rmnys=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erBpDZsiO/PvrRUOZYzHr09ZKmN5JzQjsOPDecc1T
 gv0mD6s6ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIvSqG/3GRPk4+yw9m6Lz9
 kr3Yn+deca/qnJO3fHSPGiyKaKxs38HwV3xiCl/tWo1fM/4fmOj0yLklovHKITOdd0+MZx7UWyL
 0lg8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize xenfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. xenfs never holds executables or
device nodes.

SB_I_NOEXEC also refuses PROT_EXEC mappings. xenfs maps the xenstore
page and guest memory through privcmd, both data.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/xen/xenfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
index 37ea7c5c0346..aba7d038ed73 100644
--- a/drivers/xen/xenfs/super.c
+++ b/drivers/xen/xenfs/super.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/magic.h>
 
 #include <xen/xen.h>
@@ -80,6 +81,7 @@ static const struct fs_context_operations xenfs_context_ops = {
 
 static int xenfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &xenfs_context_ops;
 	return 0;
 }

-- 
2.53.0


