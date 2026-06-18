Return-Path: <linux-erofs+bounces-3670-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35AA2CD98ED
	for <linux-erofs@archiver.kernel.org>; Thu, 18 Jun 2026 09:01:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ggvpl0tR1z2yNn;
	Thu, 18 Jun 2026 19:01:19 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781773279;
	cv=none; b=PLBP8Qy/maq0irPcPKkOXypMWYthgvusIR9qodQ2PoimhztY5gjxLZxPMtgJZ+CsUo9cU/stTbf5xuHdV/BXsJ8CK/VHwWv7LPpT9UBLmuSuD5ea7Ug3yK0QVbHXP/YvOxKPdJ+InDVhvXcdmbLvRRvrpOAAOswW+qTMAQ1T5T7nqmFog4yoKhvqDSoykYywheN4eYP+/UVoovxp5mqGFuYlxtmeiM228qTpxgP/l9hviZ2MEaLXVbH9f0j7TdDBQBY4PtcNyo8XLo610KuUN5Tq3WM0uzzNTrE6fxY3hudxyl9uP4aMlzTdv0bB1x1gNw8w9NuXLeIAe46sXjZrrw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781773279; c=relaxed/relaxed;
	bh=M9EeFcKrsMF7BhoQjCI346X+ZOMEwg/R7gAke80GfVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KAm+ChkO+dl/CRNdlcCMjq7aZqTK1BSCZWZYdPhV4QdJT+E8OGpDwZUZ7MlFVwddRwfz5AdXH/ZTpOuiWxVb78tlLu3coNe1lmNQvnWbVdqYozQJid83xsizKRy7d7C0z65soy+4fPVFKdIByWbL0c7buEvVtj1leAnNGoLb5vBPpbhriAHsoi/3WS73qaKuwO+dj8A8az9plipPwFW9lIU0huI6sS5vKgEd8hK2qyTfLvAytERr+LC06Rt3L7vznAlxsili0I426yqEFFTtNYEsHRnaN7/zyubk2fF/9U28xZo04OZcL8tQ4rmEpb5TIHxRmQ1u420XIpieC2H2Sg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=p4iXdViK; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+d0115506b4e64763d629+8334+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=p4iXdViK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+d0115506b4e64763d629+8334+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ggvpY0gtYz2xLm
	for <linux-erofs@lists.ozlabs.org>; Thu, 18 Jun 2026 19:01:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M9EeFcKrsMF7BhoQjCI346X+ZOMEwg/R7gAke80GfVI=; b=p4iXdViKvbqf6kRpw/cqG3Blwa
	6C1K9QAX6RilcSbbtwmuX/qVu/9ZC9qD2CbGR4GsoseTTprHtyPVWYUdF+WPaqcRq5No3aOVj4snF
	KgeBky4jqCsXBD7v5nK98j+u8QXMs0Lez/NEW46AB9BlZv3yxgLXldXr7403y3TEbMHfu+fk4wrP8
	oNE7wt85e0cz6qBBc0PJErX39MXQf5zHOibI1B73aiixUJYiknhsaDSLiL3IlMJlaOygj8cqZQr+q
	MWNvdmn9CVpEGytH/VmlAj16AgLGAvl2huoX9KpHS3adF+lzg6Lz+2ELB899KUxAivCV6cF1zjcG1
	NdUtNW7g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wa8cN-00000000t9z-0HKT;
	Thu, 18 Jun 2026 09:00:59 +0000
Date: Thu, 18 Jun 2026 02:00:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "zhaoyifan (H)" <zhaoyifan28@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	yekelu1@huawei.com, jingrui@huawei.com, zhukeqian1@huawei.com,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	Joanne Koong <joannelkoong@gmail.com>
Subject: Re: don't merge bios over iomap boundaries, was: Re: [PATCH] erofs:
 prevent buffered read bio merges across device chunks
Message-ID: <ajOzy2NPD2GlXcNt@infradead.org>
References: <20260612033244.993507-1-zhaoyifan28@huawei.com>
 <58bef9af-0926-4948-b917-e38c3793f596@linux.alibaba.com>
 <aiumQL8LEWQX_Nag@infradead.org>
 <fbc281ab-09ba-4e3a-90cd-2babc708fdc4@huawei.com>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbc281ab-09ba-4e3a-90cd-2babc708fdc4@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 18, 2026 at 03:16:03PM +0800, zhaoyifan (H) wrote:
> Hi Christoph,
> 
> 
> This patch works well under my workload (at least correctness-wise). Thanks.

Thanks.

Gao, do we need any erofs updates to go along with this to not regress
behavior where it would have merged before?


