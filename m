Return-Path: <linux-erofs+bounces-3282-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0502F459EF
	for <linux-erofs@archiver.kernel.org>; Fri, 10 Apr 2026 15:44:08 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fsh1M45WGz2ybQ;
	Sat, 11 Apr 2026 01:44:07 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775835847;
	cv=none; b=eH/lb2n4rYj8RByLXKRBJpF7s01q0fm6T0fOzUVIJoRPWslH2RhqwmsYOMTnuhQz3fDe4B7lsgXB0f0jw22WXGrg83zPPdtaxJf/3c9hPAmhUfnrIz9ILReJO62vksp6gr/i7Ujckr2wdlkTbONUY4mvAj+Mi6bm4UTUAUCJML/ux2fwHJ+bBU/jiOgo3+JEzZWYW8CmFvnWvzkcr7B4TudPIJsuKJFgfKOYT0XcV9jVd8G2L7WUKZ2Onc64fOTqFBuYXHOG/6QXBJJEGaJORQiYU3xiMXurjcWCBnzm67z4R138IXFMSttpZJpTTp30qo6q7DLe4UPCmliL+V9NZA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775835847; c=relaxed/relaxed;
	bh=uzBjKauimcNkCmJqc+wHQN1oYZwt8Xn/+9mNyLG5eNY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PTNRupTrqB8uH7N4wz27JQ0Q944s2E8qklyux5cKFEJeJPrdc0yvXNj3Jc0LP6XQXLMNURwme/OOQwEd/rC9nHpDyUnpHeiPyvK7PknJgM/euhmRHAtVY3iJWd+fYKafZ2dDHmrVLwGJZ41A45HX7KTP1TxJJh5YM1H+Znq9VFYgCGsPgpkjni2NAmA41HRDPPZq5a9IMS17+Lklyh0E8SAxYYVTRG50o6lMdRAS8iq/oMyxSnubdzaZwy2wfql/OOdRQxZ+mpCeI7T9+aBA7t/Dau26oUs/JbGY99hlUoYqBSRoWiED3RJbwA16sR3RdOhWSJJh7W/h8CZ2aEhrmA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=GcfKFEV8; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=GcfKFEV8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fsh1L4lzNz2yZ6
	for <linux-erofs@lists.ozlabs.org>; Sat, 11 Apr 2026 01:44:06 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775835842; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=uzBjKauimcNkCmJqc+wHQN1oYZwt8Xn/+9mNyLG5eNY=;
	b=GcfKFEV89f6o66JOUAt5gFbqOLP5cb75vI8Mb4mUUC4izyX7dOGGz43qplr3TDEZCTh4RiECbUS3/ATB9CdOmUqOGSjJ7YIZAdN99sgMUmVNwxzurOziwdK+RA7YrdVLTdzGGVvowzPGhdGAMIuRAsIbwvDUIwYgl2E8UKHkR0k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X0lcA7z_1775835841;
Received: from 30.41.54.139(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X0lcA7z_1775835841 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Apr 2026 23:44:01 +0800
Message-ID: <67764de1-3eb7-4e61-a382-d5f0bdcd3a30@linux.alibaba.com>
Date: Fri, 10 Apr 2026 23:44:01 +0800
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
Subject: Re: [PATCH v2] erofs-rs: fix inline xattr size for tail offsets
To: priyena.programming@gmail.com, linux-erofs@lists.ozlabs.org
References: <20260409154835.18533-1-priyena.programming@gmail.com>
 <20260410154136.16916-1-priyena.programming@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260410154136.16916-1-priyena.programming@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Please submit PR directly to  Dreamacro/erofs-rs.

