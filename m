Return-Path: <linux-erofs+bounces-4214-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE22CC5B572
	for <linux-erofs@archiver.kernel.org>; Wed, 12 Aug 2026 14:29:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKrV66P01z2ytv;
	Thu, 13 Aug 2026 00:29:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786544974;
	cv=none; b=OORruNwqmYPlCnArDnbdW+7pejin67nS0xIF1W21Sz3oQBAiVmuo2wZVI6ftFjPuGv+MmYp1K14/y+xKzGJvHQSWdJ7tOwDHl0nE3yWXNhDTkmY1SbFYl0h58QoQgm5NVd4VvUttuLjuR3eY13XwOTXOldTLTiYvO+8zTWl4jfWq0/BV5IDP33ICJacVIiV/VrN1IAdofK6f796VkW2tocZpY9A7KUr7Z9pRtaXNdkyuIWXdcc0egAwUXWaQrMf+GbLU2zpEGfswzfb5Ehavtr/O3YcVzgi9G4c/1l0yR8S7r+vE+zTxQB07QSxJat2n8fdz7SH6ewBVl+7XOyivkg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786544974; c=relaxed/relaxed;
	bh=0s4Yy5GfLU41Z9h16PdfFqaOJkDrF7KEfaHrh+NfUL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Y4dvEwNMW2jorBfifZDkEAkArPraX8Adw2vQKDd1ktKcpWJtzO+KCvHsLAv4MD5Hu+2M/w6FE97vCKd9XA33FKjJACDvaR5e2lH7itkcqGMYl5UE31MKT6zZpHkSLyxOrmbNA+0gBAm0XJNhptcIFJjbnXKpcF8H6VBG+xy+M+xw0vr58ftZX3LTUZrDuLihl5J/zOclyn3wrKVNxo6os58oBpQoYGXC2kehruBCzYrjucEXh/BwV8KPJx2SrZwwsxVmDUjPz7J8iIQXO5VwZP0ylpxfH/6X2KM92oCB7va8g+jTXbjVY+gWy31Rje3l06qtM3jdVxqk1Y0G3D7W1Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=fXSJgwYW; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZqVgY4Fq; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=fXSJgwYW;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZqVgY4Fq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKrV55YLkz30Wn
	for <linux-erofs@lists.ozlabs.org>; Thu, 13 Aug 2026 00:29:33 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786544969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0s4Yy5GfLU41Z9h16PdfFqaOJkDrF7KEfaHrh+NfUL4=;
	b=fXSJgwYWDfh/SJej+8dS5z4oqtPPYryvnHt6HhJfMDJdSy9HQlvfBUHJlA743ulGNi1cu4
	5pV0rLNe2a2EtUcRKngNJndhQ2nwT9ZPdl6dShZDW5tRhSav7E7VfO5DsRNRce2JgqfXge
	95fqM132Oml8Vy1MRcdJRzhr8GSxEKQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786544970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0s4Yy5GfLU41Z9h16PdfFqaOJkDrF7KEfaHrh+NfUL4=;
	b=ZqVgY4FqB7cBY/9WOjAmdsctPEuzJhtMbap9sjV/jjGSMtcLPFOIJ6Hd+cJE+aZqzSGA/D
	4leUV+K3DP28tQfewiOqAQDxljr0bUjN5LrE+zBXpHzfRF4K27Z7kaXNsvRAgCI5nJwIME
	mckHKackEMWXOydCi1it7xV0ky5Se7Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-373-tgxYgVZlOAKKr9PiyQBwCQ-1; Wed,
 12 Aug 2026 10:29:23 -0400
X-MC-Unique: tgxYgVZlOAKKr9PiyQBwCQ-1
X-Mimecast-MFC-AGG-ID: tgxYgVZlOAKKr9PiyQBwCQ_1786544961
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C199195608B;
	Wed, 12 Aug 2026 14:29:21 +0000 (UTC)
Received: from oxygen.station (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4D538180049F;
	Wed, 12 Aug 2026 14:29:18 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	linux-fsdevel@vger.kernel.org,
	amir73il@gmail.com,
	gscrivan@redhat.com,
	brauner@kernel.org,
	viro@zeniv.linux.org.uk,
	jack@suse.cz
Subject: [PATCH v6 1/2] fs: rename vfs_get_super() to get_tree_super() and export it
Date: Wed, 12 Aug 2026 16:28:03 +0200
Message-ID: <20260812142907.1010046-2-gscrivan@redhat.com>
In-Reply-To: <20260812142907.1010046-1-gscrivan@redhat.com>
References: <20260812142907.1010046-1-gscrivan@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: xY2NecpYHDaYWeu_7plxnLSqOeiW_EhStFURV7S9BYs_1786544961
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Rename and export it so filesystems that need a custom superblock
matching policy can reuse it directly instead of open-coding sget_fc()
+ fill_super().  No functional change.

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


