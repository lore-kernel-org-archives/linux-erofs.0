Return-Path: <linux-erofs+bounces-4605-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B0AEC9830E
	for <linux-erofs@archiver.kernel.org>; Fri, 25 Sep 2026 09:21:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hrlZM52sVz2yHT;
	Fri, 25 Sep 2026 19:21:31 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790328091;
	cv=none; b=TvJT75u33xwo7ncWv5jHe+G3rcaAvPZPN8CyUCqFvYxghC8eMp9KqFMgweQPIaHQahEwT2/CtjoPl/zEbnFlEa1CcmAKP7OytwGdk71rf/7oTdiVeJZe/jbE+ZhSu7qEUuAjgx3qyncJltotwTWRZPCL/6LBdOXjASlLelSKOQeelDoKlVm1Rg9bZLsozmyTVWD4vLY2LD2IIzJR1m+1mmEcUwVIWyPKcuuEqCnLGnACd1pYXRd1KqxtA853I8oKVDRK2rVsAXA1FhcdJ1IauP2zl65E7mc2Sw2tLKuieLDy/kfrch7RhfZVJOVIVgTNmVav6DLmOS2foCYJrpMCcw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790328091; c=relaxed/relaxed;
	bh=iAdE2cUqIYJRNN1QnfwzdIju6pGQadjufo/cgrRaeEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YZ/FmOxeBClL7oZqeAhZg4cYUyJBNQ2Q0v+tZu5PZl3+i1XHyL9acWoXG84+0B1PSx0UkEuER5yTazpmdYF5tzRdDu73dRsG0qdwJOzOvyJKX/ytuuEzWBwz2Qu7lgzdP5nHLC3c35HM3IyWqINpiSLEA8uQm2O5WjhQ75wPeXOJEQosjKhN68i9mFK/+5fay3+2voGMrx3Bhf7V/KDFWr5H0Bwh9r7BjAOTp4MViFzkJPW1Z/y+JAxHI1Ka/OdvdBlowTw1JgmsUAnZP7P6UNlivfRnFZGGFgE8mcNIr/oR5IepK10sWk71ThvDlj1LXyaJvqUkgt07jNDyT4EAsA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=YVXCk9fY; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+07853672776bc0ba7c7e+8433+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=YVXCk9fY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+07853672776bc0ba7c7e+8433+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hrlZK6l1lz2yDD
	for <linux-erofs@lists.ozlabs.org>; Fri, 25 Sep 2026 19:21:26 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iAdE2cUqIYJRNN1QnfwzdIju6pGQadjufo/cgrRaeEg=; b=YVXCk9fY071c5n/97Tfn3AysdC
	wCnWY+36/MlYgll3ZQn6G15WmzeWeFrVp2AagBJLVr92x+ZFdCyNhG+HtGC3lIofwumh91hOyvqYA
	cfxRVrmzwbQVJA59cLmD+UcWhZVV6NAftzPmMge/uQyZTuHr0hvhTUtHExjPUuQeepGfvGkReWkOm
	yxiunXNrZbi/MRDAzmyNQAyN49lbM+wLHDMLc8iyLdUgrY8bKFAPwK6hNivAcuo7FHRWMa/ZjoX3c
	MdX+U09KBXRVnSrl5/GDk5O5oHjCrUY6tOnMdg2hPJwv1Xlef5tXVlsQCB9stOX7paWmGa7p6Gp3J
	j4BW37lw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA27Q-0000000CzT3-0ZdE;
	Fri, 25 Sep 2026 09:21:24 +0000
Date: Fri, 25 Sep 2026 02:21:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	linux-fsdevel@vger.kernel.org, amir73il@gmail.com,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz
Subject: Re: [PATCH v6 1/2] fs: rename vfs_get_super() to get_tree_super()
 and export it
Message-ID: <arY9FCatWwCw418K@infradead.org>
References: <20260812142907.1010046-1-gscrivan@redhat.com>
 <20260812142907.1010046-2-gscrivan@redhat.com>
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
In-Reply-To: <20260812142907.1010046-2-gscrivan@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +EXPORT_SYMBOL(get_tree_super);

_GPL please.

> +extern int get_tree_super(struct fs_context *fc,
> +			 int (*test)(struct super_block *, struct fs_context *),
> +			 int (*fill_super)(struct super_block *sb,
> +					   struct fs_context *fc));

and no need for the extern.


