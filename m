Return-Path: <linux-erofs+bounces-4398-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AF2BC624CE
	for <linux-erofs@archiver.kernel.org>; Tue,  1 Sep 2026 05:56:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hYw8Z6P0Rz2y2P;
	Tue, 01 Sep 2026 15:56:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788242174;
	cv=none; b=gI4J/3tX42h23KD3JrpGA3nZ+mh3Y3ti6EgoY8fRI9guRBvWx5oN4R55Nh03X6W2Sx9Adhw5/6JGdPJusw0Wm9MHYFe9wRpfFbQJ3GPZhI1G0UA/4dqVpybGmk68BzjcaJrp3HIcgRKE1iyzZ6nrYqD0RBFWazNEmAOgCy50j6ezk6LxE94x6l7/Gp0vbgG+Jmdj31Lpj5sAUGooClO+GJ6cZgPvdxxKIi5grkK2RhwjwcHAvzO6u+g9zBBVzHpXKkuGLA/zsLR5pYp3fFf8K3FNKljNH8tgTkOpj9RZ9WNul805RTLPix2DrltBxzqu6WlfBIqmM/z1Yk+twUYAcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788242174; c=relaxed/relaxed;
	bh=3Mnj837MmtIz++Lx3CjViaHZJuFNdZX481goDRHR5Jo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UPV7Lb8wZ58tFts4Iu0n23zOAi6UljUXiJA9YqosEl9nLGAyhNRI8Glad6Kt/otpEYsMLVjpkn5mTRQk5yvfxsOnfMbugpEW4ch1NHyFABvhS+UxMZ8CDXVllGU011EYCdH+zcB8+cTr5uh+K6KrdyTUYl+H07VtLMpA8m3reeodVkdsK0aSIuY4WLpeSru36zRLDFsMcREfqfe+RxBoA58sThQv/zI+snSZDFfqNMYrznpHoLh85GbGfCNKM4H/Xa+8fisZwAvITub+HETDq1uXA+xsZ+PF5Y4Iwih6hhbIeVjq6a9Dh3z7N5GJPc3HKK6hkwkMdu53UnoofKPkbQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ou7BODbI; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ou7BODbI;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hYw8Y4WNBz2y2B
	for <linux-erofs@lists.ozlabs.org>; Tue, 01 Sep 2026 15:56:13 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC3FB40338;
	Tue,  1 Sep 2026 05:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494581F000E9;
	Tue,  1 Sep 2026 05:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788242170;
	bh=3Mnj837MmtIz++Lx3CjViaHZJuFNdZX481goDRHR5Jo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ou7BODbIZicrSpeSM00EfOJQrJABefs9Kuf2EhFYV6gK2dq64CXKdSuL3RyZbLucK
	 TPg17Tyz0+5ncdV6c1HL6WGWK3QRh4+wm6tY9EoV1ldMeb65SaokB3SYllaBh+BMU+
	 k3fxxYQqKpob1eGKNeK6NERFb4+ExYOKE40Jru2B8rYntpuKlNuC0j8YO4qOVeoRfS
	 0Gai2YDP4tJxaz3XlpWyH0B+gdt6KErKtSPMpBpFla9M4/VF7fFDFR9rb7sXCytJmv
	 hvNVEuFK2QwrR66uR+fQsxbPPuwkUO9XsB0pubH/TfXp4lry7WXlo5qdiAM9FijGEM
	 OmAyFu0d6q/4A==
Date: Tue, 1 Sep 2026 13:55:42 +0800
From: Gao Xiang <xiang@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Theodore Tso <tytso@mit.edu>, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org,
	ntfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/9] erofs: Remove redundant FGP_NOFS
Message-ID: <apZo3lDaDp3hQhRq@XiangdeMacBook-Pro.local>
Mail-Followup-To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Theodore Tso <tytso@mit.edu>, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org,
	ntfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-4-willy@infradead.org>
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
In-Reply-To: <20260830041901.2668-4-willy@infradead.org>

On Sun, Aug 30, 2026 at 05:18:50AM +0100, Matthew Wilcox (Oracle) wrote:
> The flags already include FGP_NOWAIT which prohibits all reclaim, not
> just reclaiming from the filesystem.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

