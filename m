Return-Path: <SRS0=FCDp=XM=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A34C4CEC9
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Sep 2019 15:24:11 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A5F6621881
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Sep 2019 15:24:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oXtK7ILP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5F6621881
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46Xn2b2w1PzF1df
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Sep 2019 01:24:07 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=gmail.com
 (client-ip=2607:f8b0:4864:20::641; helo=mail-pl1-x641.google.com;
 envelope-from=blucerlee@gmail.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.b="oXtK7ILP"; 
 dkim-atps=neutral
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com
 [IPv6:2607:f8b0:4864:20::641])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46Xmrq3qcYzF3t4
 for <linux-erofs@lists.ozlabs.org>; Wed, 18 Sep 2019 01:15:38 +1000 (AEST)
Received: by mail-pl1-x641.google.com with SMTP id t11so1685166plo.0
 for <linux-erofs@lists.ozlabs.org>; Tue, 17 Sep 2019 08:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=subject:to:references:from:message-id:date:user-agent:mime-version
 :in-reply-to:content-transfer-encoding;
 bh=+4isRbZsHm6lIrd4ri3Rb0sRqFlVW5TIVj9N4yPwpu8=;
 b=oXtK7ILPVK3vpo3SEZCLzJf3fLbcgtNpSPfNgdNLC/OnzftZ7gP8iBt5iy8erWHK4n
 uR9AbEO4SBMJP4QMma6Qihx0zu168eDGOKTojWZvK9QBVCd/XjXzuztZWlQDOtyTsLD9
 v2qc5lZ0KjQ2pZn5T4nUfBwDKXQfD9E2OmAmbPmxQVTJPd4TbietqWJjsl8/rLh3CvHn
 7l+Jfg5sNEwvKpeQ2A4Tc6ekzdmlpxO7GecL2+l6colLw/zrsIDXy2UOI1xoXzympiBx
 XiR4By2xU8aUf3MlUhn6GOjcBZvSv1NlXG4mH01UZ0zIG1VAcxZSBwfJuwAAFkJrcrCM
 LwVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-transfer-encoding;
 bh=+4isRbZsHm6lIrd4ri3Rb0sRqFlVW5TIVj9N4yPwpu8=;
 b=L8OG8Oq/+HCrHjV+rStDKZB+M8IvYKJM58OT7y+FYwU75igU3reTj0oyBf2r5ZzXhd
 XhGErUYlrn9RpwqU9hdYeGTh4tkWkeWk1oc7M2H2KjnyCjtW05vWgdY24sQFIBHFjDB7
 77cgh5ncXIlqXZgY6hwWESctCwjJIjlFVtep6X0o84aDca6BW8bHSh1jv4EKNx76WBQv
 xiKrJygrI4QTv1UJi9ED5xCNUUTRzOuxGpUdrxXvyI85BYrdaKjvZ9eQHcn77thN3Tyc
 I1Gk2rS9oU1YpjKXIg1uFqQmnciSnYfJTjSlxxXD50dRh4LKdWPf4T3dCQ7Ia/SftWGI
 eE9g==
X-Gm-Message-State: APjAAAXH/tjJ78UfDXUaMRPa2paL+IIEhtHEWryZm6ptKG8cxincHrsh
 FIAFlc3/iXg6FnWlXlKdhTg=
X-Google-Smtp-Source: APXvYqwWVymujUzBsQl53TCYcqeZCgJBaQWp235H19GpYMZOAW2GoEB9V31rx3vPBMvM1CAMbUUPoA==
X-Received: by 2002:a17:902:8f8e:: with SMTP id
 z14mr4271485plo.3.1568733333586; 
 Tue, 17 Sep 2019 08:15:33 -0700 (PDT)
Received: from [0.0.0.0] (li1140-19.members.linode.com. [45.79.41.19])
 by smtp.gmail.com with ESMTPSA id g12sm2277452pfb.97.2019.09.17.08.15.26
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Tue, 17 Sep 2019 08:15:32 -0700 (PDT)
Subject: Re: [PATCH 1/3] erofs-utils: complete special file support
To: Gao Xiang <hsiangkao@aol.com>, linux-erofs@lists.ozlabs.org,
 bluce.liguifu@huawei.com, miaoxie@huawei.com, fangwei1@huawei.com
References: <20190917054913.24187-1-hsiangkao.ref@aol.com>
 <20190917054913.24187-1-hsiangkao@aol.com>
From: Li Guifu <blucerlee@gmail.com>
Message-ID: <f06ac672-4bcf-54cb-3894-2e5008e146e0@gmail.com>
Date: Tue, 17 Sep 2019 23:15:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190917054913.24187-1-hsiangkao@aol.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



在 2019/9/17 13:49, Gao Xiang via Linux-erofs 写道:
> From: Gao Xiang <gaoxiang25@huawei.com>
> 
> Special file was already supported by obsoleted_mkfs,
> let's complete it for new erofs-utils now.
> 
> Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
> 
It looks good.
Reviewed-by: Li Guifu <blucerlee@gmail.com>
Thanks,
