Return-Path: <linux-erofs+bounces-4662-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27A41CA5FED
	for <linux-erofs@archiver.kernel.org>; Tue,  6 Oct 2026 11:09:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hzYRJ4cWhz30Pp;
	Tue, 06 Oct 2026 22:09:00 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791284940;
	cv=none; b=gIRkqBOfKeECOdWQCIsF1W7BXgD7SrqtyfazIqYK71v77rpesTCMJahkcfy/ImFEUut0xf1B0M0iQr4VmLOfMJtlTHVm04oLq+wQeL82zt21hFH710XzgUr5Xa1g6NcerMDXXqFbVdTnlokgOid05NluiFRM/dvdrbegpMgk2TPqT9EykU4Sb5vq96ERDWZzsMj2a/JJvLJwbeY57pWoz8r+1mYu0xNjSHqptzaQgpAp+dco8dQWcv40IGFYpBJlibABaWXGe73pcFTvE3LCqAl42qMgkl+b6BIrQg6XypVI20or0fVZ+7ILRxdCRM9PhiLVHKnd1yIiEwA1zMkmYw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791284940; c=relaxed/relaxed;
	bh=tSNqM6h7qiHQET5ED0aWKUs++ILk2Spx6my3posENKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mE5hLguCPJsiU0aMU+qu4U9m81NDBiwKT1RR4MoL4IIlrjjuTfPn2IZzuu2nfFAH+Y3n4s29MC7eLr9lFcnRLljK8VJMebawZhRhJS4Sr7h+AVi19yxrbl7cw1em7qlnX2HPU21W88qRumdlT/mleauVQiREMVDP5r+/GXLlX4hjy8oSBnYhsfGGcj173LS3fMCudVKca7ZtNn6b2Fgbrcp/A9uYsaVfJ1aVGFMiY5JBSJTfg4uwwmSnX54q747G8yb3WYd0Pmow4r6i+je1O9uoccviqV0Mqt3ij4MOjpi5SgkLHtx7+Ey4yCGIx3x+cDxADH5sR0tBoSh4yWBr3Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZWMnneOn; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZWMnneOn;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hzYRH4n7Sz2yjw
	for <linux-erofs@lists.ozlabs.org>; Tue, 06 Oct 2026 22:08:59 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD8A16022C;
	Tue,  6 Oct 2026 11:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB561F000FF;
	Tue,  6 Oct 2026 11:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791284936;
	bh=tSNqM6h7qiHQET5ED0aWKUs++ILk2Spx6my3posENKM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZWMnneOnjGocILa3F9LOddA3AGGnfF72b2Uaif+jU8cltM4XGhjATU+OjtAwm6e1b
	 svTy1x6SP3bf5bFMsuzJXa+OSoxH2SuVoaA9wApnHQ5TLLXkOzoZJo/s0Ax/Pfc/5v
	 TXYTddiiL39SmD7VhwNjCVqQPmuDDpCCHzFCjHyr4Dbm5VPArGpWIpgK6fx+RdTk+h
	 9vZLdi5o+r7PLtl5lUuXgcxuD1kJemWnaax51orWiA4+tW/WUc8dgyhsJullSLDx6X
	 PbhOFZxIfDWlKYpxAEaLVf+nu95ldWuilB6N7pcu346kbxy7ajb6gu8DkkyqCCtjej
	 RIF9maJDJ1h4w==
Date: Tue, 6 Oct 2026 13:08:50 +0200
From: Gao Xiang <xiang@kernel.org>
To: brauner@kernel.org
Cc: Giuseppe Scrivano <giuseppe@scrivano.org>, linux-erofs@lists.ozlabs.org,
	xiang@kernel.org, linux-fsdevel@vger.kernel.org, amir73il@gmail.com,
	viro@zeniv.linux.org.uk, jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v7 1/2] fs: rename vfs_get_super() to get_tree_super()
 and export it
Message-ID: <asTWwqqx8RQfD9r7@MacBookPro>
Mail-Followup-To: brauner@kernel.org,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	linux-erofs@lists.ozlabs.org, xiang@kernel.org,
	linux-fsdevel@vger.kernel.org, amir73il@gmail.com,
	viro@zeniv.linux.org.uk, jack@suse.cz, hch@infradead.org
References: <20261002163225.1258203-1-giuseppe@scrivano.org>
 <20261002163225.1258203-2-giuseppe@scrivano.org>
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
In-Reply-To: <20261002163225.1258203-2-giuseppe@scrivano.org>

Hi Christian,

On Fri, Oct 02, 2026 at 06:31:43PM +0200, Giuseppe Scrivano wrote:
> Rename and export it so filesystems that need a custom superblock
> matching policy can reuse it directly instead of open-coding sget_fc()
> + fill_super().  No functional change.
> 
> This is a preparatory fix for the next patch.
> 
> Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>

Could you replace the previous patch in
https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=vfs-7.4.shared.super

with this version?

It addresses Christoph's previous review, I could pick up the
updated branch then:
https://lore.kernel.org/r/arY9FCatWwCw418K@infradead.org

Thanks for Christoph and Jan's review here again!

Thanks,
Gao Xiang


