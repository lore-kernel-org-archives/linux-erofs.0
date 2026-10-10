Return-Path: <linux-erofs+bounces-4690-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EE35CA9EC5
	for <linux-erofs@archiver.kernel.org>; Sat, 10 Oct 2026 21:28:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j2H0P44W3z2yHD;
	Sun, 11 Oct 2026 08:28:37 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791667717;
	cv=none; b=UAA8Ah8nc6PQdhk2KS+pYCwyv53Haci2uclwk7tPaUOvFx0Rp+dNFxJbRi0CITOUpvwIOV+xer/jCiEvXKIAgXhBbwT7VjI1lqYzpziD/qCFy/1Mu22hBv0NHK83uKrtByXRH+NJhChOcU5UXFENGr6NNRLcg1SLt2prswtgRbL4b7Sd0KTahiGyF8aSxkTYno2HibBMdfeqZJ4wD7/lDVFkxIvQnE9hay7mGhmZ4GozD/1ErNvJTeicSSnbCYaWbfVSaoVKOb8HR6+dcvRmLDOxpAtWN4OmX/eK7iwkJ0RQkNFartUSX9+8uikNomqrhrnnMPs9Zpn/hd8UvVSmuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791667717; c=relaxed/relaxed;
	bh=A0mLpUjsNB+/hFJXiSI4UsRTSWL1TE0IwIRugJLK2mA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EHS7cVWopmEpaXr+BwD/Xopzil4blZ8DrrdB8AcDLw2NpnTBVu9lDNx1dmMX6UbcHLi/RFmB7jpc2oy3vV6QBL0oJUxpTPl1mrURBXI1zJie2+eHpURxwFuCHbAtOb1kAR2FgNTzT9flAcV5WOS1rn3yeW2zkLprjz7941RTiqYrzES1vkj/OH1Jyj4MQcgboA5yPli+D0U3Lkh+hVB6R8isVFQVGNUOMs2vwiVk8Gbk8anl0a2WCTrxraoEAmOBdo27x605r7W7MprPvCccxh54vB00DX4CWy1RNvN8RJ/as6WUHYCU7PjV/QzWys8VqPtfyx/o8pI9MptPSgAPNw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AdsEZHUj; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AdsEZHUj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j2H0N5Prkz2y8f
	for <linux-erofs@lists.ozlabs.org>; Sun, 11 Oct 2026 08:28:36 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E8C5600AA;
	Sat, 10 Oct 2026 21:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF0F1F000FF;
	Sat, 10 Oct 2026 21:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791667714;
	bh=A0mLpUjsNB+/hFJXiSI4UsRTSWL1TE0IwIRugJLK2mA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AdsEZHUj5k2pfgQnJLsW5C0VAiUQ47NxbgmMYVyZkT4qSu8taeA+hpoe8Mzvc0hrE
	 aJiQd7hSb/Icb+BboDTz+o5u4EuPajVA7vHyUxqwbrbmi2Dfb5uLOGjP4E+p2Cja5v
	 b90Oal8FTO6sgXK04XLEIghnLWBHrXCy4nKRy6qsG0Z3Fi+OA1VZq/XEFT7NBxwFIt
	 BMvrtp1cUiTYDkYBS+gbqCxkMQBR9I2khD0eUyTAcuwxiJjZA4EMduC5tvi3xh79N1
	 e00zvZnTxUPNxIoY3G6nFNdsIL/S/LoO2XA7+wqK4gnmwPjginQcme5c9woxEMPFZM
	 3r9PLQCTtKIjg==
Date: Sat, 10 Oct 2026 23:28:26 +0200
From: Gao Xiang <xiang@kernel.org>
To: Chao Yu <chao@kernel.org>
Cc: xiang@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>
Subject: Re: [PATCH] MAINTAINERS: erofs: add dev branch to git tree entry
Message-ID: <asqt-vM6LOPyqz_p@XiangdeMacBook-Pro.local>
Mail-Followup-To: Chao Yu <chao@kernel.org>, xiang@kernel.org,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>
References: <20261010070623.1766952-1-chao@kernel.org>
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
In-Reply-To: <20261010070623.1766952-1-chao@kernel.org>

On Sat, Oct 10, 2026 at 03:06:23PM +0800, Chao Yu wrote:
> From: Chao Yu <chao@kernel.org>
> 
> The EROFS entry lists the git tree without a branch, so tools that
> derive a baseline from MAINTAINERS, e.g. sashiko, fall back to the
> remote HEAD, which points to master. master only moves at -rc1, so
> series developed against the dev branch fail to apply there.
> 
> Name the dev branch explicitly, where erofs patches are queued.
> 
> Signed-off-by: Chao Yu <chao@kernel.org>

Acked-by: Gao Xiang <xiang@kernel.org>


Hi Chao,

BTW, could we request sashiko folks adding erofs mailing list
to their review list as well?

Since some patch could not Cc LKML or fsdevel, but I guess
we need them to be reviewed by sashiko too.

Thanks,
Gao Xiang

