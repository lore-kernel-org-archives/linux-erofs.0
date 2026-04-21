Return-Path: <linux-erofs+bounces-3342-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1878AF5A8D1
	for <linux-erofs@archiver.kernel.org>; Tue, 21 Apr 2026 02:16:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4g05Zf3m9sz2xc8;
	Tue, 21 Apr 2026 12:16:42 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1776737802;
	cv=none; b=mrTZ0123xsmXUBThebcPOcGSIPQVeKskkPrqLGw8nf9XMoXA+cEaCmGuCiozeq20gNzJ9TpL42MA4EiqXRF8Q36gEw0KraL0uct14JtBUNQNj0aDKA0+TM6Ev8pEnzfZ5UuVjoM2WknS1+kZNc5ZWVkPmWZyO9PnH++tcddvcDRl8VdwA9uUXxuzYqzzGnmjxqPhGWElOWKUzy6xuo+RyAqypEIe0S6ANehpeaRHY9sJRXXC9xH+4OEdjXnRnBaCGBxLGmVtuZAFU5IbWQnuX7T8lDdmng0GX1K7PZ2MspBLVEb6qZr413oxmQUSlCy33WLU4x1PvaReM0oeR03UXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1776737802; c=relaxed/relaxed;
	bh=VxrgHP43S1/4tAIE0dRMnCXjiYTWEIlIqqKAbN32Xos=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OheLPL1oXRPbWaxnSKrj5dxEHghQx9o7etYyOYqoXU02/OZUSNsKEvX976B4sVveeCaKfLRycHPL/DwDET9SqqLEa8nTYaUlpSSMMcotsB8qak7udC5Hr9awqVtTWaVMxN0hl4BkPpY7RLFSKzQWSXXdPqs6S2LQLs7F3u5DBQr3vpKOWGr6Bd8VyMs+J1m0cho4CeStL1xQCoublkIVj0W6RCyueIFKPL6jpEsWPlGsNFmsNVnBOr/do/ZDqxfOIO0aMHM9RAlT9zxTDftZd/POqPrWSsvlk8aj2ILICn3uuMCkjolmh/8QBwNfw9c9T6X+6Kg3znw2p200JtOAww==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=EQpwYYjj; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=EQpwYYjj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4g05Zc0Jz1z2xT6
	for <linux-erofs@lists.ozlabs.org>; Tue, 21 Apr 2026 12:16:38 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776737794; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VxrgHP43S1/4tAIE0dRMnCXjiYTWEIlIqqKAbN32Xos=;
	b=EQpwYYjjtBNvKalOncBjSxyOAv65aRWTniJRoOQL3hhPCiUTKH/DDyJeMIROMjg1MKnqlvT1XJiujZIaOmGk476ClEgFQcxTZg8IG5Cc/GQ0DMEpz2ZxuVg2tbYKbk5nv4zVAvZwZX5+fUqdncbmsW2y8zvEiEqgUayFgFxoqOc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R981e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X1RNwkO_1776737793;
Received: from 30.221.132.26(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X1RNwkO_1776737793 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Apr 2026 10:16:33 +0800
Message-ID: <3b50f2bd-44ba-46e6-95ac-0331c3cfbc4c@linux.alibaba.com>
Date: Tue, 21 Apr 2026 10:16:33 +0800
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
Subject: Re: [PATCH] erofs-utils: lib: check NULL from
 erofs_rebuild_get_dentry()
To: Vansh Choudhary <ch@vnsh.in>, linux-erofs@lists.ozlabs.org
References: <20260420174752.50132-1-ch@vnsh.in>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260420174752.50132-1-ch@vnsh.in>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/4/21 01:47, Vansh Choudhary wrote:
> erofs_rebuild_get_dentry() returns NULL when the input path
> normalizes to nothing (".", "/", "//", or paths that collapse via
> ".."). The tar hardlink branch and the S3 import loop only check
> IS_ERR() and then dereference the result.
> 
> Reject a hardlink target that resolves to root with -EISDIR, and
> treat a root-normalized S3 key as the root inode itself.
> 
> Fixes: 95d315fd7958 ("erofs-utils: introduce tarerofs")
> Fixes: 29728ba8f6f6 ("erofs-utils: mkfs: support EROFS meta-only image generation from S3")
> Signed-off-by: Vansh Choudhary <ch@vnsh.in>

Need a reproducer to experimental-tests before advancing this.

Thanks,
Gao Xiang

