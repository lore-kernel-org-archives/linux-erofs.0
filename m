Return-Path: <linux-erofs+bounces-4471-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05CCEC624A4
	for <linux-erofs@archiver.kernel.org>; Thu,  3 Sep 2026 16:11:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hbPj86R0yz2y71;
	Fri, 04 Sep 2026 02:11:08 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788451868;
	cv=none; b=IRV5gYCZGSX5XgFk7ygrNmLtERTfPR2beawxPkMHp6pKmhSCJ5SeMWnsBjP5wnct2ILXm8lJU2u6ofPh2Mf3wDZ/5U5RLjsJIl3TAMxBE+j3HXgWzEHtF2TWV/9g5veR5egZBKfT4xaQZDsp2E0AEnxytjFvRnOFnIHVk5ghrFuLA+YIy5/ZWe9qVtQN4dURpWj8jKrbAtwRucZanwQZppJwj7AiV+4uO3AzubLdy0Io64WzIwaxTKs8bSd+TZcgflUR/9MxIKdfwxwukOYO8qzpAh/blVTwNx9dxhkBI5cv9UfINGmmbCZyJqy19SWQ0C4QfxOPLSgi3Zt3L8Uzug==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788451868; c=relaxed/relaxed;
	bh=0GGJyshhlAlKfjOpgr7j97Mh0m1+5qav5ykVgFpFUIA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=DUlpnWieT9jHmJVtK4daTgwlXTxt4i1CWSKlUV5cHPWM7gZJm+JkKDdCs0n8Tor34uVk1vgO2+SvhSKAk6NZlFpZnOFM/ArSBWqvE9DvuC+aIMdkPwFdxRwdQ2X6UsU55AILhSW5IlMF4sG8VmSMfos3PFkYNwCAGW4dTmZOvcBWxRlbEM+N4/5UsoK77/bKY+kyX6dwszm47tZ1B66tB8axz4qMoLoFgXAECe6FZDL7zcrYKRTG/qU7bJIb87z5V0vxpmuKKQ0sJ6if2AEsRMZl8ryo1xajM7nST6gqIFwAwFISNOUNFqJTus243JY3WEgOAspidZX22H6KiZRN0w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JxlK65jB; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=patchwork-bot+f2fs@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JxlK65jB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=patchwork-bot+f2fs@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hbPj723kFz2xWR
	for <linux-erofs@lists.ozlabs.org>; Fri, 04 Sep 2026 02:11:07 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2F9E42AD7;
	Thu,  3 Sep 2026 16:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929241F00A3D;
	Thu,  3 Sep 2026 16:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788451864;
	bh=0GGJyshhlAlKfjOpgr7j97Mh0m1+5qav5ykVgFpFUIA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=JxlK65jBcGgrsk9TAjqXxFnNxMSr2EUzOMWx942qjPBc2ybpTNX4WvsfPUiPxOaFl
	 CvaTGDSQ1oizIiQKMXWYE2OVnwqIcGg5ydGC/+fP1+mqJ1GuK69hXukg6W16b7JT1r
	 w2aaHejOOmNUZBUXMT7w7PrSbcyV2uNkwH9yBFLEDwdRzAceRy7X++SL5zY6FEYsfi
	 FKkGMEhCG0T0FcIFQ+7naHWPwvlEPmk672vo9ZWS+QDqA+Td4EZLGZ+BJGrxKQ67ij
	 TyZdI3BpB9bpqUcAWwS6PSI4Q7NaBwZ/Wa6AfOhrb223ZyOEtRQ2bZ96TF514AV+At
	 BAPEfyocjj+3A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1986738119CB;
	Thu,  3 Sep 2026 16:10:07 +0000 (UTC)
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
Subject: Re: [f2fs-dev] [PATCH RFC 00/14] Remove PG_private by using
 page/folio->private checks instead
From: patchwork-bot+f2fs@kernel.org
Message-Id: 
 <178845180590.3423963.571905514968785918.git-patchwork-notify@kernel.org>
Date: Thu, 03 Sep 2026 16:10:05 +0000
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
In-Reply-To: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
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
 guochunhai@vivo.com, skhan@linuxfoundation.org, ceph-devel@vger.kernel.org,
 baoquan.he@linux.dev, matthew.brost@intel.com, anna@kernel.org,
 sstabellini@kernel.org, zbestahu@gmail.com, rakie.kim@sk.com,
 minchan@kernel.org, richard@nod.at, x86@kernel.org, ebiggers@kernel.org,
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

This patch was applied to jaegeuk/f2fs.git (dev)
by Jaegeuk Kim <jaegeuk@kernel.org>:

On Fri, 31 Jul 2026 22:13:23 -0400 you wrote:
> Hi all,
> 
> This patchset removes PG_private to make space for upcoming PG_folio
> (reserved as __PG_folio) for identifying pages from a folio (more details
> in Note below). Instead of checking PG_private, all code is changed to
> check page/folio->private != NULL instead.
> 
> [...]

Here is the summary with links:
  - [f2fs-dev,RFC,06/14] fs/f2fs: stop using PG_private
    https://git.kernel.org/jaegeuk/f2fs/c/5ad9409a9533

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



