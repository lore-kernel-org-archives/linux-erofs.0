Return-Path: <linux-erofs+bounces-2908-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 066B21094478
	for <linux-erofs@archiver.kernel.org>; Sat, 21 Mar 2026 14:29:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fdMHx2mrxz2yZN;
	Sun, 22 Mar 2026 01:29:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip=103.117.158.51 arc.chain=zohomail.in
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774103341;
	cv=pass; b=G+UvsK6TTbpO9zbMqfBqGu6WiRi1bOMq7P2bXghJaSX4tCZ/yN5PQQuY0hSfSwu9fUTKRGoFh4tuPNV0+2C4tNdQkGDBl9DtqnHKlSE2xQW0ZD6bUKsyMs+uY0NU/8LDVVEJQFC/JDngYg0U2UVbUQ1XE8B1wbJ7jH7NEf98I+J5UaqzIRVeeBF7FxQAlIRMNyd942QGyOykxiREjxdzUR7FkCGIQ46WzLStpAz7lvYoTxtMIOy1g7Dgp/XpLzZsqa0JQ5PltJ8lntyP+CD8zBZH81w8/PqzUUAecfu6FmtBD2vFXhYlomb9t93mFQkVY0GJcCKTJrTtFUtq+B64rg==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774103341; c=relaxed/relaxed;
	bh=bAhMwxmrPfFNnSuGIDwZAKQlVs1jrH+FERg6ecoZX5M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=McNH9/k7ynQbqOUQUIp5J+aRpBKNAIEiZekYzawJ/529E/dxpNcePzz5+qCVM14weAfr5VqfdKJ3tGTLI9cWZRXa+92CJsOfgBesKUbs/WnW6xBJAyjX6Qg/xzkW97+ZaKYbnpUuy8X025W6gKXWbPpgkoTGG6FHJ0yKUQ3NHaHd0ZsUuzMuUX/GCDUwU/5yphyQcnkZQtGRiJY9j1MHpPWiVwy8VVC915QUzz+roBKTph+0Dt8E+hRu6fVyH60p2pWqeSiNEJQXl/bhB2ibYkFBcEUW69sJycvZ1G7BsZFOz/I6IGySx5O4InJSnksuLvXEVygvyWpBDhyvOYnOSg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=vnsh.in; dkim=pass (1024-bit key; unprotected) header.d=vnsh.in header.i=ch@vnsh.in header.a=rsa-sha256 header.s=zoho header.b=VibRuWYN; dkim-atps=neutral; spf=pass (client-ip=103.117.158.51; helo=sender-of-o51.zoho.in; envelope-from=ch@vnsh.in; receiver=lists.ozlabs.org) smtp.mailfrom=vnsh.in
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=vnsh.in
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=vnsh.in header.i=ch@vnsh.in header.a=rsa-sha256 header.s=zoho header.b=VibRuWYN;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=vnsh.in (client-ip=103.117.158.51; helo=sender-of-o51.zoho.in; envelope-from=ch@vnsh.in; receiver=lists.ozlabs.org)
X-Greylist: delayed 620 seconds by postgrey-1.37 at boromir; Sun, 22 Mar 2026 01:28:59 AEDT
Received: from sender-of-o51.zoho.in (sender-of-o51.zoho.in [103.117.158.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fdMHv581Zz2yYq
	for <linux-erofs@lists.ozlabs.org>; Sun, 22 Mar 2026 01:28:59 +1100 (AEDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774103335; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=Y+es6q+Xysz0LaIeGjiG06guqkdAax1QR7vahbzh5Bk7go6CRYPAyf6ZXDiD98u00dl48yWBrSRJ0IT97T9oq/knhUbhHmnFtum6ZayywEBpqMORIyvcqnykQ7nrOBjFSZDkdS4/n5COs3NdSQeEidSPEhe+9uDJ9q4TsiC2g+E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1774103335; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=bAhMwxmrPfFNnSuGIDwZAKQlVs1jrH+FERg6ecoZX5M=; 
	b=Kvxy9qT+MVfLRC/xJjP1oNi9yJL5SgC9z+kTzLM5kBl7KXZVainNRca0O4Z6grkU9y/KqQFC6z1AYYYEpfWLvSNRFQLyXWSeUBXh4+ljZNVM9MTikhdZYv7HCLqRLBBQx/rUq7MdWWo0+UQ66T3QKGPoyMYt/JEIcC7ALnNw2K0=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=vnsh.in;
	spf=pass  smtp.mailfrom=ch@vnsh.in;
	dmarc=pass header.from=<ch@vnsh.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774103335;
	s=zoho; d=vnsh.in; i=ch@vnsh.in;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=bAhMwxmrPfFNnSuGIDwZAKQlVs1jrH+FERg6ecoZX5M=;
	b=VibRuWYN4dNgEQuk3vpI7KOn78g0jH4vypwTylUy2JN9tX54XuLQFLzyZku1Mh/j
	7e5qeVTOtoqoQtN/WUvdqHRO2YUksdiD+R85DJOjb16KmWPp68SANse/q7o4d+D0NNO
	BPPECJgguGGEsi03Wjcvlsw+ZsDtiIZrW5HeqwCE=
Received: by mx.zoho.in with SMTPS id 177410333319381.39648812963105;
	Sat, 21 Mar 2026 19:58:53 +0530 (IST)
From: Vansh Choudhary <ch@vnsh.in>
To: linux-erofs@lists.ozlabs.org
Cc: Vansh Choudhary <ch@vnsh.in>
Subject: [PATCH] erofs-utils: fsck: fix directory loop tracking
Date: Sat, 21 Mar 2026 19:58:52 +0530
Message-ID: <20260321142852.35991-1-ch@vnsh.in>
X-Mailer: git-send-email 2.51.0
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

Store the current directory nid in the recursion stack.

The loop check compares inode.nid against the entries already on the
stack, so pushing pnid there can miss self-referential directory loops
and report the wrong failure later.

Signed-off-by: Vansh Choudhary <ch@vnsh.in>
---
 fsck/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fsck/main.c b/fsck/main.c
index 16a354f..3530707 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -1022,7 +1022,7 @@ static int erofsfsck_check_inode(erofs_nid_t pnid, erofs_nid_t nid)
 		for (i = 0; i < fsckcfg.dirstack.top; ++i)
 			if (inode.nid == fsckcfg.dirstack.dirs[i])
 				return -ELOOP;
-		fsckcfg.dirstack.dirs[fsckcfg.dirstack.top++] = pnid;
+		fsckcfg.dirstack.dirs[fsckcfg.dirstack.top++] = inode.nid;
 		ret = erofs_iterate_dir(&ctx, true);
 		--fsckcfg.dirstack.top;
 	}
-- 
2.51.0


