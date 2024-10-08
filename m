Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29F26CEF148
	for <linux-erofs@archiver.kernel.org>; Tue,  8 Oct 2024 10:26:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4XNByh46Tfz2yx7
	for <linux-erofs@archiver.kernel.org>; Tue,  8 Oct 2024 21:26:52 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=139.178.84.217
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1728383211;
	cv=none; b=Dz4109fMMj913163a7/awavavOY4MKDCCUiajNVuSLNE1NYlnqoCmbo/hmqKp+us2Pd39qoZIIpH1ta4WImTu925pb/gD/oYah5edON+YHq60z9J/FsRwMZgpTxatve0EFdNn+iMp7wLwoG8K8oUO8xy4AjhGjr7nYo8PPl/wF7nxQ+Z/9b256YWi5BCf2B65ja1BxRijyPxR69Nxgf1d/lW++kljm2gkbsitYbeDX0ZynMocCcjqFdDWub4BuQl6HMgDt7Mx0/gS0V7/4CpUW6qU9AlsTCYh3B7NEKV70gJUWdwbtoIuqmBhMskyxVRs2YhQzefTPjRFSzrdWzxyA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1728383211; c=relaxed/relaxed;
	bh=JNQ5Xey4ZzdlAyNVmXPrbhxTwRKcup9Ucw5iVIHN1D4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JRC3Dxxhgcu7FAbMqgLCO15gE4IbyVQoIhgjWpIQhH5FBBjPy1fCbivlg8O6A7GESMCk9psfB03MT6ju3CYxGuHABDxCDnDCZd+xv/ZlqSwo6sy+u/+tZhBPw8W+8w9vqnMlUoGMde9upP3vm4m8omzyaguZiXBA9EvOhkmYH/KoyoGdiUusUrpV0N1j13IfGufjnqukZbU1Hv320zlu8E+bCR43lJwUHbYwfl9bnrsmE9BpK8skWQqMec+dici7wn6mUilm/lDiX5dtPm2vIKMO2lh//jojmJHZJdW+EClt0F7fCCkyzypmD2XaQu9Rz0mxg7nj7626GZfJVPLuoQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; dkim=pass (1024-bit key; unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KyMYLYbW; dkim-atps=neutral; spf=pass (client-ip=139.178.84.217; helo=dfw.source.kernel.org; envelope-from=gregkh@linuxfoundation.org; receiver=lists.ozlabs.org) smtp.mailfrom=linuxfoundation.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KyMYLYbW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linuxfoundation.org (client-ip=139.178.84.217; helo=dfw.source.kernel.org; envelope-from=gregkh@linuxfoundation.org; receiver=lists.ozlabs.org)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4XNByf1rqcz2xxr
	for <linux-erofs@lists.ozlabs.org>; Tue,  8 Oct 2024 21:26:49 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id B56145C5436;
	Tue,  8 Oct 2024 10:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FED8C4CEC7;
	Tue,  8 Oct 2024 10:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728383206;
	bh=VOWj/ElEg+xJ7SgTIJkX2eslYN+7n8APMcouViACqhs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KyMYLYbWGKxKrms3/FiRt+LplHUgSgYyuPZZRrElIgWhfnpiei8oTiGItxR37Awdm
	 k502SHHPaH4/AHsYLM+jjjYWcwWYjCaZx0e4lcSqIOZo5jGVti/Kgtw0y4Onc+c7CN
	 YZkqyvHB47BSdNuyDnRQiLhg4qYHhDbXbBN+pleY=
Date: Tue, 8 Oct 2024 12:26:43 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: Re: [PATCH 6.1.y 1/5] erofs: get rid of erofs_inode_datablocks()
Message-ID: <2024100829-unplowed-vending-675b@gregkh>
References: <20241008065708.727659-1-hsiangkao@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008065708.727659-1-hsiangkao@linux.alibaba.com>
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
Cc: linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Tue, Oct 08, 2024 at 02:57:04PM +0800, Gao Xiang wrote:
> commit 4efdec36dc9907628e590a68193d6d8e5e74d032 upstream.
> 
> erofs_inode_datablocks() has the only one caller, let's just get
> rid of it entirely.  No logic changes.
> 
> Reviewed-by: Yue Hu <huyue2@coolpad.com>
> Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
> Reviewed-by: Chao Yu <chao@kernel.org>
> Stable-dep-of: 9ed50b8231e3 ("erofs: fix incorrect symlink detection in fast symlink")
> Link: https://lore.kernel.org/r/20230204093040.97967-1-hsiangkao@linux.alibaba.com
> [ Gao Xiang: apply this to 6.6.y to avoid further backport twists
>              due to obsoleted EROFS_BLKSIZ. ]
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---
> Obsoleted EROFS_BLKSIZ impedes efforts to backport
>  9ed50b8231e3 ("erofs: fix incorrect symlink detection in fast symlink")
>  9e2f9d34dd12 ("erofs: handle overlapped pclusters out of crafted images properly")
> 
> To avoid further bugfix conflicts due to random EROFS_BLKSIZs
> around the whole codebase, just backport the dependencies for 6.1.y.

all now queued up, thanks.

greg k-h
