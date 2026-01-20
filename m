Return-Path: <linux-erofs+bounces-2085-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09367D2ECF7
	for <linux-erofs@archiver.kernel.org>; Tue, 20 Jan 2026 12:29:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dwRTm3zjWz3bfV;
	Tue, 20 Jan 2026 23:29:32 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.226
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1768912172;
	cv=none; b=SWV9R213FqlAvpvmwDiydqmSq53bfuUXiQVrwTQzD8m7aG/IptDjy1Kd72uUHM28NjuKiFyMuMbZaRvcLXI8KVtqjPtlp9WUt0irR23Ng7Fu3v97/nYMuIMnNCiNA5vWvVKUHS/v9DMUjpfFX2ImAN5tAwxjf2HUqOa77gQfqYxoLtFc8OC5lclQUn7m6TykEWRtzKMcorj+4QKOEtf3KKCz7OANUeyeHqw0QyXCgR4w+Ykzqfex2C+A63XUVXJuRYBrRBnrQD/hkWa28FVGYCpLral3WJBg+GXWgZvcbCvwVG8xIDgfEXbQt1JfsTAyWGwGTNRJVJ5/nk+pzq4KYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1768912172; c=relaxed/relaxed;
	bh=RHupX/CGLY84XH8APP1wF5McWWipsb20eq77t+n+Xkw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=aQq41UCfgHpcuCAZ1Y5VXp+JdHQSG0ZjWwK/f1jZAz48U2T3kTohiYHRWJzPZQbxaPQQfiMQR7aU0v6DF/eSt9gIH6hmj0V1MCltIaxcrO3RZyguDtPRpmPFjDo1zfYnV8LQKmcUNXjEBzisxJLWJ9n9tbGdd1whpxlxQjoFcrCGXE1w3wfy909nNStmez3VHbifEtLVoq9IEtB/srxSQ0Q+9+C60tREf+SVorqGRKzeSkBwIV1o+jbulcroO7zigBt+oLoPw6k51KY5dCrxP8/zy9MB4HoY5QUD4LJSuPvK0XlOuO8eSLtLhaHr8qy7KzHnlOvFafOffMsZ6Jo31A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=bmfDQUpM; dkim-atps=neutral; spf=pass (client-ip=113.46.200.226; helo=canpmsgout11.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=bmfDQUpM;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.226; helo=canpmsgout11.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dwRTg6b3qz3bfG
	for <linux-erofs@lists.ozlabs.org>; Tue, 20 Jan 2026 23:29:26 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=RHupX/CGLY84XH8APP1wF5McWWipsb20eq77t+n+Xkw=;
	b=bmfDQUpMGWMtc+2KYoUEK080qnSyjhKYA5Qz+7QHvfrFjYKpkiYVx6PEJTq5eQsSWu4izlaWD
	PWG4zceSgQefIZUFhlwO0SAVj3oYK0djRvkpjZh3sa4Qfee4/xCaU+7jOyrklZ3Y8V7ncunFQlv
	BDIH0aVY5uk7fnfZrwq0Hxs=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dwRPT4mMLzKm4c;
	Tue, 20 Jan 2026 20:25:49 +0800 (CST)
Received: from kwepemr500015.china.huawei.com (unknown [7.202.195.162])
	by mail.maildlp.com (Postfix) with ESMTPS id 984444056C;
	Tue, 20 Jan 2026 20:29:13 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 kwepemr500015.china.huawei.com (7.202.195.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 20 Jan 2026 20:29:13 +0800
Message-ID: <5aa7566e-c30c-470a-ab77-8b62a3cdf8c3@huawei.com>
Date: Tue, 20 Jan 2026 20:29:12 +0800
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
Subject: Re: [PATCH v15 5/9] erofs: introduce the page cache share feature
To: Christoph Hellwig <hch@lst.de>
CC: <hsiangkao@linux.alibaba.com>, <chao@kernel.org>, <brauner@kernel.org>,
	<djwong@kernel.org>, <amir73il@gmail.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-erofs@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
References: <20260116095550.627082-1-lihongbo22@huawei.com>
 <20260116095550.627082-6-lihongbo22@huawei.com>
 <20260116154623.GC21174@lst.de>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20260116154623.GC21174@lst.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.104]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500015.china.huawei.com (7.202.195.162)



On 2026/1/16 23:46, Christoph Hellwig wrote:
> I don't really understand the fingerprint idea.  Files with the
> same content will point to the same physical disk blocks, so that
> should be a much better indicator than a finger print?  Also how does
> the fingerprint guarantee uniqueness?  Is it a cryptographically
> secure hash?  In here it just seems like an opaque blob.
> 
>> +static inline int erofs_inode_set_aops(struct inode *inode,
>> +				       struct inode *realinode, bool no_fscache)
> 
> Factoring this out first would be a nice little prep patch.
> Also it would probably be much cleaner using IS_ENABLED.

Ok, Thanks for reviewing. I will refine in next version.

Thanks,
Hongbo

> 
>> +static int erofs_ishare_file_open(struct inode *inode, struct file *file)
>> +{
>> +	struct inode *sharedinode = EROFS_I(inode)->sharedinode;
> 
> Ok, it looks like this allocates a separate backing file and inode.
> 

