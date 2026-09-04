Return-Path: <linux-erofs+bounces-4475-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8525CC79F80
	for <linux-erofs@archiver.kernel.org>; Fri,  4 Sep 2026 09:34:49 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hbrsM3VCbz2xlY;
	Fri, 04 Sep 2026 19:34:47 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788514487;
	cv=none; b=FdMkIsGV2PP9EcP1IbId0xgb90W1wqQROgtfer/vguydDRrpcRaT6KLN7DRUZM/c9DuoMGJc2n9rdtsBcNpOuXQxI9KAu1Ds23dKyZ8VABlHY8INufCbJmqbzFGN4mJnCZHLlImwhu8r3FmT3BTSsqsb48L2CTFn2/sQa1ujNy6lA9u8WgNPHE9brVjKBzjUreTjpYMMi6+JD/YW6p23tQEf2rlwFoRxjyo9qSs8ZL+4AC7XsyGtK68a71RyB/4rbAu+XYwUhP6ZIc6c6qMg5+kGSGW4772WeDPlSXi96qvgMn3EbtHEPGzBrnq+rAzTzeeMSSHsX/DMcOjlZxi8KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788514487; c=relaxed/relaxed;
	bh=eK397mSRVgm1qG90uV7zAPfrgCr1A8mrhqFDHCunWWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ijzVisQ5LE/3k/Dk59b6FldvoQzWip56FANDC1OsXP8z66KcZsWVr3S8ffJorbMD3xClZ4eYm0Up/63moE/rS2qPVx7zWXEGqoJK6wwYotLw+5EnKdN1YNlu3gau4Sf43Z6yFRtE3yxYTLzeeXIf2XhPTwu9XVlurmgK61OZEX086Qsf81LyWLkTvLLs1fPnF8UwyBYWvWIXtDZ+L/CuF21Llsdr6IkE4NgpGz7MXmecDWEqhIHhti5p17rGShfwjcszhd0OW7ZWD/A/iiQahRK1M1RfhJvWfQPP+yvdWGrUUPMPet3m2MhNJhAzlk01ZMj7Eobfx1cxRbYVc0MgSg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MP+7vBL4; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MP+7vBL4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hbrsL3wKzz2xfB
	for <linux-erofs@lists.ozlabs.org>; Fri, 04 Sep 2026 19:34:46 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9898760A6D;
	Fri,  4 Sep 2026 09:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C921F00A3D;
	Fri,  4 Sep 2026 09:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788514483;
	bh=eK397mSRVgm1qG90uV7zAPfrgCr1A8mrhqFDHCunWWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MP+7vBL4CvZI8+aPjTemUNhZqygTPRJsrM48ckDbY6znvXHMXoCdgptFL3eP0SrXV
	 9UIwYJnGwO3EMtZJPbTAwfE5XGwRhNEApT/RS8oROfqjyJbRY6Fhsn8CcFmt7P1IrP
	 oWCm+RlxLuwYXotdgllqn3bnLzE/dCkGs4b+JAjQptz6KoJCYdjxAegePnGOPPKkpU
	 dAMpq/zIrNwrcBTzAz+vbadLH0COjmFu9p+bqScj2ZT46xdpsMlnmdYvvTRprVFfPU
	 7CKX1SP3al+vXQPaqpbTc3/8xtG4pZC6nptsxHrZmr1/rA64v8Wf/wwM4KTWbg2PcO
	 1Bn1WFM20fdug==
Date: Fri, 4 Sep 2026 11:34:37 +0200
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 4/8] xfs: port to fs_bdev_file_open_by_path()
Message-ID: <20260904-resignieren-ambiente-beweis-b7a6044bb60f@brauner>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
 <20260602-work-super-bdev_holder_global-v1-4-bb0fd82f3861@kernel.org>
 <apLx7pdNVkHPkrAq@infradead.org>
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
In-Reply-To: <apLx7pdNVkHPkrAq@infradead.org>

On Sat, Aug 29, 2026 at 07:51:26AM -0700, Christoph Hellwig wrote:
> This causes regressions in xfstests xfs/006 xfs/264 when running with
> a RT device because reopening the dm substitutef RT device returns
> -EBUSY:
> 
> [   20.814542] XFS (dm-0): log I/O error -5
> [   20.815055] XFS (dm-0): Filesystem has been shut down due to log error (0x2).
> [   20.815960] XFS (dm-0): Please unmount the filesystem and rectify the problem(s).
> [   20.906440] device-mapper: zone: dm-1 using native zone append
> [   20.954262] XFS (dm-0): Invalid device [/dev/mapper/error-rttest.264], error=-16
> [   20.970876] XFS (dm-0): Invalid device [/dev/mapper/error-rttest.264], error=-16
> 
> I'm also a bit surprised a RFC patch without any xfs rviews landed in
> Linus tree, especially as the series alsso got various NAKs..

I said I'll wait for Jan to comment and once he Acked it it landed in
-next for multiple months.

