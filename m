Return-Path: <linux-erofs+bounces-4691-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DFB9CA9EC5
	for <linux-erofs@archiver.kernel.org>; Sat, 10 Oct 2026 23:44:41 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j2L1M1RQHz30gC;
	Sun, 11 Oct 2026 10:44:39 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791675879;
	cv=none; b=Y6/zmuKB8Fmkt6FVlPj3kKIyH6vNGLSU/5mSvrnicJ0sRPE2qb3vdoJmvVd2vmtTxEgn3SfkhDqMfiNzyEx2sSDdWLzZY94yHi/iYudiwtsA/wx0UiHvcAo8HxjpsCM+JfXdvuWAAdYKSq+P+BrUt2WQVDg2sx/F2uGW1qwfXEds6DRYun65mm6l8yY4PxpVJqVznLxjYEmo4MTHn/H/NKjYex8XpObLuF56rXfgvND5fFgf7pUovdU3+Son3+PcG/5bYuWgzTqztGgQ7SvKo0W0hCcJvrtv4J8qn+ItW7Ub/4bfEVtsMveps8Be1xTwA8Rks4/8o5BUkrmt5fFeQg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791675879; c=relaxed/relaxed;
	bh=eeRFFWYz3sJFveuLFv6B8qZclKQNU1SgYyPsR1Nr5ro=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BljdiOMzEPPLPeaNQlzf3nZD5P79yWYfA+BDLmvQmu+a6c821fzNGfagpWX9T/UotKLRDxZLRVSvBAOyK0iamghe33l3ElTS3aKHXZWcDuTuJ91vjWoa8RLyZt7ILbp5UHkPlQ3dbx79uIK3Xas46yD5s5MEPBi3oIHC7CsNh5Qw6qXjkhRCWaqBkk1HxOof9IniupmfE59isiLosotH0lYXpei1dE3tW8iARKvK+WcnF4/6JnBrtwfN5xg1R+pPFqs72yUID3yIu0e2jUPoJJAQCsG78N2eWvaKX/IFxhL2iJj++0rPIppi41iVX7jgyVj790yMVjJQtveq2KCVgA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IXLQ/Jp8; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IXLQ/Jp8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j2L1L07qvz2yNj
	for <linux-erofs@lists.ozlabs.org>; Sun, 11 Oct 2026 10:44:37 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4290C600AA
	for <linux-erofs@lists.ozlabs.org>; Sat, 10 Oct 2026 23:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E181F000FF;
	Sat, 10 Oct 2026 23:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791675873;
	bh=eeRFFWYz3sJFveuLFv6B8qZclKQNU1SgYyPsR1Nr5ro=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=IXLQ/Jp8w9X6Z47qQisiQ7S4MYxB/bdFsz5yyg3fAAX+aCMKlqucqz8lkb3+bJVv1
	 HTaijcfrWyaj8fv5twf60mcdnJpM3wOVybjcBz6SpnCWq7rRDCltSRrd7hzy4zwJ2M
	 41aQ5xZUfdB8jA+L/jqqk3yPkHiCDWh9SOhrMzsbFqhrVEthIaDkxAWGG6iTJWdlC8
	 Wtt54yB4oo94OHtd26q/aNiZZc9iMAf1vxEQ1w3K9j2vb6HpERzckWfrzNMnAS1yMU
	 /hYUFO6Cf14zj1Sdk1LwSgaEHD6lqMyLdJl616Hk4N/zF5+guJHJk7RYwXM/hsB/QY
	 kumnqpPi9szpw==
Message-ID: <0b7f00ae-29ca-48e4-83f8-eec0213e3535@kernel.org>
Date: Sun, 11 Oct 2026 07:44:31 +0800
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
Cc: chao@kernel.org, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: erofs: add dev branch to git tree entry
To: xiang@kernel.org
References: <20261010070623.1766952-1-chao@kernel.org>
 <asqt-vM6LOPyqz_p@XiangdeMacBook-Pro.local>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <asqt-vM6LOPyqz_p@XiangdeMacBook-Pro.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/11/26 05:28, Gao Xiang wrote:
> On Sat, Oct 10, 2026 at 03:06:23PM +0800, Chao Yu wrote:
>> From: Chao Yu <chao@kernel.org>
>>
>> The EROFS entry lists the git tree without a branch, so tools that
>> derive a baseline from MAINTAINERS, e.g. sashiko, fall back to the
>> remote HEAD, which points to master. master only moves at -rc1, so
>> series developed against the dev branch fail to apply there.
>>
>> Name the dev branch explicitly, where erofs patches are queued.
>>
>> Signed-off-by: Chao Yu <chao@kernel.org>
> 
> Acked-by: Gao Xiang <xiang@kernel.org>
> 
> 
> Hi Chao,
> 
> BTW, could we request sashiko folks adding erofs mailing list
> to their review list as well?
> 
> Since some patch could not Cc LKML or fsdevel, but I guess
> we need them to be reviewed by sashiko too.

Xiang,

Agreed, let me submit a patch for erofs.

Note that by default it's mute (it won't reply review comment back to anyone), so
author or reviewer needs to check comments from sashiko in its UI (https://sashiko.dev/),
but we can change the config if we want to receive review email from sashiko.

Thanks,

> 
> Thanks,
> Gao Xiang


