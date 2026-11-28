Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401C0606A31C
	for <linux-erofs@archiver.kernel.org>; Sat, 28 Nov 2026 04:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C1+HqSBF
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jbxg92Y4Zz2y97;
	Sat, 28 Nov 2026 15:11:33 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795839093;
	cv=none; b=UhKF+zaotYuaTUUBctw60J5IfxWrCqzpvbeNB1z2Tem6gUuoroj1pWxoRO++pWXR6NpSt1cVP/3h3dCjgxX4CPbk73R+Xchlb0Ndf0q8ugDtAFx2lq0FP4qMhOJCDhlzxAY3Z6Ym6NDxAkJzx8C8dYtZvc6XgyRWbKmPcYug4iyM7qqTTAIfzFR8hGT204lbMMvhyJttk1o0iQqa+6okWEJp2TjTmOgTqGtBF7W3aU2ajXeZzcaE9jRS77tffA1XieuuLzE5wzHlzmuUeVCOur8S7uZ0xAVHXeg80juhco73kkaytkzeVox6wABnrkMWyRA6yEZMzVuvj9WxZ4CU0g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795839093; c=relaxed/relaxed;
	bh=gbfr335MaH9FR2RTW6xJZd/ANJFw2AiRzqnOW5qP3GM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kyoDlppDLGWwNF5xNzal/FhClVOWMx1+zYL2podhiECjSanVLfpzIsxHf6tV3Z4wMp5yv9KhGDhBndtv5QQDmt+ZwzywMCSpyC9n7YPBCCOCrpXSt0jpZRC1kRbikMY//K80STsv6ehQlJQDUUyBUXJQRAu2H6x9Jev1T+hqiUtDYZiiOWzzxX8FKnv7m9z+RJBTWPcyzQQ371o81RxnzZxE3YpJkEH6IvFC0VEC6QsHzNg21cEdp+q3MuSCY7R33ev6wq9/EggTUzd5EQbkpFQ1dojwbR5aWVR64g9vcuQa9n9sMaFv/B+TimNcbA9xLWnlqdnwiy55s+jkvMkF/A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C1+HqSBF; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C1+HqSBF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jbxg85Bjcz2y1W
	for <linux-erofs@lists.ozlabs.org>; Sat, 28 Nov 2026 15:11:32 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 99F5A60210;
	Sat, 28 Nov 2026 04:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399AF1F000C1;
	Sat, 28 Nov 2026 04:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795839089;
	bh=gbfr335MaH9FR2RTW6xJZd/ANJFw2AiRzqnOW5qP3GM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C1+HqSBF3D3Kh1NRzggdCCcrSBJMdpfdIhEfUJ5g4mW+CvRtnRe9Pr2lHfXSM+rK/
	 sM+uAKziIZxwUXOsZoSzFH/xgU5zQCnOWkNoBtXRqPsTyK9RGdgZxXfCeHDPMhuOLS
	 Zv9z6DB1N36NAXY0O4K2ulHHAVF4u+sgecNN5ZxpfE53lSv1ikf9SoXE4rE+wNpQBo
	 FqUBYaUSiZ0ojpmZ7US5mcYJYstjLWpogEOtzWD0n1vGUDGlYlFtd8ke3Hki/kh+54
	 yEdRVNihavDoSXVPkVa4SMsG+gEzPO1VhJ+YxQAIkEjnbNHVzrdxj4+JY6ukY4wl83
	 9AD/DfzvgW3vw==
Date: Sat, 28 Nov 2026 05:11:22 +0100
From: Gao Xiang <xiang@kernel.org>
To: Nilay Vaish <nilayvaish@google.com>
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jingbo Xu <jefflexu@163.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH] erofs: use page_private() in z_erofs_is_shortlived_page()
Message-ID: <awpUagm0z2JKI6or@MacBookPro.fritz.box>
Mail-Followup-To: Nilay Vaish <nilayvaish@google.com>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jingbo Xu <jefflexu@163.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org
References: <20261124033701.832938-1-nilayvaish@google.com>
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
In-Reply-To: <20261124033701.832938-1-nilayvaish@google.com>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 07:37:01PM -0800, Nilay Vaish wrote:
> Short-lived pages are marked with set_page_private(), but
> z_erofs_is_shortlived_page() tests the marker by reading page->private
> directly.
> 
> struct page is being shrunk as part of the memdesc work, and its private
> field is one of those that will move. Direct users have to go through
> the accessors before that can happen.
> 
> Read the marker with page_private(), to match how it is set.
> 
> No functional change.
> 
> Signed-off-by: Nilay Vaish <nilayvaish@google.com>

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

