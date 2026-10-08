Return-Path: <linux-erofs+bounces-4680-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 238A9CA600C
	for <linux-erofs@archiver.kernel.org>; Thu,  8 Oct 2026 15:43:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j0vR42cBYz2yWy;
	Fri, 09 Oct 2026 02:43:28 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791474208;
	cv=none; b=R568S3UNhbaQnIH1sTQ7VSO7IHdCbFVob1gSVwVJiWXT4ygoyzzdh2DdIeK0VYF2fxoEcH7j5fXIkWgNOSF0TU6ZSxoNNpWvjz61aC+wG+r0Ngr7FLxG1YJlNtcOnVtGBx0uhaX+bkqx2e0AoxaA2TK26rdeUNSW2Y9EQDyEdGtdQFNAGIdjf3E9PVpkO79Yqg9/e8wjn8TJIt/laa/1sDnhvcPFvSS5E8ksxeWdYMsfqD5AfbQLz78jpuFjns09PeCHKqXU6/NcJuwsMKJM4dz49FbOhWj3LSQ0xgC4gdJcxqT/k2ZIX18maU6Ks7XM/FJwMwk1yKFdiWeUR0VV7w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791474208; c=relaxed/relaxed;
	bh=zpaywRIMLozy2Gnj07rhjD6HR4RIDSFFI3XZ6vDT+/4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=OFbID83akvdPwWm5WFd6UZikKB4ShBbW0V4omAWPCMgkJ+Dwq65+gw5ACm0kOUuWt6Osu/tHvZoXDIueIzPih9TUHb9VaNrHny0CvvBKK3U4ENUne9BRHAL9vwl1DPkK9Iv3KpIwfjR6p9UIn2S6iT3cq0bLIDWlDIY6320ajJAQc12vrWcDjDMi/y9zmSFsgCVzt1jRyaX+vKyOCG2iIyNcPwb2qnw4KcduK08CMfjK9vHZE9pE7B/AmbLIxuGD7/uUjMlafseNdfJuAg9cWROYSlMczdKmoIrGeLUzXrHzXe2RaHy5r/nIR/5k498WBR0dqQ9qOB4yRuXaoQlTzA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=uvaBebGK; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=devnull+sadmanf.meta.com@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=uvaBebGK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=devnull+sadmanf.meta.com@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j0vR34wcMz2yMn
	for <linux-erofs@lists.ozlabs.org>; Fri, 09 Oct 2026 02:43:27 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BD0F41645;
	Thu,  8 Oct 2026 15:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D8EBC2BCC7;
	Thu,  8 Oct 2026 15:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791474205;
	bh=58WlZwRdoDNV04QPEm7qCQVQBGqmODxWRZtMn8B/zj0=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=uvaBebGKKgTWQwwLA4Kq1lUbYyUMnLaKbUEr6uVi6JCTE2udCLDbDR9TZIjl+kBsd
	 DkK3H5kxiEOhxQAnW2jv+SX0onLMly/5CbpniVTgmAkjD02DW57C0KvTlPQy4nez2E
	 KNIqgEo7m6itK/O5fDN9A3tJs/Vi9pAjy+9RvcAu76eKoF3842QS4R59QUG4yHJISc
	 Pux4VdWu6c6wPJ79DZlxlv7pK2iRB0piSsZJv8Y/2Ufc4VrDHJ0K93i+myQRpzg+w3
	 fvVuTR/NrKlY3OgaCKYNR/LgNNeDkxbgkrE2jBX8rHTEwmG8qm8L0cM0h5bkoesNo0
	 WBbara/8xSIEg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372A1CA600D;
	Thu,  8 Oct 2026 15:43:25 +0000 (UTC)
From: Sadman Fahmid via B4 Relay <devnull+sadmanf.meta.com@kernel.org>
Date: Thu, 08 Oct 2026 11:43:24 -0400
Subject: [PATCH] erofs-utils: lib: fix null memcpy source in xattr listing
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-chunking-xattr-infix-v1-v1-1-4a7736c35081@meta.com>
X-B4-Tracking: v=1; b=H4sIABu6x2oC/x2NywrCQAxFf6VkbbBT8Pkr4iIzjdOgpiVTy0Dpv
 xtdHg733BUKm3CBa7OC8SJFRnUIuwbSQJoZpXeGru2OoW3PmIaPPkUzVppnQ9GHVFwCBnJ76ft
 4OBH4ejJ28y/f7s6RCmM00jT8eqNJFt1znfz/zTrTC7btCywIiu6PAAAA
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org, jefflexu@linux.alibaba.com, 
 Sadman Fahmid <sadmanf@meta.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791474204; l=1493;
 i=sadmanf@meta.com; s=20261006; h=from:subject:message-id;
 bh=Pxsl8oq1y4OPZ92O817gqL4x+XdL3uXSkj2LWJNTIfI=;
 b=vtF/So3GsAVXGSW4c3VQ//9c993L8s+do1m3U+o2ElsmWUBTar6fSQXhYlojQrlH8Z2heBqqv
 FhTUs9KUL80AzKMlN0IULYWgnrI0X/2NIh43g3SAc54o6RUJH3RU7r8
X-Developer-Key: i=sadmanf@meta.com; a=ed25519;
 pk=Pc/arXJpm1RPef8qImFuHROn1p3XNX5MWSUxjZWNTa4=
X-Endpoint-Received: by B4 Relay for sadmanf@meta.com/20261006 with
 auth_id=1125
X-Original-From: Sadman Fahmid <sadmanf@meta.com>
Reply-To: sadmanf@meta.com

From: Sadman Fahmid <sadmanf@meta.com>

Xattr listing passes a `NULL` infix to `memcpy()` when no extended
prefix is present. Skip the copy when `infix_len` is zero.

Fixes: ac3b2b1f5d03 ("erofs-utils: support long xattr name prefixes for erofsfuse")
Signed-off-by: Sadman Fahmid <sadmanf@meta.com>
---
Tested with Clang 21 ASan/UBSan. Build an image from a directory
containing a file with user.test=value, then extract it with
fsck.erofs --xattrs --extract=output image.erofs. UBSan reports a
null memcpy source on the baseline; the patched extraction succeeds
and preserves both the file content and its xattr. Leak detection
was disabled for this test because fsck has a separate existing
xattr ID allocation leak in erofs_init_inode_xattrs().
---
 lib/xattr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/xattr.c b/lib/xattr.c
index 3cf8c79..d86d94a 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -1291,7 +1291,8 @@ static int erofs_listxattr_foreach(struct erofs_xattr_iter *it)
 		return -ERANGE;
 
 	memcpy(it->buffer + it->buffer_ofs, prefix, prefix_len);
-	memcpy(it->buffer + it->buffer_ofs + prefix_len, infix, infix_len);
+	if (infix_len)
+		memcpy(it->buffer + it->buffer_ofs + prefix_len, infix, infix_len);
 	it->buffer_ofs += prefix_len + infix_len;
 
 	/* 2. handle xattr name */

---
base-commit: 50c29ee8d0f88fcec28d492d01eb7ca8715f5961
change-id: 20261008-chunking-xattr-infix-v1-1a0089ddb57a

Best regards,
-- 
Sadman Fahmid <sadmanf@meta.com>



