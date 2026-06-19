Return-Path: <linux-erofs+bounces-3683-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D275CD98F8
	for <linux-erofs@archiver.kernel.org>; Fri, 19 Jun 2026 08:15:24 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ghVlG4nn0z2ySW;
	Fri, 19 Jun 2026 18:15:22 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781856922;
	cv=none; b=BtD3sPowRXgrcjtmKwIO86FAaQJc7i1NZ+cAw0fVEq1r/e6VyFNooY+pWeamJ+l6GKQichBL4dVd2kYqng26MHQcwrO4dB+vkDxHWMBeKcAEA/zKFXACpIboOeLF0wC7OA1ImwjltfTpBBDKzCvTMW7GRb77+mJn6Cjq6xguvACQUJDSkwU5L4x9yFkk+1xzp/tArBl6CqzhANoT9h+jowr64kxlTBGDzRV0hBGSdt82s6skluwWOZ9ip3DDZSPmqTHgkltebkZ94T0ZuKe061V1/XF/KxsgvlLqsEiM+YXTjFI4gNppdqUoY4h1IkmB6xSlVFVkGotIdvqKEP/b1A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781856922; c=relaxed/relaxed;
	bh=H09kVhZKvVnGT/8zcbwbAdfiVXItBYmg1/F6osgjWjA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NPbGen1K9I7Ub36XpVtYy7HexT47fUiajqRhp7v5qwNxVo4prCEHeoDLpYwsY5gAhEpTcR7oPme5EqqJf42dMSEXPtoZ3328vt8q0cdL+5j7Xvab5YX5B7GlDCq3C483qtVF83rgR1eDhvmX8gxDwVTvbEr0pxfu2eHwf+DePgzK89B55PCMsxTgTvUfl/LZEgndagcxNbGENQRhTZgI6m4y/TOU9NSZ5Q9RxItks297AzTj1FuO84O9+6pWLtREVTbZBZlUFguP6RiYO7+zBZg9LtSD07M8b0wcV+BwvBOd2BqCvncclru6E8O9TIM6jaO6yXbfi8R9bwpprvLt8w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LoFrePK2; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LoFrePK2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ghVlC4WY3z2y1Y
	for <linux-erofs@lists.ozlabs.org>; Fri, 19 Jun 2026 18:15:17 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781856913; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=H09kVhZKvVnGT/8zcbwbAdfiVXItBYmg1/F6osgjWjA=;
	b=LoFrePK2t+smObhizy7GERDaBH8shJcDeChZvPB0K8JnoRMPsveMAFHDCxjNS9h6LFGmtfU6iOeZ0LCR15m44FfEPIOuYZepqiXS3tcUdc80dyp9teqqu0iOuIhW2dQSSFsYYWczIZRC1y7UkOi3iYSYDlK+W1wvcRa+jTob3ac=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X59ET.U_1781856911;
Received: from 30.120.66.214(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X59ET.U_1781856911 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 19 Jun 2026 16:15:11 +0800
Message-ID: <e2f45d1c-c4ad-482e-8a3c-8072209eec1b@linux.alibaba.com>
Date: Fri, 19 Jun 2026 16:15:10 +0800
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iomap: submit read bio after each extent
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>
Cc: Kelu Ye <yekelu1@huawei.com>, Yifan Zhao <zhaoyifan28@huawei.com>,
 Ritesh Harjani <ritesh.list@gmail.com>, Joanne Koong
 <joannelkoong@gmail.com>, linux-erofs@lists.ozlabs.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260619050105.439956-1-hch@lst.de>
 <20260619050105.439956-2-hch@lst.de>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260619050105.439956-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/19 13:00, Christoph Hellwig wrote:
> Currently the iomap buffered read path tries to build up read context
> (i.e. bios for the typical block based case) over multiple iomaps as
> long as the sector matches.  This does not take into account files
> that can map to multiple different devices.  While this could be fixed
> by a bdev check in iomap_bio_read_folio_range, the building up of I/O
> over iomaps actually was a problem for the not yet merged ext2 iomap
> port, as that does want to send out I/O at the end of an indirect
> block mapped range.
> 
> So instead of adding more checks move over to a model where a bio
> only spans a single iomap.  File systems can still create iomap
> that span more than an extent if they want to build larger I/O.
> 
> Reported-by: Kelu Ye <yekelu1@huawei.com>
> Reported-by: Yifan Zhao <zhaoyifan28@huawei.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

