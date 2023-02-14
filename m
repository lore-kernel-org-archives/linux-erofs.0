Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB654C61DA4
	for <linux-erofs@archiver.kernel.org>; Tue, 14 Feb 2023 13:41:08 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4PGMmg3Mm4z3cMb
	for <linux-erofs@archiver.kernel.org>; Wed, 15 Feb 2023 00:41:07 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=oUx8kw2g;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2604:1380:4601:e00::1; helo=ams.source.kernel.org; envelope-from=chao@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=oUx8kw2g;
	dkim-atps=neutral
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4PGMmZ0xFzz3bhZ
	for <linux-erofs@lists.ozlabs.org>; Wed, 15 Feb 2023 00:41:02 +1100 (AEDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id B851DB81BF4;
	Tue, 14 Feb 2023 13:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F354BC433D2;
	Tue, 14 Feb 2023 13:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1676382058;
	bh=ILRkbbW9Y6xGFEnpSQ1GK+iTKL7xgpCwB42KdPXl/u8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oUx8kw2gB0gyJiSLuiU4aYLG2rhOcZWkE/PD2cz0DA+f6guAoPfeOWC270Kroc6Z4
	 Rk3eVuxy6Mr4G13efxk8hQI7e0BDJt1l9OUxbuh3q1IpMu8bddhSeBiqhqHYeM+Re9
	 YjG4aIA5nAEEHw9iSPI3ieKu3HZIdkfZdVc+TtjuDbpAZolPKGIFyvURIln2FaVOUp
	 f3vLbmeSNwpoXTsHBBPaLqbko/h0F94IOQgg3CxLfw9jpC+VZx5popD1/zF/zyYD/6
	 4MJDqxAuIHFs5+1SHNBy3Zat1DKIu+kpFmeL15imVLiwARjzR4Oas66PA3cu6XFjXP
	 9BwnQX8mAnvfA==
Message-ID: <637ce3ad-296d-3b2d-548c-4767e1084d1b@kernel.org>
Date: Tue, 14 Feb 2023 21:40:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 1/2] erofs: get rid of debug_one_dentry()
Content-Language: en-US
To: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org,
 Yue Hu <huyue2@coolpad.com>, Jingbo Xu <jefflexu@linux.alibaba.com>
References: <20230114125746.399253-1-xiang@kernel.org>
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20230114125746.399253-1-xiang@kernel.org>
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
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 2023/1/14 20:57, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@linux.alibaba.com>
> 
> Since erofsdump is available, no need to keep this debugging
> functionality at all.
> 
> Also drop a useless comment since it's the VFS behavior.
> 
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

