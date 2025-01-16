Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 539C0C02180
	for <linux-erofs@archiver.kernel.org>; Thu, 16 Jan 2025 08:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1737016187;
	bh=HlLcSsYYWr1ir2AfgCGzsZD+beNrHPx5h3xKJt1Tpbs=;
	h=Date:Subject:To:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=P9cMKXL2z36kJWqqTwADhW6tkP4ZCoON0lQrtPUQjOF1BwzN14RzANVNA5hZcCg2g
	 lOnvoSuQ6oc8Kn1ePgmjb2CAmnfF5mcMnSWt8zkPdwg7gdlErsdtrmqtHO6BQNt4Qu
	 ITZKgXf3azVGTSwV6mVTiSD1nsL0Ihj4VsiWfgvgtuuNl3d4rVsC16YG7sXfoCuc2p
	 k4J0hrEI5luRLHYNNPHM1XBPM/IKsfrL9b6VYfVz/oyS69HTYeuQH3tMHLA61xTj3V
	 1iDEuVegnpIGKugtwbRMpuGw/g2JE6HmPPBx5iXZA+JdySgTN3pTfY6m3MxHJXbJpz
	 DfjyANo4f46PQ==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4YYbdR0ClNz3cdZ
	for <linux-erofs@archiver.kernel.org>; Thu, 16 Jan 2025 19:29:47 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=147.75.193.91
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1737016186;
	cv=none; b=LIiVsYPG2D79BB7iJx6wzZnvBZAYr9O8YHgy1W+EEJE/PcJs/X/AjEY1ZlLEsSHSdJiz5Bx0Zu0z3h/nC74aI/gETMP4jB72AOfxIEADT74eW4KuW3kJ/pXoxsx+qK2kY3U1izMyLtr+z7LDbT6MsdvaN/BmnKZwZKspM0/vXe0C6GrxxQ8dch6ODqfiOCYNsRskGtUrODrYrt31r0BPUsHsQKO+8/mbxUN6vjGkZGEsIc6hLJp3TUqRs+a4XfhgVFMz8d+JKh4x++WzoQHUOJ8H8P3eQk4LBhgrKFb4+W1HNIvBkLV8piRP0hUCILBnEDikyaLmGiQE3umZxlz8pg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1737016186; c=relaxed/relaxed;
	bh=HlLcSsYYWr1ir2AfgCGzsZD+beNrHPx5h3xKJt1Tpbs=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DphvlrYwJeQD6Fz7wrLHeO0tzYhNfHdsk5L71Ff3zLsHqqeYdbTnnnw5IDVilaN/KxmnuJOvBoyGo6HYLPaojzcObmD5d01xI+E8JddzYK9EOE3SPgxcV1gUo9PysIp9nQFIBWlIuki7isiNdzYArIetBPeC7HIKSN/Znl50bHxAEeQoyxTrbQ7dYZd6FNrhQ+hQf9+LZAjrMFgNftSubplMscN4w9cY53EXS4NUqAfUk8HD2DONsybrAOWCNP8LeDzkPkhagf9y+6+7SvhGJcB3EwhICB+9GtQ5Kj60o0B4y9TY0vmq81SWztdB6JTtWwbphFFy2KKxkF7YAj2THA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=XPOoI9om; dkim-atps=neutral; spf=pass (client-ip=147.75.193.91; helo=nyc.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=XPOoI9om;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=147.75.193.91; helo=nyc.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4YYbdP33Smz2ysc
	for <linux-erofs@lists.ozlabs.org>; Thu, 16 Jan 2025 19:29:45 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 31697A41208;
	Thu, 16 Jan 2025 08:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2FFC4CED6;
	Thu, 16 Jan 2025 08:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737016182;
	bh=3v6R+bM9zC0jBKldITfqUHJtQ6njhyNfFdyvs6x9fus=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=XPOoI9omut8Iu9r47zRTSiug8P6Vpen/sPDYAimguVTT7SD+c+XLs9yWmgDKtgUbg
	 0ThlNQ2axGrk3f3cmj6TT/iTu/tCaQJYzEyt9V9USkFjEuZTWiqSft/dYstNX52mMY
	 HjnKfBaz6asf2SAgkeyRgUNJOzHp62zx/WT3UDptOK9xsINbth9iIXDlAHveq7IrvA
	 jM3eUGxXbf52dQci2WYE+HJ5/aAG0hi4eW6HORDzm/vwUOftK2Xl8L6TMO/46g1RQj
	 i2/3N61G2kywQnbrwk5rIIxguPnjyquTlC+1nNmQ0ta9VFokqNDLp37dl7Aj82rgK/
	 u2ExXYG8vUoMQ==
Message-ID: <931f0bf0-4880-4829-9338-1c7623ae9140@kernel.org>
Date: Thu, 16 Jan 2025 16:29:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] erofs: shorten bvecs[] for file-backed mounts
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
References: <20250107082825.74242-1-hsiangkao@linux.alibaba.com>
Content-Language: en-US
In-Reply-To: <20250107082825.74242-1-hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
From: Chao Yu via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Chao Yu <chao@kernel.org>
Cc: linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 1/7/25 16:28, Gao Xiang wrote:
> BIO_MAX_VECS is too large for __GFP_NOFAIL allocation. We could use
> a mempool (since BIO can always proceed), but it seems overly
> complicated for now.
> 
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
