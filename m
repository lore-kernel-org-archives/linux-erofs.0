Return-Path: <linux-erofs+bounces-4254-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE6C5C5B572
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 03:01:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQSrt4lv1z2yhY;
	Thu, 20 Aug 2026 13:01:50 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=140.205.208.135
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787194910;
	cv=none; b=LEf+hVnB8d/xSTfbfC6TqPxuP/2UHYgbtvznkULdGdy3wdMkWQiFQLar0w4s3rFpyChb+jrWH5lvZWTSpUKaRlXGL+E+WJtsdCi8LAXeZXiA7Q9O/eWyjV+Ibt/5Hbbh9iw5iHPUp+NmtKxIQ2BQ8XFp1rqIKAsaB+GUPiJaDLve57wV//bkZOx9laMpu9071e6SYK8SjXCDwdpKUaW0I7UO7zRb/vaByhaiJqnKRQAUqHs2eNPTGsnJQfuiLJChkYqoQpR1UOL6tyu4w/u1gz5NA7iKaH8Z5S/zYLT23sdr/+Dc10x7uOtS0Pn2ziWKEz9152CN4EBpXl0H6ch8pA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787194910; c=relaxed/relaxed;
	bh=YhYOIQE60tKpHXUj6jSI+9AbyBBqFgSDdEFkzewVuz0=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type; b=AIQK5psjXwwyyq7rXU6HkwtntJP6/8e0opp8YHx/xuYo4Fhmzhtxv37OfUUMt1fbfTb471DaSNulFoTGiB4noYjTggao7+GlNHvPl8pGM+WeGJjXVS4n94/YgeNJpVAs6G97qtsnO6t8EfobSDXaGJkQu7DXYsEEwf3xcPQkzVqNPXN2SJXOQRmpMfDOEHTg1tUrRq5am9DJOalvN4+wWH8sSkjjR7ccqioKR97GIBxAeOAZwO3b3BiUBFVXfag07ay0aHO3G933g2Ny/PIt4SSxoBEcbKDvxzSknURRYeTTfrkG3MXkgKDoeug6s1+lE47qzCjZpOC/ixJSxAgJ8w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=mcpcnserver.com; dkim=pass (1024-bit key; unprotected) header.d=mcpcnserver.com header.i=@mcpcnserver.com header.a=rsa-sha256 header.s=aliyun-cn-hangzhou57fb2d3494 header.b=RVOiri89; dkim=pass (1024-bit key; unprotected) header.d=dm-fbl.aliyuncs.com header.i=@dm-fbl.aliyuncs.com header.a=rsa-sha256 header.s=feedback header.b=n9A/DoAa; dkim-atps=neutral; spf=pass (client-ip=140.205.208.135; helo=out208-135.dm.aliyun.com; envelope-from=market@mcpcnserver.com; receiver=lists.ozlabs.org) smtp.mailfrom=mcpcnserver.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=mcpcnserver.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=mcpcnserver.com header.i=@mcpcnserver.com header.a=rsa-sha256 header.s=aliyun-cn-hangzhou57fb2d3494 header.b=RVOiri89;
	dkim=pass (1024-bit key; unprotected) header.d=dm-fbl.aliyuncs.com header.i=@dm-fbl.aliyuncs.com header.a=rsa-sha256 header.s=feedback header.b=n9A/DoAa;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=mcpcnserver.com (client-ip=140.205.208.135; helo=out208-135.dm.aliyun.com; envelope-from=market@mcpcnserver.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 344 seconds by postgrey-1.37 at boromir; Thu, 20 Aug 2026 13:01:45 AEST
Received: from out208-135.dm.aliyun.com (out208-135.dm.aliyun.com [140.205.208.135])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQSrn57tYz2ySm
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 13:01:44 +1000 (AEST)
X-AliDM-RcptTo: bGludXgtZXJvZnNAbGlzdHMub3psYWJzLm9yZw==
Feedback-ID: default:market@mcpcnserver.com:alibabak_ApiBatch:448107
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mcpcnserver.com; s=aliyun-cn-hangzhou57fb2d3494;
	t=1787194899; h=Date:From:To:Message-ID:Subject:MIME-Version:List-Unsubscribe:Content-Type;
	bh=YhYOIQE60tKpHXUj6jSI+9AbyBBqFgSDdEFkzewVuz0=;
	b=RVOiri89bWYICMf70TOoJiwddV0wsR1aZwXclwPb+iTwIU+vZnDo+wz32amtKmhaZwY9QEfmYxIVoJ1Jn/yU6vIJ4E66aQkhEPmxLMkVVXYhck+5c/yfaIq+lys2XFCHoHo+npTnbMCfUHy6ehB/Lrw3tttqHwWzGHoh22b5uVM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dm-fbl.aliyuncs.com; s=feedback;
	t=1787194899; h=Date:From:To:Message-ID:Subject:MIME-Version:List-Unsubscribe:Content-Type;
	bh=YhYOIQE60tKpHXUj6jSI+9AbyBBqFgSDdEFkzewVuz0=;
	b=n9A/DoAa5CVWszE6pPFqKDaly4beAG02ork0CBZIJqKv0DnQb2u6T1lWK10ha4jzt1pQHmOk4KaDn374zU3bEZ9lyubSv/aW9vH3/FNevUJgFlZrbNTydzz9XAPcjbeUxieKg0oPb9UXLHKr04Jey4dCuvtrH+p2HCxlJYOmDbo=
Received: from chitu-hsf(mailfrom:market@mcpcnserver.com fp:ma_600000347518596459 cluster:AY35D)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Aug 2026 10:55:53 +0800
Date: Thu, 20 Aug 2026 10:55:53 +0800
From: "NiubiStar Support Team" <market@mcpcnserver.com>
To:  <linux-erofs@lists.ozlabs.org>
Reply-To:  <feitechen@gmail.com>
Message-ID: <f45f6d4d-4e77-42f4-b0d5-1be9d1699202@alibaba.com>
Subject: =?UTF-8?B?RGV2ZWxvcGVyIG1hcmtldGluZyBwbGFuIGZvciBvcGVuLXNvdXJjZSBwcm9qZWN0cw==?=
X-Priority: 3
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
X-EnvId: 600000347518596460
X-AliDM-Settings: eyJPdXRib3VuZElwIjp7IklwTGlzdCI6W10sIklwUG9vbElkIjoiIn0sIlVuc3Vic2NyaWJlIjp7IkZpbHRlckxldmVsIjoiZGVmYXVsdCIsIkxpbmtUeXBlIjoiZGVmYXVsdCJ9LCJWZXJzaW9uIjoiMS4wIn0=
List-Unsubscribe: <https://www.niubistar.com/unsubscribe?email=linux-erofs%40lists.ozlabs.org&token=outreach>
Content-Type: multipart/alternative;
  boundary="----=ALIBOUNDARY_2345_7f770bc76700_6a866e13_a100"

------=ALIBOUNDARY_2345_7f770bc76700_6a866e13_a100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,=0A=0AI am reaching out from NiubiStar, a developer marketing service for o=
pen-source, AI, DevTools, SaaS, and infrastructure projects.=0A=0AMany strong =
technical projects do not need a long agency pitch. They need a clear launch m=
essage, the right developer-facing channels, and a simple delivery record that=
 shows what was actually published or sent.=0A=0AWhat we can help with:=0A=0AL=
aunch positioning and campaign brief=0AEnglish project article or placement pl=
anning=0ARelevant developer, startup, SaaS, or technical community distributio=
n=0ADeveloper outreach execution with opt-out handling=0ADelivery report with =
public URLs, campaign notes, and observable replies where available=0A=0AWe do=
 not need your GitHub account, password, token, repository permission, or priv=
ate customer data. A public project link and a target timeline are enough to s=
cope whether the campaign is useful.=0A=0AIf you are preparing a release, laun=
ch post, directory push, or developer-facing update, you can review NiubiStar =
here:=0A=0Ahttps://www.niubistar.com/=0A=0AIf this is relevant, reply with you=
r project link and launch window. We can suggest a practical plan before any p=
ayment or commitment.=0A=0AIf this is not relevant, reply "stop" and we will r=
emove this address from future outreach.=0A=0ABest regards,=0ANiubiStar Suppor=
t Team=0A=0AUnsubscribe: https://www.niubistar.com/unsubscribe?email=3Dlinux-e=
rofs%40lists.ozlabs.org&token=3Doutreach
------=ALIBOUNDARY_2345_7f770bc76700_6a866e13_a100
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<!doctype html><html><body style=3D"margin:0;padding:0;background:#eef2f7;font=
-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Arial,sans-serif;co=
lor:#111827;"><div style=3D"display:none;max-height:0;overflow:hidden;color:#e=
ef2f7;">Developer marketing, launch planning, content placement, outreach exec=
ution, and proof reporting.</div><table role=3D"presentation" width=3D"100%" c=
ellspacing=3D"0" cellpadding=3D"0" style=3D"background:#eef2f7;"><tr><td align=
=3D"center" style=3D"padding:34px 16px;"><table role=3D"presentation" width=3D=
"100%" cellspacing=3D"0" cellpadding=3D"0" style=3D"max-width:700px;background=
:#ffffff;border:1px solid #d8dee9;border-radius:18px;overflow:hidden;box-shado=
w:0 22px 58px rgba(15,23,42,0.12);"><tr><td style=3D"height:7px;background:lin=
ear-gradient(90deg,#0f172a 0%,#2563eb 46%,#14b8a6 100%);"></td></tr><tr><td st=
yle=3D"padding:26px 30px 10px;"><table role=3D"presentation" width=3D"100%" ce=
llspacing=3D"0" cellpadding=3D"0"><tr><td style=3D"vertical-align:middle;"><a =
href=3D"https://www.niubistar.com/" target=3D"_blank" rel=3D"noopener noreferr=
er" style=3D"font-size:22px;font-weight:850;color:#0f172a;text-decoration:none=
;letter-spacing:0;">NiubiStar</a><div style=3D"margin-top:5px;color:#64748b;fo=
nt-size:13px;">Developer marketing for open-source and technical products</div=
></td><td align=3D"right" style=3D"vertical-align:middle;"><a href=3D"https://=
www.niubistar.com/unsubscribe?email=3Dlinux-erofs%40lists.ozlabs.org&amp;token=
=3Doutreach" target=3D"_blank" rel=3D"noopener noreferrer" style=3D"display:in=
line-block;padding:8px 12px;border:1px solid #cbd5e1;border-radius:999px;color=
:#475569;font-size:13px;text-decoration:none;">Unsubscribe</a></td></tr></tabl=
e></td></tr><tr><td style=3D"padding:10px 30px 28px;"><h1 style=3D"margin:0 0 =
10px;color:#0f172a;font-size:25px;line-height:1.26;letter-spacing:0;">Develope=
r marketing plan for open-source projects</h1><p style=3D"margin:0 0 22px;colo=
r:#475569;font-size:14px;line-height:1.7;">A practical promotion service: posi=
tioning, content placement, developer outreach, and delivery records.</p><div =
style=3D"padding:18px 18px 4px;background:#f8fafc;border:1px solid #e2e8f0;bor=
der-radius:14px;"><p style=3D"margin:0 0 16px;color:#111827;font-size:15px;lin=
e-height:1.78;">Hi,</p>=0A<p style=3D"margin:0 0 16px;color:#111827;font-size:=
15px;line-height:1.78;">I am reaching out from NiubiStar, a developer marketin=
g service for open-source, AI, DevTools, SaaS, and infrastructure projects.</p=
>=0A<p style=3D"margin:0 0 16px;color:#111827;font-size:15px;line-height:1.78;=
">Many strong technical projects do not need a long agency pitch. They need a =
clear launch message, the right developer-facing channels, and a simple delive=
ry record that shows what was actually published or sent.</p>=0A<p style=3D"ma=
rgin:0 0 16px;color:#111827;font-size:15px;line-height:1.78;">What we can help=
 with:</p>=0A<p style=3D"margin:0 0 16px;color:#111827;font-size:15px;line-hei=
ght:1.78;">Launch positioning and campaign brief<br>English project article or=
 placement planning<br>Relevant developer, startup, SaaS, or technical communi=
ty distribution<br>Developer outreach execution with opt-out handling<br>Deliv=
ery report with public URLs, campaign notes, and observable replies where avai=
lable</p>=0A<p style=3D"margin:0 0 16px;color:#111827;font-size:15px;line-heig=
ht:1.78;">We do not need your GitHub account, password, token, repository perm=
ission, or private customer data. A public project link and a target timeline =
are enough to scope whether the campaign is useful.</p>=0A<p style=3D"margin:0=
 0 16px;color:#111827;font-size:15px;line-height:1.78;">If you are preparing a=
 release, launch post, directory push, or developer-facing update, you can rev=
iew NiubiStar here:</p>=0A<p style=3D"margin:0 0 16px;color:#111827;font-size:=
15px;line-height:1.78;">https://www.niubistar.com/</p>=0A<p style=3D"margin:0 =
0 16px;color:#111827;font-size:15px;line-height:1.78;">If this is relevant, re=
ply with your project link and launch window. We can suggest a practical plan =
before any payment or commitment.</p>=0A<p style=3D"margin:0 0 16px;color:#111=
827;font-size:15px;line-height:1.78;">If this is not relevant, reply &quot;sto=
p&quot; and we will remove this address from future outreach.</p>=0A<p style=3D=
"margin:0 0 16px;color:#111827;font-size:15px;line-height:1.78;">Best regards,=
<br>NiubiStar Support Team</p></div><div style=3D"margin:24px 0 8px;"><a href=3D=
"https://www.niubistar.com/" target=3D"_blank" rel=3D"noopener noreferrer" sty=
le=3D"display:inline-block;background:#0f172a;color:#ffffff;padding:13px 18px;=
border-radius:10px;font-size:15px;font-weight:800;text-decoration:none;">Revie=
w NiubiStar</a></div><div style=3D"margin-top:24px;padding-top:18px;border-top=
:1px solid #e2e8f0;"><p style=3D"margin:0 0 10px;color:#64748b;font-size:13px;=
line-height:1.7;">NiubiStar respects email preferences. Reply "stop" or use th=
e unsubscribe link to be removed from future outreach.</p><a href=3D"https://w=
ww.niubistar.com/unsubscribe?email=3Dlinux-erofs%40lists.ozlabs.org&amp;token=3D=
outreach" target=3D"_blank" rel=3D"noopener noreferrer" style=3D"color:#64748b=
;font-size:13px;text-decoration:underline;">Unsubscribe</a></div></td></tr></t=
able></td></tr></table><div style=3D"margin-top:28px;padding-top:16px;border-t=
op:1px solid #e5e7eb;"><p style=3D"margin:0 0 8px;color:#667085;font-size:14px=
;">You are receiving this email because you subscribed to updates from market.=
</p><p style=3D"margin:0;color:#667085;font-size:14px;">If you no longer want =
to receive these emails, <a href=3D"https://www.niubistar.com/unsubscribe?emai=
l=3Dlinux-erofs%40lists.ozlabs.org&token=3Doutreach" style=3D"color:#2563eb;te=
xt-decoration:underline;">unsubscribe here</a>.</p></div></body></html>
------=ALIBOUNDARY_2345_7f770bc76700_6a866e13_a100--


