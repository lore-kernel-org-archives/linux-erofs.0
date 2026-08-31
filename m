Return-Path: <linux-erofs+bounces-4389-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B1D4C61DD3
	for <linux-erofs@archiver.kernel.org>; Mon, 31 Aug 2026 12:32:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hYT0k4b8mz2xpn;
	Mon, 31 Aug 2026 22:32:54 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788179574;
	cv=none; b=VTp7QbqhLUe0L2Ft6BL7zF7kJsaG5Rrc7wAnNcIoaa9UzuOZltuL2yR+9WKFh1PDCOaWDcG3nffKDP7rMy4Vbl6xC1kDVRXf7zPlPKzfwuWLanDJEOi/FYOMRQNL/4HCzP7Rqfp6TknFVTxnYDRf6c9G2xMXmJcodNEH8rko1aHfxPRtvnHBxjGZiG/sDWuJyN/18Nh7UnWseBxYGsgFZe23Wf5RW0seiRRl+0mYd2/BQIdEZ1OTmWo5S39KbQUpuIUhKtktXQuni93uQYyUDBjjHrnZR12CQT8ulOrI4IdyMZjUylReZYDy3cqpFzx1gtxNdObLgYLibWlFjL/zpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788179574; c=relaxed/relaxed;
	bh=d7kMVnx2LblB7BHqjw+a56gGYnnF9uAQgrmNwvR5plE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cPhNRJKIqi2vB9U4UdF2dAlq1z1obAI2ZHukNCZIQriZszSvj8KhRUkOaOI1r4ES8czk55LuXtvZTByiLEeI72abMfoLrDmEmVfoiZadHHMAsBzIjwQiAaoY9NMvS3KAxnRXLunNL4hm9enA8Iwmer3IKth09v6S6+GYo7p45j0aj9H7KaG0lSeeb5cG26ZA7eSwBLd0DIemN4pFZz0tbCBYkYno5FcE1o5gHAo5rOZcjbVQxUYiPoZ7RaGNZd5EiD5EcFMUyTs33EeEy4y6SHFo8xQfvMsUnFYqy/+E/qBVYHwarTwn6qGLLHMaDaOASjHHte0hGApkrFeZ5Pu9cA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=WmpDWcMe; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=libaokun@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=WmpDWcMe;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=libaokun@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hYT0f6ndGz2xLf
	for <linux-erofs@lists.ozlabs.org>; Mon, 31 Aug 2026 22:32:48 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788179561; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=d7kMVnx2LblB7BHqjw+a56gGYnnF9uAQgrmNwvR5plE=;
	b=WmpDWcMeDT18m0AmkXO8QDGK2sYnHgGPTtyS4hLdv09g9gWiEasAJKsB37n5C2qEpBFWIg3Tth0dVWqvBrLIldYh9gdpN5lvpvRlGVY6SJCAOM9q1pBhFlrSZz3dZoBviUY/woq61fDp7/pxqLls+G0CBgfmgoU3cnvNCnCUPnA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X9yvEG1_1788179558;
Received: from 30.221.129.244(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X9yvEG1_1788179558 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 31 Aug 2026 20:32:39 +0800
Message-ID: <156326be-7d4a-4bdf-b0c0-030dc951af2e@linux.alibaba.com>
Date: Mon, 31 Aug 2026 20:32:38 +0800
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
Subject: Re: [PATCH 2/9] ext4: Remove uses of FGP_NOFS
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Theodore Tso <tytso@mit.edu>, Trond Myklebust <trondmy@kernel.org>,
 Anna Schumaker <anna@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Hyunchul Lee <hyc.lee@gmail.com>, Phillip Lougher <phillip@squashfs.org.uk>,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, ntfs@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-3-willy@infradead.org>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260830041901.2668-3-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/8/30 12:18, Matthew Wilcox (Oracle) wrote:
> Both of these locations are called while a transaction is in progress.
> Starting a transaction uses memalloc_nofs_save(), so we are already
> prevented from recursing into the filesystem and using GFP_NOFS was
> unnecessary.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good to me.

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

> ---
>  fs/ext4/inline.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index ceee69a66482..1884abb09614 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -601,9 +601,7 @@ static int ext4_convert_inline_data_to_extent(struct address_space *mapping,
>  		goto out;
>  	}
>  
> -	/* We cannot recurse into the filesystem as the transaction is already
> -	 * started */
> -	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
> +	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN,
>  			mapping_gfp_mask(mapping));
>  	if (IS_ERR(folio)) {
>  		ret = PTR_ERR(folio);
> @@ -734,7 +732,7 @@ int ext4_generic_write_inline_data(struct address_space *mapping,
>  		goto out_release_bh;
>  	}
>  
> -	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
> +	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN,
>  					mapping_gfp_mask(mapping));
>  	if (IS_ERR(folio)) {
>  		ret = PTR_ERR(folio);



