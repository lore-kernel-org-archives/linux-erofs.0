Return-Path: <linux-erofs+bounces-4073-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EEF0C55171
	for <linux-erofs@archiver.kernel.org>; Sat,  1 Aug 2026 03:23:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hBpDx2kglz2yT0;
	Sat, 01 Aug 2026 13:23:45 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785554625;
	cv=none; b=LliXo4kuiCmJvH63ecV2KuWPWBny8EVPXN0+KHkcmPfoS4m3KEFDjWiAcwwYyN2elJ2udU6n++gN1+/DMRxLJkAaXFgJP6gH39xYzN5ZW0ldMA7A8H7Y4BZAZKAtutcnseZvsmofnQ24/am4Yl5bUNuoGpsyllvbJCWvegveu3lFTlszO0KbF7RzX1Q6FxtD5JeSBAoljpZwnfyk2/h1xnaXMeRj6G6oJgQyRlJcIzVeWpJqJCNQzxb5yY1ljW96LUSSQ2KF9VdjPn5B+qic6f0zXrxA+11nzhrK0lwQBNDVoUY1Koyuxg/85lO8lohmwXqd9tHsJHqvZrQhxw3IvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785554625; c=relaxed/relaxed;
	bh=li38dYZ5L1cbcG7IrogqVzq62hVXlOIuYK6vBGjTZWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oqs64/2dwImdFk63GeNwwHPMQnlW1TIDQgciNRnq8F1ZLc6/lfKxgFf+yoetKVHjsn6qHU805VTrlRSwGroBcDWcXkQ3q4ELepH7qmR3pI2fYDhgo/U5QitYKhKhIj1v4sQ7dSk8VHIdmUtAGbNlbwNbShpKfjjk7ScVv6iim8pAmewhxo0MK3QIXLDb5dn1X01Xk1vBr27/OtocyvmHmDGOp1fga9lkl5GKu61ERc9CxM8q1F+bULcLmvPdVaMHJQ8nosBJ7Duz5TUguR93V8R28yb4PsBEZk++3voT6bXLU2k+atnf+e5NKFfpHEgXIr6kNABguPLVp7RFaXdIHQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FpBCcqHD; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FpBCcqHD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hBpDw3W0Nz2ySN
	for <linux-erofs@lists.ozlabs.org>; Sat, 01 Aug 2026 13:23:44 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 10A0741474;
	Sat,  1 Aug 2026 03:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DD21F00AC4;
	Sat,  1 Aug 2026 03:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785554621;
	bh=li38dYZ5L1cbcG7IrogqVzq62hVXlOIuYK6vBGjTZWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FpBCcqHDXfr7bOihxxwOylL31oNlwWAF8TqUqslAvLPvTLGNMY/s4Iaw2OfQXiY4S
	 I9gOk8+pdmyn8HZ0Tqn549QX7yfVN6VO4/yDLWtSiIEqgflGo8SAP2K5r5lJ0ooqVG
	 GUc2tJicYm4mwtBGoQwPlkrFz/bgtXsQ+1dJzjU87uMYx+ZPI2CLrTtWgiO1Cmz43Y
	 uGSvwOglrWfjqPT2fqt43J1xRMXp5MCP4cdLfFvaR31p3HgbGvXDpscQRutRVvotA8
	 XI/pEYgweT7Db8i34L3S5sFArGH7D0yqWRdw2DAcpUEIzG+/Q2HlDF4uWHAi35mXGT
	 hSd0y/In7bAOA==
Date: Sat, 1 Aug 2026 11:23:36 +0800
From: Gao Xiang <xiang@kernel.org>
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org
Subject: Re: [PATCH] erofs: fix typo in error messages
Message-ID: <am1muGemLUB1USRG@XiangdeMacBook-Pro.local>
Mail-Followup-To: Giuseppe Scrivano <gscrivan@redhat.com>,
	linux-erofs@lists.ozlabs.org, xiang@kernel.org
References: <20260731160642.2273938-1-gscrivan@redhat.com>
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
In-Reply-To: <20260731160642.2273938-1-gscrivan@redhat.com>

On Fri, Jul 31, 2026 at 06:06:42PM +0200, Giuseppe Scrivano wrote:
> the option is called "inode_share".
> 
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>

Thanks for catching this:
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

