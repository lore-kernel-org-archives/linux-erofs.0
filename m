Return-Path: <linux-erofs+bounces-4703-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2B2CCA9ED1
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2026 14:01:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3JzW3P8nz3bSy;
	Tue, 13 Oct 2026 01:01:27 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791813687;
	cv=none; b=K+SKufPQDKlVgy/LzoHCwc/ET8Ylqh4m6qUNOQmenS105Lnn0Tc1leW/TdQPLKAhFjeamw/DdJexJ2YNWAPhfwEvvYb2cOpBqsC14XLfyfnsfEKpS2eRnxjYZNkD6jSc0ewNO+igETy4OPvNmXwpP4G6hP7COxjOu68Bvzq1CfDeNIRO/75vilhBRLHaeAODHIpM9ZsYAODYdEylnPVY7miEiv+OQD36KVVUVVgmduU7oTo3b/0zwkJ+UcNXxfsuswVCETCvxytCBSd7u1ZxWKKd6+zBRWTz+Vo7GYTk36FuZ0kh0ocI9DgspILQETpr3fYNY0QLPcE08U5AR1mMAA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791813687; c=relaxed/relaxed;
	bh=tpfhScP6KRyDiOFsXGeU496N9s53GwsWPbixbH93AxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8QcWWTrWA7L0tPnXbgSf/+5K/cWlpHE+AC5ALO272fq1pCrdtszQMHBDb3mk8oI7YZ6+FBYjNr/DSUCI3m+bAq5L1UzQhJ51UUgORTp8V5HaDjbMfXCLJrHxcF4u+Jxk7kbjXFUrfboPiO3gorXhiOxLL+yV5kykn08ugS6/ifViQD4MrLG2FcMxhRxJ1D+yVhp/2MyBJiecdmVWQjXNHRz1IEvLkqAun6G0e8jIRt2lYuf6+OBKAbTZYDp5alc/2z4gh6fewBHT6UWyOELJupjBdvDErYDDefBUQBb/lT4/R2qwoIQMxJI5VQ06VVwtF+mSlH2U9BGQrDZQHYqgg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=c8xZTvXs; dkim-atps=neutral; spf=pass (client-ip=185.125.188.123; helo=smtp-relay-internal-1.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org) smtp.mailfrom=canonical.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=c8xZTvXs;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=canonical.com (client-ip=185.125.188.123; helo=smtp-relay-internal-1.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3JzV5Rh1z30hC
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 01:01:26 +1100 (AEDT)
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id C472B3F2CE
	for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 14:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1791813683;
	bh=tpfhScP6KRyDiOFsXGeU496N9s53GwsWPbixbH93AxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=c8xZTvXsVklKpVEwwoIOem+IPYwYYCfU7dV5l47XhW4lAKDWUsA+s9IQXWWE+OH02
	 6ceCdwuyCqoh8f5ewV657R345DGWziv/aJg3t6oatqDTBIdHaPJ0NgNAGrijsdDzSL
	 HtN5uTbh3cQoJZLk3GDOgY76+Y13hJtmI0SDyC+PrL3Rdd6xLXZWKzsjq83QDErruf
	 kIP066fViqmX/bJMyvawZYZXujBOAsFKTv5lEoiQSc2idbUflL/mMrQ3QwIYGpyCeg
	 0yXVThB0RSkO7fuU9+1f3s6Kg8CE1SxyYsLXqagAtZ7CprEMX0TSxmaBojtJlfYK7O
	 eRnnIIwNbTxYWcEcYarL14pcuNX/IHXaNaDJVebetHPOvYe0zPDg4uRlJMXXfm+CGk
	 anzRevMpqpfwSFTVrDaOPX/DiK4lcswuF/cVIUai1FC72uh3FL0cG1QBdHzd0yZ/bA
	 mGvAuljI+CdyDF2f1Ue8YZa1ZQJKQnmSUrW3ZtUvH+ZaF+4HYbh6BZ6EEN4AUnBQ2Y
	 MAuNk45B0ZtLPBwUOt+sy0k1LB8jFBcHTIqn0CF7+E8ZPV29xGo3o/seqMps4DL5ej
	 CGX7LFVWSLocR3Q41yg5FWzIct+xnG2pbNk/gkqwPpOlHr+uMcQxlyfokFg+aLLPRa
	 zk9Ot0LP0v8cqOE9QaElbAxI=
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-487038bc9b8so1607598f8f.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 07:01:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791813683; x=1792418483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tpfhScP6KRyDiOFsXGeU496N9s53GwsWPbixbH93AxM=;
        b=FSk8U4EG0WgsN0zsR03oGxJzHTPw7THt99QSqiW+uiyeotPgaQ5idrvrg209BIb824
         ctM9SHfhmcJnvI22LpdbG3dpq0k+pId/rLYW18Vq818uUaPT6pPRhKKZ/7nCuecC3vAU
         +ebF6LE9y2oIWVHryPXuCamlNFCEO9sj6nicZimIpH2aTY3tbQ/Ugix6ddh06l8DB7cb
         OHLbJVG4JouK7lgjBAgYKc+kK8VKzxeC+5FvXnLYVqFyfC6b64whWJeaEftSjTnXDCoY
         fvvSKhQIb5R/iFBlIOhQW1AxPR/XOK3RnBQUvCYnG/BYqcfUFNZ527OWLLsL+zCviJp3
         Gkqg==
X-Forwarded-Encrypted: i=1; AKwUvBzfSvaoQAGHSDX5Z6dQzhdESmpScXAmx9e6Nru0Civ5b54lkN4gBrBjJZvNVNfqD1q8wZJHuHMUA9134w==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYL/B+KCQfpWEIZN7//HOaaLNCv+x890LN5YENB4eguu1b11pBLE
	lGf4opsQWJwLvnRlj7nA30uymfWaL9RUuxtlQ9l3zggL9mbyOUn98VocfhlfRSrJyxmSjt6sK2D
	Lg7eqScjmf79OlKAEKA2gfmTUemOWCiCNtfktl9+hZLx3arH9b6lTVvBKSmEdBkhz5ZfLHkn18W
	9GziyNXA==
X-Gm-Gg: AYBFou3TSvPixUp5sHUaWS3i173R5LL55YYnBWN+TJBq/GdZppJMrMTFkxnUrVIcJSt
	Tc/jnXN3bZk681H/05A0hTj8fIe3tjmKKDF6pmuy0S49FDYl4sJYBOf4Op9sCcYj3x6gAcaJ5lt
	5mMM3diXE4EmQrd+2Ujr1FzjgR9cIXOHnHOUjIIKSWJiZeO4l30LbLDm4HiFi4iMSqRJyo31ppB
	7OaljgQMazhss3TwIOJeLts3NyenZ8vJanKXok8JfXvvqkIVNNeyfvs7QgeNYqMJxY7SQMPynov
	8lxyI/IrlzXFn83k6mjjyV9jofhth8KvR+dOz0SJptruKbByxWCOAj4c6YjCIYB2HyCtBjSfUGb
	ykE9YiqE3hrLtks0ZCI/HscY7aWRNdbbMUBqE7BIDLkyEcBP1mmpqZVg=
X-Received: by 2002:a05:600c:8b6f:b0:4a0:25e9:bc47 with SMTP id 5b1f17b1804b1-4a18e4ba6c2mr161382785e9.19.1791813683124;
        Mon, 12 Oct 2026 07:01:23 -0700 (PDT)
X-Received: by 2002:a05:600c:8b6f:b0:4a0:25e9:bc47 with SMTP id 5b1f17b1804b1-4a18e4ba6c2mr161381995e9.19.1791813682506;
        Mon, 12 Oct 2026 07:01:22 -0700 (PDT)
Received: from workstation5 ([2a02:908:1242:30e0:468d:767c:32e6:22fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf15691sm284551015e9.6.2026.10.12.07.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 07:01:21 -0700 (PDT)
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
Subject: [PATCH 7/9] test: fs: allow optional date field in ls output assertion
Date: Mon, 12 Oct 2026 16:00:46 +0200
Message-ID: <20261012140048.214059-8-heinrich.schuchardt@canonical.com>
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

fs_ls_generic() now prints a date between the file size and filename
when the filesystem sets FS_CAP_DATE (currently FAT and ext4).  The
two regex patterns in test_fs1 used ' *' (zero or more spaces) to
match whitespace between the size and filename; this no longer matches
when a date is present.

Change ' *' to ' .*' so the pattern matches both the old format
(size + spaces + name) and the new format (size + spaces + date + name).

Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
---
 test/py/tests/test_fs/test_basic.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/test/py/tests/test_fs/test_basic.py b/test/py/tests/test_fs/test_basic.py
index 88b163ce305..5f2af9e21d3 100644
--- a/test/py/tests/test_fs/test_basic.py
+++ b/test/py/tests/test_fs/test_basic.py
@@ -26,8 +26,8 @@ class TestFsBasic(object):
             output = ubman.run_command_list([
                 'host bind 0 %s' % fs_img,
                 '%sls host 0:0' % fs_cmd_prefix])
-            assert(re.search('2621440000 *%s' % BIG_FILE, ''.join(output)))
-            assert(re.search('1048576 *%s' % SMALL_FILE, ''.join(output)))
+            assert(re.search('2621440000 .*%s' % BIG_FILE, ''.join(output)))
+            assert(re.search('1048576 .*%s' % SMALL_FILE, ''.join(output)))
 
         with ubman.log.section('Test Case 1b - ls (invalid dir)'):
             # In addition, test with a nonexistent directory to see if we crash.
-- 
2.55.0


