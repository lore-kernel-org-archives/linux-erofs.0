Return-Path: <SRS0=S08A=NJ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 703E2C432BE
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Aug 2021 14:12:06 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 05DA2610A3
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Aug 2021 14:12:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 05DA2610A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GqVFw5TfWz3cKk
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Aug 2021 00:12:04 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=hOeFRign;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=chao@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=hOeFRign; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GqVFr4qYgz2xff
 for <linux-erofs@lists.ozlabs.org>; Thu, 19 Aug 2021 00:12:00 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66310610A7;
 Wed, 18 Aug 2021 14:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1629295918;
 bh=AQfgKebWJLpeUBl2arSYIWfhz41gG8NbDvI7MDRVrSE=;
 h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
 b=hOeFRigng7zChfxruaxhq7Uqn6Bx6YDu948lJMmvuy1kzjuMZo8GSDqD2QdERXBPn
 2Uggqe0k/CDDxqPnO1+5pa4sQd8j9rpFSgl6Ayxm0eD9gcpyplPL303fvxW8/U97Jg
 lSexQmYBWQ2M8kd/do8MCkHQkrD8p+uM53SBVZHE6gkP/IV51GsKrmqH6x5cMGL+Ym
 VoPwLpIcKRwPSay8rRrYaJH91HBP94GKgFLmIlv/0KzDPbx+HZxqSiO2qMpKPUdXym
 8BI+9X02ct1IkGXQ0XgaMUl5XRYIbNezqmpj0knFnU3L7oFZ7xIQHOXC8hMkDQ/0fU
 wyonOm5Si/aIA==
Subject: Re: [PATCH 2/2] erofs: add fiemap support with iomap
To: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
References: <20210813052931.203280-1-hsiangkao@linux.alibaba.com>
 <20210813052931.203280-3-hsiangkao@linux.alibaba.com>
From: Chao Yu <chao@kernel.org>
Message-ID: <39e06954-8fc2-3d08-dff5-8e39c97ac259@kernel.org>
Date: Wed, 18 Aug 2021 22:11:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210813052931.203280-3-hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
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
Cc: nl6720 <nl6720@gmail.com>, Lasse Collin <lasse.collin@tukaani.org>,
 LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 2021/8/13 13:29, Gao Xiang wrote:
> This adds fiemap support for both uncompressed files and compressed
> files by using iomap infrastructure.
> 
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
