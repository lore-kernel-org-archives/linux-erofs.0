Return-Path: <linux-erofs+bounces-4043-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D535C55164
	for <linux-erofs@archiver.kernel.org>; Thu, 30 Jul 2026 08:10:03 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h9hh92J6wz2yYd;
	Thu, 30 Jul 2026 18:10:01 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785399001;
	cv=none; b=joWm4Li7wqxmvCevOM9eXGNl+Wi9PSVKmRD8WaiPm4147IpLQ1jKN/RPaKtKAJQkWeMQKTyw3B95ZnjjYlb93ZjAkqIqJtOuO1qrtHL9pgGLlJG/fHznTuxc2HfDTdZ1vJOxSADfYDdxhtXhEIegVWOAUdTkijMPpkHaKo/D9hdUDsZYYo8lIR/nh3xd5dhVikEjyEN8ySZDf9gDYDPznvNCpZxcG85rFt+jhAtDysE6l6wX+fKIpdopENQZJJ9mXHXnkZCMCRtxTBPJK4oeIEKB8vAsrz/EjwgU/RDWNGZRB2/iua52i7HhG7tll0yTNE6+PxkJuNdnNVlofUqqcg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785399001; c=relaxed/relaxed;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eq2OlEM2gmW5dXnffLY9wINAltpCA+MHpVqY8xLdhFC9zTb0IESmSUOQ78gTRpcXhVw1kDij2wXHfQdy9w5A/CpEvq8pX2qtdpdw5uOV7Qtsqkd3VMuhLhUm6cTcQdjG9Gp9oWKpplPIvc5Q93pWW9XoIlObZvScyCkIz7WnplW2qJMOERtTQUUQWBVX9AkL6jKRPLNXHxNexYDrGiTNQX+/1Gqc8i5tSVWvgOLCS8VJZ1WPm9ahl0FXTa34FkedsRcIElXqZ7braw97cYfeSd2WhTKF8SsmvZQy0rqpnHNdoTz/zUIz8+YVRpJneAwGK0zznYiD/c2qCSYyF2f8BA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=rkL1tRhS; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+5608c610d26bcec1a9db+8376+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=rkL1tRhS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+5608c610d26bcec1a9db+8376+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h9hh84Jsyz2yMn
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 18:10:00 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rkL1tRhS589w27c03L/iKFIwI6
	bqAiqJcPrEbMpmjf9mx6+CvlgQvTU7eNHKmDx7/wlelA2aMnY8/8omcMw6NRIoGpPw9yluYMaWmBN
	gBQmZo4FEWUVM9sCigArBsZzj5O1Ys+LgIue0QQbekfW9lsELlNvSIjfdSlafd5L0K887M6qDXsYd
	YAntas6Ph1jM5eshuVoUY5F6RN5+iZq22oRLze+XlmEA6LmbzOFHuhYWSmAMINSckDRz8WhBpTWVQ
	evwpgZxaopjIniNiZnKWafNb4lNSo9TExbynz/nLC974xLOZxkorcKDOvNy+9N04pYkuuIkkTIg9x
	rV53T/kg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpLpp-00000009oaK-0q6X;
	Thu, 30 Jul 2026 08:09:45 +0000
Date: Thu, 30 Jul 2026 01:09:45 -0700
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
Subject: Re: [PATCH v7 2/5] block: add task-context bio completion
 infrastructure
Message-ID: <amsGyU2clNRBDYdz@infradead.org>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-2-3e8e6850068d@columbia.edu>
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
In-Reply-To: <20260730-blk-dontcache-v7-2-3e8e6850068d@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


