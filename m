Return-Path: <linux-erofs+bounces-4590-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF9BC982ED
	for <linux-erofs@archiver.kernel.org>; Mon, 21 Sep 2026 13:35:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hpPPc4pcRz2yK7;
	Mon, 21 Sep 2026 23:35:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:39::14"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789997748;
	cv=none; b=htnJEc0E/MiZNM+cYQg+BQjxlghi2uyYiluq8qDmeVISx3PnTMGLmqXzlQgN54Rimkrhd97p/kfLHSmdbhZFecIUlTOP8utnc038U3H6c1PeA3N/Zlr8XMuzPCD4VWl/m9IXa1K1sms+ortfSlPzrqeoM8s8iIqKnbTuowsQgWSCZZ7WW0BMnlOdr5LDiFAo+6Ka3y9gtnLO8fk5bXLrmML6/Puv1wxARz/oyq34v2+a6Sb05QZ36Q5xKiffNgVgDEufG4SSJbBLTpwdiNXKaz4lDQh7cVeZn/EO/8vbkA+GNI4JdjJjhKfvFl1gipSAwFPPWU4qVwPN6sImLDdt/A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789997748; c=relaxed/relaxed;
	bh=dRM0k02drs/uoEUUPrerlW4kKcMS6DQD+6SeSxFSRQI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aP9or8zONv2kfqzfda2FMWc+0v+fLyX+/CjyN23x0gbEqOZVl9IhyUQq4l1m1dTidYumbyL//BWRUH+0pGqWnRbdSJGbnBqueRFouRIU2TfS2bBgAoQfERE3WfKiFAXtNHQdsrW2v8WwS1cyKV8KZB2bLIIKzuCPnC0WB3iHxf6Gg2SWf0zxmqXqWfwOk6+8fe7euOvIuwtrhgCOuNrSBzlb9NoX6KlzsDRhuNinoiswmPdiF1PhEKd2jC+7DXq7RlAo34g3t5g4SWY0aM+NEcp4L8oef2Ir+fXR4I4mg0ZLaQnBtwwnZXaH2XeTbrLs6R8mSOsHcEP7zuI9TBcNVQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AQXZosnl; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:39::14; helo=mail-pj2-x14.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AQXZosnl;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:39::14; helo=mail-pj2-x14.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj2-x14.google.com (mail-pj2-x14.google.com [IPv6:2607:f8b0:4864:39::14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hpPPZ6j5sz2xbQ
	for <linux-erofs@lists.ozlabs.org>; Mon, 21 Sep 2026 23:35:45 +1000 (AEST)
Received: by mail-pj2-x14.google.com with SMTP id 98e67ed59e1d1-396ccd78e6eso1161772a91.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 21 Sep 2026 06:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789997742; x=1790602542; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dRM0k02drs/uoEUUPrerlW4kKcMS6DQD+6SeSxFSRQI=;
        b=AQXZosnlg1AZdCv9crpbO1hISxCr02yTGvXhg1Oxftdou3VXflAcnzccihR5PHwo8a
         MgNOhyv9eexQEtGjvhPl8USOK444v2CQzgK8BVDnhpCLASTdGMhMOSAwCA4Xm4nzkM8O
         0AeEsWq89xiVvLdu7TzOEZxVu5kOztOxaOf4PTN0d96ctk7Ed8d4xnT06k0t0Ge7ej6b
         v1817/BObZxfdY3K/tACEIixbRp82ziaIIsLehBRPNygjp5Loz6wYy5LphwAkeUKPCoD
         M0rQjwrOOBfPRCY4PyEMFx/rS5uu5tlBWyLA55Ze/2focgSkXa+uRCijbprCmWpyzOqX
         IUAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789997742; x=1790602542;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dRM0k02drs/uoEUUPrerlW4kKcMS6DQD+6SeSxFSRQI=;
        b=Pi8lQgo5tL7zAJ86Ygslg3ZoEglq/Ho2IdwQyWGbmz709nGxhf2LaUFpoJCpGnad1Q
         OuCgbD510s89Zx0+hT85YopT16XjJfeFZSojWZ6058hHyEYEFS0gZlzslVhyxf8HkBRB
         q0/uHf6UP/riTVd7JaqPTlnBVqo1GbU8qh7CJFV0PTLrc18XmhbMpZwAnQ+rb9u99t1U
         sujQ0nCf6ux/RfAQu9qzfUxqD/2hZA4JTNaE011EN0Bjm24N1YOpV1NFweWYo3qGxk5U
         9UWo7xmTfaHofmBHlTkkldwM79OamIzCOSLxfTdgWmyTyyRbEW3Yk8J6PnWaKgHfCLRH
         uVzg==
