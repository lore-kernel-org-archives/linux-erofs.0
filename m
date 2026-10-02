Return-Path: <linux-erofs+bounces-4650-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11B14CA5FC4
	for <linux-erofs@archiver.kernel.org>; Fri,  2 Oct 2026 16:41:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hxF0s6k3Zz30MY;
	Sat, 03 Oct 2026 02:41:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=202.12.124.145
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790959293;
	cv=none; b=KK+fu3MIzjfTLWVV9IE1WgrWXLYFr30AxZXC3xctUJZ714f21cWq8ZXzg7RsgTocHTNjsnbLz8f/k8Eb18i0F7CS9nBo1yiFshV8ub+zRIuZdVGkd/9v/jr0m7ku7vh8Pa3XFHg2cieVNt/eSe6p8mHjgoZGF7V/eg9jFBOKcJCXh4F3Tdh2N5ZLH8wKQJh64Xlzgw/wOg9xHASj4jJpOwxoRfnrtzjAbSjqBhZAbXLzW/LOqOmsuGlZ3xQ0Um2QboODCL6HA0FYw9i9xPoSg9yHEAk3t5/lkZImnE9h2dNWzi9SWsdURyykCKDvnRzKHTOHVQpxsplZesZ4QISRkw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790959293; c=relaxed/relaxed;
	bh=8vp//EYtL+iFtkFUXaNxAHh7uSWfdznnpRMjVFiTc+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEF6DtXIvwiphxEwyKH40rt7uTLybIImO6i1p8bFaPQUH4vn8fpW8pFwdbpm8kK4LTmHfAH7oSPi1XNeUIS4VtBC8jCl4zN9dohJo1g/rjaTAKKdVPCgGVLTwuVF35xzuQssZW26wNm3xqYzM8jQvkz3PXJQhGu1dB6AYWMooA9eeihQm5NfhMA49lz2ipRoFsErD92QmDFtWV1Rm3fXuqTM5uR1EJjC+JqhRlCMjmyMVtSA4Jb4vFL1k50sGoj5J5vqLyq/pPJ1++G7eryQA14cLwklNEq/FI+5i17G22ErQ/Z2H7S7+mcTJj/6FUqa3JLgTFn5VQBckRP/Brh8Mw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=scrivano.org; dkim=pass (2048-bit key; unprotected) header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm2 header.b=PD/beOeM; dkim=pass (2048-bit key; unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm1 header.b=k00m7no3; dkim-atps=neutral; spf=pass (client-ip=202.12.124.145; helo=fout-b2-smtp.messagingengine.com; envelope-from=giuseppe@scrivano.org; receiver=lists.ozlabs.org) smtp.mailfrom=scrivano.org
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=scrivano.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm2 header.b=PD/beOeM;
	dkim=pass (2048-bit key; unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm1 header.b=k00m7no3;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=scrivano.org (client-ip=202.12.124.145; helo=fout-b2-smtp.messagingengine.com; envelope-from=giuseppe@scrivano.org; receiver=lists.ozlabs.org)
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hxF0p1xX1z30DK
	for <linux-erofs@lists.ozlabs.org>; Sat, 03 Oct 2026 02:41:30 +1000 (AEST)
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 6E5531D00082
	for <linux-erofs@lists.ozlabs.org>; Fri,  2 Oct 2026 12:32:43 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 02 Oct 2026 12:32:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scrivano.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1790958763; x=
	1791045163; bh=8vp//EYtL+iFtkFUXaNxAHh7uSWfdznnpRMjVFiTc+M=; b=P
	D/beOeMJd3dCiiqwdkv2QjKfJczKKQJ9TUfOIYiTcPDlG5MX2on7f3D90k5N7z4/
	pkTPz3XKoq5R4J54SXXNyDGIFbU2l9MmQOEXPCciblnse4G9mBjM7PzTSeQv4TEU
	iPHUtIsL2IMOtoAoJnW2aSbOxg3YC347ko64t2nUzaiIfgrYyMJWMpXpoKEePM3D
	Kq2ef3NGMRu13MHY1z69h4DH0Sq3Mbu3l0e/BHuNEyJKEYO5BnnT0lCbk9hDAK8C
	fTGkN1wTa+HjOYUqpW2Uoy6o3DOifbS4YWjai6CpvkuaPQMrv+P8SZVZ8St1b8r2
	hRMxqHyMqyEyOk58FEeTQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790958763; x=1791045163; bh=8
	vp//EYtL+iFtkFUXaNxAHh7uSWfdznnpRMjVFiTc+M=; b=k00m7no3wczKOklBQ
	wtJ5UQoAMksWLntrzvdAjeLmOGtmjniJD5159LNWxIQH07MZxh8pPBf6UR2fLY07
	ephOWKjgGJX320jjEsPLNyVk8wi9ONawTjcH0CWR3rzU34FOdbW1Mkmx2KzRYsTy
	5sCBs3D1LVSRttvJ7odDGu61V6QU6hY+NXyj9cwzbksPgYSO68b8YBxrZALRxjFK
	xKjA9s31RLS47XrzCLIXvJiZnPKugs/ZYsD/C12gjWTbemxTSdoSFYhezbJoVAO6
	Cs4hVX6ubGQSiQxSvln0SlRj62PYSre3bQdp3Vb+kozWrtbmzogbnfEzd8G/yY9Q
	JqdNA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=scrivano.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1790958763; d=scrivano.org;
	mf=PGdpdXNlcHBlQHNjcml2YW5vLm9yZz4=;
	rt=PGxpbnV4LWVyb2ZzQGxpc3RzLm96bGFicy5vcmc+;
	s=fm2:rsa-sha256:NkYh62gnTZu/iXChFxyy8mWn4MILBKKqqJhwbYfbjtHTciS
	GcGyOi2aEn1otKoI/+G6K7cBEHt5V4AKWA8pjfz5JlFq0tbcH9ItYB1QXUDQNk3Q
	BAhJnll9uKnfDcICcmY+mIp1uRBbxj+n3TTZujsip9TPAotqOMF6uKskxUEBWxvl
	/41KGeAiozqaTaqOChNVC2fLyoxr/fhyjsEmvMH+8Jy3yFcvFlTsYeeaS5doJDK6
	5XcSWwtIqA/gKUg+XjomRRHKfZfixED66X5YqykC78K8gYvtbtXB0v5dS14UVV0a
	jMwBvauHs9o2c+ANp1CZMQ8247BP6dwi0GBTqWA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:9SqiUAun+oEWwrPyv8hamiqiDlKwuzhtXBzBd701il0=:lQpivocvX8TwoIn/ANFvEtXWnmS+qxxoOfVIvbKujMo=;
X-ME-Sender: <xms:qty_au6K39f3Bcac8Vk7_S1oZCdYZkBbgeFYwBLImAvexE-n5VayhA>
    <xme:qty_ajk0Dqzb02baS4xPgUYDxiQl7AR2MDv7q5UoB812B0P6s_16POiWnxYUF67IX
    AUjlUYYXB_R56K_SuCgHJBAkLh6MI1f__a773IKaj2pQwEYoMfkbGDk>
X-ME-Received: <xmr:qty_ap5z-MdqNGRW_fsqvINv7ifjfMiBG4QPOvaZUbzDXmX6SzUuuEQdj2mtZz8AMNnQORIlB1hb55-o4ptbPNFcSIIn>
X-ME-Proxy-Cause: dmFkZTGyqCDolNR0R7DZGwMzWNDpoJILu2jykM68ma+dDc4C112fFIur3VtfzrPwrSoPe/
    w73eKAXEp2+IXQktv6IQ+UxhEt9Szb57K8oXMVhPBJouBdWFZMV69AeCfZpfq5QRP7dsZC
    Uj/MuGmyIWY1s1nDAm8d2XRJylXM9trGrNPh0aSg/b8LjXeZoqLsS7aaLe+OzyV9npE+1x
    D7hm62C3NjWWnwp0e+o1GO5DbRrr1ZQ6z4FcBPpuMPK6lEvbImxnP1QSsEy1Lu1JbSi1a2
    aVMZfF3IUsevuSme/8yTAwynuSJhBaQHK25L0mqWcuPbJzTeUSB/HrvfyAcWZP3qYhYWBp
    DmLc7E1KpMUJxQoxXq+Ec7O7XLWPU0wxRyUjGsykn+yq2GSiETnFyhLlKXEM/Zx4YyokAf
    4t8sDHYiApsD9e5ssT+gHWSa+KRpcOsdsqUrFOn78xTgo0/Gn4/0b3NO5zXlw/lVBm5C5U
    QzSXqqPnTQ/yQtBTM/5u5ysimXsH/nb52IkPrIGXOTuizTXrVisU251rWrJTdVosYAhF8s
    XhIxZ5nxm/BGatnHAuWh6VMDJKU5FjiQ/0+XFI/WtbSTNqn+psmNWjlX+WvHaa7FrqTAIU
    +y1JSUwGaZqQBd35fXzJoIrJBfTESGIicHO2Mf9n6NMxe0ThlDD0HfkFB+Iw
X-ME-Proxy: <xmx:q9y_akQGb1LV0YLSAQ7W30i_vgUqAhplBwG7AjYcByJU30_f5AhgOA>
    <xmx:q9y_anw6mXDAFGB_x3cG5fIeEHcNrnmWY2DUoMQgjCBsOBGHUG73sw>
    <xmx:q9y_asq32aFvacRkzGWtk5z6iFVTMjEy1kMMJlyjnFy0UsNuSI-L7w>
    <xmx:q9y_aq3NfOGKUv0gOzrLgN9xa6VDNtWoN_B0OqhiXMfB44RXEtuYwA>
    <xmx:q9y_aqTcK8AH4RB0P571VOe6uEK_NpPT3Pfo-IRRqdLCuBhPRjquPzg->
Feedback-ID: i8e6e4897:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Oct 2026 12:32:42 -0400 (EDT)
From: Giuseppe Scrivano <giuseppe@scrivano.org>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	linux-fsdevel@vger.kernel.org,
	amir73il@gmail.com,
	giuseppe@scrivano.org,
	brauner@kernel.org,
	viro@zeniv.linux.org.uk,
	jack@suse.cz,
	hch@infradead.org
Subject: [PATCH v7 1/2] fs: rename vfs_get_super() to get_tree_super() and export it
Date: Fri,  2 Oct 2026 18:31:43 +0200
Message-ID: <20261002163225.1258203-2-giuseppe@scrivano.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261002163225.1258203-1-giuseppe@scrivano.org>
References: <20261002163225.1258203-1-giuseppe@scrivano.org>
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

Rename and export it so filesystems that need a custom superblock
matching policy can reuse it directly instead of open-coding sget_fc()
+ fill_super().  No functional change.

This is a preparatory fix for the next patch.

Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
---
 fs/super.c                 | 19 +++++++++++++++----
 include/linux/fs_context.h |  4 ++++
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 1d5ccf540a9b..a1dc4de1b657 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1374,7 +1374,17 @@ static int test_single_super(struct super_block *s, struct fs_context *fc)
 	return 1;
 }
 
