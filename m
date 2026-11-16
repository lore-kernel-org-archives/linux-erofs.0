Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9259560724C3
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UY61m139
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlW500QPz3ccg;
	Mon, 16 Nov 2026 22:09:36 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827376;
	cv=none; b=DDRejpv3ozrev5RHF1hkblWDnB6ylZ0TgZ5pIF5dbfRnyYTrAIMsJaskeKUBY7fDj5UZMnJTx+LOEEsEHG2SuZZghMoa3Clo17ZjpROQh22oBOZAiYHHT228BBnHkEDrAJqE1JVGoHKxTi9r4cuuE3MVxRasfUfIDemXluePXnuWVHEmqrRCJN0+uQ6JUAWaaGKbcwtgnJOEP8dpvAi0rEN4RvG5GU0VU2tpW2/OR321VZ5kZdTGABBDXmaBFZWwEbyzD17kpirMmtyxkmVrWe1WjdTgvPecnigBd7o5eC3YWTdimun+vnVAEAmUkziXzjNN5WUmVQotJLZEofzkOw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827376; c=relaxed/relaxed;
	bh=GA9SDweTRi4TPXcTEQAFscMtUQB58wBJUJ+Dpl1Ho9Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OxIAiHv4fNy4zGFcJjTYVAFWotT3NxaMUPdGiVxy+YS9oIMiiyRcN8wdgGYHtgIVJRdzHqu+KQY6oVN/MKZNPvbCN3adLphZ0JxydfpNgiR8kirP9ilBTgMsEvm/IeiJvhfE7iW5CjWnbKX9M+2AOLA0C5HPMeha7CGC0ymRd4nFOFMXwgkk7jjXGFXm8WaZCSE2S1LOfaPTsBMyEtGJRX3bRg2ZrhcJVwDLazfG+SmlezVvxmjRQO0iTsKEZxn+IYD8ZS78ye8YpwudKFtfRlEEwJsrs87T6Xn5sjOPqVTIyVTl2pCXsR9zTXkoUqe9z7YKNVZhMdRKlgLZhlnx7A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UY61m139; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UY61m139;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlW434fyz3cRP;
	Mon, 16 Nov 2026 22:09:36 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6440401D6;
	Mon, 16 Nov 2026 11:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2951F000C4;
	Mon, 16 Nov 2026 11:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827374;
	bh=GA9SDweTRi4TPXcTEQAFscMtUQB58wBJUJ+Dpl1Ho9Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UY61m139fqno9VQPvlV0NuBKhsaZrGDjrVzYlgm7LD6rQ5l5RLgAEz/YOurVtzhaU
	 qWs1Q3SpXOFEmSDFy4inEO29N0SZfbZ5fIb1NekL9cn3PvqJ6DyP4XAUxn3ozl2ZJI
	 p23wAbdf2yyN/romcxRDKr39Pbs2B/eeDzuc0T+uKi9yP3S8xjvIKh/Rs/IdXfbP5R
	 Mx/ud7lVz45gCjw7vwqFLBkjvSKk9SMvO7BidByfWJxJFW9iY0IoIxHKSuZIU92ddZ
	 aJPF5uOwKvaCzHfS0eMFmp2nXScO9LNfO2AwBc+xn3LaqIAOhZIwFema+aqToY32q9
	 RwJnBI1OJ0XQg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:01 +0100
Subject: [PATCH RFC v3 28/44] ocfs2: use fc_init_pseudo() for dlmfs
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
Message-Id: <20261116-work-loop-pseudo-v3-28-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=997; i=brauner@kernel.org;
 h=from:subject:message-id; bh=IB1X/Ir1PaWyRnPeEjajubDonNXHmf0+IfXVC+GqKVg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elwvfOHxw+ltDXUTZ+ofeOXJ0hER3a2ieLJd7uhR8
 /iS/m19HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPZXcfw3+kCa24qp2Bz09eG
 L8+mdnSztOooc+yd3XlZ1ff8S1e2nQy/WdNCAuRMJW+dt9Cc+Y1r4eIJJ4r+Gs1+8uby7aLo2c+
 y+AE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize dlmfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. dlmfs never holds executables or
device nodes.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ocfs2/dlmfs/dlmfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index d3bfcada3e3bf..1789ec96dc130 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
 #include <linux/types.h>
 #include <linux/slab.h>
@@ -563,6 +564,7 @@ static const struct fs_context_operations dlmfs_context_ops = {
 
 static int dlmfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &dlmfs_context_ops;
 
 	return 0;

-- 
2.53.0


