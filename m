Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAEE606E58E
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GRiIgHwN
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1MV4H2nz3dPs;
	Tue, 10 Nov 2026 20:20:06 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302406;
	cv=none; b=oFQVwbLmQ4DgOEwtyx9SqX+l0/BYwSXmeOFqUewmzrjs6LCnLuD1Y0WaszjHoLNtfws1716xTtxEVsezVJspyJYOVR0REIN/Ytn3In5un68ETuq1XhTINxXBubMjDbXy3R46e8AKqrvooZmblJp/eeEW3r0ENN0mtlzPI8CFa9CBMprySWT8HxM5SdMJqM16omfxQyQa33pSoVSiRI8n5G4bEe8ZYmaNFnA3QFEW88Mfr+Sf5NoYqNfSRM0H+UFWVBE4Pp3IF4D/YxgA2TFu9p1QTnIFvs4Lp8FWOqeyHDbTIn3CcgP97FMmKiRb1R3ZkFeLB0VPs+9sy2ktljNLfA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302406; c=relaxed/relaxed;
	bh=E+IOyvszTPpv67WVfApXcw8urPUkzwLhKXwxrxd5Q2U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aB5Sjifmgybl0Q16gNcddp6d7Sj2UHNQ4XhO3CKr9FqDh9W1USC2hGtQE1G777OBg/owzkzrVcOuS06G+zzMnqldRZv+gwUXorHbrLTFvNdgh5g9KVWEaqK+iIH/0QcCxUJO3zVVX32pLQ1qtH3FyckLmEKdDSKihUDfCG3PD4XwqUzV5luShd5Eg2DsE0cfpHPbagDDXE+SEoIyHD2eTXnDoaASOaHB9PDBXSPI6OJ9nmscJZiQrADpYwWK7QHaT90xr6sBEcQIp1UrojpcxGMGFc6uTGceA5B2+kJ3docBhgki7yibyLwKUWC1YaoayDg2S3yGRcWnFSSRBYEO4w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GRiIgHwN; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GRiIgHwN;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1MV02qCz3dM6;
	Tue, 10 Nov 2026 20:20:05 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 270A66381F;
	Tue, 10 Nov 2026 09:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5968D1F0089F;
	Tue, 10 Nov 2026 09:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302403;
	bh=E+IOyvszTPpv67WVfApXcw8urPUkzwLhKXwxrxd5Q2U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GRiIgHwNZvImcyL7ZrhwcHTim1Tcg8ha0BAVLvCt63eibDuBdqoGnn3+IZ3T7OBIq
	 kT6r8YMuTD7me3jVVO4LuvwQYkPqosPEVX8f4q9eZuJZsQvKrNsIgO5JMMLqqeNIuC
	 5Cpr1r58rbzBBX6KMjeREg5OUsa/9eOU65Z5i70WZg176K2uk1tQ1kAhA4U0o0Rctw
	 xZ/y1A7h5XbjDTP8H3oewDpTzB4kJ0kw8bjZG9JUpDxnNRmZc91S3mqwbwSIu6bKQ1
	 710KWpylBRJOXcVv5bGIBzE03omQg/l6rlLylLNvB6cAWjRRFZkeN1M+920TaGjY0B
	 2UXvy+J5ImDmQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:52 +0100
Subject: [PATCH RFC 36/41] nvmet: refuse files on pseudo filesystems as
 namespace backing files
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
Message-Id: <20261110-work-loop-pseudo-v1-36-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=834; i=brauner@kernel.org;
 h=from:subject:message-id; bh=agqenJdWQq7gypo76jkCFbW4mXy4h6l0lNCXX+ASm3g=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDvm3yLxwpNhn3Vf/xC/LZIi53fJ7yLL7tHITliz
 91kU4+kjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIm8FmJk6Auyf5jNeWOi0OnH
 C2RnbHW9nXtha/oTsYTE2efzD909cIzhf93azF97BBdfrrbP5nki8XXrjrDbU/+oPHgTKJzVsWp
 jPzcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The file backend takes any path that isn't a block device. With
buffered_io=1 that includes files on procfs or sysfs which then get read
and written by a kernel worker on behalf of the host. Refuse files on
pseudo filesystems just like loop does.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/nvme/target/io-cmd-file.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index dfa8aa46188c..71c69bac5394 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -52,6 +52,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
 		goto err;
 	}
 
+	if (file_is_pseudo(ns->file)) {
+		ret = -EINVAL;
+		goto err;
+	}
+
 	nvmet_file_ns_revalidate(ns);
 
 	/*

-- 
2.53.0


