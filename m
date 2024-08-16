Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F027C3DA4A
	for <linux-erofs@archiver.kernel.org>; Fri, 16 Aug 2024 06:32:12 +0000 (UTC)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="::1"
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ESXl1mq1;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WlXGL6VTzz2yt0
	for <linux-erofs@archiver.kernel.org>; Fri, 16 Aug 2024 16:32:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.112
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ESXl1mq1;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.112; helo=out30-112.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WlXGC60Mdz2ygG
	for <linux-erofs@lists.ozlabs.org>; Fri, 16 Aug 2024 16:32:01 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1723789916; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=zRUbrcom5Hdwq9l6AwT0KEBe13vgWAlIRcuXWLID/IU=;
	b=ESXl1mq1wGMWR2429aTBmc1QhJyl5cxKhsoC/I70mKf0sDUzLUHoGeHJM8Y3X+BmsTnZs2bcPOYiNbGcAop2QSkmneP/6pY8CV9FM9jMIiU9Yftx1Li4IfIanjySkT59I2Xw1nUt4laekl+RZcrISCSP3UmZIpViX3t1AazlTWk=
Received: from 30.221.129.229(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WCzVINy_1723789914)
          by smtp.aliyun-inc.com;
          Fri, 16 Aug 2024 14:31:55 +0800
Message-ID: <bcbf70d8-0907-465b-9b12-22af3a898fdd@linux.alibaba.com>
Date: Fri, 16 Aug 2024 14:31:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] erofs-utils: use $EROFS_UTILS_VERSION, if set, as the
 version
To: =?UTF-8?Q?Ahelenia_Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
References: <gho2b67qax222ewv5xb5cjkkgjgzftr3pyecl536g6jshcfexa@tarta.nabijaczleweli.xyz>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <gho2b67qax222ewv5xb5cjkkgjgzftr3pyecl536g6jshcfexa@tarta.nabijaczleweli.xyz>
Content-Type: text/plain; charset=UTF-8; format=flowed
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
Cc: linux-erofs mailing list <linux-erofs@lists.ozlabs.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2024/8/16 11:05, Ahelenia Ziemiańska wrote:
> This lets downstreams embed the unpolluted downstream version;
> when building the Debian package (from gbp) the resulting binary yields
>    $ mkfs.erofs
>    <E> erofs: missing argument: FILE
>    mkfs.erofs 1.8.1-fead89d91-dirty
>    Try 'mkfs.erofs --help' for more information.
> 
> Now, d/rules can
>    export EROFS_UTILS_VERSION := $(shell IFS="$$IFS()" read -r _ v _ < debian/changelog; echo "$$v")
> yielding
>    $ mkfs.erofs
>    <E> erofs: missing argument: FILE
>    mkfs.erofs 1.8.1-1
>    Try 'mkfs.erofs --help' for more information.
> 
> Signed-off-by: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>

Thanks, applied.

Thanks,
Gao Xiang
