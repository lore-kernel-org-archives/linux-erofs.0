Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28941606A327
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Nov 2026 15:01:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jPmv66Q1Zz2y8F;
	Thu, 12 Nov 2026 02:01:38 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794409298;
	cv=none; b=jkoM5Jp+d0eovO6S1/0UPsCbqp0WiBAoweie1CvWMQeq7GetP8J5Io+vvPnfsAkiIyrUfCow0/6zRUjeLWHr/5r8T0mDG86VVGXB5rhB1aojCjZeJv2vNMIYbvvIWFTq0sUiT0x4JBH5mdRSvV3tyguw3MJpz8RbdGZ1x3wxN9F5UKmjBUMqkZn20LQ4rhpWlqUe9uUH9JLquaN+RGmztxXMCqJUEuDAAMxBxVr2zb8D9JyLYUNF5X/y9fdcLN6I5beHT8qLahsUHQEDglO9Bok6xbIeHMAnarUGvSPZyEWing/IG1PDnPQ4Vzjz1gD7+95QVfLJNYz+8UkrLhQUqg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794409298; c=relaxed/relaxed;
	bh=GonZG2wwIvN+gNPTSiAAkhawJ65Nfia9tR3JjSU8YK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TJQpC/y3KpO4eY6xGZ+CeecwxQzf1biMZBJbvIRRtTvUqUmFKG/jdvf7dfqm0KZXEivXuyTo85mAyiQfdYLP2svMewcN36WF+QHQW32bbJ/Ayx4N0x0Euc2C4HANR0B4NZmt5cPtkoEKOuBtkuf4o5yUeaMx98WiWhQB9MtODT4qvMs9oAVM641lauawT+vd2A4gpZ6rQpllNPnWKaYM2H999P7RfZ3Qkmzo5oge9i261BZz21CwDLKTJS8SlHZ9gCihp5wkVoqDnaycJ6g3GjqBhFVNwWAfLzmzMOPCExlHKIFxvyLAVymCvUg/in5QEI50hiuEtVKe0qT6B20Jfg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org) smtp.mailfrom=lst.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
X-Greylist: delayed 333 seconds by postgrey-1.37 at boromir; Thu, 12 Nov 2026 02:01:37 AEDT
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jPmv54n0Nz2xqr;
	Thu, 12 Nov 2026 02:01:37 +1100 (AEDT)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4C15C68B05; Wed, 11 Nov 2026 15:55:56 +0100 (CET)
Date: Wed, 11 Nov 2026 15:55:55 +0100
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
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH RFC 01/41] loop: refuse backing files that aren't open
 for reading
Message-ID: <20261111145555.GA9996@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
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
In-Reply-To: <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The fix itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But i wonder if we want a thin wrapper around ->read_iter/_write_iter
to do this check so that it matches the normal read/write path?


