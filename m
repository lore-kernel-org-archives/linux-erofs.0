Return-Path: <linux-erofs+bounces-2452-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AE1AE9B36A
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Mar 2026 12:29:24 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fPdXf4nYrz3btS;
	Mon, 02 Mar 2026 23:29:22 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::432"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772454562;
	cv=none; b=KN8JmMmIc+u/UiqII7Mn2/RshzG2c+BwfMP56WeBjdOzcFmD2SsBKsbqBOabFKJ4VVYLJusuM+1HzTI/oKmELVWgqus8h4T6ZwUBWgenh0ZH9ZtaYCDscZh2yLYQ36IXleFL44H2yLnA2F3G8pIRRST+2eyxvJMlYTa/+S2NsI1dGgrpiAroW4je7xZH/DVv+55Q+n8oLNFzT8xcmVhCH/fmYvmhRXuEpvPVIGS34Vvo8BX48weqe2Xmy8FMsBjrGwYTINI8pLiMY6G/9xj8DpFP/l3lsprIUMo/BNqPsy2B/J1Rt8h1PeQ3tccgxYm4TiFl3WOTrVl/u7r4PSQxfA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772454562; c=relaxed/relaxed;
	bh=kG16c1sDYe3TyH1iYdzCyMngiyeEqWIPPMfKug2p/8o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YotApkMT2yFIdCgHncvfEWY/auyF7rMff5iXwPHAnfoisIK1/0RHAtizLF4BJq161n2+Q5tzwVAdoDtUQYqgEHWd5RYsxXDRM3WFhQbHkNfS3n36FR3N1rfUtZMW5jE6hocXOr0faKWar9af8AoKRspqgjSZr1t3V3HQbTwzuZGx2vFdXuMb2blSk0n0hYmtiwueqwCWbYfDVDWZWYS2NrbnJIzhVYcBkCrGbyJTud63dBwj8FQQgeDmppF860zzUnYWQa48YJiQ87k+F1OeTG5ODao0zePnFlXHVIgOwprEvhHsLB5p5SBa0FLh4tJ4WgB7nG4QqC4PO46RNGfxow==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=Rry8AX0f; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::432; helo=mail-pf1-x432.google.com; envelope-from=hardikkumarpro0005@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=Rry8AX0f;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::432; helo=mail-pf1-x432.google.com; envelope-from=hardikkumarpro0005@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fPdXf0Nymz3bW7
	for <linux-erofs@lists.ozlabs.org>; Mon, 02 Mar 2026 23:29:21 +1100 (AEDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-8274843810cso2274847b3a.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 02 Mar 2026 04:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772454560; x=1773059360; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kG16c1sDYe3TyH1iYdzCyMngiyeEqWIPPMfKug2p/8o=;
        b=Rry8AX0fU3orgi9A2zwMDhHzRtk3Gd2N1SYFYbiydugV6UMEhU6wSe/GyH9aB8M8/T
         +cAsuGRbZJpPR5FYTmOLBirgEhMhSqFvdGZvOd2JLFxC88EGc795i1OKsPEyaw/179Bq
         56BtdALvHlmtoe3c69RAwSGz9h6uH0sVMyglc7LhgdhyayedekAjQGdEruVFw/fkiLNP
         ZNP/IOZv/bKAqXq06BRUkA8oEUgDGdQ4GBglYHD9k0sHPVVVZ2Xo7hZ9QxGwTPIQ9ebs
         s0NZEptlCBD9hjq5CAfNyai034jWAHcda+ur8Yu2FHWYm7kFMuK6F+97kY1yBaRlHyZM
         0/Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772454560; x=1773059360;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kG16c1sDYe3TyH1iYdzCyMngiyeEqWIPPMfKug2p/8o=;
        b=KTy+1xaxRDi2gVLZEAlKKclYU5ex2hXVjk1PM3gjfHv4KdpkQt30ws3/1zIlI18hu1
         lgCBcxckd28Gm+CYZKKKEEw3Aqkw8XDH2wDx8FjTer3V2eTGZTrAGVBtajR7VqalRAox
         HcO09eAOEDmy/P2j/yNorfNwfHClfVmx42QCCmYuRHLpFeVBB5aJ2CJ6+suDtf8ECSjl
         +3S2H9Y6lMXVlUquyU3gzBHlpweUHdqnFArLKNryr50U8+ogcwAQDnsZAbLBC197S/CD
         Fl9ROoph0tcr7q5n1opbMFbdPU2N7rUNl2a8+zNylIw7SQ9nyTAhB8hwTJCF2ZP18t99
         7F1A==
X-Gm-Message-State: AOJu0YxSdPrqdK2/TYndhlDz+ZoFg35X9Gnb/YjoHirTNiNdSSRq5V4x
	0ZTrtJ1kR8aT/csfP2Us6r1Vxw9z2Qvy9XyJRu5YMYOes7yQh+oTwiInsIkmd0/7
X-Gm-Gg: ATEYQzzywbJ+OSic8PWOdyLpZYmheZ72N11ZKTh72Js7JrhIQQ62OjjGuIx4WdHdvyN
	qRKz7B42xbJOPyZe8v8awaRmR2l/OIvsTjdtTSUGYliL6KUXT5WAqhR+Vi1ldIqgQojV25BYlYb
	BZFW2zxRfwGhT4Q2x84UFygz307NzOMhLz2o62KEvNLcSjETe/IAYVVi6WFPSlT9cMfI7yMiQo6
	rB6k8luEp6uxYFplrvIydp00at3J3vxIPogKNjJ7nebNXYpk/LRu33uX5uYUcUuMW/zNE30wLNM
	7P5iU4vQlHU8DpxIqe6Uo0iE7kSYiSdI6zKm9cmvlGrGcr2Zr/A4G20V43iXGKAirjLHmYuU3Lk
	B1kRAaeOXXN8xjwqSlJeGX8CkJbSq/BqBm00Fe6jT3499gjoQqKDuSgj8y9j/CdEesNaU1dBKQW
	UNJswECGLd2uZv9Q==
X-Received: by 2002:a05:6a00:339a:b0:7e8:4398:b34f with SMTP id d2e1a72fcca58-8274d9ebde0mr10578508b3a.34.1772454559803;
        Mon, 02 Mar 2026 04:29:19 -0800 (PST)
Received: from vitap ([2a09:bac5:3e0a:16aa::242:a3])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739ff34fesm12249864b3a.42.2026.03.02.04.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 04:29:19 -0800 (PST)
From: Hardik <hardikkumarpro0005@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: hsiangkao@linux.alibaba.com
Subject: [PATCH] erofs-utils: mount: fix flag-clearing bug and missing error check in parse_flagopts
Date: Mon,  2 Mar 2026 17:59:13 +0530
Message-ID: <20260302122913.1838-1-hardikkumarpro0005@gmail.com>
X-Mailer: git-send-email 2.53.0.windows.1
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

From: Yifan Zhao <yifan.yfzhao@foxmail.com>

The MS_* constants in glibc's <sys/mount.h> are defined as members of
an anonymous enum whose underlying type is unsigned int (because the
last member, MS_NOUSER, is initialised with '1U << 31').  Therefore
~MS_RDONLY, ~MS_NOSUID, etc. are unsigned int values that, when stored
into a 'long flags' field, undergo zero-extension, not sign-extension.
As a result every 'clearing' entry (rw, suid, dev, exec, async, atime,
diratime, norelatime, loud) produced a positive long, so the
opts[i].flags < 0 guard in erofsmount_parse_flagopts() was never true
and the corresponding flags were set rather than cleared.

Fix by casting the operand to long before applying bitwise-NOT,
ensuring the result is a negative long with the correct bit pattern.

Also add the missing return-value check for erofsmount_parse_flagopts()
in the '-o' option handler.

Reported-by: Robert Rose <robert.rose@mailbox.org>
Closes: https://github.com/NixOS/nixpkgs/issues/494653
Signed-off-By: Yifan Zhao <yifan.yfzhao@foxmail.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/tencent_003DF0338EAB42F1573BC0CCFBEACE321E06@qq.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 mount/main.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/mount/main.c b/mount/main.c
index b04be5d..dbee2ec 100644
--- a/mount/main.c
+++ b/mount/main.c
@@ -203,15 +203,15 @@ static long erofsmount_parse_flagopts(char *s, long flags, char **more)
 	} opts[] = {
 		{"defaults", 0}, {"quiet", 0}, // NOPs
 		{"user", 0}, {"nouser", 0}, // checked in fstab, ignored in -o
-		{"ro", MS_RDONLY}, {"rw", ~MS_RDONLY},
-		{"nosuid", MS_NOSUID}, {"suid", ~MS_NOSUID},
-		{"nodev", MS_NODEV}, {"dev", ~MS_NODEV},
-		{"noexec", MS_NOEXEC}, {"exec", ~MS_NOEXEC},
-		{"sync", MS_SYNCHRONOUS}, {"async", ~MS_SYNCHRONOUS},
-		{"noatime", MS_NOATIME}, {"atime", ~MS_NOATIME},
-		{"norelatime", ~MS_RELATIME}, {"relatime", MS_RELATIME},
-		{"nodiratime", MS_NODIRATIME}, {"diratime", ~MS_NODIRATIME},
-		{"loud", ~MS_SILENT},
+		{"ro", MS_RDONLY}, {"rw", ~(long)MS_RDONLY},
+		{"nosuid", MS_NOSUID}, {"suid", ~(long)MS_NOSUID},
+		{"nodev", MS_NODEV}, {"dev", ~(long)MS_NODEV},
+		{"noexec", MS_NOEXEC}, {"exec", ~(long)MS_NOEXEC},
+		{"sync", MS_SYNCHRONOUS}, {"async", ~(long)MS_SYNCHRONOUS},
+		{"noatime", MS_NOATIME}, {"atime", ~(long)MS_NOATIME},
+		{"norelatime", ~(long)MS_RELATIME}, {"relatime", MS_RELATIME},
+		{"nodiratime", MS_NODIRATIME}, {"diratime", ~(long)MS_NODIRATIME},
+		{"loud", ~(long)MS_SILENT},
 		{"remount", MS_REMOUNT}, {"move", MS_MOVE},
 		// mand dirsync rec iversion strictatime
 	};
@@ -281,6 +281,7 @@ static int erofsmount_parse_options(int argc, char **argv)
 		{0, 0, 0, 0},
 	};
 	char *dot;
+	long ret;
 	int opt;
 	int i;
 
@@ -305,9 +306,11 @@ static int erofsmount_parse_options(int argc, char **argv)
 			break;
 		case 'o':
 			mountcfg.full_options = optarg;
-			mountcfg.flags =
-				erofsmount_parse_flagopts(optarg, mountcfg.flags,
-							  &mountcfg.options);
+			ret = erofsmount_parse_flagopts(optarg, mountcfg.flags,
+							&mountcfg.options);
+			if (ret < 0)
+				return (int)ret;
+			mountcfg.flags = ret;
 			break;
 		case 't':
 			dot = strchr(optarg, '.');
-- 
2.53.0.windows.1


