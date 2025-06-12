Return-Path: <linux-erofs+bounces-397-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C704CC71136
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Jun 2025 11:29:06 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4bJ0fT1w8Vz2xHT;
	Thu, 12 Jun 2025 21:29:05 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1749727745;
	cv=none; b=TYTHw+K7upNUfRCVCeIwQ7DeaWiBY/VHulzqqKUlCCnuXB93WfjjDbG3xESTvl0whZHs1K1ZB3fq8IhEku1I838PSn5RSS3I/TnFlk2z110IyMZRdZMAs7/pZO3r9V3Epz/z/pxOTrPv4MdTGfWxSfk66ENO0eywZr4qUc2Wa66iiqsX7BxUbtevJ+gXGAEmf81mw53jsxfenBjW5dV/s88PYjOlqhdXIl01uxjnhLy+LM8A2l4zwuoJAFzbFm3AwvzE711NflVZRcH+9g1xGoWxkT788OPHrV4rbqhDrrhWnG0QPqS6sXMCZW7gyrejoohXj2QrL+NnxCGK0thc+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1749727745; c=relaxed/relaxed;
	bh=fu0ZkPc/YdFxpsnb8F1tiP97BdbT2kHIv/FW3kqjBc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UaZ5C8q7GlpD4+3ghEfF8ZML9Zu5lGRx8vDbyucmYxu/V4dmhKbUt8bJ3eWnas0WBq3UN3E5A2mS+C2jz3bwdN96GpRnPzStkqeE0qxQHdWbSfooYEt3RfHzv3L3ht04U0y+JbMQLqzZhBcPFdm3fnI7gG28ocMYv3JnQl7GOn7mW5b9COkJsgWWkQy7uO3qam6KRAcq5wx2Ihxw7y0TsBcROn0egJCrReiXt0rsjrzyM1Rc9eStorJ8s6dgdAQJDxtJckwlnC9cOwdGW4eQRrDG1P70J0BzlGFPm6uci7fEe4n7Khyue7j2zTtbpawxvDEQZqF0GF4iOIo8F9Kw9g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=HF8pra7I; dkim-atps=neutral; spf=pass (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=HF8pra7I;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4bJ0fR3qcVz2xFl
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Jun 2025 21:29:02 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1749727738; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=fu0ZkPc/YdFxpsnb8F1tiP97BdbT2kHIv/FW3kqjBc0=;
	b=HF8pra7IigBuHuy1J0ixMnn4dzPnOlGmYqAPdpneFK2oaHIEv4D+x28fsZYR9kFUZJ/HpMkULDXy3sbwX73plKFigm7fgB+4/51j93ArEsf5gpMugOYqif8SJH1u3uatyYQ6dFFS7bwIGtCIRKZsAHlx6uKrQapQanqUoMGkEB0=
Received: from 30.170.233.0(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wdgqc61_1749727735 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Jun 2025 19:28:55 +0800
Message-ID: <5d85b054-0e84-45ec-a1b3-c6281243c306@linux.alibaba.com>
Date: Thu, 12 Jun 2025 19:28:54 +0800
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
Subject: Re: [PATCH] erofs: impersonate the opener's credentials when
 accessing backing file
To: Tatsuyuki Ishi <ishitatsuyuki@google.com>, Gao Xiang <xiang@kernel.org>,
 Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale
 <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 shengyong1@xiaomi.com, wangshuai12@xiaomi.com
References: <20250612-b4-erofs-impersonate-v1-1-8ea7d6f65171@google.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20250612-b4-erofs-impersonate-v1-1-8ea7d6f65171@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Tatsuyuki,

On 2025/6/12 18:18, Tatsuyuki Ishi wrote:
> Previously, file operations on a file-backed mount used the current
> process' credentials to access the backing FD. Attempting to do so on
> Android lead to SELinux denials, as ACL rules on the backing file (e.g.
> /system/apex/foo.apex) is restricted to a small set of process.
> Arguably, this error is redundant and leaking implementation details, as
> access to files on a mount is already ACL'ed by path.
> 
> Instead, override to use the opener's cred when accessing the backing
> file. This makes the behavior similar to a loop-backed mount, which
> uses kworker cred when accessing the backing file and does not cause
> SELinux denials.
> 
> Signed-off-by: Tatsuyuki Ishi <ishitatsuyuki@google.com>

Thanks for the patch.  I think overlayfs uses the similar policy
(mounter's cred), which is the same as the opener's cred here
(because it opens backing file in the mount context), so:

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

