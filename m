Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BED606A901
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B3k5bbEA
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1H14nX6z2yCr;
	Tue, 10 Nov 2026 20:16:13 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302173;
	cv=none; b=E0Q+2i02TqO8J8N08vR9uIIW3beIqZiD4kUq1Gas1SsPgc1VGExN2QZGQlA3gAtnZF1W7EaGtEhJQyFQdxJFnBewdNdC7MwFB8GEFKnkM4JmUd8M8X+JrxY2t3wW4p/KaPDO6ddTN7LidYadTbNuOsGrmqFsXkR57BjIGqGEFe9lWzo/mqYZr3SgDNoCVfnwgZuL3PPxGZFvXIhh0uzZ5AeE1WnmgIUQsedIZUpXiOMjrUhF4tQiAr6UfCzDXbftu9jS8UexJoUZUEVTx/wQPtim0n2+tIDQwgaCREWi+RNh211xChdsiJTT3yr1pYhx8bXSHf2q/Io2X+jB/8fHkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302173; c=relaxed/relaxed;
	bh=48wS641dZNlMgTbgKHYJJRZjCIIpBYSCk6vN7nPVst0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mQiy6PQuEkDBAkeMOSW88nCRAEc2OkthkiiIal3ewich2w/w70yg5fKJ5ZlmeECDBVUHUXKmx/rS+aiHfv73FqLtz6ZgsZZbArg+ZN23fRQ0zJpdAO/wEfCGkFvKbv4tynHccaX0L5qO6plibn8P+Kts7rlNRbBpQ49sR+ttEhg3Ek6gW4wBBadW7bW3xxUZ9IGjVuR7ETWkmR1TwXJxcWxGGnriSPXuwXUTU7JJapstITMXjqPaLk9VUALVSWK4FYbx/YoYIOUltNLPwEMNlHagyEUTya/GyP1Gct/ydUbMwfXvW3TCwPHAUSf5z5fPhbsfdhUN1ByNCPqiek4FAg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B3k5bbEA; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B3k5bbEA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1H10Z9Pz2xfK;
	Tue, 10 Nov 2026 20:16:13 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CB1744729;
	Tue, 10 Nov 2026 09:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7381F0089F;
	Tue, 10 Nov 2026 09:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302171;
	bh=48wS641dZNlMgTbgKHYJJRZjCIIpBYSCk6vN7nPVst0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=B3k5bbEAWfpJtZp1vzeXux0KzrY0ieZxwUJi/83P+f7eKHCKBYc9mkYVfNK2b/51Z
	 IE7odp0lQqQ7mwusK6pgB1WlHVkO/UlsckyLpTfE8Yp89sMOk+QjYT1he8sjTHJobl
	 zbSxv5PQZ8XY+Ts/6iaugpn66hCj3rJCosVRpDg0+EuqU7+TpcsCN1TcwITx1L6QCL
	 1C6NNljvCVnJ+dNekIZ/1LCG3UXVW6y81kv+eHD0umTjqyrBp3lV94BaeU5UIyHZKc
	 zDKybfsspnrP1qhiqd+dsnxznVfYXFvZSeoRYSBElTyxocH2QJC3b5d8zXbtpIhziF
	 ygU0pzxGVue5w==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:18 +0100
Subject: [PATCH RFC 02/41] nvmet: check that the file backend supports
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
Message-Id: <20261110-work-loop-pseudo-v1-2-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1206; i=brauner@kernel.org;
 h=from:subject:message-id; bh=9rTO3vQgbbKMLgtf9DhInii/7oHGTrugRkWUh4dwMMs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9ejBtltmGmxnek3mf9QvZzp8xjWWx5Y+Awzls7lyHP
 /4+2Dk3oqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAivzwZGU4478oq2RB1Nuut
 48Jj7Tu4n8+545UyJdpwumO4VdS2g7kM/9TW5p9ep3/AsD+mInRXw3I+rR/SC0xnPXVmN7wifGZ
 vBB8A
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
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/nvme/target/io-cmd-file.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 695963dd932e..dfa8aa46188c 100644
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


