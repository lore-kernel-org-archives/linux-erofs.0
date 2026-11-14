Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EB8606A8B6
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 10:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ozu7z0Kj
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRVwQ5hjmz30Tm;
	Sat, 14 Nov 2026 21:38:46 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794652726;
	cv=none; b=FgZDo+G8vNyFzQMXwj6y/1WD2pXiG7SzrK4rQjF3x4BFbM/WmlsD6owXl5cjjpXpMwcyphRZm0NVfeAbsb+2vQX4Gy+cXlWGuKtQV1AxpRFaiOyn/aYou9lq4fUJ6CvqYaWmMjWV1y/C6T6h7M3PiT4VnxmyDGHUPUge2IHKtKNqIPc15JWGbVIOM2UUXdO1i3pB2k1h5v7BBHzCFAmtd4KELDcUyFk8wY27vuhHgKKat2SdMeI2HRgl8QeKNOiA2ySF7R39YAy3T2X23R2EdrUHr++Mp6rO8QfxsrztxqZ0PGjSVrsQcoOxApZw93J0WcNVp6cAUksErzES6AZXlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794652726; c=relaxed/relaxed;
	bh=f0g6P6hsNAkBmmk1dhVL/yqmLVxvhNEJRF73P8Hffz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KX+SdNEntziv+ZRytqxBvsWtvzgT62UEAcxfnVaJGLwxFozJTzs0aWj+a1NyC4EwkMPr7tlMaEuaDIGf68FTQdlZCvvwWoQWDIQIGkq1h5h47OQGobDAR8BT/GJBcRB/jtIwb5I3Jr98q92g+ZQERAL3vpOGiJhWm5X6GXAsvYBtL2EndBAot/ols/ouAgtrH3/Uv5gtOga/POYlDHfpp22wfP3ofhV6iv+fsdtR9TOJTARMeYK9J8qZ8j6eagreipS2jtSh3XRGHlavKt4JWs7fuFoLVZAF2Q100yXXXQOlNJ2ipimaptc0UWanY7LjBfyugvyd+7Lk0ODm6Dcybg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ozu7z0Kj; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ozu7z0Kj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRVwQ0sYHz30Sx;
	Sat, 14 Nov 2026 21:38:46 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 967DE413E2;
	Sat, 14 Nov 2026 10:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE541F000C4;
	Sat, 14 Nov 2026 10:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794652724;
	bh=f0g6P6hsNAkBmmk1dhVL/yqmLVxvhNEJRF73P8Hffz8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ozu7z0Kj1tHIOD24bkiz6twDQ59H2LG047bnoA597yeAQD+7loV9AVNQq6/EfNxmA
	 RAV43n2Xp3rFswhwCvrdVPjCv2twIaBECTwXwjSyPBKOEecSJccYi16iPUffdcy+kX
	 2KsSYHa0TM5q3kVm9Et0sKjXOYpfJER4fjfggVZYik+Tlk8iLg4VYcTfwPq6hSWTb+
	 FqNtagBKrLecsr9nZyvU/RGWRSqwrFdabGVO12uSaA2rrQgzv6ROpsZEsD9jdN00pG
	 9AVp7r2bVcIF0aGX9qNUD3D/9g7VuGmG+jesekdRYeqNRWWlH0zjJp4ZwQJyQCg3y0
	 VLaLdAkJXNuOg==
Date: Sat, 14 Nov 2026 11:38:35 +0100
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, driver-core@lists.linux.dev, linux-mm@kvack.org, 
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
	ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 01/41] loop: refuse backing files that aren't open
 for reading
Message-ID: <20261114-erfrieren-vorher-taktieren-ef10b08e210f@brauner>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
 <20261111145555.GA9996@lst.de>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261111145555.GA9996@lst.de>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 03:55:55PM +0100, Christoph Hellwig wrote:
> But i wonder if we want a thin wrapper around ->read_iter/_write_iter
> to do this check so that it matches the normal read/write path?

Yes, I had thought about that as well. We could use
vfs_iocb_iter_{read,write}() for that but it's not thin at all and
brings in the LSM into these codepaths where they shouldn't meddle.

So maybe as a follow-up series with a new
vfs_iocb_iter_{read,write}_raw() or whatever. Feel free to make a
suggestion.

