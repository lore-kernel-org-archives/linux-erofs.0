Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1191B607D221
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M6eYgI6Z
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlTx3dmwz3cC4;
	Mon, 16 Nov 2026 22:08:37 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827317;
	cv=none; b=aLTF8kp0pcjVlZLOELKnzkXcgp1HAXyPvxiMvr/KVi36vMlk2wYwqaNtIM7dvkpP8s2liaf6WqQ/5w3k8CneiH9Owqhv65AKjZTs07LXT4scMJtq6QGIY9I1qYhLTBMoxDuYsHtWqWWwsOH0IAm0JPg+MeCPg3K7gwuOEAoW4ux3IV1tQggg4eCB9d4yMXCcMEhIFD81NwuYErYCzu4wU9ZOcR8qY+RQ90C0iKzEbvx61OR1IOImOkdEBAnMHJmXCeOxBb4BCircFfsmHgIRCuqtWR8I8x1NksrrVB4kS4Q5T9SZT73JavAfhEuN5+oRklyOYV+e7IOY1mkQhPrQ8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827317; c=relaxed/relaxed;
	bh=jWvZBvrR1DOnVrw2+TUZXk3eg5enGUE+5GG/CSvPX1Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OAGPszQA2TDl5Rh/KAMuO8+zyroWeFygD/MbdjBM+PBobrAcqf/nZdGaYKbVnato7HZxTjLQ1+P7FwWpaarVIH6+jNtOst16NXDwoEp58+ArXd6n41ZjW3gc38q9npsKCo7ZqF1OD7POVPhOA0goLOD7VhRToNDKTx7Ov2I6Um2u6EjmfLswfmMfs7GpPYt6qI2usDhFtmzYuVt1PSTHV1llcn2B5nkNZ2Kf6Tb96thzL9saxNl1Yrlh+rjeLtZQABGqZ0hpldyGDa+FR80p9UcfiuUJwzUDgu/0g5fweYa9QkCmBcYssXdaHMgdgJ/ZqhHm/kIGTqguNTU2s8bpSQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M6eYgI6Z; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M6eYgI6Z;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlTw6w30z3cBk;
	Mon, 16 Nov 2026 22:08:36 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 755FF41650;
	Mon, 16 Nov 2026 11:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F771F000CA;
	Mon, 16 Nov 2026 11:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827315;
	bh=jWvZBvrR1DOnVrw2+TUZXk3eg5enGUE+5GG/CSvPX1Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=M6eYgI6ZSCWFmdAv+fAKXRWQeKnBvNmi3ZGo637XqBmytIJecsOCK8L3K76JPXXYP
	 ZDPxK+Ub17iANZxNSKyVdQBi8dIcKzwcfFwcTCWZPHberYy7Dgy2T/eRZfYiblTD/U
	 c6GlWKRoWjOZBL0xxEWztgdZ+LarTM7lnyr+L5QUayqTvcDKYMI2riwgHl2jprvZgH
	 USZr2oeMdzb8nM+mcT8jPB0bEtaNdZsis1cazQz7ZkYniO5Pq48EYVmjMP3dWQBom9
	 daQQ9/8p1AQEcogykoG50jophGkGugVTSDHtKXkiD8LEQcS8k5lbk6G80EZfEpoPlN
	 0Q/R/MMLzKqVg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:53 +0100
Subject: [PATCH RFC v3 20/44] apparmor: use fc_init_pseudo() for apparmorfs
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
Message-Id: <20261116-work-loop-pseudo-v3-20-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1081; i=brauner@kernel.org;
 h=from:subject:message-id; bh=NfojWSg09WkliXy6sDezT//cu9zqICvIe5+KQz3E+8A=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elwq/vSPWt7KO3sOFNTGK89qCpZfP0G03cB2BnODS
 O1VoQXbO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbCsIHhn4LYxbUVE/0Uvyou
 mbw9Vp/12f3yXZEdk7pN8p6JL681O83IMMWguV3BybXeKuJN4+fvR5NTypbM05p2R9owKS/KuHA
 ZLwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize apparmorfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. apparmorfs never holds executables or
device nodes.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/apparmor/apparmorfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index a993664672173..351ea3a7120e3 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -21,6 +21,7 @@
 #include <linux/rcupdate.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/poll.h>
 #include <linux/zstd.h>
 #include <linux/string.h>
@@ -263,6 +264,7 @@ static const struct fs_context_operations apparmorfs_context_ops = {
 
 static int apparmorfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &apparmorfs_context_ops;
 	return 0;
 }

-- 
2.53.0


