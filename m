Return-Path: <SRS0=l39h=N5=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4473DC433EF
	for <linux-erofs@archiver.kernel.org>; Tue,  7 Sep 2021 00:46:54 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B983A61078
	for <linux-erofs@archiver.kernel.org>; Tue,  7 Sep 2021 00:46:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B983A61078
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4H3RRc39HDz2yHH
	for <linux-erofs@archiver.kernel.org>; Tue,  7 Sep 2021 10:46:52 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131;
 helo=out30-131.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-131.freemail.mail.aliyun.com
 (out30-131.freemail.mail.aliyun.com [115.124.30.131])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4H3RRV1Nrkz2xY7
 for <linux-erofs@lists.ozlabs.org>; Tue,  7 Sep 2021 10:46:43 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R201e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=6; SR=0; TI=SMTPD_---0UnXFkLE_1630975584; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0UnXFkLE_1630975584) by smtp.aliyun-inc.com(127.0.0.1);
 Tue, 07 Sep 2021 08:46:26 +0800
Date: Tue, 7 Sep 2021 08:46:24 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Huang Jianan <huangjianan@oppo.com>, linux-erofs@lists.ozlabs.org,
 yh@oppo.com, kevin.liw@oppo.com, guoweichao@oppo.com, guanyuwei@oppo.com
Subject: Re: [PATCH] uerofs-utils: fix random data for block-aligned
 uncompressed file
Message-ID: <YTa2YLuTBwvHCSAf@B-P7TQMD6M-0146.local>
References: <20210906081359.17440-1-huangjianan@oppo.com>
 <20210906081359.17440-2-huangjianan@oppo.com>
 <20210907001038.GC23541@hsiangkao-HP-ZHAN-66-Pro-G1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210907001038.GC23541@hsiangkao-HP-ZHAN-66-Pro-G1>
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Tue, Sep 07, 2021 at 08:10:45AM +0800, Gao Xiang wrote:
> On Mon, Sep 06, 2021 at 04:13:59PM +0800, Huang Jianan via Linux-erofs wrote:
> > If the file size is block-aligned for uncompressed files, i_u is
> > meaningless for erofs_inode on disk, but it's not cleared when
> > datalayout is seted in erofs_prepare_inode_buffer. Clear the entire
> > erofs_inode to zero to fix this.
> > 
> > Signed-off-by: Huang Jianan <huangjianan@oppo.com>
> > ---
> >  lib/inode.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/lib/inode.c b/lib/inode.c
> > index 0ad703d..1397cc5 100644
> > --- a/lib/inode.c
> > +++ b/lib/inode.c
> > @@ -834,7 +834,7 @@ static struct erofs_inode *erofs_new_inode(void)
> >  	static unsigned int counter;
> >  	struct erofs_inode *inode;
> >  
> > -	inode = malloc(sizeof(struct erofs_inode));
> > +	inode = calloc(1, sizeof(struct erofs_inode));
> 
> If we decide to do this, how about removing all
> 	inode->idata_size = 0;
> 	inode->xattr_isize = 0;
> 	inode->extent_isize = 0;
> 
> 	inode->bh = inode->bh_inline = inode->bh_data = NULL;
> 	inode->idata = NULL;

Please also add a note that this only impacts OTA packages in the
commit message about the background since it has some impact to
the reproducible builds.

Thanks,
Gao Xiang

> ?
> 
> Thanks,
> Gao Xiang
> 
> >  	if (!inode)
> >  		return ERR_PTR(-ENOMEM);
> >  
> > -- 
> > 2.25.1
> > 
