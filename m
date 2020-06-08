Return-Path: <SRS0=fSk2=7V=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB76C433E0
	for <linux-erofs@archiver.kernel.org>; Mon,  8 Jun 2020 15:51:26 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7970F206A4
	for <linux-erofs@archiver.kernel.org>; Mon,  8 Jun 2020 15:51:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="ZP1QDz3T";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="XmxX6NdU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7970F206A4
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 49gd5m6LQSzDqQQ
	for <linux-erofs@archiver.kernel.org>; Tue,  9 Jun 2020 01:51:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1591631484;
	bh=t74BqlJEphsa6PgNnT+foL3uaPmz3htvhZ33JzMlFGw=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=ZP1QDz3TFxGV1YVnlOL/H/DTSoCCgRtaQk7sSxGDQmYMDwKvShcm2g6KzTGMKq2LD
	 EOUkw+3LKKHb7esCkT5lruoFYJBkK3KEO6jL4aFxD3j3Ic6Jxfymo9zr5IbqyhR5VB
	 UUde3PlWETnxC4P+eRp3mHy/7xEZgO+qF4Pn3FXam3wzwSYb3AlsIK5VSx0DOEEmgW
	 YWuwpKdjbAMhtecZxA+wsdTqo/xNkTSbrKR2VbNdSzsL9m4WHmigdxtpJ+9OfaRjGv
	 5iIROXnD0CbrwReLjfKzfErK9S2TJPEGBMAvQMQ1//pQcT0+M58OdaUu2hGmK5TZEx
	 r/QH0tTMgvqSA==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.15;
 helo=out30-15.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=XmxX6NdU; dkim-atps=neutral
Received: from out30-15.freemail.mail.aliyun.com
 (out30-15.freemail.mail.aliyun.com [115.124.30.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 49gd5d0BzNzDqQ3
 for <linux-erofs@lists.ozlabs.org>; Tue,  9 Jun 2020 01:51:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1591631461; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
 bh=V7pGDZZNWfmh4/bT4QOGS3xGxv0BXfS0Lztp9yNOqi4=;
 b=XmxX6NdUCyzmrD8/TXGfI69L8Ji28C6o6BjGcsK1KwDlbSivC6sP6qeIfApmCdkyNgwJdJ4a4P2cIj29LRFX43ABSDViccxDYDSAKdOra8tkWD9W0b7KVNIgfsPd1IgSLcJvmkFds6bRn2Bv4V3ARfqLb5eP3LtpOr1m03vJmA8=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.1456455|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_regular_dialog|0.00767264-0.00150987-0.990817;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04357; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=6; RT=6; SR=0; TI=SMTPD_---0U.02M1C_1591631460; 
Received: from 192.168.3.5(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0U.02M1C_1591631460) by smtp.aliyun-inc.com(127.0.0.1);
 Mon, 08 Jun 2020 23:51:01 +0800
Subject: Re: [PATCH v4] erofs-utils: support selinux file contexts
To: hsiangkao@aol.com, linux-erofs@lists.ozlabs.org
References: <20200608123414.12572-1-hsiangkao@aol.com>
 <20200608130854.16953-1-hsiangkao@aol.com>
Message-ID: <9034e0a9-776a-4ca8-aac0-10b18dd5afa5@aliyun.com>
Date: Mon, 8 Jun 2020 23:51:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200608130854.16953-1-hsiangkao@aol.com>
Content-Type: text/plain; charset=utf-8
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


On 2020/6/8 21:08, hsiangkao@aol.com wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> Add --file-contexts flag that allows passing a selinux
> file_context file to setup file selabels.
> 
> Reviewed-and-tested-by: Li Guifu <bluce.lee@aliyun.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> v4: freecon() should be used instead of free(). (although
>     they're equivalent, but that is what manpage prefers...)
> 
It looks good
Reviewed-by: Li Guifu <bluce.lee@aliyun.com>
Tested-by: Li Guifu <bluce.lee@aliyun.com>
