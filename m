Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A36A606A329
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Nov 2026 06:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KrPXvwy2
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jJdw06qsYz2xSF;
	Tue, 03 Nov 2026 17:29:36 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25" arc.chain=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793687376;
	cv=pass; b=is8iv7QuCKIPyPB1a0Ys90FFWN1SVqEW6k/IMOkuBZcC+MAOQp0tVgDxLwDeki69Nrlw1E9cuaFHFcUG7cGYvyOzKW2+XiC2X2zD3r+htO81+Ocpihpet5gh91vB6r5XYn3D9XmuIL/DuxZ7DwkqiEomCthav5Gawq/qqrhbU4eM1rh6eZMqppXK30iytGnV5CYVbBSwc4xH70rW0ugiKXNlIHNmeML0xtju4KfDdNfj+Hzz9GZ3W2tgiipRFxsV16hNjGROs7cC8k9/p1dio1xhTVaE7GDqFAIwZF2cajK3jPkWSMkXRQbSJ0n3kqp+8h1szqrXdSUoqcMdVpZptA==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793687376; c=relaxed/relaxed;
	bh=fWQUbPoZ5chZ7TfBqJecBV4M/CrE98rCPN8Xj8YK/20=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=TI005Pryozny+ozpDBnCf0+bWCKteO1EZ3/6nDj4v2eUvjP9TQJzpBuFuB01+E91qmMeAVMMj8rtwA7ILzfXXUjrMTC/rVi8jXZOKEJa+Fv6YmS83iz+8mnFpnHcUDYIieVZVh1LZwaCWLzYaDwmqXb1j6v5utoOVjx+gf3dJ1xN8TBXd/5cmR4hngYZZwuPy7iogbaYLZfQkVwT2XlvZmWN4vkdx3pSPLr+PshcxXzOclgUg+1MjRwT5HvlQ/lWL2dSqKuQndiYa9yHj9i9bj9NKZUXqRjAlE9ysLuzLygHJ3EYs3Lzt1JpKK6SyIc5BLHk3uotEatFxuxXpwMbRA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KrPXvwy2; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=devnull+daejun7.park.samsung.com@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KrPXvwy2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=devnull+daejun7.park.samsung.com@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jJdvz3ld5z2xH7
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Nov 2026 17:29:35 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E0B8A43C67;
	Tue,  3 Nov 2026 06:29:32 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793687372;
	b=AWzh4ftIFI98bo7QPKToDS7e82LJgTdhJFLWVSO8tX2aoIKRwlE8ivrdb/mD1S3PNIKW
	 bAq8Is9RumyBnbr1mNxchGb6bCNNWHc/qnI3Q/xUMr6OgYhIvXid7XY2jyFHx4QKR+YcP
	 nFoFlDen9pGmaksWvtRBwepNcRzbWz1hRDrhFRHTNLeM+N5lXhoVdidJCIvL82F5II9RA
	 WnOdgatDIFsnY3z318ZQ82v/0xo/yMu9gHOhVUvd88Y0BYliQvLLr3rRIB5Zw7oMRUcLp
	 tgMrIFaNUB+VD1S7VP81w80QWcFC1N7JafeOiW5yNm3nhaMZ41E7AEUcUJcMJTfAQ3Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793687372;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=fWQUbPoZ5chZ7TfBqJecBV4M/CrE98rCPN8Xj8YK/20=;
	b=CWyyQ6EFpcwYINkIQrHuypZ5KAZmoKRZr+Ak8vrScaXtirCsjLzFNfnNO2zZFQZHTjSE
	 bpEwECZGkLY7jzMxIN1osBeyXiWsoAO381qYAkJ3jIY1rqCGliXqOLLW0xfP8zBxyILr3
	 6ca7Gmy/qE8Dyexm4xDMh4LV/Qe7Xir/huO4ZgkekQwySp8JA59IpN7zHH+8XQV7GwMAu
	 43d1Oh5N1yMTi3N8FYugT1TAjFEsLB24kl5+TYpQBz9bBpIiv6OLnfqGbG6Nydadqd2qI
	 YA/We1/SSmQC7z2uIYUx9/N+i2l3Loh7hRpgVZMvCJLTjvU69S+axhZ7WbBKGuqLRpw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BACC31F00A16;
	Tue,  3 Nov 2026 06:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793687372;
	bh=fWQUbPoZ5chZ7TfBqJecBV4M/CrE98rCPN8Xj8YK/20=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=KrPXvwy2BXs87cG9Vh8k6xn9DPUHf2x4eCht6aXC+f+mtVK5fbQvW7FFrOY/4vO+j
	 yPF92UjY1cdubPQ9Os07FH1J5npA/IMoWj+U9yZKCC3FTSjfgiPJVufsMCUfRUUB5S
	 SMe0PyDOgHzZIBerAxkX198e21gBkFEhnzugJwXghou4bXn/Z+VSJNNsF1Hbwdzwrx
	 TFIjGpzNjpJ25HapMJzHmmFAwL5QvpbZoggRoNY5SmOxetCv10SS6rsOWn+bpyzvJ7
	 Tqq0fFs3yrQY8i8o4HEy7Rh/faB36HokMMROnihbga5MKNrx36SYSFqbh3vGthwvTN
	 nCLazc/bqVboA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 20698467DE;
	Tue,  3 Nov 2026 06:29:31 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Subject: [PATCH v2 0/3] erofs: bound file-backed mount nesting and use a
 bio_set for requests
