Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C2ECEE49A0
	for <linux-erofs@archiver.kernel.org>; Wed, 23 Aug 2023 14:46:30 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=ccJoZZax;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4RW8DP0mWFz3c40
	for <linux-erofs@archiver.kernel.org>; Thu, 24 Aug 2023 00:46:29 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=ccJoZZax;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2604:1380:4641:c500::1; helo=dfw.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4RW8DJ6T4Fz3bxt
	for <linux-erofs@lists.ozlabs.org>; Thu, 24 Aug 2023 00:46:24 +1000 (AEST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 3D00D61F49;
	Wed, 23 Aug 2023 14:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD94C433C8;
	Wed, 23 Aug 2023 14:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692801982;
	bh=y9nMdjkiUGfR7L0YnkBfUfdbrk+TevW/ibXcHHXrrRE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ccJoZZaxN+nHZRJdo3o7Wh9es+CIwVmKEQZVDVdFuefleucWEZZzKcjYqEnov8Sie
	 BGbHRePqPtxHRR2kwrTbmaKOea4JdPUSLeIaJoDQUgVolDJFlnLb6sVr9dxXBfhUFv
	 wEZJc9phZhGTBnWX1qE2YlFIxCHUhpreVFQfCHkUvJ+JNZvhQ+rp83oVRzLaXRrJsU
	 P4iL0mymdBnwdDsNTR1CxP1jhA8nrn2VocE7IYw+fYvMTG6tBGZ+BYgVRSvJXxj+e+
	 iFoGGpm5ppcyiOV0uRiSmytdpL2xuTf3CJEreFQ7hU7EgkzLEB8RJRJvYBCw5p9Vzw
	 uXbkt0pL+ebjg==
Message-ID: <b00ad8a5-c6ab-06af-5678-13ff915aed9c@kernel.org>
Date: Wed, 23 Aug 2023 22:46:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 3/3] erofs: remove redundant erofs_fs_type declaration in
 super.c
Content-Language: en-US
To: Ferry Meng <mengferry@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
References: <20230815094849.53249-1-mengferry@linux.alibaba.com>
 <20230815094849.53249-3-mengferry@linux.alibaba.com>
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20230815094849.53249-3-mengferry@linux.alibaba.com>
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

On 2023/8/15 17:48, Ferry Meng wrote:
> As erofs_fs_type has been declared in internal.h, there is no use to
> declare repeatedly in super.c.
> 
> Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
