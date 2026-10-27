Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFCD606A320
	for <linux-erofs@archiver.kernel.org>; Tue, 27 Oct 2026 19:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b9TkdTD4
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jDgYx0sZ2z2yTH;
	Wed, 28 Oct 2026 06:30:13 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793129413;
	cv=none; b=VS5bZNTyc7V0WUSBY/vMyAXiWQ2+RZqss5VsbSud+w4ABWSwRIjM8oK2fz+oCYsVJrywBqrfPOFbqUscBEQl3iq60XIytlkDWjtRwkNI7DW2zakCl1o38jfTeZeOG2mHFKA4A4nKZ30+xPkKWbs2shG/OY3uu1XapTwwhkk3FwQvZ/fhUkvlvpQbkYTgrWZU44z4F4IdKuBIGU5ySt+z6C94EejG409eZFiFT8iR0Svab6Yup+TfBaVjBqcmSu7fLNsJ2k0enC4U0x8N1zy4Q7w0ir2HJZKDVG81gF36V9u1uJ9ka/dKpEvkDczXw1o5mrehNDIG24q/liRhGoYrGA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793129413; c=relaxed/relaxed;
	bh=uC7PG3x9TMielGTexzJGR5TIZiJxo92cq9xXopeL92o=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=NyrBVQSkplRe3C1vgDpnKmny/Hv3T3hX1EMsFhy6iDpoeomhjL/9fQ8HZ4qTqx69PuR2BXTTrmfCSiFyJZae7XevZBvi9AIpy+KLd0kick+Wxp7PNd+x4e4gMAzUW+5ZC7Tl5XCTxnCWoSM6lH+hxd8mIKpTQpoZsVzZV0Fiki05WBlia8U6qYCGlm4aupYJDBNw63ol/nYYubS1QefvzxiR2HS4uRc0bIGEpsz0DjBhLheDHo5ipi8UwWkKKAY3MTwZiYFFYi+O2EkMAfFarVUUAZmG3MkN0mCqSDxYTiXXSA4nS/7j6qmgJADNx3FcUQ9+QKcroNKCq9FSIfJGQw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b9TkdTD4; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b9TkdTD4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jDgYv4CMNz2xSZ
	for <linux-erofs@lists.ozlabs.org>; Wed, 28 Oct 2026 06:30:11 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E83DA4120B;
	Tue, 27 Oct 2026 19:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96FF1F01825;
	Tue, 27 Oct 2026 19:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793129408;
	bh=uC7PG3x9TMielGTexzJGR5TIZiJxo92cq9xXopeL92o=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=b9TkdTD4QujmEBIa/COcTUudd00KDtMibujtXgT4eCUxPzt/JEH3r0JwUUOtWciqK
	 bIXqDgRGtyfqxKkLyzUHfePhDiIc5BaTwtJiA7PKWrtVUbqE/DlP7hOJWQ7BGym5bV
	 dxXrn4NENeXVTJZmYYGFEoWarSEBZFc5zo4aBB+ohULuLXQV+vqqgSA605jC172kWu
	 gPUOYP1biHBTNeuujJ5OT8bu/qGFEJVvdGokH/m7fEv3BxJ+sBckPjGpB8pxpLooAz
	 Qft0Tf9RuEa/X1KadYHfBFjH+YvphyG5KwNXlRNW+8YVJiRY6kPbVUwCsKYdXOoZNQ
	 o6V8gAdHP/rBg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BE7FE3AA9F47;
	Tue, 27 Oct 2026 19:30:08 +0000 (UTC)
Subject: Re: [GIT PULL] erofs fixes for 7.4-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <auDf-xw7n159FvUS@MacBookPro>
References: <auDf-xw7n159FvUS@MacBookPro>
X-PR-Tracked-List-Id: <linux-erofs.lists.ozlabs.org>
X-PR-Tracked-Message-Id: <auDf-xw7n159FvUS@MacBookPro>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.4-rc1-2
X-PR-Tracked-Commit-Id: 209108a5456171ab430e25b54b2dfe083455bfb6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 83f32c773255720a661aa45d83e36278135f23f5
Message-Id: <179312940732.284542.14864597717952963666.pr-tracker-bot@kernel.org>
Date: Tue, 27 Oct 2026 19:30:07 +0000
To: Gao Xiang <xiang@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>, Zhan Xusheng <zhanxusheng@xiaomi.com>, Hengyu Liang <hengyul@cs.unc.edu>, Chao Yu <chao@kernel.org>
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

The pull request you sent on Tue, 27 Oct 2026 18:31:39 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.4-rc1-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/83f32c773255720a661aa45d83e36278135f23f5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

