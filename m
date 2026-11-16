Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F94606C120
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gqYeWMoi
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlRN3nlsz2y71;
	Mon, 16 Nov 2026 22:06:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827184;
	cv=none; b=TB3kzVhp0Z/UfsSV0ZcQrFCoPARGn2x1FdD7iGHihjZBHOLt09pSgO1+Y+DUcea1dA99erqD+YDQI98JlTK9iwiBefrKPyrBMyFz12C8SRDQyJQ4p9eZrZyi7uJO74Ft0DJZ3UTcrRxxJA7trb2h02T/VCd+zB2UrdZ8ES641Dmr/CRZ806g5+a0/caThWhWPixKVMcwL2JaKFUKkmWDE2XrezNVQZZK/Bo44syYhBFxdtaRmxU9qL8A0FmPOmwDWWrPoLLMMn9zO134553YPS+1x4YygaDn0ID/MRMJMKAaN7XSGzzVUIP9npAv2ThstNCYZ8x85MqnxU4GGkB2gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827184; c=relaxed/relaxed;
	bh=VWUjc/lm6IOzTKu/XrjxEXkA+3TDHZe6UgBZOCqPWKg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aE4UgviFqDN5m4nYE04ZC+WE+qA9o34ud3kc2Amx07IsV+UbAA0zI2lKtqPn3o1jD6VrjO2k84ILgJLPzKzYsMomHXZQkcHARXbPyMINuuYVwsl9LHucR2vMXh3AMW8A4p8mPU7aLcwx6F6QhI31oP01BSNT/iYy9iBS2cbt7Q6Oq5ZtIb7GrssleTEofs+g3wjNnA7p44J57ujFpJvw45d64RhEwuVKpI5P7xhqVNH39P5MytdUmmi+NC7RKPkhzbVI8yXHoxsPJteilkNTeEhpKDbSAOewIvdPk8VrPkD4ZROAYbGIFGsRwPTPxKrLN54RDLoZWHlw9K1WBYHIOQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gqYeWMoi; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gqYeWMoi;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlRM4CPPz2xf8;
	Mon, 16 Nov 2026 22:06:23 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 026636293C;
	Mon, 16 Nov 2026 11:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CE11F000C4;
	Mon, 16 Nov 2026 11:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827180;
	bh=VWUjc/lm6IOzTKu/XrjxEXkA+3TDHZe6UgBZOCqPWKg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gqYeWMoiimKnvtxsZfDhW+FmTOi7BTYxF7bo1d97YCVIcFzQE/1quY4S5XouMi3vB
	 mIvfX8HLza9wbhVfQveoZSPNYa7EZm6PUCmHQ7skz2lmq1+o5ujqB3Qz/i2/xmyuvR
	 0b4/gWtXnDtYIY3WrioVdCD8nsc4XHXOdDDcY2gKhZ/KosrpWqVHiN6+7kfAXc2Ahu
	 If9E+wIs0Kg08YhaHkaKtxLqpKU3MXnTXiDfJS25gkPWQfrBhMW81NVuUjfaEMsu6P
	 vgEPDQeb4sn9onP21h80NsMHJnf9A+r8P+Co4bTECH6PFFrHeRa5TxSI1gVwQGLhtT
	 OalR/X8sFsCZQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:35 +0100
Subject: [PATCH RFC v3 02/44] nvmet: check that the file backend supports
 ->{read,write}_iter
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
Message-Id: <20261116-work-loop-pseudo-v3-2-8cbbea1cf34f@kernel.org>
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
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1339; i=brauner@kernel.org;
 h=from:subject:message-id; bh=EG8EaOiS0vQgTkKg5XSiMzmkRFf0paS6Df2fYJxqpSs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epzAcWr709tb5k+1mZtXOrOoKe7FjPPX93rnL01cc
 mp3sNpj3o5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJxH1n+Ke3fG/p7vfHb83W
 Mp77jIfTTjdGPfuMqexdx60Xbl2XDD/E8D9576foPweu5yU+nf3y9bU/t+YHf7W8oOhp5cy3bNl
 qq+9cAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The file backend calls ->read_iter() and ->write_iter() of the backing
file directly but never checks that they exist. Everything that isn't a
block device ends up in the file backend. So a namespace pointing to a
file without them calls a NULL pointer on its first I/O. Only
buffered_io=1 gets that far as the O_DIRECT open fails for such files.

Refuse them when the namespace is enabled the same way zloop does since
commit 0c10f8a1a7ae ("zloop: check that the zone backing file support
->{read,write}_iter").

Fixes: d5eff33ee6f8 ("nvmet: add simple file backed ns support")
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/nvme/target/io-cmd-file.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 695963dd932ee..dfa8aa46188c8 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -47,6 +47,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
 		return ret;
 	}
 
+	if (!ns->file->f_op->read_iter || !ns->file->f_op->write_iter) {
+		ret = -EINVAL;
+		goto err;
+	}
+
 	nvmet_file_ns_revalidate(ns);
 
 	/*

-- 
2.53.0


