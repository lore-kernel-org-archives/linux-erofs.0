Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4708F606A33F
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 08:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YTSKxyaT
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQDHQ5ngxz2yKn;
	Thu, 12 Nov 2026 19:35:46 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794472546;
	cv=none; b=bgxb6ywGYkLHWG2jos7pmyk3XXUBoT/UMAhIi+IzyZj1reOA2qXv4DuGk6P5/D5b+QT/flzxq9mlstnchFZsBKgia/aKw/GK0sPHb2apXqafO1tIvOr3+156LA61sZmcEYfLZRkG7N3yDE/xR2TWjrLXuEEbmZjtrYh/UV8kUF6t/kGlPj4hnTaTORyGjAfZdRIxWv7F68hGGQ5Tao6wqL+PDm+ovBE67gafvQpijO7Z9wmivZB94klWx1svMwykuD9ACq4sn4yGDXVXEoxpRqqL6He+0spo6x51vLbe4XL1RnFl8/UVQZTcaLEZur/9UT1uTW4y+FBIFPDJJ4iAqg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794472546; c=relaxed/relaxed;
	bh=XNVnoH84ojoblKEsbGjY6MwnVeoD3CB7drWnVXqG69U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cdjF41NuNsbQPw8KHA6tayrVPt33K/CMQvXciVeGUPx1WpWMKjCUOTEb9QY3lFdYJu9IgKMMK+Do/E2j3yYsw7hO87Oz1VCBBmPwKZmCYIr3ZGwoOusHgqoyi7ezZKzMNmN8LI7ICwSuwqfCSvuMMZmW9fioiFYFAFi5AJxfV5n2hchVBuYevgK9VIlzMHrDR7zlctoBkXB6eEuwBee+GvFyI9b6yjrpnw7oxrT31wHNWVlHs7k5kvRicCJ21dEE1qNWKxq2x85jaFZ+rXOAALtanbxYij88fFeCavHLll7QM94jJcBjvBwvRdO4GCCBt9sAgmnLZSQBgtnTwHBu9Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YTSKxyaT; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YTSKxyaT;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQDHP1GpHz2y8F
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 19:35:45 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 364C665405;
	Thu, 12 Nov 2026 08:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB671F00A08;
	Thu, 12 Nov 2026 08:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794472541;
	bh=XNVnoH84ojoblKEsbGjY6MwnVeoD3CB7drWnVXqG69U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YTSKxyaTvXPd4CBIQtOqEPtFtoKe3DFraOjqnaIpSc55PG5MCMNYPPZPBQp3ha8A3
	 xTaR7HcnduB7GMIzCPmYD1rSTs7bqQr041Sx+MF9sE4qxKGTUAp/vT+kzcLGaFKOnE
	 1Kwa5cTSFArAky+2kslNA7Rxv/oBDmr+AaNIYZpDXfWT13IJ13eCcWypO7fNUnEUEl
	 qSWl+62KM9xAbHRrh65yi6k+OupB7AWxEMNeusOz9cf1Cfyf7MxHzIBgs3nxeHibvl
	 UT9Jl59RncXMEkoBsmeUidWkXYdi/pulw1w6NwqDeahxc4V+JxSnhsKPVOFYWH+LbO
	 yx1X5f0S7b56A==
Date: Thu, 12 Nov 2026 09:35:36 +0100
From: Gao Xiang <xiang@kernel.org>
To: hudsonZhu <hudson@cyzhu.com>
Cc: Gao Xiang <xiang.gao@docker.com>, linux-erofs@lists.ozlabs.org,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] docs: erofs: refine the on-disk overview
Message-ID: <avV6WNCWyMxEA8ho@MacBookPro.fritz.box>
Mail-Followup-To: hudsonZhu <hudson@cyzhu.com>,
	Gao Xiang <xiang.gao@docker.com>, linux-erofs@lists.ozlabs.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20261112021905.36269-1-xiang.gao@docker.com>
 <78C49082-EE86-431E-A97E-20CEEF2FB352@cyzhu.com>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <78C49082-EE86-431E-A97E-20CEEF2FB352@cyzhu.com>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 01:32:22PM +0800, hudsonZhu wrote:
> Hi Xiang,
> 
> > Each inode can be located directly using the following formula:
> >     inode offset = meta_blkaddr  block_size + 32  nid
> 
> Does this formula also apply to inodes stored in the metabox?

Nope, the rule for metabox is slightly different, but this section
is a high-level introduction.

I will adjust this as,
 For inodes not in the metabox, ...

Thanks,
Gao Xiang

> 
> Thanks,
> Chengyu

