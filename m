Return-Path: <linux-erofs+bounces-3339-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73DBAF5A8B9
	for <linux-erofs@archiver.kernel.org>; Mon, 20 Apr 2026 19:08:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fzw436wPKz2yqT;
	Tue, 21 Apr 2026 05:08:03 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip=103.117.158.51 arc.chain=zohomail.in
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1776712083;
	cv=pass; b=UjL/nGB0gLu/pfVQWiOuYVXJGR2ln3UAuPMDl5Qeavrk42JOVOTXJipJsXNVoS+7c9TJ/aS9ar6tdlF6R4cwhwB4p1ccBBc9ROsEV6gfBkhTPe6PzxtvLw2+JL1W4fvtDu9f+gYm7FH+gf9eUxOTUISca12ken+CdhEMtKjhkSJCbUrwB7SF17rULMrCiSRmlTVCk9ufIo5jmK+KeobhA0xmsRDCQXhjU1u1c3uymm29WqKKVU0h4Hqi4jkEefv79rQx8WgksuARoHyzPHFImdls2DU5F+SBkn2Js6pN42BTHyGywxRgB940BHOJQLJT5v0yqUTbxPjxJzapsZhcGw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1776712083; c=relaxed/relaxed;
	bh=lrQ9TLkU0IHT4Heq5yxxj6foHYuROVpWM5MtHfkyq5c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CNm1Mm9/daBKN5ErGiR6tvPkqSVq3s6zWCTB7/1LBUKemB/ATK/h0k9CS0PRlzqBxjDVmK9+GrFWB3j0opjB3EVcFMJ7HHC0F5YlenRR95LPEZSDpai5Z7FXFUwEctCDbaHVhbL90D4f+M0az+0In3cSPnj1n99zmY3dGouMk7ta9/aR7nQjyKnyBNu3NQCawH5aNRvkLDUBcWBnbh/0TTNfU6fYBvbdcYuerA1845PMadM8ErxTyS15NTMERW6kfNc0WzP2LYBVvtdHjfwLJNeD0ljK/HKV+vNfnHvXzGbGk8KEnqzLMDLQ/oc+TMcjdc8X579qlSQDR5BPrZzYag==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=vnsh.in; dkim=pass (1024-bit key; unprotected) header.d=vnsh.in header.i=ch@vnsh.in header.a=rsa-sha256 header.s=zoho header.b=C8zRbMWt; dkim-atps=neutral; spf=pass (client-ip=103.117.158.51; helo=sender-of-o51.zoho.in; envelope-from=ch@vnsh.in; receiver=lists.ozlabs.org) smtp.mailfrom=vnsh.in
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=vnsh.in
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=vnsh.in header.i=ch@vnsh.in header.a=rsa-sha256 header.s=zoho header.b=C8zRbMWt;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=vnsh.in (client-ip=103.117.158.51; helo=sender-of-o51.zoho.in; envelope-from=ch@vnsh.in; receiver=lists.ozlabs.org)
Received: from sender-of-o51.zoho.in (sender-of-o51.zoho.in [103.117.158.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fzw421ycPz2ypw
	for <linux-erofs@lists.ozlabs.org>; Tue, 21 Apr 2026 05:08:01 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; t=1776712075; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=NvJskT19r1+c5A8ouOMngDQv1b84ar14hSvvB7IzzZGHlx5qtPbqK2WU3sXTjl/7yygsGXj5poYeUHxhvu5nLQEAXcR07VU6KSrpv/8tCE9Y23HjiGPq8A6SCjePylMTh7JNqtY3Qwmu8ActgIHbNgfKwzUy+HnwbkxifeksyYM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1776712075; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=lrQ9TLkU0IHT4Heq5yxxj6foHYuROVpWM5MtHfkyq5c=; 
	b=Spp7MaHNrrcsDtjbuJBwOwtutr6QuqKX4cLPIXkC23C0GvYypkmgR6wZD2ctQ2YGEal6qqM3A3Uh3ALeytixJkzx75ED32jeHrpN5p1bu0EHiTai4H8vN5fCOYLSInJXNolZxttXRIm2e6/9kseNh7qLu1OBYQaZJx/ID3kxqMw=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=vnsh.in;
	spf=pass  smtp.mailfrom=ch@vnsh.in;
	dmarc=pass header.from=<ch@vnsh.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1776712075;
	s=zoho; d=vnsh.in; i=ch@vnsh.in;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=lrQ9TLkU0IHT4Heq5yxxj6foHYuROVpWM5MtHfkyq5c=;
	b=C8zRbMWt8x0aKPHwpFFJIgmiNAMUjyWD4O1pqf/oi2r1GUZ88lDc3peJOz0Dzh8b
	MbqVSjO82hgAfzh0BlVap91IDhcuW37lXDGrywya15r3kA3wPelFiCizLFL39QNerLO
	GnfCVisTR/LudbkEZ+uZ/vLiYVMwrkFFPIKCLGRo=
Received: by mx.zoho.in with SMTPS id 1776712072516263.876191875603;
	Tue, 21 Apr 2026 00:37:52 +0530 (IST)
From: Vansh Choudhary <ch@vnsh.in>
To: linux-erofs@lists.ozlabs.org
Cc: Vansh Choudhary <ch@vnsh.in>
Subject: [PATCH] erofs-utils: lib: check readlink() length for symlinks
Date: Tue, 21 Apr 2026 00:37:51 +0530
Message-ID: <20260420190751.71170-1-ch@vnsh.in>
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
X-ZohoMailClient: External

The symlink path writes inode->i_size bytes from a malloc()'d
readlink() buffer without checking how many bytes readlink()
returned. If the target shortens between lstat() and readlink(),
uninitialised malloc() bytes end up in the image.

Return -EIO on a short readlink().

Fixes: a17497f0844a ("erofs-utils: introduce inode operations")
Signed-off-by: Vansh Choudhary <ch@vnsh.in>
---
 lib/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/inode.c b/lib/inode.c
index bac21dc..7c66a39 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -1562,6 +1562,10 @@ static int erofs_mkfs_handle_nondirectory(const struct erofs_mkfs_btctx *btctx,
 				free(symlink);
 				return -errno;
 			}
+			if (ret != inode->i_size) {
+				free(symlink);
+				return -EIO;
+			}
 		}
 		ret = erofs_write_file_from_buffer(inode, symlink);
 		free(symlink);
-- 
2.43.0


