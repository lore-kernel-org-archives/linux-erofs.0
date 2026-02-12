Return-Path: <linux-erofs+bounces-2304-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2E4DECD6F7
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Feb 2026 01:27:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fBHjH4P8Vz2xcB;
	Thu, 12 Feb 2026 12:27:31 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1770859651;
	cv=none; b=oxhEQwgQzMxbpItucrA5ECbGBPNEZJUFag70BaR6KpvcwVqF1ohb0CZ6I6oZwtoLPuYMrH4ZHb7xYkzhnwxt5muQnSXIPZRkGhBsxbW5c01N4kt7o2mhbErsozhI9a55fjZj7wtQ7mPPs24F3Le7iqg4HF7BNUnlRMcoqoxHfP3/MxWy1129f3NXNEXd9K+RLnZrXoTEVnAWoJLXrx//stRlDeCJQ1llW9rZ0KrzrRzTKHA0x1OcRWd96aUzp8FcK3HWO5106BoBrZYOfOzJtdO5OtAoANyqrXo0Jf+nqPmuNAz4BPgwF9+6bLACd8VtGOVcGqn7az6tPAAtqmutXg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1770859651; c=relaxed/relaxed;
	bh=ZMwHaMfU3uQVjdoX/GRi9pusohwQs2sA+igHxUoWqT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QP47XldgBC/tgzxG/CEKPgI876CGDnTegeSO6rq98LWi4RwpAZd7H8qAcQzOplK/Nmblm091kZdh78yj2Smlu7ZU02INxEIlG0lyM4uqTU2ri070f2eYXolGK/xy1+2HW0DEYZzi/kHvxklG+ypoYCpzPRuQ4dJjc4ifdGeVHr1oTBaDwIUS+sVBqLgWhOSL336V8qD5qKs6eI3Pot/CvUfw/dMHRmxycniB/cl2mZxQZNZRPNhuQJQYHRx8utgvMnV60czqde82lkAyl1Ux42L4b72LojYF4l9nRhsrU8Hmr9mX3Cl4w/lv/x88oRxME1pEqGkVvJy0nl5ad0NWvg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=S14D8gQk; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=S14D8gQk;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fBHjH0VSYz2xHX
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Feb 2026 12:27:31 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B38BB60051;
	Thu, 12 Feb 2026 01:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8515C16AAE;
	Thu, 12 Feb 2026 01:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770859648;
	bh=B/VqF3pMNXT7AgKcPsCRdPF9bN6sVO/jWPDylW9RCP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S14D8gQkNN/gkSKPAKqE/vU2m/RzkkkdfJxD8hgePg3NSPGwxA22rIaftSU47oin5
	 56z8ik20eHhfnvwo2LKX9rQL92e0hrexujWDlHbrQrYnscu1APifm3WdoChl9Wu/nN
	 CIS/IpTiCHw6ups1C1fKngkGYxQ0/qxdMfzwDHZjmgEKliIIVrfllbw17qcZP3aSq6
	 Iz4mb8/JJUqzWQEv/+Ax2vzsO/pC9axmNDkeK6Ysm573N3DYse4r1Vdzq1gjsI+egI
	 YDsA6Ug8Y85NP2cA+zkopVgAuTxr7P5yOLfYST9UziPw9dD64bX+otWBJTn8VYNhv4
	 IVuwVQ7UBnRxw==
Date: Thu, 12 Feb 2026 09:27:23 +0800
From: Gao Xiang <xiang@kernel.org>
To: ChengyuZhu6 <hudson@cyzhu.com>
Cc: linux-erofs@lists.ozlabs.org, hsiangkao@linux.alibaba.com,
	Chengyu Zhu <hudsonzhu@tencent.com>
Subject: Re: [PATCH v2] erofs-utils: lib: oci: support reading credentials
 from docker config
Message-ID: <aY0se7OziwKD2qtJ@debian>
Mail-Followup-To: ChengyuZhu6 <hudson@cyzhu.com>,
	linux-erofs@lists.ozlabs.org, hsiangkao@linux.alibaba.com,
	Chengyu Zhu <hudsonzhu@tencent.com>
References: <20260209075355.16969-1-hudson@cyzhu.com>
 <20260210093726.86026-1-hudson@cyzhu.com>
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
In-Reply-To: <20260210093726.86026-1-hudson@cyzhu.com>

Hi Chengyu,

On Tue, Feb 10, 2026 at 05:37:26PM +0800, ChengyuZhu6 wrote:
> From: Chengyu Zhu <hudsonzhu@tencent.com>
> 
> This patch adds support for reading authentication credentials from
> Docker's `config.json` (typically in `~/.docker/config.json` or via
> `DOCKER_CONFIG`).
> 
> If no username/password is provided via command-line arguments, the
> implementation will attempt to look up the registry in the docker config
> file and use the stored credentials if found.
> 
> Signed-off-by: Chengyu Zhu <hudsonzhu@tencent.com>

I cannot apply this patch, which commit is this commit based on?

Could you try to base on the latest -experimental or -dev commit?

Thanks,
Gao Xiang