Date: Tue, 03 Nov 2026 15:29:30 +0900
Message-Id: <20261103-erofs-fileio-bioset-v2-0-5b91af423f72@samsung.com>
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
X-B4-Tracking: v=1; b=H4sIAEp/6WoC/12OOw7CMBBErxK5ZpEdA06ouAei8GcNKyBG3hCBU
 O6OidKE8o00b+YjGDMhi331ERkHYkpdgXpVCX+x3RmBQmFRy3qnZN0C5hQZIt2QEjhKjD0Ypbd
 GuqYNTStK85Ex0muyHk+FL8R9yu9pZFC/dPZpOfu4t/6KAfDVZwuhHPHIMChQoNtoQjTWS+UOb
 O/87M5rn+6/oT/L8tXU9jZujA3OaasX7dM4jl/k/vQf/gAAAA==
To: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>, Jingbo Xu <jefflexu@163.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>, 
 Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793687370; l=1630;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=xHyr8ZsDIYNONpUNcHNkNV4xyWK3+xLjfOqRcIe3HUY=;
 b=EcuOXlce50tx7+rrDgy6bnPyjh0auWDBQQywZeMsU4+Zsaz/XR9OPcPta1/E4yn9dDE6/wJ+6
 4S0oShmqC1AADDfl+6vEGJ4j5NYB936pbVYiBfBzfy/YSGtfPlGB3eh
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

File-backed EROFS mounts cap each request at 16 bvecs. A larger
readahead window then takes several backing reads. This series
allocates file-backed requests from a bio_set to hold up to
BIO_MAX_VECS bvecs per request.

All file-backed mounts share that bio_set mempool. Patches 1 and 2
first close two ways for file-backed mounts to nest past the stacked
fs check: extra devices, and files shared by inode_share. Patch 3 then
switches request allocation to the bio_set. Without the mm readahead
alignment patch, larger backing reads slow some buffered reads.

Tested in a QEMU guest with KASAN:
- Images and device= blobs shared by inode_share are rejected. So is
  an image after a remount clears inode_share.
- Unshared files still mount.

---
Changes in v2:
- New patch 2 for inode_share, reported by Sashiko. It checks the
  file, not the option, which a remount can clear.
- Patch 3 no longer says "does not fail", nor that a backing read
  cannot reach the pool again in the same task.

---
Daejun Park (3):
      erofs: apply the stacked fs check to extra file-backed devices
      erofs: treat files shared by inode_share as stacked
      erofs: allocate file-backed mount requests from a bio_set

 fs/erofs/fileio.c   | 47 +++++++++++++++++++++++++++++++++++------------
 fs/erofs/internal.h |  4 ++++
 fs/erofs/super.c    | 30 +++++++++++++++++++++++++++---
 3 files changed, 66 insertions(+), 15 deletions(-)
---
base-commit: 209108a5456171ab430e25b54b2dfe083455bfb6
change-id: 20261029-erofs-fileio-bioset-713570b89d89

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>



