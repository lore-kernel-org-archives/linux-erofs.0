Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E6E606E58D
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YSj0RR1a
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1MM1LNRz3dL2;
	Tue, 10 Nov 2026 20:19:59 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302399;
	cv=none; b=nr6+Rysj2M1nCmXyW8TTGSwIYDO6gdgcHPIszfLR4stghDjTyn89Yagx5MKm1/9Q77Gufw9HK9fPB2l+Ani43f2OLqOmbXkWtj0T23iQ/dJyHG+o/vsd8jqLbxCmpVNTqmd25CIhXu4MRdeP0kut/sIHc45jerLXqhGZM6tZgpHaQpItM4joBCTqf7ejk+cx5yF0fqPpZUDJHQRRA4QFCMz/oGCjyWr9gnfUbrm4Ovy4HLDubJeFrW0cPEPHIYlGj9zG7Z5rgjo/ljjJ0ojXY6ubB32fgGN1ums5IJgJPRk2O2v7SSao5EKptdu/gLEK715PUxe2mqbQXhXh4PzXOA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302399; c=relaxed/relaxed;
	bh=qJiFf9w4hToXcclP9ppmON8B46ZerQobJ1F8sM9X2a8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ObMtqHdfRUDVSfAyjvgH7J/4p1hQ8QTPzp3hzvkJG1JHkrxGqkNiL1MlUVvKWLUsJz2IU91GzJuRqztJP70/2dQwdkY4iE2ZSvoBnWC9ri+vUILfOBJfJ0hkbWJbc+FqlTnMBsqftGYXcQ+vv06hm0/+ou5+KXYmNBEnhRdappdvy9lmtISJ7VfDghSKXyJtALl7nB/OIhO3oECTaS/C3rUvaKZKxEzjwoRXyUotKR4O6PF2PN6DzQ5aZqBfSUoC2tu6rYKO/5k8wU6OD1EPtASN+B/lns2rdQTRodViXDxvbcBXiEz7Xmb4nCH+oPP3DLxd/8tICS5EctatPpvjsg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YSj0RR1a; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YSj0RR1a;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1ML4Y29z3dHR;
	Tue, 10 Nov 2026 20:19:58 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0712846B0B;
	Tue, 10 Nov 2026 09:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F39D1F008A1;
	Tue, 10 Nov 2026 09:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302396;
	bh=qJiFf9w4hToXcclP9ppmON8B46ZerQobJ1F8sM9X2a8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YSj0RR1aG6qNPyxHpaLvknjLVj91ILD+92zWFulNcS/9GzuRoaQHatZawU0nYbR8y
	 wus7ohgAGQBai1txsuKrJnXmIbOHGPu8ofJJf/FVDtHI8ClyJKzU7qfsjBbW0aZ+ce
	 zWv3AeSLtwvY+Mjd5A9NqJjMByywMDui/mH5eL6dgY9srHxtjNOSh4WuAXPTmUK3oc
	 rj74FmSQAg97IU/fPvixOSTy1hGHbrW8yJHlHbDd2o5Lngy9Nmbmsk6Ah2dyvn2OaD
	 xaVAA8ELW3uvaLp+l18HV1m2/38wuA8CuBANF9a3ezWOwggIRGtvqG3gki5e2MoaKT
	 vZL834m+QNo/A==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:51 +0100
Subject: [PATCH RFC 35/41] zloop: refuse zone files on pseudo filesystems
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
Message-Id: <20261110-work-loop-pseudo-v1-35-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=822; i=brauner@kernel.org;
 h=from:subject:message-id; bh=li+gC8cc0Mt1bD1j4gMcmL8SOHESlN2++n5Uf9tP8Fo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDHcu21pTOZuhx19nwxdyrrCmUMb3503015p6SPw
 76FMcqxHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABN5bMvwv9AwrjaFoTvl5SXZ
 U7d+5SbufCNqdW372nkxojHPVJnq7Rn+R03u+RT9ITNnZY8fx/JF32OmNseuuiD0fVMyz/+nq9X
 nMAAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zloop opens its zone files by name below the base directory but a bind
mount can put any file there, including a procfs or sysfs file. Refuse
files on pseudo filesystems as zone files just like loop does.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/block/zloop.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 65634a39b0bf..dcc06dd47b04 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -1137,6 +1137,11 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 		goto out_fput;
 	}
 
+	if (file_is_pseudo(zone->file)) {
+		ret = -EINVAL;
+		goto out_fput;
+	}
+
 	if (zlo->block_size) {
 		ret = zloop_get_block_size(zlo, zone);
 		if (ret)

-- 
2.53.0


