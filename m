Return-Path: <linux-erofs+bounces-4001-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F853C531C9
	for <linux-erofs@archiver.kernel.org>; Fri, 24 Jul 2026 15:46:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h6C595F5pz2yYf;
	Sat, 25 Jul 2026 01:46:05 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784907965;
	cv=none; b=jl4PjtRO/sluWuojYXfCjvhpFAvGCQfUo5e4DDwI+PbeRBcZOwXYf67Ui7XxKxbzJ2TE8ATbjHpK6kckIRynuTtdweuZBVT1ttfXJwwkOYkO700mdOnB0NNTLN84eIuXWQ/Qv+bEm4hi9IytnwlfDdi3TVYKB+9WyrM0JjEJWZKtaGgY8+nqDjuOg+OHtprsm7dkP2P8UtqJXLsIGeBpEGu9TSxs42yeAzcHpLb+C8EbScY8oBVi81jqUBXvdNdHv/WF7TPOk70SJkoQuWW0lHfwUNcbXooDHY5Mm96+gj9wIXqWFUSVhPjTzjmNtNPObiAcmAAQkxBVFnm24VpiaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784907965; c=relaxed/relaxed;
	bh=QIEHePVr4Hr3nL3TNAwIfbztIve4Nx7gepKgYfUimMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e50sQa8IdsGWLRAGAAqXpcxzN9B6lAUqRKpJV0wSb5lKHZ8R85M0rQ2lljA8m+imcMb71A2oEr9IIBM7+Q56AdUwP7aSkfALycm4rS4adVbTGfrz/RU8YaWyIg5uRv6x8gIVonbTLBFew3PkZyNyCyNP/W6DUzqJsM3zzxI6sYJkIQbtpLPwizHHaz871WxhZRNavune0dhfDdV7De0R48qRR2ui6d/zwdgHRZhYqcU7DrxNVlCksewK7zd2bzTwjM9ptf83XD3nIqDEeoi9tstHk+UnP7+Q0LI7Y8aeC40Vbkb8z6fQhJvLjdv+RZnMJcxJpOXCoGz2yKwgANtSrw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hrdJCplC; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hrdJCplC;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h6C590gdGz2yLY
	for <linux-erofs@lists.ozlabs.org>; Sat, 25 Jul 2026 01:46:05 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C61F8600AA;
	Fri, 24 Jul 2026 15:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62661F000E9;
	Fri, 24 Jul 2026 15:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784907962;
	bh=QIEHePVr4Hr3nL3TNAwIfbztIve4Nx7gepKgYfUimMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hrdJCplCujji7Kpk+sIr7udH6WDsPvcXy4c9mWkTg+MS2xlwsfd7Mr89O0y9/wQRl
	 OnEGzmLhL7nZzMZa8xjvM1hQAx96n7/3fP8PXdZ2r0vkGpfEV9XRZzT8Z/T8nAQ/Ec
	 ehuAYrBC67KY7qbjF8VSl73YEBRF4h3c5m0daJsG2P0G6TwLWFoA6uqBt1/0Q82obO
	 FZ5yD3udHbLf2KFTAObrs6kdLZX9igyQfhzUcsJUO+zGcq3zmfP0BqePvvGebFRMBV
	 N8SJQQBAxNactmSf/dgaJRoeL61b75odHi2ixgaL/TFcdTAx/oRKagpy1rG3hv1C1i
	 2dqa4OJaUT3bg==
Date: Fri, 24 Jul 2026 23:45:53 +0800
From: Gao Xiang <xiang@kernel.org>
To: Nithurshen Karthikeyan <nithurshen.dev@gmail.com>
Cc: hsiangkao@linux.alibaba.com, linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
Subject: Re: [PATCH v2 2/2] fsck.erofs: implement concurrent directory
 traversal
Message-ID: <amOIsYxZvZpzbdVL@debian>
Mail-Followup-To: Nithurshen Karthikeyan <nithurshen.dev@gmail.com>,
	hsiangkao@linux.alibaba.com, linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
References: <20260724143556.80914-1-nithurshen.dev@gmail.com>
 <20260724144713.85393-1-nithurshen.dev@gmail.com>
 <amOEndBYjdJ8uAeb@debian>
 <CANRYsKiNaBnNrf_vG5eX9+3U+T=TRNDqDxJQh+hLPKgULZHopA@mail.gmail.com>
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
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANRYsKiNaBnNrf_vG5eX9+3U+T=TRNDqDxJQh+hLPKgULZHopA@mail.gmail.com>

On Fri, Jul 24, 2026 at 09:02:38PM +0530, Nithurshen Karthikeyan wrote:
> On Fri, Jul 24, 2026 at 8:58 PM Gao Xiang <xiang@kernel.org> wrote:
> >
> > As I told you the merging policy, each patch should have no
> > regression, if concurrent directory traversal is useful, please
> > just implement it as a base, I won't accept PATCH 1/2 since
> > it has regression and useless.
> >
> As I told in the email, I am just stating that this patch is a definite
> improvement and meets the merging policy, and I will implement
> parallelised decompression on top of this patch only in a few days.
> 
> I hope you could review this patch and let me know your thoughts.

So why it's called `[PATCH v2 2/2]` rather than [PATCH v6] fsck.erofs:
implement concurrent directory traversal?

> 

