Return-Path: <linux-erofs+bounces-3980-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28313C44539
	for <linux-erofs@archiver.kernel.org>; Wed, 22 Jul 2026 14:25:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h4xPS1rMxz2xnK;
	Thu, 23 Jul 2026 00:25:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784730348;
	cv=none; b=Wk6qVySjIiciqMgQDhkuaaz9WDpJaN5v08mg5FbTbHJMNRYBv5mbD+/WX5z52b/3Bfut1wHEzs7RNgxr5j2+UybptW92XeSZAxMgVTnMeUdjfOX67hvi2MIx7Ss0o4IGuJtoBJ4MWdVsiOjxmV48l26crFdX0mD/HRLlkpZCWOj77RDfTp0HwgCu/dWbMMHqn4k0j8qqfw5TFz4QGINj8X9ma1NlGM4vvvzKV1aqnlasESoeR9/uCD/yiV/qORWfoEvxIATHaUXjKya2zmLEMGyhVhuRjzkm7muE4fP5SyBLj5ZmnsAm0LvnwjXVZ/hzfMrcx0CB9b9F+X5S8/KM0g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784730348; c=relaxed/relaxed;
	bh=MB2674Xq9iUX2pckuew3NqZMSr8/d8+HLDJJQm6Smho=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=UsxVdN8PIJYMEGAmhMbCxayptP08l1rsEzvBjesnw3o6ggwDDsrLb0BmwBb9GNLdS0eaLosRiCb4WT15YCfFn1YddN1sAMnwn0QLNZjDuWRQN+s0/ImribR0GlLL0StTWhUYJTzFr1qto/bPq6u0/foGHF9t9ls8docPtYVOC7XH74uwFjEgFa0CN9bORFpml0FJI9sSO0s22oMxLwuv/3OeOy19LD8YdpS1jheKFqkqBDZeRiLnW2tJluGAXRai0aZnwB79HrUw2mNMN3LxrJXMmpmRRZemDPhsupwqP1Pv64NMZ7vvwhbBENo66YipWOEybZVup0cqFD+Q55zp1A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mn9EOVCA; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mn9EOVCA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h4xPR3Gftz2xJT
	for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 00:25:47 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6117843734;
	Wed, 22 Jul 2026 14:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7811F000E9;
	Wed, 22 Jul 2026 14:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784730344;
	bh=MB2674Xq9iUX2pckuew3NqZMSr8/d8+HLDJJQm6Smho=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Mn9EOVCAzHILrLnIRFbI/FT9YSc7lEimRoN2Rnq0bCq2CB3Yrm0nAh9KD7OaJc4K1
	 T0tQWhE6SUvOApZBKJWFs43mRBZjwJ3Y2DLVuAWnQTXZc1+Iywul5Ev4KBWBAifOi1
	 0hHakJMTDOL3wyN3EWuuKTN5FP7Ku5LcD12BR6/XAFkPIyQ76fZVdHX8h5Uv/EPREp
	 nP8OcAOi+MFabL2DU3EKm7BnkHzDAWwEbzIAFMfoBQqrgV+qpFchIvJZTUtki/JmhY
	 R4Y9kceUWZq3/Ax5d/LTt/hcrwujq7WFxEUTzufZEawYAppfHf8HRGH0RJR1FR0MEE
	 iJLA2DJNSTYzQ==
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through
 O_ALT
From: Christian Brauner <brauner@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andy Lutomirski <luto@amacapital.net>, 
 Miklos Szeredi <mszeredi@redhat.com>, 
 Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
 linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
 linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
 Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAJfpeguxCOw4cURjPVOMj5-A7JnLrmy8zx4qE9uwxg7x_Wr+zg@mail.gmail.com>
References: <20260715101107.973997-1-mszeredi@redhat.com>
 <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
 <CAJfpeguxCOw4cURjPVOMj5-A7JnLrmy8zx4qE9uwxg7x_Wr+zg@mail.gmail.com>
Date: Wed, 22 Jul 2026 16:25:39 +0200
Message-Id: <20260722-erraten-hinblick-erlesen-2520fd1a3726@brauner>
X-Mailer: b4 0.16-dev-2f6f2
X-Developer-Signature: v=1; a=openpgp-sha256; l=774; i=brauner@kernel.org;
 h=from:subject:message-id; bh=x5OLo4YTWLIOMETrnu2IZQMFHkb9oKa0hKDXoZmkJ9E=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlXHrqYplk+av8ybQPod1+C22T9/E9742v7JvsGnVaK
 PURn4djRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQ4uRj+ys5333Noi32U0oyG
 5vsm9q8NbiUeaol/ePmyQdo1/2XnGhj+B/HNPysa0Kf5RSChfwXXLIH951XVz28TjZ0VeCHy8ux
 d/AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On 2026-07-20 11:22 +0200, Miklos Szeredi wrote:
> On Sun, 19 Jul 2026 at 16:13, Andy Lutomirski <luto@amacapital.net> wrote:
> 
> > This gives me the willies a bit.  It's very cool, but it has some
> > potential security issues that I think we need to watch out for.  As
> > sort-of prior art, NTFS supports alternate streams and Reiser4, ahem,
> > supported files-as-directories.
> 
> I realized that we can keep the creepiness factor minimal by
> introducing this first in procfs only.   That way zero changes are
> needed in the path lookup code:
> 
> sprintf(buf, "/proc/self/fd-alt/%d/%s", base_fd, alt_path);
> alt_fd = open(buf, O_PATH);

I'm still vehemently opposed to stuffing more creepy apis into procfs.
So this gets clear opposition from me.


