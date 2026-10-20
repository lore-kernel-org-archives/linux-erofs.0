Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CF2606A319
	for <linux-erofs@archiver.kernel.org>; Tue, 20 Oct 2026 04:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mcpcnserver.com header.i=@mcpcnserver.com header.a=rsa-sha256 header.s=aliyun-cn-hangzhou57fb2d3494 header.b=abyCydkF;
	dkim=pass (1024-bit key, unprotected) header.d=dm-fbl.aliyuncs.com header.i=@dm-fbl.aliyuncs.com header.a=rsa-sha256 header.s=feedback header.b=H7ku2zWF
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j80CJ6tZGz2yjp;
	Tue, 20 Oct 2026 15:42:52 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.21.138
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792471372;
	cv=none; b=jRizsWIGpB9SvGGZ6Q3dyXC95Kl02s7hqlajpPnwpcGy4fccRInYuU80xgdJS0PlXeEyy7xoz6qq6aT2SBtQqvMp8+vGljnJnOJwawKPb0EP5iFQ8prKMqfU9GMcLGPvWFR+nWTaDvYlSgrJtVxPPSOKNDWjTSYTVf91KoBsVqpVYaNwfZZNh85n5sy4gOIIvOm++5aAEzpQQNWett7YhKNxxij0WLGPl80YGiMKDmrxLSUJYx89iS89tmgtdH4a3XKTMxpE93BcDJtTQAOECoP4Xxh4spvkGUbcw9dJ9fHrCa/sbQL8imlBf6WxmvmppYg/ZOIA+WITe8nyWJ+qPA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792471372; c=relaxed/relaxed;
	bh=7H6DtuIKe+F44KMLg3l4jB1qVdeDIXv+pzWFDg0EhL4=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type; b=VGh3Ol+FUM47aGe1ZBhQqNTuhwyomugTdgujfA/mHGPUJ4IV6y+dIi1A1Ua0DMwU+Qypd81DvbfREfu7eT38X12v6GqdnN57MyGce2/D/k87IQZYnqXJFmNx164hYOsTgScSwN9bdF8Z63h/U8KWBTz2K/vk3k5nFzBtIlZ0OrDhMyAZN9+DIk5kLHsMfn0Ip93hrUwO61gF88lm8P8BUtCaeCNPdENawzvFqAL6UrrHNR5dq10VagEnlfy3yPpnjTW3e2Sdqig1SrcWcTHC+wa4Y7UZiUyV9dFt9HvS8X5yIfRfJyXBKhWXOEtdwX5qmCEOcekZ4X6eaUDn+snTzA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=mcpcnserver.com; dkim=pass (1024-bit key; unprotected) header.d=mcpcnserver.com header.i=@mcpcnserver.com header.a=rsa-sha256 header.s=aliyun-cn-hangzhou57fb2d3494 header.b=abyCydkF; dkim=pass (1024-bit key; unprotected) header.d=dm-fbl.aliyuncs.com header.i=@dm-fbl.aliyuncs.com header.a=rsa-sha256 header.s=feedback header.b=H7ku2zWF; dkim-atps=neutral; spf=pass (client-ip=115.124.21.138; helo=out21-138.dm.aliyun.com; envelope-from=market@mcpcnserver.com; receiver=lists.ozlabs.org) smtp.mailfrom=mcpcnserver.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=mcpcnserver.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=mcpcnserver.com header.i=@mcpcnserver.com header.a=rsa-sha256 header.s=aliyun-cn-hangzhou57fb2d3494 header.b=abyCydkF;
	dkim=pass (1024-bit key; unprotected) header.d=dm-fbl.aliyuncs.com header.i=@dm-fbl.aliyuncs.com header.a=rsa-sha256 header.s=feedback header.b=H7ku2zWF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=mcpcnserver.com (client-ip=115.124.21.138; helo=out21-138.dm.aliyun.com; envelope-from=market@mcpcnserver.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 339 seconds by postgrey-1.37 at boromir; Tue, 20 Oct 2026 15:42:49 AEDT
Received: from out21-138.dm.aliyun.com (out21-138.dm.aliyun.com [115.124.21.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j80CF5fCGz2xwd
	for <linux-erofs@lists.ozlabs.org>; Tue, 20 Oct 2026 15:42:48 +1100 (AEDT)
X-AliDM-RcptTo: bGludXgtZXJvZnNAbGlzdHMub3psYWJzLm9yZw==
Feedback-ID: default:market@mcpcnserver.com:alibabak_ApiBatch:448107
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mcpcnserver.com; s=aliyun-cn-hangzhou57fb2d3494;
	t=1792471366; h=Date:From:To:Message-ID:Subject:MIME-Version:List-Unsubscribe:Content-Type;
	bh=7H6DtuIKe+F44KMLg3l4jB1qVdeDIXv+pzWFDg0EhL4=;
	b=abyCydkFVrTVkIU2TqLND2F1ew0+d6kW5YB82IkfyPuBlXa3uJqQhMV/FkzpHXObB4CAf5tTJvDSaxon2rgNap+xfpucXWeG2AQiqsYOKFfX0r869cQzUKguCP6i8ozzfICTQ9ozB2ZwusSe1FAljFdE7yunNctRkN+CpRGI5T4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dm-fbl.aliyuncs.com; s=feedback;
	t=1792471366; h=Date:From:To:Message-ID:Subject:MIME-Version:List-Unsubscribe:Content-Type;
	bh=7H6DtuIKe+F44KMLg3l4jB1qVdeDIXv+pzWFDg0EhL4=;
	b=H7ku2zWFNG+B+RYUA9l0BFeI07dUpkILJahWQbh6xO0G6GULF1HAyxgVYIHCVTvFs+zhlrXL6W9bKtXOwJld56KvMeoeBDPWA2Vf8PkTPb24JcxVXeMul7Xm2KdhBAo0YVVEy7Lew0wtSwLJzJNzw6W4XWY2AUdJyvCe1GL+1/4=
Received: from chitu-hsf(mailfrom:market@mcpcnserver.com fp:ma_600000362840823505 cluster:AY35D)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 20 Oct 2026 12:37:00 +0800
Date: Tue, 20 Oct 2026 12:37:00 +0800
From: "NiubiGEO" <market@mcpcnserver.com>
To:  <linux-erofs@lists.ozlabs.org>
Reply-To:  <3673409676@qq.com>
Message-ID: <niubigeo.6c696e75782d65726f6673406c697374732e6f7a6c616273@mcpcnserver.com>
Subject: =?UTF-8?B?SG93IGRvZXMgQUkgZGVzY3JpYmUgeW91ciBwcm9kdWN0Pw==?=
X-Priority: 3
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
X-EnvId: 600000362840823506
X-AliDM-Settings: eyJPdXRib3VuZElwIjp7IklwTGlzdCI6W10sIklwUG9vbElkIjoiIn0sIlVuc3Vic2NyaWJlIjp7IkZpbHRlckxldmVsIjoiZGlzYWJsZWQiLCJMaW5rVHlwZSI6ImRpc2FibGVkIn0sIlZlcnNpb24iOiIxLjAifQ==
Content-Type: multipart/alternative;
  boundary="----=ALIBOUNDARY_2345_7f445624d700_6ad6f146_7666b"
X-Spam-Status: No, score=0.7 required=3.0 tests=BAYES_50,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_REPLYTO_END_DIGIT,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MIME_QP_LONG_LINE,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

------=ALIBOUNDARY_2345_7f445624d700_6ad6f146_7666b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,=0A=0AWe=E2=80=99re building NiubiGEO, an open-source tool for checking how=
 AI describes your product, which competitors appear in its answers, and what =
sources it cites.=0A=0AThe idea is simple: you should be able to inspect the a=
nswers and evidence behind an AI visibility assessment=E2=80=94not just receiv=
e a score.=0A=0AGitHub: https://github.com/Albert-Weasker/niubigeo (8,383 star=
s at send time)=0A=0AIf you=E2=80=99d prefer to have us handle the work, our o=
fficial platform is https://niubigeo.ai/=0A=0AYou can add your product and rec=
eive a free GEO improvement plan outlining suggested work, deliverables, prici=
ng, and timing. A complete AI diagnosis is available separately for CNY 99, co=
vering how AI understands your product, competitors, sources, strengths, gaps,=
 and recommended improvements.=0A=0AReply with your website or GitHub link, an=
d tell us who your customers are. We=E2=80=99ll help you identify a useful sta=
rting point.=0A=0ABest,=0ANiubiGEO Team=0Asupport@niubigeo.ai=0A=0AEmail prefe=
rences / Unsubscribe:=0Ahttps://niubigeo.ai/unsubscribe?token=3Dv1.piP-yPvRWQx=
44qBz.-0O9awdqSZqCy6EX3ywmedz-xzpd9SGd72NWfQWGXSiP5yY8v6pf5p-VzWjyECilQedYof9e=
j_q-u-StTlPKGs7fON0g8c07Zl8Cqxn0cmq9mML7VNB9zvCQP0m6U_xcvZY85b6lPKE-CMjX-6EUeN=
gz8A28ot_N_EpbTHXsAEInOWu8fH0wRSEMzwXmT7y0RhODy5BUFg.XXRtx0ehWI0JjSsxC2vzRA
------=ALIBOUNDARY_2345_7f445624d700_6ad6f146_7666b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<!doctype html><html lang=3D"en"><head><meta charset=3D"utf-8"><meta name=3D"v=
iewport" content=3D"width=3Ddevice-width,initial-scale=3D1"></head><body style=
=3D"margin:0;padding:0;background:#f4f4f6;font-family:Arial,Helvetica,sans-ser=
if;color:#24232a"><table role=3D"presentation" width=3D"100%" cellspacing=3D"0=
" cellpadding=3D"0" border=3D"0" style=3D"background:#f4f4f6"><tr><td align=3D=
"center" style=3D"padding:28px 14px"><table role=3D"presentation" width=3D"100=
%" cellspacing=3D"0" cellpadding=3D"0" border=3D"0" style=3D"max-width:680px;b=
ackground:#ffffff;border:1px solid #e5e3e9"><tr><td style=3D"padding:24px 30px=
;background:#0b0b12"><table role=3D"presentation" width=3D"100%" cellspacing=3D=
"0" cellpadding=3D"0" border=3D"0"><tr><td valign=3D"middle"><table role=3D"pr=
esentation" cellspacing=3D"0" cellpadding=3D"0" border=3D"0"><tr><td><img src=3D=
"https://niubigeo.ai/assets/brand/favicon-96.png" width=3D"46" height=3D"46" a=
lt=3D"NiubiGEO" style=3D"display:block;width:46px;height:46px;border:0;border-=
radius:8px"></td><td style=3D"padding-left:12px;color:#ffffff;font-size:22px;f=
ont-weight:700">NiubiGEO</td></tr></table></td><td align=3D"right"><a href=3D"=
https://dm-cn.aliyuncs.com/trace/v1/report?bid=3D20261020&env=3D60000036284082=
3506&extra=3D1-&mac=3D448107&mf=3Dmarket%40mcpcnserver.com&msgid=3Dniubigeo.6c=
696e75782d65726f6673406c697374732e6f7a6c616273%40mcpcnserver.com&sac=3D0&tag=3D=
API&tid=3Dtask20261020&to=3Dlinux-erofs%40lists.ozlabs.org&tpl=3D&ts=3D1792471=
020&type=3D0&url=3Dhttps%3A%2F%2Fgithub.com%2FAlbert-Weasker%2Fniubigeo&v=3D1.=
0&sign=3D31c3d5e5b45b2c558f68e201cfcc6b2d&urlts=3D1792471366" style=3D"text-de=
coration:none"><table role=3D"presentation" cellspacing=3D"0" cellpadding=3D"0=
" border=3D"0" style=3D"border:1px solid #5b5573;border-radius:24px;background=
:#11111a"><tr><td style=3D"padding:9px 10px 9px 14px"><img src=3D"https://niub=
igeo.ai/assets/platforms/github.svg" width=3D"22" height=3D"22" alt=3D"GitHub"=
 style=3D"display:block;width:22px;height:22px;border:0"></td><td style=3D"pad=
ding:9px 10px 9px 0;color:#ffffff;font-size:15px;font-weight:600;white-space:n=
owrap">GitHub</td><td style=3D"padding:9px 14px 9px 10px;color:#d9cdfc;font-si=
ze:15px;white-space:nowrap">=E2=98=86 8,383</td></tr></table></a></td></tr></t=
able></td></tr><tr><td style=3D"padding:32px 30px 28px"><p style=3D"margin:0 0=
 18px;font-size:16px;line-height:1.7">Hi,</p><p style=3D"margin:0 0 18px;font-=
size:16px;line-height:1.7">We=E2=80=99re building <strong>NiubiGEO</strong>, a=
n open-source tool for checking how AI describes your product, which competito=
rs appear in its answers, and what sources it cites.</p><p style=3D"margin:0 0=
 18px;font-size:16px;line-height:1.7">The idea is simple: you should be able t=
o inspect the answers and evidence behind an AI visibility assessment=E2=80=94=
not just receive a score.</p><table role=3D"presentation" cellspacing=3D"0" ce=
llpadding=3D"0" border=3D"0" style=3D"margin:22px 0"><tr><td style=3D"backgrou=
nd:#15131e;border-radius:6px"><a href=3D"https://dm-cn.aliyuncs.com/trace/v1/r=
eport?bid=3D20261020&env=3D600000362840823506&extra=3D1-&mac=3D448107&mf=3Dmar=
ket%40mcpcnserver.com&msgid=3Dniubigeo.6c696e75782d65726f6673406c697374732e6f7=
a6c616273%40mcpcnserver.com&sac=3D0&tag=3DAPI&tid=3Dtask20261020&to=3Dlinux-er=
ofs%40lists.ozlabs.org&tpl=3D&ts=3D1792471020&type=3D0&url=3Dhttps%3A%2F%2Fgit=
hub.com%2FAlbert-Weasker%2Fniubigeo&v=3D1.0&sign=3D31c3d5e5b45b2c558f68e201cfc=
c6b2d&urlts=3D1792471366" style=3D"display:inline-block;padding:12px 18px;colo=
r:#ffffff;text-decoration:none;font-size:15px;font-weight:700">Explore NiubiGE=
O on GitHub&nbsp;&nbsp;=E2=98=86 8,383</a></td></tr></table><p style=3D"margin=
:0 0 18px;font-size:16px;line-height:1.7">If you=E2=80=99d prefer to have us h=
andle the work, our official platform is <a href=3D"https://dm-cn.aliyuncs.com=
/trace/v1/report?bid=3D20261020&env=3D600000362840823506&extra=3D1-&mac=3D4481=
07&mf=3Dmarket%40mcpcnserver.com&msgid=3Dniubigeo.6c696e75782d65726f6673406c69=
7374732e6f7a6c616273%40mcpcnserver.com&sac=3D0&tag=3DAPI&tid=3Dtask20261020&to=
=3Dlinux-erofs%40lists.ozlabs.org&tpl=3D&ts=3D1792471020&type=3D0&url=3Dhttps%=
3A%2F%2Fniubigeo.ai%2F&v=3D1.0&sign=3Dc25caa27199bf9b3dd8bb771756e76fb&urlts=3D=
1792471366" style=3D"color:#6e4adf">niubigeo.ai</a>.</p><p style=3D"margin:0 0=
 18px;font-size:16px;line-height:1.7">You can add your product and receive a <=
strong>free GEO improvement plan</strong> outlining suggested work, deliverabl=
es, pricing, and timing. A complete AI diagnosis is available separately for <=
strong>CNY 99</strong>, covering how AI understands your product, competitors,=
 sources, strengths, gaps, and recommended improvements.</p><p style=3D"margin=
:0 0 22px;font-size:16px;line-height:1.7"><strong>Reply with your website or G=
itHub link, and tell us who your customers are. We=E2=80=99ll help you identif=
y a useful starting point.</strong></p><p style=3D"margin:0;font-size:16px;lin=
e-height:1.7">Best,<br>NiubiGEO Team<br><a href=3D"mailto:support@niubigeo.ai"=
 style=3D"color:#6e4adf">support@niubigeo.ai</a></p></td></tr><tr><td style=3D=
"padding:18px 30px;border-top:1px solid #ebe9ef;color:#77727f;font-size:12px;l=
ine-height:1.6"><a href=3D"https://dm-cn.aliyuncs.com/trace/v1/report?bid=3D20=
261020&env=3D600000362840823506&extra=3D1-&mac=3D448107&mf=3Dmarket%40mcpcnser=
ver.com&msgid=3Dniubigeo.6c696e75782d65726f6673406c697374732e6f7a6c616273%40mc=
pcnserver.com&sac=3D0&tag=3DAPI&tid=3Dtask20261020&to=3Dlinux-erofs%40lists.oz=
labs.org&tpl=3D&ts=3D1792471020&type=3D0&url=3Dhttps%3A%2F%2Fniubigeo.ai%2Funs=
ubscribe%3Ftoken%3Dv1.piP-yPvRWQx44qBz.-0O9awdqSZqCy6EX3ywmedz-xzpd9SGd72NWfQW=
GXSiP5yY8v6pf5p-VzWjyECilQedYof9ej_q-u-StTlPKGs7fON0g8c07Zl8Cqxn0cmq9mML7VNB9z=
vCQP0m6U_xcvZY85b6lPKE-CMjX-6EUeNgz8A28ot_N_EpbTHXsAEInOWu8fH0wRSEMzwXmT7y0RhO=
Dy5BUFg.XXRtx0ehWI0JjSsxC2vzRA&v=3D1.0&sign=3D6b8ea8be581d225c9ef4ff11d617e491=
&urlts=3D1792471366" style=3D"color:#77727f;text-decoration:underline">Email p=
references / Unsubscribe</a><br>GitHub star count: 8,383 at the time this emai=
l was sent.</td></tr></table></td></tr></table><img src=3D"https://dm-cn.aliyu=
ncs.com/trace/v1/report?bid=3D20261020&env=3D600000362840823506&mac=3D448107&m=
f=3Dmarket%40mcpcnserver.com&msgid=3Dniubigeo.6c696e75782d65726f6673406c697374=
732e6f7a6c616273%40mcpcnserver.com&sac=3D0&tag=3DAPI&tid=3Dtask20261020&to=3Dl=
inux-erofs%40lists.ozlabs.org&tpl=3D&ts=3D1792471020&type=3D1&url=3D&v=3D1.0&s=
ign=3D023c5cc979406da182a3c7eb242a523d&urlts=3D1792471366" alt=3D"" style=3D"d=
isplay: none; width: 1px; height: 1px;" /></body></html>
------=ALIBOUNDARY_2345_7f445624d700_6ad6f146_7666b--


