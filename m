Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88982EE49B2
	for <linux-erofs@archiver.kernel.org>; Wed, 23 Aug 2023 14:36:35 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=uPazOo5Y;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4RW80x58Gyz3c60
	for <linux-erofs@archiver.kernel.org>; Thu, 24 Aug 2023 00:36:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=uPazOo5Y;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=139.178.84.217; helo=dfw.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4RW80p6bMWz3c3P
	for <linux-erofs@lists.ozlabs.org>; Thu, 24 Aug 2023 00:36:26 +1000 (AEST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id D987D632A2;
	Wed, 23 Aug 2023 14:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A567C433C7;
	Wed, 23 Aug 2023 14:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692801384;
	bh=3vKRFxMpMI5yaOvDQPnrpGOwF6nSbpLAclelBBQ6V9s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uPazOo5YyV2vNg/R3LirVOwa559pagwW8i9iqnN+cn/YcDI8Q7rxsPIPRLoXKTqzR
	 asvZ6ZHRqQVGU3RYFWevceokG2RZjI1jog9RM57cGUTahfYDg26VydNcKKHE3rI1hY
	 vhoSZR6oSKhNRWFd8M5wqUSHPoyTKPvtS2pUGPv6v3utjek8+WmcQVktrg10IeYON4
	 79oOhRBh1cPzzw+W+QHOj2VNCX3kzx+PJjMcN4DFigDnY1T+qKuM25Oy3+gE+qe55p
	 hOOuFsS9yRhdQUIs+0PLS3uiDUNOcsYqn3T69cdK1MrJMn0ui0rFDmXjezZfFocSxR
	 Lc1NxqA3ZroJQ==
Message-ID: <d27f6e4d-2a9f-e7cc-be23-ad710aa22bb6@kernel.org>
Date: Wed, 23 Aug 2023 22:36:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] erofs: refine warning messages for data I/Os
Content-Language: en-US
To: Ferry Meng <mengferry@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
References: <20230809060637.21311-1-mengferry@linux.alibaba.com>
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20230809060637.21311-1-mengferry@linux.alibaba.com>
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
Cc: LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 2023/8/9 14:06, Ferry Meng wrote:
> Don't warn users since -EINTR is returned due to user interruption.
> Also suppress warning messages of readmore.
> 
> Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
