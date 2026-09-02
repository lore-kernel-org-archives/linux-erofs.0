Return-Path: <linux-erofs+bounces-4407-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B16A4C61DD3
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Sep 2026 02:51:29 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hZS0w0cZkz2xlv;
	Wed, 02 Sep 2026 12:51:28 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788317488;
	cv=none; b=KawHAzNM9CNxmeeNIGZKymmA0QxSubUshOt1KnlS1FjyZkaP20b1ztTNWjPuHb/flnMjmlnT9I38YG6NQX+g6wSd6bDrcYVt2v4oiLx1wK6tFUZ7CPTAU23GoKXwOmLKkHk/Mf1QFMfcqBAt1IbtwfhvYkUTOJKQi9UYpTSgEze/KKxhlBPbIwfqMwERjq9lM9H3pYCYwJgD9c93VeXBXTeJuyRUleYZYKFAr8yT0Q+6dGGJl9Gr84eJWLm6k9bt386UWgex+9njvWz3L847AActJRHjINGB5Gi5QiiBCYcEpnwnnujtPM5MeOXGlZzm057NHygLznCPCURmKnNs8A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788317488; c=relaxed/relaxed;
	bh=SlJ+mfW1unT6jQd+U2S69xjW1zoJYMuKPv395eYYr74=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R9wOSUHjBbo5eu2ntbymQuN4aW0UuWF30ndWrhy4rhiU0FMk7R0SGu0uBxH/SDAIC9altgdCKhtGCQu0X5pue8hllFfOEe9KqD1VLZAOpqD7pgs8rXywKHlsnPRCGxPwuICDrtyfleu1STroTqlMG46fsDP1RItNUfLrdawGEjHBJYbOMU5luD/kxF6NECkHTGim5EvBG5O7wcYHBNd4eAjUF9eosdFfw9JoMmTl59XzbIg1+L5iLCZZlqwRroU50IRSzWmK1S7vQ6UAPK+SdmlXqDQnNeMNcUfmoNBjlO+1j+mryc7eCKEvBWeYLAoticz9LXWLvsUVQlNwQLXQ/A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fY0UbqSs; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fY0UbqSs;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hZS0t6kQ7z2x9g
	for <linux-erofs@lists.ozlabs.org>; Wed, 02 Sep 2026 12:51:26 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 25C98600D1;
	Wed,  2 Sep 2026 02:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736551F000E9;
	Wed,  2 Sep 2026 02:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788317483;
	bh=SlJ+mfW1unT6jQd+U2S69xjW1zoJYMuKPv395eYYr74=;
	h=From:To:Cc:Subject:Date;
	b=fY0UbqSs65obWiVnBqgAkRR5TVnbkdAa3z4g8PkBP7cwJk849NGDlwijEXgZlB/Qd
	 mh5ZqD282GMP0hj8jQcWLWs5pLgCay4HjPxl+QIHOIhRhmrIp85EPVpuLvx/uDWlXO
	 sn63nttedvcJUdTg+oG46WOtBcFNFGTINd7SQU6YNsEtq67xc7bIb9qbxSVL4g6HMM
	 6MAGKZldL3Tu5rSQ8ViKVCSHdu4J7UfwagjYzpBK1wogE2qOhDGWfVmKA/4pZE2+WR
	 +o9vISc8Gc/LFl+KUctvQEZy+a4q9wuPV7m2R18OPhf53Yd0ZC4VpWRbP1NxtxQZ+K
	 hDJDNFjqQHECg==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <stopire@gmail.com>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH 1/5] erofs-utils: add missing device_id derivation for flattened devices
Date: Wed,  2 Sep 2026 10:50:26 +0800
Message-ID: <20260902025031.50499-1-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
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

It will be used for metadata-only flat inode layouts.

Fixes: 0ce853a011238 ("erofs-utils: fuse: add multiple device support")
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 lib/data.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/data.c b/lib/data.c
index 1bb9269..5a17af5 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -184,6 +184,7 @@ int erofs_map_dev(struct erofs_sb_info *sbi, struct erofs_map_dev *map)
 			if (map->m_pa >= startoff &&
 			    map->m_pa < startoff + length) {
 				map->m_pa -= startoff;
+				map->m_deviceid = id + 1;
 				break;
 			}
 		}
-- 
2.47.3


