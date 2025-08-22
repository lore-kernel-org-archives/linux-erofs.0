Return-Path: <linux-erofs+bounces-866-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EB31CA0EFA
	for <linux-erofs@archiver.kernel.org>; Fri, 22 Aug 2025 03:19:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4c7QQr52Lyz3bb6;
	Fri, 22 Aug 2025 13:19:32 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1755832772;
	cv=none; b=T7gYojWGDr74QtrqKgVeSpF3++v9bd5ySMMSYNUj9Ymep9MKz4Qr0fGPB6huqgkFpHoJ0S9hsmm57PwKuI2h+TXZz3CBzgXz2Xl429wZaIWXcu7dFDlX+HYaTEhB7DO9OurOwZGrAxUBk1KBoyRm0yFlOWUjTy/n6dcGQMimufQ+05H7CTgWJT+e3hh449ui5rL5bZ/vs4KRSsdMYkZP99fBSjqGLLz7Rkzh67mQOSldehlxzXQuUpwMGeHvhPoEyE75sAmKH8JFnbNk3sAdh3zgGu/FYsFeSV0801FX0T4YyZsGsOkqa3QR6dE1lJGDaRCgZMVBItNMhx2zqEEZxA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1755832772; c=relaxed/relaxed;
	bh=C47Y7znbpOFnJeL/pMvd4ONtuMJ/1WJiOCAc0T4xiWs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RluWipFmcjJ53+uc/SBp/QqPgvcEWUgRlO+CEORj66ZI3Lo64+2awf1OcTyxXhA0RVzk1Ihwr2QPf2uW8zsqPp+4gT4kvE7tHNfD1YStleIW0iim4cLm1PuRHjVcLYZ8irUEVm0WqSmWpGGiEPHP6XRdReGBCZSrQaRjdKz+yQN5K1SpCuBVvt0PcEgwXw32qeXBqZtakuEsA3tVGjJBvM00T90B2CGm0T0UYDENByFgQQBqnokW5+JsZDtm0i5J8LxZZVfj/ZqUE5dq4w1BoZJNgq+wm07H2cO6P43uo+F8Lnbvjnd3GPZIf2+EJwHNd7e8IAhDUMVq+F0pr7lfMQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sb9geX5z; dkim-atps=neutral; spf=pass (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sb9geX5z;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4c7QQq6Rpcz2xpn
	for <linux-erofs@lists.ozlabs.org>; Fri, 22 Aug 2025 13:19:31 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755832768; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=C47Y7znbpOFnJeL/pMvd4ONtuMJ/1WJiOCAc0T4xiWs=;
	b=sb9geX5zSmN93ryGQB8B9GXpnQ/kgdt9si70sHuFJZ5EiZZj+dW1w0/MoT1kT33g31gCqr7iyRYULBm9qwJf8WgyOheLf85620qhilxPalcyHtgJO0ZN3uQw0wp/I23H8HtJ1RFVc8zLY0OtH6NGLV6v5+w4G3TGtryGIueLv7A=
Received: from 30.221.131.67(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WmIBCuK_1755832767 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 22 Aug 2025 11:19:27 +0800
Message-ID: <91765f60-5c80-44a8-9b99-8d5918351095@linux.alibaba.com>
Date: Fri, 22 Aug 2025 11:19:26 +0800
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
Subject: Re: [PATCH 1/1] erofs-utils: add OCI registry support
To: hudsonZhu <hudson@cyzhu.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org, Changzhi Xie <sa.z@qq.com>
References: <20250821073258.89073-1-hudson@cyzhu.com>
 <4de3eb31-9368-4512-a9e4-a2f65f30edb0@linux.alibaba.com>
 <5189EEE5-2FA1-464C-8069-EA01AEAEB9D3@cyzhu.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <5189EEE5-2FA1-464C-8069-EA01AEAEB9D3@cyzhu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Chengyu,

On 2025/8/22 11:09, hudsonZhu wrote:


> 
>>> +	struct erofs_tarfile tarfile;
>>
>> 	what's the purpose of `struct erofs_tarfile`?
> 
> It's used by the tarerofs_parse_tar() function to iterate through tar archive entries and extract file information.
> 

Yeah, got it, see my latest reply on your v2.

I think you could leverage erofs_tmpfile() instead,
and it returns a fd so you don't need to creat + open anymore.


Thanks,
Gao Xiang

> Thanks,
> Chengyu Zhu
> 

