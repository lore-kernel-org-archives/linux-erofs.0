Return-Path: <linux-erofs+bounces-2446-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82DB1FD0040
	for <linux-erofs@archiver.kernel.org>; Sun,  1 Mar 2026 09:23:04 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fNxS63TDZz2xR4;
	Sun, 01 Mar 2026 20:23:02 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=203.205.221.209
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772356982;
	cv=none; b=LSWWhLZ4QfgBEtKMJqSKPpVsOgRCqvhdU+EszZ9Iq/w6ymq5X7ZqgoSl0OqrNcG9RDeGK3kc6K/kAcq78pif/zPBRKn108BYvJrcd8wQwTupLegK9ISaDTIbVZo7RjJ1N8PmFyfofKKi3r2tTmi3IF3KT1eEcjkTGVobii3oPGruPdACFURpvO4IPXMDzrxxOs6x6NhovEVcFuv5pF/bjCbLBIag5M3/6nZzwstfruKFTw4l4cyasR66EOd4DhjAphXxAjuNThEQ27DEM63xUrumGmKY5LKzQgSF5xW6NnFmbgoyDfUAxmqTH1kw5AjsURb22e4fgwNfEa3xvMoaLA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772356982; c=relaxed/relaxed;
	bh=el1xSxJCG/RiEpLV1h9eSA604ayMkg5f+jHIDP++nR4=;
	h=Message-ID:From:To:Subject:Date:MIME-Version; b=fHls1pbayP7AVu1j5Qwgw72N8N0nW3iruFmfKzwNbXwZzch2jZZfg3pCsz3Wu8kzzInXLVYUAQ8dszAmkchpqubVIByeB9lC7XKsVE3rSGECAYipbxhstGO85ZQlM4AXojfzYGvm/yB8RNnaS6KihhSSkPoJk/KUmObmpIL8DyxYVTikVw8qDi22lXxmzZBJvxtcqG9WHdQuF3GF1npL1uElcflxCJJqvUEYVnaWyFMU//ccQBiybxQWs0vBgL8yWgmjUGyQtgrLMCiRtNiWpvDAXnsiB6qgAl9zHVqxYmkzYdAEzzZm4wg/u6qIpo24zZfswxUILzd7TScsrC4p5Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; dkim=pass (1024-bit key; unprotected) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=zXo9aEFi; dkim-atps=neutral; spf=pass (client-ip=203.205.221.209; helo=out203-205-221-209.mail.qq.com; envelope-from=yifan.yfzhao@foxmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=foxmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=zXo9aEFi;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=foxmail.com (client-ip=203.205.221.209; helo=out203-205-221-209.mail.qq.com; envelope-from=yifan.yfzhao@foxmail.com; receiver=lists.ozlabs.org)
