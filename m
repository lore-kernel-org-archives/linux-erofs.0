Return-Path: <linux-erofs+bounces-2813-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41D5BFED9EC
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Mar 2026 17:08:03 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZz1F51Z1z2yhV;
	Wed, 18 Mar 2026 04:08:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773767281;
	cv=none; b=QwtjVD2CKCw2MeQ0EtX8UR9wuA0xDjnlJbhsXOfJqrVHfFia0XUuBoNWK2oPGC2MD2b5oFYxE1Eta7WIXMGVlO4d/ZZrOUfZQw/gRs0ZNoK0PIP27uOoFVOyZ24kjWHH/xeGvn1jtup21trRwV7BsXJqSPD0SnWZGqC6rX2+meaepZPm6gHifr9HYQ7Du94BmIKwUT17q4KCYT6TaXsFyiMBtYAw0PeENN5r80zxUJ9XGa7N896oFFmgNv4JEWJh5XxBifNnjZNlfKqEff+jp2oSZtrHIlZqMc7pBcijtGZBIicsHyPTfhKlRWUXfKWvVAMRIU09KK3l69aEUWo/EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773767281; c=relaxed/relaxed;
	bh=mOa0Z+FMHGlUDFKeNu1yPtuxObIBCZ/tCqFJWZwNt6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jzQ9awYwNw6yj76G57udr9fn93dGLxlfAQddmo9Nk6rYCGHjFerenv8i1nLwI72jTVxm+xKVnpF3HhAfThESKryL6Nnl/Ds6hNCOAvBAh6NGEQ2vBFEU5d0P0tN8/UwSNWH4+McWQvXOTIhOdS1GRuEVT2vO5E8YCtJb45wiar0W5CxQTDgGF9dxV4FTRLrTwg5RDsQkXExkUy2XkXeVx3NB8BxwrvLeZiYQvjNhJHv3DHuG7n0dcEd9UHgKFMEfJgdhbpuJ0uBp02192Zd0bHwE39HFgnJcECkHlKpUtPnIk1SHbZx/YxhVzhNVJ/2BiTUOW23NVMqmje/j/yHwLg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=aCZ5WtWX; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=aCZ5WtWX;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZz1D531zz2xb3
	for <linux-erofs@lists.ozlabs.org>; Wed, 18 Mar 2026 04:08:00 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 746FE43BF8;
	Tue, 17 Mar 2026 17:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76AFC4CEF7;
	Tue, 17 Mar 2026 17:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773767278;
	bh=mOa0Z+FMHGlUDFKeNu1yPtuxObIBCZ/tCqFJWZwNt6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aCZ5WtWXMY6rVqPJxf+pnsKrAi3t1rUK7yy4JZbNzeU3RpOrEGeemsIp3WK2aFIQ2
	 C3U3okaXSfpcotN41DzmSjxnkUmk56CI/9+KMWf3/cxSx7UjVpvKQxbvjkHPEE58G5
	 k5kbD9G4Ggug5anCLPJK2NmuGC5XD4fe68p924liF67kCXvEB07xR7C2mbTRWX75yq
	 FDrru/HT9Si0Xl+cX/6SnzuioL3+3sIFgse5llkl3y6Gb2hZestMMJ28shBrlR4pHx
	 Rtahk/bHXcFluvNs+gJ7/3J6rBa3xMkH51lvwdljX46EPUn1ETLMlttIEOZBtefzlB
	 nNUeRbeAbKJiw==
Date: Wed, 18 Mar 2026 01:07:53 +0800
From: Gao Xiang <xiang@kernel.org>
To: Utkal Singh <singhutkal015@gmail.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org, yifan.yfzhao@linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] erofs: validate h_shared_count in
 erofs_init_inode_xattrs()
Message-ID: <abmKacsG6m5oAsFm@debian>
Mail-Followup-To: Utkal Singh <singhutkal015@gmail.com>,
	linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	yifan.yfzhao@linux.dev, linux-kernel@vger.kernel.org
References: <20260317152439.5738-1-singhutkal015@gmail.com>
 <20260317164135.24892-1-singhutkal015@gmail.com>
 <abmF9Nn85cz35C1k@debian>
 <abmHBmJ1SjhHTuOp@debian>
 <CAGSu4WOop42Dh_7kni3uK5fsjB4zDRkqvVWyZ=+AqbXoEACCsw@mail.gmail.com>
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
In-Reply-To: <CAGSu4WOop42Dh_7kni3uK5fsjB4zDRkqvVWyZ=+AqbXoEACCsw@mail.gmail.com>

On Tue, Mar 17, 2026 at 10:29:00PM +0530, Utkal Singh wrote:
> >
> > Hi Gao,
> >
> > Sorry about this. The mismatch between the commit message and the code
> > slipped through when I revised the patch — I updated the implementation to
> > use sizeof(__le32) but forgot to update the commit message to match. The
> > changelog was also wrong (v2 mislabeled as "initial").

Sorry, honestly I'm skeptical about it, because your v2 already uses
__le32:
https://lore.kernel.org/r/20260317152439.5738-1-singhutkal015@gmail.com

And I think your v2 is almost fine, I will revise a bit manually.

> >
> > I wrote this myself, just didn't review carefully enough before resending.
> > I'll be more thorough going forward.
> >
> > Will send a clean v4 shortly.

Please don't resend anymore, it seems the mailing list is flooded
with your patches, and most versions are meaningless.

Thanks,
Gao Xiang

> >
> > Thanks, Utkal
> >

