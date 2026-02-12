Return-Path: <linux-erofs+bounces-2305-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DD57E9E31B
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Feb 2026 01:52:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fBJGZ65YZz2xcB;
	Thu, 12 Feb 2026 12:52:54 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.28.85
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1770861174;
	cv=none; b=ILapoB9NMtJ3MbOYa3T8FMdesatSuMBUNSVPCNBuFy57djq/i2b0Nxr73ZgCw/lkDw3leDHhk7KBvA2cy0rIHs9XFRFiaU870SO8Yr1c+UF7t1lTGj7y/sU4YfWO00VCOPuyPInd/JLMl+DjChN/ie++k1II9ZLu+qj9aec7usrUa5fpC8+EQYPGLKBN1x9oIXZCCsDyBpL+xU3cNHMWffnDbj4tug+nFQKNCh8gAlA+rZ/6Tz2Abz72ZUtrySJ/ENjRNc5FFiQVwxV8pmP6N1+5pZv9VDir3mAOdOW6rRBa8D2soToWeJ/k/2gDRCW9dvNtOI8hXJn7eCSgkbeuXw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1770861174; c=relaxed/relaxed;
	bh=0iV/LP5RTKbesAvBkuW2P+2t2E6f6hfSWA9+/SsuJh0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=JjPuZu93Jt/67pdneUOu6LEjePnYF6we7yomYcg115zw70i4oSblCIAW2zJdGqX034BEEl1UtNOlSIx50I5hKGDGFxQgcoV+8RiKV1Z9qmNkd/VcPmNj9yjwQixAW/zfphctHzTG3p1fDRkZOQIvCUfqmpGlpl+ig7HyWCgXSe7nyT7jztkAGGKCYtCQ8mSVp/1JdkDCkS8yQMO3LUMv3wsT38p9JtbIWSxT6+4bH+6bXSiL69ocRf2hLmWV1TOPNB6JpXtZi8+r01C1yqkLDmV7Ra4AhY2tgcTPN2BqzztJGDF/CC01L5ltMzpgloRi8OnJbrxEVHu6VRup2dBgAg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=cyzhu.com; spf=pass (client-ip=115.124.28.85; helo=out28-85.mail.aliyun.com; envelope-from=hudson@cyzhu.com; receiver=lists.ozlabs.org) smtp.mailfrom=cyzhu.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=cyzhu.com
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=cyzhu.com (client-ip=115.124.28.85; helo=out28-85.mail.aliyun.com; envelope-from=hudson@cyzhu.com; receiver=lists.ozlabs.org)
Received: from out28-85.mail.aliyun.com (out28-85.mail.aliyun.com [115.124.28.85])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fBJGX6ZhZz2xHX
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Feb 2026 12:52:49 +1100 (AEDT)
Received: from smtpclient.apple(mailfrom:hudson@cyzhu.com fp:SMTPD_---.gVKa6kr_1770861160 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 12 Feb 2026 09:52:41 +0800
Content-Type: text/plain;
	charset=utf-8
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
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH v2] erofs-utils: lib: oci: support reading credentials
 from docker config
From: hudsonZhu <hudson@cyzhu.com>
In-Reply-To: <aY0se7OziwKD2qtJ@debian>
Date: Thu, 12 Feb 2026 09:52:30 +0800
Cc: linux-erofs@lists.ozlabs.org,
 hsiangkao@linux.alibaba.com,
 Chengyu Zhu <hudsonzhu@tencent.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9864032B-C9AF-47AC-ABAE-1FF6C62024D3@cyzhu.com>
References: <20260209075355.16969-1-hudson@cyzhu.com>
 <20260210093726.86026-1-hudson@cyzhu.com> <aY0se7OziwKD2qtJ@debian>
To: Gao Xiang <xiang@kernel.org>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

My bad. Let me see what=E2=80=99s going on.

Thanks,
Chengyu

> 2026=E5=B9=B42=E6=9C=8812=E6=97=A5 09:27=EF=BC=8CGao Xiang =
<xiang@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Chengyu,
>=20
> On Tue, Feb 10, 2026 at 05:37:26PM +0800, ChengyuZhu6 wrote:
>> From: Chengyu Zhu <hudsonzhu@tencent.com>
>>=20
>> This patch adds support for reading authentication credentials from
>> Docker's `config.json` (typically in `~/.docker/config.json` or via
>> `DOCKER_CONFIG`).
>>=20
>> If no username/password is provided via command-line arguments, the
>> implementation will attempt to look up the registry in the docker =
config
>> file and use the stored credentials if found.
>>=20
>> Signed-off-by: Chengyu Zhu <hudsonzhu@tencent.com>
>=20
> I cannot apply this patch, which commit is this commit based on?
>=20
> Could you try to base on the latest -experimental or -dev commit?
>=20
> Thanks,
> Gao Xiang


