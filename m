Return-Path: <linux-erofs+bounces-4469-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38B8EC61DD3
	for <linux-erofs@archiver.kernel.org>; Thu,  3 Sep 2026 14:49:29 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hbMtv3T3Yz2y2R;
	Fri, 04 Sep 2026 00:49:27 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788446967;
	cv=none; b=XwxuQMzVYbm6y/mM2YuLuN145KxtQR/oJTSwgzj6LPhmYQPgkj53eCqrGdyiUCkbBE8HsqZgOv/mNbaNMEdEFoiUa3CXpprnvNlpI7yiugrTxY9EPHMyjfkbO+ofBSHpZItNcHZZ2Nv+NkpEItf6SikiQzzEA+WHOMT60siUc0ozckVNrtuOoFS4a6rdajkMopSfI9JlNCKuYWiZbxgJO6AVylldEL03LqvRN2xWi/DFc68i5Yy5ATH+iRXH4Ftl8uJlPiF3lHCoDUgHupNcSyGQvyUXsERqwva6GLTGt7ArV1Vu74boiybzmb4z46f4NB5GKPnPlCwoOlkkPoEAVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788446967; c=relaxed/relaxed;
	bh=qHs/hYcfdCQ1ysGE+hmGWWr3Mk+We3imbSb6wYOC52U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gskY/p0mgpnXv1J6AjNGLPQw+UfR4EaFH+beAoA4fT26MiLRqvkKkk3SD/g8LZqX7YKqjsA2jw4yvShKgXwbqC53VJw9/On6NsuDn34cbT63efjPPNSF4xaXAiH/E+n6wKgSf8Dh79tO9DzNIOi8/HTbWDi5Vp8v/AryvToLJfCoSsgpOcjLzoicUpBPcT69NHUaR7CXmE69GbhsBjjcIerAsZnBXWvbAFt+peuV5Rm+1CVYz7d4R4iLSadAMZ4DX1Pyke7aC38EhyfKWP/KbA0lax+sjbRsdK55lm2MMF06ITMMxQQw1MeVG+kDnmquFk0AWfkMKyY05TtzeObz6Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=mit.edu; dkim=pass (2048-bit key; unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=QJesqE4T; dkim-atps=neutral; spf=pass (client-ip=18.9.28.11; helo=outgoing.mit.edu; envelope-from=tytso@mit.edu; receiver=lists.ozlabs.org) smtp.mailfrom=mit.edu
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=QJesqE4T;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=mit.edu (client-ip=18.9.28.11; helo=outgoing.mit.edu; envelope-from=tytso@mit.edu; receiver=lists.ozlabs.org)
X-Greylist: delayed 165 seconds by postgrey-1.37 at boromir; Fri, 04 Sep 2026 00:49:25 AEST
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hbMts6F8Sz2xWR
	for <linux-erofs@lists.ozlabs.org>; Fri, 04 Sep 2026 00:49:25 +1000 (AEST)
Received: from macsyma.thunk.org (pool-108-26-156-67.bstnma.fios.verizon.net [108.26.156.67])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 683EjLMF011651
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 3 Sep 2026 10:45:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1788446726; bh=qHs/hYcfdCQ1ysGE+hmGWWr3Mk+We3imbSb6wYOC52U=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=QJesqE4TZVDMmqCP0gYnKzQVE38G5Sj1uHY8Px+6ZarWBBRuhH1Fwb1CRJ5tJPRFV
	 tmOiLD28kscOP8nUwRZQsNO/wuT4KMKK12aCBaWLHnxjUqbgUTwmyQBvTJ2mBkZ+88
	 /QN2pl7raeA9OfyGDIqrh4LXvngd7aOvgPf+U75IMT4tmP+CjfZpnKL3Ym4RgOG14t
	 k28ord6f1XO1MU81Az2eIi9VgraAJBU9HpcZgM1M3J0UIfdl859jwgeG0NbUVpFB/V
	 7p2L8VgjrjdYi/84CLpjr044H60KgLgzIYRVIAI7c/vwX2bDYIxq9mAEVxUhO4HVWN
	 LYHu+Y27eWAuA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id BA709132623E; Thu,  3 Sep 2026 10:44:20 -0400 (EDT)
Date: Thu, 3 Sep 2026 10:44:20 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>,
        Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
        Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org,
        ntfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/9] ext4: Remove uses of FGP_NOFS
Message-ID: <apmHuRN-r4gfWnTX@mit.edu>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-3-willy@infradead.org>
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
In-Reply-To: <20260830041901.2668-3-willy@infradead.org>

On Sun, Aug 30, 2026 at 05:18:49AM -0500, Matthew Wilcox (Oracle) wrote:
> Both of these locations are called while a transaction is in progress.
> Starting a transaction uses memalloc_nofs_save(), so we are already
> prevented from recursing into the filesystem and using GFP_NOFS was
> unnecessary.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Acked-by: Theodore Ts'o <tytso@mit.edu>

