Return-Path: <linux-erofs+bounces-2114-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B87C2C44502
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Jan 2026 09:53:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dwzym2qPjz2xqD;
	Wed, 21 Jan 2026 20:53:04 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1768989184;
	cv=none; b=iJnod4lpmBtz4FG/pjN4nu//52vEFwMd4tsbXSY6/2CLpyEFhPO9wFNWli6qXddHI+qS++Xk57PV1fssoVvawcncSr399+HMghcsL0GdqJEE64paS5A0HF5IdyT7G9GlhPnAXFEC6SzSTUtg8n9VVROp0jwvDNiRJudHFd8zsHvedpUuc7aIkw882xv2yG8XdQC/JA4tFMKUf44NtgSLCX2l0E7zCzXnfOCE9+BMODwLHIvDt/53fdCcJ1vTz6Qk9EXllB/B2Ez9zaEs3a3BH1jOPyK+lJR0vv2gR7s36oqsM9YcYC3ahkqm3tf+CU15z2+r8nDge8QvwXIfXp8Hmw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1768989184; c=relaxed/relaxed;
	bh=PBJOlGAHQuV6fK4m59wMQs9zml1XrtHGpIQe92sdocE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vif551Ok0lGFpVPBNnNXM4Mts2DxGFMNYUZ9jN4gVFzJ0nQL8kW2VJqVWALQv6jugX5ZN86iF/EK6ZWXcmz1n+qrmiB9d6mMfQrr9NrFyqSZhr9EDYiIgmKJbOIOX143OTfEgZ5mO6AR0XbAk4+OSaohjppqOVzP2CdWEq/td4I4tQV23s53h2dohFNkJlpfHNFZrDeadCBaXVYuAeZUuE/wBDBE+kKneonOkU1z81Wiw6BKto5JwHzQxTh2PX/FtaEHiTrJhVZKIha0UpGRoqhh/OWUYbuPN5Get+kZxu+Ms/5/utMNPALVC/pQSR3Ocj11mZ5Ie0TGNDe3M217tw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=wHU0Zulf; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=wHU0Zulf;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dwzyl5qSQz2xm5
	for <linux-erofs@lists.ozlabs.org>; Wed, 21 Jan 2026 20:53:03 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PBJOlGAHQuV6fK4m59wMQs9zml1XrtHGpIQe92sdocE=; b=wHU0Zulf9wG1GWqFnY5yVggCof
	mLydz5OPkY7zp9g7d+yCcH2YzhOZrnHnkVnMmzCmzcNaZ6/6tBJ65SVG+qfeucInj0l0K2D090saB
	OTkun6m7oaDpgwEEmsnayhH2VkCErcrZYpRhnGa/faRG4AbIN/MDBJVKszYg42XsvYACeDCPivLJw
	kyMmL1d4VAGbsEO2t7KXcoS6Vvf14XUxxhJIVdZEkvODAnaLlXlZrIHJxXidrVbE8sgjQCvKLlYyG
	T1WGJET209MDO5bYoI9YMbcisUnYoJAqrcHCiktzGDCHtCbQb3CB82dv+BFL3Oy0BcF9EIaE3BXRr
	j55EDQiw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viUtD-00000005Dic-3hpF;
	Wed, 21 Jan 2026 09:52:39 +0000
Date: Wed, 21 Jan 2026 01:52:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Christian Brauner <brauner@kernel.org>
Cc: NeilBrown <neil@brown.name>, Christoph Hellwig <hch@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Chuck Lever <chuck.lever@oracle.com>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Carlos Maiolino <cem@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-ext4@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-nilfs@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, linux-mtd@lists.infradead.org,
	gfs2@lists.linux.dev, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
Message-ID: <aXCh55UplHkplhFe@infradead.org>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>
 <aW3SAKIr_QsnEE5Q@infradead.org>
 <176880736225.16766.4203157325432990313@noble.neil.brown.name>
 <20260119-kanufahren-meerjungfrau-775048806544@brauner>
 <176885553525.16766.291581709413217562@noble.neil.brown.name>
 <20260120-entmilitarisieren-wanken-afd04b910897@brauner>
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
In-Reply-To: <20260120-entmilitarisieren-wanken-afd04b910897@brauner>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 20, 2026 at 10:04:02AM +0100, Christian Brauner wrote:
> > I actually think that what Christoph wants is actually quite different
> > from what Jeff wants, and maybe two flags are needed.  But I don't yet
> > have a clear understanding of what Christoph wants, so I cannot be sure.
> 
> I've tried to indirectly ask whether you would be willing to compromise
> here or whether you want to insist on your alternative name. Apparently
> that didn't come through.

Btw, I don't think the name is the primary problem, as we seem to
disagree even about the problem space.  The current patch series
from Jeff helps with the stable handle problem, which is an important
one, although maybe not the one you and Amir care about most.  I care
about it most, because the addition of unstable handles caused problems
and I really want that fixed before it spreads further, and I think
anything mentioning NFS in that is factually wrong.  If we need
additional flags to work around other issues (as in the list compiled
by Neil) I'd still prefer them to be named about what issues they
deal with, but folks get too tired of that I could probably with a
"NFSD get the f^&&& out" name if we'd just keep shouting at each
other otherwise.


