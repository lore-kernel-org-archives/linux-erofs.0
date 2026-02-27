Return-Path: <linux-erofs+bounces-2442-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D36F5FD9E35
	for <linux-erofs@archiver.kernel.org>; Fri, 27 Feb 2026 03:42:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fMZ011ySnz2xLv;
	Fri, 27 Feb 2026 14:42:25 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772163745;
	cv=none; b=c/9DdC+88fpEArtoddPHMQR6RFbFZODDOTyp/IHXtXxoSh4Bp9PvebUHybrtYqHtay8Xf3a6kW9RH+MqFgeVy6KCOKJA7qdmRuhQSDllZovzIeahthI1NapdKAFq9MuYi2I4EDFbNvlvEg4Og5Gq2D1MhZsc/t6wjLlwngl7tdekV5RxeofjMHkfX4hl7X46Lb/Rp9QglznLf3Qdy2BEjK3KU3MntAY0n7Zo8mG6+ZlRjUAf8il9P8PTIB49JZXDihv97lXnzBZjgVOgYuMAi72shw0myjuVVj6RthX0ezyfwH70yUDwUvmtXr8WwnlBDSGxLu6884H3OH0KoD8gxg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772163745; c=relaxed/relaxed;
	bh=crOioJu6SFwPEaiEa8fpsovdT++/sxwD6/acncd5gFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CMW1P8DuvoMwe5Xb44OpefJTfGGXyU+pPfet4AmC+zLfN36n1EpSVkpIoEjn8kVuGkIn9WsJrw5cChoFsiwc4C8eVzOdZrbxf8GNkUn99nntsCqL7oeq+Eh5TuHYuvHFm9AiTNRDpYEDze18qOaAGoMCQHkYkjbCsYeXFyTWEHQJW/PdrZ1iCvY1rct1LD81VIwCpl7gNwMaaiDlYbu33hAECJ2ZU3mhU5eqnviSKKQY5OV73hpM/bwzIxSKR2EWEvVxbsE23iJv+PnGweBOZ6gS86qHoQUZYPE9i4ICC+lLREvSA4xrx7r3FEiBwGGFqW7yIKDIeS5MPkseSGD2ig==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=j09hpJS7; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=j09hpJS7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fMZ001nJFz2xKh
	for <linux-erofs@lists.ozlabs.org>; Fri, 27 Feb 2026 14:42:23 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772163737; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=crOioJu6SFwPEaiEa8fpsovdT++/sxwD6/acncd5gFk=;
	b=j09hpJS7F8pCVSLwZGR7Xja8UeJtSN4UENHACqikPE+PBo+wjyEdYbI2hIfYr7gEgP7m76bd3ygKEmWTpPGLsFOwCSwO/bh1W5CyvR8TlIbVoDFl7xt4uDrvCSeBwa04Qsz5q5WP1zZj1uW29Qx3dcurMLvv5zNda9yPaer1atg=
Received: from 30.221.131.231(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wzss4rE_1772163736 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Feb 2026 11:42:17 +0800
Message-ID: <0fd7e92d-1d01-4ea8-82cf-8a9fad5cfb6d@linux.alibaba.com>
Date: Fri, 27 Feb 2026 11:42:16 +0800
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
Subject: Re: [PATCH 1/1] erofs-utils: mount: auto-detect platform for OCI
 recovery files
To: Chengyu <hudson@cyzhu.com>, linux-erofs@lists.ozlabs.org
Cc: Chengyu Zhu <hudsonzhu@tencent.com>
References: <20260227033444.99576-1-hudson@cyzhu.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260227033444.99576-1-hudson@cyzhu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/2/27 11:34, Chengyu wrote:
> From: Chengyu Zhu <hudsonzhu@tencent.com>
> 
> erofsmount_write_recovery_oci() writes source->ocicfg.platform into
> recovery files directly, but it could be NULL when not explicitly
> configured, causing reattach failures.
> 
> Fix this by falling back to ocierofs_get_platform_spec().  Also
> refactor it to return a compile-time string literal instead of
> asprintf(), eliminating the need for callers to free() the result.
> 
> Signed-off-by: Chengyu Zhu <hudsonzhu@tencent.com>

LGTM, will apply.

Thanks,
Gao Xiang

