Return-Path: <linux-erofs+bounces-590-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CF48C83F1B
	for <linux-erofs@archiver.kernel.org>; Fri, 11 Jul 2025 16:39:48 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4bdy9Z67yWz2ys0;
	Sat, 12 Jul 2025 02:39:46 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1752251986;
	cv=none; b=dFmXRihr1ukX5QQiihxbqK5yE0k1Nsf3b+olN5oYksVZRBRvvs+HQtZrXbBuOUnwRHyYQLlDkF6paPeVH7q04vHdpmLh9Wg/xjlIno+lHRtPwfuB3mrSK8aXPu25ZIDXVaxJoSr/zA72HM2hxcHJmmwkdFL1SAVowlDVqP+Fsi2lYqkcQY6o4AAnew5ICovB9/hVGR8d8I285xe2mhyq8aaVXnQKIVQzQx2dcjYLkaBNaZV0Aq+5YjJu40I3haKYOOaauZ3mbznz0EU75eqClauV9R0yvv7oP7fHyoR63gG60Iek1hQjeEM83bztZ1HJi0ffroPDdaVSedZe0TQRbg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1752251986; c=relaxed/relaxed;
	bh=2vWWNILsfAg8ewsnAFqhrqjRUSHcUktM6Bl/npm3fSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=O+l7JXJfrg4QYQtKsVIhTyUuhmY/2Zkgr/mFOw+XFGUIH1O3SNealGGojCCyVdKzQAhDXXug5BTk0yc8ZLvI5F4R+An/MC1UK3mRVgeGGdU3+X7JSn4mZUAmigSSN7oXPFeM/W2u2KJ3GDhANzSccf+Xbh02qQSfQffr32FracHM7ElS3KH+WhjJcAsZBb1uxF6vbjmnsSj3coPktif6E5n+xKGdMtdaVDaZS+cqw3we6b7UV769s6GWes/gkqy05sKLZR/gIN8Grm3wsXhEkmXIuBCAreQ25QGBMEWyKpoecDCtOg9KkTGykXF17L0pQa/tXPTrfJgKDNM3+QxrMQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=eQg96rwm; dkim-atps=neutral; spf=pass (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=eQg96rwm;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4bdy9X0mfkz2xsW
	for <linux-erofs@lists.ozlabs.org>; Sat, 12 Jul 2025 02:39:42 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1752251978; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2vWWNILsfAg8ewsnAFqhrqjRUSHcUktM6Bl/npm3fSk=;
	b=eQg96rwmP95mBbdoQyUR9lNDx9qKvitFyBi6ir1/ROFa8IV+TaGRSzBodUHd4X09XcvdrwgVJiyqYcF12d+7OKu4eHE6VFXOYyaFCEJiEhtoPvpYyZF/dUTjwYk+7vglkufX9QACH39MT01CPL3Ra3U5sgj5fJ/pzD3aYjkKiMU=
Received: from 30.170.233.0(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WihWHzu_1752251974 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 12 Jul 2025 00:39:34 +0800
Message-ID: <234da676-1ba3-4824-9fd4-cd9b41de48b5@linux.alibaba.com>
Date: Sat, 12 Jul 2025 00:39:33 +0800
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
Subject: Re: [PATCH 2/2] erofs-utils: lib: add guard clause for
 z_erofs_compress_init
To: Yifan Zhao <stopire@gmail.com>, linux-erofs@lists.ozlabs.org
References: <20250711161615.44832-1-stopire@gmail.com>
 <20250711161615.44832-3-stopire@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20250711161615.44832-3-stopire@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Yifan,

On 2025/7/12 00:16, Yifan Zhao wrote:
> Currently, `z_erofs_compress_init` allocates heap memory for `zmgr` even
> when compression is disabled, causing a memory leak. Let's add a guard
> clause to skip this allocation.

I think we should free(zmgr) in z_erofs_compress_exit() instead.

allocates zmgr is not a major issue, but I tend to cleanup
`cfg.c_compr_opts` and even `cfg` soon.

Thanks,
Gao Xiang

