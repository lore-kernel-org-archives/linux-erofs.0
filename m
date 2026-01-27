Return-Path: <linux-erofs+bounces-2220-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E137AD25932
	for <linux-erofs@archiver.kernel.org>; Tue, 27 Jan 2026 03:39:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4f0WPN49zsz2xcB;
	Tue, 27 Jan 2026 14:39:52 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769485192;
	cv=none; b=ng0Kt+1jqCHgObsMjY7g4PRVMzaoybJwy6hWNYgJwb3qL2Uv3DG8lMPI484w/pfVAlgmblgtwb4/TLjvI1ny3vZruDPjeSXkJUvw2TllT/h9DKreppZaz648NUT3S1iACAIGgsReKjH+VIGcJKTydJdOd0Vn2WOvn1UB9yVJglQDlSs///OzYCB+CpucERJbfre3ZWGKRgz6QF0lD4triurTejNXm4SvQAF8bJGga/BRDhVNJNypqcidi4oVBfdoFEUtEA1mHUYPAizNQovgKeC0EEK01stCiEnATagdvcpNeIYjKmYaJJbe88NOksqCCnqGsYsF030uQBEUNwoc0A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769485192; c=relaxed/relaxed;
	bh=JXX/+UhJQ3V1KOHJlhTwhRIDR47qF0HW0feoeATTwOU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CD3GjX7p4BUTdsmd8WiLIcGbHv1EbpyWbhRQ1WFjkRLsNWHmpHkKX8Z0x5JC9Ai7zlwcd4M2XcovqXf4m4R6nIIlJFIN1vLmNCCC5Km3oIMquqYG6ZOdTAPxflxDRUqSqofMpVtDWInRwY6TlXRFDbfZ08Wr/RLhF9f4huX90ZNwTToPgfBq7HH1RwsO4i8nxywzm8vUH0hjXs3N1DUKlxJmYn8b/7SdgPwD8SUG/2ejMIL9UjLkP5pwdFLWzqHeBSff2iE8UFfLUIlHsgyLoGtwbTYQPTwGpCbUeT/B1vxn2EF3tEH3d2R05gBQ38q2Mgz0FI+a0mIlbIZoo6IiWA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=r3BX92s+; dkim-atps=neutral; spf=pass (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=r3BX92s+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4f0WPK5pF6z2xJF
	for <linux-erofs@lists.ozlabs.org>; Tue, 27 Jan 2026 14:39:47 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769485182; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=JXX/+UhJQ3V1KOHJlhTwhRIDR47qF0HW0feoeATTwOU=;
	b=r3BX92s+MVHfrSk3i7qHK7MRbKceyX/55jhbJtstcKOKi3oeFWpoWVIbMsqVyWjODpLc4KdDUCiPuWMhsH3TqQYvZsC1sXbbZ5fmVMZwRAKPF3huddWZgGktP5/eeTJqFzoPFM0TqujZW0DBqOArGOBKKvQ4u7VaA58SSvdnKsg=
Received: from 30.221.133.109(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wy-HAhn_1769485179 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Jan 2026 11:39:40 +0800
Message-ID: <191f6576-ba2f-490a-824d-d27b22350921@linux.alibaba.com>
Date: Tue, 27 Jan 2026 11:39:38 +0800
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
Subject: Re: [PATCH v19 04/10] erofs: add erofs_inode_set_aops helper to set
 the aops
To: Hongbo Li <lihongbo22@huawei.com>, brauner@kernel.org, chao@kernel.org
Cc: amir73il@gmail.com, djwong@kernel.org, hch@lst.de,
 linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260123013132.662393-5-lihongbo22@huawei.com>
 <20260123075239.664330-1-lihongbo22@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260123075239.664330-1-lihongbo22@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/1/23 15:52, Hongbo Li wrote:
> Add erofs_inode_set_aops helper to set the inode->i_mapping->a_ops
> and use IS_ENABLED to make it cleaner.
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>

Sorry, forget to reply this:

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

btw, I've pushed the series into erofs -dev branch for
-next testing now.

Thanks,
Gao Xiang

