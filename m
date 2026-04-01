Return-Path: <linux-erofs+bounces-3151-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 649991076378
	for <linux-erofs@archiver.kernel.org>; Wed,  1 Apr 2026 06:36:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4flwHF0Cvhz2ySY;
	Wed, 01 Apr 2026 17:36:09 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775025368;
	cv=none; b=esswR0UQD/434L8FP9NfJYIWIB7TBBtFjKW698yqjtpn9jJQ9TIAQnBuLLESbXJIzXoGkKz0e2+75suSQxnCBArk0LkiWxRYR4K7eQXtrnPd7khs+ewYz/TCC0u+zoYKaMp69OMfnUkiqbXdS/OKC1syHDdQHU6y/iZuN8YFgNvF6xddj6zkB6mebKoPufWNSQWoVDMThIBCBHnB2t7Q+8j9eNbmxMl684ZpVhtixELcflArZ0o2h97m6maGEdrPe3/uoeB0xEuXhYFPh9+WWNQDsVuzoMYm8IMIF3XWKhskBv1wczJccKZc17SWwnfObIcGrxcXEVJXQcjvD6a4sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775025368; c=relaxed/relaxed;
	bh=F4Kbel5TllgyJsqP32ubgPCtgCl4AdK/hMxmN7OxCJY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cd6hIYbwigY2EgFlfQ5qot9mJvD5EVbuUcKTJrHiFRl0ZFYEX0S5TmBQTmHxQNWd0QC1/ICzQ6LM8mGi5yPnFaTOUUsSrquWcb1PI4DzoKOV9w7RgZrv8uH91m6rEE1TTomyemeFyErDHYVXZZjhXqOAk54WD5wwYJJok5sPZdiCMnYwzofEI0b9lAjHKskigXp1B+gQV9qCCdpZNwg0SK2OXB1zX4TigMmp3kxwcDwWpYEmvj+0ShhWWHqL32CmST++mLTAaJBDCxyymsrV/ypxnZg1rWlZXgUv7C2WdL6oE9KvFoIN/H2JoMk3ckgyEdOLWC+GzgHaFO/a6mIynQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=tWjp8+Dd; dkim-atps=neutral; spf=pass (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=tWjp8+Dd;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4flwH64C1kz2xb3
	for <linux-erofs@lists.ozlabs.org>; Wed, 01 Apr 2026 17:36:00 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775025356; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=F4Kbel5TllgyJsqP32ubgPCtgCl4AdK/hMxmN7OxCJY=;
	b=tWjp8+DdlFR0Wp/JMLBe7ezvHXJQFCEIhfsjfAjbNpSDU8KDYiWzKRRPmUrxQM+iuukqDeZDzL+XAhmnmAJ2n3TDmaKGDedX6z5oKQHNkYG1CEl9D9m7jGT00hw73EPDOLgpYw0C8H7yyxb/N3YtqrojZWxwl+/1oA5IIYdO5yM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X08JxhR_1775025354;
Received: from 30.221.131.203(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X08JxhR_1775025354 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 01 Apr 2026 14:35:55 +0800
Message-ID: <58d926d8-c34a-451d-a19f-8176e3726495@linux.alibaba.com>
Date: Wed, 1 Apr 2026 14:35:54 +0800
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
Subject: Re: [PATCH] erofs: include the trailing NUL in FS_IOC_GETFSLABEL
To: Zhan Xusheng <zhanxusheng1024@gmail.com>, Gao Xiang <xiang@kernel.org>
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 Zhan Xusheng <zhanxusheng@xiaomi.com>
References: <20260401061342.40166-1-zhanxusheng@xiaomi.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260401061342.40166-1-zhanxusheng@xiaomi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/4/1 14:13, Zhan Xusheng wrote:
> erofs_ioctl_get_volume_label() passes strlen(sbi->volume_name) as
> the length to copy_to_user(), which copies the label string without
> the trailing NUL byte.  Since FS_IOC_GETFSLABEL callers expect a
> NUL-terminated string in the FSLABEL_MAX-sized buffer and may not
> pre-zero the buffer, this can cause userspace to read past the label
> into uninitialised stack memory.
> 
> Fix this by using strlen() + 1 to include the NUL terminator,
> consistent with how ext4 and xfs implement FS_IOC_GETFSLABEL.
> 
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>

Thanks,

Fixes: 1cf12c717741 ("erofs: Add support for FS_IOC_GETFSLABEL")
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

