Return-Path: <SRS0=SbEo=O5=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13AAEC433EF
	for <linux-erofs@archiver.kernel.org>; Sat,  9 Oct 2021 04:48:12 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 296686103B
	for <linux-erofs@archiver.kernel.org>; Sat,  9 Oct 2021 04:48:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 296686103B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4HRCHF3yQjz30HX
	for <linux-erofs@archiver.kernel.org>; Sat,  9 Oct 2021 15:48:09 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.44;
 helo=out30-44.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-44.freemail.mail.aliyun.com
 (out30-44.freemail.mail.aliyun.com [115.124.30.44])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4HRCH55SF8z2yyh
 for <linux-erofs@lists.ozlabs.org>; Sat,  9 Oct 2021 15:47:56 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R351e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04407; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=7; SR=0; TI=SMTPD_---0Ur3l3OA_1633754867; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0Ur3l3OA_1633754867) by smtp.aliyun-inc.com(127.0.0.1);
 Sat, 09 Oct 2021 12:47:48 +0800
Date: Sat, 9 Oct 2021 12:47:46 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Yue Hu <zbestahu@gmail.com>
Subject: Re: [PATCH v2 2/3] erofs: introduce the secondary compression head
Message-ID: <YWEe8nPqFEusXkKP@B-P7TQMD6M-0146.local>
References: <20211008200839.24541-1-xiang@kernel.org>
 <20211008200839.24541-3-xiang@kernel.org>
 <20211009115032.00002f26.zbestahu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211009115032.00002f26.zbestahu@gmail.com>
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
Cc: LKML <linux-kernel@vger.kernel.org>, huyue2@yulong.com,
 linux-erofs@lists.ozlabs.org, zhangwen@yulong.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Yue,

On Sat, Oct 09, 2021 at 11:50:32AM +0800, Yue Hu wrote:
> On Sat,  9 Oct 2021 04:08:38 +0800
> Gao Xiang <xiang@kernel.org> wrote:
> 
> > From: Gao Xiang <hsiangkao@linux.alibaba.com>
> > 
> > Previously, for each HEAD lcluster, it can be either HEAD or PLAIN
> > lcluster to indicate whether the whole pcluster is compressed or not.
> > 
> > In this patch, a new HEAD2 head type is introduced to specify another
> > compression algorithm other than the primary algorithm for each
> > compressed file, which can be used for upcoming LZMA compression and
> > LZ4 range dictionary compression for various data patterns.
> > 
> > It has been stayed in the EROFS roadmap for years. Complete it now!
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > ---
> >  fs/erofs/erofs_fs.h |  8 +++++---
> >  fs/erofs/zmap.c     | 36 +++++++++++++++++++++++++++---------
> >  2 files changed, 32 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/erofs/erofs_fs.h b/fs/erofs/erofs_fs.h
> > index b0b23f41abc3..f579c8c78fff 100644
> > --- a/fs/erofs/erofs_fs.h
> > +++ b/fs/erofs/erofs_fs.h
> > @@ -21,11 +21,13 @@
> >  #define EROFS_FEATURE_INCOMPAT_COMPR_CFGS	0x00000002
> >  #define EROFS_FEATURE_INCOMPAT_BIG_PCLUSTER	0x00000002
> >  #define EROFS_FEATURE_INCOMPAT_CHUNKED_FILE	0x00000004
> > +#define EROFS_FEATURE_INCOMPAT_COMPR_HEAD2	0x00000008
> >  #define EROFS_ALL_FEATURE_INCOMPAT		\
> >  	(EROFS_FEATURE_INCOMPAT_LZ4_0PADDING | \
> >  	 EROFS_FEATURE_INCOMPAT_COMPR_CFGS | \
> >  	 EROFS_FEATURE_INCOMPAT_BIG_PCLUSTER | \
> > -	 EROFS_FEATURE_INCOMPAT_CHUNKED_FILE)
> > +	 EROFS_FEATURE_INCOMPAT_CHUNKED_FILE | \
> > +	 EROFS_FEATURE_INCOMPAT_COMPR_HEAD2)
> >  
> >  #define EROFS_SB_EXTSLOT_SIZE	16
> >  
> > @@ -314,9 +316,9 @@ struct z_erofs_map_header {
> >   */
> >  enum {
> >  	Z_EROFS_VLE_CLUSTER_TYPE_PLAIN		= 0,
> > -	Z_EROFS_VLE_CLUSTER_TYPE_HEAD		= 1,
> > +	Z_EROFS_VLE_CLUSTER_TYPE_HEAD1		= 1,
> >  	Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD	= 2,
> > -	Z_EROFS_VLE_CLUSTER_TYPE_RESERVED	= 3,
> > +	Z_EROFS_VLE_CLUSTER_TYPE_HEAD2		= 3,
> >  	Z_EROFS_VLE_CLUSTER_TYPE_MAX
> >  };
> >  
> > diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
> > index 9d9c26343dab..03945f15ceae 100644
> > --- a/fs/erofs/zmap.c
> > +++ b/fs/erofs/zmap.c
> > @@ -69,11 +69,17 @@ static int z_erofs_fill_inode_lazy(struct inode *inode)
> >  	vi->z_algorithmtype[1] = h->h_algorithmtype >> 4;
> >  
> >  	if (vi->z_algorithmtype[0] >= Z_EROFS_COMPRESSION_MAX) {
> > -		erofs_err(sb, "unknown compression format %u for nid %llu, please upgrade kernel",
> > +		erofs_err(sb, "unknown HEAD1 format %u for nid %llu, please upgrade kernel",
> >  			  vi->z_algorithmtype[0], vi->nid);
> >  		err = -EOPNOTSUPP;
> >  		goto unmap_done;
> >  	}
> > +	if (vi->z_algorithmtype[1] >= Z_EROFS_COMPRESSION_MAX) {
> > +		erofs_err(sb, "unknown HEAD2 format %u for nid %llu, please upgrade kernel",
> > +			  vi->z_algorithmtype[1], vi->nid);
> > +		err = -EOPNOTSUPP;
> > +		goto unmap_done;
> > +	}
> 
> Seems duplicated a little, how about below code?
> 
> 	if (vi->z_algorithmtype[i] >= Z_EROFS_COMPRESSION_MAX ||
> 	    vi->z_algorithmtype[++i] >= Z_EROFS_COMPRESSION_MAX) {
>                 erofs_err(sb, "unknown HEAD%u format %u for nid %llu, please upgrade kernel",
> 			  i, vi->z_algorithmtype[i], vi->nid);
> 		err = -EOPNOTSUPP;
> 		goto unmap_done;
> 	}

Yeah, good simplification. I will update it and rename `i' to `headnr'
here.

Thanks,
Gao Xiang
