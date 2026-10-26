Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1516606A31D
	for <linux-erofs@archiver.kernel.org>; Mon, 26 Oct 2026 10:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ojG/I6nA
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jCqsZ23r2z2xWt;
	Mon, 26 Oct 2026 21:40:50 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793011250;
	cv=none; b=hVVbic+QjipiVcnwkotV91Y/SsioavCfVxZTs81ZOGpWHJVeIS5/rlT/Bp9RAXLJddFvXxkG8a5+zgEX5hj6zsAMmTMojdHfgnUhgl9b8D6WiBgunVTI257DNLk9ZQujBNVyTmhgIKBLRLKaaqmVckb2ZkId0ERXVvMRQuUdaBqk1Wg+6eRaAgaCgXRmktFJHha1uZTJld8LibTYGwcJHUUetiiVfW6NFs6xPlgrL7rbC8FCxfuKmmWonVIRTGGgeSpJydeeVtgZQedqZz58HfYQUOrbFx6sj1WKStS8uZlZ8s60ACji4Y/fMmytwUns40NakY0ivrpLfrYkTxedyg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793011250; c=relaxed/relaxed;
	bh=EP4HK2sAGEG6Sk9+NnIgjZnlbU/DTAHtGnb+M3I0RHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=om7fCnK/3KC075lXT5c0xp0r+7uBJ/+0thYMJlIfJhpqvEce2GpAlVVxBjR3pm0ZUAr/AIwnFER+Vm74YMxYCyAs0Q56CRvLi0lDb0f5CrzqE2vhH7jBSXqbsM+hjHQDTTyz5GFxeq5W9io7mEWg0F/Z9NNoHPj9hoo5uYE37lpEJktCz868rfmGLbADTWuBNdq4YAZ2OSslNEsYXVlg/qNVG2ZtbpTqFX9rDNmb0eoR3t1qewj2Ibvci06Nr2wSgWWknVHiTt9wFIUTM2JvF1Jjnm7nJKl0+JuLgtcDCvPCUZgH8qQBZRqa1pYvO5jJ1AOVdyrTZIkLXOqiIYatQQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ojG/I6nA; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ojG/I6nA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jCqsY4md5z2xSF
	for <linux-erofs@lists.ozlabs.org>; Mon, 26 Oct 2026 21:40:49 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DA1143B81;
	Mon, 26 Oct 2026 10:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E67D1F01828;
	Mon, 26 Oct 2026 10:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793011247;
	bh=EP4HK2sAGEG6Sk9+NnIgjZnlbU/DTAHtGnb+M3I0RHo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ojG/I6nARC+3zNB6Jjc/jmbjIcDZSvlgu9MpO8czPyyVpMlw/KnmvJ8TE4BnjY+Hn
	 6XknwjXP+TIpYh9goWlaatrny8u2RobcbspIIXWMIsnDIT/IvbMf3Wac8s64gRZQe5
	 NjJf0VkaT+DmzoH4zyorAxT3yQhgjYLstjrkN3YSJnhmki9x0WjG+01iaWzq/46qh3
	 LNTc/mDsxGmuWcpa/EdoTY/Nb0IsG9zv+lH3qT+ZRuHUGl0QzdUOAvylwYxbLlhplD
	 9H3Qqs5njDSCGn4tWYZGhos4V/WNA/SXY8C+yR4xUnjqNSX/B+uzbgkwgAAZIImtqn
	 kHyKsZ2islK3A==
Date: Mon, 26 Oct 2026 11:40:37 +0100
From: Gao Xiang <xiang@kernel.org>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: xiang@kernel.org, chao@kernel.org, zbestahu@gmail.com, jefflexu@163.com,
	dhavale@google.com, hongbohbli@tencent.com, guochunhai@vivo.com,
	giuseppe@scrivano.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, zhanxusheng@xiaomi.com
Subject: Re: [PATCH v2] erofs: don't reuse a superblock for a mount that
 passes device=
Message-ID: <at8uJdaEhdkZVsfY@MacBookPro>
Mail-Followup-To: Zhan Xusheng <zhanxusheng1024@gmail.com>,
	xiang@kernel.org, chao@kernel.org, zbestahu@gmail.com,
	jefflexu@163.com, dhavale@google.com, hongbohbli@tencent.com,
	guochunhai@vivo.com, giuseppe@scrivano.org,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
References: <at8UCyjlHgxxBAaf@MacBookPro>
 <20261026092217.2129604-1-zhanxusheng1024@gmail.com>
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
In-Reply-To: <20261026092217.2129604-1-zhanxusheng1024@gmail.com>
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 05:22:17PM +0800, Zhan Xusheng wrote:
> From: Zhan Xusheng <zhanxusheng@xiaomi.com>
> 
> superblock_share together with device= is rejected in
> erofs_fc_fill_super():
> 
> 	if (test_opt(&sbi->opt, SUPERBLOCK_SHARE) &&
> 	    sbi->devs->extra_devices)
> 		return -EINVAL;
> 
> but extra_devices is kept in sbi->devs, not in sbi->opt, and
> erofs_sb_share_test_super() compares only the backing inode, the
> fsoffset and sbi->opt.  So once the image is mounted with
> superblock_share, a second mount with superblock_share,device= matches
> that superblock and get_tree_super() reuses it without calling
> fill_super() at all.
> 
> The same command line therefore either fails with -EINVAL or succeeds
> with device= quietly dropped, depending on whether a compatible mount
> already exists.
> 
> Refuse to match a context that brought device= options, so that it gets
> a superblock of its own and fill_super() decides as it does today.
> 
> Only the incoming context can be tested: a shared superblock may have
> extra_devices set itself, because erofs_scan_devices() fills the device
> table from the image when no device= was given.
> 
> Fixes: cd4108319bb3 ("erofs: reuse superblock for file-backed mounts")
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>

Reviewed-by: Gao Xiang <xiang@kernel.org>

Also I will update the subject as "erofs: fix disallowing superblock_share
if device= is set".

Thanks,
Gao Xiang


