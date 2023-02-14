Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1443CC6379F
	for <linux-erofs@archiver.kernel.org>; Tue, 14 Feb 2023 14:45:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4PGPC64mFnz3cM7
	for <linux-erofs@archiver.kernel.org>; Wed, 15 Feb 2023 01:45:38 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=uBKQ+PIQ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2604:1380:4641:c500::1; helo=dfw.source.kernel.org; envelope-from=chao@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=uBKQ+PIQ;
	dkim-atps=neutral
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4PGPC252KHz2yJQ
	for <linux-erofs@lists.ozlabs.org>; Wed, 15 Feb 2023 01:45:34 +1100 (AEDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id CFD68616E0;
	Tue, 14 Feb 2023 14:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A27C4339B;
	Tue, 14 Feb 2023 14:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1676385932;
	bh=bpGRp9PZUKCb5ApFTO2oPnsxvMoBE9S82dy25TRiNeE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uBKQ+PIQe18kp7QwFW4BWzZGwMik8a0erkmTpJEEG9mQ3uj/CvpdKGRlk09vwxfmH
	 zsoJMhpO0JVPvuNK65eH7jo7XXlSh5he9NlDqyu3Y+zwtAxiAoKmG0wiEZBS7zmasE
	 +APJwNBVH1AeD4FmMVM1//RhOum/D9WovjVhi3a1WP9YyVNotsIfIDZ3jxGCTUKpJp
	 wWRUfhp0bjNo05UPf40/8BOmvJy7P3BUqXIHjRE8BtjEBWdR8bLtGCHFIXg5pgwggr
	 HcYPTVuxvGWmVCxPED+0+RgW17AOv//wJ1cnsCrB/frvggln74tYJKaFxnKG+yHvNk
	 J9v1RunZ3Tsxw==
Message-ID: <7d56cd84-22c6-80df-d25d-95cb37f7fdd3@kernel.org>
Date: Tue, 14 Feb 2023 22:45:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 5/6] erofs: get rid of z_erofs_do_map_blocks() forward
 declaration
Content-Language: en-US
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org,
 Yue Hu <huyue2@coolpad.com>, Jeffle Xu <jefflexu@linux.alibaba.com>
References: <20230204093040.97967-1-hsiangkao@linux.alibaba.com>
 <20230204093040.97967-5-hsiangkao@linux.alibaba.com>
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20230204093040.97967-5-hsiangkao@linux.alibaba.com>
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
> The code can be neater without forward declarations.  Let's
> get rid of z_erofs_do_map_blocks() forward declaration.
> 
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

