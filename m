Return-Path: <SRS0=WXO8=EH=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E37C2D0A3
	for <linux-erofs@archiver.kernel.org>; Sun,  1 Nov 2020 14:55:40 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B5091206DC
	for <linux-erofs@archiver.kernel.org>; Sun,  1 Nov 2020 14:55:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="iwr7fCoK";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="QWag7JCx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5091206DC
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4CPJy10gPQzDqYW
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Nov 2020 01:55:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1604242537;
	bh=O25FpCIdb2G+yAJ8M1TmbpMm5RSnmDtURSWkBKuq76k=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=iwr7fCoKQD8eNo9aLZXeM2P4Q9cyy8ted136+0QuSJtg++/YGeLK9bSX4Ca2m65C+
	 UIkffvwWNDGvXLY8bpvLuP81PsTESStrwFkLQzzCUgFXKDjAtAig9MsKHeUjyWX2sC
	 tcX2OCdQgzbbtn+sFzXaqORUISmW4FZtSIvvn4ZN/P8OnLDE74wRS8gs0VWez59LY7
	 q8P6EcXJn54/szGqKVm4D8DEPQVvzFF4ej8pG++ylzOxnpCedugnyQMLdw3mmf3cPV
	 QEbzLCuaO4KyJDvDrO3aPXVtGTs26mDISdQVjXkr21OAeB513wB2/2hCLJ8WBXoCwq
	 d6u4Gtd9VuPLg==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.26;
 helo=out30-26.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=QWag7JCx; dkim-atps=neutral
Received: from out30-26.freemail.mail.aliyun.com
 (out30-26.freemail.mail.aliyun.com [115.124.30.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4CPJxp4WvvzDqNt
 for <linux-erofs@lists.ozlabs.org>; Mon,  2 Nov 2020 01:55:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1604242521; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
 bh=b4HGT+MlKrvKzwHtFqalIAk4vyNMjNf2EsAPAtlvAwo=;
 b=QWag7JCxU8cto7bBJleVALtZeTuH3YT7/8BJNLIId98LqT7ruKCXaar9FGx6HdZachfgqgxux2+tzB8tJogwMLlllIPmW5eVY6Wce+iw6x4fGvYVVACGZLtExLTNRUFAuMXhojtJrW3La5j2aeP+l6di4VFuuDGODGFoBkQBMm8=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.2849674|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_social|0.00847698-0.000177106-0.991346; FP=0|0|0|0|0|-1|-1|-1;
 HT=e01e04400; MF=bluce.lee@aliyun.com; NM=1; PH=DS; RN=2; RT=2; SR=0;
 TI=SMTPD_---0UDpouZ2_1604242520; 
Received: from 192.168.3.18(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UDpouZ2_1604242520) by smtp.aliyun-inc.com(127.0.0.1);
 Sun, 01 Nov 2020 22:55:20 +0800
Subject: Re: [PATCH 3/4] mkfs: introduce erofs_mkfs_default_options()
To: Gao Xiang <hsiangkao@redhat.com>, linux-erofs@lists.ozlabs.org
References: <20201030123020.133084-1-hsiangkao@redhat.com>
 <20201030123020.133084-3-hsiangkao@redhat.com>
Message-ID: <41a78be1-04f5-2aa2-ae9c-6d25e6e66589@aliyun.com>
Date: Sun, 1 Nov 2020 22:55:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201030123020.133084-3-hsiangkao@redhat.com>
Content-Type: text/plain; charset=utf-8
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
From: Li GuiFu via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Li GuiFu <bluce.lee@aliyun.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2020/10/30 20:30, Gao Xiang wrote:
> Gather all default settings, and generate UUID before
> parse_options_cfg(), therefore the UUID can be overridden
> later by command line for reproducible images.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---

It looks good
Reviewed-by: Li Guifu <bluce.lee@aliyun.com>
Thanks,
