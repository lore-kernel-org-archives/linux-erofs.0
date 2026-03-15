Return-Path: <linux-erofs+bounces-2708-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02F5CF3026D
	for <linux-erofs@archiver.kernel.org>; Sun, 15 Mar 2026 16:02:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fYjfX5y08z2yYy;
	Mon, 16 Mar 2026 03:02:28 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::634"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773590548;
	cv=none; b=lQF34hd2gW7eDG0jm4VZwmhm6kW0iavTqTHUOYH1HpAmxowZsxOtNpZQEWiwIk/cZizJEXloPpfiebU6/aMmhIEKw6Etx111wf3xwZHUj9m/+gL9IVim9EDloBTNWm30D2UJgMGEUc0g5DwACXEUB0uupiU6Td2nvzAMuK2v1joQR4mF6Apmp+svufNkEpuc+9VbwPAhqpyRSoAmM2CqYvFUj+fgxQ/bbasESogaAbwKfOlS7Tl/kvQyU9nE5VvT0l78VVJLG0XXvvwP3wv55mZO5eEjo2YPQ1QKJxmdvMufZkSBGv7kZ61OBaDqlp4tL51MO2PzVduU1T7irNbA3w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773590548; c=relaxed/relaxed;
	bh=yIaTK3j7L92EQ/m6Tsh8zAhnvokoMeLHxx4+LeGDxnM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CaoiDwG0C31jvJe/VzfSqDn2XJ8AIDpg4WfJ8r8dn6Pj+xr1Bo9QrS1ogEFMCKdEGkCcJOy6tMhpFGIxvvu6D/RZ/inPYgTeTWa56z+4mf4UUnxoLljVTkeqAevVi+yL1wqjvCgA7NeQT8mfsD5jNzkNVu+BVT5UzRKjow9S8PDWheBKJBsavjR1YwAV8Xf30MPN1zlCluhpIDrjI6VuRooAPgQfqzso+W7iABLKOBD2Tzt3bza8Yb3ZKdBKiZYPMEzgA9vK3Z84rMf/7bzjNs7WMVSJ45KF46bezVuZuZi1+FS/QMr0kh35DhBV8WSZXyxgEUBYzS8Bb0xcmGLuhQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=ks7wv1Vh; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::634; helo=mail-pl1-x634.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=ks7wv1Vh;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::634; helo=mail-pl1-x634.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fYjfW34W1z2xSD
	for <linux-erofs@lists.ozlabs.org>; Mon, 16 Mar 2026 03:02:26 +1100 (AEDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-2a8720818aeso2207505ad.1
        for <linux-erofs@lists.ozlabs.org>; Sun, 15 Mar 2026 09:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773590543; x=1774195343; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yIaTK3j7L92EQ/m6Tsh8zAhnvokoMeLHxx4+LeGDxnM=;
        b=ks7wv1Vh5qpqWfU7pApkH7IgdE1GssizYffe+RhgmSKSACpZ+2K0N5OtykyLlc+hGV
         EcSuUFw9hHGZ9lr6Bi1YHQIu/RUUxdedwIgasyEkw8/KCqsocXceI/Q1Qe09lG4jzxge
         3S4c1gbxrMD6Q0aPaXlcYKv+931OODigNRZbUwRjmO/mRjX4uLuK6sxz/1QHsZxXg/uZ
         6dN8lCIgTQHV90Yolwhd7dQ/Ud3aVSa/ix3M7yRnWOjqN8LpmOg2rSUfhgzoM71N0idm
         A8A6mpeompvswa8rNZjul5skKIYAo5ugPkDrrYjoxQ8WxtdLT5h1GSmZhk4qJVerU3Dx
         FB2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773590543; x=1774195343;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yIaTK3j7L92EQ/m6Tsh8zAhnvokoMeLHxx4+LeGDxnM=;
        b=m6QzXhXJ7vUucoR06pz8lOcer8IaDL8BPZXVKq9MY/Fjq+UvlwimbEpAVOtGdjpbys
         QJyOpCpMNeoVHMPfzKf+O3N11LBXG84aUSwuqEcYB+lwjgP7bu4orA6/HcUxZMLsw49Z
         BBeACMlUMPZT4zrHcT+e+VRUtTt424SMq99WuUhuAIjF/HOiX8c0vct192HPg918IPSm
         zPdhYKPyPQS6EDdwf4VcYLjVne4fv36UJFzKqS7X8lX2hUDAXn04n0PxSU1ww2E1hS/8
         WatDnnchejiocteRD2CpIV2tVqCzp9be166TJiyIbjWNh88zkI3wlyDuMJ2WeXA2FwZ3
         B5Cg==
X-Gm-Message-State: AOJu0YyvMfm08HgAJsl3WWVI0f6zIQAFbIfyPQ8IPXQbBuNtuxDe/LW6
	fr/ehe/ZdU8g8P1y5GV9A+7f3UvYdGomApYXEikkTQnPmnXEqpD3D60d10dqkG5H
X-Gm-Gg: ATEYQzzUOXp5clLKA8QzLOsvfIPLCaSRiY0MtAm16hQUHvfgSaupvnkPjeXhapSVxjL
	/1u841Cq3rNfQEXKz20YvYSuFzP8oSqDa5WyxXTq5XdaECEXofCjqwhD5XxYw0b9eU7Pmup8mSp
	JAzF84U7dQyMSUKL1QGFd8Yoxtf7z8m02/PE/Wu+SZQc8Qq+B6dh3etgjMR5H9SieDBJaBeG9UO
	3p+LKlMB7vsk5b/Fv0SbzRjq6T4+xna5FNdo/Q8rQ8t/xOm74eZGZKEpd5IbRPv1Lhq3Cf5n28e
	50YtIkyzpoJpvorudvkOZGVHRYOqkCK8mBC7sY9nh42MHNYc4+DUhtI2sgOEqCDYv75cjU03k0p
	M029hGBOAtWO2UAg44p5Ym1Vhb905OJSbU29rrVHPmAc8Axvny6aY57ZLI97BCJrRP8hjk/5F1x
	wY0QUSxElIbGbxjTjEqHnEyG6kVeFj0x2JrR1xdcie8bgA/t5aTr2VZuguWZ04Pp8MBabg7BfHY
	Ebb+UEjH/ijNfwTlWEZwWjpm9r7JishWB0Ziw==
X-Received: by 2002:a17:902:f70f:b0:2b0:5075:96fb with SMTP id d9443c01a7336-2b050759903mr17416695ad.2.1773590542990;
        Sun, 15 Mar 2026 09:02:22 -0700 (PDT)
Received: from DESKTOP-PU4IGQQ.localdomain ([117.203.246.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece62c701sm106867365ad.37.2026.03.15.09.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 09:02:22 -0700 (PDT)
From: Utkal Singh <singhutkal015@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Utkal Singh <singhutkal015@gmail.com>,
	Utkal Singh <utkalsingh059@gmail.com>
Subject: [PATCH] erofs-utils: lib: fix wrong NULL check after erofs_balloc() in metabox
Date: Sun, 15 Mar 2026 16:02:16 +0000
Message-ID: <20260315160216.17079-1-singhutkal015@gmail.com>
X-Mailer: git-send-email 2.43.0
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

erofs_balloc() returns an error pointer via ERR_PTR(-errno) on failure,
never NULL. The previous check:

    if (!bh)

fails to detect error pointers since ERR_PTR encodes errors as non-zero
pointers near ULONG_MAX. This causes PTR_ERR(bh) on the next line to be
unreachable, and the subsequent erofs_mapbh() call to receive an invalid
pointer, potentially causing a crash or silent memory corruption.

Replace with the correct IS_ERR() pattern which properly detects all
error pointer values returned by erofs_balloc().

Fixes: 7928074b7643 ("erofs-utils: introduce metadata compression [metabox]")
Signed-off-by: Utkal Singh <utkalsingh059@gmail.com>
---
 lib/metabox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/metabox.c b/lib/metabox.c
index d6abd51..12706aa 100644
--- a/lib/metabox.c
+++ b/lib/metabox.c
@@ -127,7 +127,7 @@ int erofs_metazone_flush(struct erofs_sb_info *sbi)
 	if (!m2gr)
 		return 0;
 	bh = erofs_balloc(sbi->bmgr, DATA, 0, 0);
-	if (!bh)
+	if (IS_ERR(bh))
 		return PTR_ERR(bh);
 	erofs_mapbh(NULL, bh->block);
 	pos_out = erofs_btell(bh, false);
-- 
2.43.0


