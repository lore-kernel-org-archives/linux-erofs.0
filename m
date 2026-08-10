Return-Path: <linux-erofs+bounces-4152-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BFA3C5AD55
	for <linux-erofs@archiver.kernel.org>; Mon, 10 Aug 2026 13:19:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hJb1s5qwjz300M;
	Mon, 10 Aug 2026 23:19:13 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786367953;
	cv=none; b=OocnuHDHKLBLjueDDpYS2goHLICUv9nW/VViw4prcFDyF+IPqFm7nzbxRkK+zl0E14DzLQA//XYnGA3feS6na+iMkC/64ue2XXkdFJOEF/zqj77/DPEzBa6hhhMZ649gD0B0tNCUDGmK3guEyXv8Hid9/lZXO3coGfz7ssesuboUsOMDbNLvsPMNnMEd6zoHDgIQ366HlUrMKfDEB/ZttCABDb+LWN5Qc/8OgJ7OGMcUg8eJ20t+r5GwbSbx+PqipXzibhAm/6xXR9xBvJj80TKQxgKnBEGFob+/wA2EVUyFPivBBEtvN2nRozMcGw1FjhpD8GV6ZZEO83oYk3zOGw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786367953; c=relaxed/relaxed;
	bh=55CYy1X48mpUWrsFfxjjXFMg/rvIGm2J087+sZKFdAQ=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=EOnsWZAa+dC9eQauTrPwfs/W7qNTq42TmjajkA3VdFrEj1qwvxQi9VPWSQzHIn2zc1wnigMTxdKAvAQJadYpeGqhqQaWE1ozhWRGdwyKbxgT02/0l0hbIq0MfQyW5vaGpYXq36mTcVxD4bxZJHq9oVYZC/R2WM/m8U3ZTNJud6BGHfcAit7XQ0m5YY0N9oJTXggZ03lms7EbTsmTB30+DrQmM5Z48t5uNz96I+aCjDubfyGji5mmydroHUTaVXqx+PNl5w7DjfZMEfEMY1vU3Dx3DQKIZ7zWN6gXni8V6fqydLIimis2OSPIPGK4UjHik+H6hCxFfKTdDBCCJ8fy5w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ckZE4Gws; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ckZE4Gws;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hJb1r64Srz2ytv
	for <linux-erofs@lists.ozlabs.org>; Mon, 10 Aug 2026 23:19:12 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C3CE460A5D;
	Mon, 10 Aug 2026 13:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDAC1F000E9;
	Mon, 10 Aug 2026 13:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786367950;
	bh=55CYy1X48mpUWrsFfxjjXFMg/rvIGm2J087+sZKFdAQ=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=ckZE4Gws9ZQP6jAds2RVL4UpMgGTLgYcSGMFpBiNa05yhtoalSBf0DRXdzwi6a4Pt
	 QoCxoErU1MYm8O0wSsVBa945jUSF2foKMTr4P7w5C/dav0sGfGa+Uy6TN8qa97Syuh
	 yyAGQds9u8QWNEt3En1r/xH73Kd3VsYWBkIkSNf7/3SQtwrMc0tAq4JAZShiJV1PQx
	 k7U7Av7SGgtBa3xWoUdOy/H2wfp2Vn1LLO9sbEkoc7xmq8yDRaLCoeH4CX/5bajgum
	 92fa37vgGl3u+6GVQH4K671dlsGeA9Vlx1L1IpX//F4ZM7XXGKuqyxmn+7MHluDAaE
	 OjDNaslSPJ/UQ==
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6] erofs: accept source file descriptor via fsconfig
From: Christian Brauner <brauner@kernel.org>
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org, 
 linux-fsdevel@vger.kernel.org
In-Reply-To: <20260804055949.2927896-1-gscrivan@redhat.com>
References: <20260804055949.2927896-1-gscrivan@redhat.com>
Date: Mon, 10 Aug 2026 15:19:05 +0200
Message-Id: <20260810-abenteuer-mietvertrag-geraten-8f6a9fa6ef55@brauner>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=400; i=brauner@kernel.org;
 h=from:subject:message-id; bh=QlD3nPeGKYbXd7zeK8x6La0FUMv808+zuusS4pzcyYE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRVnj/bOI3jYXTyhbWephErN/+323NutWtDSnKEbc99l
 qW/1zKu6yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIz0ZGhvcGbxi/q83bq9vQ
 EHSh/S772kTWe3cevnn67TaTr6QOLzsjw6qsPYVHF6ZVf5tyIcjG9MfVt2pFq4zdM9hdhPXZ/gk
 wcAEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Hi Giuseppe,

On Tue, 04 Aug 2026 07:58:42 +0200, Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> Allow userspace to pass an already-opened file descriptor as the mount
> source instead of a path string.  This is useful for tools that already
> hold an fd to the image, such as composefs reusing an existing erofs
> backing file.

Reviewed-by: Christian Brauner <brauner@kernel.org>

-- 


