Return-Path: <linux-erofs+bounces-4189-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D8F6C5AC67
	for <linux-erofs@archiver.kernel.org>; Tue, 11 Aug 2026 07:24:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hK3611LQrz301Y;
	Tue, 11 Aug 2026 17:24:25 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786433065;
	cv=none; b=m1GthCcO/jT968FIO/0eHFzWDfiHL77F6usOZv6hl6KBCMR6O6X6/cbyuxUoJLynoyKzfOlaKu66b1YHOdjDz6C6Dg/KmDmRR3YHGhNnxPe+409bSIsfPCGu6OKLYci8W9Ut74emEO4L4hdur/2PA54MqpIGNf4rEmmNv9eoYoPCT75eK5wH2T6EZ9P23tDexbD21JpXfb5UUW5yhVS+WzmrQ5ngk6wvyl08GEikkohMTAHCUyizY4VKv0cite7tjaFbIo1G4SgnxYLWBhbYRFgUbdiXNva/AIL1ukl209v4lI3nF0ZgrfSyO6c7uEnoRfRHvsjs3Obznz0E10bu5A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786433065; c=relaxed/relaxed;
	bh=ioen7yg45t3UifenWmxJJ7HmiN0IGdexHBH13NMVZ6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=LeL9kRKy3+0BEzIpCF+HuU0AuyhhUYP6FSy3FpLOL/GYVhPerC2na0yJ1jPgPyz/i+rILQUxVuebbrLswGNT79maLS1ShXdi01Su64MTaXQAuaFJ52bhC/J37HcNSi7JAIzecyVVlYdP97sSVbMgoHAmuRc34fpr/KCCQZaahFpaEhtUYQTeH04bsmgLe1AQDA283/O9/LcjQaJgXZO2FZ0HrK+5sux80+tGP1Jmwc4EFC5Oten8rLXYlu5QzCswEF7VK3QLqZSj8QOoWktBNmq4HhhOFiSYFUxKImd6vgRrY39A1djvnMLunzc48S9PVI76E5C8RJGLLvdO14yh9A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bu3nVLqT; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bu3nVLqT; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bu3nVLqT;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bu3nVLqT;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hK36014dqz2yrL
	for <linux-erofs@lists.ozlabs.org>; Tue, 11 Aug 2026 17:24:23 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786433060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ioen7yg45t3UifenWmxJJ7HmiN0IGdexHBH13NMVZ6c=;
	b=bu3nVLqTjZ4ddtF00XtbNdLDxnlCG3fGi79AzMtc3UwRw0hatiCJPd+CKbGgJ3DKOYQ4lp
	tgx19hVL5fzG8HoDoZG/DY9KI6HPZfuLPEzOFRj0OkiDg/rmgF0DOcnDXEhFkvtc14r7dj
	u9Bo2/Kjru0eM74upPcF4nKLu1Db63E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786433060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ioen7yg45t3UifenWmxJJ7HmiN0IGdexHBH13NMVZ6c=;
	b=bu3nVLqTjZ4ddtF00XtbNdLDxnlCG3fGi79AzMtc3UwRw0hatiCJPd+CKbGgJ3DKOYQ4lp
	tgx19hVL5fzG8HoDoZG/DY9KI6HPZfuLPEzOFRj0OkiDg/rmgF0DOcnDXEhFkvtc14r7dj
	u9Bo2/Kjru0eM74upPcF4nKLu1Db63E=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-172-Tt9JptKWMSCd_bZzu_dGAw-1; Tue,
 11 Aug 2026 03:23:59 -0400
X-MC-Unique: Tt9JptKWMSCd_bZzu_dGAw-1
X-Mimecast-MFC-AGG-ID: Tt9JptKWMSCd_bZzu_dGAw_1786433038
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C1881800578;
	Tue, 11 Aug 2026 07:23:58 +0000 (UTC)
Received: from oxygen.station (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 676AA18005BD;
	Tue, 11 Aug 2026 07:23:56 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	linux-fsdevel@vger.kernel.org,
	amir73il@gmail.com,
	gscrivan@redhat.com,
	brauner@kernel.org
Subject: [PATCH v5 1/2] fs: rename vfs_get_super() to get_tree_super() and export it
Date: Tue, 11 Aug 2026 09:10:50 +0200
Message-ID: <20260811071241.389589-2-gscrivan@redhat.com>
In-Reply-To: <20260811071241.389589-1-gscrivan@redhat.com>
References: <20260811071241.389589-1-gscrivan@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: As4wRSfDHutWC2YYNFh45f_bC0lMtUAkNYDd5l5xn4E_1786433038
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

vfs_get_super() already implements the common get_tree pattern of
looking up an existing superblock via a test callback and initialising
a new one with fill_super otherwise, but it is private to fs/super.c
and only reachable through the get_tree_nodev()/get_tree_single()/
get_tree_keyed() wrappers, none of which let a filesystem supply its
own test callback.

Rename it to get_tree_super() and export it so filesystems that need a
custom superblock matching policy can reuse it directly instead of
open-coding sget_fc() + fill_super().  No functional change.

This is a preparatory fix for the next patch.

Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
---
 fs/super.c                 | 19 +++++++++++++++----
 include/linux/fs_context.h |  4 ++++
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index a8fd61136aaf..84b878317364 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1251,7 +1251,17 @@ static int test_single_super(struct super_block *s, struct fs_context *fc)
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
@@ -1278,12 +1288,13 @@ static int vfs_get_super(struct fs_context *fc,
 	deactivate_locked_super(sb);
 	return err;
 }
+EXPORT_SYMBOL(get_tree_super);
 
 int get_tree_nodev(struct fs_context *fc,
 		  int (*fill_super)(struct super_block *sb,
 				    struct fs_context *fc))
 {
-	return vfs_get_super(fc, NULL, fill_super);
+	return get_tree_super(fc, NULL, fill_super);
 }
 EXPORT_SYMBOL(get_tree_nodev);
 
@@ -1291,7 +1302,7 @@ int get_tree_single(struct fs_context *fc,
 		  int (*fill_super)(struct super_block *sb,
 				    struct fs_context *fc))
 {
-	return vfs_get_super(fc, test_single_super, fill_super);
+	return get_tree_super(fc, test_single_super, fill_super);
 }
 EXPORT_SYMBOL(get_tree_single);
 
@@ -1301,7 +1312,7 @@ int get_tree_keyed(struct fs_context *fc,
 		void *key)
 {
 	fc->s_fs_info = key;
-	return vfs_get_super(fc, test_keyed_super, fill_super);
+	return get_tree_super(fc, test_keyed_super, fill_super);
 }
 EXPORT_SYMBOL(get_tree_keyed);
 
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index 0d6c8a6d7be2..c920aba5177c 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -150,6 +150,10 @@ extern int vfs_parse_fs_param_source(struct fs_context *fc,
 				     struct fs_parameter *param);
 extern void fc_drop_locked(struct fs_context *fc);
 
+extern int get_tree_super(struct fs_context *fc,
+			 int (*test)(struct super_block *, struct fs_context *),
+			 int (*fill_super)(struct super_block *sb,
+					   struct fs_context *fc));
 extern int get_tree_nodev(struct fs_context *fc,
 			 int (*fill_super)(struct super_block *sb,
 					   struct fs_context *fc));
-- 
2.55.0


