Return-Path: <linux-erofs+bounces-4406-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B79C624D0
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 02:30:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZRY80Ys1z2xlv;
	Wed, 02 Sep 2026 12:30:52 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788316251;
	cv=none; b=N7dk7Ua50qb7jqnKp9LEES+pdYH03om60GnVMqmubjW55U/fxICXbbNdb6nufoGOW2LSorMGELdmDByESohHMK23Y7JwHHPx9uWxUKG5slHz0oiafxym/TTEcAucJ+ZnGiqyC6rCaE3b765dMNxcPKK3rC/RcyA4X8JU9XU8v7VKnkjbt13l0fJO+EhcHCy9OI3GjuGSNXFXCE19N83b3IbQOaVqr5EiwgXu/VQtWfrz/cOuvx5ilk97cvGSIU8NDa1XwiS2Q1WQvM/pxap5VZBKx1mF23adEo7HBLufpdKRfyJvnOd/CgKbzDmdyuK3PAhi4+opK4pc8Kn+3mJc6A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788316251; c=relaxed/relaxed;
	bh=bmZ3zyXvqtCC4yEJpQ+fp7sbvP3sfAY6Z/LhHvL9IHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QgGRhB/AXAVazcTwIpu5NBQgdd54AQ3vTq+tsxdB9Pb9TNRr6aGzbSTvsMOxTgnhdXh62yLDpqOydg0Yf983TbAOVHWKcyKeVn3XmPrB3/RPFtj6+mvxVFDc4kscZpBd3QvcjFV8Y1QWgCPeETr1a3U0oy8WG4Jw/tIykTJMtB55vMRAtoaMv1aSwE6EGWzPnG6ozyeTlXXI+WUnPnRPGC7gPfenqRjqtqBc+uFWMufXkKFyvwdYWec0XUPa+ZfhXRmX0iw1ki1icuqOwArCtW4Qhz3Wu9p6yVU9AMd4wUCfG/2FBNCkAG677c/tqrsQjn6CswxkkBa0SXYYj3ixmw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MvZYBXLk; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MvZYBXLk;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZRY72dPJz2xlY
	for <linux-erofs@lists.ozlabs.org>; Wed, 02 Sep 2026 12:30:51 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0708E41753;
	Wed,  2 Sep 2026 02:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6331F000E9;
	Wed,  2 Sep 2026 02:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788316248;
	bh=bmZ3zyXvqtCC4yEJpQ+fp7sbvP3sfAY6Z/LhHvL9IHQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MvZYBXLkL4wjyheg6fTHnevdvRBE7Ds9Q/e/wtBt5/cpCfgiXnCd3STCy2+xsJbqy
	 i5QOv84fQ2wSAXUq/m+0UW4BRzdhCmcpWrq5/VohiIvu5Qy9TIsQWnD/r/6QpnRozf
	 Zz6/QbD6z9eK7foG5LfUO4/ddd5BOLRtVXOwKm3N4y97MO2c04vx+E91uScluUe+06
	 s3FQKcsdAgzLSzYp02QYHqST10bS9h6zoibfURKryFZ4Ryf8qo5TNbZz57hvBdusm5
	 tZAfiC/I51O1XBsaZKldgOnBTR+QyshwNsYYj4kJonXFW8KGrYTMM6eS8jk3YWOio6
	 2V7gxODH+yuRA==
Date: Wed, 2 Sep 2026 10:30:41 +0800
From: Gao Xiang <xiang@kernel.org>
To: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: preserve LZMA decoders on resize failure
Message-ID: <apeKUdpJhf_NlKR4@192.168.5.22>
Mail-Followup-To: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
References: <20260830104109.60639-1-nikhilgurudasani314@gmail.com>
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
In-Reply-To: <20260830104109.60639-1-nikhilgurudasani314@gmail.com>

On Sun, Aug 30, 2026 at 04:11:09PM +0530, Nikhil Gurudasani wrote:
> The pool-resize path frees each stream's old decoder before allocating
> its replacement. If an allocation fails after some streams have already
> been replaced, the failed stream is put back on the list with state ==
> NULL. z_erofs_lzma_max_dictsize is still advanced as if the whole
> pool had been resized.
> 
> An existing LZMA mount can select the broken stream and pass
> NULL to xz_dec_microlzma_reset(). A retry at the same size also
> skip another resize attempt. Since the global maximum was advanced,
> thus, the invalid state is left unrepaired.
> 
> Allocate each replacement before freeing the old decoder, temporarily
> retaining one old decoder during allocation. Stop at the first failure
> and advance z_erofs_lzma_max_dictsize only after all streams satisfy
> the request.
> 
> Record each stream's dictionary capacity so retries can skip streams
> already enlarged before a partial failure.
> 
> Fixes: 622ceaddb764 ("erofs: lzma compression support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

