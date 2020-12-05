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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D89C433FE
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Dec 2020 07:54:01 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 795CA22D0B
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Dec 2020 07:54:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 795CA22D0B
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Cp1zp5dzkzDqb9
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Dec 2020 18:53:58 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1607154838;
	bh=JtGC03NNz6PSMdcD5EkGL6ffRDOOrATtYNtCRkL/JCo=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=RW2rnnL3T6ZScbMmieOhhBmmVaOgm+Tc94qfsa6iKlFPX/gw7Joo0cj9X0yMLsbNh
	 gzWJ0ZzPqGdA21Cs6Qp8mZeHnTLa8z0XUQ4WhpQtk7Grx31q3vpveJFa1+hgDDuUwI
	 /8KiPhNdPWSvo74d8T4wq0fx13dE3MOCsex5iSDNgeLpCAkzAqD4PnmtQdi05TQJv5
	 eBrPCdqBKkdQLIJG6GsTOd8f33gSPHLWTfCzlCHL7Pt32azh/8EKb0ef5989cBoYif
	 yCnzx8ZZIm/9uB4tca1+fkEBDn+/lzRWHLgVw05aaoJ84t6TxXdTXZbwOldH+6AMF4
	 vF8wBsxbB9hqQ==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.41;
 helo=out30-41.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=gjpzZynl; dkim-atps=neutral
Received: from out30-41.freemail.mail.aliyun.com
 (out30-41.freemail.mail.aliyun.com [115.124.30.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Cp1zf1jHpzDqVR
 for <linux-erofs@lists.ozlabs.org>; Sat,  5 Dec 2020 18:53:49 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1607154813; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
 bh=bwjTTLJPzDkxfw4gVhE+c8NQ/CIu/vAH6KQxLerbQBU=;
 b=gjpzZynlAqwMFnU1we+JB/yPUW73NVWrirLFGuYPno0ICF4+fgGcxeUr70VFJAaXUtH0fi1ZDhbRbEedzQAash7QuHjaoWu6SCmH7rm49BjhzYYKpDrAffPOcgrZACmhhQ/ODsfkSrzoWaDxIkMNd6mg/tjgpKDxNHa/+3lGzI8=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.1056177|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_enroll_verification|0.00496793-0.000677941-0.994354;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04407; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=2; RT=2; SR=0; TI=SMTPD_---0UHZViHs_1607154812; 
Received: from 172.168.2.18(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UHZViHs_1607154812) by smtp.aliyun-inc.com(127.0.0.1);
 Sat, 05 Dec 2020 15:53:32 +0800
Subject: Re: [PATCH v2 2/2] erofs-utils: fix cross-device submounts
To: Gao Xiang <hsiangkao@aol.com>, linux-erofs@lists.ozlabs.org
References: <20201204172042.24180-2-hsiangkao@aol.com>
 <20201204175642.3231-1-hsiangkao@aol.com>
Message-ID: <7923bedc-a620-acaf-d85d-542e5b450865@aliyun.com>
Date: Sat, 5 Dec 2020 15:53:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201204175642.3231-1-hsiangkao@aol.com>
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



On 2020/12/5 1:56, Gao Xiang via Linux-erofs wrote:
> From: Gao Xiang <hsiangkao@aol.com>
> 
> Use device ID and inode number to identify hardlinks
> rather than inode number only.
> 
> Fixes: a17497f0844a ("erofs-utils: introduce inode operations")
> Signed-off-by: Gao Xiang <hsiangkao@aol.com>
> ---
> changes since v1:
>  - fix improper inline comment update;
> 
>  include/erofs/internal.h |  7 ++++++-
>  lib/inode.c              | 14 ++++++++------
>  2 files changed, 14 insertions(+), 7 deletions(-)
> 
It looks good
Reviewed-by: Li Guifu <bluce.lee@aliyun.com>
Thanks,
