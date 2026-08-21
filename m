Return-Path: <linux-erofs+bounces-4282-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D3E0C5DF88
	for <linux-erofs@archiver.kernel.org>; Fri, 21 Aug 2026 06:36:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hR9ZG4dqDz2xtt;
	Fri, 21 Aug 2026 16:36:38 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787294198;
	cv=none; b=KskM9FNdgIaMj2v+8Nzc9QISnIxZ25BOCje9bR+qKnck0ZtaEeUAfmrKDU9ohDzEyxP5vMDUdc5epwcqXlxBpCsMkSjywinMuMPkkzpakuXADsOWK0c1sj5iWG15JS5uLzTrKnto3x0pIanvfXfsjSEbZ+HWeDi1dnuI5ptdrmL7TpRfkz4KUm8z5U2EN+9BnjCUigMqiJ/jf8yO/zBDuX14uzWHhv2cEQuHz0R1ApLtDeQC3O558zKPydFG6uPmsTG6tQegJU02108sMMSkYq4NPs2ibZMScBsuZS3TgbmEiFRh71Xj0UjOgyRf9kPcJcmAm9Qkd0sC6pQWVtZrLA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787294198; c=relaxed/relaxed;
	bh=g9eZR8v1ht/04XRkyDvZToU/ut5CxaHGMVmc9MyHSdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H3fmO5X6gMYZfMxdMffgv4xn/0rAcQUhEK6A7lnNviZSfFmScw4aeW02Ox3lt6iAN7Upur4iSwiPqK1eixsNj1QCzOdTx5jB9TmL5kfLFjpaWl6q75WH3s3muK5MxOPfJdiliH8l4bdCkyFjCj7clWFlOgYux3u/SWhhiQVYgEyUG2O8D4CkRxXoxyCYXBPfktD7Dt/+xu0S95iqVGcqPDKRZLdkqigFF0fNSGLdo1rsR8ibRvv6NrxtDOwTd799gFEBsl36aZqL3cnKt1saX/09d3y26hMWIVkNWdCsN68ce/IQvQVbNkkhcr7sT+M35IN++YkKpt+OdrQa5L+aKg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SQLl8igl; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SQLl8igl;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hR9ZF6Sq1z2xWt
	for <linux-erofs@lists.ozlabs.org>; Fri, 21 Aug 2026 16:36:37 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B20D43D26;
	Fri, 21 Aug 2026 06:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082B21F00A3A;
	Fri, 21 Aug 2026 06:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787294194;
	bh=g9eZR8v1ht/04XRkyDvZToU/ut5CxaHGMVmc9MyHSdU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SQLl8iglAQ5uOHKiXapSX2A8BTF6nEaFgbpRi/AmulIHTtssD2eEOJRl7sX+JQJFr
	 KKaTRyTYzD1V+OeCVcDQ1FG3FS/rsEG0rYm7UsbsJZ79ZQ1aGn6TFNB7BrBVpps2/E
	 60SVdFsFUQ5pplMGmaArFsInrdY9aAuLNkBSHY9c25HrmuvqdIZK85e/UCukOtQQqY
	 LU+AilJksLvaQAfUW+cH8WJQ2T1zroJCgxxROinYVOUGj+NON1k/nwk+P/Q/8nnAmI
	 UiYTDEYHCcNrL1BfwZ09dIe9OR5UYvRg7lUOZa3Rh04cs7cWuimG1XNghuOn6wbef+
	 uxKbukj/jeAGg==
Date: Fri, 21 Aug 2026 14:36:17 +0800
From: Gao Xiang <xiang@kernel.org>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: Gao Xiang <xiang@kernel.org>, Jingbo Xu <jefflexu@linux.alibaba.com>,
	zhanxusheng@xiaomi.com, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH] erofs-utils: tests: add a splice() test for inode_share
 mode
Message-ID: <aofx4XAjsCKqo9k_@XiangdeMacBook-Pro.local>
Mail-Followup-To: Zhan Xusheng <zhanxusheng1024@gmail.com>,
	Gao Xiang <xiang@kernel.org>,
	Jingbo Xu <jefflexu@linux.alibaba.com>, zhanxusheng@xiaomi.com,
	linux-erofs@lists.ozlabs.org
References: <20260821015722.1936404-1-zhanxusheng@xiaomi.com>
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
In-Reply-To: <20260821015722.1936404-1-zhanxusheng@xiaomi.com>

Hi Xusheng,

On Fri, Aug 21, 2026 at 09:57:22AM +0800, Zhan Xusheng wrote:
> From: Zhan Xusheng <zhanxusheng1024@gmail.com>
> 
> From: Zhan Xusheng <zhanxusheng@xiaomi.com>
> 
> splice() and sendfile() went through filemap_splice_read() on the user
> file, so they populated the per-inode page cache instead of the shared one
> that read() and mmap() use.  The content was correct either way, which is
> why nothing caught it: only which mapping the pages land in changes.
> 
> Observe that instead.  cachestat() works on the file's own mapping, while
> fincore's mmap()+mincore() fallback goes through erofs_ishare_mmap(), which

Actually we shouldn't rely on the fact that cachestat() works on the
file's own mapping since it's another misfeature, similar to:

https://lore.kernel.org/linux-unionfs/20260623111533.2285005-1-ptikhomirov@virtuozzo.com/

we should find another way to replace the cachestat() usage here.

Thanks,
Gao Xiang

