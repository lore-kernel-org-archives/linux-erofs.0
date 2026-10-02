Return-Path: <linux-erofs+bounces-4648-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB4CBCA5FDD
	for <linux-erofs@archiver.kernel.org>; Fri,  2 Oct 2026 16:41:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hxF0r6lPDz30Nl;
	Sat, 03 Oct 2026 02:41:32 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=202.12.124.152
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790959292;
	cv=none; b=BICU0N9LhhBF2Npp6pmstDPoaEQo3gkJr5MsVSAWKKm79FDem45fovWmym9A179dKlQV4FLCjdyMEWQUOKqqY/dYx+lbHz3nad01oQJA3sACA9wD/fkbipd2TjAlaxWOJ5WW7fkHc/qd4bsKfhH1nyuKCssgWkl7mTRMSX1phANHBLUWF8V9Qq/vJiXroFZsEQGp2NWQVQGbZ7F50IMudnowrY6jGaMX8zQTGEgdds4fhlNB/+RcjJLOsB/yz3s5+YPhn3I9hbQw4saTARA9e4IMTB5FVVLbvObcrEVBk2x99dazwdz2n8y7bGHsp2AM/8+PfER0+MZ17a51t7y2bg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790959292; c=relaxed/relaxed;
	bh=ZVkG8X3Ft+8Z13bThLvYD/PHchlJ5DMHw6Ao0sJXrj4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a/ZwSNmaoddFKIOFShf99qR+t9JWis77mmwkQD7NJtAhiLcFSv+QwaoODvaoFyFUfLdco/kprlX21+3lYnaKv93wTfkK+jVUU/vNENH7pdy3guHsfEATaBnMAUQmxHHt5KHLPANNnRHsGlvdDzvl2TZnY54s1a8AhvJXMfbpzU7kngfM0qT9B13HD14oD+AH35zePAsyqYJr4xHVMvvsUcR03dgg9xKHmAIyGNwuoBh6SJenX7i3aaJTLu6Ww4aoCv5jEWeN0dUqPP0/jXpR8j6VkvQJfj3Qai3+9C9LpIojOJX9glSkXji4il/ZVU41xLujPVwtbtvo794BKZeVRg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=scrivano.org; dkim=pass (2048-bit key; unprotected) header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm2 header.b=JBdKOjuY; dkim=pass (2048-bit key; unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm1 header.b=hBYFDEJG; dkim-atps=neutral; spf=pass (client-ip=202.12.124.152; helo=fhigh-b1-smtp.messagingengine.com; envelope-from=giuseppe@scrivano.org; receiver=lists.ozlabs.org) smtp.mailfrom=scrivano.org
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=scrivano.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm2 header.b=JBdKOjuY;
	dkim=pass (2048-bit key; unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm1 header.b=hBYFDEJG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=scrivano.org (client-ip=202.12.124.152; helo=fhigh-b1-smtp.messagingengine.com; envelope-from=giuseppe@scrivano.org; receiver=lists.ozlabs.org)
X-Greylist: delayed 527 seconds by postgrey-1.37 at boromir; Sat, 03 Oct 2026 02:41:30 AEST
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hxF0p3kHfz30NF
	for <linux-erofs@lists.ozlabs.org>; Sat, 03 Oct 2026 02:41:30 +1000 (AEST)
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id D29EA7A0048
	for <linux-erofs@lists.ozlabs.org>; Fri,  2 Oct 2026 12:32:39 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 02 Oct 2026 12:32:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scrivano.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1790958759; x=1791045159; bh=ZVkG8X3Ft+8Z13bThLvYD
	/PHchlJ5DMHw6Ao0sJXrj4=; b=JBdKOjuYVXKZpkNgJPtalXwLjMh3a8B3V6fRp
	Duog7+gVl+Py8dr0Gb0hsjqv6y8bvlQq96ZCL9OW69DcxnGB0jkysPmmI9/voc/q
	nono1MWbnIWYt90fkCy1Wm9ZuJEmUScwDhsFZmxHApxf7OBvNM9x9196YAU9fntk
	91QapeF3ULRuSiVB/06PIUaE0kW2aa07OdDyhXKMYskeZ9NkGsqcEekq3peNQQFA
	o5mqLxcMHS2xE7dZnu/PY0Nt4+77HCX5Hh+Gj+RKSIEAsVoP9RuZxRPW2jHTe1rU
	ot649/5zHuklGh1ISX05kKea8GcIj9x/rGMhy08pYp1GGV4aQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790958759; x=1791045159; bh=ZVkG8X3Ft+8Z13bThLvYD/PHchlJ5DMHw6A
	o0sJXrj4=; b=hBYFDEJGIdtgrZw7fK1cRmsyZmCa1di9IYfUmNmBqXmmtx/KDfc
	cEBC20tpFx0nvG726HTFRfEwG5eCCCW3h1sBD9WDDqHG4Y0Z1pmxUplZR2GV0nxf
	kLbGxgiuAvuLM3t2sx7hREa8y+tLOVIKrY3VzwohZKPZiQT0u7AEwXzqRN+/7u3Z
	KytIJSTslci8hnDpr4bGzX+Q3AgoWqY7d/6p2vCUTzB+MPGmZs14aLPVopDCMBQ9
	OUaeWXS5uYhaPkvbJdwVHWRZd4yMkMEcPzeFbAMijWdwfqSjBnmPwNo/EQWn2eAp
	fGAffVJhkHB4AhGgP+P4q21uLf/ftoVFY/A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=scrivano.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1790958759; d=scrivano.org;
	mf=PGdpdXNlcHBlQHNjcml2YW5vLm9yZz4=;
	rt=PGxpbnV4LWVyb2ZzQGxpc3RzLm96bGFicy5vcmc+;
	s=fm2:rsa-sha256:DLYpn61kjPVY+k8Jez8jtQoRUfIhEuEk/QIpl774oSS758n
	bJcBXhtPwlodzSoFrpxukcg8+jgxhpln5VONTHNUXggHzk25xrgtMcBES9K6kXtV
	zIAlAkSr9hMje0hr6mbTkCkZuC7iHuBV28UCWep8XpyT5IOUxQ5a1R8f608JyPAs
	JHOHTV+0hJFL6JLEcGqTw+O91E+HrW7xH07WQJdHr4uetZM+qWJxP2pk98U79EWS
	Sad0Enp8RUsbWveHUpun7rLXciNjvuG1bQHLcWEjmUS2YhEadFaZzA2Zb80WXbK4
	J19xOIZC0vUUPmUoJqhbsZoYCwqAeesHoY4Q70A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:EZP4T+SYpf1ZeWef3Z4SHw8qBkoSMWXPk0bctk4PkVI=:2kLm8HLpx938594uBBELC7JX4wN26HXZRBAQ10ugVyw=;
X-ME-Sender: <xms:pty_al0WwfN2QyrJjsnagidGl3OiT0bvyduFX0eHGVa7ig0xR1rl2A>
    <xme:pty_aor61f4nzpe1tO1gNQJQG-KpD_k6-XZ4-7JZnIxB6g71dfSBO-Ttg6V_QQgp2
    QFO6F0yUj6UF5V15wS9JZaWNzm_C5Mq0f2S9QUQPA-lO4JEHffR8bZW>
X-ME-Received: <xmr:pty_aqXhEddA1PqPIGj997zc_3XRtY3_slarh_NeXPZjhhqUMATkgRuVixc49mLrZ11p3CCnf1cst6ljXVcYTEhXQ-el>
X-ME-Proxy-Cause: dmFkZTGVHbrwo2qLeP7y6YrbhRkYqNIT8CCeqa1xpcwKiQYh4HF7XUuHue2T67M/TaO7jT
    E2KBiMWoO64zcfJ0qRtgK11dIXbj+ZxK0fkVPSaJqIRXBHxqZXag7QDUN1vgTsbISXlz1i
    VYCWhpU+PVM/jwtE/xmC2+hhQ6OVRgkBjMWdLefZoOQilo49w2/XcRMZc1zrXSDFqjYcq6
    4Lq6Jbg3UDWJ3Cuh+V/aTVgNemP1R0rs6veMn9lW3kzBaIkUAtHz1aZa03RK917BrOJAWd
    GqRZIA9+5vWv6bjwxf6NJKrAB8hTt3rUjydMCJubtqZNIe+UhA1vcDiA55BMOyb5YxB9dZ
    QGz+ncLKtwkXdAhkWR2qiy2S9jA+tqsbhLdvT3TqdjgAAshlOgm19o0l4QDW8lIN9oEFWE
    Agqog4K9/oJ6Icm1Aup1Tm2pfez2/dZtSJE6XlMDFJIsa2ZJJW4EtM/TdKUw53OaGWSmdH
    QGF33FicYs8JJYaceUXDdjQDnytgb1lgKjhdex5cPCLRRKKiMaEUba2MkS8pqwSdfwZBdR
    jDFJomDq9akMq3i8UZW6oi4AVNtdd37mYPWkrKrslO2XkB390KO0nL54wws+kcqoAbK4DO
    dQVNSUBZx5KTsCJjIv0BpgbxIs1dfk3bXYf1i9WzW4//aQAMNywU8xICxmVQ
X-ME-Proxy: <xmx:pty_appS6O3CwBTiZhr-IUL3ZPEdwBvlYsGEtaa-mCNcXDfiN_Ck5A>
    <xmx:pty_apBfNxTA-bJKASqpmajELgHdxEDVBrhVHBWVshb4955zk5iD7A>
    <xmx:pty_atiHMS1KYmgKXACguEcXoquqVFMwbGue70jOzQe5VGj6D_Xh0Q>
    <xmx:pty_avZPA93-LtvIG8mEoMxqu515Fek9Pe2n_M93m-1c4mHfsfDg2g>
    <xmx:p9y_at7duLnf-yvbm1B6Pe_Rd1PCiqOa4qDnW4iq9ao1RH8X2qA6wte0>
Feedback-ID: i8e6e4897:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Oct 2026 12:32:38 -0400 (EDT)
From: Giuseppe Scrivano <giuseppe@scrivano.org>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	linux-fsdevel@vger.kernel.org,
	amir73il@gmail.com,
	giuseppe@scrivano.org,
	brauner@kernel.org,
	viro@zeniv.linux.org.uk,
	jack@suse.cz,
	hch@infradead.org
Subject: [PATCH v7 0/2] erofs: share the superblock for file-backed mounts
Date: Fri,  2 Oct 2026 18:31:42 +0200
Message-ID: <20261002163225.1258203-1-giuseppe@scrivano.org>
X-Mailer: git-send-email 2.55.0
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
Content-Transfer-Encoding: 8bit

v6: https://lore.kernel.org/linux-fsdevel/20260812142907.1010046-1-gscrivan@redhat.com/
v5: https://lore.kernel.org/linux-fsdevel/20260811071241.389589-1-gscrivan@redhat.com/
v4: https://lore.kernel.org/linux-fsdevel/20260804060455.2928514-1-gscrivan@redhat.com/
v3: https://lore.kernel.org/linux-fsdevel/20260801075446.2508805-1-gscrivan@redhat.com/
v2: https://lore.kernel.org/linux-fsdevel/20260731160901.2276832-1-gscrivan@redhat.com/
v1: https://lore.kernel.org/linux-fsdevel/20260730124120.1501126-1-gscrivan@redhat.com/

Giuseppe Scrivano (2):
  fs: rename vfs_get_super() to get_tree_super() and export it
  erofs: reuse superblock for file-backed mounts

 Documentation/filesystems/erofs.rst |  7 ++++
 fs/erofs/internal.h                 |  1 +
 fs/erofs/super.c                    | 56 +++++++++++++++++++++++++++--
 fs/super.c                          | 19 +++++++---
 include/linux/fs_context.h          |  4 +++
 5 files changed, 80 insertions(+), 7 deletions(-)

-- 
2.55.0


