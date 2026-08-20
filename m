Return-Path: <linux-erofs+bounces-4276-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C0ABC5DF81
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 14:21:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQlwm5d5gz2xW5;
	Fri, 21 Aug 2026 00:21:12 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787235672;
	cv=none; b=RfD4xP/qBSZt94yN39vFKZH+agINBZQClqNJjty6QQxhwlO+A2wQwyDu+E52O6D5xn+uCOoDoKqEK2O6EAryL0gRPUHKLW0GadeHcYiiNyXlM6BRc4wI+tA+bExC5E4QfMeAIa8/QnB8Auout3VLD585H1buZu7ifSsQXxvx6zeBqLUmy/4mpv5LsclddduIdBPzcd0XR7LCqqaOXc0++3G4q+RBE4gvWNWFd8TzDMfpv8XD5wkPb4qqt61ogAZy+quPa9n3KQWmC6MzVYFde0HVa5CWkSgrEd7aLEfQFSJyM0ju1jibTh8C7ReLjvjT6EfduEKtudaHmn6/HLUmtg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787235672; c=relaxed/relaxed;
	bh=+ZcdAEUhkbXN4K8ncEoNu11AWGnMK2rPAWCk6bkQll0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UiX5SklvDsX7IUwDFaADthE7P22HxIX01KY3xTrP89eThRbDDlsfhgE1/5aB5LMvRu1KbKI/It/hGlBgnOsmicYN1sshJYYThNMYIG6e6RMmW5Lw2rv3wxu/EAqonA8viHdMyXYSAx0vdvz7Ucj9SgOn9na3l952AzNNTQiZyzyRVSSWQmDV3Qrn3oAdllH9VPrgPdDpDk1uQnkU3JxsZxBsA4zgs0YGroD/ptVg7hKp+0rKsKnxu5RqveCv2k0WMnoe+W4RUfxFgEl/AUOTjWkLvHvG4CnpCmC6mFZuXH7cHTkZhf5JcYPRRLSzALIImrUTx0pTDzna6jafdqBEvQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MfVAaghu; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MfVAaghu;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQlwl1WXYz2xRx
	for <linux-erofs@lists.ozlabs.org>; Fri, 21 Aug 2026 00:21:09 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8314F60008;
	Thu, 20 Aug 2026 14:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7A41F00A3E;
	Thu, 20 Aug 2026 14:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787235667;
	bh=+ZcdAEUhkbXN4K8ncEoNu11AWGnMK2rPAWCk6bkQll0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MfVAaghuH+JUIlsupRpToolb10KNGB4HeLaJD0pjCKF0f8MowP+g92NifS4cuX7Nf
	 ObA34ZNP2YDr1lNdOSuUcKLz2pBbeWK481BimPyPcyiAahccVtOPMhiRmULz7UBnYs
	 b76zcZi+tsMBLKDzZ9OHtQCrpBkgBet8FsHFM0iGVwnfqFeFEANbxnGIw5bwKZVmTG
	 T8CkNKsxOmtISxKhaPuyiwgMSxI2qUbREOMuFlHyN7xG1HZhnsbP1y9nY/RbzG76qm
	 sKjD4nKdFLby/K/b5wpCjkoRiV1ja7LO9rYZPy6sQl7BSe9xpX6g8TYG3eJOsEGFFE
	 u7ppNwbTI7siQ==
Date: Thu, 20 Aug 2026 22:20:56 +0800
From: Gao Xiang <xiang@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default
 logic
Message-ID: <aocNSPyHVoPHdJlU@XiangdeMacBook-Pro.local>
Mail-Followup-To: Guenter Roeck <linux@roeck-us.net>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <c480ed6b8bf38822263e2c5b7cf32b28600f212d.1787219898.git.geert+renesas@glider.be>
 <3d845134-9b75-40bd-b221-2bd35f98d425@roeck-us.net>
 <aob8wTTSCuq5054v@XiangdeMacBook-Pro.local>
 <b56c6945-df2c-4532-9c3f-711cad5f6174@roeck-us.net>
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
In-Reply-To: <b56c6945-df2c-4532-9c3f-711cad5f6174@roeck-us.net>

On Thu, Aug 20, 2026 at 06:43:20AM -0700, Guenter Roeck wrote:
> On Thu, Aug 20, 2026 at 09:10:25PM +0800, Gao Xiang wrote:
> > On Thu, Aug 20, 2026 at 05:51:08AM -0700, Guenter Roeck wrote:
> > > On Thu, Aug 20, 2026 at 12:00:23PM +0200, Geert Uytterhoeven wrote:
> > > > When NR_CPUS is less than 16, or when SMP is disabled, the default value
> > > > of 16 is invalid.
> > > > 
> > > > While actual configuration picks up a sensible and valid default
> > > > (NR_CPUS or 1), "make savedefconfig" will still write a line like
> > > > 
> > > >     CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1
> > > > 
> > > > to the defconfig file, even if that matches the sensible default.
> > > > 
> > > > Avoid needlessly enlarging the defconfig files, and reduce churn for
> > > > updating them, by specifying valid defaults depending on SMP and
> > > > NR_CPUS.
> > > > 
> > > > While at it, make the prompt depend on SMP, as there is no point in
> > > > asking the user about the maximum number of decompression streams if
> > > > there is only one valid answer.
> > > > 
> > > 
> > > Absolutely agree.
> > 
> > As I replied to Geert, unless there is a mandatory requirement
> > documented that "there is no point to make a Kconfig visible if there
> > is only one valid number".
> > 
> I would call that common sense.

Ok, I don't want to argue with that minor stuff more.

Thanks for the patch, I will pick up this patch with all rvb
tags later (no later than 7.3-rc2)

Thanks,
Gao Xiang

> 
> Guenter
> 
> > I tend to avoid making EROFS Kconfig visibility depend on arbitrary
> > architecture Kconfig options such as SMP or !SMP; SMP here is due to
> > some arches make NR_CPUS = 0 if !SMP, but it doesn't need to bother
> > users why a EROFS kconfig visibility has some relationship with an arch
> > kconfig.
> > 
> > Thanks,
> > Gao Xiang
> 

