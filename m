Return-Path: <linux-erofs+bounces-4677-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49DEDCA6004
	for <linux-erofs@archiver.kernel.org>; Wed,  7 Oct 2026 20:49:22 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j0QGS3CyTz30VM;
	Thu, 08 Oct 2026 07:49:20 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791406160;
	cv=none; b=YKxrvTHMcWMXdxL3Go07iyDRZaLY++ruG7u1nvjsFswJk7fsIFWyFO7h1mfcC7ECCVJcF7v6OL0+DHdrUp8KgcBFaFVZCrIUk+EIMyC+0JvYg8J9ZZqaPDzDtAatGaUuTdajf4imGLyQkf87aAq9UKpNM8Bv4oKV6r2HG60+GJy1MKWEkRK7YgLTR+SWMlkh0sso77cgrFVNtueKZLC8uT3jFL1FncT5GxdXZN4VQw6WT7ivEmHJsYXQwBWCZa5J3drggiOTa8UHnGFbflABcbZ9FTogCdtqPVXUcOj9w1pmWvg+XDOwPy9T7lrqtBKo7YpP97kF+TgeTjfNnsMqLg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791406160; c=relaxed/relaxed;
	bh=9rMeD8MlOFxmU3zk0nk6XtJsDAttl45lqVJfzxlnln8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9rs8Lg6Tz8psIoZJXEbv/HXR/BlLMyNNzehxNTbv+51sF2rfkys/jbpqsrgHnC2jkyylCiry8amRjsxTAE2LN9PT2GEmaoFeswwOTTKMIyJbPMhZe3zr6RTb0LjS+UnpWiRHJ6XWg4C2GBN6EH7vJEi/7gA0m8R/U+nB87QinIc/fEtlVJImpvDJBcCG/kSNubHWgd7Ndb+4b09w2xdd3e2WFs5WUnLTTTZu1IvN7dxXtQ0ST40dQLKK8iJiNnVlSCSgaq7E8tqZphLRdfjfWlEHDOs8fN/ZYzdEb/tTCtKt47PgFsF1Glmw2yRbdu27zBV7B5j8X5Ak+MbcFyPMA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xm4Rhv7g; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xm4Rhv7g;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j0QGR6d0yz30Nl
	for <linux-erofs@lists.ozlabs.org>; Thu, 08 Oct 2026 07:49:19 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2F4E43990;
	Wed,  7 Oct 2026 20:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDB11F000FF;
	Wed,  7 Oct 2026 20:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791406157;
	bh=9rMeD8MlOFxmU3zk0nk6XtJsDAttl45lqVJfzxlnln8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xm4Rhv7g+/qmQEw9Q6RhOCvS9qBOIb81YM4DTL9YAux0MgWNOS5H/1q2pksCIZ+Qu
	 z8/4tsrzWXtFKZG38wp6apWZGQaFAcf7FF6eTgL9tufSw5Jjju4M4sixEJeAfZzV8o
	 b0zRA5sOQASI/4Kmir8k4m7bJM9bldQmERFktpPvDkA/Fefcz3PGAIklFRX2ZRla5Y
	 5udviNHT0K2v9+hVX6KbbSVZkbEhbGbwUEzJRd7boKbbOPTMsjEY/MuBBO834sy5yS
	 K+TPe4bIWI20sYYpzXzXJBb0d4ipmvS5DNCcUyBQI059Os1OyKw9t8/10JteB4cKlh
	 PLSLscOklBXBQ==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Andrew Gunnerson <accounts+github@chiller3.com>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH 2/2] erofs-utils: tar: Fix printing uninitialized memory from xattr value
Date: Wed,  7 Oct 2026 22:49:09 +0200
Message-ID: <20261007204909.19426-2-xiang@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261007204909.19426-1-xiang@kernel.org>
References: <20261007204909.19426-1-xiang@kernel.org>
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

From: Andrew Gunnerson <accounts+github@chiller3.com>

Link: https://github.com/chenxiaolong/erofs-utils/commit/093e9db89dd78c9cbf77aac26370d385c6a55ecd
Signed-off-by: Andrew Gunnerson <accounts+github@chiller3.com>
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 lib/tar.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/tar.c b/lib/tar.c
index f24ad95..560036e 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -416,12 +416,12 @@ int tarerofs_apply_xattrs(struct erofs_inode *inode, struct list_head *xattrs)
 			continue;
 		}
 		item->kv[item->namelen] = '\0';
-		erofs_dbg("Recording xattr(%s)=\"%s\" (of %u bytes) to file %s",
-			  item->kv, v, vsz, inode->i_srcpath);
+		erofs_dbg("Recording xattr(%s)=\"%.*s\" (of %u bytes) to file %s",
+			  item->kv, vsz, v, vsz, inode->i_srcpath);
 		ret = erofs_vfs_setxattr(inode, item->kv, v, vsz);
 		if (ret == -ENODATA)
-			erofs_err("Failed to set xattr(%s)=%s to file %s",
-				  item->kv, v, inode->i_srcpath);
+			erofs_err("Failed to set xattr(%s)=%.*s to file %s",
+				  item->kv, vsz, v, inode->i_srcpath);
 		else if (ret)
 			return ret;
 	}
-- 
2.50.1 (Apple Git-155)


