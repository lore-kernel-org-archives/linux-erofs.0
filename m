Return-Path: <linux-erofs+bounces-2835-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6090E103E190
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Mar 2026 14:54:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fbX0X0Lkjz2yk6;
	Thu, 19 Mar 2026 01:54:20 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773845660;
	cv=none; b=Yi5BoNKnysxDqXebTXagum6QQksyw/c66TtnT2jTg0lgwzGUg7J6DqXsdKq0eUSgnsUk1/ecHconoCNUo9c/l1RVcEWF7k2TV2PVTOiHa4JRkcSNMCc/dMIpMo/DHjVZIXW5z+7gFV9iONsxheWm1FaJqLAlXX/+IqdxsJUl11yrsc6ri1O/GAiT8SO2uaeQrUWS6y3AdptrPqcai3y7Y7QliID3KGYiFMJAi9Bz9tHmaEdOpOAVmiVZNSwFd4c/HjjzNob+km2v3DcRL9oVbRmFLZ4RN7iaEw88LkburK/Q5S+yKptH8hrOq73g24FzM+Iqz6yB59nCX7rDTy1klw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773845660; c=relaxed/relaxed;
	bh=3KzMabiC6Algyf1l9JeiiFmN9UBAfaxRH/IH0Kg6ii0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UdZYKw73ovXJ4N7+JZujjsbKykJmVgMyePhTeMdaXQGMb1Vp/qr3RoV08jtL0mzs7SddXSA/UnWpxVMqXtD+WmwqOvVuPRorlgVii8D8WZ7WOgDrpFQBNOClla6HEdLwexWUttyvHne6oRS15phOrFw260VvV8aP0J7KbysDo9zsjXug7vsSqvoK3k941Ss1mFukGrMyYvj2gZvowDHxjXFvPDInYJ7qzxlX4CDR1feGmxBNwrRHdxXhT3NWj+PmxUzOUh0fXRFJEMBIejZ5gTQlnV69jdgfuI/K361rwY5mNsBRAVrW/iEUMXVy7IfoUKbV9+AnFrCKYEpHACqZxA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=pe+acHwj; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=pe+acHwj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fbX0W0cRVz2yjp
	for <linux-erofs@lists.ozlabs.org>; Thu, 19 Mar 2026 01:54:19 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EBB9740DD3;
	Wed, 18 Mar 2026 14:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EAFC19421;
	Wed, 18 Mar 2026 14:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773845656;
	bh=bDJPbwojvkuFiXOovGzlPWqS46GSsoLEqXdJV2yFS4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pe+acHwj3r6od3RZ8JkSDXRmVAOBjvKZINlio6ddg1fzECfiLbwoSol/wuHySeuj/
	 eyW/kT2/V1KykUUsYFZCXfy38DKNZADYN/YxNJC+zW+ZANmy0ui6/Nuxw9hKEzHox4
	 qspAzhNwXB2iks5UjDnPHmEB3oH1DQQ6xz8j6R2yYpnB8Nuxq5Z9ZmwVZvsErLK2O5
	 cfFphMVPrfyNgi8IOTO5WFfkewnXH663i8K2QmZWiasLJpcRnO7Yl4xR+ooENI1HR2
	 +Ivi9BqGw+gptjTSe4h51ZWxhWp/ia4tWXJoTq+1JjAl2TjocNxKduLalf4ALlGnC0
	 TKXysCIBYXmcw==
Date: Wed, 18 Mar 2026 22:54:11 +0800
From: Gao Xiang <xiang@kernel.org>
To: Lucas Karpinski <lkarpinski@nvidia.com>
Cc: lasyaprathipati@gmail.com, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH v2] erofs-utils: lib: fix potential NULL pointer
 dereference in docker_config.c
Message-ID: <abq8f00vvrywkf7R@debian>
Mail-Followup-To: Lucas Karpinski <lkarpinski@nvidia.com>,
	lasyaprathipati@gmail.com, linux-erofs@lists.ozlabs.org
References: <20260316085300.19229-1-lasyaprathipati@gmail.com>
 <1b7a6e1c-e1f2-48cb-a947-7f5c7f949cea@nvidia.com>
 <6f2045fe-9ed2-462f-8a95-54575e75311e@nvidia.com>
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
In-Reply-To: <6f2045fe-9ed2-462f-8a95-54575e75311e@nvidia.com>


Hi Lucus,

On Wed, Mar 18, 2026 at 10:26:08AM -0400, Lucas Karpinski wrote:
> On 2026-03-18 10:06 a.m., Lucas Karpinski wrote:
> > On 2026-03-16 4:53 a.m., lasyaprathipati@gmail.com wrote:
> >> From: Sri Lasya <lasyaprathipati@gmail.com>
> >>
> >> ---
> >>  lib/remotes/docker_config.c | 4 +++-
> >>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/lib/remotes/docker_config.c b/lib/remotes/docker_config.c
> >> index b346ee8..6401c1b 100644
> >> --- a/lib/remotes/docker_config.c
> >> +++ b/lib/remotes/docker_config.c
> >> @@ -202,8 +202,10 @@ int erofs_docker_config_lookup(const char *registry,
> >>  		}
> >>  
> >>  		entry = json_object_iter_peek_value(&it);
> >> -                if (!entry)
> >> +                if (!entry) {
> >> +			json_object_iter_next(&it);
> >>  			continue;
> >> +		}
> >>  		if (json_object_object_get_ex(entry, "auth", &auth_field)) {
> >>  			b64 = json_object_get_string(auth_field);
> >>  			if (b64 && *b64) {
> > There's still a tab issue as Gao mentioned in v1. This looks like a diff
> > from your v1 to your v2 patch. Similarly, you also dropped your
> > Signed-Off and are now using a From.
> > 
> > Lastly, you submitted another patch just yesterday that includes this
> > change in addition to other changes. It is very difficult to follow what
> > you're doing.
> 
> One correction, no tab issue anymore.

Thanks for reply and help.

As you may noticed, this year EROFS became a GSOC organization,
so there are many new students sending patches and proposal
these days.

Of course, it's a good thing since we could get more new
developers. But one thing that I'm not quite sure if they are
really humans or AI-assisted bots, taking a simple example:

As you may noticed, this thread Cc an email <gaoxiang25@kernel.org>
which is never existed (my email is xiang@kernel.org or a very
very old gaoxiang25@huawei.com one but it never works for many
years since I changed my job many years ago.

also

Another thread I've seen <yifan.yfzhao@linux.dev>, which is
never existed either.
https://lore.kernel.org/r/CAGSu4WMGStFw7DzePCDW0JKM4DFeia4oj_U1PMDz=kG4hdLEaQ@mail.gmail.com

I'm not sure if they are AI hallucination or not, but they really
warns me that I should take those GSoC proposals more carefully.

Of course, those patches can be still valid, but I need to
review more carefully in case of potential random AI hallucination
or meaningless changes.

Thanks,
Gao Xiang


> 

