Return-Path: <linux-erofs+bounces-3738-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2369CDB46F
	for <linux-erofs@archiver.kernel.org>; Tue, 23 Jun 2026 13:53:08 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gl6370VLjz2y71;
	Tue, 23 Jun 2026 23:53:07 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782222787;
	cv=none; b=fJqZvsj0KjbujcKW8eYI6dpP4R30dWRZ1/jCdxkiDh96onHntvdMW8gc9E2pWHSLT/SvLPm1ampK7K/Y07ZYUoCBBR8JHHuOrLLoiS1ZqWsCCFryaG3mUdBX73yDK830G8vcnvNjT4gNPITqlWePTd6xTnGaHscZkFqPvP54Ri1m0BT+ay/7HTpaVqK5dAhA+GlSJvlhFgURPVsOt7FBa4J98akB1goJjJ7LVIDzeYJ/RiMlh+2HudM0lION6qhtms3QWoQsqntfU0w4WtdkurZfuKMNBdEJDiRLL4uGOws17r7O4NyIgYaL0NAOt4v5DR9K155RtYb/xxsNXQnt/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782222787; c=relaxed/relaxed;
	bh=IU35pXaCxbba6lk74nkqid4mkn3LULJzvPghf/ZGitY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ks1RGR12B/FpYlzpcxpjvHKCF7//avc7WRa6LiFSeHfTQX9WYpHZRmnlOvtj8F2Ie88WANf4j2/VB0yfnEXNUR3dVeT6aYB3HIgF5v+PBQlCCTVcJFVQM/BW8HFOgp6byLE9GlQXztj/ZLnUVC2JOgn/ptb9yskaaEZxgPtPWcL0kgc1cbYAfQthc8gI5+u0EczKvxoWNbGYYES5eNhPNZZ8V/q4ztSa0RMFNBhDa+mY2PYd/z6w8lSyyf3zmVZGmgm7GbFz9OMg1kNEZjjl4gb4i6RE7WX3guONuym+NIc/4wBYcHf0A4JC+RW3cKFwOd+qVFdOxkn2x7yG9v/pgw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org) smtp.mailfrom=lst.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=lst.de (client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=lists.ozlabs.org)
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gl6362kJnz2xM7
	for <linux-erofs@lists.ozlabs.org>; Tue, 23 Jun 2026 23:53:05 +1000 (AEST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 54A3968B05; Tue, 23 Jun 2026 15:52:59 +0200 (CEST)
Date: Tue, 23 Jun 2026 15:52:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, Kelu Ye <yekelu1@huawei.com>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: submit read bio after each extent
Message-ID: <20260623135258.GA8720@lst.de>
References: <20260619050105.439956-1-hch@lst.de> <20260619050105.439956-2-hch@lst.de> <CAJnrk1ad7Wxr9CB4P1=VZPUS_BRmHTTmRVXVgRjM628iFCZh0w@mail.gmail.com>
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
In-Reply-To: <CAJnrk1ad7Wxr9CB4P1=VZPUS_BRmHTTmRVXVgRjM628iFCZh0w@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 22, 2026 at 02:51:36PM -0700, Joanne Koong wrote:
> Does it make sense to move this line to the bio submit_read callback
> instead of unconditionally clearing it here? If we clear it here, I
> think this makes read_ctx only able to hold per-mapping state instead
> of also being able to hold persistent state across mappings. fuse
> currently uses read_ctx to hold per-request state (though this patch
> wouldn't break anything since fuse only ever returns one mapping
> covering the whole request).

I've done that for v2, also we also need a new argument to
->submit_read for that to be useful.


