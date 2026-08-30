Return-Path: <linux-erofs+bounces-4379-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C10BC61DD9
	for <linux-erofs@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hXf6214QBz2yhP;
	Sun, 30 Aug 2026 14:19:38 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:8b0:10b:1236::1"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788063578;
	cv=none; b=bjbd2SxYGtcSsh2pyjoUUvbeJXYye9pGeLxFE1eeKx7H5ciwWEJeGdxLnth243cioX5t+s+nWBvPndFCzZIUBfxCQcNj8yyMkjpHSNT+dF9KfSxYRWw5wer8iWBPN9BPP/JU8hgFtO0NmxRBOmhLKncDtMc2StUijtFc33FIJDBJj5dhas70ThlMoLf/hsyOiG/xQldS8MSKhyjvMjqdzkc9dUAHieYqSpDOdkgGjFNn1uq2qCIWqNg5AEP5iH+H/NPSJarEyJkpWAjM+paKhi1bGCMBGjSQ4wyZxMrpY2fn0tkKDip79FkqmYGeH1j0EX3+H+KCuffsu8/xsXbqYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788063578; c=relaxed/relaxed;
	bh=Aq91nEzmhiWcCrw9x2W22xOz/ZEdIqQpE8kWR+O0NkA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ju8bnnMvHxQ+BhGJECczdPjluUspyo5Gij6Lrca5H40j+5i73zCkOTsPiN44GZuBWlfJVPgkZOdstvvNjGBwa4zNajrULGwZGkp7Xkxx9ABIaENaWe9G1om6HfGwtsGQ1RdpF/0E/zqKbCliOdZLx0HmqObkL3nn/OjuMAkIvBiMvN5p71a6OapCGWDOMrT6smS9fnXWByJIORH/NER/KXnBZ6n0CAA8859Dg0JREuOb84BWqWhZxxLS/Fu7cP+SQ50K8Grmt0Hu4SPuR2cPqWUFDUzT3vKezkT7/YJ7LgPdleepIDG0kzTfDyHrjs0hIL45EPRZ3+jzaKV6qT+PbQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=SXgE0M1y; dkim-atps=neutral; spf=pass (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=SXgE0M1y;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=infradead.org (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hXf6131tzz2ygg
	for <linux-erofs@lists.ozlabs.org>; Sun, 30 Aug 2026 14:19:37 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Aq91nEzmhiWcCrw9x2W22xOz/ZEdIqQpE8kWR+O0NkA=; b=SXgE0M1yzk/4IOCBxbi6JCeibY
	l/ZzAsS0d9y+MhWS2Zj9oR1xd6NyCOGh/uXFJXxsDD9xtXsFxzXDUTbwoYyo/r5vkaFA90qrevPzA
	lcSx0f7Ff8JB4PB2wkE+34bN9lcF3sELubj2ZVBVVIerSOgz/TMjaYVTkk0ruejPn9ra/2ubKqhLW
	ctO3gUBseMzwy+wqmQ1R2Fr2PyQcqg5BYkMS5LKClOhhCGxe1P18Ba7RoSizVxbOex3a5H+2Yow2J
	Jh9eKWbRJUSE/07pvTMCiIrwGBZjrjspB9zentyvDPzibetEfrvZQpHdqArWGUVK9Yi3a/4OxIb8n
	TXuImnLQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Y-000000000hK-3Hg9;
	Sun, 30 Aug 2026 04:19:02 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Christian Brauner <christian@brauner.io>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	"Theodore Tso" <tytso@mit.edu>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/9] Remove FGP_NOFS
Date: Sun, 30 Aug 2026 05:18:47 +0100
Message-ID: <20260830041901.2668-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
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
Content-Transfer-Encoding: 8bit

There is broad agreement that we should eliminate __GFP_FS in favour of
using memalloc_nofs_save().  This is a small step in that direction by
getting rid of FGP_NOFS.  It's also a nice simplification in its own right.

I added the documentation improvement at the start of this series, not
because anything depends on that (obviously it doesn't), but because
I thought the existing documentation was rather MM centric and it needs
to be FS centric.  Hopefully the cc'd filesystem maintainers will have
the chance to look at patch 1 and see if it makes sense to them.

There's a few different solutions here:

 - Filesystems specifying both FGP_NOWAIT and FGP_NOFS.  If you're not
   waiting, it doesn't matter if you're allowed to reclaim from FS
   context or not, you're just not doing reclaim.
 - We're already under memalloc_nofs.
 - We can prove that the MM should be allowed to reclaim from
   filesystem memory (and so specifying FGP_NOFS was wrong).
 - We can add a call to memalloc_nofs_save().

Matthew Wilcox (Oracle) (9):
  mm: Improve memalloc_nofs_save() documentation
  ext4: Remove uses of FGP_NOFS
  erofs: Remove redundant FGP_NOFS
  nfs: Remove redundant FGP_NOFS
  ntfs: Remove FGP_NOFS from __ntfs_inode_resident_attr_pwrite()
  ntfs: Remove redundant FGP_NOFS from ntfs_wof_collect_dest()
  squashfs: Remove use of FGP_NOFS
  filemap: Remove redundant FGP_NOFS
  filemap: Remove FGP_NOFS

 fs/erofs/internal.h      |  2 +-
 fs/ext4/inline.c         |  6 ++----
 fs/nfs/dir.c             |  2 +-
 fs/ntfs/inode.c          |  2 +-
 fs/ntfs/wof.c            |  7 +++----
 fs/squashfs/file.c       |  5 ++++-
 include/linux/pagemap.h  | 12 +++++-------
 include/linux/sched/mm.h | 31 +++++++++++++++++++++++--------
 mm/filemap.c             |  2 --
 mm/readahead.c           | 14 ++------------
 10 files changed, 42 insertions(+), 41 deletions(-)

-- 
2.47.3


