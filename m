Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8B7606A31B
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Nov 2026 09:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=InY6wC0L
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jKLGp5QTDz2xK7;
	Wed, 04 Nov 2026 20:48:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793785698;
	cv=none; b=IbGoWaB94uOabd7CQLwXdhDCg70ENovtN7h0c/1hA6naQgOBFnzejinrT2dlC9JBba1MUXFcTQTDaFgf9MfcjsjP9brJcOlDeL9I3FjOvVJpElq+Oypxh61Zt5ZUrct4wt2aisxh+u/ThH/Q/fOQPWCdbVgRFvwNt2jttwuyopxEMuAwm/O0ZCe7oWA44dcEmlveNQ/C6gCRm9uSkdMrvz0iDTf99RKhGVoSndmJrsbK4jNsP8P/Y9gFtDnR0MLwI9BgLZF9Dtkks6nRzxDRZB/ipXMSa7YYCoxOJZrAfbAJWW9LPYRSj5X0fqlKPEZrPyRB9aWiwPYS9ismMsn91g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793785698; c=relaxed/relaxed;
	bh=HXzV35Z8UwpB17ysmZXHbQ0RRCvEcx5jH2Iaw9wScdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A3S0Sr1X26JBTzo9EEJUsTuVIEyED/qaHt8I0T+OBfvrv0Fcbwm/scodkhJ8Zmg+KxhnOFRMH/quSqTonwxCMhgs0GA5/PWwtI3cBGpgdrOB0GMuJYFMIqhxJerNOT2RWsu1m3kY2DljTwSR+N/XLf/x+YzxF+NYSxogVYiP7Tmczrme0PmjQ9/qiYaSUHiELgv3wfGkIugAPOoqtrkff1g0E9kWyKRZYuhgcpn+aIJB5Rax8XoG1YnpnwlI0uLnmaX225VxQ4DLIjffIPqaO+M5Gil1CTmzW0oqC2ji4ZmP+MQDUisR1QDEOZQRkFDiQskPgCKICTjJvW9J+NHwDw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=InY6wC0L; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=InY6wC0L;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jKLGp0cw1z2xGw
	for <linux-erofs@lists.ozlabs.org>; Wed, 04 Nov 2026 20:48:17 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AAC0410DA;
	Wed,  4 Nov 2026 09:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9089D1F0093A;
	Wed,  4 Nov 2026 09:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793785695;
	bh=HXzV35Z8UwpB17ysmZXHbQ0RRCvEcx5jH2Iaw9wScdw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=InY6wC0Lu/gE1+Uh9tivct4df3l9zhQNYnbCEA4+N7iJzhya1BjWHq7875hXbMx4i
	 JSOVZ5adapMJadDpAl1T/blwxthLNJSOEA4t4EVO7LTnwUxSQknlv9JvKz/3z8f7av
	 KYCJ7mxw/uUa9lvseLUNpsV+sEpSqq04qJJkMJS0aBkatvZ32QaEI/gCyICcnTkGkB
	 ipEgO9WNm2noUsomIFuHtMj1kbeeoJKeKCEwprSSPgfc61IYJ8Pl8bvhgmCa1/YM3m
	 pRdTX7WUeZ9fKYV8MKpHLCYG2kwNqW4v7BFC06Zf5LZaC7titPk3Z+Yl8jLsO7dz0Z
	 DPoLcM769tPpg==
Date: Wed, 4 Nov 2026 10:48:08 +0100
From: Gao Xiang <xiang@kernel.org>
To: daejun7.park@samsung.com
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jingbo Xu <jefflexu@163.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v2 2/3] erofs: treat files shared by inode_share as
 stacked
Message-ID: <aur_WN7z_EnoYSu-@XiangdeMacBook-Pro.local>
Mail-Followup-To: daejun7.park@samsung.com, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jingbo Xu <jefflexu@163.com>, Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
References: <20261103-erofs-fileio-bioset-v2-0-5b91af423f72@samsung.com>
 <20261103-erofs-fileio-bioset-v2-2-5b91af423f72@samsung.com>
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
In-Reply-To: <20261103-erofs-fileio-bioset-v2-2-5b91af423f72@samsung.com>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 03:29:32PM +0900, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> A file-backed mount whose image or extra device is on a block-backed
> EROFS passes erofs_is_stacked_file(). If inode_share shares that file,
> erofs_real_inode() may pick an inode of a file-backed EROFS in the same
> domain to read it. File-backed reads then nest in the same task.
> 
> Treat files that use erofs_ishare_fops as stacked.
> 
> Fixes: 34096ba919fd ("erofs: support unencoded inodes for page cache share")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20261030-erofs-fileio-bioset-v1-1-caf47adbb3a3@samsung.com
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Reviewed-by: Gao Xiang <xiang@kernel.org>

I will address the first two patches upstream as fixes in these two weeks,
and then review the remaining one as a new feature later.

Thanks,
Gao Xiang

