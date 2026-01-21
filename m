Return-Path: <linux-erofs+bounces-2124-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D24D46947
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Jan 2026 14:47:51 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dx6Vt1crfz309S;
	Thu, 22 Jan 2026 01:47:50 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769006870;
	cv=none; b=ClpxhtlxQdK4I7UAu8jdsfBjaLQNcR5cuoaMWD8Fs0QsDy4dVDwna/u5dQjkCe3OSgttxaQEIRU8JL+urAu5qV0CBxLwUtr8M2bj4vZO0u2WByM22ZGWjRDLxR4rAUjY6e2BVvszmbjosPZNNdI1SdIVZZ04H+R8FutPIop7Pm1SAIQU8tOmVCPLfKjzE6dHxHr7ZgNAOkLIkQEzXmiOELGt9Xd07fc1GyMk2cxc3vhTx5IuLYVmZq4TYYlH/gZCFJ7hK5qJfCcTx1igCBKR60Je1IGRhrQPvGK1AJmqPj8BJlCjfyY6nn7X3q/uSkOtJV7xXU0mRrlNdGB+Gu+SmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769006870; c=relaxed/relaxed;
	bh=edtMn02AVod+IBbJIVsMu3fhJTzD4OTVoerhqOtkeWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BaE5IQ28VzP5+tMxsob7r8lPgxcSu5T7zYC43X/EWiQYZRBfOLtjBVvT78vbGZAJLl6S2jxCgxW2mu2Ltl+QDZO0l3sdjKezUf0cjmOwmltX6FyMvJ6fVeznFMNSoOWsuxgtNKAiZKmzcfuytaxkX7J24xAXyeb3F9GH5BMaXVMUZX7J3YJpmCe9gEelxsgjgyxtSj7qaKfYrDwgUHsjKbPSP5uXa0LI+bvThfxxplSz5bjMbKdvhyq7v9NVYkSSoTTyK3A4dn6N1cSGZpLoJoiyJJ9w3dXE1DIbnNO/052A20g2CK5r8jMOp/zfeazLjG9apuJsCuttAx3O34DZzg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=lyoZtqRM; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=lyoZtqRM;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dx6Vq5xV8z309C
	for <linux-erofs@lists.ozlabs.org>; Thu, 22 Jan 2026 01:47:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=edtMn02AVod+IBbJIVsMu3fhJTzD4OTVoerhqOtkeWk=; b=lyoZtqRMQf0KSh1E6771IlhF4T
	RrLjV0QALpxuAPKkekpZyZQzp1pko+bePRoZZJZ8ieyVV9svFucFsTJJihcCgY79/+Ga4AHQJAc9s
	0HjxA2m6YspkhDbzNJ8FksqryID1wx0o/FHYrZbeQAZmuJVCMo088yeeWEO0vm0Tt9I/3s7710GOE
	h1vZyqOcZojbUC8ClviRx150cBwXx7bgs0Stvn7e/Y74KTKUQD3jGgHsXsJfr8QvEdBTO4/qnlaWf
	rvTpv2se5FecitDGJbn+/YyKGUb7cbrew+LBJmByxqOXDXj2JzWyvd5zyQm4Qr4kt6qFg51hdkrIL
	K1f5k5Dw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viZUG-00000005dMj-1Wd9;
	Wed, 21 Jan 2026 14:47:12 +0000
Date: Wed, 21 Jan 2026 06:47:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: NeilBrown <neil@brown.name>, Christoph Hellwig <hch@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
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
Message-ID: <aXDm8FPPOHs04w9m@infradead.org>
References: <176877859306.16766.15009835437490907207@noble.neil.brown.name>
 <aW3SAKIr_QsnEE5Q@infradead.org>
 <176880736225.16766.4203157325432990313@noble.neil.brown.name>
 <20260119-kanufahren-meerjungfrau-775048806544@brauner>
 <176885553525.16766.291581709413217562@noble.neil.brown.name>
 <aW8w2SRyFnmA2uqk@infradead.org>
 <176890126683.16766.5241619788613840985@noble.neil.brown.name>
 <aXCg-MqXH0E6IuwS@infradead.org>
 <176899164457.16766.16099772451425825775@noble.neil.brown.name>
 <364d2fd98af52a2e2c32ca286decbdc1fe1c80d3.camel@kernel.org>
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
In-Reply-To: <364d2fd98af52a2e2c32ca286decbdc1fe1c80d3.camel@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 21, 2026 at 09:27:38AM -0500, Jeff Layton wrote:
> Using your definitions, stability is not a problem for Linux
> filesystems. The filehandles generally don't change after they have
> been established.

fat seems to be an exception as far as the 'real' file systems go.
And it did sound to me like some of the synthetic ones had similar
issues.

> > We'll still need a stable handles flag, and expose it to userspace
> > to avoid applications being tricked into using broken non-stable
> > file handles.  We should have caught that when they were added, but
> > didn't unfortunately.
> > 
> 
> If we assume he meant "unique handles" flag, then I think we're all
> mostly in agreement here.  As far as this patchset goes: what if we
> were to just rename EXPORT_OP_STABLE_HANDLES to
> EXPORT_OP_UNIQUE_HANDLES (and clean up the documentation), since that's
> the main issue for existing filesystems. It would be fairly simple to
> advertise handle uniqueness using statx or something.

Unique seems to also only capture part of it, but I could absolutely
live with it, if the documentation includes all aspecs.  But maybe
use persistent as in the nfs spec?

> 
> Alternately, instead of denying access to these filesystems, we could
> just fix these filesystems to create unique handles (a'la random
> i_generation value or something similar). That should mostly prevent
> filehandles from being reusable across a reboot on these filesystems.

Do we even want to provide access to them?

> That would leave cgroupfs and the like exportable via nfsd, but as you
> point out, we can't deny export by userland servers. If people want to
> do this kind of crazy stuff, maybe we shouldn't deny them after all.

I think Amirs patch would take care of that.  Although userland nfs
servers or other storage applications using the handle syscalls would
still see them.  Then again fixing the problem that some handles
did not fulfill the long standing (but not documented well enough)
semantics probably is a good fix on it's own.


