Return-Path: <SRS0=Or+M=PG=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE7CBC433EF
	for <linux-erofs@archiver.kernel.org>; Mon, 18 Oct 2021 12:25:44 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 239B260F56
	for <linux-erofs@archiver.kernel.org>; Mon, 18 Oct 2021 12:25:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 239B260F56
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4HXx115lynz2ywN
	for <linux-erofs@archiver.kernel.org>; Mon, 18 Oct 2021 23:25:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132;
 helo=out30-132.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-132.freemail.mail.aliyun.com
 (out30-132.freemail.mail.aliyun.com [115.124.30.132])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4HXx0x1y6Nz2ymr
 for <linux-erofs@lists.ozlabs.org>; Mon, 18 Oct 2021 23:25:36 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R791e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=12; SR=0; TI=SMTPD_---0Usi8-QT_1634559919; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0Usi8-QT_1634559919) by smtp.aliyun-inc.com(127.0.0.1);
 Mon, 18 Oct 2021 20:25:21 +0800
Date: Mon, 18 Oct 2021 20:25:19 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/11] dax: remove dax_capable
Message-ID: <YW1nrxmaw5CfFXBb@B-P7TQMD6M-0146.local>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>,
 Dan Williams <dan.j.williams@intel.com>,
 Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
 dm-devel@redhat.com, linux-xfs@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org
References: <20211018044054.1779424-1-hch@lst.de>
 <20211018044054.1779424-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211018044054.1779424-8-hch@lst.de>
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
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
 Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org,
 Ira Weiny <ira.weiny@intel.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Mon, Oct 18, 2021 at 06:40:50AM +0200, Christoph Hellwig wrote:
> Just open code the block size and dax_dev == NULL checks in the callers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/super.c          | 36 ------------------------------------
>  drivers/md/dm-table.c        | 22 +++++++++++-----------
>  drivers/md/dm.c              | 21 ---------------------
>  drivers/md/dm.h              |  4 ----
>  drivers/nvdimm/pmem.c        |  1 -
>  drivers/s390/block/dcssblk.c |  1 -
>  fs/erofs/super.c             | 11 +++++++----

For erofs part,

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang
