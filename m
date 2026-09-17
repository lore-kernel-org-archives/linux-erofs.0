Return-Path: <linux-erofs+bounces-4574-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE81FC982C1
	for <linux-erofs@archiver.kernel.org>; Thu, 17 Sep 2026 03:54:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hlhhD22rjz2y21;
	Thu, 17 Sep 2026 13:54:04 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:3b::10"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789617244;
	cv=none; b=oZR53haN+ClvXyuWYUz2GBTQzWBVCLhztWS/6NNjbsWn7/puDrNGQwkqOVpfsJYZnX0KSjPFlwKDTBKkmrADymzJq7U5Ns9X4cJn8D9+UTcZFkk/Ut6LVl2wQfD46LAZtTwbQ0G+fwGLmsSnboDfzITGv3Gr2JgMNbRa93hwi6KwBoBXCelroMrsa0fMy5wajYlHNeGQCX0VNvaQTpc72lNHhSNclA+S8n2C2r+SOGVyQHdq4YuOKrQr4bbMlKkHNL+XPXLwKSH2wsoKbdHldf4HJgsMXssx7Dis56th2Crg2pWxxyT3gwxM2yAUf579Y6zvOC9206CiZb/BPyYDAg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789617244; c=relaxed/relaxed;
	bh=XLlTrq5RDnowOv4tjQZuCYGmdFogeri990mo9bRcL28=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ofL6YBAxU5hU3k5W+EBx/JYdkUwsyrkUUvQJoiwP2Ooo2eWzkuhhwZ2kUNLuxOXrZ6A3l1Xc6R0U/6WN244rOBnVSTaJelKxF3L7rSTFuO8mo23Rkff4kWiUq5uWSOKVtRvmKI3QH1R0kXfKxg1kdCr4Cdi2P+UZCT6FIDqfKjUn9Kz+LWyUGpzu+sAEWJIZ46SQJXWnJcskIgMuzOp/Uih7YoqzicR6TMlV+rEW76yhrjkoop98V1IwNaVypIlqlDaIwJcZXC5iNws4CMIw3empAt1EH4npSTn9ijfdKsSy7LmyXXl52QGP1BetMTM7IWhGyzH+XPnz/kae71EIkg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Tbrb1XIQ; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:3b::10; helo=mail-pz2-x10.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Tbrb1XIQ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:3b::10; helo=mail-pz2-x10.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pz2-x10.google.com (mail-pz2-x10.google.com [IPv6:2607:f8b0:4864:3b::10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hlhh953WWz2xYh
	for <linux-erofs@lists.ozlabs.org>; Thu, 17 Sep 2026 13:54:00 +1000 (AEST)
Received: by mail-pz2-x10.google.com with SMTP id 41be03b00d2f7-cc1cea4bfd1so254083a12.0
        for <linux-erofs@lists.ozlabs.org>; Wed, 16 Sep 2026 20:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789617237; x=1790222037; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XLlTrq5RDnowOv4tjQZuCYGmdFogeri990mo9bRcL28=;
        b=Tbrb1XIQ3+2mOwBw4APFrRWvLYG/pmSF5/PDkxR4uv/rVfXNy8trBgc3/eIcqOiL+i
         pizormg0Eb478Y/5Cy5PQQTnrGDeVtTXwL+TvovQ3Gs4glBq02Q0xcyUcimCLO7ZOTv5
         LbqMZDhn9jC7S+3PuM+12qxL7GGJUStklAMGlcx/FgAJZOj0dMkkFqeq1yj/7a1vWL9w
         V83suGPJRsYNS6bb8sNtu7KNQ40IsuvTesQnq+P2bC+BN0ns+ybw7DnHqoRr063DNski
         N4nDZ0DodEYXgXTmHQtouu4Ftwezu9eunEMT8pUE/8LiH2oWCo54F2qM+dYvbiG3dPBF
         zN+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617237; x=1790222037;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XLlTrq5RDnowOv4tjQZuCYGmdFogeri990mo9bRcL28=;
        b=XRwx6bSx2v0POrL/3S2p9seCLOp70dYEDDX8qdHoXg89nP2e0nDBso4DIhD2p6QzkW
         BDolLME4BdwKoEGKfPwmK2E81Dpoadc+agude9KfhxFLLLC1mkvdZvfiyKCdysuhhTVP
         JEM0rB3QkkxvuDlWdMCg7cEfRMv6um01jMr5qmAek1XP5lPYQsUTm5h9eAAKSSbQfyZa
         jEhPqW3t/Jn2gZbz80sqR7J6O0pHAcygN8HeMKW8gRmEDer9iJFGStgPaBTeYt4M3JTh
         ZXshIEWi4/gWqXYq7GH9ISfmifU6Jv2V9x2KgTyEwMLnGJox5VGpu/aZgdtGqEKFTVyH
         ZdUQ==
X-Gm-Message-State: AFuF++l2E3eWxSoJwHPPfofuIX1srCJS6aMY38ga//rM3DDDBKcUxQGg
	GdtwDnIsXAI6yReaUttqlQ/+GdiKXaV12idoJBGYAd90Esavu73NqDFzFwQKHAtRHdk=
X-Gm-Gg: AYBFou0x6gQxxkiLeGZxQV3O6oiY4SQ09QycZBLbXctiIqiH37AqyFFGkFAPavcwnj4
	cfaoWLvXDVbhElRHzSF0BJRpINTxjMUDmeTNrVd1cGtWj1lN24AonAAVqJXwZHrXdLRAcClMoMo
	ijO6rgBnkaBnzctGw3V/t3LIRvE8LBmExhkw9U2yeLnVzBB8eCxH8HMr96YX7ifk/uVKzEXMROh
	HhSoO+U9pv+YuE6UehkeJlYFh8TeMW1+YmsSHQgrr66ONYxo2vTehsrjPQs+6WO9XzloAjMJAgp
	XLhiMEGSZq18arNUW9qRGKhMIW1TSp5Blu/j89i6a6y1k5f3RC22DHaoRefs+wWCkMiUJhR0GX0
	Rnk9KFyojWBg/SaflxtVdcYEIqRtX1zUzCWkXDUS5t2Tg1TjLZEefZw2QEdF5glP9oXgEwdTHHx
	xALiZzWe3NonB0eBrqhYjR373kQZjXN9hpy4w0nsSGVKWWja9xJeuUTxFn8RD27O2egP1GiRGQA
	ljlq9RiVnxzAmJj1LkZ8d3Xkf1bY9w5BktrlQCZYYDG2joWAw==
X-Received: by 2002:a17:90b:2ec7:b0:39d:f317:44cd with SMTP id 98e67ed59e1d1-39e1e4907f3mr16534838a91.14.1789617236961;
        Wed, 16 Sep 2026 20:53:56 -0700 (PDT)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.58])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89ee3557sm19423245ad.52.2026.09.16.20.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 20:53:56 -0700 (PDT)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Yifan Zhao <stopire@gmail.com>
Subject: [PATCH 1/4] erofs-utils: fsck: fix hole handling during extraction
Date: Thu, 17 Sep 2026 11:53:46 +0800
Message-ID: <20260917035349.1339521-1-stopire@gmail.com>
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

Fix the following two issues in fsck.erofs --extract:

- Trailing holes leave extracted files too short.
- With --xattr-inode-digest, holes are hashed without advancing the
  output offset, so subsequent data is written at an earlier offset.

Assisted-by: Codex:gpt-6-astra
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 fsck/main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fsck/main.c b/fsck/main.c
index b2d8f1a..55da9ea 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -569,7 +569,8 @@ static int erofs_verify_inode_data(struct erofs_inode *inode, int outfd,
 						(const u8 *)zeros, chunk);
 					remain -= chunk;
 				}
-			} else if (outfd >= 0) {
+			}
+			if (outfd >= 0) {
 				ret = lseek(outfd, map.m_llen, SEEK_CUR);
 				if (ret < 0) {
 					ret = -errno;
@@ -855,6 +856,11 @@ again:
 	}
 
 	ret = erofsfsck_calc_inode_data(inode, fd);
+	if (!ret && ftruncate(fd, inode->i_size)) {
+		ret = -errno;
+		erofs_err("failed to set file size: %s (%s)",
+			  fsckcfg.extract_path, strerror(-ret));
+	}
 	close(fd);
 	return ret;
 }
-- 
2.55.0


