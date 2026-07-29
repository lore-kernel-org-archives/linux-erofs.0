Return-Path: <linux-erofs+bounces-4029-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C3A7C54F51
	for <linux-erofs@archiver.kernel.org>; Wed, 29 Jul 2026 01:41:06 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h8w5r2zqgz2yRM;
	Wed, 29 Jul 2026 11:41:04 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785289264;
	cv=none; b=oKtmN0/68iQ+isgnl3p5es5WoyFSkUmGaT0nJNb+hjjfNlm7KE7iQIcYbdrLy1kx5iPmh1bWQBdtoKkO0KugfYhnJeuawqXYsrAZ6sMSNezLdCMKZ+dr9Bi1NTUmtbb7BjYAV+zf9E3YM4HI9Z9etNkN+nSym8oP2nVKRuUXcK27c/F1sSSBB+vFUnMX5/dPtFibaL6YNEUa/78wjJeF01QFqlmG88qgUutkdaa7oXBczpuei3+gYxCEed8WW9XQcsY70ZOCMLzBiCBB9ck3tAucVwxrzMXarZK53wP7RJMjo01lGJaaRgxFbc91ouAP3/cx5dFN4NbL0O9GcYB+Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785289264; c=relaxed/relaxed;
	bh=vSxpuTUnCBd3tEjZ9vGZIvSxtQcrtVHhUia2u95b0SQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cWV/dXWwvjOSozzzz49CwJAff7V5NfDHuZ20q/xF5OlTzOJzpgE/toW9VE5q9AGhM3vxDQMfCN0zfi3ZnY2U3zrPL8QKEUyQAydSkoFx9NKoVtRXd6n/o+Lg+VISXL29bgUEbr9gZYniO+3DS68oPmv4SfvSihiBRxtWlXh00ZDA/jAO+QYgN8AWILh2I68PK6MfGQmPyMLKWyxD5kH+vTgflxYwZJxTbzZiTyxb+bYTVztVGsZKTjRQzCTqWER8lM3nrpIW8W2l8ihJKOwSuPIczaTK1Lrn4dMRiJLasGTa1VH1CTmLCZ0PleQRKeaxVZsHxMG1/BW5WJ8FANpgOA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bvyay/4z; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bvyay/4z;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h8w5q1Ht5z2y1Y
	for <linux-erofs@lists.ozlabs.org>; Wed, 29 Jul 2026 11:41:03 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D35AE60A61;
	Wed, 29 Jul 2026 01:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4263A1F000E9;
	Wed, 29 Jul 2026 01:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785289259;
	bh=vSxpuTUnCBd3tEjZ9vGZIvSxtQcrtVHhUia2u95b0SQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Bvyay/4zv6y0+LYaxUeZIzdEn5Tte9w49t0pPpP2+ev2yNY+MPRYbuRvzLj57O6kS
	 Z4CU/jfd+s1y35xAsVb6XcICTT2Lqo5B1zOIMEVIUOp7WEQOS/lsqHqxplfL3Jj2Yo
	 JUYwYiH5VV7JTSMa66C+S1IezhQIa3q3TsueIPjWVzxxlLPQRt74vjV/2s98dh6N7w
	 Pg4u87+EYfFjYV6WlkFeWdEY3qAgFnTkcoObFUTocn9urTmk+mvBkZuGvdej8xJjIJ
	 qfk+NHHQTwy/k5EAqAr7L+9dRPduHFibcIfsxi7/zkuj5vUPorIv+mBYjXutiCfdVo
	 xDJKH7L3vy7cw==
Date: Wed, 29 Jul 2026 09:40:50 +0800
From: Gao Xiang <xiang@kernel.org>
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: linux-erofs@lists.ozlabs.org, cyphar@cyphar.com,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5] erofs: accept source file descriptor via fsconfig
Message-ID: <amlaIt8jjy_mSK-j@XiangdeMacBook-Pro.local>
Mail-Followup-To: Giuseppe Scrivano <gscrivan@redhat.com>,
	linux-erofs@lists.ozlabs.org, cyphar@cyphar.com,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
References: <20260728160619.853924-1-gscrivan@redhat.com>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260728160619.853924-1-gscrivan@redhat.com>

On Tue, Jul 28, 2026 at 06:05:32PM +0200, Giuseppe Scrivano wrote:
> Allow userspace to pass an already-opened file descriptor as the mount
> source instead of a path string.  This is useful for tools that already
> hold an fd to the image, such as composefs reusing an existing erofs
> backing file.
> 
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> ---
> v4: https://lore.kernel.org/linux-fsdevel/20260717134147.1602735-1-gscrivan@redhat.com/
> v3: https://lore.kernel.org/linux-fsdevel/20260714154917.489993-1-gscrivan@redhat.com/
> v2: https://lore.kernel.org/linux-fsdevel/20260711071137.4130824-1-gscrivan@redhat.com/
> v1: https://lore.kernel.org/linux-fsdevel/ak5GfvVfWLJU1EwK@debian/
> 
>  Documentation/filesystems/erofs.rst | 15 ++++++
>  fs/erofs/super.c                    | 73 ++++++++++++++++++++++++-----
>  2 files changed, 77 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
> index 4230884fb359..774e8b236d09 100644
> --- a/Documentation/filesystems/erofs.rst
> +++ b/Documentation/filesystems/erofs.rst
> @@ -139,6 +139,21 @@ inode_share            Enable inode page sharing for this filesystem.  Inodes wi
>                         page cache.
>  ===================    =========================================================
>  
> +File-backed mounts
> +==================
> +
> +When CONFIG_EROFS_FS_BACKED_BY_FILE is enabled, EROFS file-backed images
> +can be mounted directly without a loopback block device.  The backing file
> +can be given either as a path, or as an already-opened file descriptor.
> +
> +When a file descriptor is used, the kernel resolves its path and records it
> +so that /proc/mounts and similar interfaces can still report the mount
> +source.
> +
> +Only regular files are accepted as backing files; to mount an image that
> +resides on a block device, use the traditional block device mount path
> +instead.

Reviewed-by: Gao Xiang <xiang@kernel.org>

Hi Christian, Jan, could you ack this (`fc->source` filling when
`source_fd` is used) if possible? I wish this behavior can be
consistent even vfs source_fd is implemented later.

Thanks,
Gao Xiang

