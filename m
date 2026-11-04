Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC1E606A332
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Nov 2026 04:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=hdZcY+Pw
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jKBqj2C5zz2xdb;
	Wed, 04 Nov 2026 15:12:49 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=8.221.36.197
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793765569;
	cv=none; b=H06G+NTF7encCJFH0yUDE4Wt83oI9a9SqjVAcyGRbBqh5aNkmx9OVg6VRc7SlMtTgZYJOisgdKMflMUp6rKcgH0uSkkOHHebX4DK8dVMnPq3rlctW+DlR1It4BxA8ZaHm5AceYGtnHAIV4LYIZq+z6kp4Nm30WIikpzy2ntvcjDL4rlhuad1EhwtfpNBwzNQ14S/4YVD9+oazPBULBdqX8/SZnZIA1nfJyGhMDFytJo8coo+Jwpbtqbwy9P5qi8QuACANcP4of9Zg9U44mRKW8nu6FBIy191BJ2YrkIqUWHQJqG9+ysOSC6Pt4JJIwJtAzRTIyF/QkZ2j75ZJAs1eg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793765569; c=relaxed/relaxed;
	bh=/3z9vXrcvQ/nGlv+aGJCsjBfywKvHK3sNx3jssd3QgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4mIxMsWQX8Sj9s3mjVm6UKCIhPIXs6JBGTaqbV/sWtsTt5ca8Cyi151uREdvtv6aMBa+CVXRzgJUf2EqAykJDNyMGnw9RZf2QiImNCdpGVj3VnZKhNQotwkKYOlZyL5OZaI55tEb9izmvpufsEY1pZsFRJPyzzLQMNnB/SEY/rHZW6hnL1wbZOTItbHJeJlyzntlrQZYp4dZJ7k5+FrSNtI2kypeVJSC6RMDWvoSOereMIxYEwHGZYg4fERGgvkNmvVHKTN8TRw/ZIGcYAgp1A1K8ya/F7MtX9fJEulH4NsLtvX4SZic7DTw0SqloCUcAUuYX4J5kKNgAZM6XagCA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=hdZcY+Pw; dkim-atps=neutral; spf=pass (client-ip=8.221.36.197; helo=mail-m822136197.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org) smtp.mailfrom=deepseek.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=hdZcY+Pw;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=deepseek.com (client-ip=8.221.36.197; helo=mail-m822136197.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 306 seconds by postgrey-1.37 at boromir; Wed, 04 Nov 2026 15:12:46 AEDT
Received: from mail-m822136197.xmail.ntesmail.com (mail-m822136197.xmail.ntesmail.com [8.221.36.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jKBqf0RVnz2x9c
	for <linux-erofs@lists.ozlabs.org>; Wed, 04 Nov 2026 15:12:45 +1100 (AEDT)
Received: from localhost.localdomain (unknown [124.243.154.173])
	by smtp.qiye.163.com (Hmail) with ESMTP id 536bdc6d9;
	Wed, 4 Nov 2026 12:07:32 +0800 (GMT+08:00)
From: Wenyuan Xu <sereno.xu@deepseek.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: sereno.xu@deepseek.com
Subject: [RFC 2/7] erofs-utils: lib: add erofs_inode_has_xattr helper
Date: Wed,  4 Nov 2026 04:07:20 +0000
Message-ID: <20261104040725.2473313-3-sereno.xu@deepseek.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104040725.2473313-1-sereno.xu@deepseek.com>
References: <20261104040725.2473313-1-sereno.xu@deepseek.com>
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
X-HM-Tid: 0aa1a4bd9c0a03a3kunma3fc75f17e057
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDTUlKVhhPGk9NSh1JHkpDGFYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU9VSU9IVUpOT1VKTEhZV1kWGg8SFR0UWUFZS1VLVU
	tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=hdZcY+PwyRnMSjlkc46UafMfaedHm/2cUEBDZc44ysntF/G9AuYPvN1DFQ2EbcBKguxIF5bI3Wiqtdw7R7DwMrS1+q4x+ahgo50xDs6aRn7LQnZsAyd2vBO8reeswH9cJPwd4eqHz5HGcuGsuX4Yb9PQon7R96XL95ygBqh3Axw=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
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


