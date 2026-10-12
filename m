Return-Path: <linux-erofs+bounces-4704-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53565CA9EC5
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2026 14:01:37 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3JzZ3WHFz3bSw;
	Tue, 13 Oct 2026 01:01:30 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791813690;
	cv=none; b=VLHPk3NmJ2DWlJ+eCZBeRHvjHUeaFeuMR3rEj8NIaqJ+aWvBjbTOTCa/SwTQt8W9tlW7vHbNiUamS9tL0k1gSc2frjE5lIKz1I9cusfBMr4Rq/ZE5QDbxUC+q+aL2td+ACo9lKdYqno3CGxRG0t4ElfXH3xTBDa4vxsPCsVCoB/wVCf3NYQU3o3ucV8GDJ245b4n21PAxPSdaYh1J/tOoVw4UNf3IZlArXfUUtyqJtZIRlrnrkeU1COdFrFyanOLGtijj9Dsd19QEixSttKyoxqX1QThLaRsy5OzzMQM8ZOl6zTIGvmT1eSJUEOKrNlX+TcM5J689vdYQuEEe459PA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791813690; c=relaxed/relaxed;
	bh=4J9yr73r6ct5cWEU22m05yeks1AqwUzhiTbfVukubqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTJcBetaOS/33lMh1GVXGmocyJ/Y2rzKf4D/VK4fo85rQM/O/5jNGBS4nOXDlnIsvpJ+oMdA6CoHEwhomQ43EzAEgLNbvcHLxoPUUnc+uLWTgW5Sggw982c0UFHGcq9/44qVHD9kLzIhAj0fSW2I44lzw+Mhi2Vfraj7LTHl80fUlaNZQ+XKVfoieEwbo94sCOjvBQVt5DCz9HWc92C+7Bb1uBF2nM0f8olfSur6+8xuBs81v7Y8HTizYyzclLElia7XBJuYKlUc3VjIBnd5PytRoGVt9O82GZkEuAHb9i9zDerT95VW9GIOblR1G1YJm/EuD9T2e/5wqY9BEYBZqw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=tV3l3Q8d; dkim-atps=neutral; spf=pass (client-ip=185.125.188.122; helo=smtp-relay-internal-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org) smtp.mailfrom=canonical.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=tV3l3Q8d;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=canonical.com (client-ip=185.125.188.122; helo=smtp-relay-internal-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3JzY5PLXz3bNr
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 01:01:29 +1100 (AEDT)
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id B6D5A3F294
	for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 14:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1791813686;
	bh=4J9yr73r6ct5cWEU22m05yeks1AqwUzhiTbfVukubqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=tV3l3Q8d8TQH/4TPen9fgtWlSbFOM/C3pH+4EYQnnji2a8y2zXQBt0IiRXE6mct1F
	 pkjqEwTLWsSo7twuojVeDVVB7iDZb1A6KANEtp2uH7JoVP/islWRPmtQNyM6YNrwUy
	 nMOfysVwF1uhglj1IauB0GTCxibyDk+oEe2gYg64FgnalNCVb3JIQJqVaYtLMuTAfs
	 Cpt1KHrCa7vFJ5DCAXM9anvQat3VJ7OvHx5c7fedXej73a8xLlDDwZap3jeN5mJz0a
	 cuV6/kQZSkPXRJ8eXwds+4Zapwg5NErzHVK/TUhmgv74P6X/wxGnq5mn3NstSXDGdD
	 Kaz8tDoC09Q0p1GBMh8HWCQhMWuYRt3ceY52r07QHiXl6QPYzrO0jTjAdL3BQ4HjHi
	 zJyoOfzB4Q4OR7F8dHf4Px9/6K/S/PO46u6G5NbSs9buhM2Un9IgXvm2z8dyKRVJCL
	 BaqxWutejKav23cG2m427+dUFhsRsMAt0iUDBwtpFN36UMnf8KuNAGPRbs/uSYgPHz
	 ii1tElYNiVY496fQqsitioDD4jzMFoUjdwes200I4GAAtGfQDfN/WwI2/8mr4IHpLO
	 O4CRCmIKuczx8742BlTehYyhKTK+NZoowHbsic70R8UHWAeSnld/YGCRwE0G3yxqfh
	 zrSwFJE2BnRWnxLeJyFtc9M4=
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a0761224e1so18181695e9.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 07:01:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791813686; x=1792418486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4J9yr73r6ct5cWEU22m05yeks1AqwUzhiTbfVukubqk=;
        b=yUgHAeUxR95BaOWkKFqIxJ7HtZqCjoGdZrpikXxQSyZJe/7Z9lrkzH/UCOV9L6Wd9h
         WUSowkfXsuoxRmRYYNTUzCX6O92OUjfT8wSySQuQuEEPNyqRLYN1R3CObLFV4SYHTzqv
         0GbjkENbBYpFTHvhjCt7USL8OsRdcFDTujb8FBT8ds17I4VxxStY/7X/CRhT8z/HY8sz
         cAwKNu9jOWxogpZIXJXCMb2sLgPnZY+irE6Kn+P0wrWzz9gIg8dUyJOvokOq50hpzW93
         NwTy1xpZRIjsqIqDieTBjQB+M0Ra/K1CMUjLYFQmqWM1C9KrMX9TK6YK7IJVwZgkDWi9
         nnrQ==
X-Forwarded-Encrypted: i=1; AKwUvBy/sm6Jp4IlHpMPdRYpQldpSwFCXZtJxpWzwNPSPV3ffifVdc0D7eFdOFf1jGYg/IrbDO8v4qvi67DB1Q==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYKnrf24CTqXt1h02hRdmI2bKObFydpLZJXW/OiEskeRJl7LxSdt
	Ytp5Z0pPUK+3Wis4sOJOT1PnxgMq1kYbvWIpkMd6DwFxepdDgZTs+h71tU/Yt8LUqpRKLOYIx6t
	zw5AE3JPamVehBjhNKAAXaVxtV5WBqwBy3qyl8dp+/dmaiJVsaFq5Cy6KkoscXKux+PEHfYhxb7
	Y7BXw5Sw==
X-Gm-Gg: AYBFou2mprbibIQo0BTzSRc/kQxyLMYfyextwET2xS7ZKr6ySe4bB1lmfmN0lllQ0AB
	sYvnqL1nn6G/GyOdCq6HRBQY+G1CSFLsd2Txh+OWxjSzDhpSrDx6ZwjyNPiMSq3VJ0471MZXaZc
	ylw/nZs+jx678pZxw6WWtxgwVUhPZ4x/JdGoylrjmav5yyVFSzMs2NNNBJ5cMaBVS1fJurUtbs0
	uGoIMAmLYxXLw04IAZMwVz5vA5nG8mM8hy5PBHRStDxDlS+yja3r0pV28Ynta3lGiMPMwmm6F9e
	ohMD/QAzb8Rbc6zeTwmg5poeTnZ866AE9F75PJlRsmTbTYGzG7b379Mj+QLMCnw06bOpU43emqz
	dLyVPd5XqFmB1lU0gu9vr+HTzuNGfokpwX358nP3scssWzNH1Z2jRN4U=
X-Received: by 2002:a05:600c:3144:b0:4a1:70b2:8dbb with SMTP id 5b1f17b1804b1-4a18e4b0347mr172750635e9.19.1791813685890;
        Mon, 12 Oct 2026 07:01:25 -0700 (PDT)
X-Received: by 2002:a05:600c:3144:b0:4a1:70b2:8dbb with SMTP id 5b1f17b1804b1-4a18e4b0347mr172749945e9.19.1791813685349;
        Mon, 12 Oct 2026 07:01:25 -0700 (PDT)
Received: from workstation5 ([2a02:908:1242:30e0:468d:767c:32e6:22fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf15691sm284551015e9.6.2026.10.12.07.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 07:01:24 -0700 (PDT)
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
Subject: [PATCH 9/9] test: test_erofs: adjust expected ls output
Date: Mon, 12 Oct 2026 16:00:48 +0200
Message-ID: <20261012140048.214059-10-heinrich.schuchardt@canonical.com>
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

With the addition of the date field the space between columns in the ls
output has been reduced. Reflect this in the expected lines of the erofs
test.

Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
---
 test/py/tests/test_fs/test_erofs.py | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/test/py/tests/test_fs/test_erofs.py b/test/py/tests/test_fs/test_erofs.py
index cec803256ac..7e7af9c6bf6 100644
--- a/test/py/tests/test_fs/test_erofs.py
+++ b/test/py/tests/test_fs/test_erofs.py
@@ -65,8 +65,8 @@ def erofs_ls_at_root(ubman):
     slash = ubman.run_command('erofsls host 0 /')
     assert no_slash == slash
 
-    expected_lines = ['./', '../', '4096   f4096', '7812   f7812', 'subdir/',
-                      '<SYM>   symdir', '<SYM>   symfile', '4 file(s), 3 dir(s)']
+    expected_lines = ['./', '../', '4096 f4096', '7812 f7812', 'subdir/',
+                      '<SYM> symdir', '<SYM> symfile', '4 file(s), 3 dir(s)']
 
     output = ubman.run_command('erofsls host 0')
     for line in expected_lines:
@@ -76,7 +76,7 @@ def erofs_ls_at_subdir(ubman):
     """
     Test if the path resolution works.
     """
-    expected_lines = ['./', '../', '100   subdir-file', '1 file(s), 2 dir(s)']
+    expected_lines = ['./', '../', '100 subdir-file', '1 file(s), 2 dir(s)']
     output = ubman.run_command('erofsls host 0 subdir')
     for line in expected_lines:
         assert line in output
@@ -89,7 +89,7 @@ def erofs_ls_at_symlink(ubman):
     output_subdir = ubman.run_command('erofsls host 0 subdir')
     assert output == output_subdir
 
-    expected_lines = ['./', '../', '100   subdir-file', '1 file(s), 2 dir(s)']
+    expected_lines = ['./', '../', '100 subdir-file', '1 file(s), 2 dir(s)']
     for line in expected_lines:
         assert line in output
 
-- 
2.55.0


