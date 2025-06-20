Return-Path: <linux-erofs+bounces-478-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B863C7115B
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Jun 2025 21:18:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4bP9Lx02VNz30Pn;
	Sat, 21 Jun 2025 07:18:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=192.3.254.239
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1750454312;
	cv=none; b=Y8K9RFvp94j1wne+WfQ1xro+dzaOUUhOHZRV7iwBJLj2rVasleHRJtQB/pC4GkEXCf7KsLWckszbh+rAxBnwDGEdUjSOAygLXzGFcspxHxv/ighDj2QH+pO9bQO65em5VZPafkMVjPVW+ZG4sUvlRx1cqlJbb2cvlAuqF4qqWbMIcxnl/IkmB7Oo7BNKgPRlchO8U29R2cKBbsxBcs4Uo7LY6OJb6ltcvuVMlgdfFa/NQoP3Wo4+YMvmGpI0qliE51NAQVsYFuXwADhtV7EExiHdG8ONLHxpfE07JPxfinwZF2Rlxh7rP0DPlKGWfH+wo00GjIAgRvhewZsTgMtF9g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1750454312; c=relaxed/relaxed;
	bh=4vx1+CZa1waCPYmulwx5tPt5o5n9pTt2TQ9W/g6rnpg=;
	h=Message-ID:Date:Subject:From:To:MIME-Version:Content-Type:
	 References; b=e4Fyp+WGa9vswbCSll3hexbVfVQOSMg00zj1mea2qbMV35s/0fY1zg3JI91gggcJDxtmfM7c/zyWbvUeYm0J5SOaw8FIZ428XF3psEGDrmiYPM9IY+E4wMcGhD0YSXb2u/Rybua64EalVBEPYgkTEyIGu7h1SXY34oa1y7G7ZadBWlbL9/P1gM8shu+sffOrsArdfQ8xW2FmdjiLHU7vTjBV8QKkkGH1XsjMYoZIklkMTFeZb56g8WYAICI7bLf4mz3S9y5jpMzOVoOX7W1PQ8exUpEliVeNyQku03CP0VlJ6HsTTQyxs1N2KkScIiq2UvjbwEDtJKzVKyTzuVzxgw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sh.abgev.com; dkim=fail header.d=sh.abgev.com header.i=egan@sh.abgev.com header.a=rsa-sha256 header.s=selector2 header.b=r0xCeLMj reason="key not found in DNS"; dkim=pass (2048-bit key; unprotected) header.d=sh.abgev.com header.i=@sh.abgev.com header.a=rsa-sha256 header.s=mailer header.b=n03ur43t; dkim-atps=neutral; spf=pass (client-ip=192.3.254.239; helo=packaging.qualityassuredmanufacturing.com; envelope-from=gayla.groat@zjdobest.com; receiver=lists.ozlabs.org) smtp.helo=packaging.qualityassuredmanufacturing.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sh.abgev.com
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="key not found in DNS" header.d=sh.abgev.com header.i=egan@sh.abgev.com header.a=rsa-sha256 header.s=selector2 header.b=r0xCeLMj;
	dkim=pass (2048-bit key; unprotected) header.d=sh.abgev.com header.i=@sh.abgev.com header.a=rsa-sha256 header.s=mailer header.b=n03ur43t;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.helo=packaging.qualityassuredmanufacturing.com (client-ip=192.3.254.239; helo=packaging.qualityassuredmanufacturing.com; envelope-from=gayla.groat@zjdobest.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 1205 seconds by postgrey-1.37 at boromir; Sat, 21 Jun 2025 07:18:31 AEST
Received: from packaging.qualityassuredmanufacturing.com (packaging.qualityassuredmanufacturing.com [192.3.254.239])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4bP9Lv0D3Vz2y2B
	for <linux-erofs@lists.ozlabs.org>; Sat, 21 Jun 2025 07:18:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=selector2; d=sh.abgev.com;
 h=Message-ID:Date:Subject:From:Reply-To:To:MIME-Version:Content-Type:
 References; i=egan@sh.abgev.com;
 bh=4vx1+CZa1waCPYmulwx5tPt5o5n9pTt2TQ9W/g6rnpg=;
 b=r0xCeLMj1lZ+jl3ijq5gp1MqoION3k/VEyteI+C+IvBDCV3zns8YrVi+TBgidec4BHVZtpOyN8pe
   BtOQ0oBOwLyTZLgjnvx3dwgMOdLFwveP0f5hEPUK2f431T7dudpxr5q/y6AeqTqAQaean3GVmSYA
   fNrgpAOauoeEJoY5NNs=
DKIM-Signature: v=1; a=rsa-sha256;
 bh=4vx1+CZa1waCPYmulwx5tPt5o5n9pTt2TQ9W/g6rnpg=; d=sh.abgev.com;
 h=Message-ID: Date: Subject: From: Reply-To: To: MIME-Version: Content-Type:
 References; i=@sh.abgev.com; s=mailer; c=relaxed/relaxed; t=1750453101;
 b=n03ur43tCfbmgZfKo2c2f/LA/vzomNo2n/TglVcCTM6nUa4nurJU2QzXoNgsY7a9axkITvSpq
 MouSloIe70b81uRvc/bhM5+PAo2xuZ7wNEDL4YtpLaFgHgSjnah5KzfaQyHa1Om2H93AUI5ez
 QmjrjP92JZV7ZgSoXKrK8UQ5uYDckE7ajokvLU8o9arqhifJizMp60wfNS28pRJ0h/m2FugrE
 VBZ4f+OP6WXDbJEE7Egve6OeSckW32+CBtYS+CcAmpJkrr5CWE0x8goMCTUw0pq7HNxjNE1py
 dp63deo9PSJfoMk4OxJeAJzQFtt1sLNpPa5Ht+nHtRaRf/uOZQ==
Message-ID: <212b59316e5111c3dd3630a9fe0acf700504a604@zjdobest.com>
Date: Fri, 20 Jun 2025 20:58:21 +0000
Subject: Unlock expert-level precision through our comprehensive range of
 advanced CNC services tailored specifically toward achieving superior
 manufacturing outcomes.
From: Carole Pagano <egan@sh.abgev.com>
Reply-To: Carole Pagano <info@en.preassem.com>
To: Linux erofs <linux-erofs@lists.ozlabs.org>
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
Content-Type: multipart/alternative;
 boundary="_=_swift_1750453101_9b98fdae7c0cfcbf1de41066cd8f0e63_=_"
References: yr932esdqpb5c


--_=_swift_1750453101_9b98fdae7c0cfcbf1de41066cd8f0e63_=_
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

 Hello Linux erofs,
I trust this email finds you living life to the fulle=
st.

It is my pleasure to introduce Cnm Precision Molding Design Co., L=
td
(CNM), a leading provider of prototype development and short-run
man=
ufacturing services for global innovators since 2000. Located
within Shen=
zhen=E2=80=99s high-tech corridor, we offer full-service turnkey
solution=
s covering SLA/SLS rapid prototyping, vacuum casting,
precision CNC machi=
ning, sheet-metal fabrication as well as complete
surface finishing and a=
ssembly under one roof.

Our facility features 35+ CNC machines, vacuum=
 casting systems, UV
curing ovens and a specialized hardware division to =
support production
runs from single prototypes through short-run manufact=
uring while
ensuring precision tolerances and expedited delivery. We prov=
ide
material solutions across diverse polymers including ABS/PC/Nylon/PMM=
A
as well as aluminum/copper/stainless steel alloys tailored for
automo=
tive components, medical instrumentation, consumer electronics
systems & =
robotic applications.

Our team consisting of over one hundred skilled =
individuals is fully
committed to maintaining rigoro us international sta=
ndards, including
first-artic le inspection processes and SPC data tracki=
ng for every
order we handle=E2=80=94ensuring precision at each stage fro=
m design through
delivery.

I would appreciate the opportunity to exp=
lore your upcoming
requirements and illustrate how our comprehensive solu=
tions can
optimize efficiency in development cycles while minimizing expe=
nses.
Please do not hesitate to reach out for a call or site tour

Tr=
uly yours,
Jame Rufeyr932esdqpb5c=20

--_=_swift_1750453101_9b98fdae7c0cfcbf1de41066cd8f0e63_=_
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html>
<html>
<head><meta charset=3D"utf-8"/>
=09<title> Unl=
ock expert-level precision through our comprehensive range of advanced CNC =
services tailored specifically toward achieving superior manufacturing outc=
omes.</title>
</head>
<body>Hello Linux erofs,<br />
I trust this ema=
il finds you living life to the fullest.<br />
<br />
It is my pleasure=
 to introduce Cnm Precision Molding Design Co., Ltd (CNM), a leading provid=
er of prototype development and short-run manufacturing services for global=
 innovators since 2000. Located within Shenzhen=E2=80=99s high-tech corrido=
r, we offer full-service turnkey solutions covering SLA/SLS rapid prototypi=
ng, vacuum casting, precision CNC machining, sheet-metal fabrication as wel=
l as complete surface finishing and assembly under one roof.<br />
<br />=

Our facility features 35+ CNC machines, vacuum casting systems, UV curin=
g ovens and a specialized hardware division to support production runs from=
 single prototypes through short-run manufacturing while ensuring precision=
 tolerances and expedited delivery. We provide material solutions across di=
verse polymers including ABS/PC/Nylon/PMMA as well as aluminum/copper/stain=
less steel alloys tailored for automotive components, medical instrumentati=
on, consumer electronics systems & robotic applications.<br />
<br />
O=
ur team consisting of over one hundred skilled individuals is fully committ=
ed to maintaining rigoro us international standards, including first-artic =
le inspection processes and SPC data tracking for every order we handle=
=E2=80=94ensuring precision at each stage from design through delivery.<br =
/>
<br />
I would appreciate the opportunity to explore your upcoming r=
equirements and illustrate how our comprehensive solutions can optimize eff=
iciency in development cycles while minimizing expenses. Please do not hesi=
tate to reach out for a call or site tour<br />
<br />
Truly yours,<br =
/>
Jame Rufe<span style=3D"color:#ffffff;"><span style=3D"font-size:8px;"=
>yr932esdqpb5c</span></span>
</body>
</html>

--_=_swift_1750453101_9b98fdae7c0cfcbf1de41066cd8f0e63_=_--


