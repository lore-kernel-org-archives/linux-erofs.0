Return-Path: <linux-erofs+bounces-4343-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC2A5C61DBD
	for <linux-erofs@archiver.kernel.org>; Tue, 25 Aug 2026 19:51:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hTz1R3h3Sz2xVq;
	Wed, 26 Aug 2026 05:51:23 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787687483;
	cv=none; b=g8B1CDZigVYFSwRJLvmxJbz7zAbTzZJU10eJnsMqRklYABXt2Yu+1UnGuDRFYfm/LKXoqGsDpgCYneDdzu73L8NlrzItqHN4H+6WPkmYGiCROPE3iCK3qLPwbijDJ1xPa2scvMUxCx89DK5GrPaxGB50u8eWj2w+jErvE4YdMbQW4cHpQFsUNdUu89ycWiQWtCHw9n28AfpNaYqC2QcT8j6q1xh/jI8TgYHWCkBTAMtUYeZ1B485qwNiEj9dn3gX5m/SfkYwthC8ZSq2WnxVBidoMDXrMzLXHphu1bO0q6lm2pO/EwKKVjb/3YKB46qgxcnPQ+GAB0UYE5uezh29HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787687483; c=relaxed/relaxed;
	bh=cPXh9hOUGxjmkOqhvb1OeFlRhFjt4w6i0DUulVzL62U=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=MbATc5Ow8hTGc7QB//qMoRWwwxMu+Jh2CU/K1JmQcD0dSE0k+bNFSNKZ/WUJAq/2ZIcOreo7JbXFgHUxElJZf/VFOuO9Yin0fDjv9XfHhXoFjaNuLnI3Tc7Y1lId1j2+RYCarqJSWeAqr2TqDz5e4Ug3Q/R5FqsT3daWjPRMvZT1llW9FjdnP9RSylC65Kvbf4OorY7Lnu3H3FhzkQy51+MV5sG5+30T52wKYvOXJxgr8yqF7fVAGEBx1dsyfODKycgC5u5kS7a9dZteL0E+vSwAq+Pol6qjwaNMGdjYhTqaheqziRubUNL1nbsZEsyB2BxaQ/kD6dYmEpT/T5wZbg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jvqKNoTO; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jvqKNoTO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hTz1Q1MVYz2xKh
	for <linux-erofs@lists.ozlabs.org>; Wed, 26 Aug 2026 05:51:22 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 563D6601E9;
	Tue, 25 Aug 2026 19:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32111F01563;
	Tue, 25 Aug 2026 19:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787687477;
	bh=cPXh9hOUGxjmkOqhvb1OeFlRhFjt4w6i0DUulVzL62U=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=jvqKNoTOYeB2lfWrF7u3k5jn8tErsNZFaQctbGtNZQA5wjhrUROv4ZGJcQyIBqFfb
	 a6ckxjGhcX7qYpt9gcRU2QYT113fTKdsFF/vjs/96HYYvm4ud0ecOMU3CoFwhnSVwX
	 kXvQmhGiRQl3kiF+qymLjffQtGsRRoOc+DUgDOfL53KQOTqVObEDJntzmTnWA+K9OF
	 enizVPFoVysz2dDj+yxZxrWsy8LTg5eI7wXND6k21gTmt3h4uSxmmO7H3hAbfvHDSP
	 p5rTuGbWOvifpTKwKXAn9Y7Kdwh9t3Wk+iIaGO0wtMl9b5HlF4U6zIKaoayDeEWOfC
	 sCi5ky986osvA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ED51D39253CE;
	Tue, 25 Aug 2026 19:50:25 +0000 (UTC)
Subject: Re: [GIT PULL] erofs more updates for 7.3-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <ao3ALZVbrWYuY6nw@192.168.5.19>
References: <ao3ALZVbrWYuY6nw@192.168.5.19>
X-PR-Tracked-List-Id: <linux-erofs.lists.ozlabs.org>
X-PR-Tracked-Message-Id: <ao3ALZVbrWYuY6nw@192.168.5.19>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.3-rc1-2
X-PR-Tracked-Commit-Id: a7d28aa0e9b2c983b915d091f9596f0e3b253355
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 73ae59e975966d24e32926247ddb45a537ebe184
Message-Id: <178768742469.4034242.10689508799041723150.pr-tracker-bot@kernel.org>
Date: Tue, 25 Aug 2026 19:50:24 +0000
To: Gao Xiang <xiang@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>, Geert Uytterhoeven <geert+renesas@glider.be>, Jingbo Xu <jefflexu@linux.alibaba.com>, Zhan Xusheng <zhanxusheng@xiaomi.com>, Nikhil Gurudasani <nikhilgurudasani314@gmail.com>, Chao Yu <chao@kernel.org>
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

The pull request you sent on Wed, 26 Aug 2026 00:17:49 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.3-rc1-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/73ae59e975966d24e32926247ddb45a537ebe184

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

