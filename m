Return-Path: <linux-erofs+bounces-3868-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 233B9C43458
	for <linux-erofs@archiver.kernel.org>; Wed,  8 Jul 2026 20:19:03 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gwTvT3D7Jz3054;
	Thu, 09 Jul 2026 06:19:01 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=103.168.172.149
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1783541941;
	cv=none; b=aW0g0iXs4xPobGUmBJS3HZuAPh1R0ygmxk5QjQAUxZOMTvOZreXlsTRM8JL2g6kmH6hR8ipp7Y3Op8po6sJN0vWuqfyvc/rCDmXYR2nnQPEbCMZxovFISRlHkvf+qv25OoluAsKjFVsxiATeVBMfO+x8If72+tH4cTsSQqkpW8Hj/0qKWsJkDT1mTSsjS5OipfdWq/WEzKZMIFa2cymYCQ92eWckvzkMpk2amKgjLARxXYuuOqP6w2FRsjiVE+ieSDJs6zKf1BktmU+bU3qFRigR0pyeLd6IrgOXrwBZw3mfdNGdq5pv/gvkdLUp9WHvTnGQFPFrifCS5fWLerGS0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1783541941; c=relaxed/relaxed;
	bh=wLGhsWeNJi8zd8/PkkwZnzKfSNF/g1DdrFV0OOf9YqY=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=noUbKF6acwvZ3XfojmNDDVjdiaTGNcbK1EOYniqBKYnDdn2dvlg1VADQ+OFiHXicm/J8fbvGavGcGihH54lnssGO+wD5F7PDja8JJpT6MuOaHoVVtA2IlDl5WydGqfbiw81mxrM/73G+Sx90AcCh6ZALuTZaRhQ9sNDgKBwVTnFKrKkGp8Ksxprx7/khn59SvxfW21oeXdX0Cj5/dayTGavzY6pcKnxoOMT2RLGsf5+N8RAd2qehlCqp6oukwfgnRK27scyTpo44JnkiRUxkfHlkjnOYt60OmA6NW3WUUfXBb3WsmOH2vWrbUCLNYE97ZNf6h31Z/7pDaF008YhNGQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=verbum.org; dkim=pass (2048-bit key; unprotected) header.d=verbum.org header.i=@verbum.org header.a=rsa-sha256 header.s=fm2 header.b=ow/n4Rit; dkim=pass (2048-bit key; unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=izvy4diN; dkim-atps=neutral; spf=pass (client-ip=103.168.172.149; helo=fout-a6-smtp.messagingengine.com; envelope-from=walters@verbum.org; receiver=lists.ozlabs.org) smtp.mailfrom=verbum.org
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=verbum.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=verbum.org header.i=@verbum.org header.a=rsa-sha256 header.s=fm2 header.b=ow/n4Rit;
	dkim=pass (2048-bit key; unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=izvy4diN;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=verbum.org (client-ip=103.168.172.149; helo=fout-a6-smtp.messagingengine.com; envelope-from=walters@verbum.org; receiver=lists.ozlabs.org)
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gwTvQ0wv4z2y7r
	for <linux-erofs@lists.ozlabs.org>; Thu, 09 Jul 2026 06:18:57 +1000 (AEST)
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 8D654EC0088;
	Wed,  8 Jul 2026 16:18:54 -0400 (EDT)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-04.internal (MEProxy); Wed, 08 Jul 2026 16:18:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verbum.org; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1783541934;
	 x=1783628334; bh=wLGhsWeNJi8zd8/PkkwZnzKfSNF/g1DdrFV0OOf9YqY=; b=
	ow/n4Rit5tUlEd2H3q0EG/TVdn2dzyC9g40PZAHxVjO+WA2ydZCUqPcuwfiQpSYA
	hhKT1Noiibx3cz96xPjI2Y27BGua9XfG0ZR6DKwsEdyyB8kus0twp75/VTK3+R2I
	8vkeWggo1FepJd//zs5uAQZftRuqS6so3/5TyP1yi6EMi5tFXFiuYbe4l41hoQbn
	pEhGkSEO4ogzNbO6mcyAbhhDXzfEtR4fxb1LvDGtkTyZfRMKrjtOOosWK84zN3uj
	mPzwVbTkSUp/dTR1Hmm6VXQc7i4iRkULOID8fp4QevA/ZmbfqOEZzHnjB6hjujhx
	pyJlW6/I93gxiD5UJqOpEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783541934; x=
	1783628334; bh=wLGhsWeNJi8zd8/PkkwZnzKfSNF/g1DdrFV0OOf9YqY=; b=i
	zvy4diNMr3EwaUdCBT9je5mqS3VjvyctlwpE65BoychvpB3oJDOS5DUOtLm6wG3l
	3g0Bvc1TjviPgXe0SikEnvSTcda8J+cc6iu6Xo/B4rpqvO+Vq2YISWAigBkRwfGf
	GzML+QhW+smpde/ZmnIV10Hl+vV3N/JVnI8qspZx/OqsSWXeas7KrdsFkTvKtH2Q
	UMW8cVGk5Lq0Jogxvmve/FtUk0C9cPPQfI4JIasJOSRax1ZAJnlUfhEWwzsVS9Kk
	qyyyDyEvg12ZytxZ8bTaTX5vwgJAp3+tUUJjU0hb8IKADFbk17h6+Y814M15kMtH
	6LhjgcDqntOkjdGO8tJzw==
X-ME-Sender: <xms:rLBOaicjHXAzWj2f30SgSCFtt9Gm4YwDjOXvGT1edISQp7rLKPrLdw>
    <xme:rLBOanDVf_8pC2mnRM10GE-EvyAWRa1mtsXCG3mUQqgA_hBpk2WCFo42IYiwwQJv2
    6_RnEWSOObAVF_IPlegFddN17Weq8lsOUHRTibx5pVKqVX130xUPw>
X-ME-Proxy-Cause: dmFkZTFeSPUT25v+12YVMbRBoofLsuPVc5lWVwFljbzt+zLqPXzvS4js3nW+jwmR6qiqwK
    l2E1L2sYGTAVEOpkxbHitkR4MrfePAFXCI95P8r5vW1cHnVPCapFoN0ksFkpcPxyOHmjxl
    Q3UxS3CfKznUJH9t1bb7dweAudc2NLBNNlY1Vj7KPNO2ClMqoqCcuR3Q4xEz1xXArAzlop
    kwDj1fHHL+1dmUAm7uAufaAoVr+O5SZtsPm2xR/ajf376wN043bEH0kqXoeeZ59scvJ8z9
    76XrIh3FM51EuTUDOesyqUyUYoIgl9o4yEE737hNR5K56mapr0aGMZ91aUILk06vtrnEbM
    0RztINzHEmPpqgUYqcS9DOomOKoubBzWKw/Tej5NK3ZRw+/Qxay/KC7Cim4YeHAIyeHYeo
    SojHnAD4pd0S7zm8czFFehVDgwXBww4HO3xJG/ByIkffHDjU/4QyVXLtf4jtnXgds6VAt0
    4cGcs4eHp4pB2lmSOaLKZJSLbZ7ehGHkdn4ZDvCrWghr0mc3VMmVPvaDnE8BRkBnppoF1Y
    ozs/0cHxXxVYFDU4/2Cf7Nx7NVCy5bIa+UnjdiAHpQtX1Qy8tUmwmjTxt6/KNlEqVweqYA
    aOcuqZsXiJCWmCSTvM+M0nMkPVB/LxltxZr1fjRDzZxKW5GmcgLA9ztdInPQ
X-ME-Proxy: <xmx:rLBOasGhE5DwljEjCOp92hnkDBmd-l2s62EnYPB0oOE_iQWxPvNQ1g>
    <xmx:rLBOaq3bJb6qB3C1f0R4dp8wCGR8-hAttyy99A2feNU_DGSJv5HYtA>
    <xmx:rLBOalPI9q1TWCVdIrzutQy_XXxskQqtEgURo6_NIllDFQc-Fiiuog>
    <xmx:rLBOaibrKjpkVkoCxKZnxH5gfa7tdFN4_oUrXzol3wBmef4Stjl39A>
    <xmx:rrBOalvn_VGwtfzSPnyv0ta10VqD041ZtZSW5_Gt0ZKHLVqcYuvu_Qff>
Feedback-ID: ibe7c40e9:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id B2F56780AB5; Wed,  8 Jul 2026 16:18:52 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
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
X-ThreadId: AP2jg_FR6fcw
Date: Wed, 08 Jul 2026 16:16:42 -0400
From: "Colin Walters" <walters@verbum.org>
To: "Amir Goldstein" <amir73il@gmail.com>,
 "Giuseppe Scrivano" <gscrivan@redhat.com>
Cc: "Miklos Szeredi" <miklos@szeredi.hu>,
 "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 linux-api@vger.kernel.org, "Al Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>,
 "Gao Xiang" <hsiangkao@linux.alibaba.com>,
 "linux-erofs mailing list" <linux-erofs@lists.ozlabs.org>
Message-Id: <01df945c-9dbc-4b80-b71c-f68aa70fb8bf@app.fastmail.com>
In-Reply-To: 
 <CAOQ4uxgbNhdzKN7tvRmFDpt-8CZWh9pVcMLv25HxJzA0_0WfSg@mail.gmail.com>
References: <20260708095831.3381978-1-gscrivan@redhat.com>
 <CAJfpegsJON=1_84PCGMjASYPFL=Wqsz7dnTAbO3Tdz5DfRQU+g@mail.gmail.com>
 <878q7l8y4y.fsf@redhat.com>
 <CAJfpegvQ06=2E0V_ADgxwmo7e5weTfOMozmBB-QVNLLWYAm8WQ@mail.gmail.com>
 <87wlv57dt1.fsf@redhat.com>
 <CAJfpegtTixwWSh9M-9NbwP0nUbJJ9rh0rxqO7BzgK7Su_RpM+A@mail.gmail.com>
 <87o6gh79yi.fsf@redhat.com>
 <CAOQ4uxgbNhdzKN7tvRmFDpt-8CZWh9pVcMLv25HxJzA0_0WfSg@mail.gmail.com>
Subject: Re: [PATCH] ovl: add ioctls to retrieve layer file descriptors
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On Wed, Jul 8, 2026, at 3:01 PM, Amir Goldstein wrote:

> If you want to keep a pool of mounted erofs images, you could do that
> in userspace -
> create a service that indexes mounted erofs images by unique mount poi=
nt paths.

You're right that it=E2=80=99d be possible to do this in user space.=20

However, overlayfs is used by many things (it=E2=80=99s a powerful =E2=80=
=9CSwiss army knife=E2=80=9D!) and this ability to reliably introspect i=
ts components is I think generally useful.

For example: https://github.com/systemd/systemd/issues/35017#issuecommen=
t-2457333218

Various tools want to know the backing filesystem(s) and/or block device=
s thereof, and if we don=E2=80=99t have something like this in the gener=
al case every overlayfs user would need to agree on a scheme to store th=
is data out of band - and manage its lifecycle as mounts change and deal=
 with where that data is stored with respect to mount namespaces etc.

Even if we had this API, would it be better to have a user space cache s=
erver for the original use case here? Maybe. I could personally go eithe=
r way.

But the introspection I think really would be generally useful and there=
 are code bases (in systemd and in composefs at least) that would start =
using it (with fallback for old kernels) for at least that use case righ=
t away.