Received: from out203-205-221-209.mail.qq.com (out203-205-221-209.mail.qq.com [203.205.221.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with UTF8SMTPS id 4fNxS15zLpz2xQs
	for <linux-erofs@lists.ozlabs.org>; Sun, 01 Mar 2026 20:22:57 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1772356976;
	bh=el1xSxJCG/RiEpLV1h9eSA604ayMkg5f+jHIDP++nR4=;
	h=From:To:Subject:Date;
	b=zXo9aEFi/KB6E6SKPmKzV+Df8O1wFiS0JZbpWZ3ptDlF21c/arLLDJU9nzynRGJeI
	 oh28xPLJsHDEArT1BKBoSq0wmvgOsY9YWxltZheacoMTx15ZAymsGTxhjzzHtBYpYz
	 9/KzSzwedDLp8AmhyGs1vhg8Ap6e3qrEHqAy8pFc=
Received: from ZYF-DESKTOP.localdomain ([112.64.102.79])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id 4EE8022B; Sun, 01 Mar 2026 17:19:46 +0800
X-QQ-mid: xmsmtpt1772356786tovf0p100
Message-ID: <tencent_96714BBBDE4CE22ADE3214FDC8B3BD6B5606@qq.com>
X-QQ-XMAILINFO: N1S+bQX1UMGdqhQ1Li+ru2EjImqtyt/gqzt1nkkgOP9kuOtmftkZ8mA3aSUJCX
	 olySZoyefKy/+By0PghL+q55KKfNKCsAQgyaQ/iQ6Hh0PSz/sJqZ9soO/+aKTcAmcL3p6B3toTfi
	 O3KsLHE94Etjoy8bO6a6frwn0X2E9+dDetzyOa4UG6zlFIM8pTIhkoi66nOSk5j6k0VxkBR4NOQU
	 5c8IgvPUoqgxPCv5i+l2sOpfkI+wsE3YNgcoR+kYfDiA4+n7h1K9RKKOG9YmBtqu8ihduCVUzcbK
	 PPkNay1ukl8BwfTwIb58L/dyGNb22E5qES2nrQ/39Aa69i0AGFbDn5q74YguZQBoZPKny2fkysQC
	 c6A14dzTj6lKgmG98GeiEex8adUQ5xmug6m7BlUx+Qr3EkgZQGr9r5mirtafovmkzkozN5VbsI36
	 hHrSSd9zaSDRakb+TrzZq7YZWHI8JxHRX4MWZrgVYIh+pil1HFjymfdwDExvbOIqIRABoKk/A7eT
	 g0XYVz0ybGnIyqiOEuxxyt7AOHRKQ3jPFxoJ8e2ZizLf2I9aLrP+wgD+Ik5sN9xaIDDG6Evux1jl
	 6SzB6F08SXugZMBkiATk7b8q2NNSLQi70iEZQJGg0pssxnVPHanmBvY0Emza2Niim7PGtVqe5DIT
	 Zr9p4GqlpdG0vtCvW8zFK+6Gvx+yPlXZ8yZFn7K7AV+dv2aCY6ihZf23F265XLErVbPBdH4Ynbi+
	 yVoEDkNL+bpZ5ac6jcGRA6oOJG1ZlEUox5UQBBo0lNamPO7pfk5p6TkbhUFA7yrJPeoa9FpksjDi
	 A4x7Vj8j6KSKZmg5pQJaZvDrsd544ush0MS4Oy2mAKwnxJ5Vv2625qcBsmoXGR45khDWV7XPiie7
	 zegZhMie1xCF6iNn0tt+/lxcblLKP+nOuZ39mZGrGk9WNv/ZgJI/wSbIzkmNGCVWmpeU91QdWQL3
	 OoyiVdOnIiGXFtD0oSeEdPgNygs5XH110QkahS4r49hKFpYGVs9jx9JQvBDs1kW7u+OpifBG/4IC
	 R46q9SgaTLpmv3kohcr5BbaCNMhiVg1XHqvyim/8IEuTyNmuuApNIDOvqPLfMtX0r2fVY7H2sUof
	 ONBteaYOfbordr1yUGm7JKDeSgwNFCW1r/WMw3
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: Yifan Zhao <yifan.yfzhao@foxmail.com>
To: linux-erofs@lists.ozlabs.org,
	hsiangkao@linux.alibaba.com
Subject: [PATCH] erofs-utils: mount: fix flag-clearing bug and missing error check in parse_flagopts
Date: Sun,  1 Mar 2026 17:19:46 +0800
X-OQ-MSGID: <20260301091946.99253-1-yifan.yfzhao@foxmail.com>
X-Mailer: git-send-email 2.53.0
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

Reported-By: rorosen <76747196+rorosen@users.noreply.github.com>
Closes: https://github.com/NixOS/nixpkgs/issues/494653
Signed-off-By: Yifan Zhao <yifan.yfzhao@foxmail.com>
---
 mount/main.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/mount/main.c b/mount/main.c
index b04be5d..5686189 100644
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
@@ -307,7 +307,9 @@ static int erofsmount_parse_options(int argc, char **argv)
 			mountcfg.full_options = optarg;
 			mountcfg.flags =
 				erofsmount_parse_flagopts(optarg, mountcfg.flags,
-							  &mountcfg.options);
+								   &mountcfg.options);
+			if (mountcfg.flags < 0)
+				return (int)mountcfg.flags;
 			break;
 		case 't':
 			dot = strchr(optarg, '.');
-- 
2.53.0


