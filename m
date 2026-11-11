Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C018E606A8B7
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Nov 2026 15:12:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jPn7F3HrSz308H;
	Thu, 12 Nov 2026 02:12:09 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794409929;
	cv=none; b=JDKXMPgyPIpzmQXzkpRhrEKOY602xsUCY83C5Lb45yNo4F2VHJ8xwK5jVn3TSsQ/q3G/97ijayifMRlgQ7/O+J8qDmNftvX6F57qCjrclSKpefiRlHWW/Q4vUL6twfBviwAN3ijmC3HWpYLAs2OyEtbHVCN+kfEanWMbur0bmKqJL/yPzzeGvdLYxS84GQYhTER1CF1eFBqT/NWL6I9aG1YBfMH9o5SIFSyDfaihU68gGVKr3V9J1tPyY0+fJSWpqJLCXWiclSb3v6GBnnMxRj9qdOEUv6PVJ/smvZ4yjS+35NkYEudNGVqXLUVuf1P0SNspNtWJKA1rkIPz7pY/lw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794409929; c=relaxed/relaxed;
	bh=dehBO8Yxo1qlGsyLOmGqdqT0CExk2sS3MX1Vk4oa/6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GSNYqwr5ZPNtddokZXjw+sWz/rrQQY2cOluDK4gG9tm37mO2MhldcXF7v9ILbnRC61g4hxnoCxwY2TBiNR9ke7FkZS69iBVDWfAim8tDZR/VypHciax8/tO1XtvsAFkPjdRKduspX75BKnCqrBtZOfS4K7kWBOnMigLSt1tJqXLpoVYa7GuQKGWbsnXYOdSzNaglg88aa78hdZZndWsWjoXCvo26OoOba5jIWhdiS9uIXVxmkhLRlbJPwtvOTzwIXffohJuSTC5ZLt66Fxr75QfJ+KU4uak5Gnc3IsaJkkpsRrzxROtqdwwomg0vIRkEkLWHnsiJiwnTZkL6BDvCqA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org) smtp.mailfrom=lst.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jPn7D3b2Mz2y8p;
	Thu, 12 Nov 2026 02:12:08 +1100 (AEDT)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 52A7668D16; Wed, 11 Nov 2026 16:12:03 +0100 (CET)
Date: Wed, 11 Nov 2026 16:12:02 +0100
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
Subject: Re: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
Message-ID: <20261111151202.GA11391@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
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
In-Reply-To: <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I've seen setups where people use fuse to mediate access to sysfs
sysfs in odd ways.  No idea if that's still around, but if so, this
patch will break it.


