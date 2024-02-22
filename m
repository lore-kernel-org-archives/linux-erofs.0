Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 360E7C48BF8
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Feb 2024 07:35:57 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=FItXX0at;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4TgQ1765SJz3dS8
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Feb 2024 18:35:55 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=FItXX0at;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=145.40.73.55; helo=sin.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4TgQ125DYDz3cL0
	for <linux-erofs@lists.ozlabs.org>; Thu, 22 Feb 2024 18:35:50 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id AF7D8CE214F;
	Thu, 22 Feb 2024 07:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66413C433C7;
	Thu, 22 Feb 2024 07:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708587347;
	bh=/gg6HLF1iVc0ufJm2KfXB3s9/qrmwuJTBEsKy5Ju3CQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FItXX0atqDVJdSO1Mfc/40AiapAWskiKnq9zL2oS2mm9+kzD56o7fNbV91yzoA8eM
	 RAJTFEnxz7s6CLqzlajoYgAwf/uE3XXD/8A9vo8sDLZe9cmqp0JAADAK2cyDnAHXuu
	 G6tmuLc/4/gwZSwk9jY2NdUaPwTnBInpgOW4p9iRkvKZvfbgQF48SI+CBffipUVdef
	 d7OC33Jcba0SJn6ahtRcbU0DvAyyu6SpmrF+pmuCztU3vXKyZ4pge3YvB/XaS9XsWE
	 4aHOfOtOrR2qB2wUg//b5CTkmFXNSjqJ+CRiK+h3p96888P51y/SCMlA/cFrbNv35L
	 IB+IIccn1kCdw==
Message-ID: <12b7187d-73c9-488c-a7cb-93ca31bc74e5@kernel.org>
Date: Thu, 22 Feb 2024 15:35:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] erofs: fix refcount on the metabuf used for inode
 lookup
Content-Language: en-US
To: Sandeep Dhavale <dhavale@google.com>, Gao Xiang <xiang@kernel.org>,
 Yue Hu <huyue2@coolpad.com>, Jeffle Xu <jefflexu@linux.alibaba.com>
References: <20240221210348.3667795-1-dhavale@google.com>
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20240221210348.3667795-1-dhavale@google.com>
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
Cc: quic_wenjieli@quicinc.com, linux-erofs@lists.ozlabs.org, kernel-team@android.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 2024/2/22 5:03, Sandeep Dhavale wrote:
> In erofs_find_target_block() when erofs_dirnamecmp() returns 0,
> we do not assign the target metabuf. This causes the caller
> erofs_namei()'s erofs_put_metabuf() at the end to be not effective
> leaving the refcount on the page.
> As the page from metabuf (buf->page) is never put, such page cannot be
> migrated or reclaimed. Fix it now by putting the metabuf from
> previous loop and assigning the current metabuf to target before
> returning so caller erofs_namei() can do the final put as it was
> intended.
> 
> Fixes: 500edd095648 ("erofs: use meta buffers for inode lookup")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sandeep Dhavale <dhavale@google.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
