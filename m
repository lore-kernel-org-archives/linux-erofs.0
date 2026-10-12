Return-Path: <linux-erofs+bounces-4699-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1024DCA9EDE
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2026 14:01:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3JzN3Vm2z30W9;
	Tue, 13 Oct 2026 01:01:20 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791813680;
	cv=none; b=dxihKt4c475TJIY4ykROgW6SOlN1B0ZGJGkwqI4bXjUEqMBp8U3mve8EZHiHM+zgTh6KbJfNxbN6pYwlbE91BQYBmhA8LapOMUxw/FuCTbXRH5lmT+4z+fL6r43IYSpIvewBKYR6bqIpXe+PNYiKpsxMUfxumHA1ZDgUskgbuf9c0ZNpzuz/uOsAlLCen04K7jHENYa2qSHS4j0CcFWrRcqVDPx2FJh4Q5g31CBjQVyKy5sv0a7kSuM0mm2Zkzm0/Hy1JxUVK24bN2ZnAv1yvXofhcXIr3qU2vvkCtdO1AD6TdVYzW9TT1AwqeHyhQtddAN60cT7R0kOQmCw8oojRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791813680; c=relaxed/relaxed;
	bh=O+2iEn2wJh10qhSoM1uM1UcZeaD/tRv048GX9axQpuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abWhLjbo1ZSjGqm3H9FHNQ/qMAyJHnE6NKNKqvXm0vC4Z6lJgiBHuZobtr7mrpjeTtZIN9LTxKJPBNEc8smveCtC4Rr6qWfs+pyRpmTpzAMmP5xadXkXcVqpJewAOKLC/IAWlOAw11u9dLTVyqbMXg3zkbFs0qJUEA1nNO4eErY3ToHdwW4fPfr6EWTDLo+lzZDural1tSypE4hmmObOzR0K6cNIT9W0ejNFLjH/j5Hq0Ug3/hBKtTiCVaME328R02VriikKikS0BvGi6woOJWpVvzed4/xG6xFMm6IhBGlktlP9ax50wnRmIN3AQmq6/15Hv4Zv61QdC/5kt4upFA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=ocgFPfRH; dkim-atps=neutral; spf=pass (client-ip=185.125.188.122; helo=smtp-relay-internal-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org) smtp.mailfrom=canonical.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=ocgFPfRH;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=canonical.com (client-ip=185.125.188.122; helo=smtp-relay-internal-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3JzM3kFtz30Vs
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 01:01:19 +1100 (AEDT)
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id D8F233F223
	for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 14:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1791813676;
	bh=O+2iEn2wJh10qhSoM1uM1UcZeaD/tRv048GX9axQpuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=ocgFPfRHNsW+gRNfeDjBNrxXXdKm0IR2iA34U7b+LWxaIlxAsfzk1vp8dVuIF3eLV
	 Be7eAmj0vmJG6lY3cBEHlmULQN6sTKKn3BM5k53v8uLuIJpgDgg/GaVDb4ueF0PwnB
	 6+9RrRZixO0ucVAYfkIqOWTx2DtWbLQWnUCjpcg4oI1qtrhIAmgWUEy0s5SUkkT4yR
	 cknJXBCnCLpLoDUyRNgn1iUZ3eDHrKWM+M6u1ganlhOyxzHGeWvmAuZRV2vFZW8uTK
	 kA5V8lT1fCo0eQ/0fNRybOB/nmfIEdxYL8LAbIoXIe2411B2Vu2v+tMhghHe/1GOv5
	 8Cvi10ryU37rWh4yPrUeolMISlumV8rvA1dpQCs3p4NjpwGF4e1Zt1voRjitTaAlbI
	 KdADeTpX8C1Hm8AsXDh1Tdmn1PDCOoazcG39S78/zTgoIrU2elL3pzMMVbk40xnKWX
	 sxqPeTIdSlk1YeYrTVsEjWr3fgWzWZ3pi+RLRaEsy1kSS098RI39lEc+Png5HD1Zpq
	 5gvcj4N8XYmkg49v6LUtbXG1DRmk3f1jQ3KrSivn29YRUKtPKeXyq4O+P/urjfJUwm
	 J3tEYCHgL3Ngal8RWwGopghK0vVdqv4/Om0RTxYQ7/bAaPrVLG+gjblN7LvlV2fzNI
	 h6fau7GIBcA1ZVTAkeg64i+A=
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a1895ffc83so15993735e9.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 07:01:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791813676; x=1792418476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O+2iEn2wJh10qhSoM1uM1UcZeaD/tRv048GX9axQpuE=;
        b=waYLc5c385yivjeWrl1m/Jnndxv4z+2+Yo9O7VZ90t+SQFb/91xk05ZVSRP7BoCMui
         EaUnr8pI7HF8d+yWN9toLBnT0o7y53ePMUdCsA8/uVoi+yDG1ouzsIM5WJEQd+GrpWOr
         +7I9SuXp77t4yh6rWeRY8g+m4vyKBKFy96TO56UdfbZvQl8xfOWYwZTSIokYbSL1sFg0
         c/0Ow4aE6adzXZIhl13z5/cGegODTFKLW8MhNdkrijZLaYDVZb+X2qQmLFXY6sE3Rxqs
         S0tpb8t0t3E4/+iNiyclRoWIHRDyjX0ld0gs65h8qZE46DkMo3cYtzRxi8bP/PbJ/eIe
         mnbw==
X-Forwarded-Encrypted: i=1; AKwUvByvL2gyu+AgWm7u4uH/RFeE23WH9RqNOPc2AMW9j0bYPBf+/fFQCTLa+hkL1rrQj5J8sugu8Hm/N7GL1Q==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYJI9QDmCUdDLEZ3CNAU0sG7AMrG2OJvWpaJ16uObDkVDDSIDcnC
	wnBTgIKinVPVd2SpspBmXQNADWzn0KfzyHAIbmkjCv/9ruO0Xo99emK5b9pKya+FMrpAsv8D5R6
	MepsRIJyytwT1UD+mvr/E8MMHsSDb8qTbZyE4OrTczQmfgW+kcH2fxvuibOUgXYBUHXuJY/cgu5
	izOMIyLA==
X-Gm-Gg: AYBFou24U721xQynmQCYh+NKVsYrodtImEhkdVefLommywb85LwOGIZfbiJHCzP2Lyp
	EWswU3qtoi9yVBO6s23RHhnCPU1XqAGpsfM8b1Rqki5obS8b+F9y8bYlz07qlE9iudzZ4Cok+8+
	paAlW3vvOg5IWtDULu0h1Xv+CuW3p4hMHynSh51JupeTkn13Ng5x8Q/p/lwoDXhC1cTrBXqeu+H
	t3juG64OEBXIJGE51zqI9KRU8Bb7lMTA9MFS40b+M+zJzHyt/BpX7dTNDo3vYfmbZgDN0odhsoC
	wHRp1Eh0HprRCGYQlC3HTEkux/y4kMwJpq/ELoSiAZkwjXKUj2ruDPZIOCmtXNrEFgdLXKQkAP0
	ct5PWOzbFh8FoEGQ62wJSkeB+AAiNxtHBJII5D2eP0lzpnZ9G/ndwoRY=
X-Received: by 2002:a05:600c:a00f:b0:4a1:6c0c:ab93 with SMTP id 5b1f17b1804b1-4a18e4e24c7mr185215125e9.28.1791813676281;
        Mon, 12 Oct 2026 07:01:16 -0700 (PDT)
X-Received: by 2002:a05:600c:a00f:b0:4a1:6c0c:ab93 with SMTP id 5b1f17b1804b1-4a18e4e24c7mr185214515e9.28.1791813675606;
        Mon, 12 Oct 2026 07:01:15 -0700 (PDT)
Received: from workstation5 ([2a02:908:1242:30e0:468d:767c:32e6:22fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf15691sm284551015e9.6.2026.10.12.07.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 07:01:15 -0700 (PDT)
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
To: Tom Rini <trini@konsulko.com>
Cc: Simon Glass <sjg@chromium.org>,
	Huang Jianan <jnhuang95@gmail.com>,
	Daniel Munic <v-dmunic@microsoft.com>,
	Tony Dinh <mibodhi@gmail.com>,
	Alexey Charkov <alchark@flipper.net>,
	Vincent Jardin <vjardin@free.fr>,
	joaomarcos.costa@bootlin.com,
	Aristo Chen <aristo.chen@canonical.com>,
	u-boot@lists.u-boot-project.org,
	linux-erofs@lists.ozlabs.org,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Subject: [PATCH 3/9] fs: ext4: print change date in directory listing
Date: Mon, 12 Oct 2026 16:00:42 +0200
Message-ID: <20261012140048.214059-4-heinrich.schuchardt@canonical.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261012140048.214059-1-heinrich.schuchardt@canonical.com>
References: <20261012140048.214059-1-heinrich.schuchardt@canonical.com>
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

Declare FS_CAP_DATE in the ext4 fstype_info entry so that fs_ls_generic()
displays the modification date alongside the file size:

 4096 2024-03-15 09:30 filename.txt

Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
---
 fs/fs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/fs.c b/fs/fs.c
index ad577c475f5..c2a893f6ff3 100644
--- a/fs/fs.c
+++ b/fs/fs.c
@@ -262,6 +262,9 @@ static struct fstype_info fstypes[] = {
 		.fstype = FS_TYPE_EXT,
 		.name = "ext4",
 		.null_dev_desc_ok = false,
+#if !IS_ENABLED(CONFIG_XPL_BUILD)
+		.caps = FS_CAP_DATE,
+#endif
 		.probe = ext4fs_probe,
 		.close = ext4fs_close,
 		.ls = fs_ls_generic,
-- 
2.55.0


