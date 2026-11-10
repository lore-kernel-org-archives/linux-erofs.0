Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721C3606EEF9
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eIJ0bZ6Y
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1Mv45Pcz3dVp;
	Tue, 10 Nov 2026 20:20:27 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302427;
	cv=none; b=JB7T0udrOEsIyPl/mEpkcSFD/VzfsvcK2pvnA/7RAiuVVqImhJ4HYLvRFMek3OL2/NIzOtrOJpnF/APGPbdtu9+hLBk6lrCtoLjNB8Mzt0LkWvXWEqVTnzd6nl1JMU2Yx/w70PpwENdWIcN46z1exmrrrYBp6Xke9PalmV+kjCOXe//GipqaDgl26hPo6xaTAXZ0Hxl/HvC0OscSDmBsMh8tLZVaV4WXV9mkIUaB7n7wb0AtxFhAmw4NgdaVOTJ2N1l48xD+0MuaR5Z0S6AOHa+vHuYSo/v/sCl2w755bZ3JLKflpYotjq5+qDnRAULnN/IMoUsMltrzkdirCOEgZw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302427; c=relaxed/relaxed;
	bh=5v6oTkZQz6qlfBhdJSuXnvnO8rYqx/rzC+7+Nl5/OGM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AQWYD/8X2F/qm+rqJnJbGSVhnl74o2ynwWdIsQgpb9ssnDE08yfMSXqTjVDR40pcE8miJgZgvU/63JniVAI4C5OwmVJEbA6k8Vn5TE2EQ0nmbFlHRsf4hTf1srohfNLul+cXq0CK8AsbkC8/8exz4t8GZw5+eSvYWqBqGjcPTPbAjmudIqXqdTfiknZXIUSm1RbqmHDpkB6oiS8qkCBfOXgQ63K8Ux/TyOV0v1aC3lVP6e4bMCdHwhNUcaUi/6c3/UKU6/WkonkYT6qGC61PsiMtbY91cllAbmIGkErD2ygVJwFnFvjmlQVK7gha0hC94i1O2qN/jdaeoYxp5gszUQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eIJ0bZ6Y; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eIJ0bZ6Y;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1Mt63HJz3dTJ;
	Tue, 10 Nov 2026 20:20:26 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EF33663821;
	Tue, 10 Nov 2026 09:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515E81F0089F;
	Tue, 10 Nov 2026 09:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302424;
	bh=5v6oTkZQz6qlfBhdJSuXnvnO8rYqx/rzC+7+Nl5/OGM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eIJ0bZ6YykzyfYaq0uQnsLuPNj+m0vg4MOIRUUV7WyIHrzOWlMn5BpzKyvQO1xQnK
	 lIgHxLYXr0xM6gXAPduca8fCpGnrbXmRu3n7sX++lmrPokRdnMxOQCvAaieuNDey1/
	 rDMY2lnbcyTg88AQ5EnW+l0uOlH6KcCfGavMFZPvkrzrCwVDMo4o1H9usL4RbMeid9
	 8ju7v6AtrNpyzqVV8uy5DYhL2Vr+eLE/ymRsWc8pcaS97R4A8Z95dfIgLeSJCXVpWi
	 mDeT0clD8WfcFmQfLKdl3Rcurbo/W+eyqIPzNmzhefzjE4bnqF8y5kxjx80v9c4Gko
	 v/as+SN9c7AFA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:55 +0100
Subject: [PATCH RFC 39/41] usb: gadget: f_mass_storage: refuse files on
 pseudo filesystems
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
Message-Id: <20261110-work-loop-pseudo-v1-39-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1124; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5CZmEVUvUM8phb7GCUC0PbdIONUtutPPh5jN88b8MUg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9enDwpOymfbk/lix9c8OUO8H7nMDJjqNuYfXt8RN5b
 SZ7VM/p6yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIsgXDP81qmQUMxt7JIhtj
 H769H+D76yOfp7vrv8Uv+XNqFL+3cjL8szGK7szT6zNcPi0pgC3zv/C19XHNGld3L/vwMHyKxLW
 bjAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

fsg_lun_open() takes any regular file as the backing file of a LUN. The
file-storage kthread then reads and writes it with kernel_read() and
kernel_write() on behalf of the USB host. With a procfs or sysfs file
behind a LUN the host gets to read and write kernel interfaces with
kernel credentials. Refuse files on pseudo filesystems just like loop
does.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/usb/gadget/function/storage_common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/gadget/function/storage_common.c b/drivers/usb/gadget/function/storage_common.c
index 75831f2c7abe..83683ade20c2 100644
--- a/drivers/usb/gadget/function/storage_common.c
+++ b/drivers/usb/gadget/function/storage_common.c
@@ -211,6 +211,11 @@ int fsg_lun_open(struct fsg_lun *curlun, const char *filename)
 		goto out;
 	}
 
+	if (file_is_pseudo(filp)) {
+		LINFO(curlun, "file on a pseudo filesystem: %s\n", filename);
+		goto out;
+	}
+
 	/*
 	 * If we can't read the file, it's no good.
 	 * If we can't write the file, use it read-only.

-- 
2.53.0


