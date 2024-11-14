Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BD2BD65C42
	for <linux-erofs@archiver.kernel.org>; Thu, 14 Nov 2024 06:34:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Xpr3X4Jn7z300g
	for <linux-erofs@archiver.kernel.org>; Thu, 14 Nov 2024 17:34:32 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a03:a000:7:0:5054:ff:fe1c:15ff"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1731566071;
	cv=none; b=OKpUzLgGcwKwQvKCXN0cM/gS1+PUUdvdIJeKDXXcJa5zCGZcBG622yf2UkTekP2ErXHN1WQ8G1s0PE5IaG8KbG0lt9LYtpunpqp3QhF+UzVYcGOYGN2ExrCLvvCDZrqLReK5Ubb5AbPzmwKI5yJ+afwyivMVrjogO/m0VVK1HgJZOz82Y77lDjMtuDMVmzQ/eYCZVccPZBM/yY3Gr44yG5hbL8SlRtP5LVz5LBY3VSXhwo+WGaHnlfURlxXxJT57XQBtKIEF7gNgiB2XxXuSI+bqRVVEsdkdF2YecOa0d0XKI0npMPtrebwSFh1gQGImsAdT7j1NRacR0QE+KJxOcA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1731566071; c=relaxed/relaxed;
	bh=weLT0MTvye6xD6HZw1Bdz27SlRmDyDJkE8ZHqZy6GU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N+rqql+Xyywx8hQmKYHTJRRyRIX3lkK4U9ZVj0EzB7Y3m6YTRjfjqDl4yJNNm0UPiNSjN2ZBkBiXY0BYnpOm3DOLrF1Zyj1WaPreBmEFNGhSkLFR2waRO6b076f1LFE/icnpe0Dtz3+kkXBvbGslPw5GsOkn/4VBmbIEE2ay40s+O2kSNFcOPse/uQKcgMgsRYS/qRBsLiVwLC6HsGsSqblkrvwwt/Hn0TNtD1miEr3XEIx4Opp7YZA2PkCkbnH6+YQKDCLxxc8ynPU+Kole3tgV7XVMypwMHlJAHqw/RuZ1X+VAO6+5LNp2T2elfZTHQDLSwZOKQJLcVCypeSHaNw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; dkim=pass (2048-bit key; unprotected) header.d=linux.org.uk header.i=@linux.org.uk header.a=rsa-sha256 header.s=zeniv-20220401 header.b=kZJ+0nCE; dkim-atps=neutral; spf=none (client-ip=2a03:a000:7:0:5054:ff:fe1c:15ff; helo=zeniv.linux.org.uk; envelope-from=viro@ftp.linux.org.uk; receiver=lists.ozlabs.org) smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=linux.org.uk header.i=@linux.org.uk header.a=rsa-sha256 header.s=zeniv-20220401 header.b=kZJ+0nCE;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=ftp.linux.org.uk (client-ip=2a03:a000:7:0:5054:ff:fe1c:15ff; helo=zeniv.linux.org.uk; envelope-from=viro@ftp.linux.org.uk; receiver=lists.ozlabs.org)
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Xpr3V0r8Hz2yMv
	for <linux-erofs@lists.ozlabs.org>; Thu, 14 Nov 2024 17:34:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=weLT0MTvye6xD6HZw1Bdz27SlRmDyDJkE8ZHqZy6GU8=; b=kZJ+0nCEz6IAjcPIH5Awlq0OTm
	/sYOjJlK4oJ4pL8za0NvOpeExm1cVRpCux+SmOz4QRNEL4gLY4PQsNjEU4q/l/ONyjXjrjL0e0URJ
	3hXeHWaWSVO7/UJATFq+0PR7CRLPKGt9OyxpmbayjcVLZGRh3yBYhryPZsiLSocgQXYmSLJmXF9Tu
	/QmDJgT3FKCBHFOwWFT4ffFO0HsQcRqeG3p0jh0BIGOTR30A5dxilNud3tsIf7eFZkWdtOlgQ1TWz
	nLcex60HNyej7jZukggLOEmT5JDZE387MF42/BOBMRZ3eIlIWtxf6xeL6RXeT3jdebnm2paUpBgI6
	eVDk1mdg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tBTQs-0000000EoAm-41Xw;
	Thu, 14 Nov 2024 06:34:23 +0000
Date: Thu, 14 Nov 2024 06:34:22 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: Re: [PATCH] erofs: fix file-backed mounts over FUSE
Message-ID: <20241114063422.GM3387508@ZenIV>
References: <20241114051957.419551-1-hsiangkao@linux.alibaba.com>
 <20241114060434.GL3387508@ZenIV>
 <61c24337-798d-4a2e-82bf-996e86d0c0fb@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61c24337-798d-4a2e-82bf-996e86d0c0fb@linux.alibaba.com>
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
Cc: linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>, syzbot+0b1279812c46e48bb0c1@syzkaller.appspotmail.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Thu, Nov 14, 2024 at 02:23:27PM +0800, Gao Xiang wrote:

> > 3) AFAICS, (buf->kmap_type == EROFS_KMAP) == (buf->base != NULL).  What's
> > the point of having that as a separate field?
> 
> Once buf->kmap_type has EROFS_KMAP and EROFS_KMAP_ATOMIC, but it
> seems that it can be cleaned up now.
> 
> I will clean up later but it's a seperate story.
> 
> > 
> > 4) Why bother with union?  Just have buf->file serve as your buf->use_fp
> > and be done with that...
> 
> I'd like to leave `struct erofs_buf` as small as possible since
> it's on stack.

enum + bool eats at least as much as a pointer, and if it's on stack...
an extra word is really noise - it's not as if you had a plenty of
those in the current call chain at any given point.
