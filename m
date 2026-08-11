Return-Path: <linux-erofs+bounces-4193-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74CFCC5CFCF
	for <linux-erofs@archiver.kernel.org>; Tue, 11 Aug 2026 11:00:49 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hK7vg3yMgz2yyJ;
	Tue, 11 Aug 2026 21:00:47 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786446047;
	cv=none; b=FjpfMo7FeKobuRBlLHcAb2cThivmgM8rxcppRLeC7WvMC5H9WYueYLFPd6KIFayH5wGSGa6GNos6WP3DH3R2M+7v6difLRPKRLeDqjUQkfxoXsrrT+yShinjU5vkZNLiqNyzStoMx429sB3tsPQcYJjR1Xk959ax9KiOZf8v50xlassH+zYlPxuRUVSpqp2T57/u+sS9NcqjLj01S0RgQgmh5t8g6nd7XTFUAxAtM/6MVkEZ5jkZpjkKgiln2P6MH2eZspk/L7LSlukICRctR+o7Bf9Sjdt/7ot4KbzSDBcxfv13yPncLXfzryIXN8zJaKreMUULooLYUiO/YMZ2AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786446047; c=relaxed/relaxed;
	bh=7vWhnoDyViDukKyEBgtPiQ3wF3p2ShiE/R3R680ir5c=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=obZbPQDnd2uiVCuWaCYQWTrxn2I8lAWlD5vveH4HL7FIf6J+4daJv+0ympSwGGYmym2W0p8SSOVNzq3Zf1qfBIFzKbIXqhqvl+UHLFkoihpZPwbZ3SrbtkmOcgHAviAdPRirJlIFhEWgc5lf3VRDurQ3C/eDBQlWWgf2Bl4fI6MOW5YHYHenXVuKwY3HH3rEFkzgBtT4q87CKxaIcFTR2I2bMX0QBz6UMluz4oOak4PvNvbUke3hMhf9js80OpWmaJ4nR6Btaq/DpAPZbNJyUaK7r5obWknVPTdvhKxhAt7aA6BEOSIxMbIaAJ+DYLJsftCkJi+g6ZIKCW5gbzHNpg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YqFhBBDM; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YqFhBBDM;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hK7vf4rfLz2yvM
	for <linux-erofs@lists.ozlabs.org>; Tue, 11 Aug 2026 21:00:46 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A1A5416CF;
	Tue, 11 Aug 2026 11:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABE11F00A3A;
	Tue, 11 Aug 2026 11:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786446044;
	bh=7vWhnoDyViDukKyEBgtPiQ3wF3p2ShiE/R3R680ir5c=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=YqFhBBDM65COHqJxMDtIFUpvzJnIqMjh92Bf84/C1wn+G8pb0PsHoX/P0o86/87wa
	 5Mo4YDEGCaZIKtM3ko56MjqujNkXCevm8Qn9+ucUBO+ZLMjl+xbMDEqDJTk8ncj6FR
	 n8xrcBLbK+TJIOqMTTRJZdeiHdXTVWy/W/QvfwrM4Byyk0vMpHgm2EnSDXyD++sz76
	 WF3GSMKcEDieuh1a2xUZwEXsIIpZBHgmqgFKKUnuqbUq/89vwIoAqVPLMgIsgfNPq+
	 8YJGr4Ffijk4DHxCjukFRRHvAL1+TfvzKnCGhZPEQvEb8HMF+4yqhMlj19ffRb4D2S
	 aawArWQTqbJDA==
Message-ID: <5b0c0856-21de-4bbb-b211-d493329ba6fb@kernel.org>
Date: Tue, 11 Aug 2026 19:00:41 +0800
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
Cc: chao@kernel.org, LKML <linux-kernel@vger.kernel.org>,
 Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] erofs: use dedicated meta inodes for file-backed
 mounts
To: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
References: <20260811080852.29418-1-xiang@kernel.org>
 <20260811090717.29787-1-xiang@kernel.org>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260811090717.29787-1-xiang@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/11/26 17:07, Gao Xiang wrote:
> Currently, metadata access for file-backed mounts reuses the page cache
> of backing inodes directly.
> 
> Switch to per-sb dedicated pseudo inodes ("managed cache") for metadata
> access on file-backed mounts (although I still don't think it is
> necessary due to the EROFS immutable model). As the result, metadata
> cache won't use the page cache of backing inodes anymore.
> 
> The "managed cache" was originally used to cache physical compressed
> data according to the current cache strategy and I/O patterns; since
> file-backed mounts also need to access physical data for metadata
> access, it's natural to reuse the managed cache for this too, providing
> a unique inode for all physical data access.
> 
> Signed-off-by: Gao Xiang <xiang@kernel.org>
Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

