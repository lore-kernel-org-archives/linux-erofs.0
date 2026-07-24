Return-Path: <linux-erofs+bounces-3999-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77465C531C9
	for <linux-erofs@archiver.kernel.org>; Fri, 24 Jul 2026 15:28:42 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h6Bj45bwrz2xYh;
	Sat, 25 Jul 2026 01:28:40 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784906920;
	cv=none; b=fpwiz8EM6A5PhvBJec61itytdhWVw0oAdX2K1yBhddFWeDgjmNeEz/7ihmTvm49C0NNhJ3ORt3rxhR/3x/xtXg6ZpD7Rxw2FRgXRw7iOOzLgDh4OGYlPGWR5n4MFBC5Ck32yu0VIDNzDE38wJtyiwFnIyUyypvb1aMOanGqOb+JqHeOUud7UlQlUiblz0v14x/9Y1/TQ8YQ8hRu+PsGOmiR/x70TrBR/2I/W0agLMz9EGRaWHOt9Fowous+LGjxO95Y2xnHpF4p3ygWig7zAPKZSVVcwjLChQcC9qFNPv23D7ZQhr3TWistBwdvpUxZlJWhuiqlNJOapQmuAycTE2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784906920; c=relaxed/relaxed;
	bh=HSKDxQEkY9Iy4ck1ci0ZuITiTwJBFBXJ/vzFimi1fO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ef8VoXbtY10MLwlsmLRH/XgaJE4xpzBZODItgUbuDyCrny7itUTiICYWsAgUHkMDMl+ITtG2J7SkDnKsRl1YKWVN7FMR8YijL5vkpIGJup4p09fNK7GdYwe1n06TU8DFZlHzMbu9fKCNtxdPRSE/QXebl4otZ9o95vOcjEH1EC0qpJWUl+lppupsujiPPr84qMSttD7fhgm7h7CmVDrRr4kNW3WduIhp9aZWFYrrrZZ8WMb71Nk44+aUit/2dNGeEIINycevcuwt2VJBuStaEDSHNj4XPfUwPr4cg5crqIRbF5R61pWDT8Gjg0YUq5DE3ZJgIG5mUqzyZx23slh/LA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n2l4l9c2; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n2l4l9c2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h6Bj40NdLz2xRs
	for <linux-erofs@lists.ozlabs.org>; Sat, 25 Jul 2026 01:28:39 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ADEF6600AA;
	Fri, 24 Jul 2026 15:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D201F000E9;
	Fri, 24 Jul 2026 15:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784906916;
	bh=HSKDxQEkY9Iy4ck1ci0ZuITiTwJBFBXJ/vzFimi1fO4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n2l4l9c2n374MUgbsJGwWrB9Rh/JgdP38DNrGqm+Ak8c7aq+Sg2lF6Ud6L5AAMIzD
	 rkWfXdqro/RlnMeMZogXGn1wU7hCPSqmAM+NyHchk/UQ0Z0oeSvubOtHLdWTNQrvZL
	 FacLZ+SbESku9oZTEMdYremK0W9JaTWqp5eZKz22zrjPrBSwCJEcBtbNe6m4rBohsh
	 Q5NAGy500HjuPsgplXAVuDD7JEtM3+BMmxvURV6BVMgyNywym5YGBrU2dppamS5tjg
	 ZMKKJc4IKasuwESTskLIVTgblHCsqI8KRGXCU2yiFT7dHn/oAatC/dUTiJpaBruP9U
	 aRMUx2CLpe14A==
Date: Fri, 24 Jul 2026 23:28:29 +0800
From: Gao Xiang <xiang@kernel.org>
To: Nithurshen <nithurshen.dev@gmail.com>
Cc: hsiangkao@linux.alibaba.com, linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
Subject: Re: [PATCH v2 2/2] fsck.erofs: implement concurrent directory
 traversal
Message-ID: <amOEndBYjdJ8uAeb@debian>
Mail-Followup-To: Nithurshen <nithurshen.dev@gmail.com>,
	hsiangkao@linux.alibaba.com, linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
References: <20260724143556.80914-1-nithurshen.dev@gmail.com>
 <20260724144713.85393-1-nithurshen.dev@gmail.com>
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
In-Reply-To: <20260724144713.85393-1-nithurshen.dev@gmail.com>

Hi Nithurshen,

On Fri, Jul 24, 2026 at 08:17:13PM +0530, Nithurshen wrote:
> Hi Xiang,
> 
> I have implemented the concurrent directory traversal and ran
> the benchmarks to compare it against our single-threaded baseline.
> All integrity checks passed successfully. Note that this data is an
> average of 5 runs of extraction of the same file with purging all
> cache before each extraction.
> 
> Here is the extraction time breakdown and performance improvement:

As I told you the merging policy, each patch should have no
regression, if concurrent directory traversal is useful, please
just implement it as a base, I won't accept PATCH 1/2 since
it has regression and useless.

Thanks,
Gao Xiang

