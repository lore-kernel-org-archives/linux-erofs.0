Return-Path: <linux-erofs+bounces-3518-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86651CD6E7B
	for <linux-erofs@archiver.kernel.org>; Fri,  5 Jun 2026 17:33:00 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gX7n644dYz2yN8;
	Sat, 06 Jun 2026 03:32:58 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1780680778;
	cv=none; b=Y3bEoMEXHmyyYJMNUIZX64oIQCvNyCaLHgQvU1uMc3ARakUVfA/hIsj0x0rWpF9ezwuadb37BNM0OJxUAuQ92xdGvI1719GiC9U1YFkpeWUy07dmDpVxD9JxhUOD6oCgIWVEHApyLbkFJupNWqhcdlhCup+GdzMtJlSzycHwQ88oruVDjRQX2OLT84ifgfrj+nBnfNqSARlu9CuZxIkSVBJ/rh/11IHGbRbvn+mgGPaosLcydF9Rg2x+ABCVlpwHedqmnHLLCL/gqvVQoxTuYrWE1rqkCmiIfRCWb8p6THHufvsNEgaXMI9vOQdQio9LoZ6uonFHWOI0K/ytMHjqaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1780680778; c=relaxed/relaxed;
	bh=jAzXvXviohgFyzfmPyEzqKnRxVZfMUvWgWHpMMjIoqw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=FCakcxoGjU2BMt0DX3+5SUKEYoFZE7pny3anaOBb7QzFZM8WoXBk3/URI7xV0rPJuTHntVo+WdNo2hjGs9h7TrH6xPFHN4sQ5gSuNmenLL7VGtehkLikWtYXIg3wAQh5ovZqxXr/S8EiGViPUU7NUUTCrGvqaO/Ys6T8Fr6voLulXCf6HadW57Cb5fJz5Eysf/PQhneC+/rgvtvskJXjSOWyAZh+jgqa6j4JbigqfBjNBzdwDx6hxrpId8mTmXrHPWM/d0QYGU/200Y5t5QxQ2ddIimcMTSlyXVYlF5kIEjr9b0pgQbrAwa6yyGoYF2xuHx05ZPSigKfCivNUwZDJQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nhU2lg8J; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nhU2lg8J;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gX7n54J1xz2xdb
	for <linux-erofs@lists.ozlabs.org>; Sat, 06 Jun 2026 03:32:57 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 65742437B8;
	Fri,  5 Jun 2026 17:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47ADE1F00898;
	Fri,  5 Jun 2026 17:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780680774;
	bh=jAzXvXviohgFyzfmPyEzqKnRxVZfMUvWgWHpMMjIoqw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=nhU2lg8JNUXb1ERmJqR/980N8zvEHupKMvIgVw5Bw7VqXlulZSUBLjdEWAVJsK35Z
	 sfl8LTl2QBQyPQ5WJdURCuBYXkfKUmzGkdtqCwJFEef5Cei7e7rhRj/PXMfMDa5B5s
	 YUUthvM1KWpv99W6iAJ44P/DxpwVqgbqfCM+S3dXCWQQATyYgB0A8TL448F+EccJyY
	 kh93IZroIM/7Nf8gYoUeYPlDoW9jichHImGc0SJhCVOKFEB4vTgxUpOmWhwx23zUmj
	 RS4N9KCDPDWPV7J3EgkuBan0JEgQphi3Z0mQwO3OcH/frMs83dP65Fc9m+x382Muap
	 zEafU2b1wXujg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0AF43930BAF;
	Fri,  5 Jun 2026 17:32:55 +0000 (UTC)
Subject: Re: [GIT PULL] erofs fixes for 7.1-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <aiIchc5EH5GPU-UW@debian>
References: <aiIchc5EH5GPU-UW@debian>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aiIchc5EH5GPU-UW@debian>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.1-rc7-fixes
X-PR-Tracked-Commit-Id: 27f2d085bd72abe4235689d34d8654cfc876d568
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2b389a573b76f4e3e1e17654eeaced3eb48c2972
Message-Id: <178068077436.3853150.2061686099781873998.pr-tracker-bot@kernel.org>
Date: Fri, 05 Jun 2026 17:32:54 +0000
To: Gao Xiang <xiang@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>, Chao Yu <chao@kernel.org>, Zhan Xusheng <zhanxusheng@xiaomi.com>, Jianan Huang <jnhuang95@gmail.com>
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

The pull request you sent on Fri, 5 Jun 2026 08:47:01 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.1-rc7-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2b389a573b76f4e3e1e17654eeaced3eb48c2972

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

