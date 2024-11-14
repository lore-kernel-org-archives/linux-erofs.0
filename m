Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABECCD637CF
	for <linux-erofs@archiver.kernel.org>; Thu, 14 Nov 2024 01:37:44 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4XpjT26Dktz2ywS
	for <linux-erofs@archiver.kernel.org>; Thu, 14 Nov 2024 12:37:42 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1731548261;
	cv=none; b=UlJ9zHSkRcsrHp9jGmRGVdCwwCoeh5lk0Lrx6kYaI6rZ3MT77KabPod0jGNJscRwsCS4T/EhbzXFci8NXaLDhzHtEL5E7p+Ks5hDrwQISUykQn3GMhhL5VadQWMJ7VoKNIph2u4h2Tv2nqk03gcua/iFHpghKxjPROST2U3IfGZO9oVs48rJ87i3auhGfiQNgqFlRkZHc70rVww/fR6ZH6XDP2mei/WDyEqkKQKoU3ZIhFrWEV4L6n6SKgeVftXKvR8CPgaNlPoIPxHjTIPIKDknSImafyyuZthvNKsrTdu3BRMn7nA83okLvThrbKs6mxtTLgJwyDjg7sQFBIvHcg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1731548261; c=relaxed/relaxed;
	bh=lsAGW9pjTFb8tNFD9mQMBYghnGRdFWUFmaeRR+RpZMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sf6+DYNUDwnAGrLtQpnlZH/XM5u3ZHN9kgM7vpx+AXVgBRmnQlFp29335DQPjJ/kWRsH8s7U4DeFoLB17tUuduGC68i//tVBVmtGk3ljswm9cRKxy7DUScCc87sqBghwG3S4aGVF35FAI/9Tm3EVAzBNnNL7/JKMFhWNJsWv2XcYuO/hJBqtHgzdMct9bYW0wtnoy+atiwQ0EEyDHBk/khR4EMby+Ti302e6FYaG7sUImKoFHhQZRPRVrTtNm5B+BpuGnakzXTYTMugBlnH7pkVDPbS7a7ZvX8aDGt54f/GWFXypm3Yp0ItZxNXQjMVWUJS5mt/ReCbIyI2E5KXsaw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=T9uOC7wD; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=T9uOC7wD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4XpjSw4vzmz2y8d
	for <linux-erofs@lists.ozlabs.org>; Thu, 14 Nov 2024 12:37:34 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1731548249; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=lsAGW9pjTFb8tNFD9mQMBYghnGRdFWUFmaeRR+RpZMA=;
	b=T9uOC7wDMYMcBqodhMHpYRRYzFZ6TdgCJGBdAn3YNYEQZ2B5CDN0uJt9UfJ3BN/19U9GkFg4JtyZ4YnWqgKoewTNSVu76dG0ZWSF+ylRlY9/6QJdeCS+amA3H2nygCdvCm86UGvBtAEh0bfV0DMjVYzxXgwOL6GcgRLHlTuC7ng=
Received: from 30.221.128.214(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WJMVDwZ_1731548247 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 14 Nov 2024 09:37:28 +0800
Message-ID: <3651782b-e65f-4dd3-959b-0b122cd596da@linux.alibaba.com>
Date: Thu, 14 Nov 2024 09:37:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] erofs: simplify definition of the log functions
To: Gou Hao <gouhao@uniontech.com>, xiang@kernel.org, chao@kernel.org
References: <20241114013247.30821-1-gouhao@uniontech.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20241114013247.30821-1-gouhao@uniontech.com>
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
Cc: gouhaojake@163.com, linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2024/11/14 09:32, Gou Hao wrote:
> Use printk instead of pr_info/err to reduce
> redundant code.
> 
> Signed-off-by: Gou Hao <gouhao@uniontech.com>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang
