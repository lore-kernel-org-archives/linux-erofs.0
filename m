Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E588D606BF36
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KN56aSxE
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1K01ZPHz3c5y;
	Tue, 10 Nov 2026 20:17:56 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302276;
	cv=none; b=RUbfPlEgtRbDg6PFdJjpHJxk+d/eU5Fvxt/jDh/LpIzYlRpxnYm3Vw1Sh1fe7EWwzrFLNKCIL/0bjhrU20wzTv4LfGg4elkWx37j5DZDCwtgDpudZPOILDW0bTLcLqBuhJtialtu3Mda9LsNvFqXgyXignRkF5HS+usvwHWYy97uZEY1Oi6VgTUxu96t69PQQP70x85pjfo3vSnOPDbbeSTJon2QUlCstE/aVyGWxT1p5N9r+3N8yZiVAfCzVIleBR7tCmOIB3vD6NdGkfcgRrxu0jHZ+xqMBBvGq6zIAMDCniYN4TBtMTcmDKVyud9edUq7g+iFF7LrZqWlAAEwBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302276; c=relaxed/relaxed;
	bh=V5BWJw5fa84POo80x3ibKreEFrHi8L/+0M4nKiAomaU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WmxW3F+fax4E0f8J/b3Fqa9E8EVGsErTj/74DNeY/CxpQ371sMF0SqFZh9t2vD44JukC/vsqdx2D69j9cLhR8pQOZHN4sl54uJGNAY67R1TsVbVQDUjexeQtm22aLcT+9OhLKNmusy6TCAjzxVfSdrN3/bw3EPuwhDee7UTidYvI+9BE/JR3Ga9pmmcajWgSeV64ejZjuIHX/405iHlmkl1YLZsFuRo3r3XKwi3LiqTObygQH3HdkhEf30wJoczQjNYZBCqmtlJayW4m74XApLQJLZiWlVvgdVDWRKFRNZRtHIyXCppmaqSlnSFls95NeO6U064UHMIglOQRXJhenw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KN56aSxE; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KN56aSxE;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1Jz2jpWz3btn;
	Tue, 10 Nov 2026 20:17:55 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB08A4359C;
	Tue, 10 Nov 2026 09:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BC01F0089F;
	Tue, 10 Nov 2026 09:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302273;
	bh=V5BWJw5fa84POo80x3ibKreEFrHi8L/+0M4nKiAomaU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KN56aSxEcIL4HezFtJpqamXDQkWCizrnZgnkUMIpPJsU7rRuUGbPuKCmoeZKs9Z8T
	 KX8yIwO5M/hIAuohYYoYuaalWbYYVGCWyj3OPI2eTlBmHabq5gQXT0Q9S0rZ4F3ut5
	 C4zEnhc+UMJ2cgIQGGeaEL+qrQxNqtC4KAdzr1uwPXxDiu2A5V9MYGtecJfiijcWEU
	 2ZNMp5ydhnhMaivDafrR5m7QBhsQux+h3Tx/1FbSjFTpvpg7tD2QL9hYdoAqvzBL6y
	 XALD9so6bBSasGgjOreqMXh2TJ7gKHcAOMhp27y+3npGTFNV3GX8PCI5KY5SzKdsrT
	 HZkVBu2EyzxNA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:33 +0100
Subject: [PATCH RFC 17/41] securityfs: use fc_init_pseudo()
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
Message-Id: <20261110-work-loop-pseudo-v1-17-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1036; i=brauner@kernel.org;
 h=from:subject:message-id; bh=MwHP9YE6cjEfGAuH1dNASl/A50wevLh7f7bfLWi2WsQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erD8krTE09Ofz2cIRrPJrvxZXfW5i2mz60HLaz3/t
 aacvaGV01HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjAR0ceMDF3dd12/pYZrKTE8
 Ycgt3jlH/vK/wh9r1zpfPu+pqC78O4rhJ+MXzsV8icqCDBsCp8j+vcN8x+XyLeYvblvbTnJ6hSb
 MZgMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize securityfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. securityfs never holds executables or
device nodes.

AppArmor puts a .null device node into securityfs but only ever opens
it via dentry_open() which doesn't care about SB_I_NODEV.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/inode.c b/security/inode.c
index 080402367674..93997a9f16fc 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -14,6 +14,7 @@
 #include <linux/kobject.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/mount.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
@@ -64,6 +65,7 @@ static const struct fs_context_operations securityfs_context_ops = {
 
 static int securityfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &securityfs_context_ops;
 	return 0;
 }

-- 
2.53.0


