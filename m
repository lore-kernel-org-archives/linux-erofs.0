Return-Path: <SRS0=suzf=ZO=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B258C432C0
	for <linux-erofs@archiver.kernel.org>; Fri, 22 Nov 2019 08:59:22 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C3A1E20708
	for <linux-erofs@archiver.kernel.org>; Fri, 22 Nov 2019 08:59:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=haruue.moe header.i=@haruue.moe header.b="mnNqqNkM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3A1E20708
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=haruue.moe
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 47K9N76f3RzDrLw
	for <linux-erofs@archiver.kernel.org>; Fri, 22 Nov 2019 19:59:19 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=haruue.moe (client-ip=2607:f8b0:4864:20::643;
 helo=mail-pl1-x643.google.com; envelope-from=i@haruue.moe; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=haruue.moe
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 secure) header.d=haruue.moe header.i=@haruue.moe header.b="mnNqqNkM"; 
 dkim-atps=neutral
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com
 [IPv6:2607:f8b0:4864:20::643])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 47K9Mz422szDrKb
 for <linux-erofs@lists.ozlabs.org>; Fri, 22 Nov 2019 19:59:07 +1100 (AEDT)
Received: by mail-pl1-x643.google.com with SMTP id f9so2851781plr.7
 for <linux-erofs@lists.ozlabs.org>; Fri, 22 Nov 2019 00:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=haruue.moe; s=gsuite-haruue-moe-v2;
 h=date:from:to:subject:message-id:mime-version:content-disposition
 :user-agent; bh=UdOC7/gOzd81jhGMAUohwjrfawEQLqd2Gd1fx2N6f3A=;
 b=mnNqqNkM509YFGlFgUeenMdC5PPJkkOcIV5XX2HWRpBWBLiZ93lULeOdDK0O1K84f7
 FD4ZiouFKM5/W7cEpuumEkeVkqP2NkwS27aAJWZDqvgsTABXbvDZmP+16IJ0juUfmaaZ
 NRiOREFwD07CCK6OupY1pEMOh5J9VFyp15wFliwzzWJRHI9zXXadD4Et4MAuGta9LOxS
 fnakW3De+Y3G82raC+1S9hIPKSA2afaBFiZTPXOGsl58kw+uQ7RQMP+umRW85OfNAAvO
 5WLDu7Ww89nBMF5KSj9QGONDO9c6jiemoGgG9cc5HTrlLeo6WxjI4tTOWIZdIFGiS51V
 bJrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:subject:message-id:mime-version
 :content-disposition:user-agent;
 bh=UdOC7/gOzd81jhGMAUohwjrfawEQLqd2Gd1fx2N6f3A=;
 b=Qya6JIJn514GE0yn7YQrUFKX84RSep2PCPtMaplDfSXIsGYDC0TqVdVcQ0M8ZI8413
 Tq4yzEJIcIb104ZtZavvidt4FecNN5yFUh33+16tXrQ8cuwn12mZCx35QtS0RvqIQkJu
 vEHTCu/y5v7sBWltaZrAf0IQJNEPXmyDqzm5F7oLKy0lft5LU7ELB/c3HGHTSi0v1QAy
 RDXotBfwlxmwrXJWdBbGOMp+VJNB8V9TOshvGSRLekoCqM2loeuxOgpRds4f8AjUd9vQ
 A4Oeby+gVz9kafuKNbPKByju7Rr0viChqWGzbP07KoVCrGWGfq4F+vgFxjFnEPv8rT+q
 2Dtw==
X-Gm-Message-State: APjAAAWcWSeHZRLj40eLtejzNvzdhQGXfIAeBFMS8nG7zcwwxm+k1rwE
 Hz4KC6PeYMi2d0z6Ik9F6HcAKsLLXKc=
X-Google-Smtp-Source: APXvYqx2fHLBek906xd8NujpXuhA6aQc0SSd4U83FRAQnxbRPsLTssC8ZqpBTxuQ5vBjjDTZwq3RoA==
X-Received: by 2002:a17:90a:a00d:: with SMTP id
 q13mr17295441pjp.106.1574413143768; 
 Fri, 22 Nov 2019 00:59:03 -0800 (PST)
Received: from usamimi.host.haruue.net (216.39.92.34.bc.googleusercontent.com.
 [34.92.39.216])
 by smtp.gmail.com with ESMTPSA id a16sm5704179pgb.7.2019.11.22.00.59.02
 for <linux-erofs@lists.ozlabs.org>
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 22 Nov 2019 00:59:02 -0800 (PST)
Date: Fri, 22 Nov 2019 16:58:59 +0800
From: Haruue Icymoon <i@haruue.moe>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: fix configure.ac
Message-ID: <20191122085859.GA2414688@usamimi.host.haruue.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

./configure will fail when --with-lz4-libdir is not set, since
$with_lz4_libdir will be an empty string and generate an empty -L
into LDFLAGS. This patch fixes it.

Signed-off-by: Haruue Icymoon <i@haruue.moe>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index f925358..870dfb9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -174,7 +174,7 @@ if test "x$enable_lz4" = "xyes"; then
 
   if test "x${have_lz4h}" = "xyes" ; then
     saved_LDFLAGS=${LDFLAGS}
-    LDFLAGS="-L$with_lz4_libdir ${LDFLAGS}"
+    test -z "${with_lz4_libdir}" || LDFLAGS="-L$with_lz4_libdir ${LDFLAGS}"
     AC_CHECK_LIB(lz4, LZ4_compress_destSize, [
       have_lz4="yes"
       have_lz4hc="yes"
-- 
2.24.0


-- 
Haruue Icymoon
GPG: E16D 3FA4 E636 A602 2684  0D38 A54A 7E9C 812E EB09
https://haruue.moe/

