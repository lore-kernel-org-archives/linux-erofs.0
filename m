Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252AC606A33C
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lugfFYds
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1Md5Lc5z3dRJ;
	Tue, 10 Nov 2026 20:20:13 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302413;
	cv=none; b=c32ZrX8JaCWVcZpcAaR3I7+G6RL/eV9Q0sTW9lNS/ufKmk6yM+XcN5zjzjnFSE3nZMWJS+xwqBRdnSJRNETwiRoJRrjePPyt4Uj5fwzbpfrR1yDYrknwlnOYrk1gzQNI0T6kIf4KXrCYZOdK0juOiBcFOUeAvfxEvSekPtaNMl2ZRIgQMb1I08pS/p3d5ufeFbJl4onD+zVvsbKgIPsy2zLsIT+BjexX9qiVG5rPPLVfAqSVrIMRyEY4SC7aFyP2e22uhL2zo9j3y76Wd3ayal9eujXyfJWGEVjId73Wt24nFEKHknCVvePtN6PReiwhA6/vBOkzeVQ2W5yzHf9KMA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302413; c=relaxed/relaxed;
	bh=wvcrRKkVitwBIHc8bsc86Ap1TkghVmPhKT6D7YPBbwY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jhwdooDV5feNkjFpr2ByhOAreUvfujSRl/D7iWZfRqgb1hw45GNZYvmQoYROzH4WXnc1qRhFtkaSQCjKo1Xap2jGvx9GXw8iITQquSJLsg/hQ9NCvJ04GPE6C5eAOsLXL5677T0z6CbsWM+R6lyKkyOvi8AcVZQhKPzRhptSTghkCtS/qSLOtjDjhxTvFLAXsl3MjpcHJ/os0szVQA/t3kb/c1k4zIkumgIykH7btz/5TuzAL6w4d5C84TiE9R8xnq/GNgtB6qWtFeWRjQ1H4D2lMt1LKypOmJUc7uUuA0xyx4gp17auUbsvN3RnzaszFsg/u617sEz1rEAQ0VXpCw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lugfFYds; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lugfFYds;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1Md0qhfz3dM6;
	Tue, 10 Nov 2026 20:20:13 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 349816381B;
	Tue, 10 Nov 2026 09:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E501F008A1;
	Tue, 10 Nov 2026 09:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302410;
	bh=wvcrRKkVitwBIHc8bsc86Ap1TkghVmPhKT6D7YPBbwY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lugfFYdsp+5acpRZ62DrLNSRpPTqwD6ALObkR4htZDZ7jJ4CwxnL+J31LlzQBLdHg
	 S3Q6wKQ8rLKVDvOjaO/7i9LdpOAAGQkJVKTTZnDkbfMZ0mXM3yVItsw5AH/x4JgMCS
	 r17kh6jTusP0FcEnEBzFzqzJtQ746vPtMKO+E1iLTHLZ7PgzOBIB9SrMppxD4aMf6g
	 ++c6vcWP0wgZ4rHVjr+6Av5KOdeAceVogEGD1LonYdJsm5MlecXYdFkPg3OEFOR0DA
	 l4vCIncvJpwPXykOZGsC4m66wbdnnjiMUoL8mSoluVAzhYGK1Oc9EGsTAAgpOcHIVj
	 fpmwuommLUy7A==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:53 +0100
Subject: [PATCH RFC 37/41] target: fileio: refuse files on pseudo
 filesystems as backing files
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
Message-Id: <20261110-work-loop-pseudo-v1-37-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=995; i=brauner@kernel.org;
 h=from:subject:message-id; bh=BDYGZBkzpJOf0luK2Iqx3jSxHLpIeW6e4aOnDtryI1I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDf6mtMEqNwmyJbTeSGX/PXP05KecQy9ejD6kOb9
 /3cf9Hkd0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBETl9m+F99+X7Ky605zSv7
 GErvWk1zaPix/Pxk04Q9+p1/0oTy/pgx/JXbprm34uPtr4v2Ll0y0cL+SOu1/dVOakafmv0qqj/
 fj+YCAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

fd_dev_name can name any file including files on procfs or sysfs. The
initiator then gets to read and write kernel interfaces through the LUN
with kernel credentials. Refuse files on pseudo filesystems just like
loop does.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/target/target_core_file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index a5391e57e9aa..7a3cf63dc979 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -152,6 +152,13 @@ static int fd_configure_device(struct se_device *dev)
 		goto fail;
 	}
 
+	if (file_is_pseudo(file)) {
+		pr_err("FILEIO: %s is on a pseudo filesystem\n",
+		       fd_dev->fd_dev_name);
+		ret = -EINVAL;
+		goto fail;
+	}
+
 	/*
 	 * If using a block backend with this struct file, we extract
 	 * fd_dev->fd_[block,dev]_size from struct block_device.

-- 
2.53.0


