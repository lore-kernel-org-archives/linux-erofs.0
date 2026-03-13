Return-Path: <linux-erofs+bounces-2686-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26961105F79C
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Mar 2026 11:38:37 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fXMty4J5mz3cGf;
	Fri, 13 Mar 2026 22:38:34 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773401914;
	cv=none; b=i7gnKC+ks1ktjKWpkOZf92w3FgBKDeCIgOkfW0SfGXBfmPiFlgKPAywKinzoO1Lg7cft1pdLj4FTO/J/Sg8K6la6Y1P0+poDJchytNe5SYxC/osKZjjOV8etxLi67zEet31fr6gqk2zOLpxo2A1PVIBTonoMxDq55ZYNuZltqJK86CfKoP+naTwfMUKmrAt2K5eWrtJLWkOX4xJUAGqi0DDYP/T+vInF62/Qup6uHGxTAQz4eaCnSoaj/8iVcHHDQ1tEaoLChAut+kkpMgV5yy7DiyCVZO/38CXivcn0hU4WHOFHQHsCW9lyz4o5RdDGAEhhGRvl7V7JyCLTsPLLhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773401914; c=relaxed/relaxed;
	bh=KanIEsrT05/mXx4Tu94aidB3WZ4UHRhSJnl8i0BYHy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HylC7gSsyKoEq3ajqJGnib0x3Iig2BwdsuOU/ae0HsJPjvPsW3K+8YMIhdG/8mjulBRnuIlb0uJQidAtBIf2D1Af5tDIkfgTDxr2rmemeWezM0vH5n04jreJb3U4q0WDmNNyLQqZwPLZQBr/wYcDQ4OIzfGBD5oBsJRgtDqevvF7ldoJL31LWUi/RsqyLjjCwkhkWD1oJiufk1G3FSYJKUjorxEB0lpFiZQ968cGFe2Aa6iuwl1n7i8Lvxd8VdUFPijr5WBdEt3wdwN2G72YjfuPJIf1kFSzoUwW6MHXVz7LMmuRvoCku0vLmYNOvgYonlXdST5O/8KfGCo8qCDWIw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=RLsIY8qT; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=RLsIY8qT;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fXMtv4Btmz3cGM
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Mar 2026 22:38:29 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773401903; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=KanIEsrT05/mXx4Tu94aidB3WZ4UHRhSJnl8i0BYHy0=;
	b=RLsIY8qTiAoLZ6i9i/4Dmwl3gXyxeFzKGTBTXilsXvI/mJN3uwZv/vY1J36kMEVAoyP9ZbHxjy2poG/e3JF/vL7nghdOWZ83tFbrClOESxCg5zhfqaXS/kx9BS/n3WeLsxyuSSpwtZOXVsSrn6zezqdXmW09p6cgs0NuefwzDv0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X-sKaXR_1773401901;
Received: from 30.170.14.2(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X-sKaXR_1773401901 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Mar 2026 19:38:22 +0800
Message-ID: <a8adb93e-084c-4106-91d4-e3ad871ddc0f@linux.alibaba.com>
Date: Fri, 13 Mar 2026 19:38:21 +0800
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
Subject: Re: [GSoC 2026] Introduction and Project Interest: Support generating
 filesystems from manifests
To: Sri Lasya Prathipati <lasyaprathipati@gmail.com>,
 linux-erofs@lists.ozlabs.org
References: <CABDnCWkfX7jNZEcaCQhnJKw86WJijYVSrOov8DZSPDJT=S4F0w@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CABDnCWkfX7jNZEcaCQhnJKw86WJijYVSrOov8DZSPDJT=S4F0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sri,

On 2026/3/13 16:52, Sri Lasya Prathipati wrote:
> Subject: [GSoC 2026] Introduction and Project Interest: Support
> generating filesystems from manifests
> 
> Body:
> 
> Hello EROFS Community,
> 
> My name is Lasya, and I am a 3rd-year Computer Science Engineering
> student. I am writing to express my strong interest in the GSoC 2026
> project: "Support generating filesystems from manifests."
> 
> I have spent the last few days familiarizing myself with the project's
> goals and the erofs-utils codebase. I wanted to share my progress to
> demonstrate my commitment to this task:
> 
> Development Environment: I have successfully configured a WSL2
> (Ubuntu) environment and verified that I can compile the project from
> source using autogen.sh and make. The local mkfs.erofs binary is
> functional on my system.
> 
> Code Analysis: I have begun a deep dive into lib/tar.c. I am
> specifically studying the tarerofs_parse_tar() function (line 700) to
> understand how it iterates through the tar_header and maps metadata to
> the erofs_inode structure. I see this as the primary template for the
> manifest parser I intend to build.
> 
> Initial Research: I am currently comparing the "unix proto" and "BSD
> mtree" formats. My goal is to design a manifest parser that is robust
> enough to handle various metadata types (UIDs, GIDs, and permissions)
> while remaining consistent with the existing importer logic in
> erofs-utils.
> 
> I am highly motivated to contribute to EROFS and would welcome any
> early feedback on whether there are specific manifest formats the
> community prioritizes, or any architectural nuances I should keep in
> mind while drafting my formal proposal.
> 
> Thank you for your time and for this opportunity.

Thanks for your interest. You could look into the erofs-utils
codebase and write the proposal first.

Thanks,
Gao Xiang

> 
> Best regards,
> 
> Lasya


