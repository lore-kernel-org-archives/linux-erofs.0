Return-Path: <linux-erofs+bounces-3324-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBBCEF436B9
	for <linux-erofs@archiver.kernel.org>; Fri, 17 Apr 2026 16:20:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fy0Tq1kjfz2xc8;
	Sat, 18 Apr 2026 02:20:15 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1776442815;
	cv=none; b=GHcEqkF6mcfzFKmW3CsHUNQE+erF46qGfVJx7a/7h1mu1ogpJ/a1+CVmhrzo/402diYd9I7zSlzrae+0LhWFMl3wGtbQF3D6ufgHwl7kYu//hi5Uyi77dKj+vZ1wQ0eO4zj+YZhcQaErCPXUoDeIRmVnTQETS0j/cXgYw/QD3YH4br6PSDrncN8GmUdZPIDmPeNWSoFxG5+u5P6EBL8ujtfqPXlgVms8b4JDRAKM2H1LHRnm6wzkeAiHhGZZixyNRaoIbb8rYjnN9OfFnwh4UpBSgR7Ida6pt8hH6xvMl4LDVIEpdzgXDLpFxLCqcE2agHxkklui93OWKyqstThLQg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1776442815; c=relaxed/relaxed;
	bh=TMy0Zd9kNur/j+YGJX0a1NoWbBD2UdQpguYnnEtiY+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nh5GIRBoYar1nZC8jkaJCPCLY8XMA7DQC1usi6+NGJ/ndp4o4JSuZMWGH7BUrOcQkUUu1HGVnTAKBcE5ai8XXU+UlAuryynPxYAZ19iL3PzuUDfq2437RgBtSTGrC1qFUx8BpHSEFp/zsmUjmPJLEHbDTpqtIaDBVemJBSFs9R/S6yeTx6AyqnFHO4bhgIDxmjpW4puvdIbQhBc2z3bAC8XLzrJw/kcVhG7TATjj1pbiAiqlI/IEgh8tHLMExTq2AN+kI4eCG/p4E8DWQ8Qi00QKbEc9STXzdczJOjbRVhKQQsALPmS0qY8WjN0TZNxeavOF8stkf90kGqaCtIOhSQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=JOAX4cy0; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=JOAX4cy0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fy0Tp1gBkz2xTh
	for <linux-erofs@lists.ozlabs.org>; Sat, 18 Apr 2026 02:20:14 +1000 (AEST)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B5AFA416AE;
	Fri, 17 Apr 2026 16:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063F8C19425;
	Fri, 17 Apr 2026 16:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776442811;
	bh=p9H4HGanoHe8r+GpynkxivQGZGHCybeKdTOMUvSnbjA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JOAX4cy0O3RgdP1J2dc4lEpauhzfFGqJjduimjkXGkfhLzUiRTSasTLxvCJXaYGWV
	 nfJB4gAAEHXhT4QV+K/T0nx9gkIWrj1zFL6pNIIs6dJMNBElBsBRLtuxnCRdkr8ba4
	 nUeNZPy4xKQDkVah5Hd6A1YpMMNllAPh+gktyw9ioYDj5TbbrVAo2jef50Mn1U0C+l
	 moINBaB5oXwzesjMUx7zsvuqpqMy0lNprZ4jEr5lrsEqBVDFwKCSmRUKoxWLbIbmCf
	 jJ528knWwjrLYcTe/ac3Cis+QhyMjwB8fUIXy8dchTrNXAPl4yhP7sdo2GFcvtHUum
	 DRHyADhtC58rQ==
Date: Sat, 18 Apr 2026 00:20:03 +0800
From: Gao Xiang <xiang@kernel.org>
To: Yifan Zhao <stopire@gmail.com>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org,
	oliver.yang@linux.alibaba.com, Yuxuan Liu <cdjddzy@foxmail.com>
Subject: Re: [PATCH 1/2] erofs-utils: mount: support mounting EROFS stored as
 an AWS S3 object
Message-ID: <aeJds46XjTU2rx2C@debian>
Mail-Followup-To: Yifan Zhao <stopire@gmail.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-erofs@lists.ozlabs.org, oliver.yang@linux.alibaba.com,
	Yuxuan Liu <cdjddzy@foxmail.com>
References: <20260417101829.1214550-1-hsiangkao@linux.alibaba.com>
 <f4edfc67-0c4a-49c6-ac15-5821c9b467d3@gmail.com>
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
In-Reply-To: <f4edfc67-0c4a-49c6-ac15-5821c9b467d3@gmail.com>

On Fri, Apr 17, 2026 at 10:15:30PM +0800, Yifan Zhao wrote:
> 
> On 4/17/2026 6:18 PM, Gao Xiang wrote:

...

 > @@ -1106,7 +1263,7 @@ static int erofsmount_startnbd_nl(pid_t *pid, struct erofsmount_source *source)
> >   				}
> >   			}
> >   		}
> > -		erofs_io_close(&ctx.vd);
> > +		erofs_io_close(ctx.vd);
> >   out_fork:
> >   		(void)unlink(recp);
> >   		free(recp);
> > @@ -1186,13 +1343,13 @@ static int erofsmount_reattach(const char *target)
> 
> In erofsmount_reattach() we should:
> 
>     `struct erofsmount_nbd_ctx ctx = {};` => `struct erofsmount_nbd_ctx ctx
> = {.vd = &ctx._vd};`
> 
> otherwise uninitialized ctx.vd leads to segfault.

Thanks, fixed.

Thanks,
Gao Xiang

> 
> 
> Thanks,
> 
> Yifan Zhao
> 

