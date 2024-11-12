Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 637D8D41D44
	for <linux-erofs@archiver.kernel.org>; Tue, 12 Nov 2024 01:05:59 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4XnSsK2k64z2ykC
	for <linux-erofs@archiver.kernel.org>; Tue, 12 Nov 2024 12:05:57 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1731373556;
	cv=none; b=CQYOnIrO8qqIoSP7MokLfVFxbaV8k76Sc4uP4dkVV3+2skv5Jowlv6KsD12qPedafvb9zdPUH/Z11bpGdoggzSHwuywVa6douGS8Xuq93uTdLzvtM4hGD3kT+yX8+YzrLhJoIRJ1BVzwHJfPs4ZDxNYD+szVjgTfexpXBdNlsWHIg1suxEmscM2umh+waoGJUOuHOr8QuOEwGHQUBFYBWE8QW2tydrTS1MEzc+U0H6bpa8WP9ctefJVYcGnjgJuuKYUyiMTexJg1uifs+zgehv7W6osj5mnAmvJllfayDbK/Wiosf1EQha92pD+KuKSMO5YN1UWOuohdx/FePF0F9A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1731373556; c=relaxed/relaxed;
	bh=eARRj5ydQKtU144BhhuhRyCE/qbl+F/TcgxxJQx4RUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=as/0SjvXZSZJlxtdyjdRYqR8uEuwcMiava9YprQEDW+ORfRgTeFMVN8nf4m7sxaHNxYLL+ZA1YmUNwPFVYOUa3ne7ibXbiCSnLYGpKo82duTPANyKPbZSWjh5K3kcmw4meBGa/Tju/KJVryUvV1z4eZnKMsk5u5Niu/Uz56+8Ijw4ysJCCvVE6JrkUhmKvI1TAhYrC/BHXfSTp3UfK1QhpFbH0IlEtFUP5rph2zB53G3n62jNxzknm7wN+acL4vlcQComdFZnr+xlbdY/twMGryEPPwD5IbWlI3EIul4hmaslpWlwEMu66Y6Oo6S6N4oNOTLdOCIQlOVK6QQgtXycg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=YBfyUzTW; dkim-atps=neutral; spf=pass (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=YBfyUzTW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4XnSsC168nz2xfR
	for <linux-erofs@lists.ozlabs.org>; Tue, 12 Nov 2024 12:05:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1731373542; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=eARRj5ydQKtU144BhhuhRyCE/qbl+F/TcgxxJQx4RUk=;
	b=YBfyUzTWI8nyT3t0T17gruVIO7YaUXZDQwnWnQtP/TeHP5vdnTslN2RZFAsERh/v5l3AspxiSmfquD3LjwKvaQGbppwk0jY7Yp0j8VDkprkuwfUL5LHFmDNQpXqSbT7dL9/euDDaeTOtRzlNRGERISkPi//+H+bvGV/Y+HjeYzc=
Received: from 30.221.128.202(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WJF2ORl_1731373540 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 12 Nov 2024 09:05:41 +0800
Message-ID: <71572068-5a5a-4e5f-a1b4-b7f5ed24244d@linux.alibaba.com>
Date: Tue, 12 Nov 2024 09:05:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mkfs: Fix input offset counting in headerball mode
To: Mike Baynton <mike@mbaynton.com>, linux-erofs@lists.ozlabs.org,
 sam@posit.co
References: <02a3a22d-782b-434b-b3e6-5138f77ee251@linux.alibaba.com>
 <20241111164819.560567-1-mike@mbaynton.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20241111164819.560567-1-mike@mbaynton.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Mike,

On 2024/11/12 00:48, Mike Baynton wrote:
> When using --tar=headerball, most files included in the headerball are
> not included in the EROFS image. mkfs.erofs typically exits prematurely,
> having processed non-USTAR blocks as USTAR and believing they are
> end-of-archive markers. (Other failure modes are probably also possible
> if the input stream doesn't look like end-of-archive markers at the
> locations that are being read.)
> 
> This is because we lost correct count of bytes that are read from the
> input stream when in headerball (or ddtaridx) modes. We were assuming that
> in these modes no data would be read following the ustar block, but in
> case of things like PAX headers, lots more data may be read without
> incrementing tar->offset.
> 
> This corrects by always incrementing the offset counter, and then
> decrementing it again in the one case where headerballs differ -
> regular file data blocks are not present.
> 
> Signed-off-by: Mike Baynton <mike@mbaynton.com>
> ---
> 
> Thanks Gao for the suggestion, looks good to me and tests ok on my
> sample headerball inputs. Let me know if you want me to resubmit this
> with Co-developed-by / Signed-off-by you.

I will add "erofs-utils:" prefix to the patch subject but no need
to add "Co-developed-by" tag.

Btw, if some converter for headerball files from tarballs is
available in public? It'd be better to get some tests for this
feature.  `ddtaridx` is designed by some other team in Alibaba
so I don't have a valid simple generator/converter too...

Thanks,
Gao Xiang

> 
>   lib/tar.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/tar.c b/lib/tar.c
> index b32abd4..990c6cb 100644
> --- a/lib/tar.c
> +++ b/lib/tar.c
> @@ -808,13 +808,14 @@ out_eot:
>   	}
>   
>   	dataoff = tar->offset;
> -	if (!(tar->headeronly_mode || tar->ddtaridx_mode))
> -		tar->offset += st.st_size;
> +	tar->offset += st.st_size;
>   	switch(th->typeflag) {
>   	case '0':
>   	case '7':
>   	case '1':
>   		st.st_mode |= S_IFREG;
> +		if (tar->headeronly_mode || tar->ddtaridx_mode)
> +			tar->offset -= st.st_size;
>   		break;
>   	case '2':
>   		st.st_mode |= S_IFLNK;

