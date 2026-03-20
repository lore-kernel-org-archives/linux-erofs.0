Return-Path: <linux-erofs+bounces-2875-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FAFD109316E
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Mar 2026 05:30:22 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fcWNs0wzVz2yY1;
	Fri, 20 Mar 2026 16:30:21 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773984621;
	cv=none; b=VRR7DeCytC+FvwkYNoVRPzIWn+MiHatwSMzhe/BL0DVzfZAaWBPSmlCT0IB6W35uWupg+wivgB2aozIbf27Ub5fiD7/S5Is8nuiKJD1qHyWwshLadiQfS5MT9eszQEleGuHBnbVLKzVeyzWkfd7tgV2HkUIV4UeQ0fX+OxXxiM9uhblFgUXG+tYi9PbBMB4sKDDH8Rt43tBpRKrnenwSD7SJfZVCvO+Uc3ycm5TsR3QXVrQgQipVf/BBVKJFXHmnnZLOo93dIcQX5IxTd4t7dmt8BHQQymNlnRDlcH75lGn1uQsc7CWMOSVxKT0o+xF0k/yuhpGmqGdlkjGh05bl0g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773984621; c=relaxed/relaxed;
	bh=srQtCqjm0ScOIPXio+EDB35KZ3T4riRMFxbfwTNFrrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dqDv+7/2DU0HAwhs/rwpe8DQifnvmdJ0QRBuJvcONpFIao4JVkO2U1INgss41vw0E7V10L36nCZri50e7+S7IKnFPkZEIKxxZiRWIQzEumA2WYgo3g4sxezMy+tW//JBV78IXySUkB8IOEPtLODZg1UCFHP/iIA6tsot2Nhb7ptJbm1oJBA6rr8DLk8JOdvJQjiDB+QyVlcTUrNvP/5x951RsP0KF+VWdlgzwmgqD/RisX2qi9MN/oeXYEe1WjGZxbK3ip6VCTyNrdRIhdY+zogB2xnMVrvYqsE8tpLZw8Ipxy+cal/UAD6izUOEB/2QQVZ5PpaVJ3cGSZuGYQ4Dmw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fD80ehFR; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fD80ehFR;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fcWNp515lz2yWK
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Mar 2026 16:30:15 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773984609; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=srQtCqjm0ScOIPXio+EDB35KZ3T4riRMFxbfwTNFrrI=;
	b=fD80ehFRxa/BAXON1sZJcdKBGcqzmwYwvEMDxtVX0DsQmv/t6eOSjKdYAqJ3xOWdVSrP7PzRVla5aybTAAxO4S3NkkICUV41n1s7lQE1pjYpT0QB3SwxteJXehYrU0CYp4Ndiy6YY9ZmovJCXrFmwNPUGAyKjQJL7ULRKxTOvcA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X.Kgl8a_1773984606;
Received: from 30.221.131.211(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.Kgl8a_1773984606 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 20 Mar 2026 13:30:07 +0800
Message-ID: <7f6d31c2-67f5-4233-91eb-13385582c300@linux.alibaba.com>
Date: Fri, 20 Mar 2026 13:30:06 +0800
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
Subject: Re: [PATCH v3] erofs-utils: decompress: fix QPL job leak on error
 paths
To: Vi-shub <smsharma3121@gmail.com>, linux-erofs@lists.ozlabs.org
References: <20260320015947.2325-1-smsharma3121@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260320015947.2325-1-smsharma3121@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/20 09:59, Vi-shub wrote:
> Two early returns in z_erofs_decompress_qpl() after a successful
> z_erofs_qpl_get_job() skip the cleanup, leaking the job handle.
> Use goto out_inflate_end instead.
> 
> Signed-off-by: Shubham Sharma <smsharma3121@gmail.com>

LGTM, will apply.

Thanks,
Gao Xiang

