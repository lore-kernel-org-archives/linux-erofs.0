Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD578C433EF
	for <linux-erofs@archiver.kernel.org>; Fri, 11 Mar 2022 04:18:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4KFCNZ0mkFz30DW
	for <linux-erofs@archiver.kernel.org>; Fri, 11 Mar 2022 15:18:38 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1646972318;
	bh=4R+TLdl4qm39FOyt1q57qcqX2RVuyWtFh3Z8zDvkgsU=;
	h=Date:Subject:To:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:From;
	b=DxuTYizwve142qWHfhPshE0I8UFEYmRRok2Dnr1U6rRoQnMxeX3tCgm72ZYGFdOap
	 LXP7Jkx1ZaIiMXT0InQFMKSxU5rv5oepgcmfBS89jC3L6Hq8Y3GTntYwbyocTuKYH4
	 SqfotNfDWpHeKUCq+Hog0qfKKKzok7x6WLhqgSGRCZSWkfSCuDGZbiEaU/o/Ry7f8q
	 ysuvaceTy1v+j5M810E0R9ZAL/7FEaWJjprIyQa+1Tg1JmCPLeBzPRR6m9dI7vP4Cv
	 BT3zE7T6z0R2qZrUh1hcODLdihsMoxZnvv4l3c6DwPomBdMYWeYsqO0/PfgFnz4IkX
	 1/VV/aLAqMa9A==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=flex--dvander.bounces.google.com
 (client-ip=2607:f8b0:4864:20::104a; helo=mail-pj1-x104a.google.com;
 envelope-from=3l80qygckc_qzrwjzanckkcha.ykihejqt-ankboheopo.kvhwxo.knc@flex--dvander.bounces.google.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256
 header.s=20210112 header.b=HJCYKZB+; dkim-atps=neutral
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com
 [IPv6:2607:f8b0:4864:20::104a])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4KFCNW0WYRz2xKR
 for <linux-erofs@lists.ozlabs.org>; Fri, 11 Mar 2022 15:18:34 +1100 (AEDT)
Received: by mail-pj1-x104a.google.com with SMTP id
 c7-20020a17090a674700b001beef0afd32so4588053pjm.2
 for <linux-erofs@lists.ozlabs.org>; Thu, 10 Mar 2022 20:18:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=4R+TLdl4qm39FOyt1q57qcqX2RVuyWtFh3Z8zDvkgsU=;
 b=l+cScAu2bOLWi+m9FCIauirTFUckYBaH0RCzZSNLZptgFdjL/RH+lwSSf5eBhlt4Zu
 nMYtXuCY+yQZPaZ5IeVZonLVoaa0OStUK6LRgWMByo7v3lm/vh2yej7XYesnUULrxGT0
 6pwLz9Rr0Cjx+CLuFDkywymclouovEnA6OfoUm/shINXWwaUGR5eN+VZ+lJmyDAP/s1X
 KNyF+1lk/eOfwsAdY9HFJPKWdTY5VgaQAst1La3QUQn+roX4zk4Mh9vBhbc9Wyix9aeH
 ctLv274JiLrcRyV4UqU4pe7xy3Z8YoAv88K8ou1FJMNx0gqEL7oe8EiI5nCSQvPfMFN0
 RO0A==
X-Gm-Message-State: AOAM530BOFjx+T0sp76uHTtXuoec1hwMrKG57zu8VV4xUNsB2p2DVarw
 u/TwCJ+VWFVfdTLmBa3DeUnSLvzUsNSgbBMV7wPQXzUGLEUC/8C0sQIAZaWs0o8T7yFhFZPlM/O
 lgl6hvuNjK0TLo76pfHlRWcZ0rsOEqr36b2Ld28vEcmexCeOUeueJ6Mde3cU0f7VtUZiXppgY
X-Google-Smtp-Source: ABdhPJwB1sM/fUm2jms645oCcD7X2MQTGUn67SSs/7TtmiALTAXAsCo7MQt2CopCj0kQD0r3D91jBGVL5QAL
X-Received: from dvandertop.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5102])
 (user=dvander job=sendgmr) by 2002:a17:90a:9306:b0:1bc:9256:5477 with SMTP id
 p6-20020a17090a930600b001bc92565477mr20175163pjo.170.1646972311947; Thu, 10
 Mar 2022 20:18:31 -0800 (PST)
Date: Fri, 11 Mar 2022 04:18:29 +0000
Message-Id: <20220311041829.3109511-1-dvander@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH] erofs: rename ctime to mtime
To: linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
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
From: David Anderson via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: David Anderson <dvander@google.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

EROFS images should inherit modification time rather than creation time,
since users and host tooling have no easy way to control creation time.
To reflect the new timestamp meaning, i_ctime and i_ctime_nsec are
renamed to i_mtime and i_mtime_nsec.

Signed-off-by: David Anderson <dvander@google.com>
---
 fs/erofs/erofs_fs.h | 5 +++--
 fs/erofs/inode.c    | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/erofs/erofs_fs.h b/fs/erofs/erofs_fs.h
index 3ea62c6fb00a..1238ca104f09 100644
--- a/fs/erofs/erofs_fs.h
+++ b/fs/erofs/erofs_fs.h
@@ -12,6 +12,7 @@
 #define EROFS_SUPER_OFFSET      1024
 
 #define EROFS_FEATURE_COMPAT_SB_CHKSUM          0x00000001
+#define EROFS_FEATURE_COMPAT_MTIME              0x00000002
 
 /*
  * Any bits that aren't in EROFS_ALL_FEATURE_INCOMPAT should
@@ -186,8 +187,8 @@ struct erofs_inode_extended {
 
 	__le32 i_uid;
 	__le32 i_gid;
-	__le64 i_ctime;
-	__le32 i_ctime_nsec;
+	__le64 i_mtime;
+	__le32 i_mtime_nsec;
 	__le32 i_nlink;
 	__u8   i_reserved2[16];
 };
diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index ff62f84f47d3..e8b37ba5e9ad 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -113,8 +113,8 @@ static void *erofs_read_inode(struct erofs_buf *buf,
 		set_nlink(inode, le32_to_cpu(die->i_nlink));
 
 		/* extended inode has its own timestamp */
-		inode->i_ctime.tv_sec = le64_to_cpu(die->i_ctime);
-		inode->i_ctime.tv_nsec = le32_to_cpu(die->i_ctime_nsec);
+		inode->i_ctime.tv_sec = le64_to_cpu(die->i_mtime);
+		inode->i_ctime.tv_nsec = le32_to_cpu(die->i_mtime_nsec);
 
 		inode->i_size = le64_to_cpu(die->i_size);
 
-- 
2.35.1.723.g4982287a31-goog

