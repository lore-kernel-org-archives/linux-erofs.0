Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97538606A988
	for <linux-erofs@archiver.kernel.org>; Sun, 25 Oct 2026 02:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OSka3LFL
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jC0qq6K0Zz2y32;
	Sun, 25 Oct 2026 13:21:27 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792894887;
	cv=none; b=bmRJrAsOHZC7wgdkl7SYmsk2Z6WObLbV7LMpDalKoS2BzC1rK7dqYh7OBEJLgJFcFqEioa+PtzOHUTK21HMc+1j9fBeXZZqcdtR+qkADZtdni1LkpI0PIH7SoCCPiQLcmcq6enh8+LgVP9FCcc7K3XcHfUdnvKH+TZKJQAB5jqrLmXakvniWSaMAZq1d3kTSEU+4qpf+9nbjUweflchOjv4Mx1AC89FU/rnnsJuQ3gECwlJtmfDvp1mVc1PcNSL2tbioSfoYnfOAzdkC33bNnoIwxfIS7wEHUqISTNJ06qzEAM9NcJyTvVWXSMr4JI9yomT0cotnxm1qZKZTZqW8+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792894887; c=relaxed/relaxed;
	bh=tk1nNKvu4gh+/6cQpDYde1nK+SUWzRQlVwuGvyxxZfc=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hDmb0fN+EafKMj1icekln7c/nqRov2anfpegmjbqII9RS9quh+BRsunnVotSsrDAcCFXkkXif1QarHK7VIi1M6xGU4QNoA260jQrw7eVGT0hqVGzJvaHjsKb1xqmUODUso1pG9ycS9yx9JWF5kmPUBzGBusA/U68bzyapAsXD3oe76wwsNU1/zzgeCpDq/KQ7Beiq6HF0AYtzuNtpiHXTCXXjZz886mhtXNVCIdJdwMv8BGVYq3BhHSeh5B9OKSqwqvunJsbxhYHIVp4lvJ9AcAQlMws8uXmSSDSdab8wpGpYwYJ6Q8hlxOqUItEsP8ABElndlGng7+Ck2r7PJfYfA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OSka3LFL; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OSka3LFL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jC0qp5VFRz2xqh
	for <linux-erofs@lists.ozlabs.org>; Sun, 25 Oct 2026 13:21:26 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5932A6024D;
	Sun, 25 Oct 2026 02:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA401F01825;
	Sun, 25 Oct 2026 02:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792894883;
	bh=tk1nNKvu4gh+/6cQpDYde1nK+SUWzRQlVwuGvyxxZfc=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=OSka3LFLmkiQLqEa70/pTPQS9idWYgbeWk/LwcTeJ35OvI+2DknedSsgSj1VD6DP+
	 8WTrtbdgwG4TlzkuQmQV4fhpLk7/tgW2c8AFM5YpmbqM4SzEYQLDs68Ea2jOecQjse
	 YIymUt3ygNuxu6M3+glYkMqwOncXIZGcR17WvKaDFnb523mKiuAxYQWHBoPXmQuXgb
	 Af9Q6csQyf5AnzEX6rndObQsxAEIXhnt8vz9poR5suZo6DRBK7hCzTCG0bN5xchi4T
	 wjZCJzSHM3+OqVrKIoqfjFJE8aQzbE5qxiNTQswDSSRzpAzZOGCFbNi3EJipYx7ph7
	 dOqtTXu00gAzg==
Message-ID: <22cd38be-5f6e-45e6-8042-9ad091089192@kernel.org>
Date: Sun, 25 Oct 2026 10:21:20 +0800
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: chao@kernel.org, LKML <linux-kernel@vger.kernel.org>,
 YoungWoo Rim <xsapiens75@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] erofs: hold real inodes for shared files
To: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
References: <20261024192028.53932-1-xiang@kernel.org>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20261024192028.53932-1-xiang@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/25/26 03:20, Gao Xiang wrote:
> EROFS page cache sharing uses shared inodes. However, a mmaped VMA
> keeps the shared file even after the corresponding fd is closed, while
> currently the real inode is never held by any reference associated
> with the shared file.
> 
> As a result, the real inode could be evicted and removed from the
> shared inode's list while the page fault can still invoke on the
> shared inode's address space, which causes no candidate is
> successfully acquired by erofs_real_inode().
> 
> Fix this by simply keeping the original inode in the shared backing
> file's private data.
> 
> Also replace confusing "readinode"/"rf" names with "sf" (sharedfile)
> to unify the terms as well as nullify realinode in erofs_real_inode()
> to avoid returning an uninitialized pointer.
> 
> Fixes: 5ef3208e3be5 ("erofs: introduce the page cache share feature")
> Reported-by: YoungWoo Rim <xsapiens75@gmail.com>
> Closes: https://lore.kernel.org/r/atzSVuvqYKgmvDmO@MacBookPro
> Cc: stable@vger.kernel.org # 7.0+
> Signed-off-by: Gao Xiang (Docker) <xiang@kernel.org>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

