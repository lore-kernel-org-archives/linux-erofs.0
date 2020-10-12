Return-Path: <SRS0=Po1J=DT=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19352C433DF
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2020 15:21:57 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7A7A720878
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2020 15:21:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="lWy8WQd3";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="ov6RbNLF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A7A720878
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4C92TZ4rKZzDqkB
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Oct 2020 02:21:54 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1602516114;
	bh=JKhTAO4e3CgZcFHsY6AATvcjmc7diWxcRa4xJpfobeY=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=lWy8WQd35Q5rF7dCg44MnBiX8fET5vivEi26eyFMQ4gT3HFyI+NeMKcUYaxQb2Z3O
	 7W/9Rvd9sW9PVBnIqbp//bVW/zru6LV1aidvzXoaqL0SURw5N5dUII/rXuYOoXE36z
	 0Pyoc+1/8WqGamIMSMS8xc7Z22610obTqTBwyy6vM7ZEz/ahu2pTCspQsChwkmtUJu
	 CfydtQjzokSSc1+GU8u+R46dgbMbOzv0UL6u0EBPgLXAbeXW7uMCAX8vEO6++w+2/t
	 hqlJ355T+WxWOSWhdBn2AuWWpWO0niRVP51rv/Pg7/16sCq9n6sX6fzsHg9QMv5P1x
	 NSzwEla6X37DA==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.29;
 helo=out30-29.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=ov6RbNLF; dkim-atps=neutral
Received: from out30-29.freemail.mail.aliyun.com
 (out30-29.freemail.mail.aliyun.com [115.124.30.29])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4C92TN1hP9zDqjn
 for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2020 02:21:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1602516090; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
 bh=qdEtJmaF1vr8K5kj+WVpy1YJMg40lfnkL48ua0ftM7Y=;
 b=ov6RbNLFgHoi/yGaN1zjxlq9U9B1y0K/3/iJcaTxRGPDzDJYyie1hFe29eUKqDCFbJ784PVtLvNDauBpxlH3iMVy4dRBJPU5t2i02mtz+Y6eAyWzERAjMnC7qd4Efxd/yUl5k3aUq1nMITDcw2tFzXz2k6a4MT4X4MnUqkeyJBY=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.1426594|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_regular_dialog|0.0202992-0.00336022-0.976341;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04420; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=3; RT=3; SR=0; TI=SMTPD_---0UBrEMdz_1602516089; 
Received: from 192.168.3.5(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UBrEMdz_1602516089) by smtp.aliyun-inc.com(127.0.0.1);
 Mon, 12 Oct 2020 23:21:29 +0800
Subject: Re: [PATCH] erofs-utils: README: update known-issue status of lz4hc
To: Gao Xiang <hsiangkao@aol.com>, linux-erofs@lists.ozlabs.org
References: <20201012073446.18103-1-hsiangkao.ref@aol.com>
 <20201012073446.18103-1-hsiangkao@aol.com>
Message-ID: <fefc27c6-ba56-4134-dc8d-5e12a01a783f@aliyun.com>
Date: Mon, 12 Oct 2020 23:21:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201012073446.18103-1-hsiangkao@aol.com>
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



On 2020/10/12 15:34, Gao Xiang wrote:
> Known issue of LZ4_compress_HC_destSize() mentioned in README
> was targeted by lz4 upstream days ago.
> 
> Update README so all users can be noticed.
> 
> Signed-off-by: Gao Xiang <hsiangkao@aol.com>

It looks good thanks
Reviewed-by: Li Guifu <bluce.lee@aliyun.com>
