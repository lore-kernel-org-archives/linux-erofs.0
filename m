Return-Path: <linux-erofs+bounces-4066-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ADF5C5516F
	for <linux-erofs@archiver.kernel.org>; Fri, 31 Jul 2026 16:07:03 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hBWD464y6z2yY1;
	Sat, 01 Aug 2026 02:07:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785514020;
	cv=none; b=UOvDyD68QRLNgGHi4HmTjpKm6LEfvazV5BTWerE0K+8CNj1XEbtYG/mp4HgyQ9GbIMzz3Grf2zZ/FGRzWbb0U8pfPNByOtIgc9d7AF8fuVhBRz/+N9Sj2uWzxDRsK4hrjBrOj2vZeKAhrB8I/x6/mayNGfyyCjygbqKp9g1cr/zyM9yHh3BGzmvBFkLNN+z7PhY6FxqNs0orw/amud7ecjPTIM3p9/dWzZlg//6N8aJ/EKrNdgNNGzwWNCTg9UsJ/9GGzm+Qer0QkjRMhPEf7sL+0wcXJEMLe3V7nqeGhde16gDe3qY3GAWGx91iw9/DIkz5e2DwljEELMj3VUjRsw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785514020; c=relaxed/relaxed;
	bh=S4YuOLsZAstwoSJL1hbwIRXCh/F2kcR2EuybAowBqQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=kzw8hKLnLggMIY+yQJEaWe1zp8l8lw9sOrPb7FNdeLBV+S8JKpASvNURwZyy6Zfp2zV9oL6YUZaxO9KTLphGIGC4trJtBvLbdPiAxve4myBpYmsADocQXntuUr7mkfuCzPk4vs8Z9/VrVT7CxRnDgF8kiKUeYO5myqBPlG15QOMJ4m1xkBibGRxgGrh+rQSh2E1kja50b6fY2HWtWbiHnHLljDDPFB4u8TGKY6SVXlsuY/+DYq1XkSmkj5kyW8UY+ptScfTkogAvuW2kbpiCM+uozdacCXydEZ3MnAt5+xQfGoeOyw+aq9h6jlXmeTlkJNfF+BhopjnAFjhe1XQxLg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=J3J3zmi6; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=J3J3zmi6; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=J3J3zmi6;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=J3J3zmi6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hBWD35HY6z2y1F
	for <linux-erofs@lists.ozlabs.org>; Sat, 01 Aug 2026 02:06:56 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785514013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=S4YuOLsZAstwoSJL1hbwIRXCh/F2kcR2EuybAowBqQQ=;
	b=J3J3zmi6RtT+AnRtBrYwg/fomZZNqWGrIao/Z97SYQYOoc9OQ/vyBgC03KQULuhMT/yMuq
	u8pjth73c+UNAB8dzdQUt0RzFn2bsXts2lxRsyISqTCtwMd39Ddl1XKO4qMcA0fCBB/Qwr
	a//l2MV1oIHLRKA4xjhgj6OpCtBDvas=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785514013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=S4YuOLsZAstwoSJL1hbwIRXCh/F2kcR2EuybAowBqQQ=;
	b=J3J3zmi6RtT+AnRtBrYwg/fomZZNqWGrIao/Z97SYQYOoc9OQ/vyBgC03KQULuhMT/yMuq
	u8pjth73c+UNAB8dzdQUt0RzFn2bsXts2lxRsyISqTCtwMd39Ddl1XKO4qMcA0fCBB/Qwr
	a//l2MV1oIHLRKA4xjhgj6OpCtBDvas=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605-4uRH_UC5POCtzOvrR2f7lg-1; Fri,
 31 Jul 2026 12:06:51 -0400
X-MC-Unique: 4uRH_UC5POCtzOvrR2f7lg-1
X-Mimecast-MFC-AGG-ID: 4uRH_UC5POCtzOvrR2f7lg_1785514010
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6CF981800364;
	Fri, 31 Jul 2026 16:06:50 +0000 (UTC)
Received: from oxygen.redhat.com (unknown [10.44.32.120])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2DEE8180044F;
	Fri, 31 Jul 2026 16:06:48 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	gscrivan@redhat.com
Subject: [PATCH] erofs: fix typo in error messages
Date: Fri, 31 Jul 2026 18:06:42 +0200
Message-ID: <20260731160642.2273938-1-gscrivan@redhat.com>
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
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fyI6rwpWoJZ4JJ4dZDAUoxYmZf8kiMfZk_pDD05iC20_1785514010
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

the option is called "inode_share".

Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
---
 fs/erofs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 23fee43de1d1..f1f728a2ed57 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -664,7 +664,7 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_op = &erofs_sops;
 
 	if (!sbi->domain_id && test_opt(&sbi->opt, INODE_SHARE)) {
-		errorfc(fc, "domain_id is needed when inode_ishare is on");
+		errorfc(fc, "domain_id is needed when inode_share is on");
 		return -EINVAL;
 	}
 	if (!sbi->domain_id && test_opt(&sbi->opt, SUPERBLOCK_SHARE)) {
@@ -672,7 +672,7 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 		return -EINVAL;
 	}
 	if (test_opt(&sbi->opt, DAX_ALWAYS) && test_opt(&sbi->opt, INODE_SHARE)) {
-		errorfc(fc, "FSDAX is not allowed when inode_ishare is on");
+		errorfc(fc, "FSDAX is not allowed when inode_share is on");
 		return -EINVAL;
 	}
 
-- 
2.55.0


