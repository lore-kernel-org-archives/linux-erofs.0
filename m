Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4E34C76196
	for <linux-erofs@archiver.kernel.org>; Tue, 11 Apr 2023 08:24:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Pwf5C2QvPz3cdG
	for <linux-erofs@archiver.kernel.org>; Tue, 11 Apr 2023 18:24:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1681201455;
	bh=6nX5sI6EN+QIsWtAaq5RhWz/W4vuyCGzISy2tTv8b6w=;
	h=Date:To:Subject:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=hMtyEzOv/m6ndTva1WoIhxpMYgx+XhgtHHf7vxsusJkwijw5MVhJ3ee5E7244nkSj
	 3b6H7lb4hgg6xu64pdYlE+xOfP8lsgEaMsNBcIx3SKrwKivZBoR9YC+pRg3aWmf09e
	 LQYouvpOXTjD1PpyC5g97l4+nJPrGC44yhcgXqxtnBlVbQJ3fHXKw3dR84cd0yG65P
	 V0Gxem1eY0pvOuV5sEhyvluAu63eHVVUinTvNmyqjZHKGb7flVO7WWQ5oRxJHUrm7Z
	 hVFZs3DvkE8PaPjGv43j9gHb7b5CHWs86afhScd4sY1Ue0ZX03WFivD24TFzgxV/k5
	 gNPq6fvQcnN5w==
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+c6fa32d9e84a85109083+7170+infradead.org+hch@bombadil.srs.infradead.org; receiver=<UNKNOWN>)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Pwf4z29z3z3bTG
	for <linux-erofs@lists.ozlabs.org>; Tue, 11 Apr 2023 18:23:52 +1000 (AEST)
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pm6Py-00GReU-09;
	Tue, 11 Apr 2023 05:19:46 +0000
Date: Mon, 10 Apr 2023 22:19:46 -0700
To: Andrey Albershteyn <aalbersh@redhat.com>
Subject: Re: [PATCH v2 00/23] fs-verity support for XFS
Message-ID: <ZDTt8jSdG72/UnXi@infradead.org>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404145319.2057051-1-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
From: Christoph Hellwig via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Christoph Hellwig <hch@infradead.org>
Cc: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, agruenba@redhat.com, hch@infradead.org, djwong@kernel.org, damien.lemoal@opensource.wdc.com, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, dchinner@redhat.com, rpeterso@redhat.com, jth@kernel.org, linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Dave is going to hate me for this, but..

I've been looking over some of the interfaces here, and I'm starting
to very seriously questioning the design decisions of storing the
fsverity hashes in xattrs.

Yes, storing them beyond i_size in the file is a bit of a hack, but
it allows to reuse a lot of the existing infrastructure, and much
of fsverity is based around it.  So storing them in an xattrs causes
a lot of churn in the interface.  And the XFS side with special
casing xattr indices also seems not exactly nice.
