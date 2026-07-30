Return-Path: <linux-erofs+bounces-4042-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A261C531D0
	for <linux-erofs@archiver.kernel.org>; Thu, 30 Jul 2026 08:07:08 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h9hcp16Fsz2yjp;
	Thu, 30 Jul 2026 18:07:06 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785398826;
	cv=none; b=ljYA/2xfFdnb6nv/7Uj83/qvNLpnax6ayZ4wbbW7YdVJCWtrq57ZnxD9f56ndr4+izOBnwNoXKC3MM8AXxtEutKd1NvhJdy6s6podFPFcKvGuGJBd7nbajEwL0XezcqNXZzrdymR6QpgtTdspUig//TgxuRYdANBkKM88CqgtYE0aJWePoMINWd5iME0sb1+Z589UayMmHrGlF0FBPr56T5ujGmrsQZbv/VAOVp71BQJjO5X5e8mYohZejx8+81XGc2I96BKfdVrF2ph03QLqH+MNcCNAwq7ogMQKy8dA54byFVcgoKx3hGjC+JOFv+dfislUGogJvOy6CP2wxTzYw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785398826; c=relaxed/relaxed;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UE63d1IwTD18MBcDWAdSHry4vj4cBKogKEcy2rc3gPw/lkj2On1om5cX+8ISf5ntC6dj7boLUXUbZJcI6dnUHdoLGd8oevPbwGT7LdcI4oThv4XmeFMWrWdr7uA6gVPExKexGOmPznPqFRwMXM+lIOolTnFkJuZz+7PxdZmCkZqnStJmmASGde2qGfmXHEUwjMB3uQ6o0Odu6leCfHfb+t+ml8Mqz93qd0eniFQ5Svct8Qh7rsj1OVFzD2HMUn68cOXgqDr0whpoTKKaBbAl537LXaLI9pDE3/ltMfraAC7nTuI7Hc3k4MJ5M8OolZ8b46qr6OwnCjG7gkdy0N3/DQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=MpSKyd6b; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+5608c610d26bcec1a9db+8376+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=MpSKyd6b;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+5608c610d26bcec1a9db+8376+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h9hcg54mcz2yjR
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 18:06:55 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=MpSKyd6blI4PZs64kwm5+Qkg5P
	OAZ7P8IO4Dc6J2fsN8yU4R8qIwqHZnmMsR8WXrNUH/NvTBS8SXGx1onY1MKpZUNL3B7bhH4XdnS97
	g919bzj/aB+Vk+7R5gp3ae3L65moj5W4cV/wEM/b83V7c6IvGXd4nrEeWRt+4RnpQiWLFkbcY/5hH
	QUAXyR5kEwdu73XkqndRsA7x7zpahd4p/suJqHpFw61W7nvz6iRcMJue15/gaX669U5dOfVXXqWGX
	qaFvPuubpO8Rel8kEKXq/fNljPuIKsKxBxBuQ0sNKQp7WDw1jtLGSEV19c0nfya1Hnss6bVmSVdv8
	h/Pf1KCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpLmm-00000009njp-22pZ;
	Thu, 30 Jul 2026 08:06:36 +0000
Date: Thu, 30 Jul 2026 01:06:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Hillf Danton <hdanton@sina.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH v7 1/5] block: introduce bio_in_atomic()
Message-ID: <amsGDOQZaCqQMBtm@infradead.org>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-1-3e8e6850068d@columbia.edu>
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
In-Reply-To: <20260730-blk-dontcache-v7-1-3e8e6850068d@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


