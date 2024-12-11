Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DB83E7717D
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Dec 2024 08:27:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Y7TH60Smtz30Th
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Dec 2024 19:27:14 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1733905632;
	cv=none; b=lavBTYgk07nhgYEZvwZjlwwSTnL/1r7Qy6+UW9XuWMFLECbKWmXI/yXdGFce4JiuQfbDLeRsfhpQepg2xIAC+AMFQ8ixnpAyMW+cu/UaMcmse4cjwfYOZZUEF7CzIZq0GMBl36qhP+m3MSi1oNF69lRjE+jTGyakaecpnxPznqn0HIx7jnyGwjkEsQeBwdtZpAJafkPadGs4EfHOU2MUc//YVqewG8QBmutht6umt0LCX75eTAPPRIynEIngGgMEB46qMDD1ASKtDYRl9tLqGQE/8nZwu4DJz6BWSqw9b0Z3U3Disj0+MQKssdAPFcwxGdagYk8VPOT8ZhouNEWxPw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1733905632; c=relaxed/relaxed;
	bh=qu6ZJQXtM8l423+WKxjZ38oMaUAOb4QcnD0R42mJevo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CnrOOjSPwPmCvHH/koQP/dPcrpUpgvMPRL0Hk5e+Dg0NL9USBbJ6hsr0VV0FgC0gP4S04g4it0c5E21T5GdTs224z0avZJUBybf5Q99y0CyNd6MEvd325gk/F2VpIbdUHrShqMkgHi0qyPWvZyi8PCIDmE9nmDGpSV9nSZzR198juenNsIUZFaG/Fd45DVwIP39LME9bbn+m+qj8SZwbavFUyJa2UIw20HVcjpWCGKjm+yG1bMwIVj50a7qRGivvOYs5tYk/N/CKLldhp88LJjuD86cFVrBkmOgI7s/BQ19X8GY50IAY+CyRc3/cJSmGMgUBmg44Xg3TJUK0dKtIUQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=BJ18qysP; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=BJ18qysP;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Y7TH05Fn1z2yFP
	for <linux-erofs@lists.ozlabs.org>; Wed, 11 Dec 2024 19:27:07 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1733905623; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=qu6ZJQXtM8l423+WKxjZ38oMaUAOb4QcnD0R42mJevo=;
	b=BJ18qysPwdtZmwNtwtSSo2Rwn7h3lUg2epS1Yrnf3yfr1MOUnJPxKdYv5jDdqF8Zvnq3XXEYCUhG8oW3axq6II8yKbzp0aUAw/rmluZmXMTL5R7Ae7FCwdF4y5bgXxfcANtPBT/jSWNtwsyBj3XwoLNJ7sxYvjb82gFAcTHSrOs=
Received: from 30.221.130.195(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WLHfMid_1733905621 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Dec 2024 16:27:02 +0800
Message-ID: <5ac4956d-10c2-4243-8396-cea01c4d72be@linux.alibaba.com>
Date: Wed, 11 Dec 2024 16:27:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: erofs: update Yue Hu's email address
To: Yue Hu <zbestahu@163.com>, xiang@kernel.org, chao@kernel.org,
 linux-erofs@lists.ozlabs.org
References: <20241211080918.8512-1-zbestahu@163.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20241211080918.8512-1-zbestahu@163.com>
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
Cc: linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2024/12/11 16:09, Yue Hu wrote:
> From: Yue Hu <zbestahu@gmail.com>
> 
> The current email address is no longer valid, use my gmail instead.
> 
> Signed-off-by: Yue Hu <zbestahu@gmail.com>

Acked-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang
