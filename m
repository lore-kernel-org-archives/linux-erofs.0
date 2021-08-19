Return-Path: <SRS0=jHcD=NK=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE47C4338F
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Aug 2021 05:15:38 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3A1A061107
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Aug 2021 05:15:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3A1A061107
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GqtJR6dWbz3bXl
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Aug 2021 15:15:35 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132;
 helo=out30-132.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-132.freemail.mail.aliyun.com
 (out30-132.freemail.mail.aliyun.com [115.124.30.132])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GqtJH567Jz308C
 for <linux-erofs@lists.ozlabs.org>; Thu, 19 Aug 2021 15:15:22 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R381e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=8; SR=0; TI=SMTPD_---0UjyVVjp_1629350099; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0UjyVVjp_1629350099) by smtp.aliyun-inc.com(127.0.0.1);
 Thu, 19 Aug 2021 13:15:00 +0800
Date: Thu, 19 Aug 2021 13:14:58 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Chao Yu <chao@kernel.org>
Subject: Re: [PATCH 2/2] erofs: support reading chunk-based uncompressed files
Message-ID: <YR3o0qjHCR7DE7kO@B-P7TQMD6M-0146.local>
References: <20210818070713.4437-1-hsiangkao@linux.alibaba.com>
 <20210818070713.4437-2-hsiangkao@linux.alibaba.com>
 <2c833d7e-9f82-f1f7-a576-b9fc50e0cb15@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2c833d7e-9f82-f1f7-a576-b9fc50e0cb15@kernel.org>
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
Cc: LKML <linux-kernel@vger.kernel.org>, Peng Tao <tao.peng@linux.alibaba.com>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, Liu Bo <bo.liu@linux.alibaba.com>,
 Eryu Guan <eguan@linux.alibaba.com>, Liu Jiang <gerry@linux.alibaba.com>,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Chao,

On Thu, Aug 19, 2021 at 11:46:11AM +0800, Chao Yu wrote:
> On 2021/8/18 15:07, Gao Xiang wrote:
> > +		else if (vi->datalayout == EROFS_INODE_CHUNK_BASED)
> > +			/* fill chunked inode summary info */
> > +			vi->chunkformat = __le16_to_cpu(die->i_u.c.format);
> 
> le16_to_cpu(),

Thanks for the review and catching this, I didn't meant to use that.
Will send out the next version soon.

Thanks,
Gao Xiang

> 
> >   		kfree(copied);
> >   		break;
> >   	case EROFS_INODE_LAYOUT_COMPACT:
> > @@ -160,6 +163,8 @@ static struct page *erofs_read_inode(struct inode *inode,
> >   		inode->i_size = le32_to_cpu(dic->i_size);
> >   		if (erofs_inode_is_data_compressed(vi->datalayout))
> >   			nblks = le32_to_cpu(dic->i_u.compressed_blocks);
> > +		else if (vi->datalayout == EROFS_INODE_CHUNK_BASED)
> > +			vi->chunkformat = __le16_to_cpu(dic->i_u.c.format);
> 
> Ditto.
> 
> Thanks,
