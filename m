Return-Path: <linux-erofs+bounces-4363-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE490C61DBD
	for <linux-erofs@archiver.kernel.org>; Fri, 28 Aug 2026 15:47:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hWjSk6109z2y2T;
	Sat, 29 Aug 2026 01:47:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787932054;
	cv=none; b=QKQzBYE8Bxg9PXO78rZ5MiPzj0HFcRjwOCkwB9Whh6Ih0DLmOedjo1TEAyHixm/fEPhqaYqBj2ojpf0i4G0XMW/AmqYtFEYdDn2z7iYW8opfK0jycUo+x3OAao6ZDD/zsbGUh4KlvNXCYUb9PbMQpjPFiDjBad28sv6MI6+bJv0RTkFjQcTQnbQYIeBlekuP6OagHaA788mev6XbgZ3JRZkjnPlSPXjLmm2eMow8+riL8loGgp0hxaeWUuDrZIJlQeYrxjuZKtHdoLM78I6Z0hk0Gs6T0giernpLsKAth+6PN4t0n68euq2wTjTPYJthuIF9pQrF2tmPsK9jHsGLDA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787932054; c=relaxed/relaxed;
	bh=UX7PSrLrhs/jlVb65VbeiT5KGinVZr2MwpTHEwgnYKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FYL+dKnLpZ7QvjwBeCeAipJWvJRtMqRC8H1rxWzXqXzxgjMYMnKAdm3TZcPOYMaGkeWmPorW4a45VmYbAwRZzdmEqQYffc7GULYXLMmPaiN50ZNpxEQe2WMcqYQwNmsJ9IJq+bK3x4MSv5eWJ6RE2dq5hAzUYHqhCprxTwATq237O6wXlRPx60jWTFa/pjiuCYMCfDsZatIjeSfAeAwiJjLOdbJjndE06GwoNsgL6cDiohVqPC+NdeY9g0mqrZnjCUmGwYCNZVVnegJNK0Wbkg27dTScaJybLQk5PEt8Uf07FmnrW+gkHfpLVqnSGopBzpfArAz4oRP1vkd6XZV//g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KOF7MG1V; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=nsc@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KOF7MG1V;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=nsc@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with UTF8SMTPS id 4hWjSj37gRz2xlw
	for <linux-erofs@lists.ozlabs.org>; Sat, 29 Aug 2026 01:47:33 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id D57E640757;
	Fri, 28 Aug 2026 15:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3D9511F000E9;
	Fri, 28 Aug 2026 15:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787932047;
	bh=UX7PSrLrhs/jlVb65VbeiT5KGinVZr2MwpTHEwgnYKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KOF7MG1VQIHvi+BqY7noHCPVWdPMOYRvGIZn/tvskmB7DTwQfvfJS33MWlsdVrbfA
	 nX3ynyesHpksP/X2aXhMJI4L0FK+l0s0jeHDlnO3/jXwEvjZJYp3Sc7I4uysKE/4Cz
	 6PZUPJoDCXjmyhJp6ulzFBzUKdqjPD744R6vteiWMIWW4I5KwE0o/zD29uaKUN4NdC
	 rwo9JqwmSCOZrYk/Zwo1fDdvgAvmqdixOsFmRUQOy6VPMQc++oMPzPjCuNE9/TpUs8
	 1923CcCFeUEawOy7OjOLSCaQ1HgBeob7L0PwxUJFupBeElaP3PUUsxk7kCBdiiMBTJ
	 eI7b+I0IioIfg==
Date: Fri, 28 Aug 2026 17:34:27 +0200
From: Nicolas Schier <nsc@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default
 logic
Message-ID: <apGqg5a5I9g1CoF_@levanger>
Mail-Followup-To: Geert Uytterhoeven <geert@linux-m68k.org>,
	Nathan Chancellor <nathan@kernel.org>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-kbuild <linux-kbuild@vger.kernel.org>
References: <c480ed6b8bf38822263e2c5b7cf32b28600f212d.1787219898.git.geert+renesas@glider.be>
 <CAMuHMdVyUAA3L4mUkSjmnuE3cvj-+N8z-Bhxsh1wa-FQWc=fjw@mail.gmail.com>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVyUAA3L4mUkSjmnuE3cvj-+N8z-Bhxsh1wa-FQWc=fjw@mail.gmail.com>

On Thu, Aug 20, 2026 at 12:15:33PM +0200, Geert Uytterhoeven wrote:
> CC kbuild
> 
> On Thu, 20 Aug 2026 at 12:01, Geert Uytterhoeven
> <geert+renesas@glider.be> wrote:
> > When NR_CPUS is less than 16, or when SMP is disabled, the default value
> > of 16 is invalid.
> >
> > While actual configuration picks up a sensible and valid default
> > (NR_CPUS or 1), "make savedefconfig" will still write a line like
> >
> >     CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1
> >
> > to the defconfig file, even if that matches the sensible default.
> 
> Is this a bug in kconfig?

I am not able to reproduce that; this is what I see with ARCH=arm64
(arm64 always has SMP=y):

.config:CONFIG_SMP=y
.config:CONFIG_NR_CPUS=3
.config:CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=3

-> defconfig:CONFIG_NR_CPUS=3

similar for ARCH=arm:

.config:CONFIG_SMP=y
.config:CONFIG_NR_CPUS=3
.config:CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=3
defconfig:CONFIG_SMP=y
defconfig:CONFIG_NR_CPUS=3

or with ARCH=arm and SMP=n:

.config:# CONFIG_SMP is not set
.config:CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1

(CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS does not appear in ./defconfig)

and with ARCH=m68k, NR_CPUS=8:

.config:CONFIG_NR_CPUS=1
.config:CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1

(CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS does not appear in ./defconfig)



Thus, to me it looks as expected.  Do you still see the behaviour you
described above?

Kind regards,
Nicolas

