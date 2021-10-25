Return-Path: <SRS0=d7Ai=PN=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 103BFC433F5
	for <linux-erofs@archiver.kernel.org>; Mon, 25 Oct 2021 19:03:06 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6329961076
	for <linux-erofs@archiver.kernel.org>; Mon, 25 Oct 2021 19:03:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6329961076
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=thesusis.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4HdPVJ0pHkz2yMq
	for <linux-erofs@archiver.kernel.org>; Tue, 26 Oct 2021 06:03:04 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=thesusis.net (client-ip=34.202.238.73; helo=vps.thesusis.net;
 envelope-from=phill@thesusis.net; receiver=<UNKNOWN>)
Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4HdPVD3ZrPz2xfD
 for <linux-erofs@lists.ozlabs.org>; Tue, 26 Oct 2021 06:03:00 +1100 (AEDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
 id 0C83861FD2; Mon, 25 Oct 2021 15:02:27 -0400 (EDT)
References: <YXHK5HrQpJu9oy8w@casper.infradead.org>
 <87tuh9n9w2.fsf@vps.thesusis.net> <20211022084127.GA1026@quack2.suse.cz>
User-agent: mu4e 1.7.0; emacs 27.1
From: Phillip Susi <phill@thesusis.net>
To: Jan Kara <jack@suse.cz>
Subject: Re: Readahead for compressed data
Date: Mon, 25 Oct 2021 14:59:45 -0400
In-reply-to: <20211022084127.GA1026@quack2.suse.cz>
Message-ID: <87fssprkql.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
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
Cc: linux-ntfs-dev@lists.sourceforge.net, Matthew Wilcox <willy@infradead.org>,
 David Howells <dhowells@redhat.com>, linux-bcache@vger.kernel.org,
 Hsin-Yi Wang <hsinyi@chromium.org>, linux-fsdevel@vger.kernel.org,
 Phillip Lougher <phillip@squashfs.org.uk>, ntfs3@lists.linux.dev,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>


Jan Kara <jack@suse.cz> writes:

> Well, one of the problems with keeping compressed data is that for mmap(2)
> you have to have pages decompressed so that CPU can access them. So keeping
> compressed data in the page cache would add a bunch of complexity. That
> being said keeping compressed data cached somewhere else than in the page
> cache may certainly me worth it and then just filling page cache on demand
> from this data...

True... Did that multi generational LRU cache ever get merged?  I was
thinking you could use that to make sure that the kernel prefers to
reclaim the decompressed pages in favor of keeping the compressed ones
around.

