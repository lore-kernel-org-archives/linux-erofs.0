Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5F3ED12D5C
	for <linux-erofs@archiver.kernel.org>; Mon, 11 Nov 2024 02:28:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Xmtl601Sxz2yZZ
	for <linux-erofs@archiver.kernel.org>; Mon, 11 Nov 2024 13:28:34 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1731292111;
	cv=none; b=k2qTQgDsDXY7iJnR6KLgIZlbJHhTsIhGNTUJdd1Xn3WHz1htiPV7rl2EWjoG7ZoJkafnOkI+xzR8pL0UhFtxfW4+5Ga5rIG4l85b3H2oEJeOckY7kxA3MkH6imatSw3ETtkWfmjA+L9zPc/Ynnda0F3F2sAZHiurGFcmlv2WuDHVFn1Dnucy9OMRTZhw5K7bMap85XUO3RYKouJnGnjwc3qx6LYFYgnZSHSWgf6Nqi92L+fBt6QO/f9EM3tbL4/jzbxNu8LyX1UrJYLXnanltfxWFgxPJy/FAneGvGnTv5VXo91zlKXVjHim4NovA0RGiNglS7ZYShps9yZ0ZDOENQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1731292111; c=relaxed/relaxed;
	bh=bANbxY9BmAz7NXQK5ofkVWL88hJguTT5ljf1WDdn6Ag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dgzgjJDPpiHKKqkd4fzjkclZ50npO2RBW7Okdggu5vJLJg+DmqrSwmAXZDuiFY93LxJDF71GwXjelFdfJSdt2b9d5TZidNG7MvQqagOu64NEg0cJiG05GBdgepCq94sjD8kdCCXXXnoHVLa3QMVkI0xgw+/2IqFwiISQn/hCkIHPy4LTNvZKAaVfRoMiyqFcCbjOlTuKJ+qkH/lmMw9GV10/7JM76s86/f44aQf9UcC+KW2llfKJxFK0QfZxfp+QmO3dZqUjj4s7dZWHz9TIXP0QmMakMky3rOoNR23tBpF1Ku7+GOslpuIbbYgVl9MVO1Zak6S4OIPWgY89JuuZjw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=T8mV35/b; dkim-atps=neutral; spf=pass (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=T8mV35/b;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Xmtl26Vxqz2xGr
	for <linux-erofs@lists.ozlabs.org>; Mon, 11 Nov 2024 13:28:30 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1731292106; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=bANbxY9BmAz7NXQK5ofkVWL88hJguTT5ljf1WDdn6Ag=;
	b=T8mV35/bWwi+pXLKjBfmEGF6BjoYdN1fMbONpvcb8h9Ni8MzHrJEZ2Kc+k2FL3YniXFRWy31OU7rIw8ywu/CwxqxdX0yZAJ6ULALvjpaU7xMCyDp7Z2SvsUhPDyrQxLw3Q1MuYajl+GQzQOe7th+bUwyGaOSXGAxcN7QHUUtIz4=
Received: from 30.221.130.244(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WJ447SW_1731292104 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 11 Nov 2024 10:28:25 +0800
Message-ID: <0fa61236-e84b-4a3d-9804-612b33d166da@linux.alibaba.com>
Date: Mon, 11 Nov 2024 10:28:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] erofs: add sysfs node to control cached decompression
 strategy
To: Chunhai Guo <guochunhai@vivo.com>, xiang@kernel.org
References: <20241101124241.3090642-1-guochunhai@vivo.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20241101124241.3090642-1-guochunhai@vivo.com>
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
Cc: linux-kernel@vger.kernel.org, huyue2@coolpad.com, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Chunhai,

On 2024/11/1 20:42, Chunhai Guo wrote:
> Add sysfs node to control cached decompression strategy, and all the
> cache will be cleaned up when the strategy is set to
> EROFS_ZIP_CACHE_DISABLED.
> 
> Signed-off-by: Chunhai Guo <guochunhai@vivo.com>

I guess remount could also change the decompression strategy?
Or there are some other concern that remount is not usable
for your use cases?

Thanks,
Gao Xiang
