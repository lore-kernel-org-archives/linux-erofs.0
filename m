Return-Path: <linux-erofs+bounces-4492-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FB97C79FA0
	for <linux-erofs@archiver.kernel.org>; Mon,  7 Sep 2026 17:01:12 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hdtd23vJHz2ytv;
	Tue, 08 Sep 2026 03:01:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788800470;
	cv=none; b=Xc1CdCUS32DyQPM4FETp0RXMI+58y2jLzQ25uGf9khbND45y9HiYuy3hD7/mdTLzW9+oBmH1K1zaaCZ14CTbzBhPYwvBF/XDabiO8YoGS6Tl2UOiEUzUwkWRtW0fFsAPOMvnMvekUbBbrRF1DaFqZWV6inUN3krIGkivK20etXcZ1TuIGOB1kk9dCOQLcACWliOKus6w0qA4A2M2GBS25T4Cw41wLEMxTNKLHmiXWYCIi11+h9L+xs1ntxRK+jFEZPR+HBlP1Bai2+6MmH+ROKvP6aLkibIgLZE0pRcLN5rcJEo575okWEvMLgO7WM8AnEwTReq0lBoMh92OGSLemg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788800470; c=relaxed/relaxed;
	bh=MaXDcai1D5iQBoi7xi9olTK/TjK+YeuvCgmC2IXSMX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C51kyPIPD8qz98QU0f3c9wQgJFVYmo0FXH5ExFdnE1/z2B17eNOjPXDb3VrbG+9t3yHe2QHuB+6oQuwHmXjkLxoanmgQUeSbfDOf2lLIdIjrHYdtcu1Yueb7xrdTKexsFFyHl/9CJc7xkCHcQSjgSfs/xtKAk7wMttkmA7IPkNAXKWrSzYHQiKjRSjgsm7x8gIzniznAobzd62a/ne4k7I4xmYls6zEaFCHbv5uFXFcVF3fqM/EDe7Ks8Achna8ZWEY87UPqClc8jHjtk5OLfCZUlkao3RHL5ihxtswDUdZLs4VhdFP9y6hZFiQyV4cKw44EddVlx8LlYcD3FevZHA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CnAtHcWZ; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CnAtHcWZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hdtd13WsPz2yCr
	for <linux-erofs@lists.ozlabs.org>; Tue, 08 Sep 2026 03:01:09 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 89A2E40A73;
	Mon,  7 Sep 2026 17:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C751F00A3A;
	Mon,  7 Sep 2026 17:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788800466;
	bh=MaXDcai1D5iQBoi7xi9olTK/TjK+YeuvCgmC2IXSMX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CnAtHcWZun0ywBpa/QxielXJkob1gtc1EOpEoBvphgwGpyWFh7vF6rpneH1FPmjDV
	 lJmHd2f3hdNeRDKOyQXlXJltUjZW1I9E3c5A+XrBgml+qVzBGPf8YJU4aWSAD6yZZ0
	 2qGSNaJOAiVNyGI9aqbMr247O7po02Y2T1W3elzESJO2dkVgQsc+oNj6mr8ZDrERT+
	 DAMGK8cK0R8I34mDuCVbckMIS6ar0iuvAlfMRrbaqRKZTQiIzOxK/bNZvkTu5x5njG
	 DFXbFuwFxDUVPOJR/mkyFqahlAseGibgVn6NyRmD87WFVSAEcWupNxDzbdoDalUtv7
	 SnxN4d3ciUp/w==
Date: Tue, 8 Sep 2026 01:00:56 +0800
From: Gao Xiang <xiang@kernel.org>
To: Jonathan Calmels <jcalmels@nvidia.com>
Cc: linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH] erofs-utils: lib: refresh device table slots on
 incremental builds
Message-ID: <ap7tyB-Nv_BhPU4d@XiangdeMacBook-Pro.local>
Mail-Followup-To: Jonathan Calmels <jcalmels@nvidia.com>,
	linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>
References: <20260903232109.1198449-1-jcalmels@nvidia.com>
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
In-Reply-To: <20260903232109.1198449-1-jcalmels@nvidia.com>

Hi Jonathan,

On Thu, Sep 03, 2026 at 04:21:14PM -0700, Jonathan Calmels wrote:
> When --incremental=data is run on a merged image, erofs_write_device_table()
> leaves unified addresses and total block count stale after the primary device
> grows. Fix it by rewriting the slots in place with updated uniaddr value.
> 
> Reproducer:
> 
> mkfs.erofs -Enoinline_data a.erofs a/
> mkfs.erofs -Enoinline_data b.erofs b/
> mkfs.erofs merged.erofs a.erofs b.erofs
> mkfs.erofs --incremental=data merged.erofs c/
> 
> Signed-off-by: Jonathan Calmels <jcalmels@nvidia.com>

Sorry for the delay. I've applied with minor changes.

Also it'd be better to have some basic functionality test case
targeting for experimental-tests.

Thanks,
Gao Xiang

