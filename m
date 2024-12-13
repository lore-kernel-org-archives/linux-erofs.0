Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D08CCE7717F
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Dec 2024 00:50:19 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Y8W2y0kxPz3bPR
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Dec 2024 11:50:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1734051016;
	cv=none; b=K80rPykvBGBQA1N6lIhS+61fbBqV40f4zxKSkhxIwUjihibf4BgMmRsg5h2+DHPRmiu60rvOLu/0ceTW9VtN1NJCzHgciCHFNmBYrJX17fVI41cFFfe6b6X+PGIMLsRWbnm9TZ3s0pZRYAEcdh2JHrJ35hCgVfE6yU7EXyLw8sm7nrTIbcLgKuv5E/OyP0paHigTa/zE0xjPuqJxdSedSpc6S13J08jVbqkxoO14peHsvrzdegtTRY9svONL4h4EnNJR17W/eZRlc0unILflnfZjYo4sHnu2JDQlJsw4RY/fZdO6saiUHBmcQv8b3iKceI54Ac5O6KswnCVMrzTM/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1734051016; c=relaxed/relaxed;
	bh=Ty8EZNmVKAJdhiCOUndN34Bs9JOCI73WRxvTNPMY5hs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lPz8XLIPwldD4MaI8OSDNH6TP5u7QQJ+8LInrXS72ohqD81QDnxFXhWsEbJYmwS2IjRzQI0MVgkAsvt5rtNGz857X1Rav7zT0OGWmrZX6WJF4y1tqLnrCDFn0h65f4XgmWX+RrvR+2hbbfFTh2CW7zHWchCAgs3eBhyvgE/YeLSzdjEzEzMy/L6bATBCK++mVxLysBF4B08dMdi//KZatPHtSyPyWNea42kjfu7SYjk1NuZdyhrRA5wDLYesW0OEuz7NdACJZl8yScqCpqsGtkVAqivEGZMIIXcdyopuAHsfsKfGoEOBqz+tH+f3hfge6v46TquuHg9A00TDnQpamA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=OZsLpUaE; dkim-atps=neutral; spf=pass (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=OZsLpUaE;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Y8W2s5CYJz30Wp
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Dec 2024 11:50:10 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734051006; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Ty8EZNmVKAJdhiCOUndN34Bs9JOCI73WRxvTNPMY5hs=;
	b=OZsLpUaEbHXf+bb/+A89Nykpu3EK4BiFCmV+YNJFKG0aY+PYxawaloxEqP341iVBi98uGuZsGEgK9b42q2SyRfmB5ZXsLprX6RV35+sEmPsfOMtvD1K1PgToA1lpFoReuT6ihFUaoOhetSVcWt3EVDkvMox9oVpyowpNMGeytTQ=
Received: from 30.170.86.122(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WLN-3t0_1734050999 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Dec 2024 08:50:04 +0800
Message-ID: <d7155d5b-3259-4cab-97b0-95ed267d7468@linux.alibaba.com>
Date: Fri, 13 Dec 2024 08:49:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] erofs-utils: add --hard-dereference option
To: Paul Meyer <katexochen0@gmail.com>, linux-erofs@lists.ozlabs.org
References: <20241212165550.58756-1-katexochen0@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20241212165550.58756-1-katexochen0@gmail.com>
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
Cc: Leonard Cohnen <leonard.cohnen@gmail.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2024/12/13 00:48, Paul Meyer wrote:
> Add option --hard-dereference to dereference hardlinks when
> creating an image. Instead of reusing the inode, hardlinks are added
> as separate inodes. This is useful for reproducible builds, when the
> rootfs is space-optimized using hardlinks on some machines, but not on
> others.
> 
> Co-authored-by: Leonard Cohnen <leonard.cohnen@gmail.com>
> Signed-off-by: Paul Meyer <katexochen0@gmail.com>

Thanks, applied.

Thanks,
Gao Xiang
