Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95077606A33C
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Nov 2026 09:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=cmZW0raJ
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jPdwQ6BS9z2yDD;
	Wed, 11 Nov 2026 20:47:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:41b8:202:deb::311:108"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794390438;
	cv=none; b=DblUcOOkl5/ZpNXZVgd2UzRhCxHR/LCHNGo5w9RSNE/tfKjs1xQWz6oD6mYyfax2qzjGUFFCMsFT7Yzv7QDpTVTUrB9ySnOmOzXhVevA740p15uDV7/IkrXjrZtQEQ4BieGeg2UqmUN/KTCzeonm0Fo9jKIN1Gsd8etn/1qVcBrXSp15ecmvd3XinE9ImzImIV5sh227zx4Z6v99acaqft9CXJIW2S/knbFLkOjK23y/gqiaAVSMvD5EgbUODmHK9F4Rbp1LTa+POQT4PwRLvGLVyOccWp5LKsBuIhsMwTTFqwzXci4XJSBjIRiSdLHnWlLZpaGKuyRdPT8bZeiuHw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794390438; c=relaxed/relaxed;
	bh=g4FJ8o8UQUtyD0eGI0sUCpicqPvdI4Vdc4LMM0bmn0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E0FZa5IqLA5o1k4BsCSUrnPrL9TbMf1q7ctvLECVkqSLDCvuqPgoyJ632TPtPI0K2Y9GXq5HZl/ezAL34BS4ze1inFD86eiDLwYwac0OIg8ZpgK49gjXdU1KxXWJDe/yO1yMzzPkymO3/W8kO1DGlrzJpJOns8L/s9UZXqSpXi6H/oeV/ly0R213EXrVWJMlHxqNfRr+wYuQo1g9/CzZhaJ43pMeiG/86Est6ICCMWg60UjIpdUcNcdO3oUqfVZbxS9K9ZtHiBgxLWGcqDDH7kU884uyHM/Jz4KKxjQ/zX1TdbrLdX81TA53l+7MEu+++F8WGGQgBQJpyK4IKOmUrA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=debian.org; dkim=pass (2048-bit key; secure) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=cmZW0raJ; dkim-atps=neutral; spf=pass (client-ip=2001:41b8:202:deb::311:108; helo=stravinsky.debian.org; envelope-from=leitao@debian.org; receiver=lists.ozlabs.org) smtp.mailfrom=debian.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=cmZW0raJ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=debian.org (client-ip=2001:41b8:202:deb::311:108; helo=stravinsky.debian.org; envelope-from=leitao@debian.org; receiver=lists.ozlabs.org)
Received: from stravinsky.debian.org (stravinsky.debian.org [IPv6:2001:41b8:202:deb::311:108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jPdwP5yqjz2xLq;
	Wed, 11 Nov 2026 20:47:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=g4FJ8o8UQUtyD0eGI0sUCpicqPvdI4Vdc4LMM0bmn0w=; b=cmZW0raJpZImC504fK0B0kMd2h
	XJQXfLj15TrbtRxuoXIll7+dYj88ZVAl2AayT9vhDBlAQ57+Eho/cFEk5It94wIbKS4EH4G+cdutI
	0K9jgabrgunrLX95HA3KOWeYRz+hLh5iGe5EyD3w5xx8w9MzCtlstOcNUcfrAtIPd3RxiWEjnELaD
	hbo41pU2e/eygmvhOngKp7971UVKKEY71/mIvuWf0WfaOur34IyUdpGFowB9/oVJFRm81ZxsZDxLw
	5M54Kif6OKPedXxyOCO9YpK4/4uqCIxZE2p81NHj3kV9mf9cnMGZSmbBCsLntHmPvgWT1OTOymjci
	CwvzesXA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xR4up-00D5nW-2D;
	Wed, 11 Nov 2026 09:46:51 +0000
Date: Wed, 11 Nov 2026 01:46:43 -0800
From: Breno Leitao <leitao@debian.org>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
	linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 16/41] configfs: use fc_init_pseudo()
Message-ID: <avQ5dv0747H-XKmD@gmail.com>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-16-4c998976c6c7@kernel.org>
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
In-Reply-To: <20261110-work-loop-pseudo-v1-16-4c998976c6c7@kernel.org>
X-Debian-User: leitao
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 10:14:32AM +0100, Christian Brauner wrote:
> Initialize configfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. configfs never holds executables or
> device nodes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Breno Leitao <leitao@debian.org>

