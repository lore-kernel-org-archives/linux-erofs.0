Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20E7606A31C
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 09:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=xunyunfawu.com header.i=office@xunyunfawu.com header.a=rsa-sha256 header.s=default header.b=M7fvTAxF
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQsPW0LRbz2xlw;
	Fri, 13 Nov 2026 20:28:15 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=38.9.97.189
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794562095;
	cv=none; b=Lq7DhF4luZRRTgmYXmnFpZKSx6/SQXfdRgqgwIaKCQuFCaENQnslr5sVIR3ptSIe9VRaXSuiBfwwtZUekbFb30EFnqAa5eYTMpwH0xX6RpLWbb0WblX8qFqVvVZHF+/H2Tb2nJvtv/7Nwdqg3nciyfHOFKVIoDwWTtHiteFZ2LYs3b52p+psvIj7rKjTyaRZ7zJAvpuCaEMbal3qLMd0ZdzlUS/9v8V1Jrvcm3aSWCfcpjU3QxPFGTMwL0KqntGQA7N/xW/KO1n4eFY4YbnOpBeV+BmcWFxTLWHWsrufvM6DVCbizVoS2qrEl5qJSTEVcEy4r3yXI7WXHyLTw9s44w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794562095; c=relaxed/relaxed;
	bh=O4nEADRKomJXg6H1PBILjkEB2Ot/rM/uoZWUVVhkYiI=;
	h=From:Subject:To:Content-Type:MIME-Version:Date:Message-Id; b=fjV93rmES5mZkpIKvtAhnT2umM4zoDyk27CP6PvRGpO0e2wP1KalNs5V5eThahOrJayWVnraR9YJl4pteK2Y/0eD2T7VdAdu5SDCSeIVMf7RyB1XM9ep7+p/H0Zy8mjdbPtRlJcbzY4NwFIJF0S2L4PHJrwnfcz3haXPq0egDI2rOofEDUbW+u9on8+xhm7dTwJ3/Ofxx359HNGVCQXfgEQf0KXbMJcXcPLdyj45KPX6gKmuMopmtoHIYjld2CpF9vRsJ4j2IfxNpFpMu49LhfPyO3tbxlBo18R1Svb1MqvxcB4Jx9f25Tpy32J63lcJdI/2jMxYSII0t49EZh0xBw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=xunyunfawu.com; dkim=pass (2048-bit key; unprotected) header.d=xunyunfawu.com header.i=office@xunyunfawu.com header.a=rsa-sha256 header.s=default header.b=M7fvTAxF; dkim-atps=neutral; spf=pass (client-ip=38.9.97.189; helo=xunyunfawu.com; envelope-from=office@xunyunfawu.com; receiver=lists.ozlabs.org) smtp.mailfrom=xunyunfawu.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=xunyunfawu.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=xunyunfawu.com header.i=office@xunyunfawu.com header.a=rsa-sha256 header.s=default header.b=M7fvTAxF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=xunyunfawu.com (client-ip=38.9.97.189; helo=xunyunfawu.com; envelope-from=office@xunyunfawu.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 1822 seconds by postgrey-1.37 at boromir; Fri, 13 Nov 2026 20:28:14 AEDT
Received: from xunyunfawu.com (xunyunfawu.com [38.9.97.189])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQsPV1c0qz2xcB
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 20:28:13 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=default; d=xunyunfawu.com;
 h=From:Subject:To:Content-Type:MIME-Version:Reply-To:Date:Message-Id;
 i=office@xunyunfawu.com;
 bh=O4nEADRKomJXg6H1PBILjkEB2Ot/rM/uoZWUVVhkYiI=;
 b=M7fvTAxFkeolkrPwj+oW1sxSE4ENPf1Rh22X9Jcy7POLnBQA555vnoSKE0oOZ3K2ULLRuT6zhaNp
   zuwCn6vhqtWNdAJamt1UXPLYZSh1wTITV1D174zmf8+IA/duL+F2jR20oE9z1YJzELV1VBhGyjHM
   ENOoeC8MhQp1Puy4/gynV6H+MkNNg8PC1PQXtj7nltAxSaRkEeCjcZYDYYtqQTRjfUo/gxjO5p1s
   WUjzJMF6TOE2mKJNAToMSJU6EnDXXuxCzcg+gCLiFWNN17hr1ZgxDdE8qm9K+cVMrrAMDLN2D/Mr
   dq+yWB+GU9YlP7I02ZMdK6oNCTdnxaQfSodbOw==
From: "Gloria Lizeth Ramos Hernandez" <office@xunyunfawu.com>
Subject: Request for Bulk Order Quotation - DANI
To: <linux-erofs@lists.ozlabs.org>
Content-Type: multipart/alternative; boundary="1K=_g7YUG5KReaBKr1gF3iWDG85nn3hRQI"
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
Reply-To: <lizeth.ramos@dani.com.mx>
Date: Fri, 13 Nov 2026 00:37:45 -0800
Message-Id: <20261311003745DBE692BA94$613E88271B@xunyunfawu.com>
X-Spam-Status: No, score=2.7 required=3.0 tests=BAYES_50,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is a multi-part message in MIME format

--1K=_g7YUG5KReaBKr1gF3iWDG85nn3hRQI
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Good Morning Sir/Madam,

I hope this email finds you well.

On behalf of DANI, I would like to inform you that we have thoroughly =
evaluated your product and are pleased to confirm our interest in plac=
ing a bulk order.

We appreciate your prompt attention to this matter and look forward to=
 your confirmation.

Best regards,

lizeth Ramos God=EDnez
Gte. Administraci=F3n de Ventas
01(791)91 3 8056
cel: 5534495416

lizeth.ramos@dani.com.mx

facebook / dinacamiones

--1K=_g7YUG5KReaBKr1gF3iWDG85nn3hRQI
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


<html><head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-=
8859-1">
  <title>Request for Bulk Order Quotation - DANI</title>
 </head>
 <body> <P>Good Morning Sir/Madam,</p><p>I hope this email finds you w=
ell.</p><p>On behalf of DANI, I would like to inform you that we have =
thoroughly evaluated your product and are pleased to confirm our inter=
est in placing a bulk order.</p><p>We appreciate your prompt attention=
 to this matter and look forward to your confirmation.</p><p>Best rega=
rds,</p><p><B style=3D"FONT-SIZE: 16px; FONT-FAMILY: Aptos, sans-serif=
; WHITE-SPACE: normal; WORD-SPACING: 0px; TEXT-TRANSFORM: none; COLOR:=
 rgb(0,0,0); FONT-STYLE: normal; ORPHANS: 2; WIDOWS: 2; LETTER-SPACING=
: normal; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; font-v=
ariant-ligatures: normal; font-variant-caps: normal; -webkit-text-stro=
ke-width: 0px; text-decoration-thickness: initial; text-decoration-sty=
le: initial; text-decoration-color: initial">lizeth Ramos God=EDnez<BR=
><BR><IMG border=3D0 src=3D"" width=3D185 height=3D58><BR></B><BR styl=
e=3D"FONT-SIZE: 16px; FONT-FAMILY: Aptos, sans-serif; WHITE-SPACE: nor=
mal; WORD-SPACING: 0px; TEXT-TRANSFORM: none; FONT-WEIGHT: 400; COLOR:=
 rgb(0,0,0); FONT-STYLE: normal; ORPHANS: 2; WIDOWS: 2; LETTER-SPACING=
: normal; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; font-v=
ariant-ligatures: normal; font-variant-caps: normal; -webkit-text-stro=
ke-width: 0px; text-decoration-thickness: initial; text-decoration-sty=
le: initial; text-decoration-color: initial"><SPAN style=3D"FONT-SIZE:=
 16px; FONT-FAMILY: Aptos, sans-serif; WHITE-SPACE: normal; WORD-SPACI=
NG: 0px; TEXT-TRANSFORM: none; FLOAT: none; FONT-WEIGHT: 400; COLOR: r=
gb(0,0,0); FONT-STYLE: normal; ORPHANS: 2; WIDOWS: 2; DISPLAY: inline =
!important; LETTER-SPACING: normal; BACKGROUND-COLOR: rgb(255,255,255)=
; TEXT-INDENT: 0px; font-variant-ligatures: normal; font-variant-caps:=
 normal; -webkit-text-stroke-width: 0px; text-decoration-thickness: in=
itial; text-decoration-style: initial; text-decoration-color: initial"=
>Gte. Administraci=F3n de Ventas</SPAN><BR style=3D"FONT-SIZE: 16px; F=
ONT-FAMILY: Aptos, sans-serif; WHITE-SPACE: normal; WORD-SPACING: 0px;=
 TEXT-TRANSFORM: none; FONT-WEIGHT: 400; COLOR: rgb(0,0,0); FONT-STYLE=
: normal; ORPHANS: 2; WIDOWS: 2; LETTER-SPACING: normal; BACKGROUND-CO=
LOR: rgb(255,255,255); TEXT-INDENT: 0px; font-variant-ligatures: norma=
l; font-variant-caps: normal; -webkit-text-stroke-width: 0px; text-dec=
oration-thickness: initial; text-decoration-style: initial; text-decor=
ation-color: initial"><I style=3D"FONT-SIZE: 16px; FONT-FAMILY: Aptos,=
 sans-serif; WHITE-SPACE: normal; WORD-SPACING: 0px; TEXT-TRANSFORM: n=
one; FONT-WEIGHT: 400; COLOR: rgb(0,0,0); ORPHANS: 2; WIDOWS: 2; LETTE=
R-SPACING: normal; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0p=
x; font-variant-ligatures: normal; font-variant-caps: normal; -webkit-=
text-stroke-width: 0px; text-decoration-thickness: initial; text-decor=
ation-style: initial; text-decoration-color: initial">01(791)91 3 8056=
</I><BR style=3D"FONT-SIZE: 16px; FONT-FAMILY: Aptos, sans-serif; WHIT=
E-SPACE: normal; WORD-SPACING: 0px; TEXT-TRANSFORM: none; FONT-WEIGHT:=
 400; COLOR: rgb(0,0,0); FONT-STYLE: normal; ORPHANS: 2; WIDOWS: 2; LE=
TTER-SPACING: normal; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT:=
 0px; font-variant-ligatures: normal; font-variant-caps: normal; -webk=
it-text-stroke-width: 0px; text-decoration-thickness: initial; text-de=
coration-style: initial; text-decoration-color: initial"><I style=3D"F=
ONT-SIZE: 16px; FONT-FAMILY: Aptos, sans-serif; WHITE-SPACE: normal; W=
ORD-SPACING: 0px; TEXT-TRANSFORM: none; FONT-WEIGHT: 400; COLOR: rgb(0=
,0,0); ORPHANS: 2; WIDOWS: 2; LETTER-SPACING: normal; BACKGROUND-COLOR=
: rgb(255,255,255); TEXT-INDENT: 0px; font-variant-ligatures: normal; =
font-variant-caps: normal; -webkit-text-stroke-width: 0px; text-decora=
tion-thickness: initial; text-decoration-style: initial; text-decorati=
on-color: initial">cel: 5534495416</I><BR style=3D"FONT-SIZE: 16px; FO=
NT-FAMILY: Aptos, sans-serif; WHITE-SPACE: normal; WORD-SPACING: 0px; =
TEXT-TRANSFORM: none; FONT-WEIGHT: 400; COLOR: rgb(0,0,0); FONT-STYLE:=
 normal; ORPHANS: 2; WIDOWS: 2; LETTER-SPACING: normal; BACKGROUND-COL=
OR: rgb(255,255,255); TEXT-INDENT: 0px; font-variant-ligatures: normal=
; font-variant-caps: normal; -webkit-text-stroke-width: 0px; text-deco=
ration-thickness: initial; text-decoration-style: initial; text-decora=
tion-color: initial"><I style=3D"FONT-SIZE: 16px; FONT-FAMILY: Aptos, =
sans-serif; WHITE-SPACE: normal; WORD-SPACING: 0px; TEXT-TRANSFORM: no=
ne; FONT-WEIGHT: 400; COLOR: rgb(0,0,0); ORPHANS: 2; WIDOWS: 2; LETTER=
-SPACING: normal; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px=
; font-variant-ligatures: normal; font-variant-caps: normal; -webkit-t=
ext-stroke-width: 0px; text-decoration-thickness: initial; text-decora=
tion-style: initial; text-decoration-color: initial"><A style=3D"TEXT-=
DECORATION: underline; COLOR: rgb(5,99,193)" target=3D_blank>lizeth.ra=
mos@dani.com.mx</A></I><BR style=3D"FONT-SIZE: 16px; FONT-FAMILY: Apto=
s, sans-serif; WHITE-SPACE: normal; WORD-SPACING: 0px; TEXT-TRANSFORM:=
 none; FONT-WEIGHT: 400; COLOR: rgb(0,0,0); FONT-STYLE: normal; ORPHAN=
S: 2; WIDOWS: 2; LETTER-SPACING: normal; BACKGROUND-COLOR: rgb(255,255=
,255); TEXT-INDENT: 0px; font-variant-ligatures: normal; font-variant-=
caps: normal; -webkit-text-stroke-width: 0px; text-decoration-thicknes=
s: initial; text-decoration-style: initial; text-decoration-color: ini=
tial"><I style=3D"FONT-SIZE: 16px; FONT-FAMILY: Aptos, sans-serif; WHI=
TE-SPACE: normal; WORD-SPACING: 0px; TEXT-TRANSFORM: none; FONT-WEIGHT=
: 400; COLOR: rgb(0,0,0); ORPHANS: 2; WIDOWS: 2; LETTER-SPACING: norma=
l; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; font-variant-=
ligatures: normal; font-variant-caps: normal; -webkit-text-stroke-widt=
h: 0px; text-decoration-thickness: initial; text-decoration-style: ini=
tial; text-decoration-color: initial">facebook / dinacamiones</I></P><=
/body>
 </html>

--1K=_g7YUG5KReaBKr1gF3iWDG85nn3hRQI--


