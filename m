Return-Path: <linux-erofs+bounces-2723-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D18ACEFCBD1
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Mar 2026 06:51:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZ5NQ3TBvz2ygh;
	Mon, 16 Mar 2026 17:51:34 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::102b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773643894;
	cv=none; b=YjzmkAjfjqoKRX6hXCX2CRfT92X4r/183ydeA5snabkfUDWD6slgE2PpkAD5vO2s0+nZbDa2eD9eH2J53EjSQQQIYQ8ZQsbrCu+Z+LGzIOsKzDTD5ceNaffn7or+KgOVUgQSHWbmonCwveLt9zIqRot29nPqfvOJRNHu+oU+FWhP3ObebhyutnvLKoCumdSJU9aRHdh5T+iPg+JGOYna5/8KgLy4AnQfW0XxGfoP3cbZ7pkkGkkerM6q5PzZ/Ylhaj1YYofuslRBlauY8MflgokmQbXC83CpoAr5uY2O1a5ND2WR0osnbXe1J+6U/uvYP41tjgcFEv3vfo76Adyrwg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773643894; c=relaxed/relaxed;
	bh=Xtw98uB7v1zHKoslDSeoSegCcIr7J7RAVQq22gnxnlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZT3J1Bk/gIDQltfIsfpQ254JZP17qsndWgQxPYu9pj/zRfHFESRupbtasz3usW8jwJ4Yi4a/CjAjqPUISWscmpuEV9NIscmUpuVa3WVFlfv1UUAzjT6p9VENo900K3WmrrJbuB1andTfWoTKmVD97aRdNV4qovxwRsWCHCUPz8yxomHWU3AHC5XtlTQIMZyJknQ16Btg3G2SN2v4UpM++Jrm7JznEpH976SgCkmVnlCifniFSYtOj+I/WYO3GVFN5sCYb/OMxNw932tTUUZA0L/6GbJykYRadmaJJEEJcr50Vk9abb3kgVfsa/hkmyNkMPrWtWBqYtMEdr3L1ZppmA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=OQYZsAPs; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::102b; helo=mail-pj1-x102b.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=OQYZsAPs;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::102b; helo=mail-pj1-x102b.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZ5NP1KyGz2xS5
	for <linux-erofs@lists.ozlabs.org>; Mon, 16 Mar 2026 17:51:32 +1100 (AEDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-35a01aff037so126003a91.3
        for <linux-erofs@lists.ozlabs.org>; Sun, 15 Mar 2026 23:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773643891; x=1774248691; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xtw98uB7v1zHKoslDSeoSegCcIr7J7RAVQq22gnxnlw=;
        b=OQYZsAPsurQqwT5F4zuYh/sYitX8qAHyi2n6oZJOW01jQ9Dhmc3RbMguvCzjCr2dwV
         Cq3UvhaYanoc5x4UNpV5tDFUgdS5PST3zp8gaC9El2OdUxAKpWrNcz7iWuw9CjktCsG7
         YHtljOfkulNajn//JQLbBj33Vrk14OjUn9VYcMC6ZwGOHmNYPRjQBH+VxJIKlcV1JvyR
         rzGKX8nbR2NNjJ1buoChGpnjqzkB/3Cezmu1D5/LOeyJU6eA0ugyBevpuoEy/heXsm9n
         DvCbn8v/aipzCgy/h8RSBC+DQcp3cnWS6lcfiAzuyzRvpRvYlCiO8HEBVpvPrspFciBS
         /IBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773643891; x=1774248691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xtw98uB7v1zHKoslDSeoSegCcIr7J7RAVQq22gnxnlw=;
        b=Ujd7ZBnfxs2hTTyYQW14ejeY5LjEuqYb9tMl0yhxc9Ked3rJ1sh9u5A+QGdFV5AD74
         X3Gl4IN5JtbrEul13Vyy3Qe7PjhKxj6mD1tm4K+zeWkkSg2ZYMLNNwahWtC731HXjLjp
         D7ElM1EK/3eCYoWOrTMj6AqcSfGWn+pQfVvnhTNeKmKHp9UiSarbAjaQiWichaRzka8j
         ceuyyOhfSla5Guia969azdqSbPQCUuAtFCKiWVuTQ+3PZX1qCqoO8OrHrT7yAMSY7v3a
         B3zWO7Z0ZjLp5UeV4mDg80jBjk2srnZFFyMneSaxlOVvkvtWmwag9KrCDdzhe5qKx+q4
         cavw==
X-Gm-Message-State: AOJu0Yx9fbOfApzu6F7e9vk4uWwIkykGlh/y8MYJo8CIPZ/p6v2hZyPd
	wenElXJHybyMKIMstucWM3aPac9Er9fei8Wp8JaJtmogfmp//NkmdGKd7qmgWqsL
X-Gm-Gg: ATEYQzxayX+MIjD9YiU2VaAn1lb7rkpwOd9QQZje05QvWFSFbfWhXSB1tibveWJwXPS
	/RdS1gotUFSoPhsJzYm9sJLe1NdozC8mRP6iC6aal2+UKXCazmDRQgcisZq9kwXE572MucBmMy3
	46c7hhhRxB97IFKXVsJboJbSVuNLQjeodnscbbtkKbJ9X4Aki0zG9fbv4JiO3t1hsz7sggEJB8x
	1ctC2qeZJ7UI31RDo12fzHBkWkxcQ9/1fE4PMobTr4zOTHxmonUkwYYzO4RHsuDdd2hlkICAAhj
	enm8Udbt81aGrO9GSOOEUZzenJZiw6CrM1EAW/SVBxRFLayzTxKjQVubGyG5mD2VnPeIUlG8vFJ
	lgXyiezPUO6emezzfT4dgR/qbhGIj1MIlSS1eNZ4Wddowavo3T2fQ5KPkI9916AVfc0BinMEDWz
	IE6WXH6/wHdNCj4WOw8h7Pdg8fMIhusemgJqrBA5a6iVE59ruXDQqQfQyY7QfPtoA5LW9xF3x+/
	LoQUI+D1MOQZwFvptNdCZyQNnjf7ulaILN9Bujn+BhZucE=
X-Received: by 2002:a17:90b:55ce:b0:35b:a94d:7ad2 with SMTP id 98e67ed59e1d1-35ba94d7d9emr39715a91.5.1773643890812;
        Sun, 15 Mar 2026 23:51:30 -0700 (PDT)
Received: from DESKTOP-PU4IGQQ.localdomain ([112.196.126.3])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73fc1774dfsm4218601a12.1.2026.03.15.23.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 23:51:30 -0700 (PDT)
From: Utkal Singh <singhutkal015@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	yifan.yfzhao@foxmail.com,
	Utkal Singh <singhutkal015@gmail.com>
Subject: [PATCH v2 1/2] erofs-utils: lib/tar: skip PAX entries with empty path
Date: Mon, 16 Mar 2026 06:51:18 +0000
Message-ID: <20260316065119.21726-2-singhutkal015@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260316065119.21726-1-singhutkal015@gmail.com>
References: <20260316065119.21726-1-singhutkal015@gmail.com>
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

When a PAX extended header contains 'path=' with an empty value,
the computed length becomes zero. The subsequent trailing-slash
removal loop accesses eh->path[j - 1] where j is zero, resulting
in an out-of-bounds read and undefined behavior.

Skip such entries to avoid unsafe pointer arithmetic and invalid
filename handling.

Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
---
 lib/tar.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/tar.c b/lib/tar.c
index 26461f8..be86984 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -510,6 +510,8 @@ int tarerofs_parse_pax_header(struct erofs_iostream *ios,
 
 			if (!strncmp(kv, "path=", sizeof("path=") - 1)) {
 				int j = p - 1 - value;
+				if (!j)
+					continue;
 				free(eh->path);
 				eh->path = strdup(value);
 				while (eh->path[j - 1] == '/')
-- 
2.43.0


