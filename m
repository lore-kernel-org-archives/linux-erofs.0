Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB546080D47
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iQA/sxsh
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1LR3TSRz3cdT;
	Tue, 10 Nov 2026 20:19:11 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302351;
	cv=none; b=W0T4BWpOXFFMobNx5075OJNw+zlm8DpGLFky9HxmJspEZDKQGhkqEGbQnBRS7BZP2cjAEo6/v9NhUgOxwgvZdj2AVM+A0zv7ZfVwXZvmFpLLcaVvhU51wut5d/LveeAR4o1Z7vSIx9bavvo8fnZeGOR0mYO6cO0hYlHF2pX2YF2eccCfG4KD8N5ILRLs0m4NcszOb56k8ka8NhUR9cPphwCwzE51dL5su0I3roe0n/tjfxmy9vwwiKULBovG3HD610q5yWx2T0OeoA7e5YN0zdBUGjMwe6VTlAQVproopYL9ocXgd3VTA8MXbjMCuEFxIICeV34QZh2okq7PAasMTA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302351; c=relaxed/relaxed;
	bh=5VuE4/weECRM9eIO6+lamMRzkXENJc2tSdRrjKtP/6E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=X+wZWKaMnslF9MY16/2XLz1Ss82KM3LNg9D9W6TIEcWgRzhE6ANnjvODblLvu/ZJfEKCVH7+yZ9d5Z2h5a7U/ys5bTl+l9tVK4Ihp1NESLJsPs0grsBEBQVINJPfzPi3rSDCOHFu9UvZusXsy1fbTqirzfUnjMAYLsfHtogmLV78FJ3M3p2lTT56xK+SVduazhVZQkgx6a/gUmAIDb7ZjL52x+uaGOxHwqAVcDE0kVhe8HafghJBETGGFzubgJ8BnyXPs76t/0kmgyPb8WZ0Kn/sjZyQz9t71ic35Stp16VWhx1ytXUa72Dcxrv+wWP0Q0BWALq0EJ6DVboDD98cPA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iQA/sxsh; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iQA/sxsh;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1LQ6GNkz3cc0;
	Tue, 10 Nov 2026 20:19:10 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D6824487E;
	Tue, 10 Nov 2026 09:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77511F008A3;
	Tue, 10 Nov 2026 09:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302349;
	bh=5VuE4/weECRM9eIO6+lamMRzkXENJc2tSdRrjKtP/6E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iQA/sxshAM8lgjVZtwQBlBlt6Ccgq/KLZUd+ak37Q2oUOuNb3EKD2IEz5QKL7HSuJ
	 PzfYZUUU9t4mHJQyXpGh/FegWtFPckXXEaWIZpe18Dzveuhdh412cFkoYX9U6GHhAs
	 FA3mIwVRbXfRG/foFS7hgF8f2XdzXBVoA2mbPV/1dW+mNpe42vnBoqn1KQUo3a7IH3
	 OShJM3zaQPTgLbpL8PYQYa3MhajH2yuDWbFWTSzcixuX/GpsV21irhlminf8YwjK3i
	 FcMM/10RV269QdY1WwY6VGtRQ1P449Wk5bY3A8Uk5z3MdBjKp3IUMwp4dCZ2nOAdUX
	 a+oxx0hQk158g==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:44 +0100
Subject: [PATCH RFC 28/41] ocfs2: use fc_init_pseudo() for dlmfs
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
Message-Id: <20261110-work-loop-pseudo-v1-28-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=909; i=brauner@kernel.org;
 h=from:subject:message-id; bh=IdNufAsq5EGNNcdE9WV9rVN1DCJjWbb8v/riZT7kRA0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDl3LqF3BIxnOW7s6R69N3au4r1m0WSo7rUW0tPb
 d3ziC+no5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCJLTjEydK1aEV6R03Dp6Qur
 9ReajrtK9AT09OsHms5fHf0wofDSUkaGzj38rmzbCz87b5+14Zu8c8plz01rglO+aJ1tSLofN8u
 eDQA=
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

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ocfs2/dlmfs/dlmfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index d3bfcada3e3b..1789ec96dc13 100644
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


