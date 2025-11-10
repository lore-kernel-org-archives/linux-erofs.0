Return-Path: <linux-erofs+bounces-1358-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BCC2CCFA1A
	for <linux-erofs@archiver.kernel.org>; Mon, 10 Nov 2025 03:08:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4d4ZNr1nBhz2xSY;
	Mon, 10 Nov 2025 14:08:12 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1762744092;
	cv=none; b=PqJ10q0obdk1JadZQKaDU9ckh4122RvfNCbvXJ1eb34CFYt3cGLrYDzy+ZT7N+KZZTzUcYa1nWaEZBKA0I5UP/FvH1izOOyBMFTGm3oXp14XiJb2+VXLojpaAkzmgJ7JVVUr3NAEChMmci2fTe8757ZGJlf/CmdAuvccXtXsXLKwF4TPlyKxiR2SfBIfy5IS+UhR8tnQb6q6OWdKsGk3WlaJNNOt/KcYIm39BlumnIyV+tQglMxRWgQUR1JOwSQK5AFc66NTHQMd4hM5Hdc+IVWutvGzwVNx4TPchJJ+NHFQGVNPazaFezb9q18W9gtw8AfbNnmu7+eAAlG2LFlzKw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1762744092; c=relaxed/relaxed;
	bh=HMtmQ1JhOkMqrf4cquOYemrn0zg1l3rDE3TcWFn8eu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bFiNgSNr19xUG+dAYVsOdPaR7glmmKTHzXVnTcAQueOSeVRgadSmZ6LjFkeD/Myt1qnV6rVX1lgsn3U7lNN5NMG98OTaJkOI4noHwwIZO+jc9rmi1PfYr+oHy7U12r8fusbLkq+7nKEWLnvrfkaT47iASm65H1ZO3MSCT5y3n/lklMHkdj/IRvA3NxwyihpSP25TOEYg/cDKFzYwJ/Nik6fp8Z+MdtNl11PE3WZgLG17+au0SRkFqLeYDyM+KCueQ5+Rv6eHWgozKJjbYkCt6bgQMBbZNAnhK1mp/yx+RBhABo4TsE10e+8xGjen0M5jxn1RKEKRvMsAD1imXWdS/g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=lasrnIQc; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=lasrnIQc;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4d4ZNq1pzSz2xSX
	for <linux-erofs@lists.ozlabs.org>; Mon, 10 Nov 2025 14:08:11 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B12E3409CB;
	Mon, 10 Nov 2025 03:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921FFC19425;
	Mon, 10 Nov 2025 03:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762744087;
	bh=fd9POp+RKa9HLJ2LrC+Ap7gJzgzA1aWHAf90z4Yt3+4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lasrnIQc5PZZl0bzbNHeu053kv5TyGP8tEmTl6C78v7YeTYBy8cBuxVK6KSt5Msai
	 YfW7ID6eJO9LXE+FBE2PDYcyjDBDsc4twgeX0ka2FgdVo6vLelFHkqd3oi8LRBCctE
	 mICDeeOCz37j79wNzBrc1oJs0yo+66TaQK5WoCDzhVeT0dNkIxxj8qOohISsrdLZnM
	 2t0tymucp1ybg6VB8TfJj1s1PwOJIccv1rK1kyZ2k7sQ1neL8SwaYL2R9rCFqNKv4J
	 anVqyWUecnGNBOWuIWnj8lGHIVOGp7LXPEWPLAqw41M5HtIqtaDUYLAzdg0hTLtdix
	 Y2ECha1rC9xcA==
Date: Mon, 10 Nov 2025 11:07:53 +0800
From: Gao Xiang <xiang@kernel.org>
To: Yifan Zhao <zhaoyifan28@huawei.com>
Cc: linux-erofs@lists.ozlabs.org, wayne.ma@huawei.com, jingrui@huawei.com
Subject: Re: [PATCH] erofs-utils: lib: add more tests for
 s3erofs_prepare_url()
Message-ID: <aRFXCfXQZ1NzusVC@debian>
Mail-Followup-To: Yifan Zhao <zhaoyifan28@huawei.com>,
	linux-erofs@lists.ozlabs.org, wayne.ma@huawei.com,
	jingrui@huawei.com
References: <20251031093037.655851-1-zhaoyifan28@huawei.com>
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
In-Reply-To: <20251031093037.655851-1-zhaoyifan28@huawei.com>

Hi Yifan,

On Fri, Oct 31, 2025 at 05:30:37PM +0800, Yifan Zhao wrote:
> Add more tests varying `path` and `key` to cover real use cases.
> 
> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>

Sorry for the delay due to other ongoing containerd work.

I've applied to -experimental branch and will move to
-dev branch soon.

Thanks,
Gao Xiang

