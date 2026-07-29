Return-Path: <linux-erofs+bounces-4030-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD442C53200
	for <linux-erofs@archiver.kernel.org>; Wed, 29 Jul 2026 08:55:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h95lH0dcQz2xrL;
	Wed, 29 Jul 2026 18:55:39 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=157.180.15.194
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785315339;
	cv=none; b=MByvCTMLprzJgU1JxmT15EjSw+f4ZXyGIDBMXOEIQpSqWgGB/GyZsBrHHfzRmLlKzZBdypkLj2npL2hUEPmxTofC/keyW8RfeaiNsYlyOpMKFFIxMqvmn8pI3Sh6OELTsQHJEDv7iufVumRKFnQPFMTX8NT7j8RYyZ0HeVUo2fNOJTp1sWJXIBADZuQU4qyUas2q2d99kpoxf7Ur2GSJa8GdVpbxlH5TQXteKGyBwdUPsTCSiGsUHNQ9rv4J09eXnnZaeJdLjUDDDwy+sVxdGJLP4KHq85qfntFepLYl5gjp9MDz9SfjtXHA6n/p7wnvbba1pqmc8iBgxbpryO4Xxw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785315339; c=relaxed/relaxed;
	bh=Ca3qkNHic8rR3X/AP7JbZLGtPa++G6cubzXyiDrZHTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D43iZg+hboDzNM79mERlBZvqTBw6VIcT2M/jfD8FDXsNmU1stulHgcbcwMvD9u1CEjUW/DqdDFasGU4pDfgr/wZeVyBYxlxL4/E71aYCB/GK02d0BwYENDIJpoG0qnTUXn/B8p8BnQHxuGMHm/bo7zknbsW+nmIvroaP1XfJrzDTlgpftg5/7H/Eq/9LeVeaXPE+RyOzoXLkKXlYiWq7nyYAylMLLSVkOEp9kaImSnrYXYuE9iFUjvWBzKcnXifObbrHW5nMOi8gsxIep3ZO2vwPQHLdGCxw+NfBQ8qlBVeIUEr4YfmDLsJDj/sBgnWE0s2vZJQj0Zoci8q9cOo4nw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=envs.net; dkim=pass (4096-bit key; secure) header.d=envs.net header.i=@envs.net header.a=rsa-sha256 header.s=modoboa header.b=Xl4WkHPX; dkim-atps=neutral; spf=pass (client-ip=157.180.15.194; helo=mail.envs.net; envelope-from=xtex@envs.net; receiver=lists.ozlabs.org) smtp.mailfrom=envs.net
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=envs.net
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; secure) header.d=envs.net header.i=@envs.net header.a=rsa-sha256 header.s=modoboa header.b=Xl4WkHPX;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=envs.net (client-ip=157.180.15.194; helo=mail.envs.net; envelope-from=xtex@envs.net; receiver=lists.ozlabs.org)
Received: from mail.envs.net (mail.envs.net [157.180.15.194])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h95lD2H8Yz2xFc
	for <linux-erofs@lists.ozlabs.org>; Wed, 29 Jul 2026 18:55:34 +1000 (AEST)
Received: from localhost (mail.envs.net [127.0.0.1])
	by mail.envs.net (Postfix) with ESMTP id 0EF341C00C8;
	Wed, 29 Jul 2026 08:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=envs.net; s=modoboa;
	t=1785315331; bh=Ca3qkNHic8rR3X/AP7JbZLGtPa++G6cubzXyiDrZHTQ=;
	h=From:To:Cc:Subject:Date:From;
	b=Xl4WkHPXQWFTPVjoaS6iQmFpX/kc3t2C+Nx0wG1heriNX0svW2reeljXWtQYAvY9Q
	 z7DRh/USu20IAR5x7qrSRUPZ2ZdC00SBas+J8Ry2ezMcksc6JvTl1c2TqBN8GwAy4m
	 CwrlUV486rOrpx+qtoR4jKZx18tFI9U3ToJLqH6uE39b/5zkepAqXcXPDLsQFSv+Rh
	 1mN4niwlujpZKW3VcRyT+hfWLw8Lg1wJxrb1FqfOvEpLVwt40HccIxqKXnlw2KOsSn
	 hT84x+v1Ta6UmQD8hVr2xXX4hpyftLRd1Rjp4K8SRlLQXbaBis4YOBVV8H/qldH68+
	 JduzNM4ihgt9KssAFQkAC6Ed5cl5yori4WhGQk0u2mYKxtSMvrfq8dywp2zrs70Q4p
	 X7CbRjvHZ+161ZoSzGd/6kVfj27xlmHMXY+7TVgXfNAEWT5voPtIZt0QDtKOO5dbyw
	 OvQZwp93TnBZ2cW22jAvHoMQBLhYmkI+HS/Et81FS9iXveKjHWzI14ZykePthSFsTg
	 0JWfLZ8y/j7/ZFC6BE0PC66Tr9+7IlqRLXt5f3i6Lf1+pYwCjG5vtvR3g1Lmg7otsa
	 ZGatzux12DFnoc0a8lJx7iyZYKaycNZFdIODT7kgl7qjuBtvtk/OIrv+Se0nvP+6l7
	 pUpbKEpvoqxsX3B8s9XPORDE=
