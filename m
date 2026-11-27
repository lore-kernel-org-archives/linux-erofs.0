Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6EA606A31C
	for <linux-erofs@archiver.kernel.org>; Fri, 27 Nov 2026 03:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=unisoc.com header.i=@unisoc.com header.a=rsa-sha256 header.s=default header.b=KjQUn0o9
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jbJcF2PNgz2xqh;
	Fri, 27 Nov 2026 14:21:49 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=222.66.158.135
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795749709;
	cv=none; b=E9W2VSx5Ubm1DlI4H2FddTmbrKshowJLulsHst2h5rLL1gYBbs5KWtDrrFL3xSnwVD23C79HuEhGYGqIsokHvofF8OE0IC446W0DxJNwzFL8Kn711qeEZEKyyerTjcZsxb2dD6OlY+ouRXe6n24fpK3MTMZgOi0BbiZ8geRtJ9TlVjlEUd0++fEgl783jPYO6wDX0MATyG0LNv7HJ5gt3m+846mRcRieHVQxMEOLYX504RVvEurMvJEESC7QFnVsbf8GDxfmfpzjCa0odhvB5y6p1Cy4VV/c3DxOV/fVcTm8MNrFdzP8zElcCjS4KZCvXKzy2sa6jwLqzzo1a/qvGw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795749709; c=relaxed/relaxed;
	bh=bF4hh22n+MdlZ7aJdmfged1+CobUKKXMbXYtIJKVVb0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TF5ZjiyLkLLV+L2iHYjpmxuv8TtrcQ41SJOXoe1+id6OLMR9SiiBXgZjwPpKCKkNxptHQnLBZosf8caoe8U4qBgFxaidlF8+dY4QlvYHF/sgHiacte44/K6m/kYSyoTh7gnRvB9AZeBUsuS81n/5RK69KDu7p0Vb1asLxJSQBV0ZDEk67DE4h4G5eo4DrHBDwXNy4nLQguoO9wok+fPh5PP12r+yaZwwuQKWx5BezClf90jvNwTFAjKCfEUOk4tFu0/Fy71MI5qm6+BVlEnwkDEr5/OscK7ZRWjXNgFbUa2wKutwbw2UvMAbA1LDC327HCOrBEkrO1YT3rYsNNAU6g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=unisoc.com; dkim=pass (2048-bit key; unprotected) header.d=unisoc.com header.i=@unisoc.com header.a=rsa-sha256 header.s=default header.b=KjQUn0o9; dkim-atps=neutral; spf=pass (client-ip=222.66.158.135; helo=shsqr01.spreadtrum.com; envelope-from=zhiguo.niu@unisoc.com; receiver=lists.ozlabs.org) smtp.mailfrom=unisoc.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=unisoc.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=unisoc.com header.i=@unisoc.com header.a=rsa-sha256 header.s=default header.b=KjQUn0o9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=unisoc.com (client-ip=222.66.158.135; helo=shsqr01.spreadtrum.com; envelope-from=zhiguo.niu@unisoc.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 1399 seconds by postgrey-1.37 at boromir; Fri, 27 Nov 2026 14:21:45 AEDT
Received: from SHSQR01.spreadtrum.com (unknown [222.66.158.135])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jbJc965FCz2xLs
	for <linux-erofs@lists.ozlabs.org>; Fri, 27 Nov 2026 14:21:40 +1100 (AEDT)
Received: from SHSQR01.spreadtrum.com (localhost [127.0.0.2] (may be forged))
	by SHSQR01.spreadtrum.com with ESMTP id 6AR2wQju025113
	for <linux-erofs@lists.ozlabs.org>; Fri, 27 Nov 2026 10:58:26 +0800 (+08)
	(envelope-from Zhiguo.Niu@unisoc.com)
Received: from dlp.unisoc.com ([10.29.3.83])
	by SHSQR01.spreadtrum.com with ESMTPS id 6AR2ux50012534
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 27 Nov 2026 10:56:59 +0800 (+08)
	(envelope-from Zhiguo.Niu@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX02.spreadtrum.com [10.0.64.8])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4jbJ2S2X5nz1VVg;
	Fri, 27 Nov 2026 10:56:00 +0800 (CST)
Received: from bj08434pcu10.spreadtrum.com (10.0.70.50) by
 BJMBX02.spreadtrum.com (10.0.64.8) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Fri, 27 Nov 2026 10:56:57 +0800
From: Zhiguo Niu <zhiguo.niu@unisoc.com>
To: <xiang@kernel.org>, <chao@kernel.org>
CC: <niuzhiguo84@gmail.com>, <zhiguo.niu@unisoc.com>, <ke.wang@unisoc.com>,
        <zbestahu@gmail.com>, <jefflexu@163.com>, <dhavale@google.com>,
        <hongbohbli@tencent.com>, <guochunhai@vivo.com>,
        <linux-erofs@lists.ozlabs.org>
Subject: [PATCH] erofs: print error code in erofs_err() of erofs_readdir
Date: Fri, 27 Nov 2026 10:56:36 +0800
Message-ID: <20261127025636.1333457-1-zhiguo.niu@unisoc.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SHCAS03.spreadtrum.com (10.0.1.207) To
 BJMBX02.spreadtrum.com (10.0.64.8)
X-MAIL:SHSQR01.spreadtrum.com 6AR2ux50012534
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1795748251;
	bh=bF4hh22n+MdlZ7aJdmfged1+CobUKKXMbXYtIJKVVb0=;
	h=From:To:CC:Subject:Date;
	b=KjQUn0o9Ac8tWFxAPfrZzUVejzJtz8hM7oz3fnsZpu05drr0UjaflOnOeRdWrxB0I
	 xJ1xq0mOAhmtuRS+sMWDZMImmQE8sLhYdsGR5V2zOuGBfodTNuc++Cb4XeN/3/A5lL
	 PkT/Urq0a/eyyBPsWiRCkcVBqpcx9TNME7r99OY+y5D/bltUupV/mbWnpFsWSr66NZ
	 Jfn8eGhqoGI53ZMqqy9BuvPAIfpYTlYEk9aKwphilKe/QZ4B8d2hgSnSidUXh08bym
	 I6ZKXVoChDOtidmbfp+3dYjj9uHg8/RL97VgVMpnFpDILDoVlQXbcFX/rS0L2pG8qY
	 F1irenQdkfmgQ==
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Under system stress tests, the following log frequently shows up:
erofs: (device dm-8): erofs_readdir: failed to readdir of logical
block 0 of nid 124

Without the err value, it is hard to tell whether the failure was
caused by an interrupted read (e.g. -EINTR) or a real I/O problem.
Print the error code so that we can get more clues to the problem.

Also fix the similar codes in other erofs_err() call sites where a
real error code is available but not printed:
- erofs_read_superblock: "cannot read erofs superblock"
- z_erofs_init_pcpu_workers: per-cpu workers allocation and CPU
  hotplug init
- z_erofs_readahead: "readahead error at folio ... @ nid ..."

Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
---
 fs/erofs/dir.c   | 4 ++--
 fs/erofs/super.c | 2 +-
 fs/erofs/zdata.c | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/erofs/dir.c b/fs/erofs/dir.c
index 4aa52a5f204a..69aea8a7c3dc 100644
--- a/fs/erofs/dir.c
+++ b/fs/erofs/dir.c
@@ -83,9 +83,9 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
 
 		de = erofs_bread(&buf, dbstart, true);
 		if (IS_ERR(de)) {
-			erofs_err(sb, "failed to readdir of logical block %llu of nid %llu",
-				  erofs_blknr(sb, dbstart), EROFS_I(dir)->nid);
 			err = PTR_ERR(de);
+			erofs_err(sb, "failed to readdir of logical block %llu of nid %llu: %d",
+				  erofs_blknr(sb, dbstart), EROFS_I(dir)->nid, err);
 			break;
 		}
 
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index e92a7fa90ae3..39f195e6d10b 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -273,7 +273,7 @@ static int erofs_read_superblock(struct super_block *sb)
 
 	data = erofs_read_metabuf(&buf, sb, 0, false);
 	if (IS_ERR(data)) {
-		erofs_err(sb, "cannot read erofs superblock");
+		erofs_err(sb, "cannot read erofs superblock: %ld", PTR_ERR(data));
 		return PTR_ERR(data);
 	}
 
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index e981e371d6c2..02a5342cec9d 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -416,13 +416,13 @@ static int z_erofs_init_pcpu_workers(struct super_block *sb)
 
 	err = erofs_init_percpu_workers();
 	if (err) {
-		erofs_err(sb, "per-cpu workers: failed to allocate.");
+		erofs_err(sb, "per-cpu workers: failed to allocate: %d", err);
 		goto err_init_percpu_workers;
 	}
 
 	err = erofs_cpu_hotplug_init();
 	if (err < 0) {
-		erofs_err(sb, "per-cpu workers: failed CPU hotplug init.");
+		erofs_err(sb, "per-cpu workers: failed CPU hotplug init: %d", err);
 		goto err_cpuhp_init;
 	}
 	erofs_info(sb, "initialized per-cpu workers successfully.");
@@ -1896,8 +1896,8 @@ static void z_erofs_readahead(struct readahead_control *rac)
 	while ((folio = readahead_folio_last(rac))) {
 		err = z_erofs_scan_folio(&f, folio, true);
 		if (err && err != -EINTR)
-			erofs_err(realinode->i_sb, "readahead error at folio %lu @ nid %llu",
-				  folio->index, EROFS_I(realinode)->nid);
+			erofs_err(realinode->i_sb, "readahead error at folio %lu @ nid %llu: %d",
+				  folio->index, EROFS_I(realinode)->nid, err);
 	}
 	z_erofs_pcluster_readmore(&f, rac, false);
 	z_erofs_pcluster_end(&f);
-- 
2.43.0


