Return-Path: <linux-erofs+bounces-2732-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0663F013C5
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Mar 2026 08:04:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZ70W3VWhz2xpn;
	Mon, 16 Mar 2026 19:04:27 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773648267;
	cv=none; b=ZQiCePGsW4LMhdtz4aTZ+TTVQBBBzT7xLOGce+TKhGfwOjRPXihjm2dhXTTEfgKkDIuXdzjAFokbxFx3+A4STTaPJZAp6N7TIt/I8E2x+Cq+y9mAhnDw4RCS3KONR7kQ3QN6jzA5XVzeVlJ9jIzil8Uwyw+VewqqcTEOItbLoxnnosG1RCvQJ6hhZ878sFJnfnkw24jfULrpIqqLaL0XXDceTH0+rHe9u7Z/PKa8mN+2fykJzF+wRXc50v1J0iBFBMPdDDwEN9w2ytviMb3NYVzHzbBPxjKA0+CiBp0m7FwYf3M6RAXFvu+b3D1+kgTJ7SGxJd6JBES6Rja6gpplfg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773648267; c=relaxed/relaxed;
	bh=QbpepUZOAIdDkprCRlikObGh27mJdCxpv3AzkBPt72E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hGyFGBfrnSKq+98dsZHpinwnzX2xXM6qA1W0JCH1Ddei3U6mf96bWgFRLtFlqCCkMgyDGQ6opBJxJ+eMM/keZVObae2JZiOZfntC8u2KgmdUqVIY9sCgpXXucUQ3Db432VugMNq7Le5Tx7Rf09GChBHvS812K0uHSXFfFmf8nBPdk253ImgKbl98XdNrXWArMMfH08a/jsSz/RDJbwVNRXclYnQPiTE12h6NAYU2uUrqZQ9OHlJXvwlOCYmURMtC6CodQKKJHaqR80agwphE3opKRl/4RRJdsIpHLbS19Yr7Pbsnx963JNU05qj7f+O9DqMFOihIWsMg0wMJvFI1Jw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=d2nQ9xR8; dkim-atps=neutral; spf=pass (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=d2nQ9xR8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZ70V3MVLz2xlP
	for <linux-erofs@lists.ozlabs.org>; Mon, 16 Mar 2026 19:04:26 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773648261; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=QbpepUZOAIdDkprCRlikObGh27mJdCxpv3AzkBPt72E=;
	b=d2nQ9xR8wLwGD45KPT9BZIqgvAClwC3CyYhgYHlmU12ixA74voCeXSzphPQz9THD0uJnvXO0jSc1G2Gl2JWXXnfYwT8+YJKNufMrmOFwR2HixZQAcbdsDMg5JOw43xJW1Uv9vGlFHuoPeCYPD1+guJz24bQkZkc/cwpoYZgqV+Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X.1GdNh_1773648260;
Received: from 30.221.132.167(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.1GdNh_1773648260 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 16 Mar 2026 16:04:20 +0800
Message-ID: <48a20201-eec8-4457-91cd-f80634a2267f@linux.alibaba.com>
Date: Mon, 16 Mar 2026 16:04:19 +0800
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
Subject: Re: [PATCH v3 1/2] erofs-utils: lib/tar: skip PAX entries with empty
 path
To: Utkal Singh <singhutkal015@gmail.com>, linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org, yifan.yfzhao@foxmail.com
References: <20260316075831.35495-1-singhutkal015@gmail.com>
 <20260316075831.35495-2-singhutkal015@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260316075831.35495-2-singhutkal015@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/16 15:58, Utkal Singh wrote:
> When a PAX extended header contains 'path=' with an empty value,
> the computed length becomes zero. The subsequent trailing-slash
> removal loop accesses eh->path[j - 1] where j is zero, resulting
> in an out-of-bounds read and undefined behavior.
> 
> Skip such entries to avoid unsafe pointer arithmetic and invalid
> filename handling.

I don't see a reproduciable way here.

> 
> Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
> ---
>   lib/tar.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/lib/tar.c b/lib/tar.c
> index 26461f8..be86984 100644
> --- a/lib/tar.c
> +++ b/lib/tar.c
> @@ -510,6 +510,8 @@ int tarerofs_parse_pax_header(struct erofs_iostream *ios,
>   
>   			if (!strncmp(kv, "path=", sizeof("path=") - 1)) {
>   				int j = p - 1 - value;
> +				if (!j)
> +					continue;
>   				free(eh->path);
>   				eh->path = strdup(value);
>   				while (eh->path[j - 1] == '/')


