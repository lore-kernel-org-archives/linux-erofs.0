Return-Path: <linux-erofs+bounces-2738-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29473F013F2
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Mar 2026 09:11:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZ8V24xrfz2ygh;
	Mon, 16 Mar 2026 20:11:38 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::62e"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773652298;
	cv=none; b=gv6VY+/L+9WTAWLm8zN8DQ6haSO1fU2KyHRXICBhfoUrqPymKIauB06h4W0iUEo5iJb0fqcXrsEK8y7hfIXETLSgh8V9zOGtC197xlnNzG5wSIOvoIe+hC8OySYyqcA/BE1bENDY9C/5rG6lKcCViAecB1GlZ132wU+em3FxCodjMp5o/ZQroM/vInovdH7+lmMdMcJrdMeo5buQAOeCjaKB77HVLxpIREG8+SLKHnB5xvrCTfmY4yTKXCn25Xsnmk1rmlnkh8J2p6Q7cU1zfbDWYoHzMdmYaJoukHCqlfkzWbSrigrXj4q1GyDHl9JrWCIWtIo/6roa3BVptGaRaA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773652298; c=relaxed/relaxed;
	bh=sK8tqDC7U3A6sr53mcZziTz2tbG3ApswPW/HjjXhYuw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NYUMFHWSEfiwd5ivQ6GUeTctLOi7KcrV5g3a18qwBiMwFB+deVyK2GFrWx1xfBJp+VIQHM/LEFCxNUDc0s7AivL1VtMR7yfVWVfiJ+QeOzaq8Co/rSIk+79jI5Vi0350o2HNWEx51FuYc31DcdTgT/76KwCNn0vFcMWtNEJiwjyQ3dgeTTqYtJsTFQHkntFrLOblTJWGKCNQWUNUQVCjxJ0/w0Q3F9snM4vM7AKOsXWMZEPy0WZAFtEJh0V9tXTEGBH2TjhS9a8y3pc/8V/DSVGVRbINQ4WB3nUnps1psShJZW7Hy3FP9snE/roE6DaEjI4hz24TxfrVi2g35BeXvQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=L7eGZ3+6; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::62e; helo=mail-pl1-x62e.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=L7eGZ3+6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::62e; helo=mail-pl1-x62e.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZ8V14xPMz2xpn
	for <linux-erofs@lists.ozlabs.org>; Mon, 16 Mar 2026 20:11:37 +1100 (AEDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-2aae4d2d215so4486425ad.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Mar 2026 02:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773652295; x=1774257095; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sK8tqDC7U3A6sr53mcZziTz2tbG3ApswPW/HjjXhYuw=;
        b=L7eGZ3+62Knkf+lcOPL6+/+lO2KPvfNbHFdHiVJv6tFYMINCMv96CyDJZtacfECt5Y
         97Jp/L875DIfJX2aULmzCsLHOaPTPxPm6Fmh5sVvd5VBSdaNosRDq5nY+b6jSILz0oFM
         cm64BVcDQJhR76aW5hQqYJG9Xmf1QYHfX3WiJXyq6AY4BxGBdUHOSmigqfLYDt+U1gEY
         jn+vphyHxW44OE/K/+HB+m9YzlTQlaDtWo+fhUmhQ+m/1TzaLa+ll16RdACiETF8Ur7m
         FhjIByassLDHCAVDeKhOudgVpbcxo2dQ2/2fyYnH5DzduRxNdHzFaTzcJFhW7rtyzgIv
         eLOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773652295; x=1774257095;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sK8tqDC7U3A6sr53mcZziTz2tbG3ApswPW/HjjXhYuw=;
        b=rRL0am17ZF1YHeQkrjE9tmWxLDO+VMaJbvVpacuU5fFR78rKMgebwFYsk1sVcSI9fV
         VquFafKNaCL5Dr2/8XwMPSst7cblz2QObW2JkfyXiQMVlzzVj3ZqQUot9l9Wz/ZCpx2u
         sPcVIuHIDLbSkLZMuvDfL8EyEBXUkk9eIe3fA/G1sAHzr3ELHzpfGo8Xr5w1ZIILS+2o
         AG3xDihIQSp9+G39oSywouRyY6UaysUuw/GcFjHaNy04xZtm+l7TD2c3YhrvnPAnPTrA
         TP/2/89srYWgk9s7c6No32z68VRPIubkJSqrdm39irfomL1mxcJEne+rOTpbgJBDaShM
         /z/g==
X-Gm-Message-State: AOJu0YwKGmCaCRxPe7SXHiV+gLwHjjjm2wmjJDK1DBk1IJZDJ1/oQEsj
	QmxZZyie/Y8TP3BhdiFXsoniN/z7RAnqJxneFBGu4rIRSDLkZHksoRGA
X-Gm-Gg: ATEYQzyIsuBAgnCSXO8I1ONg5wW/kp032UQyWLaOR088UZuV6iyI+KaZOMIkwk1kLD8
	djUlfhfTqah1ae5eyYYrkSl3fnEA5yJ1CrnqqGYxR36q/QL2kwktnKLVBCSudbSfRxxdX/PZJTK
	vbQamKaGsGJV9hq+MsTevqcfxNayc6/xbDK2l5/mYZnwxiAbUV9Ez4fjP0d7JEuo32z7Doi63Yk
	YCtU8DWrnzLVGvCkqHkmBZ+G9thYLaHkl5zckQ/j2SPH4n4OsxnnemKhVZfFbpqBek/dvkdLndr
	4vriyt3iZheEgeQ97IwZoklEZurd9C1dFsu5pjVF2lPNb00dUPBqW6L5ZC2bVCCC0nQZ0qi2xJI
	Z2hA+Sn7qKL3Rlc3alyF126eKFXdvdZAQcn8kRwpZPY7RSyScoPV4fgH8OtnHCf17uxbxYzLhWy
	zscuqqhtbQs7cZhzKyTCxEovzeh1FzhkpXW3CfuG3FSzhr9OCrwtY+WYvX58Crd5AzWD/CRshrd
	1YRCHiOXge9tIhGn35sdCyi4uQSUrzXzSHWjw==
X-Received: by 2002:a17:902:ccd1:b0:2ae:cefd:18ce with SMTP id d9443c01a7336-2aecefd1e81mr71843715ad.2.1773652295243;
        Mon, 16 Mar 2026 02:11:35 -0700 (PDT)
Received: from DESKTOP-PU4IGQQ.localdomain ([117.203.246.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece62bc32sm104097595ad.36.2026.03.16.02.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 02:11:34 -0700 (PDT)
From: Utkal Singh <singhutkal015@gmail.com>
To: hsiangkao@linux.alibaba.com
Cc: linux-erofs@lists.ozlabs.org,
	Utkal Singh <singhutkal015@gmail.com>
Subject: [PATCH] erofs-utils: lib/tar: fix missing NULL checks after malloc() in tarerofs_read_header()
Date: Mon, 16 Mar 2026 09:11:27 +0000
Message-ID: <20260316091127.48847-1-singhutkal015@gmail.com>
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

In case 'L' and case 'K' of tarerofs_read_header(), malloc() is
called for eh.path and eh.link respectively, but the return value
is not checked before immediately passing the pointer to
erofs_iostream_bread(). On memory allocation failure, this results
in a NULL pointer dereference and crash.

Add NULL checks after each malloc() call and return -ENOMEM on
failure.

Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
---
 lib/tar.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/tar.c b/lib/tar.c
index 13e777a..5a6e07d 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -906,6 +906,10 @@ out_eot:
 	case 'L':
 		free(eh.path);
 		eh.path = malloc(st.st_size + 1);
+		if (!eh.path) {
+			ret = -ENOMEM;
+			goto out;
+		}
 		if (st.st_size != erofs_iostream_bread(&tar->ios, eh.path,
 						       st.st_size))
 			goto invalid_tar;
@@ -914,6 +918,10 @@ out_eot:
 	case 'K':
 		free(eh.link);
 		eh.link = malloc(st.st_size + 1);
+		if (!eh.link) {
+			ret = -ENOMEM;
+			goto out;
+		}
 		if (st.st_size > PATH_MAX || st.st_size !=
 		    erofs_iostream_bread(&tar->ios, eh.link, st.st_size))
 			goto invalid_tar;
-- 
2.43.0