X-Virus-Scanned: Debian amavisd-new at mail.envs.net
Received: from mail.envs.net ([127.0.0.1])
	by localhost (mail.envs.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id sthl5KdgIcl6; Wed, 29 Jul 2026 08:55:28 +0000 (UTC)
Received: from xtexx.eu.org (unknown [211.136.168.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.envs.net (Postfix) with ESMTPSA;
	Wed, 29 Jul 2026 08:55:28 +0000 (UTC)
From: Bingwu Zhang <xtex@envs.net>
To: linux-erofs <linux-erofs@lists.ozlabs.org>,
	Gao Xiang <xiang@kernel.org>
Cc: Bingwu Zhang <xtex@astrafall.org>
Subject: [PATCH RESEND] erofs-utils: lib: fix memory leak in erofs_fragment_commit
Date: Wed, 29 Jul 2026 16:55:27 +0800
Message-ID: <20260729085527.124698-1-xtex@envs.net>
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

From: Bingwu Zhang <xtex@astrafall.org>

erofs_fragment_pack may initialize fi->list as a
new list head instead of adding it to a bucket.
If fi->pos is non-zero, the fragmentitem and
data buffer is not released by erofs_fragment_commit,
leading to a memory leak.

Signed-off-by: Bingwu Zhang <xtex@astrafall.org>
---
Reproducer:
mkfs.erofs -d9 -Eztailpacking -Einline_data \
	-Efragments -zzstd --zD data.erofs data

Direct leak of 5080 byte(s) in 127 object(s) allocated from:
    #0 0x559bf549b788 in malloc (/home/xtex/src/erofs/erofs-utils/mkfs/mkfs.erofs+0x10f788)
    #1 0x559bf554391e in erofs_fragment_pack /home/xtex/src/erofs/erofs-utils/lib/fragments.c:205:7
    #2 0x559bf554426a in erofs_pack_file_from_fd /home/xtex/src/erofs/erofs-utils/lib/fragments.c:302:7
    #3 0x559bf552e89f in erofs_write_compress_dir /home/xtex/src/erofs/erofs-utils/lib/compress.c:2074:8
    #4 0x559bf5507421 in erofs_write_dir_file /home/xtex/src/erofs/erofs-utils/lib/inode.c:744:9
    #5 0x559bf5507421 in erofs_mkfs_jobfn /home/xtex/src/erofs/erofs-utils/lib/inode.c:1654:9
    #6 0x559bf5507421 in z_erofs_mt_dfops_worker /home/xtex/src/erofs/erofs-utils/lib/inode.c:1723:9
    #7 0x559bf5498fca in asan_thread_start(void*) asan_interceptors.cpp.o

Indirect leak of 7135 byte(s) in 127 object(s) allocated from:
    #0 0x559bf549b788 in malloc (/home/xtex/src/erofs/erofs-utils/mkfs/mkfs.erofs+0x10f788)
    #1 0x559bf55439c5 in erofs_fragment_pack /home/xtex/src/erofs/erofs-utils/lib/fragments.c:218:13
    #2 0x559bf554426a in erofs_pack_file_from_fd /home/xtex/src/erofs/erofs-utils/lib/fragments.c:302:7
    #3 0x559bf552e89f in erofs_write_compress_dir /home/xtex/src/erofs/erofs-utils/lib/compress.c:2074:8
    #4 0x559bf5507421 in erofs_write_dir_file /home/xtex/src/erofs/erofs-utils/lib/inode.c:744:9
    #5 0x559bf5507421 in erofs_mkfs_jobfn /home/xtex/src/erofs/erofs-utils/lib/inode.c:1654:9
    #6 0x559bf5507421 in z_erofs_mt_dfops_worker /home/xtex/src/erofs/erofs-utils/lib/inode.c:1723:9
    #7 0x559bf5498fca in asan_thread_start(void*) asan_interceptors.cpp.o
---
 lib/fragments.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/fragments.c b/lib/fragments.c
index 13afce3be537..f137e41b7365 100644
--- a/lib/fragments.c
+++ b/lib/fragments.c
@@ -325,6 +325,10 @@ int erofs_fragment_commit(struct erofs_inode *inode, u32 tofh)
 
 	if (fi->pos) {
 		inode->fragmentoff = fi->pos - len;
+		if (list_empty(&fi->list)) {
+			free(fi->data);
+			free(fi);
+		}
 		return 0;
 	}
 

---
base-commit: 30711d4b2e234fe3e8aaeb779ade4cb609b0d920
change-id: 20260706-fix-frag-leak-f7a6cf172168

Best regards,
--  
Bingwu Zhang <xtex@astrafall.org>


