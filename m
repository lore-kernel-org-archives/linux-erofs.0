Return-Path: <linux-erofs+bounces-4405-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A26BCC61DD3
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 02:20:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZRK32Gdqz2xlY;
	Wed, 02 Sep 2026 12:20:23 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788315623;
	cv=none; b=Ul29IhuJkh5ngO+Wt7DSXtWR+4ZtRBVr/z3kSR5GJ0F/tEBdkt8xE0yP6ajSLiScQn7stqGnOXFceuSKlIo2gkw6nMUjnKOo/Q4lHUTY5Vx5nPRaBaBVXGTw/aXGfPDU1kbNlFWHvIfzzRgcj6734XdKYfu+D1E9pTDnWgSl7kLLAaUVLW9jxFoSecC34o7H6cgUKcGiQYiNoxxp4en1lP82vMx3PYqe3m8uznqMLY5DPWC4x1gkuSUISjfynUvL7hWSRGd0MZMI1SUsYibvX/oGpddBf8viQ5SN8zzc6SE5FKA4vreUg0c16VanF5ZgNNLrlX0KOqcjwj7gVsFxmg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788315623; c=relaxed/relaxed;
	bh=JSNKUMG19ljYjQxMFfJROELQ+OnVuDWBJaJwd3/w0hc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gKA2i/QE3q80nH98p813PuD3ln35EnaeEkjx+LHqI3a3oagGoTDFjx5HZgp+fjxWyYT3chEzgewIILuhEdt+PdndE0DnHZEpYKQjrWqro7NpVFvOq0X/U7JJCiG3rXpa8oVgMx/ci+aXei0z44J+YupHo6uZGComghr/8YRarVsTblSFt5SCqSFbsJ6HRSvWC/pcFDFvOz+XEHa0T/h4qwnoNGXTmWzWhaW66J33mvzxuNyAW8NUJ25mxSQaZzcAykHLjAYEWU7b1BdHX7qNQDy7elAH2bAiWO9mZZ/ZYA6FLsfI9kN/N75agQhNFVhLE6iavmEnujz7u72YH53wGA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jHaNAOvq; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jHaNAOvq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZRK11fd7z2xLf
	for <linux-erofs@lists.ozlabs.org>; Wed, 02 Sep 2026 12:20:21 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F439600C8;
	Wed,  2 Sep 2026 02:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E631F000E9;
	Wed,  2 Sep 2026 02:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788315618;
	bh=JSNKUMG19ljYjQxMFfJROELQ+OnVuDWBJaJwd3/w0hc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jHaNAOvqsw2rPdbOgXsqask8qk8si6tJEeIGq2dhY1Bkx90JSCjkhgSfTUCPzFQ3c
	 PBrlFLxTeIEFkabxIHQneST/A9a4eY5DF0O5DP0YhnXcSNrhh+xC46qPtu67Xv8w0x
	 L23X4oJzoBM9f6HNRJKbSmCNykhm1WvkzpR+G8PqlKizkKGGvXOZUkmVkexRMq5Zq7
	 V5ZugdBlQntRzdfN0QFBzcgztoAqEti4Zqnl+oK49iCzogz1/chH95xmj5UQz4J48T
	 aoXxhcWc01mdmxPdMr31chJyENr12EawmEQ5H2eV5z9l40PxJdnxjVi/khXiI0S0JN
	 RNXkM4uj23mWA==
Date: Wed, 2 Sep 2026 10:20:10 +0800
From: Gao Xiang <xiang@kernel.org>
To: Qingyu Zhang <usupergate@gmail.com>
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
Subject: Re: [BUG] erofs: LZMA stream state NULL deref after failed dict grow
Message-ID: <apeH2iPSptCvno8K@192.168.5.22>
Mail-Followup-To: Qingyu Zhang <usupergate@gmail.com>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
References: <CAPBHda=tMkmjY3-WE-d8jnNfDt5bEsAvu1BCiwOT4FgqqYASEQ@mail.gmail.com>
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
In-Reply-To: <CAPBHda=tMkmjY3-WE-d8jnNfDt5bEsAvu1BCiwOT4FgqqYASEQ@mail.gmail.com>

Hi,

On Wed, Sep 02, 2026 at 10:04:41AM +0800, Qingyu Zhang wrote:
> Hello,
> 
> z_erofs_load_lzma_config() can leave strm->state == NULL while still
> publishing z_erofs_lzma_max_dictsize. The next mount of the same
> image skips realloc and decompress NULL-derefs.
> 
> Type: null-pointer dereference
> 
> * Summary
> 
>        for (strm = head; strm; strm = strm->next) {
>                if (strm->state)
>                        xz_dec_microlzma_end(strm->state);
>                strm->state = xz_dec_microlzma_alloc(..., dict_size);
>                if (!strm->state)
>                        err = -ENOMEM;
>        }
>        ...
>        z_erofs_lzma_max_dictsize = dict_size;  /* even if err */
> 
> On alloc failure the old state is already gone. The next mount sees
> max_dictsize >= dict_size and returns 0 without retrying. Then:
> 
>        xz_dec_microlzma_reset(strm->state, ...);  /* state is NULL */
> 

Actually there were similar reports:
https://sashiko.dev/#/patchset/20260714114729.3760594-1-michael.bommarito%40gmail.com
https://lore.kernel.org/r/20260830104109.60639-1-nikhilgurudasani314@gmail.com

I will reply Nikhil's patch soon.

Thanks,
Gao Xiang

