Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00DC606D2A3
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CSnJIGlX
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZFQ3MdBz3dKm;
	Sun, 15 Nov 2026 00:08:42 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661722;
	cv=none; b=I4QbNJOPz81vNOT3EHVOfJ9K1I8Hq6E8p12YxSDbqut2pn0Z7tZmWtUxfZFfM6uaHg0YFoxjFPY2ZhO1hVMcR2wTr9y6BCn6WgoL+YobHiTXpaSXj3L9ExqSjLOonCg6AgmrNdHP4zMXrbvwBcEBuuC8LEEYFs2Kc2+83TkJ9ARmWosW34fTs9sI1Ks//DVLXZchgAIzvyaZxKwwq+bZG3GtQ7/afDp3tEWX+izxsjAT1G+3BVx4sUxykzsPAXY7Ph38ufuEaduRNXPA/M7aVPCsJ3jwUxc41QPA6u6R95ZNOkr4xo3xWsg/F7kVGuG/RLQ1fO1QW7np1ZXjrNjaHA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661722; c=relaxed/relaxed;
	bh=IrVRaUgylyW7dx1wUoEgP8enLWWhiisOApdkF3tckhc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=A/MT5K0P5O/38FuhQ9D4dUicVI9EaMDze362fczvrnrjWim/BTcPVO69o19n2ACbbHPCUO40BY9BbJAZfqOQgmprsqzKby+t0DxSdnb5BABV55sRodQmxejrvaRSj581huvnlssyldpG3HyIUUgUHf7WcRsRd9ckJ6Yb4/Tig4t3WvylzJFCVuqULf9lR4WIZfpFlC8CaW02uuYg2EaeuT1qRBX576lNXZKoA2UF1eurZKd1WG1lXfbZX2kaQRiMhQvuAtgTGMfieEHnfaaas0g30nxFxYfMrmDlVc6AUOGzA5/KSnPndKWYN9rwsBiICDs57ANU75cPUQcd3cuIow==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CSnJIGlX; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CSnJIGlX;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZFP6Nqyz3dKc;
	Sun, 15 Nov 2026 00:08:41 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60A7140D83;
	Sat, 14 Nov 2026 13:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB201F000C4;
	Sat, 14 Nov 2026 13:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661720;
	bh=IrVRaUgylyW7dx1wUoEgP8enLWWhiisOApdkF3tckhc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CSnJIGlXVCwPfZYGjaLB6IqanwTkuYMOqLjiIV98WyWx8/XlfQskQ4Ncrgj5RhMZR
	 wSZWZkZtit+aDjyLJmmgvMVuloaMpGHPl4V5iV3BBa563e5JY9xO+gJBwtTb9q7Q8C
	 mdg4xQ1+bqoQpc+gIpw5ks/W1KsdFYl1y8ZZRTzVOQ9kvuq4mogGtVJ4dS/PfMNIH3
	 q1Qk3HwuKj12Ep3f9iEkAbgFiSF6DWteKE3HQuNBK6n0301E9uMdY5e48cCjb0q9en
	 cBz3CDPb58li7HRkb67AF/RctpON8mZ6M2WcpSfLnE1Hp/QuclXpoedwNIpfQtb034
	 yVf37SRkLjV4w==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:07 +0100
Subject: [PATCH RFC v2 26/42] xenfs: use fc_init_pseudo()
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
Message-Id: <20261114-work-loop-pseudo-v2-26-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1019; i=brauner@kernel.org;
 h=from:subject:message-id; bh=FUjiFAJ818KMfzd+kfIYJM0T6xlI1Tybz/61rTbofEc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iGk2ymq59kHLQ6h8olLRV6eCMAf3indWE33bRHYYG
 yoaf7zdUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJEOK4bfbPpa60rvXBGfN9V1
 euu+TdOP9GV/muPCcL7yp0X8f6GmCIb/wbNO6i6ubdGYUd+54ZleikWZyucDWjzxvCyT2fm7JCz
 ZAQ==
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
index 37ea7c5c03469..aba7d038ed735 100644
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


