Return-Path: <SRS0=iiW+=DS=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0BD9C433E7
	for <linux-erofs@archiver.kernel.org>; Sun, 11 Oct 2020 08:59:13 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D235C20795
	for <linux-erofs@archiver.kernel.org>; Sun, 11 Oct 2020 08:59:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="cGm/k7u7";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="I5TSBE4q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D235C20795
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4C8G2R1YfbzDqv8
	for <linux-erofs@archiver.kernel.org>; Sun, 11 Oct 2020 19:59:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1602406751;
	bh=mP0c+ZJzpC8cvPE9q7N/M1NLwX2NjncyP9KIhfNRp4s=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=cGm/k7u7ODoqsIqkaTVELk5/oboS34PeLVXU+5By+z9jqAtLaj8wU7RfNB4f0eEkf
	 e6hxSsOFA30JHJIbletBBncwD4oJWDsnFLFHQSjRmymfwOluDdXhCcXqK8ODZQwnqM
	 Q/dVooB0ExKroAu4IY0GNVvYe19yB9Ejliq76eDoIJ624CzRb/JkcWvW3/QRF0fK04
	 u++LWVW2XlBOFs/ebvW6iNY1CgU8+kvCPcYcxIfvBtRyyCz2cfhGSi9Wr51v0CTums
	 BNWoYxuTaJBgDy7FDOURrn6IPMBrCUrQpXy0+6E2OQQllYLvqmYdXjElvjJTvcuX7r
	 N/8KEVjhe0Bpg==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.53;
 helo=out30-53.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=I5TSBE4q; dkim-atps=neutral
Received: from out30-53.freemail.mail.aliyun.com
 (out30-53.freemail.mail.aliyun.com [115.124.30.53])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4C8G243ZBZzDqsq
 for <linux-erofs@lists.ozlabs.org>; Sun, 11 Oct 2020 19:58:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1602406726; h=Subject:From:To:Message-ID:Date:MIME-Version:Content-Type;
 bh=SSsyIVyMf6nZUoewhFEfRBjipFDJJRBxYGjs4B6T2d4=;
 b=I5TSBE4qR+UFYQIg788rZJfWT+NAD+JrgZwmY3N6hhVH3q20mYLlS2Vqxv2EcjMDpUs8ej2T+BYxvcqXz2aVBHtiU18MlGoP2VTgEZzN+atd/oq5AfIV1H81Y0XJXHXxT32QZVFRPuDPrncK0gFEtoTKJ9YzfbuqY9hAPrjtGYQ=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.1032649|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_system_inform|0.00537778-0.000560787-0.994061;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04420; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=3; RT=3; SR=0; TI=SMTPD_---0UBdjjjE_1602406403; 
Received: from 192.168.3.5(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UBdjjjE_1602406403) by smtp.aliyun-inc.com(127.0.0.1);
 Sun, 11 Oct 2020 16:53:23 +0800
Subject: Re: [PATCH v2] AOSP: erofs-utils: add fs_config support
To: Gao Xiang <hsiangkao@aol.com>, linux-erofs@lists.ozlabs.org
References: <20200928213549.17580-1-hsiangkao@aol.com>
 <20200929051302.3324-1-hsiangkao@aol.com>
 <7e4490c0-0a3d-0ceb-98ca-73d5eb69932d@aliyun.com>
Message-ID: <a4b4d4a8-46bc-87d2-eb8a-d1d010f9d76d@aliyun.com>
Date: Sun, 11 Oct 2020 16:53:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <7e4490c0-0a3d-0ceb-98ca-73d5eb69932d@aliyun.com>
Content-Type: text/plain; charset=gbk
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
From: Li GuiFu via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Li GuiFu <bluce.lee@aliyun.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



在 2020/10/10 0:33, Li GuiFu 写道:
> 
> 
> 在 2020/9/29 13:13, Gao Xiang 写道:
>> So that mkfs can directly generate images with fs_config.
>> All code for AOSP is wraped up with WITH_ANDROID macro.
>>
>> Signed-off-by: Gao Xiang <hsiangkao@aol.com>
>> ---
>> changes since v1:
>>  - fix compile issues on Android / Linux build;
>>  - tested with Android system booting;
>>
>>  include/erofs/config.h   | 12 ++++++++++
>>  include/erofs/internal.h |  3 +++
>>  lib/inode.c              | 49 +++++++++++++++++++++++++++++++++++++
>>  lib/xattr.c              | 52 ++++++++++++++++++++++++++++++++++++++++
>>  mkfs/main.c              | 29 +++++++++++++++++++++-
>>  5 files changed, 144 insertions(+), 1 deletion(-)
>>
Please update the usage about mount-point

