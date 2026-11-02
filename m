Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B3D606A94C
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Nov 2026 12:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hFqWJ6xb
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jJ9L94gc8z2yST;
	Mon, 02 Nov 2026 23:02:09 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793620929;
	cv=none; b=BOPXA8nkY60zFJhLt1Qrtm1uAm6jMpAa19QfHM8Z03Wi6u5+J3l/ieq/YNcEDxmvEwuuCCJmxPerFJ76ewLMG1ssD+bguOdoAy/QOibB98F+3qYIJZXxXcdFI7WfNXy1Lqlz4PADO0OYQrwuwf0qu/HFGG8/irc+tbDoK1oYEnSb0Q2pfB0vO2HrZqSu473Pe6V0OJeHGFDunLqocB/9xLdI0LBduw7X+IA5ghz6WoStUC7UBMevjWc0q67otLO0XjsqAeosNaGO22r2bGEATOTOPuLODPSlgdHoIdf1ml0TL+8bObRIpLgxFKVrfPwRm8stI8NQ9YqtuVyRPQjOcw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793620929; c=relaxed/relaxed;
	bh=gHY1puQJ7kSuZAenvzMMAkp9lfMXsFJFMUTGckGB6U0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cjBe7S18gilgEyhyGO69IJh+U+mehWiPFelBcENe02BJtjbcPFiuHaqtkF5vwqCjDXl+qbKMvtbQta6Ax1iBX6iyU7LOpMeqb0okaBji0aDVR3ABvDu3L41655IJpkK2m/O0t2KmZETWr+/vxLZua8OpmjulZxy6fWK/XMRkSBfOW1A0FOCCDzAVxw3QWDI2FzmVjAlKh9TONXCd2Fm2thycYiy6hCMBS7+yS1NqeIOxe3jz4yIpurSZgFbrHF0D8HhtzvHVsR/y2OhloIqPg9wz0xuG4Us419beFEUxeDTYFgyU/62g1ZyqxqitNAPjFqSrre7Mk1n6nadrLfzAFg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hFqWJ6xb; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hFqWJ6xb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jJ9L83hnBz2yKn
	for <linux-erofs@lists.ozlabs.org>; Mon, 02 Nov 2026 23:02:08 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 71DEE43284;
	Mon,  2 Nov 2026 12:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089F91F00A22;
	Mon,  2 Nov 2026 12:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793620926;
	bh=gHY1puQJ7kSuZAenvzMMAkp9lfMXsFJFMUTGckGB6U0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hFqWJ6xb8+YNk2t4sqrI8V49VwC1ky8tbwa60SzI20Liy9keur6iv+zgK/Z5jBGvp
	 VEN3IY914EIWvC2X3C2X3PjLJoDWBL+InxYyR+XoDpNceezLVm265BrBAA18IqxmcT
	 FOF491UKbf8ndlsXtIx83tfjGijOU7Sbtq4Y2Gue7Uk15pgY6Jv+jDwkZQ5DEB5Sn4
	 tI6qQy3ac3QTS9SlsKWAQ0L6Tm8CRpjamtFKFFVzRcG5Ygf6Cl7IEWr7d49axmJM3A
	 xP4KCGJxwFpDPvPNtKMq81V67IzV0eLLISziWwmjNfWBYwMKuNXKTYBjqhZYm4Nj7Q
	 HrJ2r5cE5Rjvw==
Date: Mon, 2 Nov 2026 13:01:59 +0100
From: Gao Xiang <xiang@kernel.org>
To: daejun7.park@samsung.com
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jingbo Xu <jefflexu@163.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: apply the stacked fs check to extra file-backed
 devices
Message-ID: <auh7t-KdfKXhUAUY@XiangdeMacBook-Pro.local>
Mail-Followup-To: daejun7.park@samsung.com, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jingbo Xu <jefflexu@163.com>, Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
References: <20261030-erofs-stacked-extra-devices-v1-1-39f7df7ac01b@samsung.com>
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
In-Reply-To: <20261030-erofs-stacked-extra-devices-v1-1-39f7df7ac01b@samsung.com>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 12:52:44PM +0900, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> erofs_fc_fill_super() rejects a file-backed mount whose image is on a
> file-backed EROFS or on a filesystem with s_stack_depth set. This
> bounds the nesting of reads. Extra devices given by device= are not
> checked. File-backed mounts can still nest through them without limit.
> 
> Apply the same check to extra devices.
> 
> Fixes: fb176750266a ("erofs: add file-backed mount support")
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Reviewed-by: Gao Xiang <xiang@kernel.org>

> ---
> Tested on erofs dev in a QEMU guest with KASAN and lockdep:
> 
> - Blobs on a file-backed EROFS or overlayfs now get -EINVAL.
> 
> - Blobs on XFS or a loop-mounted EROFS still mount and read back.
> 
> - Lockdep warns about devs->rwsem vs i_rwsem for a device= path inside
>   an EROFS mount, with or without this patch.

What does that mean? Can you explain more about this lockdep issue?

Thanks,
Gao Xiang

