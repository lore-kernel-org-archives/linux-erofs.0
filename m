Return-Path: <linux-erofs+bounces-765-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 387D3C87FCF
	for <linux-erofs@archiver.kernel.org>; Tue,  5 Aug 2025 01:43:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4bwx5m6Lylz2xHp;
	Tue,  5 Aug 2025 11:43:24 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1754358204;
	cv=none; b=FS9yuaebfVzPKstWA7oGHXWnmCyw+jVW3y+dtRH/9jR/Ze7YbK8MdwfBYVUqsWcMinuurS/T5mpiZGAgIsqM/WecsoIUFsIG0M36xjXLkCX3mTawQ1RwJKeAttmhYr5UD9UJmZba8IErOOUGn8se49cF9nTaZnpQwEBA9Gkd2Nr7R5OkQaRgjh6YoFvtmVulURGhvK401KAC7ed2ves0euE/fDT5RXjHgbqNoIBt4twz04HjaNRdWiepifnnERtBk3JP76i3JjBOi13dXJ6abS1lmDxeUyDUXNT8eMnlI+wN2W2+llb0D1kJ4xF8m1xmNWptyoluhAc6fplIkA74mA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1754358204; c=relaxed/relaxed;
	bh=9dYADWpTuv14vdNRl1oOPRCvz8e/tdcXRS2nxaslzHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QIXJro4ji69eNBxxPmJNbucFMMu4dBgLqLztELjbvBW0ybj/rpdMPDUrkpZcSptUoBQjdbDAbB0JStKlERqHYDN96AhnNhNfl8BhRQWwcMqRSvv3LSB4Zj5lsEYpFEN1uWiNhBwvi3crW5aBkz+XbPKv4w6jlyf4Bb4gE5TlZa2Rn/nxn9kQkPQUXUjVIIJqkyufEwX2v3ZvUIRHWZvgZEZnabH8RMl6t+X/lEQsZBMOaFefDhAIvqdj7e1DM/HbgM8jXOYVfX4s5D42GOI3CN/PKTwgnF67Tnt8MMMict0pide+DAWMIThczxiBnQZ/fBTRiHnOHK0v6QFApFxLCA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Scb9mxYx; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Scb9mxYx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4bwx5k6qw4z2xC3
	for <linux-erofs@lists.ozlabs.org>; Tue,  5 Aug 2025 11:43:22 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754358198; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=9dYADWpTuv14vdNRl1oOPRCvz8e/tdcXRS2nxaslzHg=;
	b=Scb9mxYxI6VXzGyuPK/ZRE5qa+1vObQUQ4WnSykuLSKFwWgQw/TeOfnbfur6dDly5nvGEAj5nHC77f4PbElvByDVxpD/gklZGnLRPUairUAhO3VX5v5AIeFfTK/nUsxbVYM1CnqgZMBthllSOwWDwD6nTim1mnY9GOtmrvvqgoA=
Received: from 30.221.131.119(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wl33RFZ_1754358196 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 05 Aug 2025 09:43:17 +0800
Message-ID: <0c1b7ff7-b053-4868-a550-e2044aba300f@linux.alibaba.com>
Date: Tue, 5 Aug 2025 09:43:15 +0800
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
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] erofs: fix atomic context detection when
 !CONFIG_DEBUG_LOCK_ALLOC
To: Junli Liu <liujunli@lixiang.com>, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Cc: xiang@kernel.org, chao@kernel.org, yangsonghua@lixiang.com
References: <20250805011957.911186-1-liujunli@lixiang.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20250805011957.911186-1-liujunli@lixiang.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2025/8/5 09:19, Junli Liu wrote:
> Since EROFS handles decompression in non-atomic contexts due to
> uncontrollable decompression latencies and vmap() usage, it tries
> to detect atomic contexts and only kicks off a kworker on demand
> in order to reduce unnecessary scheduling overhead.
> 
> However, the current approach is insufficient and can lead to
> sleeping function calls in invalid contexts, causing kernel
> warnings and potential system instability. See the stacktrace [1]
> and previous discussion [2].
> 
> The current implementation only checks rcu_read_lock_any_held(),
> which behaves inconsistently across different kernel configurations:
> 
> - When CONFIG_DEBUG_LOCK_ALLOC is enabled: correctly detects
>    RCU critical sections by checking rcu_lock_map
> - When CONFIG_DEBUG_LOCK_ALLOC is disabled: compiles to
>    "!preemptible()", which only checks preempt_count and misses
>    RCU critical sections
> 
> This patch introduces z_erofs_in_atomic() to provide comprehensive
> atomic context detection:
> 
> 1. Check RCU preemption depth when CONFIG_PREEMPTION is enabled,
>     as RCU critical sections may not affect preempt_count but still
>     require atomic handling
> 
> 2. Always use async processing when CONFIG_PREEMPT_COUNT is disabled,
>     as preemption state cannot be reliably determined
> 
> 3. Fall back to standard preemptible() check for remaining cases
> 
> The function replaces the previous complex condition check and ensures
> that z_erofs always uses (kthread_)work in atomic contexts to minimize
> scheduling overhead and prevent sleeping in invalid contexts.
> 
> [1] Problem stacktrace
> BUG: sleeping function called from invalid context at
> kernel/locking/rtmutex_api.c:510
> in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 107,
> name: irq/54-ufshcd
> preempt_count: 0, expected: 0
> RCU nest depth: 2, expected: 0
> 
> [2] https://lore.kernel.org/r/58b661d0-0ebb-4b45-a10d-c5927fb791cd@paulmck-laptop
> 
> Signed-off-by: Junli Liu <liujunli@lixiang.com>

This version seems applicable to me:

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

