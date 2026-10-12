Return-Path: <linux-erofs+bounces-4692-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CECFCA9ED1
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2026 10:48:46 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3Dj85qwCz2yPR;
	Mon, 12 Oct 2026 21:48:44 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791802124;
	cv=none; b=Kme1JwZUYUezTY7S2hyg/kAX0n6IZmwcTuWSx5wg+20pUC19cAmxFJ5jaYSd9R3ZqTJqIUQGxrf96gJlt/SD1DtGi7QKsJGPB4ZkGy4iZ7lH6ZYqGDDyJzx30YXUfTZ6bk4rqIAo6zRwHzpMqeYlsneyPMyVJ36w82/zWrArgrTHFr7teoWeVqYfxaKigoezEOM3uGl6byxvjY6B90E/51Xga9VWBkkkWoTVzC5SfFO+yDaDEt/fJeclyb/tNl5FAyukwXnIz75AYgsO8yOXAVR5g9XTHkvOhE1cnMVhWr6gy4rg9FJD26gdh7SHxyV6ZYuRcytmpHCqVlnzHeQGEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791802124; c=relaxed/relaxed;
	bh=86dla+81F3suTOLS52ok6cqcU2G1FZrSK0sW+VFXWFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k+fO+qt8BNSJhiwHqNZcLT6DR+jaYBaCZP84tJyqSK3sh9KmTc/dcssHrhsZz71LRnw3yfWSTIFsVyAfLNN6UnuCPO7y20KKu2ksN8V4QNrAymtpFhr8PiPGSj1NvZ24d06AgSFLJfANWyeBLiljMbNsfd+n1G/X1iv0jmeXEP9szGqt5okp5UvrKGag1HI6cf5TRUgQqXxrOQXQ9FoCkixQp/u7TOWXJZtMoVEN9fSidJLJByjkSlbFO03HVZemq+Qi8Z8sPr2izXI2kWKZp+cAmZ0cgD3ZZBupSe4pBSK8HmghM8Su2fpYcZ2/njHYaAlSoZvt9rzCqVuhWzutYQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T7yEkkwM; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T7yEkkwM;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3Dj76hftz2xwP
	for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 21:48:43 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1813640F06;
	Mon, 12 Oct 2026 10:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54891F0089B;
	Mon, 12 Oct 2026 10:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791802121;
	bh=86dla+81F3suTOLS52ok6cqcU2G1FZrSK0sW+VFXWFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7yEkkwMSiReMceqyGA3nhecrnbDPlVSdz19p92FWrl2iftSzKqoxvi0qM9gmkwSb
	 0UunS9J28l9AZmxCipppAqaIykx/jJxI2cWqIod+Jcoz2/KaLQo80JfFY/MbfYPy6N
	 MDKEp2WcpbeSqWZ5DZ7PuHhiWH71k9v45FBVoVvRtXSk57ZDC3KEqu1nI6VUOxmeE2
	 O0axRlQEX2foTPnE20oXleoxS836XP88nfO+2753ZnL4P0wXDjSs5PXIylk39AD9tb
	 dqLQCsNKgMa1/sS3oVdqqU2L+TmmdivcTMAWz4nHGC80gCn/nZvvSgAdmFj4b1+aIT
	 qIV9+DwK1jpYg==
From: Christian Brauner <brauner@kernel.org>
To: linux-erofs@lists.ozlabs.org,
	Giuseppe Scrivano <giuseppe@scrivano.org>
Cc: Christian Brauner <brauner@kernel.org>,
	xiang@kernel.org,
	linux-fsdevel@vger.kernel.org,
	amir73il@gmail.com,
	viro@zeniv.linux.org.uk,
	jack@suse.cz,
	hch@infradead.org
Subject: Re: (subset) [PATCH v7 0/2] erofs: share the superblock for file-backed mounts
Date: Mon, 12 Oct 2026 12:48:33 +0200
Message-ID: <20261012-inkubationszeit-hierher-pferde-402d3192f67b@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002163225.1258203-1-giuseppe@scrivano.org>
References: <20261002163225.1258203-1-giuseppe@scrivano.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1428; i=brauner@kernel.org; h=from:subject:message-id; bh=MYSPzdGHvAq1WootgbulOFD95hAFP42k6oZCW9G+8b8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2c28cp4Nk/kF940plT7Hb8+NXfH7tcG/XyoMVqWfr toY3Hdw6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIymaG/w7a69eZTzn3nX1y qTZ31Radya+MBLIFfqzmfa2/iivAq5zhf8Gq2hW8a0S/Nq6dcFrq/cFs5wnJV53XijV53ln2+eT KtdwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Fri, 02 Oct 2026 18:31:42 +0200, Giuseppe Scrivano wrote:
> v6: https://lore.kernel.org/linux-fsdevel/20260812142907.1010046-1-gscrivan@redhat.com/
> v5: https://lore.kernel.org/linux-fsdevel/20260811071241.389589-1-gscrivan@redhat.com/
> v4: https://lore.kernel.org/linux-fsdevel/20260804060455.2928514-1-gscrivan@redhat.com/
> v3: https://lore.kernel.org/linux-fsdevel/20260801075446.2508805-1-gscrivan@redhat.com/
> v2: https://lore.kernel.org/linux-fsdevel/20260731160901.2276832-1-gscrivan@redhat.com/
> v1: https://lore.kernel.org/linux-fsdevel/20260730124120.1501126-1-gscrivan@redhat.com/
> 
> [...]

Applied to the vfs-7.4.shared.super branch of the vfs/vfs.git tree.
Patches in the vfs-7.4.shared.super branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.4.shared.super

[1/2] fs: rename vfs_get_super() to get_tree_super() and export it
      https://git.kernel.org/vfs/vfs/c/64571ba65816

