Return-Path: <linux-erofs+bounces-3206-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1CFAE64018
	for <linux-erofs@archiver.kernel.org>; Sun,  5 Apr 2026 10:18:44 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fpT2B6Jd6z2ybQ;
	Sun, 05 Apr 2026 20:18:42 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip=103.117.158.51 arc.chain=zohomail.in
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775384322;
	cv=pass; b=aQONu+7fgnH3Vh39HHvQJUxEk3EzIF5RqNZCWltnldXPXhoUDDyXbyEyOfou8HZyA0kBEK8XfoL8RXJEPH2evrNPWyK/3vTQnRyiXiGqJm46R7du95uN7l9T0k+sIJXf7X8kRyXHQGPqFyQlGpcpyTTatilXMSjIF/OsKonnnIBzrSniWaZGcDP8PP259JfjY4xL4WHOPbUfK5opeAX6OGeP8Bxe4Jnb0vf8UG9evdJcCIAFmutHFGJ/hPIATHuZSLGkYUKbBM3jvrpwKCSLL0EbQMmDyPPQZKNV6tAUnLZSWmNPFXjf5EurawsGGll1UzXA3OniU2ujeKXQ7PY3rw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775384322; c=relaxed/relaxed;
	bh=BAKoaqPo5rwODH20zC5iNUFEjL3huyiGubNChUwGQm0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=etXjjMdriek9yafmcv9ryfdiNgNyzcPOcu544x+2QpQkMkIPfu0Da4OvP1K8Xs7p6PMYvyjEb4gDMpRT5HxvMfh+whB6yN+jS93NWlquiYuR/nXFD7T3Ju8M58g9gYUtYVMwbdEV9u3P/gam27I3bmQdEvRaKAdOywUgZtr7SEpxlac/TraH0RLJ5Kvq+/zGnZ0FNweaF5seOtsj6lC1stCGJmFUnvG495gVQ8PeO6lRrCpOYonzlR8u90rCpXfoQ/SMW/I3gCp3bnXcc9Z/UpZi4URtxoyhZscsQF2i3iqamsTJ5wG78v0k5WurNCVBaXjqdqR7vkascze2cM8pEA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=vnsh.in; dkim=pass (1024-bit key; unprotected) header.d=vnsh.in header.i=ch@vnsh.in header.a=rsa-sha256 header.s=zoho header.b=o5NGMgjG; dkim-atps=neutral; spf=pass (client-ip=103.117.158.51; helo=sender-of-o51.zoho.in; envelope-from=ch@vnsh.in; receiver=lists.ozlabs.org) smtp.mailfrom=vnsh.in
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=vnsh.in
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=vnsh.in header.i=ch@vnsh.in header.a=rsa-sha256 header.s=zoho header.b=o5NGMgjG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=vnsh.in (client-ip=103.117.158.51; helo=sender-of-o51.zoho.in; envelope-from=ch@vnsh.in; receiver=lists.ozlabs.org)
Received: from sender-of-o51.zoho.in (sender-of-o51.zoho.in [103.117.158.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fpT2904DYz2xLt
	for <linux-erofs@lists.ozlabs.org>; Sun, 05 Apr 2026 20:18:40 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; t=1775384315; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=Gn/gzncJcEnBvCok+o46A0JereU2O4DDdCuXnZLQ5h/y51YZfnHWtXtU6OqnUORtAvimxpLyyfa3XguVjNdy2ltj/A06YStxeUcCvH2YZtqRC+odJA7kPSYN2z6VnkQfzL4AEI4OXhJ6XmHeRFl17GiqdHZNwthreQriAz2f2So=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1775384315; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=BAKoaqPo5rwODH20zC5iNUFEjL3huyiGubNChUwGQm0=; 
	b=Wn2keLsc5vL0zZ+0Wrvy5qnRm4708FBB1ZWe4QpiF5KY8VM41LKZDZ7nKfUM+d7DfobHIg5sYuVe9wqijk648p2OC+9ABM/WvxWPSGNant0m1ml9tlgN28oQclGVjnMfTVAcTCGM0/zJhl5sBoCOLNuNtRkoPDdUBeQ77MKEY9I=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=vnsh.in;
	spf=pass  smtp.mailfrom=ch@vnsh.in;
	dmarc=pass header.from=<ch@vnsh.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1775384315;
	s=zoho; d=vnsh.in; i=ch@vnsh.in;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=BAKoaqPo5rwODH20zC5iNUFEjL3huyiGubNChUwGQm0=;
	b=o5NGMgjGutxsViXdHuQGRG3MSdEvlfUog7qKf6ELTgOE3CKLjUhoIslae8BqM59t
	U2TBHVqyt6yz24MAHkmPoYL7lGW3BnR3Qfoy6KciNXDTWm8jnXcRZWUjtPGD3waLcUV
	+slN73b+3z5A4zK9ab6CYwAe+ktV75HzlUKIrFfE=
Received: by mx.zoho.in with SMTPS id 1775384312353851.4880744044425;
	Sun, 5 Apr 2026 15:48:32 +0530 (IST)
From: Vansh Choudhary <ch@vnsh.in>
To: linux-erofs@lists.ozlabs.org
Cc: Vansh Choudhary <ch@vnsh.in>
Subject: [PATCH] erofs-utils: tar: fix negative GNU base-256 number parsing
Date: Sun,  5 Apr 2026 10:18:30 +0000
Message-ID: <20260405101830.34127-1-ch@vnsh.in>
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

GNU base-256 fields use a 0xff prefix for negative values, but
tarerofs_parsenum() currently accumulates them in signed long long.
That does not sign-extend negative values correctly and can also
trigger signed-overflow undefined behavior while shifting.

Handle positive and negative GNU base-256 fields separately and do the
byte accumulation in unsigned long long instead.

This fixes GNU base-256 decoding for negative tar metadata values such
as mtime, uid, gid and device numbers.

Fixes: 95d315fd7958 ("erofs-utils: introduce tarerofs")
Signed-off-by: Vansh Choudhary <ch@vnsh.in>
---
 lib/tar.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/lib/tar.c b/lib/tar.c
index 871779a..05d1a74 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -328,17 +328,26 @@ static long long tarerofs_otoi(const char *ptr, int len)
 
 static long long tarerofs_parsenum(const char *ptr, int len)
 {
+	const u8 *p = (const u8 *)ptr;
+
 	errno = 0;
 	/*
 	 * For fields containing numbers or timestamps that are out of range
 	 * for the basic format, the GNU format uses a base-256 representation
 	 * instead of an ASCII octal number.
 	 */
-	if (*(char *)ptr == '\200' || *(char *)ptr == '\377') {
-		long long res = 0;
+	if (*(char *)ptr == '\200') {
+		unsigned long long res = 0;
 
 		while (--len)
-			res = (res << 8) | (u8)*(++ptr);
+			res = (res << 8) | *(++p);
+		return res;
+	}
+	if (*(char *)ptr == '\377') {
+		unsigned long long res = -1ULL;
+
+		while (len--)
+			res = (res << 8) | *(p++);
 		return res;
 	}
 	return tarerofs_otoi(ptr, len);
-- 
2.43.0


