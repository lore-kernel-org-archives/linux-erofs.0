Return-Path: <linux-erofs+bounces-4731-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6F11CC6B03
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Oct 2026 11:22:38 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3sPn06kyz3brV;
	Tue, 13 Oct 2026 22:22:37 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791890556;
	cv=none; b=W6N1oQxlkwwNYBdWfe0S4JuqujfhT5ve5Zwooh3vItUAUMCakmFklDdb8A5+69GTynt5yzD2IkywHsIBFPQ4PRyCkvNY622WH/E4/yGAU3q/VZJD32fSxUQGpyCBsvggYNvaNbCVoUUsAVHxmqhIjKu7VC16oK4KTb2aIbqFp2O0Zb4L9vk98DAuMYUCV7qteDoVylYw3Cd7ozTeLhEfZfv1EpzN0xQbcVPO383AAzCV2yNxJK1CFtEDCmUloZoTDznxkwGZHGdG7tPjRDjm3y5n51supMCxc0KD/NcIYvuL4yF/v6Ozq1v6uEHTh3KSGDjKa56PsTlFWO9J6rLMhA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791890556; c=relaxed/relaxed;
	bh=mtpgXdzPgdHugzEFbyFxgZF7cgPiieuUZpPezpahctY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CqaNUNIlO+bf/1vlcMgURMK2Cj1dK4skBs+2oN+qDfB6HQZYh1wiQJcRj7a36fPPh2SOXdMH2eDitYgZDX2kTbOuVPi0xCJVcnRJ+/LWtgf8YfPLHkXP65iZjp/Br/82QflEe/E0C8yFKmwMTpjUwsm2UgUPs/DXw3ASt6YQLykSfs84aCQLGLe9KUhwO1Yd/3xD9U2hWQ7SSjoJJUTZ+h3FTWGEoNaj9qxcOctrIhKN7SJDZnv5qW5F2njI4ozWWRKkdDaVAWxJV7/vl+HO80dNxasEmjusuq4WZfusboLM9wop536A6f4B3sceQJud1WpwlSv4/KsfoLbtWXrd3A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PZpNke+k; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PZpNke+k;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3sPm2P4Kz3br2
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 22:22:36 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 08B3360A5E;
	Tue, 13 Oct 2026 11:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C9A1F00899;
	Tue, 13 Oct 2026 11:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791890553;
	bh=mtpgXdzPgdHugzEFbyFxgZF7cgPiieuUZpPezpahctY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PZpNke+ky9Mf0deSxyKCg4UUJbgy4KDId6WcZbWS72Gw5uU76oskxmdDSQvuFJF+Y
	 9iXh3+rKMIjDZK1kud0aBVXddZVH0FFcHyb+KmcFJfZKeRMLkRnhM6UG9xY/G5H/kM
	 TLPwGprXCFampSpBhxQACcJXsYhhl/+qaKTyf9qZKYl4h/G9QMolGRahO8jYj0mEXA
	 CP2l7avckvUe4j1+tIcK3IVjRmJsD5vJ4Qo+JrNj8q9PmTzpm8CwCrQNaAV19lwF0u
	 4dYr+ct2hiu0PYGUJFpKcguC0o3YExmBHFxMMmZ6HLipfZq42qTvZ9znoueyjfY9ta
	 N6AK75rGaod+g==
Date: Tue, 13 Oct 2026 13:22:28 +0200
From: Gao Xiang <xiang@kernel.org>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Gao Xiang <xiang@kernel.org>, Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
	linux-erofs@lists.ozlabs.org
Subject: Re: Patch "erofs: remove fscache backend entirely" has been added to
 the 6.18-stable tree
Message-ID: <as4UdEWzIr2O_M31@MacBookPro>
Mail-Followup-To: Michael Bommarito <michael.bommarito@gmail.com>,
	Gao Xiang <xiang@kernel.org>, Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
	linux-erofs@lists.ozlabs.org
References: <20261013020044.2527207-1-sashal@kernel.org>
 <as3drCZLoTUPS_oC@XiangdeMacBook-Pro.local>
 <20261013111011.2814836-1-michael.bommarito@gmail.com>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261013111011.2814836-1-michael.bommarito@gmail.com>

Hi Michael,

On Tue, Oct 13, 2026 at 07:10:11AM -0400, Michael Bommarito wrote:
> For context, the original bug I found can hit both 100% deterministic
> local DoS and a textbook UAF on kmalloc-128 slab that requires timing,
> but I don't think an LPE can be ruled out...
> 
> Since it is reachable by an ordinary read() on Nydus or others that
> enabled ondemand in Kconfig, I think it is worth thinking about what to
> do for all of the pre-deprecation users (even if it's just comms).
> 
> I would defer to Gao, but I sent a minimal fix in June that can
> close the UAF without any other breaking changes.

Do you mean this one?
https://lore.kernel.org/r/20260619135800.1594811-1-michael.bommarito@gmail.com

As I requested months ago, could you please provide a reproducer first
so I can play with your patch.

If you provide a minimal reproducer, of course we could address this in
the stable kernels.

Thanks,
Gao Xiang

> 
> Thanks,
> Michael Bommarito
> 

