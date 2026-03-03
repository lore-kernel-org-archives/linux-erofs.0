Return-Path: <linux-erofs+bounces-2473-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D59FFEB364A
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Mar 2026 01:42:00 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fPz7C2ghXz2xpk;
	Tue, 03 Mar 2026 12:41:59 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772502119;
	cv=none; b=MhoRom+Sd071SYO578rVAG2MIJeIFo6uO9awF2a5O4EM3zLekRw+AfB1ZGhWaNFvb7kdw+XcIy+jUjb9HgrXffq3axaCa4GEFi2t6Kxn0FFB3Vlgx52E26ojmxL0v1BKAXmgK21CU5bjBZniL69bRHKjU5cyQCmLSUD+t86+/uRyM+uSxkKMx9Q5FlcVpMbiIHc9OUa3Llg/ABJKONQJerjA5W2wIjI2N0ssebSPYYGPhpU6B9SOXJOyw+y8JkSpDwWrwRelfugba9QOc3qmVuPq03VJcj8q0VwsfBGoPS1AHstGoqn7PBOXh8PYpyb0UXbafQ/IHEmyxHMeOJ0tIg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772502119; c=relaxed/relaxed;
	bh=D9VtcV0U1STZe/+Ilt1nqP14Nc37zhney3SWbOyckYA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dwND0v22Wh0VjsqxlKpDyaUFCwiKzrZV/J+tmurnidGDwLor/AsitNICZvmbG5V7wyHMugr6TuQwcnRMCCqALPww/RJIBo/8gB9ZJzS98Gib3aViTiyDQdR9uCwghvV1KPKYsLAZYOhjjVdQycKpdmH+zt79X5nx9tPgNCDfEuDdwSmEUme+J/Wt6HH4luQqlo75kj85MdRrbu28Zwz6eB9n58+AKLG0kkxRwRcFNZ1XQJgDpbjWrnWLKG6wsChiPEKMd53yzlG2QmRzpIrbGT+Cw4aoeFuU6QcxeiPWcPlAvHPoTNH2TrASlK1gK71X5TBDrrys4GzjbkNZtVGUZA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KnaqoW0T; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KnaqoW0T;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fPz793wNYz2xRq
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Mar 2026 12:41:55 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772502111; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=D9VtcV0U1STZe/+Ilt1nqP14Nc37zhney3SWbOyckYA=;
	b=KnaqoW0ToBr5uyU1gDbqMEH63BQuqBk5JpR0iPUffmHuHIgpGfUfL85JsqP8wqTtaABBQ21w63IkwkKafBF/7N0gV3EzitwmG76oQMaoTHsonGj9PXprnm/wzPIYHk4Nz/vng3R/AOvFaF08IIzwImUmxibLGGijBcl1SDUw1VA=
Received: from 30.221.132.55(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X-7rcir_1772502109 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Mar 2026 09:41:50 +0800
Message-ID: <946373a7-23c2-4ee9-a92e-fac76ee7e2e4@linux.alibaba.com>
Date: Tue, 3 Mar 2026 09:41:48 +0800
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
Subject: Re: [PATCH] erofs-utils: mkfs: fix CPU spin using --tar=f when stdin
 is closed
To: David Scott <dave@recoil.org>, linux-erofs@lists.ozlabs.org
Cc: dave.scott@docker.com
References: <aaXec59gbj8fIXai@beast>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <aaXec59gbj8fIXai@beast>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/3 03:01, David Scott wrote:
> On my Mac I saw a CPU spin which looked like this:
> ```
> Call graph:
>      2192 Thread_132504   DispatchQueue_1: com.apple.main-thread  (serial)
>        2192 start  (in dyld) + 6992  [0x185bcbda4]
>          2192 main  (in mkfs.erofs) + 7916  [0x10253a6d0]
>            2192 tarerofs_parse_tar  (in mkfs.erofs) + 5492  [0x102551d48]
>              2187 tarerofs_write_file_data  (in mkfs.erofs) + 140  [0x102551fe0]
>              + 2187 write  (in libsystem_kernel.dylib) + 8  [0x185f47834]
>              4 tarerofs_write_file_data  (in mkfs.erofs) + 116  [0x102551fc8]
>              + 4 erofs_iostream_read  (in mkfs.erofs) + 16,36,...  [0x10254fa28,0x10254fa3c,...]
>              1 tarerofs_write_file_data  (in mkfs.erofs) + 140  [0x102551fe0]
> ```
> 
> The input stream was closed prematurely, so the reads returned 0 (EOF),
> which wasn't considered an error.
> 
> Treat return of 0 (EOF) as an error.
> 
> Reproduce by:
> ```
> dd if=/dev/zero bs=1024 count=4 2>/dev/null > /tmp/testfile
> COPYFILE_DISABLE=1 tar cf - -C /tmp testfile | head -c 2048 > /tmp/truncated.tar
> ./mkfs/mkfs.erofs --tar=f output.erofs < /tmp/truncated.tar
> ```
> Before the patch this will hang, after it should fail as expected.
> 
> (COPYFILE_DISABLE tells mac to avoid putting extra stuff in the tar)
> 
> Closes: https://github.com/erofs/erofs-utils/issues/43
> Signed-off-by: David Scott <dave@recoil.org>

LGTM, will apply.

Thanks,
Gao Xiang

