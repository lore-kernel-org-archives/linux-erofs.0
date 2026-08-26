Return-Path: <linux-erofs+bounces-4347-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB414C61DBD
	for <linux-erofs@archiver.kernel.org>; Wed, 26 Aug 2026 13:44:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hVQqL2Tf4z2y32;
	Wed, 26 Aug 2026 23:44:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787751854;
	cv=none; b=kx7Vk72bEjIuWPigebolCKUN3vDHYAMkalDEIkG33AesubdJsU5XUxsP6QI6ArpVnEFuLRkjpl4jP0r0FHWyVic1DVEm9ReFFCe0of1TOBUNU5tDhGtumpNEQ1w4oa6ar5p+hf9cgny2tHKkNwdOmiLokNQ28/k9FV9BoY4N+GkBl2ITFYG1LvsrY9PLobiXpmNKdTU5OXZm1v4PT8Y31cdyeZnHjotNQnujvIRIY6h53e1yLH+H1ujcRTSRv7lhy6gPZ2TkiKJditJR0FXTy9Zd05zsZtD8Qmz39SY0t8W5IUaDmEpKawCFgu5d0KKpQS3kus4C7ASuypvmp7vKag==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787751854; c=relaxed/relaxed;
	bh=+LFX83LpwXwKMKSlUw035K97C3Gtjl8o7GZd7T+LhpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aT5mH3AwJGiyrpgyl0Xhey6iKVcnCYA5rxWDnL/aR5QPGtoNpRwc7fLpVHae6SdXBc9i0fgKPuNAAHejF1atAvgLrt9gFir1+U35QTU8sj3issY91e/KeYlGtjUgog2bDQ71AME8ZmrA3e2FXSo+9B4U1u49L3FMBpbFAR0MKiv4UbRZ53PSLaBLzu7Ur0X35tzJpzLkRWxoZmoVsXbjTZYrYJp742PIVtU6gBONWK/INz9Tve04f+mP1vEy+/irS4l9lYVGWWq4gmODcMnrmAsNWw7nTiOwXXV9UeLK2WcpHKBDd2z4kwc7ne0UrRjcB8+q549xuQ0lBq8BWruqUQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CPKbxlDH; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CPKbxlDH;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hVQqK3XF7z2xLG
	for <linux-erofs@lists.ozlabs.org>; Wed, 26 Aug 2026 23:44:13 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A523F6020E
	for <linux-erofs@lists.ozlabs.org>; Wed, 26 Aug 2026 13:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FB61F000E9;
	Wed, 26 Aug 2026 13:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787751850;
	bh=+LFX83LpwXwKMKSlUw035K97C3Gtjl8o7GZd7T+LhpQ=;
	h=From:To:Cc:Subject:Date;
	b=CPKbxlDHpulXX9++3CquX3l15Z9WLUNCcQpqKUL+1b3y4GPPiL1ln9a1Cu85f/mCN
	 htEy802uHFX50N3n6Yg91H6aXIQjkOPE0YmxAyQBQMF9OWLbqAi4qE3HQdPDFFDvkE
	 L3dfFdMJgdpabjeKgUPNjiFU0O31XFGVs49b99YXZXIhKnJazxFP+Rcop2Ar51kXud
	 ZflU8qM98k4ir+MejzTja/ZdqKdyXAPa1alza4xq5nPhCwryZuX1fUXhfKsmD7vEh9
	 L/yZtXqk1hAGDMOoamyHA3zij9oJdralFqwgCz1N2RBcLIxRTet/uJfgc7NFR/O8v5
	 qtt64EiF7DpnQ==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH 1/4] erofs-utils: lib: fix wrong forward declaration of `erofs_metamgr`
Date: Wed, 26 Aug 2026 21:43:17 +0800
Message-ID: <20260826134321.11835-1-xiang@kernel.org>
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

it is forward-declared as "struct erofs_metaboxmgr", but the actual
struct was already named as "erofs_metamgr" in lib/metabox.c.

This could confuse the compiler; update it to match the real name.

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 include/erofs/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index c9c7873..514cfbd 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -89,7 +89,7 @@ struct erofs_mkfs_dfops;
 struct erofs_packed_inode;
 struct erofs_xattrmgr;
 struct z_erofs_mgr;
-struct erofs_metaboxmgr;
+struct erofs_metamgr;
 
 struct erofs_sb_info {
 	struct erofs_sb_lz4_info lz4;
-- 
2.47.3


