Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F8F606A882
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VlWUdDLV
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlS46PKjz30Pr;
	Mon, 16 Nov 2026 22:07:00 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827220;
	cv=none; b=VuO8bwlPXMQ4Hk4Illa76UbCnN3mpX868A2uaECqxMrDTRGRU7Y+I4HRjmGZAV7LcdSU4k5qJIiqDqKpz0rM31UTMu//85fB8eey3qf159769GtGTADIFaTNZXnlXCIC2XgpBezaxz3AU/L4IDzU2lALBoG9/aLbdbnqmJR10DRuA5bJtpX73gyNwQhJuycesU/YJ0srKlo/Ln0shtQUgjx46lfPrr/ZWqmPxfX6Xu5SlfYi62gP3SYI2ddTzgRBcL3wfLrTa334/9zcWLsg6EQAzxkfb6gqsPJ36va+qDBe1zhaUOEXxR9+nbBfA/bD+WaPcuneVNBjVA6yAIv+rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827220; c=relaxed/relaxed;
	bh=jcuZgfEAu/QV7fwp1VLyFSljuB6ko+rpbI5oo0xXTbA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ba2dvs83CDVCDJKtVamF7IpdjCMTXJYSCS5TyHUceXYZjRCfMLz9Ls82uEPJiT3IAyQnO69GxFbg/Zzd1dqu1BoeDsUhoDM9jjEN0kdhn6e5ZjxsL6bNysdyHeLdH/zBhw43vjxK3DprN481FhDGn2plolU25i6XXs79EpqMxrYSA45H8hUx0z7yISLdy2IM8mvbMdOMaUZH5m8iNRnNUR5UU7mUPE1A+71V8/16QKCQgR6bGJaPpJp7T6sJtdJXqEygBtl1cR3/TBRxvKdfmv+jvw+gbuupVD5TN2e6k8jAzH6F8MD0vJDHajoX0eW5BB97KYPY83PvPVVJDeIUaA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VlWUdDLV; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VlWUdDLV;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlS40ByQz2xf8;
	Mon, 16 Nov 2026 22:07:00 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AC7762965;
	Mon, 16 Nov 2026 11:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF281F000CE;
	Mon, 16 Nov 2026 11:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827217;
	bh=jcuZgfEAu/QV7fwp1VLyFSljuB6ko+rpbI5oo0xXTbA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VlWUdDLVuU7+1W5AfKDV8A6h7bpZD6EsCzKV3QkLOwQIaYytJajpFIVxFa+tZJ35S
	 tI3uPLWgSo+No0yMgSs4xL74IpVyEJcOMhOK9feVdhR0gz/3OsFCh+HBGIfL5bfaQy
	 EeWwUQfCTADTYpl3kYIVLHrKD0071KrFYjjll+kMtoKchmkd0P4z7p5mleDk4dc4RI
	 FfwrK4jlOLZbAGciN7FsmDhx1C1Isd2oeRGeEvBqEwGSDwcR3+swUmLjG4HKFAeiXz
	 c1mW+z65Ldx/VReJb1LQr1zBRFMkwzpCRVKF3SJQ+PxD2B6SIRjYnlrbYtR7otXVX9
	 51azYy6ntC+8g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:40 +0100
Subject: [PATCH RFC v3 07/44] binfmt_misc: use fc_init_pseudo()
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
Message-Id: <20261116-work-loop-pseudo-v3-7-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1381; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Op8caQB40yLDgM+EzuEIWYdaqzetBKTmauJ3/A8MyW4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epz2stXSV/bIi9CLVUrrcpeXPvuV4y5RpjX9R2Rox
 r/jidW7O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYiKszIsPeTS0+B0pFmdk8l
 p0n2046ui4zZq/L5S64sm9fmmVf2dTMyzMt9rHkle3Nhwf2a5nkBe5i1t7ttYSyfFqfzfN10XlU
 eRgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize binfmt_misc as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index d945b4f6e1581..7dc233becd98d 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -22,6 +22,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/init.h>
 #include <linux/kstrtox.h>
 #include <linux/limits.h>
@@ -1575,8 +1576,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (user_ns != current_user_ns())
 		return -EINVAL;
 
-	/* Never exec off this instance and never let anything stack on it. */
-	sb->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
+	/* Never let anything stack on this instance. */
 	sb->s_stack_depth = FILESYSTEM_MAX_STACK_DEPTH;
 
 	/*
@@ -1660,6 +1660,7 @@ static void bm_kill_sb(struct super_block *sb)
 
 static int bm_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &bm_context_ops;
 	return 0;
 }

-- 
2.53.0