-static int vfs_get_super(struct fs_context *fc,
+/**
+ * get_tree_super - Get a superblock, optionally sharing an existing one
+ * @fc: The filesystem context holding the parameters
+ * @test: Comparison function to find a matching existing superblock, or NULL
+ * @fill_super: Helper to initialise a new superblock
+ *
+ * If @test is non-NULL and matches an existing superblock, that superblock is
+ * reused; otherwise a new anonymous superblock is created and initialised with
+ * @fill_super.  Passing NULL for @test always creates a new superblock.
+ */
+int get_tree_super(struct fs_context *fc,
 		int (*test)(struct super_block *, struct fs_context *),
 		int (*fill_super)(struct super_block *sb,
 				  struct fs_context *fc))
@@ -1401,12 +1411,13 @@ static int vfs_get_super(struct fs_context *fc,
 	deactivate_locked_super(sb);
 	return err;
 }
+EXPORT_SYMBOL_GPL(get_tree_super);
 
 int get_tree_nodev(struct fs_context *fc,
 		  int (*fill_super)(struct super_block *sb,
 				    struct fs_context *fc))
 {
-	return vfs_get_super(fc, NULL, fill_super);
+	return get_tree_super(fc, NULL, fill_super);
 }
 EXPORT_SYMBOL(get_tree_nodev);
 
@@ -1414,7 +1425,7 @@ int get_tree_single(struct fs_context *fc,
 		  int (*fill_super)(struct super_block *sb,
 				    struct fs_context *fc))
 {
-	return vfs_get_super(fc, test_single_super, fill_super);
+	return get_tree_super(fc, test_single_super, fill_super);
 }
 EXPORT_SYMBOL(get_tree_single);
 
@@ -1424,7 +1435,7 @@ int get_tree_keyed(struct fs_context *fc,
 		void *key)
 {
 	fc->s_fs_info = key;
-	return vfs_get_super(fc, test_keyed_super, fill_super);
+	return get_tree_super(fc, test_keyed_super, fill_super);
 }
 EXPORT_SYMBOL(get_tree_keyed);
 
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index 0d6c8a6d7be2..d1727dffecc5 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -150,6 +150,10 @@ extern int vfs_parse_fs_param_source(struct fs_context *fc,
 				     struct fs_parameter *param);
 extern void fc_drop_locked(struct fs_context *fc);
 
+int get_tree_super(struct fs_context *fc,
+		   int (*test)(struct super_block *, struct fs_context *),
+		   int (*fill_super)(struct super_block *sb,
+				     struct fs_context *fc));
 extern int get_tree_nodev(struct fs_context *fc,
 			 int (*fill_super)(struct super_block *sb,
 					   struct fs_context *fc));
-- 
2.55.0


