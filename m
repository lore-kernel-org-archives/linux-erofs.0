Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61598606AB60
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TgjMN56K
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlYC0L2Pz3dXP;
	Mon, 16 Nov 2026 22:11:27 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827486;
	cv=none; b=UQbjWWXvKkd0Ni+okykpte5wdULiPVEWRPIE9J5fKj14MabsypSS0oTe6U+xLVEmHKMMUf/n9QKyo9CWqteeFm6rtbkpF0AtcYaPM7VgOKMKme1RtstI7ZIqBgZ5ab4JvKYiZXGN1R42efb/lYgFxqUd/G48pY+KpxamZSay2xAxauJROr7y5unWykbdFNtFVPDKjjksTau2YyxSneI5AbpBG4mtIRXRn1/wUkK2Pyel0R9oslCRHb8ukRCEwig3FfwjjyK69c60tdylBJD8uCjjMW6hkYRU8nbYIJHbLrQ++1RYKhXsUp9fftfm4//1TLMIC+LszJyDJTaz+iJMjw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827486; c=relaxed/relaxed;
	bh=8CwpxM6nYTuBn1diZMKE8u8L7OG7WlbpBDnW4TTBYyk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gkPXiMHfQnw7l0vKuaGC1xyyCB4hiR4zWJ/p9gzjdMJ8z5w5YlBr67hX6PyPFKst/EjkPrz7opQQmGR5g+yLqO33q56xQY61ElDKsNdhStW3rM+Z03h8zqBux9ZS2ylHlr+hb2O3PuIjjvMCKdJU3FjCxykJsClnBdQhrpd/S3r+9vVV0utyfOIf5Bok1L7O0NHpOta+0ev1LM5X34rJvyRSA1Xz5OpugVWjT+lNPW7b25kjt2ftmUnKS1rxgWpWeffjCqEeTc2jEH4ZCWRoAHsRi/91F5xrpzSNKvtxi1D9dGUI9hW9lQQ8dTwCIn625OZBHIFDGxAgYA9nZL3EjQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TgjMN56K; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TgjMN56K;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlYB1M8Vz3dVl;
	Mon, 16 Nov 2026 22:11:26 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0AA1162967;
	Mon, 16 Nov 2026 11:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07B31F000C5;
	Mon, 16 Nov 2026 11:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827483;
	bh=8CwpxM6nYTuBn1diZMKE8u8L7OG7WlbpBDnW4TTBYyk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TgjMN56KOGGjy4LWUYsZ8zVo89DB80z6mNiJUIXdyCxzkfdDPL0CceRNnYEB5ZMAg
	 PvkD68BWJ9caW2s/BGPrGC91Iq9CXON0BvEYC4o9C6G7FIaTwo+zxVlOEz2OOHPj5k
	 4vXH0MjVLq/jft4abkooK+ZUvlfxnZFbaMziEvjtIgG2hkF85u9Jdu0B1Z0thxS1Vt
	 ZGARk4NS/4O6UY4E9/nGiGeDdufCKu3ZzScYIpnsUw2WoGqih1dN6XANIxyQsbx8j7
	 /P5GGzoXoUbjqBYgg50FlLRHJWxCQQmcH0xslfduPPlaC1VbV4Z1ZBjTDb0GhtHuP2
	 ZujQbdQe5sKRQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:16 +0100
Subject: [PATCH RFC v3 43/44] acct: refuse files on pseudo filesystems
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
Message-Id: <20261116-work-loop-pseudo-v3-43-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1795; i=brauner@kernel.org;
 h=from:subject:message-id; bh=TBLyDKw5rIlrAxe1WyLhAIBRdo8Sa0ool6FMcens/Cw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ejzBrFZos83lvdOmyU1dbrg+U5ejPTdxwtWo7L1VD
 VNiDrWpdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyE7zkjQ4fU9EqupZErcpbM
 YdFl11N9/mKWoNrBrC3H9UQXrluybwojw9s/fcqVr01abSYZ5cX71J9+ofyxLFboXoAX66kl1eu
 TOQE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

acct(2) already refuses to write its records to files on kernel internal
filesystems and to procfs and sysfs files. It recognizes the latter two
by FS_USERNS_MOUNT_RESTRICTED which misses every other pseudo
filesystem. So a cgroup2 or binfmt_misc file is accepted as the
accounting file.

The records are written with the credentials of whoever turned on
accounting so this isn't abusable the way loop is. But files on pseudo
filesystems aren't a place to store accounting records. Use
file_check_backing() to refuse all of them.

SB_NOUSER doesn't need to be checked separately anymore. It is only
raised by pseudo filesystems and by tmpfs instances that are either
kernel internal or can't be mounted.

Suggested-by: Alexander Mikhalitsyn <alex@amutable.com>
Link: https://lore.kernel.org/r/ae189903d4cda27130317a9312d94b53d07415ba.camel@amutable.com
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/acct.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index c440d43479ca5..0c502f778fde0 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -245,11 +245,11 @@ static int acct_on(const char __user *name)
 		return -EACCES;
 
 	/* Exclude kernel internal filesystems. */
-	if (file_inode(file)->i_sb->s_flags & (SB_NOUSER | SB_KERNMOUNT))
+	if (file_inode(file)->i_sb->s_flags & SB_KERNMOUNT)
 		return -EINVAL;
 
-	/* Exclude procfs and sysfs. */
-	if (file_inode(file)->i_sb->s_type->fs_flags & FS_USERNS_MOUNT_RESTRICTED)
+	/* Exclude pseudo filesystems. */
+	if (file_check_backing(file, 0, 0))
 		return -EINVAL;
 
 	if (!(file->f_mode & FMODE_CAN_WRITE))

-- 
2.53.0


