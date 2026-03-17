Return-Path: <linux-erofs+bounces-2773-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F335FB5EA6
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Mar 2026 02:10:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZb5L2Vl1z2ySB;
	Tue, 17 Mar 2026 13:10:14 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773713414;
	cv=none; b=DgrFboA0yV6JzQ9BzvjKCFSsXF9RV0eD/x8AdlVAOuYQAWMH4teUt6OxamP8OZTm+tyTCH4cBrNWtGcK9ni21vtbQWps31LS6l6mrIWMUnRBA7K9t4A5eULof3ixNghtSfEKJDDScHAg/bQadPcpr1fWubH4r7krzipAEMKcFGTCNXj5IGsT+hhT43IMs99MHyDzqiQAlkDR8W6vAD5fJNBYy/ZJdRM3ICUmoQy5sXWfz0mJ6X9+F7DQS7fmRZsM77j6OvQephpxmWkIX/BLHkILone+UIavIEEm2DJ/YZ20A7l2Ei34d8QJxdALjgY9+bx28aKC1RS6za3yXSh3rw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773713414; c=relaxed/relaxed;
	bh=Q8CKSjfOEwiyYS2a3MWKW262aZN7KU+V42ZaNMRS9bc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RwSk5UvFDxz6Q9weQwg+10DGCcNqrnkzY2mPYf9cQosivyYE9nLzRtoUmtXZX6NzQ7exEiDvh38Y4NQqEugxR04lULwilltHJOW5TaHUvFz1KmtMu+bt4DLBz2n9XIfOCuWxIh0Fyp54J6jt1aqZKvzLU5Pun7pPJeOtf1u6dF1qh610lBt97HdBhH8Y/H3FrrH2OC5WGMQ23B90d8lUDjJmGDB797DUebK1SYuX31Ip02IQ5HWviwpcN8bPFLI/aHxEZM2Qo9ijlzFtuXdtFetjKdzr7AViLDqGD7z1oOFNxwuorj8+GyP7Etea/5TipEl5h4C6DLLcqTwFxXXI+A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KcULD7hI; dkim-atps=neutral; spf=pass (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KcULD7hI;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZb5H2tYSz2xb3
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Mar 2026 13:10:09 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773713403; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Q8CKSjfOEwiyYS2a3MWKW262aZN7KU+V42ZaNMRS9bc=;
	b=KcULD7hI/i4MPsZPzrxA9Wkp1BLarz2wt4jKQ+dYok7MBh5pHsyemdWP1+YRUH5U7MIgRpaQBei2L93iRizWOXAanM1Klw7l9CNmtNy75GLhMhMGFFG917cti/yUwF4cLzHXvDjRD3krOBJkqH2urysabesfHBfPE3/u5L+NEVY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X.9Gvpw_1773713401;
Received: from 30.221.133.143(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.9Gvpw_1773713401 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Mar 2026 10:10:02 +0800
Message-ID: <70da1a5c-8365-46a9-8c89-a3f451a6e257@linux.alibaba.com>
Date: Tue, 17 Mar 2026 10:10:01 +0800
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
Subject: Re: [PATCH v1 1/2] erofs-utils: lib: validate ZSTD frame content size
 in decompression
To: Utkal Singh <singhutkal015@gmail.com>, linux-erofs@lists.ozlabs.org
Cc: yifan.yfzhao@foxmail.com
References: <20260316212847.57030-1-singhutkal015@gmail.com>
 <20260316212847.57030-2-singhutkal015@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260316212847.57030-2-singhutkal015@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/3/17 05:28, Utkal Singh wrote:
> ZSTD_getFrameContentSize() reads the content size from the ZSTD
> frame header in the compressed data. This is untrusted on-disk
> metadata, independent from the extent map that provides
> rq->decodedlength via z_erofs_map_blocks_iter().
> 
> A crafted EROFS image can set the extent map to claim a decoded
> length larger than the actual ZSTD frame content size. When this
> happens, a buffer of the (smaller) frame content size is allocated
> and decompressed into, but the subsequent memcpy copies
> rq->decodedlength bytes from it — a potential out-of-bounds read.
> 
> Additionally, the ZSTD_getDecompressedSize() legacy fallback
> returns 0 for frames without a content size field. This leads to
> malloc(0) followed by out-of-bounds access on the returned pointer.
> 
> Reject frames where the reported content size is zero or smaller
> than the expected decoded length.

For this kind of commits, please add reproduciable way all the time.

