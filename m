Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477C060A2612
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Nov 2026 15:04:57 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jPmyv6wS0z3bSw;
	Thu, 12 Nov 2026 02:04:55 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794409495;
	cv=none; b=PfhRlgqeZO7Lq/W9E5nZcueMjtLf52BcB9tLqiLFzrqFaAfnf9+5rnLLVLmGUjyBBS6b5e/4xnqSLzbHq59bFpKNDVJZSwaIFgmjWpfzOlzBB/3cCvWC8HPFaEw8tySugCPXkZUsQwIonwy+QUrqO6cbu/TYJUe8rlZjXN/igBUrTjwDa1tT4cudyNLXiF9cSAOvDeHD17ep61xpEGbAP8EvjMYkNPdofP9wb6vH21lfkCaXD15qJrWOgoWRWL4bYKJjpjTzOfgK0NPD63dyE6vAFoM4PONnKxNicTrY/ValDotCJJ1QZSyD0ix4g2v8yLRzvleyqAooi+qtBhQRng==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794409495; c=relaxed/relaxed;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g4SBo5fILeQOqW9UCX/P60y6moMwBV1zH/0rjgQWcXgMZiwFWOIYb/kQkv7m6zgCXJ7avGwk69wsPC03Ne/wiSOn+Y9qPtG8MNMCBb2t1gacx38BM/DOJoj09MsFjfasQVULXgqBFaZlsfoZkKe2xwWxvZNqOVWTBeNmivS9h2XXLqYAAXrKbpxyP/BGAWJceD73ewc9gAuq0v52g+wQLsGHXGOQ0sfCFAUTAQI8B5ggICk1of3BPu6S3wve8iKJpDDAlL+BWzOBSIpoIHqLx27PeJIpBnG4Qd1nB10KyvqDJVcVfGAUZwAq/IsJhY+Yb8Sp9KWW9PfKws/4R/UxFw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org) smtp.mailfrom=lst.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jPmyv1xbDz3bTj;
	Thu, 12 Nov 2026 02:04:55 +1100 (AEDT)
Received: by verein.lst.de (Postfix, from userid 2407)
	id A445568D12; Wed, 11 Nov 2026 16:04:50 +0100 (CET)
Date: Wed, 11 Nov 2026 16:04:49 +0100
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
Subject: Re: [PATCH RFC 06/41] proc: use fc_init_pseudo()
Message-ID: <20261111150449.GC10644@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-6-4c998976c6c7@kernel.org>
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
In-Reply-To: <20261110-work-loop-pseudo-v1-6-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


