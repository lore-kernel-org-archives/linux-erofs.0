Return-Path: <linux-erofs+bounces-4660-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD42FCA5FCE
	for <linux-erofs@archiver.kernel.org>; Mon,  5 Oct 2026 08:14:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hyscP0gPsz30V1;
	Mon, 05 Oct 2026 19:14:29 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791188069;
	cv=none; b=H64bf4Hh612dwQMZhoG8igyFNkj35bfQgZ4kVp7VhzhKpM5wN2l9s3r3PlA0kl+whfpSanX096MTDB+vwmI29Mg48NcpdWLkPqvSjBq+IcswkCd5H7pyl09wStom3ifBNo2qQVzZtOy5ERfFRvsLZk/fVmxtL7SyK07GX4l80lCxYB6HJCmEtCWm//TajJCklwflHiGv9OsEMR2uwbZ9U6AHtBVpSycbVHBuRrRLipLp7cLxpckERertPuiMITWfgWSNYa237jUuRr1uvH8zOwrrYYt9+PsAvhHAGKrpf7f8NM3eOMxKcqKFHK0ktCv+tw+3XBYvteO7+sG782683w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791188069; c=relaxed/relaxed;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GbnohnK9agWOwMwUgn3yB26yw8I4bfZl8xLzIDfyxP8wP0humVoFhNFRAlHyK5beYGCVmHAgB6PUxhJGVHV+R6NXI4miGR3bgdNgnlQPg6QIIMdVe7K90MlWRxDlfJ+PAI1RZVgHDsMC7KMDPA4QPBlNnojiSfNznoYi/oEarHUQ3xLP+Pd6qZ0MX8By2cHxrso5MSo9aDNvN5iJRfDu94ZORaV+2AX38zZS4WBGSnXLm/ADaghejPOKNXEecew93zcgafyal6kyka5WbaxNmdC8WJCA92p+k3wA8Mc8AADdM3M+0WQBLGs4y1BsiLI7kFV6DOuY8PjgFpd7BtHCUg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=voGYnLYw; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+468a587a01b7da22bf06+8443+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=voGYnLYw;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+468a587a01b7da22bf06+8443+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hyscG6v7Vz30Qv
	for <linux-erofs@lists.ozlabs.org>; Mon, 05 Oct 2026 19:14:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=voGYnLYw7LRWDRfrLPu2cB2s8s
	5X2eqIm72RX/YNF+BXZsY38xR2cXY8NvNI9nCNR0Y0kqTkz36vkXyjBIxrd1TUtD1/XaYVlbOjLDM
	zvaeJWzvUM7JZ2bB4IPl7UHCeuW7u6tiy75swU7z9ETqgbd/jeulJvZJC+6ikvkPhdUFpfu/sq1ap
	i9xt228JjzZU7Hzlx3SjVg3LVgnfPw7rJ5uLrsgp7nNqz5FN5oLt3bU/H/kzA5Xu+cwYhnHl/T8oH
	wo1q61GSzlJVXLtDUUqt2QkLmyVnJ/6q5TMkTkTFjGE9T69gkRDtaKvJV+zipgU6x8r6mUCU1OwIV
	AA/p3PAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDdpv-0000000FrJj-3n7S;
	Mon, 05 Oct 2026 08:14:15 +0000
Date: Mon, 5 Oct 2026 01:14:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Giuseppe Scrivano <giuseppe@scrivano.org>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	linux-fsdevel@vger.kernel.org, amir73il@gmail.com,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	hch@infradead.org
Subject: Re: [PATCH v7 1/2] fs: rename vfs_get_super() to get_tree_super()
 and export it
Message-ID: <asNcV-k_V0dHXGC6@infradead.org>
References: <20261002163225.1258203-1-giuseppe@scrivano.org>
 <20261002163225.1258203-2-giuseppe@scrivano.org>
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
In-Reply-To: <20261002163225.1258203-2-giuseppe@scrivano.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

