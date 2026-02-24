Return-Path: <linux-erofs+bounces-2374-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17071EFB806
	for <linux-erofs@archiver.kernel.org>; Tue, 24 Feb 2026 05:59:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fKn9C3dDmz3cF8;
	Tue, 24 Feb 2026 16:59:11 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.119
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771912751;
	cv=none; b=AapeS4ETGMFk0fe8Ani0OJpnZ7eX0FWo8Cw/DZnQ920pfl94YTHYf5/ALFqRHexqWMFKZaNYhqH0wVFVTkMbm7wtQZiEtZOYvmBpO1WAF5k5mahi/J/r6KOeiSGZLn8cCNN2vkdHMDgI1A1g0QptDqFH1cB4UuSLhif3Fz6UIXfu6JOrTeW/IczdOJk2I4FP6atSC4j2kwTuNebHiougFM/6+tooa1HkgWnx34iYsHvYNk1/GNnzftrJLjhFdPOvp48boZ6Z0bazXruTIZJJAinnIpLAnLMvy0zk9U9p6LE8rgEsb4YF+W/+ZddZ5edHBt/nl+tCKofLTOhTVM3l1w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771912751; c=relaxed/relaxed;
	bh=jFKUCLSR9HnxfCK9tiiOoezNo1xsrPFk4sNth07JOV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y9GtOQZvHlwOmONAeXx5cVcdFae87kI6hJH46PHLyF5sFJrk4YiwEQgwTji8OT10ff58aM0zSq+iqpzUd0M6oHU2schqzoYjZRP9IUmxktcKPy4r43iawyzph6310tBiYydDJ3wqxWutowNY/wuX65buLXQZbjGmGb8ZdfGMz+I0wGxYwkx1Vu48Y0znrFPFiClMZ7TH4cepcrVFHXsAnsXsNl6yfqtCD934HtgfvNJzKtleu91iWsc7Cx2cZNa8KqITAEmo6g6WLfZmiwIZV1GC/uz2LVTIo7M+PcRFpCIExPOAjOyGT0fHTsHY59xiDPjteC1pkfGo4sMcHnSH6g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=tOliXWbf; dkim-atps=neutral; spf=pass (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=tOliXWbf;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fKn9925C7z3cDg
	for <linux-erofs@lists.ozlabs.org>; Tue, 24 Feb 2026 16:59:08 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771912743; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jFKUCLSR9HnxfCK9tiiOoezNo1xsrPFk4sNth07JOV8=;
	b=tOliXWbf48PkJEyoepet98uRF3T2QcXdEg96h8hWWI6h7IXyAsuT/ah0s2P02BdoWjFP9lbZGI5FyDtLtiLwFsAwS/4XxFQHhnqBy04UvTKrk91xx+yZ5Jfd5vVQrAbjgHHxz9CAlfNhD30y1E/sEcGnW8Zm0V+8gDNesa5wzSw=
Received: from 30.221.130.254(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WziN6ov_1771912368 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Feb 2026 13:52:49 +0800
Message-ID: <184101bb-9606-4e2a-9e35-6b3a1eafb4da@linux.alibaba.com>
Date: Tue, 24 Feb 2026 13:52:48 +0800
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
Subject: Re: [question] GSoC Proposal 2026
To: Saalim Quadri <danascape@gmail.com>
Cc: linux-erofs@lists.ozlabs.org
References: <20260221214258.129214-1-danascape@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260221214258.129214-1-danascape@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Saalim,

On 2026/2/22 05:42, Saalim Quadri wrote:
> Hi everyone, I am Saalim Quadri an undergrad student at Dayananda Sagar College of Engineering, pursuing Electronics and Communications.
> I wish to participate in the GSoC 2026 as a part of the EROFS filesystem.
> 
> I have been contributing to the Linux Kernel and have more than 10 accepted patches.
> I have also worked with Android Linux Ecosystem in the past years, and have worked on several subsystems, backports and fixes.
> 
> I started looking into https://erofs.docs.kernel.org/en/latest/roadmap.html, and I am interested in expanding erofs-utils to stabilize liberofs APIs.
> 
> In that sense, I would like to know if anyone in the community could provide with some suggestions for my proposal, and a positive impact.
> Any suggestion or hint is appreciated!

Sorry for late reply since I was in the vacation.

"expanding erofs-utils to stabilize liberofs APIs." is of course
part of TODOs, but I'm not sure if it's a gSOC project since:
  - It's not an independent feature, much like just rearranging
    code instead;

  - Currently we don't have enough mentors to trace too many
    formal gSOC projects.

The formal gSOC projects are still under discussion, but I do
hope we could have some improvements in:

  - Multi-threaded userspace decompression;

  - BSD kernel support.

But if you're interested in erofs development, contribution is
always welcome!

Thanks,
Gao Xiang

> 
> Sincerely,
> Saalim Quadri


