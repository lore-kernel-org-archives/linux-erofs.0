Return-Path: <linux-erofs+bounces-4291-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DA96C5DF97
	for <linux-erofs@archiver.kernel.org>; Sun, 23 Aug 2026 14:24:04 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hSbrf25V9z2xrL;
	Mon, 24 Aug 2026 00:24:02 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787495042;
	cv=none; b=ErHZLZg+EDjyHmN1QpHskirdxNr4UjNyZ1wml473ZPMO50e+bTBt2MceeteNxvMdnYRRTZkZ/+Zf47w/xnWVIbKXBAA7JcnizRayb5qA7G/TquuhlpjxvJWvH9YQOI77whi/PHqV3JLZoXeRuPnF85+bp5USLFDY2uxVqCEirMJAUsjyrnF24RGdEtpFKjX7qFyFfeF1TruVKfmYswYU+eYXdA1UxowQgGTD3X7FhcqrnpnDhrb1whPNqLmHn+xki3YeY9byiYsro/NM8OvCUokpj81kjy+tuKDXBF94tpBcAKBRTgcAva0Aa8hSxTVR+PxQbWnXrH6jQJtQM+lbHg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787495042; c=relaxed/relaxed;
	bh=DYRwqfm1gCvsAIADhSTBb7bhsQccw0Dp6UWHLBZIMBo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PxjukXRjs/mfLlnjVrhW+0emhBrpo8nM92FVHlDBBebBJzxT0Wm8yeWJ2TqVuYGkgHvDmJz+4z3xJpnkcbHmtukXD0XHIqSJPjDOz77h+vOCgShS1mq52KhAeycOPQcZ4U6hRd/SDSvMR19C5FQhrTIiYxAYcZixXoMvtj3/fR2CAyy02d7NH+Gn9lHs6/pgd/GC2MdP+2QLHh7Wl51ysfTYRoIFLo7q9JBmKH7Fm5mebO+PlJeXU6ETEMkIIyp/GSKWm5aDYP9uU6ZnySJIi+QiSis6DLP1QOrXGjfcWn5hBbScH9+ueKjE+zdjCJJJBl4kWVIQKmIJBfwZBZW5mA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KFowHqWe; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KFowHqWe;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hSbrd14JKz2xnQ
	for <linux-erofs@lists.ozlabs.org>; Mon, 24 Aug 2026 00:24:01 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A923E41984
	for <linux-erofs@lists.ozlabs.org>; Sun, 23 Aug 2026 14:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC2D1F000E9;
	Sun, 23 Aug 2026 14:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787495037;
	bh=DYRwqfm1gCvsAIADhSTBb7bhsQccw0Dp6UWHLBZIMBo=;
	h=From:To:Cc:Subject:Date;
	b=KFowHqWeVK5IrSzEtV86Wiu9AdjJApd2cqnOj4Oef42i58j9SqYLn5HYMxZHvNhP6
	 zEpxNoLyl64MlwYC+1xfXH+48M62jKm++HzJRkRufCfxopg4h4VFl23R2gEHLTcLBL
	 X0PMDkGQdrIbZG4dtruutdFV6vkCwDhImuSEZenEh4tDdwV7PxAoIubeigwKXVHAhE
	 7J5jYlpPG3XtT26oIxgO3F2PldoxWM5QkJHV8wpqxWOZL4LDv/2LDHQHwVTzlts2CC
	 f37Hq+yf93tb1/5x5bw9st7pkJShqKgyiLfPcHdNg7R3Kj8LWK9SZvPnNT9atKUJt2
	 XqVLwRVVjl6Fw==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH] erofs: simplify z_erofs_gbuf_growsize()
Date: Sun, 23 Aug 2026 22:23:05 +0800
Message-ID: <20260823142306.42533-1-xiang@kernel.org>
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

 - Use guard(mutex)() to manage gbuf_resize_mutex;

 - Nullify tmp_pages after successful allocation, so that the error
   path becomes clearer.

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 fs/erofs/zutil.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/erofs/zutil.c b/fs/erofs/zutil.c
index 6b9bfa2ef3b6..960cfe86eeb6 100644
--- a/fs/erofs/zutil.c
+++ b/fs/erofs/zutil.c
@@ -70,12 +70,10 @@ int z_erofs_gbuf_growsize(unsigned int nrpages)
 	void *ptr, *old_ptr;
 	int last, i, j;
 
-	mutex_lock(&gbuf_resize_mutex);
+	guard(mutex)(&gbuf_resize_mutex);
 	/* avoid shrinking gbufs, since no idea how many fses rely on */
-	if (nrpages <= z_erofs_gbuf_nrpages) {
-		mutex_unlock(&gbuf_resize_mutex);
+	if (nrpages <= z_erofs_gbuf_nrpages)
 		return 0;
-	}
 
 	for (i = 0; i < z_erofs_gbuf_count; ++i) {
 		gbuf = &z_erofs_gbufpool[i];
@@ -89,8 +87,7 @@ int z_erofs_gbuf_growsize(unsigned int nrpages)
 			tmp_pages[j] = gbuf->pages[j];
 		do {
 			last = j;
-			j = alloc_pages_bulk(GFP_KERNEL, nrpages,
-					     tmp_pages);
+			j = alloc_pages_bulk(GFP_KERNEL, nrpages, tmp_pages);
 			if (last == j)
 				goto out;
 		} while (j != nrpages);
@@ -101,24 +98,23 @@ int z_erofs_gbuf_growsize(unsigned int nrpages)
 
 		spin_lock(&gbuf->lock);
 		kfree(gbuf->pages);
-		gbuf->pages = tmp_pages;
 		old_ptr = gbuf->ptr;
+		gbuf->pages = tmp_pages;
 		gbuf->ptr = ptr;
 		gbuf->nrpages = nrpages;
 		spin_unlock(&gbuf->lock);
-		if (old_ptr)
-			vunmap(old_ptr);
+		vunmap(old_ptr);
+		tmp_pages = NULL;
 	}
 	z_erofs_gbuf_nrpages = nrpages;
 out:
-	if (i < z_erofs_gbuf_count && tmp_pages) {
+	if (unlikely(tmp_pages)) {
 		for (j = 0; j < nrpages; ++j)
 			if (tmp_pages[j] && (j >= gbuf->nrpages ||
 					     tmp_pages[j] != gbuf->pages[j]))
 				__free_page(tmp_pages[j]);
 		kfree(tmp_pages);
 	}
-	mutex_unlock(&gbuf_resize_mutex);
 	return i < z_erofs_gbuf_count ? -ENOMEM : 0;
 }
 
-- 
2.47.3


