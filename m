Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE29606A7AE
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R9B5RaEQ
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlVW548cz3cNp;
	Mon, 16 Nov 2026 22:09:07 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827347;
	cv=none; b=UyLDKjR7sYdInlBg6pWPAsLh1OwpGBR3zvNNGu+G4/TjFRAODHl+Mgp9msHeNmmNalKCiA3W25aCvQp4gkGPNoAZpVOfVFCI1R1DPd85JPPLnV8w1Vro/DRkKWUbdgs97J8jco5McZLdqrCJ3msdU5WruuJOMkUNrYTZ7H4Vk0YMvXFH2ryT6a4MUpXpYEt0PziurlfutkMvQ4nugefuVIAyuiMTyxeWApRs1yymDUOaeSlt3zmEQ2P6/cnL7nUwEVP60ZpazXy8M28e+Q0RQ7n6+O6d2LV2qS2DU95WZdYqlsfyC1uqq2hCRnRb0jYk8jdOcgecNtYAmXex/48yyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827347; c=relaxed/relaxed;
	bh=WZa8raruWf4jzyZcy4zjAHZiv8qEDUIon9hD96nRur0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LfQAxFyUWrmehUPfBOQbKWfQUZ5NJqUWkvR9ykQzwhDGh0a94MKJzY9LFDf38Cz/huzzVrhb13nHQf1VC3Sj5K/QjiBAGk5K32osbJllyhNmJ2RBBDr1Cg3SmUVUb2Bq7SKyXYKhJoS36t2g/4QW4eozqZu4et1+QdtT1r3H7ZAmbjR3ciS7q1YyRQfXBZ8mrlUlI1Ws3EVUZ4pbU6aC18PsRmbNwkXvQZrfEF3rByPp7/6faMWmyS8rqMkBl1VH98I6KxdYkcisyuRW1vky8HCs7M0XYybhs/CLgJTvpkhyj022KDMQmnoeebcPppXvusXtWVpG9byffOxUxy7C6w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R9B5RaEQ; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R9B5RaEQ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlVW0vg0z3cNj;
	Mon, 16 Nov 2026 22:09:07 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92ADC41233;
	Mon, 16 Nov 2026 11:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643CC1F000C7;
	Mon, 16 Nov 2026 11:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827345;
	bh=WZa8raruWf4jzyZcy4zjAHZiv8qEDUIon9hD96nRur0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=R9B5RaEQmiwsAP1jIczB2zWH7HySjdmMzkng/+3APaCz2aIiR/5pA6QHlhTGPsx8z
	 CRzgX8ndXpYp0sjoyAbMIp1+MxGD+2DAlrY7udq0z+KNdGy7F3kxcIwyC6zbTjxhWm
	 yirFYavZHEFP6gIEwpXBYIN6SxBglphEPLbBaCq7FRAcuqs7D0l1JDGItjul5ABdHB
	 d9KuKk4ck+bWHEQ7LhylcskCqFiUIBf3v15nKwFrhNFGCCv2wRxQdpOvT+/bHvNnrt
	 DnN5kVqm7vTrOkR80gnd3fRgFIsX/hlTkS2T+BoxTB5bUiUfAjvwd6zlckKAgcRgHy
	 1qyB+N2C8a43g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:57 +0100
Subject: [PATCH RFC v3 24/44] efivarfs: use fc_init_pseudo()
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
Message-Id: <20261116-work-loop-pseudo-v3-24-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=972; i=brauner@kernel.org;
 h=from:subject:message-id; bh=U3c0nafflYvUbB7XCWz+41zdupMknG85VhFAzpOuQl4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elxl0evIXDdr63nf8LI7X+5e612rf6tTU7lporhxj
 mdZts/6jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIl0/WL4K3elzLjM+M6M+brf
 9/5bG75Vlvfsk9/+7EWxqyIett05Vc/wP8X9yuP865WvUu2fte80N+1KFXWeciZ+5nF3c9snSkG
 ZTAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize efivarfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. efivarfs never holds executables or
device nodes.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/efivarfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 12746ced6dc63..e598d42c5f42c 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -8,6 +8,7 @@
 #include <linux/efi.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
@@ -554,6 +555,7 @@ static int efivarfs_init_fs_context(struct fs_context *fc)
 	}
 
 	fc->s_fs_info = sfi;
+	fc_init_pseudo(fc);
 	fc->ops = &efivarfs_context_ops;
 
 	return 0;

-- 
2.53.0


