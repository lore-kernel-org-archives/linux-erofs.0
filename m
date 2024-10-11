Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C92FD2447B
	for <linux-erofs@archiver.kernel.org>; Fri, 11 Oct 2024 06:52:00 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4XPy3M16Bjz3bxL
	for <linux-erofs@archiver.kernel.org>; Fri, 11 Oct 2024 17:51:59 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1728629517;
	cv=none; b=XvzYMHzzkYujIJvHNdllFR9mQjLhm1z3QwsapJffM+OFllZaCzfq6kdpslHO0vmvWEMCS8wqXbdesTwIdVNYjIE1it0FOpP8B1DwwacBmZjFZdX+xPgUiYGOpUuMZT9zpxRMa3ug8yFv90oU2zl+/S0BiwCLCYRdLsrv39dWunRzQr4INfX2YMcx0Uz5LFFeuGIZrZ2p6YmvRwEdUKp7PC5ryISx/rNOaUA26guj+Z8RqfG1hh3dyUfFDpX36SJXAhPEcaNcPrrJ9azj54s0q3NVtwRWDZwQl9KElNUk7xN89ZjFKfvA5KNui6LEnR4vQomzKqZEcoVsSvk8khTzfw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1728629517; c=relaxed/relaxed;
	bh=9Jq7WlCziE6Y2VeyCMIXiyZ4N1+DiD4cKivRAbahRII=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nAukj+CzgfAgvJAxrdUtbqtLMaNDy1Kv9fNgoLC1dJO5eUY/lqPBVKaGMXICvcRzOSi4hwQen1tI07l0XfRducY0yqb9O+MqbvQUEvmI66jar9DztHFB+LRrAKNA75QYLx5+9laTGzPAg4NkfJA5EHFaWJDD8Me9jJkyJ9Fewndnh5cUqn47NgBikvY4LUs2ZBWXT8bYAfUEuUnSh8vRWtn5uuekAeoy7a21QZm2wHMKzY2ZZt2maKS7j2hVbKxpPp+u98bhhah+MJgO5QRnhrG62ekm5B80C1ANLklTPzWuRh5aPBO3spEeR0R8/Ie8SgkOPjDJjwcCxVfo1sPtUQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=IxnpGl0G; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=IxnpGl0G;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4XPy3F4j5Wz3bg4
	for <linux-erofs@lists.ozlabs.org>; Fri, 11 Oct 2024 17:51:48 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1728629504; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=9Jq7WlCziE6Y2VeyCMIXiyZ4N1+DiD4cKivRAbahRII=;
	b=IxnpGl0Gt+6eIeXSHnbpwcwCBrrNX/5mW6zCnbUw+G1cPq+oINkdrIMAX3GzrCSRGPV1q/bRvXgd5DYROjM3pU+y/xXBBWMgmuFbrhq7o+sU1yThlvVR8phil/VvwMrKl+wWEBbRpeauLEsfOcLkYpRRKh71mLLEpaLYbAkBCt8=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WGp69Ai_1728629490 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 11 Oct 2024 14:51:43 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs: add SEEK_{DATA,HOLE} support
Date: Fri, 11 Oct 2024 14:51:28 +0800
Message-ID: <20241011065128.2097377-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Many userspace programs (including erofs-utils itself) uses SEEK_DATA /
SEEK_HOLE to parse hole extents in addition to FIEMAP.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/data.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 61debd799cf9..6355866220ff 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -473,8 +473,32 @@ static int erofs_file_mmap(struct file *file, struct vm_area_struct *vma)
 #define erofs_file_mmap	generic_file_readonly_mmap
 #endif
 
+static loff_t erofs_file_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct inode *inode = file->f_mapping->host;
+	const struct iomap_ops *ops = &erofs_iomap_ops;
+
+	if (erofs_inode_is_data_compressed(EROFS_I(inode)->datalayout))
+#ifdef CONFIG_EROFS_FS_ZIP
+		ops = &z_erofs_iomap_report_ops;
+#else
+		return generic_file_llseek(file, offset, whence);
+#endif
+
+	if (whence == SEEK_HOLE)
+		offset = iomap_seek_hole(inode, offset, ops);
+	else if (whence == SEEK_DATA)
+		offset = iomap_seek_data(inode, offset, ops);
+	else
+		return generic_file_llseek(file, offset, whence);
+
+	if (offset < 0)
+		return offset;
+	return vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
+}
+
 const struct file_operations erofs_file_fops = {
-	.llseek		= generic_file_llseek,
+	.llseek		= erofs_file_llseek,
 	.read_iter	= erofs_file_read_iter,
 	.mmap		= erofs_file_mmap,
 	.get_unmapped_area = thp_get_unmapped_area,
-- 
2.43.5

