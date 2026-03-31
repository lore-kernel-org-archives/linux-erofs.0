Return-Path: <linux-erofs+bounces-3141-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8813D109B467
	for <linux-erofs@archiver.kernel.org>; Tue, 31 Mar 2026 13:12:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4flT6v6rMjz2ybQ;
	Wed, 01 Apr 2026 00:12:23 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774962743;
	cv=none; b=HJlF5QjEO+cEp7Lr2X6cx48oz2QRIx4BXW3xwy6F5wJ3SfkWVBT0dKm6nTTatkBATR2gYS2bcGfbCnr8w4fOvbjQuriZCb9+LAz4dTNfdQ/Rf0PFrCtVESwUpmPTBEba4zdoTihWiGAYIivyxdyEKIM4y9KxdbuJXInYL8SKGI35AizFmknlEHMlI5TFg4mTXHBZDEwcZYcSA2uySkD4qCv7bnWG2BTBqQM0Weo9bTt+Ko89lrBMywbaS42VGbSLpAdUIMpmn2qW5meSp4Gc7pJA2rAOoql/82q+HOZ+FISPlBcf5WebfuOgJh4bR1RGz5K851JlDBKcCuSfzXxSSA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774962743; c=relaxed/relaxed;
	bh=N154C0IbvKe3lYUHIr5PYmJt9/2KA4XOPHlGWLqYPcE=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=LU70lJ3neH3jg0xGPgL8WVrQfFpZWujAII86FvMpy7oodaeKFsc4uE6qYzVlPNTdOpVpgGsF8hr5BmrNSBxi+McDOIuyQfRLxhjeU2P6yAGyGohm7xXIuyeNb7eGUo2PZurv9rJZbsIeeIPMw+2rUz3E2mJT4i/zQmt9zzylqTzD9b0osNI8wYBM5NjM4vrvIjgF0I/sk0PEzjjVtFvi1jIieTBWUroyZO5xhFo6p66J9pSjbpzGcGO2ALeH6Aaz19GqwJdk2w2EcrC05+LsZi98vjWaHMKMBD/jGFQUzQgoyqm5Z/uFHJRq1FjIjpPQeluGBP8Uy1sIlP1vUmx3zQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; dkim=pass (1024-bit key; unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I3Mkdvje; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=gregkh@linuxfoundation.org; receiver=lists.ozlabs.org) smtp.mailfrom=linuxfoundation.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I3Mkdvje;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linuxfoundation.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=gregkh@linuxfoundation.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4flT6s325Dz2xYk
	for <linux-erofs@lists.ozlabs.org>; Wed, 01 Apr 2026 00:12:20 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BCA741832;
	Tue, 31 Mar 2026 13:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91259C19423;
	Tue, 31 Mar 2026 13:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774962737;
	bh=Vm+JGExcodg7akIuEpfztcudohQP9LxVsvkgdZP/LrY=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=I3MkdvjeT3bjbAKDxq2jGk7JkldIL4StVhyZnHfLQNIlQZVtnwSqHrDCra32cCwu4
	 KvctSMbZhZSl7hCi+zaVlOyjaifzsjp4VQjXR7itHnwxNRktf5m4AZgML9TODBAeqU
	 9mFYujQU9hZgonFCdC8RjI/wgEYSD2D6S4JBK/wg=
Subject: Patch "erofs: fix "BUG: Bad page state in z_erofs_do_read_page"" has been added to the 6.6-stable tree
To: 69c3b299.a70a0220.234938.004b.GAE@google.com,gregkh@linuxfoundation.org,hsiangkao@linux.alibaba.com,linux-erofs@lists.ozlabs.org,syzbot+b6353e35ae2bab997538@syzkaller.appspotmail.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 31 Mar 2026 15:12:15 +0200
In-Reply-To: <20260327041524.1087336-1-hsiangkao@linux.alibaba.com>
Message-ID: <2026033115-author-estimator-a14d@gregkh>
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
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    erofs: fix "BUG: Bad page state in z_erofs_do_read_page"

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     erofs-fix-bug-bad-page-state-in-z_erofs_do_read_page.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From hsiangkao@linux.alibaba.com Fri Mar 27 05:15:33 2026
From: Gao Xiang <hsiangkao@linux.alibaba.com>
Date: Fri, 27 Mar 2026 12:15:24 +0800
Subject: erofs: fix "BUG: Bad page state in z_erofs_do_read_page"
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-erofs@lists.ozlabs.org, Gao Xiang <hsiangkao@linux.alibaba.com>, syzbot+b6353e35ae2bab997538@syzkaller.appspotmail.com
Message-ID: <20260327041524.1087336-1-hsiangkao@linux.alibaba.com>

From: Gao Xiang <hsiangkao@linux.alibaba.com>

It's actually a stable-only issue from backporting 9e2f9d34dd12
("erofs: handle overlapped pclusters out of crafted images properly")

We missed to update `oldpage` after `pcl->compressed_bvecs[nr].page`
is updated, so that the following cmpxchg() will fail; the original
upstream commit doesn't behave like this due to new features and
refactoring.

This backport issue only impacts some specific crafted images and
normal filesystems won't be impacted at all.

Fixes: 1bf7e414cac3 ("erofs: handle overlapped pclusters out of crafted images properly") # 6.6.y
Closes: https://syzkaller.appspot.com/bug?extid=b6353e35ae2bab997538
Reported-and-tested-by: syzbot+b6353e35ae2bab997538@syzkaller.appspotmail.com [1]
[1] https://lore.kernel.org/r/69c3b299.a70a0220.234938.004b.GAE@google.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/zdata.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1503,6 +1503,7 @@ repeat:
 	lock_page(page);
 	if (likely(page->mapping == mc)) {
 		WRITE_ONCE(pcl->compressed_bvecs[nr].page, page);
+		oldpage = page;
 
 		/*
 		 * The cached folio is still in managed cache but without


Patches currently in stable-queue which might be from hsiangkao@linux.alibaba.com are

queue-6.6/erofs-add-gfp_noio-in-the-bio-completion-if-needed.patch
queue-6.6/erofs-fix-bug-bad-page-state-in-z_erofs_do_read_page.patch

