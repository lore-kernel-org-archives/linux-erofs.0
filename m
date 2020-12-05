Return-Path: <SRS0=VaLi=FJ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A790BC433FE
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Dec 2020 08:42:36 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 26BA822D72
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Dec 2020 08:42:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26BA822D72
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Cp33t4DM5zDqk7
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Dec 2020 19:42:34 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1607157754;
	bh=km+sbYO4Z/ySqgkpWLqEAu5fimRYfF87bYpHt3+O9ps=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=dwTuomka6zCuXYf+MGzkhabPD5RovjTBJHlg0tG2TzrzB9G6CScKE93mxBxiEQ+SN
	 HJyZvaj8c/8SxRG+mc2cG8oBJ79VwbELQHXdpvIeMZAfS+fq9wFMUTSRJyEsXtyg7P
	 eoGz0DkzWKeUtNyYyaXQYMC4T8GvgxGzL1K8kjwo0dwjDzIshJt/cE9FxW8+FaUqzz
	 meAvldy051Pu63w6nbdJY0UmE6jkjyqoJwwyh/3aDxoXYCQfwrxjSCbNefBtf8TK2h
	 YmkCqDHBiUr8jamkeDBz2vW/3mV25ZUS0pHi8PBUL9EJ21kSZch+Lj2cMwLauAmCJa
	 9VTkLyN9hGy2w==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.15;
 helo=out30-15.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=wn1iQRaN; dkim-atps=neutral
Received: from out30-15.freemail.mail.aliyun.com
 (out30-15.freemail.mail.aliyun.com [115.124.30.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Cp33j2qVJzDq6B
 for <linux-erofs@lists.ozlabs.org>; Sat,  5 Dec 2020 19:42:23 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1607157725; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
 bh=preSmaAcNMhEV9vMEWyd3y2jDzBIf/D+r/XStNiLUiU=;
 b=wn1iQRaNsq2FXHqoBOC01L3/Q9cwOumullt+Fpl3jTC7fuIhWxyJIk5n56/FQqQxOFKFK7q5CZEgT2umlJ6fnR9xje6KUmwlT+doaNlOeHLsl804OWtmL22gfjebfErz8FdalBNyGVvvHfc/S/m21nEFHKFliGQWZaVXsyL8Kr4=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.0831589|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_enroll_verification|0.0123251-0.00246905-0.985206;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04423; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=3; RT=3; SR=0; TI=SMTPD_---0UHZmT9M_1607157724; 
Received: from 172.168.2.18(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UHZmT9M_1607157724) by smtp.aliyun-inc.com(127.0.0.1);
 Sat, 05 Dec 2020 16:42:04 +0800
Subject: Re: [PATCH v3 2/3] erofs-utils: fuse: support symlink & special inode
To: Gao Xiang <hsiangkao@aol.com>, linux-erofs@lists.ozlabs.org
References: <20201127114617.13055-1-hsiangkao@aol.com>
 <20201127114617.13055-3-hsiangkao@aol.com>
Message-ID: <5367c0d3-b303-6430-3e4b-99e2af4bdcbd@aliyun.com>
Date: Sat, 5 Dec 2020 16:42:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201127114617.13055-3-hsiangkao@aol.com>
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
Cc: Guo Weichao <guoweichao@oppo.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2020/11/27 19:46, Gao Xiang via Linux-erofs wrote:
> From: Huang Jianan <huangjianan@oppo.com>
> 
> This patch adds symlink and special inode (e.g. block dev, char,
> socket, pipe inode) support.
> 
> Signed-off-by: Huang Jianan <huangjianan@oppo.com>
> Signed-off-by: Guo Weichao <guoweichao@oppo.com>
> Signed-off-by: Gao Xiang <hsiangkao@aol.com>
> ---
>  fuse/main.c | 10 ++++++++++
>  lib/namei.c | 22 ++++++++++++++++++----
>  2 files changed, 28 insertions(+), 4 deletions(-)
> 

It looks good
Reviewed-by: Li Guifu <bluce.lee@aliyun.com>
Tested-by: Li Guifu <bluce.lee@aliyun.com>
Thanks,
