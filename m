Return-Path: <linux-erofs+bounces-2800-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B03FD876A
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Mar 2026 13:24:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZt2t2GCXz2yjV;
	Wed, 18 Mar 2026 00:24:06 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::530"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773753846;
	cv=none; b=i/JJNYh0ywj5SBxZn2a5ZGNu/LSU1QYV5Dz4nn6W7xg4PKsr4iLaCxFhq3dfivwyRcEXDv56gv4fGA5aPpxcp5LQeb7jVs9nATZQzsmz3Au4oJMgNc91j8cFXymfyO75nq3Ejj+Cy3tRs0KCAPv93WnV9t+k6aEClcJQB4Z1PNlQSeLa9nrzf/6U9ysyVtFL7YwiA7/NtgD8pTyGiuJ+qVnjalEtfzty1WnVjQWziw9BpEUpnV+3oibYNccpr1VY+O8UtOyOTuPWJPmzQ+sjGw+3OKSTAL6Es7fu1NhrD5Nb6qvwPMnCSixdSaKhyrIW9va4/MplrIvo8Sq49f2gag==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773753846; c=relaxed/relaxed;
	bh=wDkHRlFyBw3AqbHZfo12ncQp76Cu27YWrL4/LonMVsI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BgMXwiYuLlMb8oCyujKran/+SnfWolDUNNTlY4wfLl31y8B0mh35gwDqLcb0E5qLFSjU8kK4S9rN4Mvm8QAsWPV1R5qJ82rP9O4sl+GAEOorbN7dyPCPBUtZItKmRDkW3A5uMocVJLwXoRb0MobKLr7fp3YVBUfiyqtEgEXTU+ODsNYVJrbn2TKi4f6njYCIdJ3q2xTILfNbLV9PlDE2BJr33V6+oEAlHmhbDEpwR2nIm0rb94ijH7eERYoJWbEywbkEF3hzo0QgA2LC1+rk/O9rQmI6bcaxgiw+KEL+NoRLjrxwFuILUq7VfrPO8r0ES2Iody2JUR4hbnZJv30IJw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=jKEXj0/x; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::530; helo=mail-pg1-x530.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=jKEXj0/x;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::530; helo=mail-pg1-x530.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZt2s2PSpz2yh4
	for <linux-erofs@lists.ozlabs.org>; Wed, 18 Mar 2026 00:24:05 +1100 (AEDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-c73874b3ae2so190641a12.3
        for <linux-erofs@lists.ozlabs.org>; Tue, 17 Mar 2026 06:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773753843; x=1774358643; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wDkHRlFyBw3AqbHZfo12ncQp76Cu27YWrL4/LonMVsI=;
        b=jKEXj0/xTBJGyZDQZYey/OmxlxvNqfIOZ0J5qd25MDpQtl3L/8Nn8PDWXcIdH1gnSw
         vBt4l6reAuEz/zOTp1ApdIgx3z7jOoLsvrj+m4lM3QE0bg9PQ2ki4Amexp2mclnCqvyk
         ri9FZLO00UNe+6zMwbNBPYmT74Wwe6LC3E6EG4X8BOiqsLKmrTTFySXMLG7Zh2AIuKgq
         kQ5doHeI0l4zZ0jgdXbYchFx9CRqL+D606zul9VdCsaHBiWNEH+5FplfkiJrd2RR7QyM
         qwCtxVyugO49lMK8Gf6GMjDSHOaKeuBdrHEAMNflojV/Iyx71zBOSrnSdbEmdhKyaq2s
         X59w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773753843; x=1774358643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wDkHRlFyBw3AqbHZfo12ncQp76Cu27YWrL4/LonMVsI=;
        b=mJnAdQuVojrSc0AzAMoOAGydSCpKKWQM9JyOTpt/Ne41RRHMyIA1Ylc2WGshmI3d3J
         8KWWcmIkqhQtzlxej3jHRTibcD0NdPr7V7qEslvxk2mI3WYRiJsp9jrZVuKAkax+/HDJ
         skYM17fZw8KBnoNi/UiXioqWVm5iUbJhLvADRFonc6tTZ7qmVSFTxNC3wUQDbTt/CGKR
         72Hjkic+6QCdnVciLNa0Jgcmx90cudYQjuSolz7h7WwzEWv5z/+bHLehPISL8fGS3hKf
         cIn9Kud0/+sVpxErGkIKqe4t1BQuAaOuD+lJYubwth1ZLhACuN4Q3pDChYdyDhW8Ws5N
         96vw==
X-Gm-Message-State: AOJu0YwCHAJHLkGFJxDOaftCUxI+h5tyEnIeoXIDW8w92X0+MdoS0Gvs
	/w3Bj9S5mNiss0yyU3HO6fPuxumrlcyokKezMce2uIxmQxTGbXqjzCcmBvzav/qy
X-Gm-Gg: ATEYQzyT/27NVMq5ekHEhw2oYmbJlzkC05Sr5I9xsZDyBXTIokQJaYVb6n2SCcHHcAf
	VMzWcEOMGeR6MEmioCaMAkLgWRomWNcHFD9tp++ya+t6zP9Bqs5sPi06LPBOaT6A95+yWajHbVX
	xVno9Zpum3ep3JazTyP84MNt8gWfSSScMhKZ3DphHrKOgeDL3MJYbJzc59R2+FbQWfgW8OHo2Cb
	A8MNiIII6ObO3G5qnipgXmdjX+B8nG3icDWQ4F0FFAVgajXV0/FkFsKqfptySBSx2aXlSDavmdy
	HBeanee7a4WjOjvVFR49H95+d9Vig8OeveBy7oKRdThRjXMlKaNJ6+O7uk3cW8gMuPL3oQh0Vky
	94UkU5GHf4Fd0Dggtf1dTuzrSols9+HnbffYx75hLZoAaOvhrf82ub/ff5V/r1hj2Oim4Cgf/AB
	Xz6mU7qS83OEfmLwzDm58kFo/VTDodJHw0tCWz10a0U64/sscDpnLXH36Ra7WmNDouRH6VECelp
	KbvruN5QroDaLGaCIsrnYOHX5Q7E/OFg6Lch54CmXDr093m
X-Received: by 2002:a05:6a00:ae09:b0:82a:1589:311b with SMTP id d2e1a72fcca58-82a196bb525mr8149373b3a.1.1773753842708;
        Tue, 17 Mar 2026 06:24:02 -0700 (PDT)
Received: from DESKTOP-PU4IGQQ.localdomain ([117.203.246.41])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a072422desm17215042b3a.1.2026.03.17.06.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 06:24:02 -0700 (PDT)
From: Utkal Singh <singhutkal015@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	yifan.yfzhao@gmail.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	singhutkal015@gmail.com
Subject: [PATCH] erofs: harden h_shared_count in erofs_init_inode_xattrs()
Date: Tue, 17 Mar 2026 13:23:56 +0000
Message-ID: <20260317132356.15341-1-singhutkal015@gmail.com>
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

`u8 h_shared_count` indicates the shared xattr count of an inode. It is
read from the on-disk xattr ibody header, which should be corrupted if
the size of the shared xattr array exceeds the space available in
`xattr_isize`.

It does not cause harmful consequence (e.g. crashes), since the image is
already considered corrupted, it indeed results in the silent processing
of garbage metadata.

Let's harden it to report -EFSCORRUPTED earlier.

Fixes: 47e4937a4a7c ("erofs: move erofs out of staging")
Cc: stable@vger.kernel.org
Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
---
 fs/erofs/xattr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
index c411df5d9dfc..aaac37c6bb78 100644
--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -85,6 +85,14 @@ static int erofs_init_inode_xattrs(struct inode *inode)
 	}
 	vi->xattr_name_filter = le32_to_cpu(ih->h_name_filter);
 	vi->xattr_shared_count = ih->h_shared_count;
+	if ((u32)vi->xattr_shared_count * sizeof(__le32) >
+	    vi->xattr_isize - sizeof(struct erofs_xattr_ibody_header)) {
+		erofs_err(sb, "invalid h_shared_count %u in nid %llu",
+			  vi->xattr_shared_count, vi->nid);
+		erofs_put_metabuf(&buf);
+		ret = -EFSCORRUPTED;
+		goto out_unlock;
+	}
 	vi->xattr_shared_xattrs = kmalloc_objs(uint, vi->xattr_shared_count);
 	if (!vi->xattr_shared_xattrs) {
 		erofs_put_metabuf(&buf);
-- 
2.43.0


