Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54A3DC433EF
	for <linux-erofs@archiver.kernel.org>; Fri, 10 Dec 2021 01:59:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4J9Dbh6RwJz3c56
	for <linux-erofs@archiver.kernel.org>; Fri, 10 Dec 2021 12:59:12 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.54;
 helo=out30-54.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-54.freemail.mail.aliyun.com
 (out30-54.freemail.mail.aliyun.com [115.124.30.54])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4J9Dbd0Z5Kz2xsS
 for <linux-erofs@lists.ozlabs.org>; Fri, 10 Dec 2021 12:59:04 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R131e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04407; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=2; SR=0; TI=SMTPD_---0V-6eolo_1639101523; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0V-6eolo_1639101523) by smtp.aliyun-inc.com(127.0.0.1);
 Fri, 10 Dec 2021 09:58:45 +0800
Date: Fri, 10 Dec 2021 09:58:43 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Igor Eisberg <igoreisberg@gmail.com>
Subject: Re: fsck.erofs: support --extract=X like fsck.cramfs to extract to
 path X
Message-ID: <YbK0UxT1Ei7ylaL2@B-P7TQMD6M-0146.local>
References: <CABjEcnFhyAq9COGQAj4zCA7dydE9_o0b9s99ubEmgowBB3kCHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABjEcnFhyAq9COGQAj4zCA7dydE9_o0b9s99ubEmgowBB3kCHQ@mail.gmail.com>
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
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Igor,

On Fri, Dec 10, 2021 at 02:48:30AM +0200, Igor Eisberg wrote:
> * Extracts dirs, regular files and symlinks (overwrite enabled with a
> erofs_warn, mainly for use with WSL, in case certain files in img exist in
> different letter cases under the same dir, i.e. "path/to/file/alarm" and
> "path/to/file/Alarm").
> * Raw and compressed data chunks are handled with a unified function to
> avoid repeats, compressed data is verified lineary
> (with EROFS_GET_BLOCKS_FIEMAP) instead of lookback, as it's problematic to
> extract data when looping backwards.
> * Also refactored some function names and strings for consistency.
> 
> Please let me know if anything has to be changed.
> 
> Best regards to Mr. Xiang!

Thanks for your effort and patch! I might need to seek a whole free
slot to look at this (maybe this weekend...). Before that, would you
mind sending a patch with your "Signed-off-by:" [1] and using
"git format-patch" to format a patch?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst#n382

Thanks,
Gao Xiang

