Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC546606A326
	for <linux-erofs@archiver.kernel.org>; Sat,  7 Nov 2026 04:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=lNT+NmU7
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jM36v2PcXz2yb9;
	Sat, 07 Nov 2026 15:32:23 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=103.209.128.48
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794025943;
	cv=none; b=KDbLUtBUChss0HepR8rsXkxYN3pyFd4+VshNN3QhFtX8a1+vgGQMQCe1bdJeyVkzYpLaLdEbNXf4J0LZStRvKhmDaHw3jLLMQQBC9huajYO8mcXNxLA45G6QAJnNJrcpgrRyVw/JXrl/BP0kM4Om8Qiq4tm8M4g0g7YfHRnO+xa5s/fGf6DEhN7yJcOQuTtBOnvLWgipbWOZzEKUMA3XrfUOV4/OAl1oCAOzvZoXIdiM70UE5MJHR6KyOOAvOlr0/cNSHgwLZp3gGuzwkgXGaTpS7iK+Ph9zbhIH4B2SHXDjTj1ARUqDN1IimSMlf/JJMkkWLDuchEzfV0HGsctajg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794025943; c=relaxed/relaxed;
	bh=/3z9vXrcvQ/nGlv+aGJCsjBfywKvHK3sNx3jssd3QgA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=nbG0YyP4yLtTe1Wkk52B2XG3qqD1px0/SPDwaXcQ8Yp5T72MS8PRW6I86nn6aYR1gacul7ImaHYz12DTtd2XxFuzwJy3tVA69oeUQpVdAiMFmYU+NhR6Ci4XTZlbdWE0xZ00NOo4UbRiwJb+uFXpf+DUdpm+ZEkCEXIaHLJj58sGjoU/94IsxcrvjY72BbdX57YtoTtUPxMQEENNtW4Lxj4l4TRjk2LhrYx1+f+j8V/ga21dZhNC2xhDNh+VPatJS2aB345WjPL0LLvWXG/VJ0kjNQzfIlXpzmSKO51b12KtVRV1U4XIeRBZTWx1jGePEPA68SS+cZacXeRd5e5jDQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=lNT+NmU7; dkim-atps=neutral; spf=pass (client-ip=103.209.128.48; helo=mail-m12848.netease.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org) smtp.mailfrom=deepseek.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=lNT+NmU7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=deepseek.com (client-ip=103.209.128.48; helo=mail-m12848.netease.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org)
Received: from mail-m12848.netease.com (mail-m12848.netease.com [103.209.128.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jM36q4Lnnz2y7r
	for <linux-erofs@lists.ozlabs.org>; Sat, 07 Nov 2026 15:32:18 +1100 (AEDT)
Received: from localhost.localdomain (unknown [124.243.154.168])
	by smtp.qiye.163.com (Hmail) with ESMTP id 53d4b1d05;
	Sat, 7 Nov 2026 12:27:06 +0800 (GMT+08:00)
From: Wenyuan Xu <sereno.xu@deepseek.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH 1/2] erofs-utils: lib: add erofs_inode_has_xattr helper
Date: Sat,  7 Nov 2026 04:27:02 +0000
Message-ID: <20261107042703.3392000-1-sereno.xu@deepseek.com>
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
X-HM-Tid: 0aa1b4429a3d03a3kunm1b25b6102ae889
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaGh1LVkhISUwZSU1PHU8aTVYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU9VSU9IVUpOT1VKTUNZV1kWGg8SFR0UWUFZT0tIVU
	pLSUJDQ0xVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=lNT+NmU7OjtSFcY1l8hRvW7/5edq4sJeadYv6vuO8V9Bxl4qjkkSMeIxFPjgiz0bJ4zfCEj5qvCsvxmD/e9C+bfgKVA/Bo7GkxpmpYEPN1WaIy8gPTH4gmpzEMPe17yOgwT/B3fdXI7hMZFHL5hkjiMQmFk1EuRSRvC9tWSjtQY=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=/3z9vXrcvQ/nGlv+aGJCsjBfywKvHK3sNx3jssd3QgA=;
	h=date:mime-version:subject:message-id:from;
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Allow callers to check whether an inode already has an in-memory xattr
with a given name without exposing the internal xattr structures.

Assisted-by: LLM
Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
---
 include/erofs/xattr.h |  1 +
 lib/xattr.c           | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/erofs/xattr.h b/include/erofs/xattr.h
index d12c292..0016ad2 100644
--- a/include/erofs/xattr.h
+++ b/include/erofs/xattr.h
@@ -45,6 +45,7 @@ int erofs_setxattr(struct erofs_inode *inode, int index, const char *name,
 		   const void *value, size_t size);
 int erofs_vfs_setxattr(struct erofs_inode *inode, const char *name,
 		       const void *value, size_t size);
+bool erofs_inode_has_xattr(struct erofs_inode *inode, const char *name);
 int erofs_set_opaque_xattr(struct erofs_inode *inode);
 void erofs_clear_opaque_xattr(struct erofs_inode *inode);
 bool erofs_get_opaque_from_disk(struct erofs_inode *inode);
diff --git a/lib/xattr.c b/lib/xattr.c
index d86d94a..a0ac76f 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -579,6 +579,16 @@ int erofs_vfs_setxattr(struct erofs_inode *inode, const char *name,
 	return erofs_setxattr(inode, 0, name, value, size);
 }
 
+bool erofs_inode_has_xattr(struct erofs_inode *inode, const char *name)
+{
+	struct erofs_inode_xattr_node *node;
+
+	list_for_each_entry(node, &inode->i_xattrs, list)
+		if (!strcmp(node->item->kvbuf, name))
+			return true;
+	return false;
+}
+
 static void erofs_removexattr(struct erofs_inode *inode, const char *key)
 {
 	struct erofs_inode_xattr_node *node, *n;
-- 
2.43.0


