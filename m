Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0326E606A92C
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oIOs/EM+
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1JC45zCz3bl5;
	Tue, 10 Nov 2026 20:17:15 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302235;
	cv=none; b=aPWfgb3hxThCkpYFAAN3WZ1Y+cu+/uZbskWMaxJWk9m9IXsc9awJlC8bqWgvtYliNsz9yucpFgEYrwOHRUJwlbGXvzeisJ6OJ4jSB1QmvLBTKMRWAGA/WBoKDEykS3aINXeFHctBeDHQai+ycTX1tyB4sYyjM53parwKQEP5H8x3Rsa9r1fsf4seXiklJo0VqV3B7RU6/SBgCgxyoYLG7XcxjnP2HTARfhtHGYlxCCrtXVFEPAPoOZWmfSCOPolCK2hVug4JyhvRA86GlrRLWWmuWNXMEkaue4IU0+80aLDYU6NgBFB5u35Li98m5IWbVzRuxlZn4bBaIzongzMjpA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302235; c=relaxed/relaxed;
	bh=Aeiu3UyUCzSAfqYn5Q8bZyz+wYYebjsNU8IIX+ZzMDg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aWX/hNaSLdhf+hiGGZaSp73q1fsTUjjSQmLQTv2xgIWqdR5lU3Bwn6Psl/8buLEnWXjJ/LVTbPn8Ez+k39VHtJhFSSxr5dYN/YQxhu7ayhUnJVarPRDAIgqiApo7gwFdXKwsGfe9/ljH2AVT9EvhDISCA7SuBvDUsj5ZOPzb325V77OuUqknG1OIMuF+en9Rd+yS90Ilu1dDgi7h85oLMvTDrLeTbrTKsTV4IVWdN8y7J9VdbY7XZo5tVBuYMfR1qedoOhfUmP4YJXHFPSUVC7U2KcJuh5DW7HnlUg6nTpGkPGE3FeBflYtFy4xXfhLLGKIcezwZpc2oM3MQ3tTNpw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oIOs/EM+; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oIOs/EM+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1JB70rJz308H;
	Tue, 10 Nov 2026 20:17:14 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E24963804;
	Tue, 10 Nov 2026 09:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3D61F008A2;
	Tue, 10 Nov 2026 09:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302232;
	bh=Aeiu3UyUCzSAfqYn5Q8bZyz+wYYebjsNU8IIX+ZzMDg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oIOs/EM+KXYJ1grlTivKYR/ku8jTJ0m+cIlI+pG3YVNmGlTgU+6mJXjsBjanfGWq1
	 8T4XFq0QNRg8zsAR7ESB+aTONXWP2FVgpzDjvL9j6/UuounNAWxRDH5vAS4BK+FriA
	 AfJ2mWd7w+XhNvm479SKkBvm8bw9ZW4l45/S/N6hJoGcFILfLfz/Qcj/WnSIAKKHlR
	 aZu74imaFzIlgEUKmwdk+yZz0BxAbckL3QBgudLh+hdwVCHz4VM3nz2NTqfxr8RO87
	 0wJDp5SY816Gwv6wS5IRgzFg66syGlemxNOlITSZvr+VV0w4yn0U9xfFOWxx2iUo1Q
	 ypT2aD1Wz0XJQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:27 +0100
Subject: [PATCH RFC 11/41] failfs: use fc_init_pseudo()
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
Message-Id: <20261110-work-loop-pseudo-v1-11-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=879; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jMBLnsAt3YLGCzcD1+vp96riKCztRaww7Mw52ZY6Vqk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDgSsTlaLm0BaZPb2g9zFBdk3jqJpvVSZWp6w78u
 SDN++zJ2Y5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJ6BQy/M9iFhSuKGdsOHT4
 K5PvuWfptRIcgVqXrHXW3VP44fKMUYvhn/I1R41K+fPTD11o4sx5ED/hfMxLg0sltflhfgn7d1b
 yMQAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize failfs as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/failfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/failfs.c b/fs/failfs.c
index 437cdc981c2d..f03334f361c0 100644
--- a/fs/failfs.c
+++ b/fs/failfs.c
@@ -3,6 +3,7 @@
 #include <linux/fs.h>
 #include <linux/fs/super_types.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_struct.h>
 #include <linux/magic.h>
 #include <linux/mount.h>
@@ -132,7 +133,7 @@ static int failfs_init_fs_context(struct fs_context *fc)
 	fc->ops		= &failfs_context_ops;
 	fc->global	= true;
 	fc->sb_flags	|= SB_NOUSER;
-	fc->s_iflags	|= SB_I_NOEXEC | SB_I_NODEV;
+	fc_init_pseudo(fc);
 	return 0;
 }
 

-- 
2.53.0


