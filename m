Return-Path: <linux-erofs+bounces-4747-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9105DCC6B2A
	for <linux-erofs@archiver.kernel.org>; Sat, 17 Oct 2026 07:12:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j6CgJ5LX2z2y7W;
	Sat, 17 Oct 2026 18:12:28 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792221148;
	cv=none; b=PDZ7MLE2QlEnOm6TDe6m+ORSePkOJT1uAOLGU+pJ6rgku6SVAag0ly5Wg6L0JaDO1Kf8MLS5b+yNDWk/dHBo9Te3alxq7cEArlChBN2cnyy/ghpVwGMmzuZwcnYjMKUoL8LkvcKk35QhHS9kTXFGWd6pLiJYnwpLQCdrYylyvdTp7YGe2qraTmMn63Exs4QZdzWCdAkuGyqJF5jEWZ+DiUkxHAv2WihdJHtiBoICdCg/Ss9Ax78//hbzWmeEpuJi8DNtwkgKiaxO8WYqe/vWPsasnO9mR98Mz6+9V/EB/xTKqlv5PXeozPILbqsGUsBR9QaSzdHjKlQjAwExUhjphg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792221148; c=relaxed/relaxed;
	bh=pawdgz1PFW+s1/dBQACbZ1G5t/EZzaKaoBS1ynYJbZA=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kM+qrIF78JmPT0WurSllJVUlampyErOKCuxliBoDCe7RWrcHxz+g064MFJYxInsxxlB52dt9ull9nCtVOp6kzn5d/RWBwwI1GmnhngswgJ7NfWWa261f46/5vqdqT85UXvV6FsMbVcOsl0NRnQ/DVrcpQMgav8PRq/5K/2FZKOqalDDtlhncUEW1TZYW0ik0gORjhnDboif6xtqhzpe2e4Uocx35QNuTODQXLGH1fHYoecOE1raGcEwkEBs51RqP+bSnKux3lzu2PPDXXnPLkwpuqrbaGbKHKq6Bb1bT5jZZTkShkcMdZEZnOhyYamxF+pfZj2wDrp3B4SxmWl29zA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X01Rnn/U; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X01Rnn/U;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j6CgH5CF9z2y2J
	for <linux-erofs@lists.ozlabs.org>; Sat, 17 Oct 2026 18:12:27 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB9346022E
	for <linux-erofs@lists.ozlabs.org>; Sat, 17 Oct 2026 07:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAD21F000C4;
	Sat, 17 Oct 2026 07:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792221144;
	bh=pawdgz1PFW+s1/dBQACbZ1G5t/EZzaKaoBS1ynYJbZA=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=X01Rnn/UjdCmUIIvN1zKJ1nPfQV5THE6+AbDItJM3Wzr/GwsRuvK5y158kSRSb/31
	 gPBwaSw5VhObaZfQySP3Pi9L5uMLi3oosy1GUs0SMWHFr2WXrJTfZdoNuBLHREWzSP
	 RFgJ4EtNNrgdV459DBFKtADe21cgAy5mywmcBJZq5Oh9+o/GWogS1cSlvpfVJ/xeE2
	 Snmh2B4wrM9RIPBNyc0XnGUc+SqWQTV9FHTIfD3bQVqS1cFbJUL5l3TgODn5mKR406
	 LAzYcQe759EFzgglfpo+LENEZK2y2efRxxX92eOr5KWxKXcxUYQJXDp9JHS3gHAIpT
	 X8PiKVH+diuaw==
Message-ID: <b0399575-ba61-4778-a8b3-aec32090ac5d@kernel.org>
Date: Sat, 17 Oct 2026 15:12:21 +0800
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
Cc: chao@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 RESEND] erofs: enable iomap for file-backed mounts on
 unencoded inodes
To: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
References: <20261017002758.52193-1-xiang@kernel.org>
 <20261017023352.67568-1-xiang@kernel.org>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20261017023352.67568-1-xiang@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/26 10:33, Gao Xiang wrote:
> Iomap supports non-bdev I/O through fs-provided callbacks since
> commit b2f35ac4146d ("iomap: add caller-provided callbacks for read
> and readahead"), making it suitable for file-backed mounts on unencoded
> inodes.
> 
> Enable iomap for this case to support sub-folio buffered I/Os on
> file-backed mounts and simplify the codebase.
> 
> Signed-off-by: Gao Xiang (Docker) <xiang@kernel.org>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

