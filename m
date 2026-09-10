Return-Path: <linux-erofs+bounces-4526-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43AFAC79F9F
	for <linux-erofs@archiver.kernel.org>; Thu, 10 Sep 2026 08:11:44 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hgVkk4531z2yFK;
	Thu, 10 Sep 2026 18:11:42 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789027902;
	cv=none; b=ZFp7hBUBCVgJJDcIS7QKLmiDIMH0TiAO28E8Gol9PgEntXeyl/kxvbHlfLTPeYYCJSx0pMghQ2GbOwM6QTgk7p11eEZFeTZcp8xAzk33lkJ7dbePxmQE5xrwbCkGqbgg+YaJtNWM1NUbBeUORfJ3Uw9/Mo5w7m8jpjT9hmNnwgoh6GyVD8ZO6VI6IM6YN68D+6+b1Qw5n9F6olD3/WtN+K6pNO0AP25uw5vASJEi1KZRkdJzz0f55IhZ7ysRHja9YXAGZzo2pfqxiyjOQCBQiy5IVrHUXnzI5N+KUZjxBlX94p2bp2JvfTaI4yxsbOqkOdohveT2pogMao8ft2//sg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789027902; c=relaxed/relaxed;
	bh=Bl2jWTajUKdkFTVEmaIsZckt4uMF6UIWmGeyLi3kFQg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OP39Zykg2/bF5+UByvy64gZoQaL8PE1gEhuW3p9dmd1T0QU2pEkClSq35jsitacVG9BjcqnYLkjt7RZKouOlXJHzlpGLU7hZ4u6HoC6qBypvJwuyaSR9a8c1nE034U0tYor6u7DAchRo+U5Fkx8uQBG80nLL9H4Q++72fTwUFaHWPlu1RwLkwOLU8RnXhxuEdTICQm6EFlFFTwdliEFdJ/WKtbikbyP610WTwwK0emVpbW97V+DmrFKUQzOTBZFzjcLDtdBoJxHJseoKtal+MmK1K7IVfXHipf5juNiS9JVFThRRddmyfBCcg+vWAxRsPv+ZzHUDnIupyYYKv6MP1w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DAqb16Lh; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DAqb16Lh;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hgVkj1xJSz2y2S
	for <linux-erofs@lists.ozlabs.org>; Thu, 10 Sep 2026 18:11:41 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7DAB9600C8;
	Thu, 10 Sep 2026 08:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D241F000FF;
	Thu, 10 Sep 2026 08:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789027898;
	bh=Bl2jWTajUKdkFTVEmaIsZckt4uMF6UIWmGeyLi3kFQg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=DAqb16LhXA4V3x2MEBgyebklpieMD75ealCT6F60CkFf+1FpmPAJyTfsmtGyVFhzC
	 Eekvf46yp132dC4zoRl85r5FXyUpUdsWXVUh08Xcz1+9bOVObP5c6h1fXfZmlaxrzM
	 P2tKsaJycMsQjasylX2DwThvMnSOubkKYXSyhG5k+ZOmCTZPVPkzq9xY4H9AAtgM2+
	 bv/gFqBICa+dxei6mzc0FdAoQcLhta8R015Ur710MTEVpZDuYI8huu5pliRpIvykY1
	 PM3ORUCluTaMjr1OPi/LRpzglnTOCs6cwf/AQvzv4pOZJCfOVOQQWJkrVBZxdVs+Io
	 bpZbmlO4+cExw==
From: Christian Brauner <brauner@kernel.org>
To: Christian Brauner <brauner@kernel.org>, 
 David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.org>, 
 Matthew Wilcox <willy@infradead.org>, Namjae Jeon <linkinjeon@kernel.org>, 
 Marc Dionne <marc.dionne@auristor.com>, Stefan Metzmacher <metze@samba.org>, 
 Eric Van Hensbergen <ericvh@kernel.org>, 
 Dominique Martinet <asmadeus@codewreck.org>, 
 Ilya Dryomov <idryomov@gmail.com>, netfs@lists.linux.dev, 
 linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, 
 linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org, v9fs@lists.linux.dev, 
 linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260909072105.1663687-1-dhowells@redhat.com>
References: <20260909072105.1663687-1-dhowells@redhat.com>
Subject: Re: [PATCH v13 0/8] netfs: Miscellaneous preparatory changes
Message-Id: <20260910-rohrkrepierer-clinchen-affront-100171384452@brauner>
Date: Thu, 10 Sep 2026 10:11:29 +0200
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1938; i=brauner@kernel.org;
 h=from:subject:message-id; bh=PSYLbShhpWiv3aVB2nJrOHdeh7Z3k4zELmiY4CjG9uE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQtSjPOTU++uvzGNKGtX+59+bbANNaqinHmG+kZFS+fz
 imr/6Fl01HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRiX6MDLNL9Jr6i6ZfcHJI
 5Zibue9R84UHvjxep8JUI2eX/pB/28/IcMBbawZXzeYHH6JTJjpNWJb77J//i10b/F5X3sh6F7u
 ilg0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Wed, 09 Sep 2026 08:20:54 +0100, David Howells wrote:
> netfs: Miscellaneous preparatory changes
> 
> Hi Christian,
> 
> Could you pull these patches please for -next?  This is the first of four
> batches.  This is based on your vfs.fixes as there are some prerequisite
> patches there.  This was split from v11 of a larger series[1].
> 
> [...]

Applied to the vfs-7.4.netfs branch of the vfs/vfs.git tree.
Patches in the vfs-7.4.netfs branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.4.netfs

[1/8] netfs: Use uoff_t instead of unsigned long long and loff_t
      https://git.kernel.org/vfs/vfs/c/0447d3e7ca81
[2/8] netfs: Remove the writethrough code
      https://git.kernel.org/vfs/vfs/c/1c167be3e3f3
[3/8] netfs: trace: Change the "clear" folio traces to "endwb"
      https://git.kernel.org/vfs/vfs/c/b4c9fce24e25
[4/8] netfs: trace: Rejig a couple of the tracepoints
      https://git.kernel.org/vfs/vfs/c/80fe2005dc3c
[5/8] netfs: Add the cache object ID to netfs_read/write tracepoints
      https://git.kernel.org/vfs/vfs/c/b1abd92147b1
[6/8] netfs: Make deprecated PG_private_2 support opt-in
      https://git.kernel.org/vfs/vfs/c/e5c67dd3bbf7
[7/8] netfs: Add some functions to wrap the all-queued handling
      https://git.kernel.org/vfs/vfs/c/a38f37509940
[8/8] netfs: Set subrequest->source at alloc before trace emission
      https://git.kernel.org/vfs/vfs/c/3df7501ad939


