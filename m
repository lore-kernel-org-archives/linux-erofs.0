Return-Path: <linux-erofs+bounces-3992-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F03ABC531CA
	for <linux-erofs@archiver.kernel.org>; Thu, 23 Jul 2026 11:33:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h5TWz6qlLz2yVZ;
	Thu, 23 Jul 2026 21:33:19 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.21.131
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784806399;
	cv=none; b=Qmri0wiLrWXIKlKAST6wLlq6HPLpa2NOEBPSCeir5ZEY43YzaX4+NNsQZ5sHSx9l1MetdWwSNwDfwIeDIBZLrzXCIcQVq3TloxNboL05IknqSQHHiCz/7f9pQ1gxCV6cH7BoVZSTkGg2WbH/5/H4jireQO7jwtOisonL+odnhvlWKTTvz65SeVERKSABGaTdSEiYZ5lzSds8Lu/KXMrAzzd+XmpvyBCAQxA47PNrI651BbBUL0OUJpQ85ydRJZXBDFVWMJziVLH4qxHA2Aw1qLxp+q9L6rU2L1pHZPLfmqhJEUNh4iLPiQd8cdfY2fP2XHbSP+UNn1n/V6sFgznxBg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784806399; c=relaxed/relaxed;
	bh=1pDO9nZSQ3Xwz/CyhK1GZmp6pG1BGPMNAAmhlJBNLEI=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type; b=eSB2DCJ4ej6SkEfFplkP7tQxC0qEpz2u6cEgo8nB/pluUEqzOtxgo9IeEzLZJ4rkS/Qd2qKPGDk9W+X/BiN2lFRcaeEqPXvPk4ABKC/AK0g8yPqEwmD8tNiZ86AYFqi8TQRqvBx4FOZy9pVPW13OpXn/WYaj1tQzXKvJdBbf+cqz0CIIAcPI9cppMGYJ5Zq2RFnNMVu3vzKSvi5cACCFzOA304btN0wGnTwVTxaCnyeT4at6dni2Zxj1mSEvItXQrPORS6nioVTIhmSWfzWST3g1DrqipOzARLhOEm8ZFtjd1epxje4J6ybcyYPIK52gmpoX0qMOtBoraDmNCfJyxg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=mcpcnserver.com; dkim=pass (1024-bit key; unprotected) header.d=mcpcnserver.com header.i=@mcpcnserver.com header.a=rsa-sha256 header.s=aliyun-cn-hangzhou57fb2d3494 header.b=KUOfVZW/; dkim=pass (1024-bit key; unprotected) header.d=dm-fbl.aliyuncs.com header.i=@dm-fbl.aliyuncs.com header.a=rsa-sha256 header.s=feedback header.b=C8yMiso8; dkim-atps=neutral; spf=pass (client-ip=115.124.21.131; helo=out21-131.dm.aliyun.com; envelope-from=market@mcpcnserver.com; receiver=lists.ozlabs.org) smtp.mailfrom=mcpcnserver.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=mcpcnserver.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=mcpcnserver.com header.i=@mcpcnserver.com header.a=rsa-sha256 header.s=aliyun-cn-hangzhou57fb2d3494 header.b=KUOfVZW/;
	dkim=pass (1024-bit key; unprotected) header.d=dm-fbl.aliyuncs.com header.i=@dm-fbl.aliyuncs.com header.a=rsa-sha256 header.s=feedback header.b=C8yMiso8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=mcpcnserver.com (client-ip=115.124.21.131; helo=out21-131.dm.aliyun.com; envelope-from=market@mcpcnserver.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 336 seconds by postgrey-1.37 at boromir; Thu, 23 Jul 2026 21:33:17 AEST
Received: from out21-131.dm.aliyun.com (out21-131.dm.aliyun.com [115.124.21.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h5TWx359sz2xyj
	for <linux-erofs@lists.ozlabs.org>; Thu, 23 Jul 2026 21:33:16 +1000 (AEST)
X-AliDM-RcptTo: bGludXgtZXJvZnNAbGlzdHMub3psYWJzLm9yZw==
Feedback-ID: default:market@mcpcnserver.com:alibabak_ApiBatch:448107
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mcpcnserver.com; s=aliyun-cn-hangzhou57fb2d3494;
	t=1784806394; h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type;
	bh=1pDO9nZSQ3Xwz/CyhK1GZmp6pG1BGPMNAAmhlJBNLEI=;
	b=KUOfVZW/EfmAWQuiupjcaslROQJeUKDgRbkfa06AmH8SPZVm9J63yOio+gi7gwZqyqsE1dHPBWFqeIUWQF9Swiwl86X82fK+qJzguVffoTzss4qmqbg7UZTD0efOYFBM8PQDKH3N7fo9AmVgctKDDJj/S5tTqlPx0v3ZCA2j3Xo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dm-fbl.aliyuncs.com; s=feedback;
	t=1784806394; h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type;
	bh=1pDO9nZSQ3Xwz/CyhK1GZmp6pG1BGPMNAAmhlJBNLEI=;
	b=C8yMiso8LGPylKInYtnI0f4/OXj9sJLE2lq6LQdNxEbsZcVnDn1mpNaQOOkhAlsD5HhFvZslBUWHeGxiGB1xa43dVhTxLPEedL8FGOqC5R7gT+98j374EdyvWKbbArhDLgNoaFXTtOmdNnsDg7Gh5S9HuYGkXQjFcUyn2pN8OuM=
Received: from chitu-hsf(mailfrom:market@mcpcnserver.com fp:ma_600000336733642987 cluster:AY35D)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 23 Jul 2026 19:27:33 +0800
Date: Thu, 23 Jul 2026 19:27:33 +0800
From: "NiubiStar Support Team" <market@mcpcnserver.com>
To:  <linux-erofs@lists.ozlabs.org>
Reply-To:  <feitechen@gmail.com>
Message-ID: <094eb286-c70c-41b7-b550-d3fa3b8291ff@alibaba.com>
Subject: =?UTF-8?B?RW50ZXJwcmlzZSBvdXRyZWFjaCBpZGVhIGZvciBnby1lcm9mcw==?=
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
X-EnvId: 600000336733642988
X-AliDM-Settings: eyJPdXRib3VuZElwIjp7IklwTGlzdCI6W10sIklwUG9vbElkIjoiIn0sIlVuc3Vic2NyaWJlIjp7IkZpbHRlckxldmVsIjoiZGVmYXVsdCIsIkxpbmtUeXBlIjoiZGlzYWJsZWQifSwiVmVyc2lvbiI6IjEuMCJ9
Content-Type: multipart/alternative;
  boundary="----=ALIBOUNDARY_2345_7ff6ae56e700_6a61fbfa_532d8"

------=ALIBOUNDARY_2345_7ff6ae56e700_6a61fbfa_532d8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linux Erofs,=0A=0AI found erofs/go-erofs while looking through GitHub proje=
cts that have already attracted stargazer attention. I noticed it is mainly Go=
.=0A=0AIf you are planning a release, launch post, directory push, or enterpri=
se-facing update, NiubiStar can help package the project into a broader develo=
per outreach campaign.=0A=0AFor early repos, the goal is usually to create cre=
dible discovery paths beyond the repository page itself.=0A=0AThe package I wo=
uld recommend is Enterprise Outreach. It is built for teams that want more tha=
n a simple GitHub signal boost: targeted developer discovery, launch proof, re=
levant community placement, and hands-on execution around a specific growth wi=
ndow.=0A=0AYou can review it here:=0Ahttps://www.niubistar.com/enterprise-outr=
each?utm_source=3Dmarket=0A=0ANo GitHub token is required. A public repository=
 link and a target timeline are enough to scope the campaign.=0A=0AIf this is =
relevant, reply with your launch window and the audience you want to reach. I =
can suggest a practical outreach plan before you place anything.=0A=0ABest,=0A=
NiubiStar Support Team=0Ahttps://www.niubistar.com
------=ALIBOUNDARY_2345_7ff6ae56e700_6a61fbfa_532d8
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<!doctype html>=0A<html>=0A  <body style=3D"margin:0;background:#f7f8fb;font-f=
amily:-apple-system,BlinkMacSystemFont,'Segoe UI',Arial,sans-serif;color:#1118=
27;">=0A    <div style=3D"max-width:720px;margin:0 auto;padding:28px 18px;">=0A=
      <div style=3D"background:#ffffff;border:1px solid #e5e7eb;border-radius:=
10px;padding:28px;line-height:1.58;font-size:15px;">=0A        <p>Hi Linux Ero=
fs,</p>=0A<p>I found erofs/go-erofs while looking through GitHub projects that=
 have already attracted stargazer attention. I noticed it is mainly Go.</p>=0A=
<p>If you are planning a release, launch post, directory push, or enterprise-f=
acing update, NiubiStar can help package the project into a broader developer =
outreach campaign.</p>=0A<p>For early repos, the goal is usually to create cre=
dible discovery paths beyond the repository page itself.</p>=0A<p>The package =
I would recommend is Enterprise Outreach. It is built for teams that want more=
 than a simple GitHub signal boost: targeted developer discovery, launch proof=
, relevant community placement, and hands-on execution around a specific growt=
h window.</p>=0A<p>You can review it here:<br>https://www.niubistar.com/enterp=
rise-outreach?utm_source=3Dmarket</p>=0A<p>No GitHub token is required. A publ=
ic repository link and a target timeline are enough to scope the campaign.</p>=
=0A<p>If this is relevant, reply with your launch window and the audience you =
want to reach. I can suggest a practical outreach plan before you place anythi=
ng.</p>=0A<p>Best,<br>NiubiStar Support Team<br>https://www.niubistar.com</p>=0A=
      </div>=0A    </div>=0A  </body>=0A</html>
------=ALIBOUNDARY_2345_7ff6ae56e700_6a61fbfa_532d8--


