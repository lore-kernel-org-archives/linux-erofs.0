Return-Path: <linux-erofs+bounces-4232-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D584C5CFC1
	for <linux-erofs@archiver.kernel.org>; Sun, 16 Aug 2026 03:10:57 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hN1FC5thbz2y83;
	Sun, 16 Aug 2026 13:10:55 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=157.180.15.194
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786849855;
	cv=none; b=Uw0cMMipYi5SHU256nRNPEigspAmXdSHTOKtGZuy8fGQ4L4QbO+kyUStdQiCDqZu43gMBRbv2Sx2jXjI14Rw5KUnSzK/eLYjEWu50M2wAXxs2LUtPr48yn6JKQIUmFRv1sdK7HRGZ61ipqDdnqLRL6b63czEarGuLMb9HJ/rRkSVYo92POFo8w1PdAkFQigfw6TTkCtnCr6hsuXVlpdfHg2rv+la0EJ1Ighz1gu0SXfmgeCaIpel4dVA2M0mOC/THBbkKo86YNoPRj8SB9tXHjwVO3WBHdlGL7wtq7PLZuZ02ud70AlNa5+xr7foYmHbmWl/eTzcjOxFY7JbB4RBEw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786849855; c=relaxed/relaxed;
	bh=THNaG18hCRuMyp28k58DLD3qnHxBLp2XZUx4BLxJCjo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CK65Cvr4JIriHtP991oKVmz3bfK9KVZKCjJtLMj30+XBA1OJ8F+b4ToZ2iGtbRSBKs09+FROg2EMFXZRAIVIAF5p+FtmAywoOIxxjhJaPBaX48JZjmLrI9XAtBdQfwpXcfBumg9zYMeZK+B2P5l8FsAXtihPc8DWeTkBZtrgq5mUwXttym3QJN+lLQ0JWvmH/G0OeGGLvCD9df70XpK7RGOwFG0wY9IJLYpRie40GRmvcCPE8OxP8usgfWRygQrEswSGprxOGLr4acduLNRk3BeFVqfhS1oPVFCj8Vqx2BzFCwAxt7WSKlnt0SW1obVG4auMnXwSkRn5ZVO1m9pIuw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=envs.net; dkim=pass (4096-bit key; secure) header.d=envs.net header.i=@envs.net header.a=rsa-sha256 header.s=modoboa header.b=HsTpILb+; dkim-atps=neutral; spf=pass (client-ip=157.180.15.194; helo=mail.envs.net; envelope-from=xtex@envs.net; receiver=lists.ozlabs.org) smtp.mailfrom=envs.net
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=envs.net
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; secure) header.d=envs.net header.i=@envs.net header.a=rsa-sha256 header.s=modoboa header.b=HsTpILb+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=envs.net (client-ip=157.180.15.194; helo=mail.envs.net; envelope-from=xtex@envs.net; receiver=lists.ozlabs.org)
Received: from mail.envs.net (mail.envs.net [157.180.15.194])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hN1F95NFkz2xwM
	for <linux-erofs@lists.ozlabs.org>; Sun, 16 Aug 2026 13:10:53 +1000 (AEST)
Received: from localhost (mail.envs.net [127.0.0.1])
	by mail.envs.net (Postfix) with ESMTP id 660C11C00F1;
	Sun, 16 Aug 2026 03:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=envs.net; s=modoboa;
	t=1786849850; bh=THNaG18hCRuMyp28k58DLD3qnHxBLp2XZUx4BLxJCjo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HsTpILb+yo2hHZjrSOp/fRGsrieBCJCeMxu9N56hnAi+om0Bcx5seBcRzs2SxQK3B
	 iGylaWonk3etR/8BZBgTu8Cm5tRtK7YUgMOZ59JwHv9kzSDrumwDHdtd9Qt3RPxtAb
	 uE23uUXsHgJPld2wjV37Nd3kAhZ5E9mHts7r3FjMtVhpJQH3FZ004MjRTWYgr+IskL
	 GorGkPNNYwuj8vd6d6gRVmL5hfuXpkNl+6Jagb/UK8+0x33RJub0qbL62l5k+njn+4
	 c68s3KRTjHM79t0PdkKxaFr0Mj1UB5gZYAPCNKBGbMRFmfzdFRan26eVz4QYCIBGuO
	 tLY4E+PiCMBjy5de9as6lcQD0ghK1yh4KIB0j99SNpH0O7rIiUgaeZY+QX+4ANV78Z
	 AY2Wm5aQwLY9pwBIeQfGThHSPds2Iq4lysaSFwKKSEDOvPEg3zwkmlJ5RGMLUryDs0
	 /L2JfChD50mnqC5T9gLOw9YeQG3ZqP9jW9pZ/+LMLsInAnkC8+Kkve9zCFXN3zNbcd
	 8SzhUUJAO3fTWjwQ2Vhi2Pzv3yvby13D3lFHC7A/YzNkibD1VUhp/cVaouP7cWh8CZ
	 9AVmqCEVtYZtAJt89e0w1eAJNjR/2wQ9g1Q2A/RVxfNu4EkuuAGkYASdNagqVNbTNY
	 iZM6rg88hz5HKRiDO9IBP1lc=
X-Virus-Scanned: Debian amavisd-new at mail.envs.net
Received: from mail.envs.net ([127.0.0.1])
	by localhost (mail.envs.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 8thAD0Q16lNr; Sun, 16 Aug 2026 03:10:44 +0000 (UTC)
Received: from xtex-l16.localnet (unknown [120.230.214.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.envs.net (Postfix) with ESMTPSA;
	Sun, 16 Aug 2026 03:10:44 +0000 (UTC)
From: xtex <xtex@envs.net>
To: Bingwu Zhang <xtex@envs.net>, Gao Xiang <xiang@kernel.org>,
 Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>,
 Hongbo Li <hongbohbli@tencent.com>, Chunhai Guo <guochunhai@vivo.com>,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 Bingwu Zhang <xtex@astrafall.org>
Subject: Re: [PATCH] erofs: remove erofs_dev_context->rwsem
Date: Sun, 16 Aug 2026 11:11:28 +0800
Message-ID: <MkLn7nwBTr2E85Djml6mgQ@envs.net>
Organization: AstraFall
In-Reply-To: <aoEpHV2r6ye_Ff3c@XiangdeMacBook-Pro.local>
References:
 <20260816-erofs-remove-rwsem-v1-1-78b60b855fa6@astrafall.org>
 <aoEpHV2r6ye_Ff3c@XiangdeMacBook-Pro.local>
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
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hi,

On Sunday, August 16, 2026 11:06:05=E2=80=AFAM China Standard Time Gao Xian=
g wrote:
> Hi Bingwu,
>=20
> On Sun, Aug 16, 2026 at 10:00:12AM +0800, Bingwu Zhang wrote:
> > From: Bingwu Zhang <xtex@astrafall.org>
> >=20
> > devs->tree is only modified in initialization and
> > destruction code paths and will never be concurrent
> > with data reading. Thus there is no need to guard
> > idr_alloc/idr_find with a rwsem.
>=20
> Thanks for the patch.
>=20
> In principle, yes, but it's also no problem to leave it as-is in case
> some use cases later need adjust the device_info of a dev for example
> at runtime.
>=20
> Or if it causes any noticeable performance penalty, that will be one
> reason to drop it now.

Thanks for the reply. I don't think it caused any notice performance=20
difference so it looks good to me to keep the rwsem.

Thanks,
Bingwu Zhang

>=20
> Thanks,
> Gao Xiang
>=20
> > Signed-off-by: Bingwu Zhang <xtex@astrafall.org>





