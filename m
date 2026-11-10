Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E36607502D
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R9v9qHLP
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1Js5BL5z3bxL;
	Tue, 10 Nov 2026 20:17:49 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302269;
	cv=none; b=X319/Wm64ClFIOm3g/+50hv2pssLmp4LdxKc39Hbr9uKJKL9FVrCDXUUyAHZCpIDvz8AYymZY0+hYy6xGtsZEWEDfTdZMKmfEFbCuNUlI4rV5o0QYP1GbR83bkG7S73QOdUGWT6NvyoEQiYCFnaiZCgFl/T9z0aWk9lquUPXokrv+bcL+iip/yQtXpiVWCW+gGZf7VgFDxA5LEVtAvc3APnc/BlhJ0De/vRHhT9UmzHqXMghBuuOPx2en6Qt/5ZLMvYzCTkhuIFHF//aRqV4QXwh3LKMiIRlpsx44ALBYvim8+otJnCSmrJWmemzIQd0QVCLmj9tbvBUy7UWYpXP1g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302269; c=relaxed/relaxed;
	bh=l8LDAQNHphQBAnLKVY0j2bP3Ogdq6gK5b5xHcx0dYsg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VCKxLp01VULMIW6KaTMEtpzG9RiyEqu4vF8Ak1JFnOLmyYqjicXS0RgZMpYNmr23yL5TmRovQlvTcR7GnQdrVDSs64PUAg1A/oNUwfvGEqfpqLGM0q73GMSYUNaoQst/N4Y39wNJQvzGAfOrWOW2dWU1vfVuSi5luyf9Ig1cIjkpGf4hD1BXFwkADOWxbvTovpO9elMSuNy/x0KeOrQc8vhwpX+vu8Q4Xd0uvluOtnaML0Zdbe59k1UvijnFqW6J531AbyB/ydu9sSfwwOwcYGhSEX5adzsDglA7njbkt2Rht4t56zeFoCH09PHxyHdPJ4Fc8d+rwmO3XYDPK5iLPQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R9v9qHLP; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R9v9qHLP;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1Js0bFNz3btn;
	Tue, 10 Nov 2026 20:17:49 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F16063805;
	Tue, 10 Nov 2026 09:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987041F008A1;
	Tue, 10 Nov 2026 09:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302266;
	bh=l8LDAQNHphQBAnLKVY0j2bP3Ogdq6gK5b5xHcx0dYsg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=R9v9qHLPfZZRHObjYnC3o1mAzO1hP+/9155v1wxmmC7hQDax+NvgTbE4W9xrNan6b
	 z0Sdkmw0b24b+Z76hEcw0ec7fC8rhBm0gmhG32Dr9KvOltCueuenMbGzfKiksYbb/R
	 A6o9Yo/dPlBuObvaZL1En87DLRIXfZzEMhiQLtg8EsJhl2E4mtXzQGo9ABc14bgHRe
	 PZldAZR1cxgMtFhW4nTK2eKI2Yi5t+MGsF5VrX1YHsgpjfxFteN0G7738shRXMLGdm
	 N33HXtEWu+Tp9JkAiYvDDygE7C96rLISq1P2stvft/KA/fCZ0rHgRq5v+c5DMmWCFV
	 ymFNp2JgMpqoQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:32 +0100
Subject: [PATCH RFC 16/41] configfs: use fc_init_pseudo()
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
Message-Id: <20261110-work-loop-pseudo-v1-16-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=912; i=brauner@kernel.org;
 h=from:subject:message-id; bh=FZSn8pZNkelWJZuy96PPD0cDLXKTFQ+NnjbEVUus4Cs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erAsoPxm8YvkDfvCz87c1p11JmKH6fuChtd3Yuf8U
 K0rc7F601HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARx10M/11uxYdrM97avS7+
 mvJWaemvRj2ydif4HQs8FhZrHNFqm8Dw33+Ncnarxkp9i/liZ7b1r790NO6pyta3nhe6A+fNCn7
 EzQEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize configfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. configfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/configfs/mount.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index d8cac1cbf3bd..60ba24e7ae2b 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -106,6 +107,7 @@ static const struct fs_context_operations configfs_context_ops = {
 
 static int configfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &configfs_context_ops;
 	return 0;
 }

-- 
2.53.0


