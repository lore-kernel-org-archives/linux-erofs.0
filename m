Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D5A5C46467
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Jan 2023 08:32:24 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4NsLX66j3Rz3cd7
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Jan 2023 19:32:22 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.131; helo=out30-131.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4NsLWp4Ys6z3c65
	for <linux-erofs@lists.ozlabs.org>; Wed, 11 Jan 2023 19:32:06 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VZMek6i_1673425922;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0VZMek6i_1673425922)
          by smtp.aliyun-inc.com;
          Wed, 11 Jan 2023 16:32:03 +0800
From: Jingbo Xu <jefflexu@linux.alibaba.com>
To: xiang@kernel.org,
	chao@kernel.org,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH v2 4/7] erofs: implement .read_iter for page cache sharing
Date: Wed, 11 Jan 2023 16:31:55 +0800
Message-Id: <20230111083158.23462-5-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230111083158.23462-1-jefflexu@linux.alibaba.com>
References: <20230111083158.23462-1-jefflexu@linux.alibaba.com>
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
Cc: linux-fsdevel@vger.kernel.org, huyue2@coolpad.com, linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

When page cache sharing enabled, page caches are managed in the address
space of blobs rather than erofs inodes.  All erofs inodes sharing one
chunk will refer to and share the page cache in the blob's address
space.

Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
---
 fs/erofs/fscache.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
index f715b3efcc77..4075d9519a7d 100644
--- a/fs/erofs/fscache.c
+++ b/fs/erofs/fscache.c
@@ -384,8 +384,56 @@ static int erofs_fscache_share_file_open(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+static ssize_t erofs_fscache_share_file_read_iter(struct kiocb *iocb,
+						  struct iov_iter *to)
+{
+	struct file *filp = iocb->ki_filp;
+	struct inode *inode = file_inode(filp);
+	struct file *realfile = filp->private_data;
+	struct inode *realinode = file_inode(realfile);
+	struct erofs_fscache_share_file_info *finfo = realfile->private_data;
+	ssize_t already_read = 0;
+	int ret = 0;
+
+	/* no need taking (shared) inode lock since it's a ro filesystem */
+	if (!iov_iter_count(to))
+		return 0;
+
+	if (IS_DAX(inode) || iocb->ki_flags & IOCB_DIRECT)
+		return -EOPNOTSUPP;
+
+	do {
+		struct folio *folio;
+		size_t bytes, copied, offset, fsize;
+		pgoff_t index = (finfo->pa + iocb->ki_pos) >> PAGE_SHIFT;
+
+		folio = read_cache_folio(realinode->i_mapping, index, NULL, NULL);
+		if (IS_ERR(folio)) {
+			ret = PTR_ERR(folio);
+			break;
+		}
+
+		fsize = folio_size(folio);
+		offset = iocb->ki_pos & (fsize - 1);
+		bytes = min_t(size_t, inode->i_size - iocb->ki_pos, iov_iter_count(to));
+		bytes = min_t(size_t, bytes, fsize - offset);
+		copied = copy_folio_to_iter(folio, offset, bytes, to);
+		folio_put(folio);
+		iocb->ki_pos += copied;
+		already_read += copied;
+		if (copied < bytes) {
+			ret = -EFAULT;
+			break;
+		}
+	} while (iov_iter_count(to) && iocb->ki_pos < inode->i_size);
+
+	file_accessed(filp);
+	return already_read ? already_read : ret;
+}
+
 const struct file_operations erofs_fscache_share_file_fops = {
 	.llseek		= generic_file_llseek,
+	.read_iter	= erofs_fscache_share_file_read_iter,
 	.open		= erofs_fscache_share_file_open,
 	.release	= erofs_fscache_share_file_release,
 };
-- 
2.19.1.6.gb485710b

