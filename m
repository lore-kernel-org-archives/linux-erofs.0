Return-Path: <linux-erofs+bounces-2920-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A525E1094489
	for <linux-erofs@archiver.kernel.org>; Sat, 21 Mar 2026 18:36:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fdSnn56tSz2yfs;
	Sun, 22 Mar 2026 05:36:45 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip=103.117.158.51 arc.chain=zohomail.in
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774118205;
	cv=pass; b=W5KpenCtSbsSxDArLyYeoztnlOZihZyyYsa5RrJnZQt8JPkdseaSYL+GLTnJyANzNk+5iQgVwvdCxVCA5dgX/c6j/fso06XLYTi0ZJGRRZeSbIqbW7rA4VhLyXKBhDR8fp4ZiIGRji6dGyAiTyGmADNblfGRkSV2I0G9AjrqJe9bFepGFY8bYX15FG45ZrNEPciOjt/m58iJVMTuumWgEKdmsuCmuYJG1i7++z+w26uefVguKcVpb9LkiYDgbVuDrYya247AxEX9VrFA3CZQ4G7PTZRnKE8LNTVDYzy8hwCVVFJGelYBAEiVCHTo5phCyQ6M2PwUBchyjWERZWFMaQ==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774118205; c=relaxed/relaxed;
	bh=r8DzzNw24+pqbXbFOCtYbfpNMtGLAIEwotjKlCZ8uMc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GQi2tswZatiTZ3ChmKC1duxdUJGDxXS1y54qQRgF/2K+Gvc/5XQCEBRdbp0Z38RJ4Xhv/jF3Huot1tc0KmMUdlCC7K9c1135MtrtjG4McUgCoxNmLsxZ++VJnhdol/kRrvZaBHSecz9OYj3LD6AATwfGi2hAHJaScQ56SFABfPI05gFGzavYqHE/AGIiL9LORuiCBbpYkntbIRi2J8Ogl8h5GPGu3WZdHhsKnX5KWwDf3/3UmvH0wp2BP6FV3KYJD7gEvTU86eER5krV1/QEdR/Jf29/lwmwe/PY0nv0vtJqAZpxy4yRQOY+48CZc7fQBxE1BlqbtkQlgZzL4Xrdcg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=vnsh.in; dkim=pass (1024-bit key; unprotected) header.d=vnsh.in header.i=ch@vnsh.in header.a=rsa-sha256 header.s=zoho header.b=R7Wi7LY9; dkim-atps=neutral; spf=pass (client-ip=103.117.158.51; helo=sender-of-o51.zoho.in; envelope-from=ch@vnsh.in; receiver=lists.ozlabs.org) smtp.mailfrom=vnsh.in
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=vnsh.in
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=vnsh.in header.i=ch@vnsh.in header.a=rsa-sha256 header.s=zoho header.b=R7Wi7LY9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=vnsh.in (client-ip=103.117.158.51; helo=sender-of-o51.zoho.in; envelope-from=ch@vnsh.in; receiver=lists.ozlabs.org)
Received: from sender-of-o51.zoho.in (sender-of-o51.zoho.in [103.117.158.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fdSnm2Gmzz2yYq
	for <linux-erofs@lists.ozlabs.org>; Sun, 22 Mar 2026 05:36:43 +1100 (AEDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774118199; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=RXA2bYXY0iyXlRXnajL40Vv6RQxXTg6F1jQ3FNIbGr7DnA33EXop06rbjHYe9Uhc+O9XIaoLDFxlUrifxkXqm7sQVrYeqzKUrEsQIA2DG1suW+qGZAWIjEhcU6Nd9XddBOWCUqGXymVpMS9zdh4CkavPZ9SL4fyhMRJoy/tuAxY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1774118199; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=r8DzzNw24+pqbXbFOCtYbfpNMtGLAIEwotjKlCZ8uMc=; 
	b=HBkazMpRgeCngxQBjPRX696WSzPbAQlfb6Nl7EbzuB4FebVlQtNPHbJVHMCftvOrYwY+UYuvTqGiwvaul890XqAibJNhXyAt4lrp/MJvV9b1IgrluBsUjqGBwS1PAmqU5wRLcC6fHeoOEeloXls5D2iK+8zNTnrA6hpa5CVyLHc=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=vnsh.in;
	spf=pass  smtp.mailfrom=ch@vnsh.in;
	dmarc=pass header.from=<ch@vnsh.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774118199;
	s=zoho; d=vnsh.in; i=ch@vnsh.in;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=r8DzzNw24+pqbXbFOCtYbfpNMtGLAIEwotjKlCZ8uMc=;
	b=R7Wi7LY9BTnKwD4yhPrcZvcDNQVabFEOJI6GqE9YqaIbEDtV8JPqpnCOoO8uOuQ2
	T4DC1jGhvKv6KUwvgQgP4DbzkcVQHWDZxdeAimOrdhuTwsRZZ015QyTKk8/9CS5NFUd
	kpoIrOln9x/Ft8EOW8oT26ZQijIQhqUjchqMUvoI=
Received: by mx.zoho.in with SMTPS id 1774118198500509.3947448325174;
	Sun, 22 Mar 2026 00:06:38 +0530 (IST)
From: Vansh Choudhary <ch@vnsh.in>
To: linux-erofs@lists.ozlabs.org
Cc: Vansh Choudhary <ch@vnsh.in>
Subject: [PATCH] erofs-utils: fsck: check symlink size before allocation
Date: Sat, 21 Mar 2026 18:36:38 +0000
Message-ID: <20260321183638.43353-1-ch@vnsh.in>
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

erofs_extract_symlink() uses inode->i_size to allocate a buffer for
the symlink target and then appends a trailing NUL byte.

Reject symlink sizes larger than SIZE_MAX - 1 before allocating the
buffer so malformed images cannot overflow the allocation size.

Return -EOVERFLOW for this case and keep the existing extraction flow
unchanged otherwise.

Signed-off-by: Vansh Choudhary <ch@vnsh.in>
---
 fsck/main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fsck/main.c b/fsck/main.c
index 16a354f..1254112 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -4,6 +4,7 @@
  * Author: Daeho Jeong <daehojeong@google.com>
  */
 #include <stdlib.h>
+#include <stdint.h>
 #include <getopt.h>
 #include <time.h>
 #include <utime.h>
@@ -794,6 +795,13 @@ static inline int erofs_extract_symlink(struct erofs_inode *inode)
 	if (ret)
 		return ret;
 
+	if (inode->i_size > SIZE_MAX - 1) {
+		erofs_err("symlink size %" PRIu64 " is too large @ nid %llu",
+			  inode->i_size, inode->nid | 0ULL);
+		ret = -EOVERFLOW;
+		goto out;
+	}
+
 	buf = malloc(inode->i_size + 1);
 	if (!buf) {
 		ret = -ENOMEM;
-- 
2.43.0


