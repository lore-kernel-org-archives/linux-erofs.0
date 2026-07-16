Return-Path: <linux-erofs+bounces-3927-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB407C44512
	for <linux-erofs@archiver.kernel.org>; Thu, 16 Jul 2026 14:09:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h1FKl26pWz30Qv;
	Fri, 17 Jul 2026 00:09:47 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784210987;
	cv=none; b=Hgeb/0NKEi5pIWjxP1XD2UFIzyneXivVK/lF67AJmkOIudbhGLZcr1H+MlGzMkuAK8c1J9bBMfPEXh+BR/lsoWb/IK2ydeTJkAcQ9z+Vh8taGHJP1atYlyLwoTTR/scLXQabMSfiJe2aOdlkBMiU6ENPS6dA2PUBwx24VgHHKGvacpPXxPOpquQTcnbzRHn7B3xbuWpwDacEcnZQneIUUytKN7r5HeE5eJG8XrO4y7Z5gdg+XDFn02kbkJsSrVTgIqa87sOsEvk9cxmXd3fvaTUB4/SSlK/TwKRKUzTJdimSphbCUaEJxzU8Ge3+EcstLP4/6Z+KFeLvQxwg88BB0g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784210987; c=relaxed/relaxed;
	bh=kGamTcS4sVFtX6QmitbxVR0BDQIJTcz2VhTQyBO2iVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kP33smmqyYfjI/fZZ6OJbmJqFjnFSK4iBlzkQQiROYtX+f3oMg0abOKc+fhPeM0AvdVk/jRA2USKiIvNFAOvyJquMXW05L9ry87YDV3dqDYsZ3qdLyCmdWvdqccE/Nuh4TJPTb2cRAWkgvWBHz+P3/CWAKAiEU3d1Dm6YrKKScKfSJIg/2ZZ1Rq5fb+WC3WvLnQL7xoYRBvVwEZ9BQmDj7W2SjWWKoPunXQ5JEVE1GhiQLeqPPq+qjsl+aMbv2mwffIsJlOqtYzGzCGtWtue203PzLOENU6XT1IMvsebTSoxCK/4nCvsAHAN4wTTX+G1WEM98BWq8b0teFu2gxcOug==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IUfmUzYY; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IUfmUzYY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h1FKj6fr5z30Dq
	for <linux-erofs@lists.ozlabs.org>; Fri, 17 Jul 2026 00:09:44 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3361B4021D;
	Thu, 16 Jul 2026 14:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB7E1F00A3D;
	Thu, 16 Jul 2026 14:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784210977;
	bh=kGamTcS4sVFtX6QmitbxVR0BDQIJTcz2VhTQyBO2iVQ=;
	h=Date:From:To:Cc:Subject;
	b=IUfmUzYYPBgUHapZJimJGGGXy4IqO4ozardW9sbB/HTc0UMESeUsSMVMzoS7ZJ4nI
	 9ujw2SzCwyGL40J8zSiiXso/QVv0cm5TyAYz/h9OKU+c2flO1Vn5+EAJM2VoTXO2CT
	 5hV9d/7G7a6MD0wZIuc7ya6mbPJziv6cfEm3aI0XR0BjwqcMLhs68E4nDSAaaBOL8r
	 O/MW2sXyuitVHNNS5OkhoqN/gE8jZfy8dud1F0GaLKbYTuQOwsJN7Oowc5ROWkhDAZ
	 093XIf0p+aW3NvJ/ibUqhXBOUPlC0UkK0OZxIlTKTT1IVtBzoik12Rk5/7K2TJQT4v
	 CFgZA/MSUczfA==
Date: Thu, 16 Jul 2026 22:09:29 +0800
From: Gao Xiang <xiang@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] erofs fixes for 7.2-rc4
Message-ID: <aljmGezzdz_pJy_C@debian>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Linus,

Could you consider these fixes for 7.2-rc4?

All commits are small as shown below: anyway, the most impacted one
fixes a regression introduced in v7.1 to avoid false corruption
reports for some ztailpacking-enabled images.

Thanks,
Gao Xiang

The following changes since commit dc59e4fea9d83f03bad6bddf3fa2e52491777482:

  Linux 7.2-rc1 (2026-06-28 12:01:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.2-rc4-fixes

for you to fetch changes up to 1572282de6d3377ca8605d48c50df3a8c08468e9:

  erofs: hide "cache_strategy=" for plain filesystems (2026-07-13 16:41:42 +0800)

----------------------------------------------------------------
Changes since last update:

 - Fix sanity checks for ztailpacking tail pclusters to avoid
   false corruption reports

 - Use more informative s_id for file-backed mounts

 - Hide the meaningless "cache_strategy=" mount option on plain
   (uncompressed) filesystems

 - Remove the unneeded erofs_is_ishare_inode() helper

----------------------------------------------------------------
Gao Xiang (4):
      erofs: use more informative s_id for file-backed mounts
      erofs: relax sanity check for tail pclusters due to ztailpacking
      erofs: get rid of erofs_is_ishare_inode() helper
      erofs: hide "cache_strategy=" for plain filesystems

 fs/erofs/ishare.c |  8 +-------
 fs/erofs/super.c  | 19 +++++--------------
 fs/erofs/zmap.c   |  3 ++-
 3 files changed, 8 insertions(+), 22 deletions(-)

