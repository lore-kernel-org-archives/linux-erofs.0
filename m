Return-Path: <linux-erofs+bounces-3336-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6389F5A8A9
	for <linux-erofs@archiver.kernel.org>; Mon, 20 Apr 2026 17:48:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fztHm20rwz2yqT;
	Tue, 21 Apr 2026 03:48:04 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip=103.117.158.51 arc.chain=zohomail.in
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1776707284;
	cv=pass; b=K1b8BPSQhJveKOCGPhSYSJvE0qbG3ONd2LzGjR3u2tijwmqo85tSzevCYFB3WLwKwL6IlMUmF76ycFnas7gu0C1A70TyrjGdXp/RF4EaHq4qu9mZvXkJMIrQIRoCv2KT+amGfB1ZDNOwp1gLVaWk+z4cagfSd313YWX6XECf9k1CPalt+Mlw8K4pT0kBYsW0UBEqrvMragYx2QdZadc8H0Qz9H7xbMhsCg1i4oQTS2gnGGMXMc6MP8wge1aZOl2gkOKDJGNQ8/1dsw6g/omBohOP1yu+MySsWr0J3a8oFNG6xg8PJ+3FTpG4ELcnANKJPor9koHyy3u0EqCgS3qhAA==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1776707284; c=relaxed/relaxed;
	bh=fVE1QqhfUMfiQMv2NiZUXsvY4CKNsni8HJeHzW/ovGs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=E1uoV4ctgydy1FTwkG54UQIAvddaSlMNh9mA3tJUlXXGck2kUlXN+YVorY65A4KNtHUy+fkBYox1CQkPcENRqvvyfOpPtdEhCIHfIWEVEmkPXdEMzhew6W9+CI6twLVWjRU4F7hTBoF+zLV+d7z2Q7YHrTsJfgeCqiUsynY+at2gJDQFoZVOrKxnNG0zXR4LsAHFPnXi1zP4D63gX2ZpVdcRtQjYLQHockgzUQkVhuR9akbGkF0k5M+Z6mowDAyl1SuiNjfDep2tBXYXdt1RjPpQn4/yahu72YNd1PLC6g3PPUESCR/EKEuVMF6ipESZSKuM2yKsg8d9PDJpAAMLzQ==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=vnsh.in; dkim=pass (1024-bit key; unprotected) header.d=vnsh.in header.i=ch@vnsh.in header.a=rsa-sha256 header.s=zoho header.b=AZgp62O9; dkim-atps=neutral; spf=pass (client-ip=103.117.158.51; helo=sender-of-o51.zoho.in; envelope-from=ch@vnsh.in; receiver=lists.ozlabs.org) smtp.mailfrom=vnsh.in
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=vnsh.in
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=vnsh.in header.i=ch@vnsh.in header.a=rsa-sha256 header.s=zoho header.b=AZgp62O9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=vnsh.in (client-ip=103.117.158.51; helo=sender-of-o51.zoho.in; envelope-from=ch@vnsh.in; receiver=lists.ozlabs.org)
Received: from sender-of-o51.zoho.in (sender-of-o51.zoho.in [103.117.158.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fztHk2LbPz2xll
	for <linux-erofs@lists.ozlabs.org>; Tue, 21 Apr 2026 03:48:02 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; t=1776707275; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=RC1gh1tbCQ0l5pUXJJGP/5oRFDGzUZo+QgLIwBArbDNNq1oTP71Ubq4Hwlseq5aLiNj8tdCpn9IYUcUCJYfuf8q99PeL3mq6SHpOEUxULIRc7KpQGKKlNwRSc+9+By92GVo3wRUIZAJO3CcWjX2c213wAgyMWzClc1qbUauIq5A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1776707274; h=Content-Transfer-Encoding:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=fVE1QqhfUMfiQMv2NiZUXsvY4CKNsni8HJeHzW/ovGs=; 
	b=YJpxWHyj5KahxVh1cod9/DWZC1bFhYRkyyxtPo2axu2IdfzTiNKeSMLP7+ziULYvR8qGJMjP73Zfd5bBVqQ9zmMUBndgw4f9Kjja5MxA2Lpe6VFnAmBbVwETTE7r3BQGyA3ng/boOgigh7Omzc36yLWoZa6pfxoXmN0U8Oc7690=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=vnsh.in;
	spf=pass  smtp.mailfrom=ch@vnsh.in;
	dmarc=pass header.from=<ch@vnsh.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1776707274;
	s=zoho; d=vnsh.in; i=ch@vnsh.in;
	h=From:From:To:To:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=fVE1QqhfUMfiQMv2NiZUXsvY4CKNsni8HJeHzW/ovGs=;
	b=AZgp62O9HbpREF89u0CBXFvbNWUQEyGypkF3My2jl+uawhZ8FadQkWZNOYAok8Ox
	SJvYcH+Exr5GuY8WK/scqJBbxD0+iBDt3RaZsfSQtWjv41jDgf24q/Nul/CftBrDet2
	7vUi8UThP8Eej74FaIvHXz3EHb4QDTqp5vm44Hzw=
Received: by mx.zoho.in with SMTPS id 1776707273402195.3788380498354;
	Mon, 20 Apr 2026 23:17:53 +0530 (IST)
From: Vansh Choudhary <ch@vnsh.in>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: lib: check NULL from erofs_rebuild_get_dentry()
Date: Mon, 20 Apr 2026 23:17:52 +0530
Message-ID: <20260420174752.50132-1-ch@vnsh.in>
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

erofs_rebuild_get_dentry() returns NULL when the input path
normalizes to nothing (".", "/", "//", or paths that collapse via
".."). The tar hardlink branch and the S3 import loop only check
IS_ERR() and then dereference the result.

Reject a hardlink target that resolves to root with -EISDIR, and
treat a root-normalized S3 key as the root inode itself.

Fixes: 95d315fd7958 ("erofs-utils: introduce tarerofs")
Fixes: 29728ba8f6f6 ("erofs-utils: mkfs: support EROFS meta-only image generation from S3")
Signed-off-by: Vansh Choudhary <ch@vnsh.in>
---
 lib/remotes/s3.c | 5 ++++-
 lib/tar.c        | 4 ++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/remotes/s3.c b/lib/remotes/s3.c
index e552ed0..d386a32 100644
--- a/lib/remotes/s3.c
+++ b/lib/remotes/s3.c
@@ -1129,7 +1129,10 @@ int s3erofs_build_trees(struct erofs_importer *im, struct erofs_s3 *s3,
 			ret = PTR_ERR(d);
 			goto err_iter;
 		}
-		if (d->type == EROFS_FT_DIR) {
+		if (!d) {
+			inode = root;
+			inode->i_mode = S_IFDIR | 0755;
+		} else if (d->type == EROFS_FT_DIR) {
 			inode = d->inode;
 			inode->i_mode = S_IFDIR | 0755;
 		} else {
diff --git a/lib/tar.c b/lib/tar.c
index d2dc141..b08bd77 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -1024,6 +1024,10 @@ out_eot:
 			ret = PTR_ERR(d2);
 			goto out;
 		}
+		if (!d2) {
+			ret = -EISDIR;
+			goto out;
+		}
 		if (d2->type == EROFS_FT_UNKNOWN) {
 			ret = -ENOENT;
 			goto out;
-- 
2.43.0


