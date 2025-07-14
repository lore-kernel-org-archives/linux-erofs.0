Return-Path: <linux-erofs+bounces-606-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67F07C83F1D
	for <linux-erofs@archiver.kernel.org>; Mon, 14 Jul 2025 03:15:49 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4bgSBX088Xz3bpS;
	Mon, 14 Jul 2025 13:15:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1752462947;
	cv=none; b=B1XF33Om6eG1T6iPj7kDVYiuI3m7+QaKKtKi7n593ONuCXHpaLSQSsg3pWl7YSjwDmBu233yZQiWkVEowtV69qb9ByS12X1K0g9nNA1sBwUr31DqWWZATCxLqHECA+Jae0ZZrW8GdeyMpcfiQix3efRBgoTVEEcCCT+RzC0b9/F95mC8w+pk0FdY2/dzCrtVjLrDdX966kZgHhq2fW5pN/Gdarbu1A+cd0M8WnHjq7M/2Z7uUChgRD049G/LqCdxnBJTdUfaE+uomqYaAY+5njU2uvj9FMCGWruQVq1TEY/EVJqKM41nE+9qyfMfXuZ9Ntiu9V2QFgNUffzE5y5Hkw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1752462947; c=relaxed/relaxed;
	bh=FENEh6unhDrJM6ycBsaGIIgxr+/jbcbzF4ckXjLx4MM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MzwlEAjq0BadOXZTZp8ATIDwDlZaPW5pcxnhoCfN7KEVUmP0M/3URiwUDUMs/PAU1yWG5hhET6GP+dcyOGJMWzvokrYxLr56H5mCjtYGUiTBFkOXODVfAVBWYHRalfUNG3OrnjzAT7hO+ZTbyU1IjzOEYFedQnLi+mJMgntknTMEDdQqTLwk20vsDCcVOafK64+xKsuP/ZIKP9Bc9B3IZZ28fdS82vE04fUdGKaO/0dKNlVAiPJow0su6qwQNRcaFpBvshMM/41Q4KEQhsS0jRcQ4Cvq8OVxhgwaEM0bjVMjXg11KtnIE+aMW5qR57RZ2E5oxZ1PmkEcIW7XcQ3vbg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=BZwdPQWZ; dkim-atps=neutral; spf=pass (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=BZwdPQWZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4bgSBT5KGrz3bnm
	for <linux-erofs@lists.ozlabs.org>; Mon, 14 Jul 2025 13:15:44 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1752462940; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=FENEh6unhDrJM6ycBsaGIIgxr+/jbcbzF4ckXjLx4MM=;
	b=BZwdPQWZIw8jpviPzPhKAQc5O+nMbL8sroJ7KSLhim3OIz4zLZ8l34vG+7T+FKdYDTs5vZId3nOl80tvIGk7nvSGKQ7D4cjpOltrGycRCdX06k2qHAgR4ryfwXy7Q0Ju1h0EBkmHOtzInrVRJjqEyWw6Gonm9sY7Zj7B3PcwRzM=
Received: from 30.221.131.165(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WioQNfI_1752462938 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 14 Jul 2025 11:15:38 +0800
Message-ID: <b11bafba-fe9d-47d9-9ba1-1b514bd67f34@linux.alibaba.com>
Date: Mon, 14 Jul 2025 11:15:37 +0800
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
Subject: Re: [PATCH v2] erofs: support metadata compression
To: Hongbo Li <lihongbo22@huawei.com>, linux-erofs@lists.ozlabs.org
References: <20250711094004.2488-1-liubo03@inspur.com>
 <054c2678-c8a6-48d2-b10d-f051e86d259f@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <054c2678-c8a6-48d2-b10d-f051e86d259f@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

..

>>       if (!name)
>>           return -EINVAL;
>> @@ -411,9 +416,12 @@ int erofs_getxattr(struct inode *inode, int index, const char *name,
>>       if (it.name.len > EROFS_NAME_LEN)
>>           return -ERANGE;
>> +    if (erofs_sb_has_xattr_compr(sbi))
> 
> Is xattr_compr another feature under meta compr? In my opinion, how about splitting it with another patch?

Just answer this in advance, it should be in this patch, or
as a seperate patch before this patch.

Otherwise it's non-bisectable (and thus causes a incompat
feature) because users could use a kernel with metadata
compression but without erofs_sb_has_xattr_compr, it
causes the connected features fragmented.

Thanks,
Gao Xiang

> 
> Thanks,
> Hongbo
> 

