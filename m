Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D91606CFA6
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c/Ap+R4z
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1Kn1lb9z3cMb;
	Tue, 10 Nov 2026 20:18:37 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302317;
	cv=none; b=k5o5CrngIGQxevujkneO9QadV8ZEn3m1LEGz1eK3/AFEyqxtb4RHNNEPPBiHljOUyzYBDC5AYVaiK/kHwv0gVXVXXm5xidhH0rK1HG0oW30UYOhEw6fAztux+YbSUMsE49WeFQ0ph1nvX8RDMWKvCr2+gDf5ddIhvY35d70RyKZ8Ch/RzOKZW80f9hZ8FLzvhfDVn52zv6F0aovNaA0KVNiSx/IsDBhyHcWn59LkvlGBWErpSxZcABhX8vjnJbEi5LpqBajTUEnEgsGOj0MhCNBkW88h5SXAz956L0X5e+VhZs3adFHvdX2XgSfMta3L6YXdTISHor62KIerb/yBPw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302317; c=relaxed/relaxed;
	bh=B8RQTNfc/eWS72nZHsD5FmaXKvsQcX/MHrv0MZNEckg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IpcSblfb2UBny9nWUJff6+p9oH+SekbHbS72L512+GpWpiobXnZItaf7PN5f4KqdUNx7rDmkXBiJBYnLCi+U9qEEH1MgVeOVdpWzALGLGFAJtJ0zSsApOACNunL+PP4JY32bmzkl7dkCyA9IDC8ZB2wW4wOyo6oQK37U7QeAOx79fxO+nwke9jfCEQvaYyc/ARXk7oPtBtBp0tjAVnKhWvlDNuleEJo/kvEk+1uewusRocwLvtBjDthwScaAbSKTpZOLBY4g3qRsi4ygVdcIt023ZFnizXXb7tmng8UargEyVJi3W7q5ojVB+301kO020as1kJrx4zrZ8ZA42Oozlg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c/Ap+R4z; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c/Ap+R4z;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1Km4R1qz30Wd;
	Tue, 10 Nov 2026 20:18:36 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FE2D46A87;
	Tue, 10 Nov 2026 09:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20071F0089F;
	Tue, 10 Nov 2026 09:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302315;
	bh=B8RQTNfc/eWS72nZHsD5FmaXKvsQcX/MHrv0MZNEckg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=c/Ap+R4zFMvV3/8vcuIEPdB/Gt2XHUlHZTBEX28zCRTGUeuDJCvLmXS2bTYSdzi9R
	 0gr12Xdu/wNWC4bbLqs4TiHsR/YcW9JNs28CEkwEGUBB6TGWOirP4sbeOuKd4a7tZW
	 afM3jYlHN6+MVYSwuAcf1MRkadLxCZQa5Ry8f4ildqJfo+Wt7K+lGKrO7TizAPDeis
	 lj14KsNBHSrSqgHUxSQyH2WPPe6YEGnglY+yEWWsL8vk8c3l5TKaUlKahI+HbhISLF
	 nnD6YXeLZZD0ZUXVgvIwonj2iwv3yWDlAmtq4vfzLGXczqU+vQuxgOQWxGbajWp8T+
	 zqYWbwys3SKng==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:39 +0100
Subject: [PATCH RFC 23/41] fuse: use fc_init_pseudo() for fusectl
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
Message-Id: <20261110-work-loop-pseudo-v1-23-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=893; i=brauner@kernel.org;
 h=from:subject:message-id; bh=hjM1iJ4vU3paA5L4OQPDkADa3AqUdKJFLW5EmBnT+kw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erCuT2albMuTpuPqTDYzVbc45F0XFJ6y9xJTg/iJB
 vndWrxNHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPh02ZkeGybnbLv4dlnla2P
 zh+U1FV/fVEjuEXs+QzeMzuWCLwPtWVk+PIs8Nv5vXPYWX98mZbrdj9iVbPCut91O9M+rQ7YuNr
 gHTMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize fusectl as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. fusectl never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/fuse/control.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 21ffde596d61..4497362e7df0 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/namei.h>
 
 #define FUSE_CTL_SUPER_MAGIC 0x65735543
@@ -334,6 +335,7 @@ static const struct fs_context_operations fuse_ctl_context_ops = {
 
 static int fuse_ctl_init_fs_context(struct fs_context *fsc)
 {
+	fc_init_pseudo(fsc);
 	fsc->ops = &fuse_ctl_context_ops;
 	return 0;
 }

-- 
2.53.0


