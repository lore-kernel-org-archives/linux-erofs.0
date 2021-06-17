Return-Path: <SRS0=6U2p=LL=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14448C2B9F4
	for <linux-erofs@archiver.kernel.org>; Thu, 17 Jun 2021 09:28:05 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 81B6D613E9
	for <linux-erofs@archiver.kernel.org>; Thu, 17 Jun 2021 09:28:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81B6D613E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4G5Gtq6l45z3bsL
	for <linux-erofs@archiver.kernel.org>; Thu, 17 Jun 2021 19:28:03 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.56;
 helo=out30-56.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-56.freemail.mail.aliyun.com
 (out30-56.freemail.mail.aliyun.com [115.124.30.56])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4G5Gtg1z6Hz306q
 for <linux-erofs@lists.ozlabs.org>; Thu, 17 Jun 2021 19:27:52 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R341e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=7; SR=0; TI=SMTPD_---0UciMDLB_1623922053; 
Received: from bogon(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0UciMDLB_1623922053) by smtp.aliyun-inc.com(127.0.0.1);
 Thu, 17 Jun 2021 17:27:35 +0800
Date: Thu, 17 Jun 2021 17:27:33 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Yue Hu <zbestahu@gmail.com>
Subject: Re: [PATCH] erofs-utils: do not check ->idata_size for compressed
 files in erofs_prepare_inode_buffer()
Message-ID: <YMsVhf2JgQOm1fDE@bogon>
References: <20210617082954.1001-1-zbestahu@gmail.com> <YMsQHU+iSKE+FRO5@bogon>
 <20210617171555.0000673e.zbestahu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210617171555.0000673e.zbestahu@gmail.com>
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
Cc: zbestahu@163.com, huyue2@yulong.com, xiang@kernel.org,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Thu, Jun 17, 2021 at 05:15:55PM +0800, Yue Hu wrote:
> On Thu, 17 Jun 2021 17:04:29 +0800
> Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
> 
> > Hi Yue,
> > 
> > On Thu, Jun 17, 2021 at 04:29:54PM +0800, Yue Hu wrote:
> > > From: Yue Hu <huyue2@yulong.com>
> > > 
> > > erofs_write_compressed_file() will always set inode->idata_size = 0
> > > if succeed, that means no tail-end data for compressed files. So, no
> > > need to call erofs_prepare_tail_block() which is used to handle
> > > tail-end data for that case. Just skip it.  
> > 
> > Thanks for the patch, due to somewhat long time so I don't quite
> > remember the exact logic here now...
> > 
> > Yet from the description before, it's not strictly correct
> > since my original intention would be to support tail-packing
> > inline compressed data which is similar to uncompressed case
> > to decrease tail extent I/O and save more space.
> 
> nice.
> 
> > 
> > BTW, if you have some interest, would you like to implement it? :)
> 
> I don't know if i can finish it. But i would like to have a try :)

My rough thought is to try to inline the last tail compresseed
extent after the on-disk compressed extents, maybe we could let
it work for non-compact (legacy) compress index format cases...

Yeah, if you have extra time and interest, more ideas / thoughts /
discussions are always welcomed ;)

Thanks,
Gao Xiang


> 
> Thanks.
> 
> > 
> > Thanks,
> > Gao Xiang
> > 
> > > 
> > > Also, correct 'a inode' -> 'an inode'.
> > > 
> > > Signed-off-by: Yue Hu <huyue2@yulong.com>
> > > ---
> > >  lib/inode.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/lib/inode.c b/lib/inode.c
> > > index b6108db..b5f66de 100644
> > > --- a/lib/inode.c
> > > +++ b/lib/inode.c
> > > @@ -111,7 +111,7 @@ struct erofs_dentry *erofs_d_alloc(struct erofs_inode *parent,
> > >  	return d;
> > >  }
> > >  
> > > -/* allocate main data for a inode */
> > > +/* allocate main data for an inode */
> > >  static int __allocate_inode_bh_data(struct erofs_inode *inode,
> > >  				    unsigned long nblocks)
> > >  {
> > > @@ -572,11 +572,11 @@ static int erofs_prepare_inode_buffer(struct erofs_inode *inode)
> > >  		int ret;
> > >  
> > >  		inode->datalayout = EROFS_INODE_FLAT_PLAIN;
> > > -noinline:
> > >  		/* expend an extra block for tail-end data */
> > >  		ret = erofs_prepare_tail_block(inode);
> > >  		if (ret)
> > >  			return ret;
> > > +noinline:
> > >  		bh = erofs_balloc(INODE, inodesize, 0, 0);
> > >  		if (IS_ERR(bh))
> > >  			return PTR_ERR(bh);
> > > -- 
> > > 1.9.1  
