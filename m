Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2661606A33A
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Nov 2026 15:05:55 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jPn023x7bz3bkg;
	Thu, 12 Nov 2026 02:05:54 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794409554;
	cv=none; b=SZHwuaOWLUDtDAAq/zLBkwa5Fwy85N+eLorqS/i5yAHBVKNRglFsD6l6svoyzOyjSIKWVaScA4s9EXv/D4F91x7caV0eNuOyIBiLdg07u84HuqBveKuydf3ZjR6h5z04zpC3uega8Xd++JVYHiKg5y8svgo9h/vI02u1JCH7EEvPC1+Mk6FCNrPs8ut9zoIByg2rUgAnilTUw4bRHszLCZ8qgv/b3o/yeZiDKpWLfpj5ouxWviYjxacgGG+18DkyBVOXNoUwNriU14J0Iuql8wILVOwBr/Ii44RdvTxGDYgAA3GB2/FgOda2YKP25oqu+WnZtfqKOY74qNn0ROkMvg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794409554; c=relaxed/relaxed;
	bh=eTh/pZjfcHNyaYvHc1i0brd4au2XXqBxglcFJNmjPBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ddLUsp2vuZeuAIClEgvIF06i00GsBNc7bCs36C3MWligE4dUyknXuoyMMqh0F9ci6Bnn2AaVkXV+jpGAr48yR8LTBbojxax0DxNBnEliI4d8LVP8HfWFJKpjv2UWDFOTy1HPiKdSupNEcBrvDaUVMmGbiu4l9zTte9kEe1qCFfpzzag90K/5nwuTiGRvtjG7RmzXYW1OWziBqiYwLmXtpIPwkQATOTj7ZBFv7skSKIb0oZ39914WGLRKadc9pCIL4lJkpnIN7agq5P+rYSqMSRH4uYELTYPP6EKTOtBU9xZVwMXz6T5ftBhNL8I2/Ol89NNAR0WfKJ4ii/A8gv3S4A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org) smtp.mailfrom=lst.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jPn016Glyz3bkb;
	Thu, 12 Nov 2026 02:05:53 +1100 (AEDT)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 484DC68D15; Wed, 11 Nov 2026 16:05:49 +0100 (CET)
Date: Wed, 11 Nov 2026 16:05:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 11/41] failfs: use fc_init_pseudo()
Message-ID: <20261111150548.GG10644@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-11-4c998976c6c7@kernel.org>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-11-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 10:14:27AM +0100, Christian Brauner wrote:
> Initialize failfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


