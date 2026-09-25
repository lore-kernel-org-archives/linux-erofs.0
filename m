Return-Path: <linux-erofs+bounces-4616-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03D04C98321
	for <linux-erofs@archiver.kernel.org>; Fri, 25 Sep 2026 15:27:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hrvhM1Tkpz2xqM;
	Sat, 26 Sep 2026 01:27:15 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790350035;
	cv=none; b=VDxy99R4w+Bb7ay+yPrd3sXHV+bD9s+J0aIhIXetQ2j/zNA1ruxo89HGUjGjki1LITpeWp4mFhwIMOxenfTPcYhl0LhTlbYICJG65487qu3BB8N+u6n50Fe5YfqmHx9A2LFAgC4l04gaMQCcEsh5FzPldfReP2PZXTVHgHJiXbbn6DM4pCcHADJ5Vy21ReKkWoCbtv9e/Nj8muU34D9PZYzMsejOIcl+Fa3gADAzezaSpI5ptXjYI9bu8gyW56bmneSIaGPbbcO75K79LPklTOjqpiL8ymlB4B7uG9AWikoa1sZ86gqLvyxFGtVy7cksV7IwMQZTGUIgbEgyZE2Ncg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790350035; c=relaxed/relaxed;
	bh=M0Dlkk7AxI+8rNRtVS5M1ySYtEPD5rm7u8ObsT1hC7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iu0nsaPRWWymr6g2eMyMgyrjUjTmkFf4QeydrKaBRCFb+yNOYHcE/3ezy7yfAwZUBdnSCeBJy2+lksKOiLqn6o72QTmqYZlaw/NeLt+V1dd6oVZHAyc3cpPhjpDcI1QJz0kh0f7/EhGn4ahBGMJ3BAzAy8t9iSOl5/8Sh6wpkkoHpAjRzTxElUPVY+JYSsFdYWF+DBpbB6OITZjSCE1yYyEGzuSEIrwjfu1nNdE8OQEDDmAWJoqIyk/N4ucDTMSSVwPOhrcUh8HbkviqcIm+nmDLL685XHOwYHiRjZdm5fk88CIx/uAOBeGdtI2UWWQUURJD3kJx+aUWKlQ1rwEyPA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G6+Kz6HS; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G6+Kz6HS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hrvhL1x6Mz2xnp
	for <linux-erofs@lists.ozlabs.org>; Sat, 26 Sep 2026 01:27:14 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9506437A7;
	Fri, 25 Sep 2026 15:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9691E1F000FF;
	Fri, 25 Sep 2026 15:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790350031;
	bh=M0Dlkk7AxI+8rNRtVS5M1ySYtEPD5rm7u8ObsT1hC7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6+Kz6HSWnElnZPFmeh/2PcaTum0xwfNI61Ru6dckoL/DWbb3J3W004zVxLfKSSrM
	 Un4LCXV9FiUiws6p9TF5GvWX6E/wJUoynfuoUEfU1F9PxSKv82yH2WHGQikBq/Ktga
	 0Cippz5vRPrTezdgAeC1t6w8zoElWzY7yg89LV5pOAmgvEy80psiJ1B6KBPuN/nnm9
	 Arla20ZUz0O+3qjGfDrfhJGKI6vzPUkFZHt/eNncvGHYM2WdgwIBuau6EHpofvDdF0
	 HwahKDCObIyYey7XVab7qYuFjj7gaS9iUdFXbh6A2Raf4oQ2b9OuUYNi2NtUtv+1tf
	 h6G1gFOUba+1Q==
From: Christian Brauner <brauner@kernel.org>
To: linux-erofs@lists.ozlabs.org,
	Giuseppe Scrivano <gscrivan@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>,
	xiang@kernel.org,
	linux-fsdevel@vger.kernel.org,
	amir73il@gmail.com,
	viro@zeniv.linux.org.uk,
	jack@suse.cz
Subject: Re: (subset) [PATCH v6 0/2] erofs: share the superblock for file-backed mounts
Date: Fri, 25 Sep 2026 17:27:04 +0200
Message-ID: <20260925-aufruf-fiktion-regeln-d328dc899089@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260812142907.1010046-1-gscrivan@redhat.com>
References: <20260812142907.1010046-1-gscrivan@redhat.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1431; i=brauner@kernel.org; h=from:subject:message-id; bh=QiOdI5ie9Wic4iqmvCCRmQNxf/g07Uk/qM7aWdUeRy0=; b=kA0DAAoWkcYbwGV43KIByyZiAGq2ksqj4iOUbTRt+tCP41MdiRWL4PxlsaHlbofybF0fD8VM8 Ih1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmq2ksoACgkQkcYbwGV43KKS9wEAs/6R ud8dpR38Hs0SE7Z2Pky1VZAl//RYB31gC5QgEgEA+gPZgiHkuTpb0ze/tOH7CvycGp61RbjZBn9 GcmGNh6YK
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Wed, 12 Aug 2026 16:28:02 +0200, Giuseppe Scrivano wrote:
> v5: https://lore.kernel.org/linux-fsdevel/20260811071241.389589-1-gscrivan@redhat.com/
> v4: https://lore.kernel.org/linux-fsdevel/20260804060455.2928514-1-gscrivan@redhat.com/
> v3: https://lore.kernel.org/linux-fsdevel/20260801075446.2508805-1-gscrivan@redhat.com/
> v2: https://lore.kernel.org/linux-fsdevel/20260731160901.2276832-1-gscrivan@redhat.com/
> v1: https://lore.kernel.org/linux-fsdevel/20260730124120.1501126-1-gscrivan@redhat.com/
> Needs: https://lore.kernel.org/linux-fsdevel/20260804055949.2927896-1-gscrivan@redhat.com/
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
      https://git.kernel.org/vfs/vfs/c/09c6d98c822f

