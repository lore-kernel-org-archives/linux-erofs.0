Return-Path: <linux-erofs+bounces-3878-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E35DC43458
	for <linux-erofs@archiver.kernel.org>; Mon, 13 Jul 2026 03:57:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gz7tH36Jmz2xjN;
	Mon, 13 Jul 2026 13:57:11 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1783915031;
	cv=none; b=YKySH6iyNsm3c+Dim2z79V1Lw11ep3+ClbaWwTt+V0azGDdpNgm2J/FsO+qDZiMlNxSrLRHKZvKE+AXYTkfyn2BDuwxk+DRRtyjU8a9bBcX+41FQwGXXRNGs/SKo3x6ZyHPES5J19jHb6pCrsDL3QgXEOHjQ0/NXZFAXkbow4kEp9UNvh8pgCXwHkhtSU9IOOXEw582j1guorUMquugAikYt1iWnc3CR3ijiwl7osWWI9CIOd2PFDp7XVTc9ybyA5Kg3RLcZc7zEoFjEmjRE/nMP7T442DH2tdyTkYQk8m+0+abI6hEWAGR0H/mB5iQBx6Js1PtcID1pUeLZMfjUKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1783915031; c=relaxed/relaxed;
	bh=ptapzLT2kC0FRZONruSP9TU30xzkIav8a6oiB+WjSOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l7qrdkVO4zH0zAIecNGKRYZJeWBLktV8K7tO8ss/fnvRvBJxFl2xbp0b6WOrl6LcEM9plbvlFioDYOOq6voycXcY8nDk+pcYI6jjVPdLLu2gnzLfeJ5OVgGCExtAr1nqbPZuoDYrXES+VcLmqKOL680XWiUgyxXupEOqF2+HBTOqkK3tsN0qP3IsJfRk8139+WS9LlpkHNM5EmrP4xe59TWcR6Riob31hk7zDUJv5WX2oWZagahWVP/Z7XH5sLvyHN3uk2THOypHbFSIqpIR9btaDutyW3K2ch2lXyycYvZOUzCy0+MLBHc4Z5QUMLN9ah2zS2rEEXmaj1izwlUNGw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=BsQ9aqWO; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=BsQ9aqWO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gz7tD5kqXz2xRw
	for <linux-erofs@lists.ozlabs.org>; Mon, 13 Jul 2026 13:57:07 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783915022; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ptapzLT2kC0FRZONruSP9TU30xzkIav8a6oiB+WjSOc=;
	b=BsQ9aqWOSWipLfGX8+tiTBOBRlHouAtLlcMIXTZsUeic8rAXbgqIJWp9kIvktgxBPCIDyOAwZX5L1plHKqeyTcMzUPKqleAwYMFx2pEylPtjozZw97PotbwUgEwdSc7LYZH+CWXrtgK7KvXlbrOfUYvm+YypGvCqHLfzrE0Towg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X6teBxS_1783915020;
Received: from 30.221.131.243(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X6teBxS_1783915020 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 13 Jul 2026 11:57:01 +0800
Message-ID: <008358ad-beef-4086-a423-0b282746ebb2@linux.alibaba.com>
Date: Mon, 13 Jul 2026 11:57:00 +0800
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
Subject: Re: [PATCH v2] erofs: accept source file descriptor via fsconfig
To: Giuseppe Scrivano <gscrivan@redhat.com>, linux-erofs@lists.ozlabs.org
Cc: linux-fsdevel@vger.kernel.org
References: <20260711071137.4130824-1-gscrivan@redhat.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260711071137.4130824-1-gscrivan@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/7/11 15:10, Giuseppe Scrivano wrote:
> Add fsparam_fd("source") so that userspace can pass an already-opened
> file descriptor instead of a path string.  When the fd is provided via
> fsconfig(FSCONFIG_SET_FD, "source", NULL, fd), it is stored directly
> in sbi->dif0.file and erofs_fc_get_tree() skips the filp_open() call.
> 
> This is useful for mount namespaces where the backing file may not be
> reachable by path, and for tools that already hold an fd to the image
> (e.g. composefs reusing an erofs mount's backing file).
> 
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

