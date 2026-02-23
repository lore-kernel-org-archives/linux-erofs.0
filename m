Return-Path: <linux-erofs+bounces-2369-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44B6CEA4FC7
	for <linux-erofs@archiver.kernel.org>; Mon, 23 Feb 2026 14:47:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fKNww2j7pz2yDk;
	Tue, 24 Feb 2026 01:47:12 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=95.215.58.174
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771858032;
	cv=none; b=jW1Fpb7aWPUatmaLOzQo1aDYvSg4lTZN5afNiwxfZT5cHHvGHEsNuvlNIjXvT4uBapzO+hevdGOnvN9Xm21GT8+q4fWbnV6fCiL5RAVG6z3qi9bT3jfbVx0PZNM1gNt9NC7nxVTFCgTzn+Qx9i8lXZF4ScF9dTYeZX2xZWEZeaPTMAgw0rha9hU+B805RL+qWIJ4M90Qn7YcQG6nEuupFK80LBszLGUhS6PJZCDSzCmlcs87TcTJygKbcTPmJ4oa7Ky8IDrCI3HQS4cXfsyL+XepAHV0Jl6ca6oynXsNPfYVI9KD2ZvirpQ+2EOWGznWXqSqoFp2wxW40TU3VqYy5g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771858032; c=relaxed/relaxed;
	bh=jrdY52taT3U/NZQPuGXBlMxO3l3XijeN4kwKfbf/UaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIO+RTV33w6EqNR+vscXbI1yTRbG74DXEmQvvbuZsvilhlbbxaFJt/XeP7oBcMPDetv3aJcuL9A9uMC8BjCsYfCXEbcrXh/u8EaoYnv3U+O/l+ZpLwIELwaeuPBpSoyJ1WX9cwNS5RCBcdR/dUQJBPMEm9DqzxS+ec87QgO3cD4xsT6yjUczXUF6LUmYz73gZ1MLS6K/gVDnVKV+1jVonKfcESOWFSPCC4GivteRhPLJCZOQOBtD4UFerbiZZBKjEqgopFgakuLGLfqAWipDAamLcZKTVpej5oS5E9UveZ6ev1eYmFdn3kYRHd86FZPLw6FlxDqszTdjZUk5ht5aVQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.dev; dkim=pass (1024-bit key; unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gvPA+MB/; dkim-atps=neutral; spf=pass (client-ip=95.215.58.174; helo=out-174.mta1.migadu.com; envelope-from=usama.arif@linux.dev; receiver=lists.ozlabs.org) smtp.mailfrom=linux.dev
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gvPA+MB/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.dev (client-ip=95.215.58.174; helo=out-174.mta1.migadu.com; envelope-from=usama.arif@linux.dev; receiver=lists.ozlabs.org)
X-Greylist: delayed 80 seconds by postgrey-1.37 at boromir; Tue, 24 Feb 2026 01:47:08 AEDT
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fKNwr2q3fz2xN8
	for <linux-erofs@lists.ozlabs.org>; Tue, 24 Feb 2026 01:47:08 +1100 (AEDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771857916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jrdY52taT3U/NZQPuGXBlMxO3l3XijeN4kwKfbf/UaA=;
	b=gvPA+MB/3rPZe3/+/xAdy7rLGGsuixZx+6Lg/SFcdvj7Pne2gcTVBzuqWYk6/eSywKtBCg
	/+sZ+33MMW3OoWIFucMMZgXUSMYkPwnWDirsMg0jvpEzROz4AOTFePeJ+p4rAiMfDKgcVO
	5d9tzkSlI2GvoE75tBd7urtM5+ANWj4=
From: Usama Arif <usama.arif@linux.dev>
To: Zi Yan <ziy@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org,
	linux-block@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	Jason Xing <kernelxing@tencent.com>,
	Yushan Zhou <katrinzhou@tencent.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: Re: [PATCH v1 01/11] relay: zero page->private when freeing pages
Date: Mon, 23 Feb 2026 06:45:06 -0800
Message-ID: <20260223144507.3065618-1-usama.arif@linux.dev>
In-Reply-To: <20260223032641.1859381-2-ziy@nvidia.com>
References: 
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
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Sun, 22 Feb 2026 22:26:31 -0500 Zi Yan <ziy@nvidia.com> wrote:

> This prepares for upcoming page->private checks in page freeing path.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Cc: Jason Xing <kernelxing@tencent.com>
> Cc: Yushan Zhou <katrinzhou@tencent.com>
> Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
> ---
>  kernel/relay.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/relay.c b/kernel/relay.c
> index 5c665b729132..d16f9966817f 100644
> --- a/kernel/relay.c
> +++ b/kernel/relay.c
> @@ -131,8 +131,10 @@ static void *relay_alloc_buf(struct rchan_buf *buf, size_t *size)
>  	return mem;
>  
>  depopulate:
> -	for (j = 0; j < i; j++)
> +	for (j = 0; j < i; j++) {
> +		set_page_private(buf->page_array[i], 0);

Hi Zi,

Should the index into page_array be j and not i over here?

>  		__free_page(buf->page_array[j]);
> +	}
>  	relay_free_page_array(buf->page_array);
>  	return NULL;
>  }
> @@ -196,8 +198,10 @@ static void relay_destroy_buf(struct rchan_buf *buf)
>  
>  	if (likely(buf->start)) {
>  		vunmap(buf->start);
> -		for (i = 0; i < buf->page_count; i++)
> +		for (i = 0; i < buf->page_count; i++) {
> +			set_page_private(buf->page_array[i], 0);
>  			__free_page(buf->page_array[i]);
> +		}
>  		relay_free_page_array(buf->page_array);
>  	}
>  	*per_cpu_ptr(chan->buf, buf->cpu) = NULL;
> -- 
> 2.51.0
> 
> 

