Return-Path: <linux-erofs+bounces-4558-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22A81C88E6E
	for <linux-erofs@archiver.kernel.org>; Mon, 14 Sep 2026 15:31:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hk8JL4VRCz2yjw;
	Tue, 15 Sep 2026 01:31:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789399890;
	cv=none; b=BKjlwX7WhcPWSawQXSEYBjNficJAedKAVKHBCMQQ7mdrENLN5ECnA2yk5MmqEFwKSPJ48r0X4+jBoyANXzkj8air9SWX7LdDrqDsSXloC7KX6MxR0Vhng8Y/Qe+/eyu9ganbcLrKD+acH42qGB0To3G0Xt05DO9hjtfJyIm3DuU7RNpWjD9Sb4vYZLYtJOrg3LDj14zcp5UkKT2A6IB5Jsa8leYV3hPS5sNSIKbCkHHASlbtRPTWZZrhq8RdelkH2DVttMC8olWcpT0kaKsn31BrkSvnTJTnRximmwFs2un87iC6jPk93qb3ztu0HDEyWfvx/pQMgxa9pAJGkHrXBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789399890; c=relaxed/relaxed;
	bh=nR/vh4GvI0WOU5I3SDjzgrYVoTA8r4/N125W3zwVcoM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=VEmxdZg4uj18hUoIzN2DBCoAHd7XV6F/IBYEIvqsbbgXKJ70wxiOEMDo/gyW6xXiMFiU3OQCozcVSvQ1w77ybr9AzYrj8adbllFr2wKvNXgp4sBcu1AiohaY9mjruePBZ/05fS8DD0orIRhIcRgKgR+Ja8LkywB3bc1to4qaYk/0TFkpKIGQt7lgFQhoTuFPchHWJuCFcZR48Kl4XRlkZ2OfRes9+OLNKF2jtaH0I89Vn00NIUKGDW6/24QPxzM7kOY22HSJDj1IncphrG3b48uFztxxMuHaJRT6lADximBuviK0xoRC2vAwwtP7ZXe1na+OTgPrRQcZKwo3DxfT9g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RbCEKtn4; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=patchwork-bot+f2fs@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RbCEKtn4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=patchwork-bot+f2fs@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hk8JF26rFz2y7Y
	for <linux-erofs@lists.ozlabs.org>; Tue, 15 Sep 2026 01:31:25 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 953F9408EA;
	Mon, 14 Sep 2026 15:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F361F0089A;
	Mon, 14 Sep 2026 15:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789399883;
	bh=nR/vh4GvI0WOU5I3SDjzgrYVoTA8r4/N125W3zwVcoM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=RbCEKtn4AO+w1y1Nm4+9OPjd3F5HeNMHAg3uez+4FdxFCGDSSpv7EiKf+nOYlAqRD
	 WpbEgLLqAW4/l8pXzRAprjeTjPg5iYhCGnBEarYYppZgnkrHtBmnFS9mupbuYxw5uF
	 9IaiI70goJcN/QHzRT88UUSpAI4Re7c2DETfrByKeR3s4TjTlq6nG8lVpXAeCBJkvv
	 0JK4xXezKzgYlQ+Oc3bwKs3QN943NILxYGwTYwEDkh+jk8qAJukkZVAb2U57/OORtM
	 maeohl2NdOmJIEX01jxCO7utzNVfC1W0jyXsjrJ+AH6xFXa9Zfjke3MaE5gkTOu/bL
	 U9AI6BB36tibg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D092A3924A79;
	Mon, 14 Sep 2026 15:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
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
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH v4 00/16] Remove PG_private by using
 page/folio->private checks instead
From: patchwork-bot+f2fs@kernel.org
Message-Id: 
 <178939981839.647967.9641554131485178993.git-patchwork-notify@kernel.org>
Date: Mon, 14 Sep 2026 15:30:18 +0000
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
In-Reply-To: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
To: Zi Yan <ziy@nvidia.com>
Cc: david@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 muchun.song@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, hannes@cmpxchg.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, kasong@tencent.com, mark.rutland@arm.com,
 irogers@google.com, jack@suse.cz, linux-doc@vger.kernel.org,
 amarkuze@redhat.com, peterz@infradead.org, kexec@lists.infradead.org,
 dave.hansen@linux.intel.com, ruirui.yang@linux.dev, adrian.hunter@intel.com,
 linux-mm@kvack.org, hongbohbli@tencent.com, hpa@zytor.com,
 guochunhai@vivo.com, skhan@linuxfoundation.org, tz2294@columbia.edu,
 baoquan.he@linux.dev, matthew.brost@intel.com, anna@kernel.org,
 sstabellini@kernel.org, zbestahu@gmail.com, rakie.kim@sk.com,
 minchan@kernel.org, richard@nod.at, x86@kernel.org,
 ceph-devel@vger.kernel.org, ebiggers@kernel.org,
 alexander.shishkin@linux.intel.com, mingo@redhat.com, slava@dubeyko.com,
 weixugc@google.com, yukuai@fygo.io, xen-devel@lists.xenproject.org,
 xiang@kernel.org, magiclinan@didiglobal.com, mhiramat@kernel.org,
 joshua.hahnjy@gmail.com, xiao@kernel.org, byungchul@sk.com,
 james.clark@linaro.org, acme@kernel.org, linux-raid@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, bp@alien8.de, rostedt@goodmis.org,
 linux-mtd@lists.infradead.org, axelrasmussen@google.com,
 jefflexu@linux.alibaba.com, namhyung@kernel.org, jaegeuk@kernel.org,
 yuanchu@google.com, idryomov@gmail.com, osalvador@suse.de, jgross@suse.com,
 pratyush@kernel.org, linux-nfs@vger.kernel.org, tytso@mit.edu,
 oleksandr_tyshchenko@epam.com, song@kernel.org, corbet@lwn.net,
 pasha.tatashin@soleen.com, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-perf-users@vger.kernel.org,
 senozhatsky@chromium.org, tglx@kernel.org, jolsa@kernel.org,
 linux-fsdevel@vger.kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 trondmy@kernel.org

Hello:

This series was applied to jaegeuk/f2fs.git (dev)
by Jaegeuk Kim <jaegeuk@kernel.org>:

On Sun, 13 Sep 2026 22:23:58 -0400 you wrote:
> Hi all,
> 
> This patchset removes PG_private to make space for upcoming PG_folio for
> identifying pages from a folio (more details in Note below). Instead of
> checking PG_private, all code is changed to check page/folio->private !=
> NULL instead.
> 
> [...]

Here is the summary with links:
  - [f2fs-dev,v4,06/16] f2fs: stop using PG_private
    https://git.kernel.org/jaegeuk/f2fs/c/60105162524e
  - [f2fs-dev,v4,07/16] f2fs: convert the ->private flag helpers to folio-only
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



