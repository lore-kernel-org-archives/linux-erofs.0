Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0007C606A31C
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Nov 2026 07:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bt5DAlfs
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTGX75hCjz2yDc;
	Tue, 17 Nov 2026 18:27:19 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::42b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794900439;
	cv=none; b=c2/kXvWhOyxFJ4gH078vZKuEECUhWpf+cjD1SfhuC9NCOUVCk4a6v3wLcFCt+DR398ug42SULwilHwCBVaEpqY5aSKKYlFtWQJxXt1Z8uOxdi0qPsC+69C6jlcuoN8P52RTVwjchTMMrXl8tVqflpIWML6KJ6Eb9qdH07KvU7zsy4ekoFYJ1PSv+37FkN8Znv/uXRilNEtZCs59JoZ4UvzGp2E/lMyPtXYKasg9zZmXOkKldhRKCQOIcxuVqwboJuq37N+nbp5xu70gxY5Lz47RT3XlIKT3nlIjpeQ7WkOOdztlz9bRQaX5lnyMo//HXZf06daU8/i1oG5ONzF9TPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794900439; c=relaxed/relaxed;
	bh=J86r6FThI6DtLCNmBjeYTLCokWyMce2ndHyeeqE2eR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jruVBwUCqjWr31CSooW29QBgo2TgrMNRGvW2Ht1CZ6sNJF53MqOnmj44WS/fDaWsElZng+ken38DXACV7rApxK2StdttTC7ACsV/PpJjBN4C9VMt5/42DFfN3zc7UB3lI7GsyLWfVtcVtVO5Cz9taMTgrtCVQXe62HJnThEGlcrJfQ9z3dGbWEyQMKfg56WOF3lc9G3m7tJtvyOx91A/WoC5KYHh0W1uUfs0MVV07N7xfNb9znX4pxAUGmQVywITaSWFweyPPYvAn3bjQkWZRTy8HFTuyKUMCjFFeu78em+dnLszhi0AQES9/aUeyFpuPdoyw2ZDmoZhcSrjr70qpA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bt5DAlfs; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::42b; helo=mail-pf1-x42b.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bt5DAlfs;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::42b; helo=mail-pf1-x42b.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTGX70xRMz2xPb
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 18:27:19 +1100 (AEDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-8b2382bf051so2421028b3a.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Nov 2026 23:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794900437; x=1795505237; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J86r6FThI6DtLCNmBjeYTLCokWyMce2ndHyeeqE2eR4=;
        b=bt5DAlfs8QJW14ak/qY7P5tXzyKNt9+VUuuJ5xcEaIUs5guAdHy4ioqr9TMnZLxt+M
         Z1flceqVWc8dZgZPQ8zqOx7xiLZaDELMg9h0Xdzegiagr9BGf1APcEE3cfJyfcV6qiMN
         zsCHFycOwsyfGqJfyF47ceyzacJD3oALeAQdYsYSMbn07u/3uMF+nxHNcvsGrNiMDh76
         mUn04W/8V2fcmmc7+kr5kvnR/qDd89L5y8uqxXe7YWiMzMq3HUnfzqqieVUXJzLaVAEk
         ONFvoDxAdVdbJ/6bZlfFKrbVMEFNz+EHg+/Bb6BsVkJcaPUWtzZcXtIoD+KnOFaX4zgb
         2rzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794900437; x=1795505237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=J86r6FThI6DtLCNmBjeYTLCokWyMce2ndHyeeqE2eR4=;
        b=T0+jd8MEKK9ZKZRAMsOVaZ8quj18qfI5OdPW8gSAHieEgD517UZmQ03dOxOLuN+Z/5
         PeqzamD52lh97829CWR34nYK7Q3wq2tdU9ZOkVrNDnoz/lMHtGD3iWTFJX/TrFzWo26d
         +zwg3GQnSnS8/dzpcyD0FVr0l+R8yaLhek2VrJmAvO57NpfwslUUS9Qv1Z4Vb1BByZhs
         NG9YeVujEozZ1qU28e9/RIqoD1X0UTbfxB4WtChkZh0IB7Ye2BR0KoXMUaHBwGRlU+6Z
         65z9lBQj1S9pr32Io2Re3htGqMKrhq8aG4yKNlNZgGpyCmFJC4di8vxm0wRbTCeAlorx
         T6ZA==
X-Gm-Message-State: APuU4Z96ZMAYsI/6twCujEyXXRTow4wWO7SnL1EGRn1fgKlhFC8Hz+tw
	OfROKIBRjVg1s/XIABseqxb8pbQbKdA+JqKSRrPNmbZ3M4eCjk1mvl2kgXc+oykbFRE=
X-Gm-Gg: AYBFou29dBqlWt8HhMBY/YMNM/1hlPVLB1WOaDpOcsAVirYnCYKiyjQby/+bcqQzitl
	65QJ2iMnWzKskb75cqO/5I2e7dh4Z7QPYooRivjxFSWoMc9UQBuuzfeFjKkkNwpkvo16+lYzyfh
	vd1ww/6b5yW8nc0E1nTGtWcFNArjJPERCU5mK9+fkK9Klndjz3fzc52wGaGmk3AwVVKwNFL4krH
	bIY4DP1t8IqbU5GeQ93OWAfTgDu6uumhTPIqCbE0PPH53jOjITG59O0vAxoarN3y+ONBT6Smr+H
	gS03jMa0rIyYKbg4C3AEu+WdmaGThrjgTm3P1ih2+os9u5qzoFllaezLgn2GrjAYztGdHCmlARw
	eZ1wrU2sG0xI2/NY+G+mmqKHx7GxTdmRo5tkfc4+lHTJS33PFwm7xLvPHV7+GFWsc+SSPestqNN
	+kcY1ZmQuXVKrfRS6G2XzqhQ+GyW4wliOuzxTiG1rQ/lEot/SCxA9VeEOolszMLpdveWiRiXWsx
	8XT7QxWTDVcs6v14SOJRwAHjR+EqTZnOoJDoWpOhyhFexrhmfjIRppNcxM6Pz1FMq7E9G5svOys
	6/8H6c+5udCrPcZS1hgySSlovs8O6jQBT5RHVjQQijJV1fdN
X-Received: by 2002:a05:6a00:4ac7:b0:88b:7712:6e21 with SMTP id d2e1a72fcca58-8beb81061aamr11073873b3a.33.1794900437479;
        Mon, 16 Nov 2026 23:27:17 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed2055031sm4940716b3a.39.2026.11.16.23.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 23:27:17 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Yifan Zhao <stopire@gmail.com>
Subject: [PATCH v2 9/9] erofs-utils: lib: bound OCI blob reads to the requested length
Date: Tue, 17 Nov 2026 15:26:29 +0800
Message-ID: <e82d7487404ff5b400bdb0429b99fea00ed5b31f.1794899782.git.stopire@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794899782.git.stopire@gmail.com>
References: <20261112124725.2774244-1-stopire@gmail.com> <cover.1794899782.git.stopire@gmail.com>
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
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fixes: ec0ae531ade8 ("erofs-utils: add NBD-backed OCI image mounting")
Assisted-by: Codex:gpt-6-astra
Assisted-by: Antigravity CLI:gemini-4-carbon
Assisted-by: Claude Code:deepseek-v4.1-flash-1017
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/remotes/oci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/remotes/oci.c b/lib/remotes/oci.c
index 948d699..3e86e91 100644
--- a/lib/remotes/oci.c
+++ b/lib/remotes/oci.c
@@ -1491,6 +1491,7 @@ static ssize_t ocierofs_io_pread(struct erofs_vfile *vf, void *buf, size_t len,
 		return ret;
 
 	if (download_buf && download_size > 0) {
+		download_size = min_t(size_t, download_size, len);
 		memcpy(buf, download_buf, download_size);
 		free(download_buf);
 		return download_size;
-- 
2.56.0


