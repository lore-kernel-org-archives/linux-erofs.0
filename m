Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E6360A6F54
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RAVzUn3Y
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZB961cvz3bfG;
	Sun, 15 Nov 2026 00:05:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661553;
	cv=none; b=j5ejuCuxfL7oFryxoNlzRL9ZMw7HwOFApLp9lYfOn8j8DbMiDjSSkwBDwMGrVtyoNSLGgMEyLqcCRTZA2wKu0lTT/NbUefBLmvdOSdPZBrHGgDx1w/n0Dq9Q/R38c6gwgeQXTUyIBhaEvyl29BEcucJgeMcDSZZpa3+kzTf7xiKxJdCUiV7eSQIKcLDf5er6xejGiXm3EURvEIPL6MTnbORsm40My87kXmy7RZatpmU9Z7+kbzKEV0jG5iMP8iU+w8I3mtCEBTd/KsRHoUsptktGxUsZ/PBnpK3gAjGfTtejXxqkjXXJ1Ipb9ASK4RbxfG/yRbojUgA7ozOYWRFalg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661553; c=relaxed/relaxed;
	bh=E39AX+G/jh7TUAATD8FoQ3LTHbJD9uA3ozmx0gOpFaM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=d7mnq0Ydh+/rWeavOmu5LS5nmfYW3gToMxWNKyhHpWuvouybiau5h/QYAEGYF1ziWjcLcGCyAIVXlyyjmra0pqXBjzsNlzHIIuN9edeeEsmdFJc0yf2+EBU0yxpECSW/Vaesi90U2oVTCSl4EPVXyTvdTz/KaxY67N1JuMW+kctagN2q7wKCheXfBxiXzYJI7co169JlMQrEa1up6nI/nSeiEiy2saQevI4LxiPxh/XPEso7ugBQs669Qhj7IxL6J9rrggnBS10uc0duxaeUO5PaHhYVQEgqJe23KRj0sT89rvpyr6fRJRq5GhK0Cnwjah4eb5NNT0n7VxmhhxTfcQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RAVzUn3Y; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RAVzUn3Y;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZB85rWYz2xjv;
	Sun, 15 Nov 2026 00:05:52 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B31E40C46;
	Sat, 14 Nov 2026 13:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C8A1F000CC;
	Sat, 14 Nov 2026 13:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661551;
	bh=E39AX+G/jh7TUAATD8FoQ3LTHbJD9uA3ozmx0gOpFaM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RAVzUn3YihPEfR8QNXiJZ4kO+0Ww2rPP5SABGZnl60hGUL2Z0RR98pxZaO/RoCDhp
	 vFYwvxbUW2TAi/HXFTMH17UIgslNBpCFe+PegPbRAYGSEPrqXonsLU/7Mi83e0RghI
	 czwaB96M9lWGq2+Bal8IV3hGZe6UTMGaixjoty54b98sTD+UZ2KloakvmTGKcP2Jtj
	 qKh6CkT3Y7cwABFcxmNSwVcEj2qVq/VdVxme/wkozCtmB2Ld1vYY0zFO17PwNCJ9q8
	 9qOOW7IJz3w0BfWgmHzKZBLNseME+eb0Q9TOZs/6zDxRI/611bKgvwwKnGnKZ+bkRy
	 yOh/Udy9zGjgQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:43 +0100
Subject: [PATCH RFC v2 02/42] nvmet: check that the file backend supports
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
Message-Id: <20261114-work-loop-pseudo-v2-2-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1291; i=brauner@kernel.org;
 h=from:subject:message-id; bh=//ir9fc9dMVqltiEAJAlWV+b7M4aWVaisbvAL6AhlSg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iMn4JfhIyMuq+MC8pis+ES5tTa9bd7/WXjzJ/vXPK
 QH3uOszOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbys5OR4c7lBycqbVyqBPoK
 F7087SO3W5fzvW6nkVvw5Mw915xkFRn+qe1OU1wTfjyRac5dfqezqXvv/Qotu/+h6FShzocNC3+
 l8QAA
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


