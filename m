Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082BC607188E
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 18:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BmHjhcH6
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jR5dm4NZ5z2xhS;
	Sat, 14 Nov 2026 05:39:40 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794595180;
	cv=none; b=Fcy2I0dEYsi1dSGa/OcALsUHxIhENdiCHj3qC3JC0AAZw2aOZ0KVN3mJn8pIdbslYamz7Beb4RhQn4F+xg8uAC+8mE+Xz3k+X+CPIdw9Ipac4n0ZqdyzcycZDJAW3gJ6mK1m9J8epXBBJhiEfmx822joEa6gsiR4eR+9zJxPNGYqLF+gcOrlK2ImzUmynAOM2DDgl7hmQueLF4TbORpWq3TtDGzmgnhg+03GGYNQu5REr4b9bfMwdM4X+tjHY9ETUnCxJnjgfSWq1kUAj9hi6sNidNYHqgf9p5zxwutYECMlWB2ljUOpg84anhV2/VFvuaee7HWd2UcMn/YtvsgeSw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794595180; c=relaxed/relaxed;
	bh=GKkUaPjQ9HSzLxoN+bG5qq5nVAC+gnIY9tY/xC5NK/w=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=oNAqYGgmkoMGFpbcx9v5ky2luDMUf2zCY5IvEa3FmyRAsPpDU0h38FA7ATbuK1YW1Km+3cMN8hJZxfW65C6dyRiwrNuOqXAyGr4hBlGOAh5rd95tL6BLWEYpQqt7wjdfimcBekyitKxkSBpm/Hi47NlyVUeJL4IIZhQItoo8mJSuE631WGsMZm/NsSJ6FfVxgbqTTPnas25aQ7LJ3fyYMp5eQblefvGarhXlDax1LJWV5k8gdWyX/ISaZD9KZoDl5edi9vzZh3c2aJToBW8sCVXzAceZYOS8fKmRqGoVtiSvHeJIJIIjhRNGEQWtjJADdl+ky3F1i6OMZgHkbLNf3A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BmHjhcH6; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BmHjhcH6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jR5dl6f8Mz2xg9
	for <linux-erofs@lists.ozlabs.org>; Sat, 14 Nov 2026 05:39:39 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C9EE7615E4;
	Fri, 13 Nov 2026 18:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825151F000C5;
	Fri, 13 Nov 2026 18:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794595176;
	bh=GKkUaPjQ9HSzLxoN+bG5qq5nVAC+gnIY9tY/xC5NK/w=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=BmHjhcH6TeFUyYov3GX1U2GnMc+q5WbxbFGB2usDXgoFKGVeKBh4t5qwUfHVe2qbQ
	 WMGwYa92xwygNHcyaRNrPHrEGaJYC3asZo5W4B2f9daj3M+UK5nh6wsK5FJECJjSEN
	 Cr5aGrYLXgBW4CbwJm6JK6Hrqx+qipB1DAstEAjvxRlOtvsf5c9KE5CBDgAzfM7nNo
	 K7UNBcT79d+A/4gvACtz5LvCHn9OV5BWdvD6dqqIK7rcvu30NTIHPXN6YWjdbF5pwW
	 UmwRkdji0zNIHNlFIghcZAIAHWqS1LAxliFycv8i+B93RWkn/VWZ25aWFGfNsV4Y03
	 px4M9jj3OtIUQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 77598392E998;
	Fri, 13 Nov 2026 18:39:36 +0000 (UTC)
Subject: Re: [GIT PULL] erofs fixes for 7.4-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <avYqFWIxinR9JB0O@MacBookPro.fritz.box>
References: <avYqFWIxinR9JB0O@MacBookPro.fritz.box>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <avYqFWIxinR9JB0O@MacBookPro.fritz.box>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.4-rc3-fixes
X-PR-Tracked-Commit-Id: 7906eac042a4d6facd3b2dcebfe7179fedfcf1f2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b970ee43be13fc45851e957469807cac049c10ce
Message-Id: <179459517518.1691752.5818346831969815186.pr-tracker-bot@kernel.org>
Date: Fri, 13 Nov 2026 18:39:35 +0000
To: Gao Xiang <xiang@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>, Daejun Park <daejun7.park@samsung.com>, Zhan Xusheng <zhanxusheng@xiaomi.com>, Chao Yu <chao@kernel.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
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

The pull request you sent on Thu, 12 Nov 2026 22:05:25 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.4-rc3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b970ee43be13fc45851e957469807cac049c10ce

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