X-Gm-Message-State: AFuF++nEE2kZeKGykUeuMaJnDmYbtN4BmVPGdYeBTYrYZ9CnC1ao9MRy
	md3Pvcl5eGgQxel1xXqcZhwGPLENiL7bppJC+8LlVGi1m/T/6AA2EGXRRLjrQrdM
X-Gm-Gg: AYBFou1IzUN4nr4oOeY5+QvryV64HA/pDdCKXLeBYQhW6eg+56s6PmjHR8y232G0w8P
	1H6P1Jb+zhiJdg9ujarlhFX7z6UlqQG+1hRBljgHYg5FrMl7+Q1DeEP33TNY6731UrkRVxSRo5H
	U2l0pRWuLQVBewK+Z94WJmReAytyupfsOUkCQN4k3lqqCcyZuKAnFE7iNO83HgJhK+M0cjvZMr5
	cKwA3d9OBvzVIyQUgJAA8iIDPcWyjB3dNgnE+IbCoGLIAGEUNYMnrW2lZwIAq0aOi4+SAeffOkN
	g95ZgRc8kaYS/iTwmKqDjty6ixOK0KWwUxO5cojksvnrNSfcwpfsm3trAAA+AOBPJyD8k/FwK19
	4hegHBRwO9y8jqEtQeLu3pFUk4znwdjv9M7sZ46/0SlopF40DT3w+PIb5upxIb+bkIGxrN5ONPj
	oGzN7hKf+QHaAu+NnN/Jy+Ga6RCgfarYErkD14LbwxBHMc98i7yJjviOCrGQyHFGjSoUogbEJtA
	UaZxgIcC8lv9XIAXBKuITpPjSl4BKTN/MEpnHa2Sz2yD7vMPSc5EZk3Zrxz
X-Received: by 2002:a17:90b:5143:b0:39b:5622:d645 with SMTP id 98e67ed59e1d1-39e5513d689mr10197256a91.0.1789997742208;
        Mon, 21 Sep 2026 06:35:42 -0700 (PDT)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a06369372csm179385a91.1.2026.09.21.06.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 06:35:41 -0700 (PDT)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org
Subject: [PATCH v2 1/4] erofs-utils: lib: fix short write retries
Date: Mon, 21 Sep 2026 21:35:32 +0800
Message-ID: <20260921133535.2381246-1-stopire@gmail.com>
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

Retry with only the remaining byte count in both the pwrite() and
pwrite64() paths.

Assisted-by: Codex:gpt-6-astra
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/io.c b/lib/io.c
index 5c5449f..f62129f 100644
--- a/lib/io.c
+++ b/lib/io.c
@@ -75,9 +75,9 @@ ssize_t erofs_io_pwrite(struct erofs_vfile *vf, const void *buf,
 	pos += vf->offset;
 	do {
 #ifdef HAVE_PWRITE64
-		ret = pwrite64(vf->fd, buf, len, (off64_t)pos);
+		ret = pwrite64(vf->fd, buf, len - written, (off64_t)pos);
 #else
-		ret = pwrite(vf->fd, buf, len, (off_t)pos);
+		ret = pwrite(vf->fd, buf, len - written, (off_t)pos);
 #endif
 		if (ret <= 0) {
 			if (!ret)
-- 
2.55.0


