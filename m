Return-Path: <SRS0=VaLi=FJ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3101C433FE
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Dec 2020 07:37:20 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D92A422D0B
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Dec 2020 07:37:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D92A422D0B
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Cp1cZ1BTQzDqbY
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Dec 2020 18:37:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1607153838;
	bh=20DGs9Ep/VYUMg61X9q/0Mz1o3mcElDt7vNhKt29fQ8=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=LqTN84bFDAkjDi5tnMX+GR/wAJf69hHx6f+TSdz8NtuqG3SXGiN+fdaYPA+WZRR7t
	 Qsc9qWqj8z0rH8km69Mqmvvnoxvr0EQn/V5NoZguQDnw6679+VqGDxWE4/KmiwjBk+
	 dbUzCe0pPmEvU3SAuLD6ebQ1guTxRR/NXTFyWud5I5Kau7w8lZgxnC0xIzXjlpRHiP
	 K34OWWfaxwIOIUhaZgFfOzap9W3H51H04Hpd+0bv/ehdQ4UnTA+hAQfyUACp4a18fy
	 etekV4jaRRUGGLcxAS7v6CbCqzgYlhwaCMUTvG0T+xrajJqR+9ssw7lWSLZQjQYRcw
	 JS75AfqCW1iPA==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.14;
 helo=out30-14.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=fZ6CQuU7; dkim-atps=neutral
Received: from out30-14.freemail.mail.aliyun.com
 (out30-14.freemail.mail.aliyun.com [115.124.30.14])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Cp1cR2bQYzDqbY
 for <linux-erofs@lists.ozlabs.org>; Sat,  5 Dec 2020 18:37:10 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1607153823; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
 bh=M5AdV9Gvu5BxVfZlHrkxEiJ0YuPYy0na15kAdekTzJ8=;
 b=fZ6CQuU7AOhQlfJ9aReasJ8wsUpOWJTJQ/+mvrl9Hkgy1mRZsNfFe3dtI6vudIJP7yXTHQnMmQtQstekI4w4OWRQqjPSjeFQHzyne7TCHkqldt/u3KyS+qAKcGjh9oHWo1F98ewGC/zM3RtwLwXBl3zxNMQumd17MiTInjodz+U=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.257241|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_social|0.00442329-0.0007862-0.99479; FP=0|0|0|0|0|-1|-1|-1;
 HT=e01e04423; MF=bluce.lee@aliyun.com; NM=1; PH=DS; RN=2; RT=2; SR=0;
 TI=SMTPD_---0UHZmJXP_1607153822; 
Received: from 172.168.2.18(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UHZmJXP_1607153822) by smtp.aliyun-inc.com(127.0.0.1);
 Sat, 05 Dec 2020 15:37:02 +0800
Subject: Re: [PATCH] erofs-utils: update .gitignore
To: Gao Xiang <hsiangkao@aol.com>, linux-erofs@lists.ozlabs.org
References: <20201202095345.10485-1-hsiangkao.ref@aol.com>
 <20201202095345.10485-1-hsiangkao@aol.com>
Message-ID: <9f1e1c8e-66bb-5761-35a4-b7c76aa7e555@aliyun.com>
Date: Sat, 5 Dec 2020 15:37:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201202095345.10485-1-hsiangkao@aol.com>
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



On 2020/12/2 17:53, Gao Xiang via Linux-erofs wrote:
> Add more extensions to .gitignore.
> 
> Signed-off-by: Gao Xiang <hsiangkao@aol.com>
> ---
>  .gitignore | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 

It looks good
Reviewed-by: Li Guifu <bluce.lee@aliyun.com>
Thanks,
