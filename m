Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3FBBC61DA4
	for <linux-erofs@archiver.kernel.org>; Tue, 14 Feb 2023 13:46:01 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4PGMtJ3w73z3cJF
	for <linux-erofs@archiver.kernel.org>; Wed, 15 Feb 2023 00:46:00 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=Aa6b3zQB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2604:1380:4601:e00::1; helo=ams.source.kernel.org; envelope-from=chao@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=Aa6b3zQB;
	dkim-atps=neutral
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4PGMtD0mDBz3c9r
	for <linux-erofs@lists.ozlabs.org>; Wed, 15 Feb 2023 00:45:56 +1100 (AEDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 86106B81D6A;
	Tue, 14 Feb 2023 13:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BECC4339B;
	Tue, 14 Feb 2023 13:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1676382352;
	bh=Hm3NTeKzEpgYjkJbBp7+dl97tgXNT9cz6BFe26+Na04=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Aa6b3zQBhr4WszefGzPfFkPO7qmdDyGb39I0AZKJQgKJKq3iYsuMgcoKfC8vsezjz
	 7GUlbpmS8sN72n89r+edKLQbvM7uOI46jzEd7ELsIprY71W3pK0WZUHpXg/QQkcOdq
	 1suWRJFeP2Rt9VFSSnO58CLQlb7VS2lj4cYmJHHWaONf3mll7mj8viPqNuqKBZ9xKw
	 PQSs0hwIr6kilJoeMcDWutSDIjCeUhQlTo60cfS0ICfEvNJWxrrWC3urNnzqzGtFWZ
	 RpLo9xAOewodJeUMSbMEGer+GLP++9hGQgjvx7j8Rm38Lbm9nxZxONUvyTC7e6SOee
	 qh1F37BnAHWXw==
Message-ID: <d5e32e4c-a4bb-e2c1-4c6e-eeb41947dbcf@kernel.org>
Date: Tue, 14 Feb 2023 21:45:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 1/6] erofs: get rid of erofs_inode_datablocks()
Content-Language: en-US
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org,
 Yue Hu <huyue2@coolpad.com>, Jeffle Xu <jefflexu@linux.alibaba.com>
References: <20230204093040.97967-1-hsiangkao@linux.alibaba.com>
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20230204093040.97967-1-hsiangkao@linux.alibaba.com>
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

On 2023/2/4 17:30, Gao Xiang wrote:
> erofs_inode_datablocks() has the only one caller, let's just get
> rid of it entirely.  No logic changes.
> 
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

