Return-Path: <linux-erofs+bounces-4339-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A0CBC61DBE
	for <linux-erofs@archiver.kernel.org>; Tue, 25 Aug 2026 12:32:57 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hTnHX0KF5z2xKh;
	Tue, 25 Aug 2026 22:32:56 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787661175;
	cv=none; b=E+8a3xlOf5r3SqMXBv7EYEOCNsaTeOtiBVV6uHUoHWol4PET4Alb0C9USvT5Qwl8Vvkq+qZok/1seBCFo5dAz/jJ/3+zfukTDDkSvb+4hmf+p4UzH3qWxRtSzpWdwAXOxufxwOl7280czGpOiPVeIEuR0I/e5EbWmPkjLdgdP8h3WrWkIkUZi5KvW9YC4LhT1dCdoFgMOvtj8BFyY9o0f65aoFqiqdZWpXCsDVxi85TOwnjLp4CqyZEVjiXUsBK/oSf2ETI1x/FEzcOlnCm4pxGKb72rORyBFia7WgF0eOcS4daDBCosL4Mu8Jh3WPZev7JStxvzdFpx0FIT3jBD3g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787661175; c=relaxed/relaxed;
	bh=SpXwlqfpTMSqPr0d90JklGo6OIEhYzopHmqlFENWmWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vs5VNJB6ODPcXvLnWIxn+jr/p6fi5g8biFzDP+tuvswDojEwFMKh8xgKoWap21iKsiLGMyF/dxcrofZgyX7dqqWJlM48Q+OSBjNDXK3S8q9h98gMT3gVF+F6aVjcEl7o4S05slI7uYvvhLhPuD0B3PGoI0OLkwcio+y5WSH86jPJg9ZcU1AnbXSrM1/cgrBnK2oijIDcGCh0916nnHKJEKMd6GIsQbBZFxXMu3uDMk0VWO2307c8qEMIgm19AaLyUVh9ATqjcfTKKxckkNocjA5Zk/qFhy45k9AKj8iiBQFS+CE2uordeQiTgfigImxzs20exsjNBVODSmF0D2f6kQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UQitDpqj; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UQitDpqj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hTnHW1gVFz2x9g
	for <linux-erofs@lists.ozlabs.org>; Tue, 25 Aug 2026 22:32:55 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D934E41AD3;
	Tue, 25 Aug 2026 12:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01ED01F000E9;
	Tue, 25 Aug 2026 12:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787661172;
	bh=SpXwlqfpTMSqPr0d90JklGo6OIEhYzopHmqlFENWmWs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UQitDpqjc9v1jX9R0zuwAqvDhnoeB4zVdMoM2mfkvZ3tl8spDoHHcIvHNpPkdifWg
	 8DQYd+tgNFbYtLodunNYY68F3u8GnLUf/TVDG/t5J/m1GQ4xI+MXNqlDWTPYu/06GS
	 gfBnm9LfjhROvo72q19a3Zqk+zRTwpMCxNcJTDiZPpmsFwZjx9p3FPstVIyBClP8Jl
	 e+gsftCO5KQfsxJoolMFhyYjjvFdbzc2s1UbhmF7+r+gMl+Z3tLMWRY8fHbLlT13cg
	 AxhTgpx2XQoRpA/klvQtCYZbvDHawGDVXo5MemJ2xhlj+X9slrbHQfXaWXeyIztK9Y
	 0LpdF4ka0vtJQ==
Date: Tue, 25 Aug 2026 14:32:48 +0200
From: Christian Brauner <brauner@kernel.org>
To: Gao Xiang <xiang@kernel.org>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, linux-erofs@lists.ozlabs.org, 
	linux-fsdevel@vger.kernel.org, amir73il@gmail.com, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 1/2] fs: rename vfs_get_super() to get_tree_super()
 and export it
Message-ID: <20260825-gorilla-zuhilfenahme-unfug-4b81185496a3@brauner>
References: <20260811071241.389589-1-gscrivan@redhat.com>
 <20260811071241.389589-2-gscrivan@redhat.com>
 <antDVPzz0tbn2kTU@XiangdeMacBook-Pro.local>
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
In-Reply-To: <antDVPzz0tbn2kTU@XiangdeMacBook-Pro.local>

On Tue, Aug 11, 2026 at 11:44:20PM +0800, Gao Xiang wrote:
> (+ cc vfs maintainers)
> 
> Hi,
> 
> On Tue, Aug 11, 2026 at 09:10:50AM +0200, Giuseppe Scrivano wrote:
> > vfs_get_super() already implements the common get_tree pattern of
> > looking up an existing superblock via a test callback and initialising
> > a new one with fill_super otherwise, but it is private to fs/super.c
> > and only reachable through the get_tree_nodev()/get_tree_single()/
> > get_tree_keyed() wrappers, none of which let a filesystem supply its
> > own test callback.
> > 
> > Rename it to get_tree_super() and export it so filesystems that need a
> > custom superblock matching policy can reuse it directly instead of
> > open-coding sget_fc() + fill_super().  No functional change.
> > 
> > This is a preparatory fix for the next patch.
> > 
> > Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> 
> With the new vfs_get_super() helper, it seems much cleaner compared
> to the previous versions.

I'll add this patch to the vfs-7.3.super tree post -rc1 and then you can
pull it in. Thanks!

