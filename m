Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 522FEC4332F
	for <linux-erofs@archiver.kernel.org>; Mon, 27 Dec 2021 12:55:48 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4JMyMQ6SLSz307C
	for <linux-erofs@archiver.kernel.org>; Mon, 27 Dec 2021 23:55:46 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.45;
 helo=out30-45.freemail.mail.aliyun.com;
 envelope-from=jefflexu@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-45.freemail.mail.aliyun.com
 (out30-45.freemail.mail.aliyun.com [115.124.30.45])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4JMyMF0lnnz3bbx
 for <linux-erofs@lists.ozlabs.org>; Mon, 27 Dec 2021 23:55:35 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426; MF=jefflexu@linux.alibaba.com;
 NM=1; PH=DS; RN=12; SR=0; TI=SMTPD_---0V.xJoSm_1640609709; 
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
 fp:SMTPD_---0V.xJoSm_1640609709) by smtp.aliyun-inc.com(127.0.0.1);
 Mon, 27 Dec 2021 20:55:10 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: dhowells@redhat.com, linux-cachefs@redhat.com, xiang@kernel.org,
 chao@kernel.org, linux-erofs@lists.ozlabs.org
Subject: [PATCH v1 21/23] cachefiles: implement .read() for demand read
Date: Mon, 27 Dec 2021 20:54:42 +0800
Message-Id: <20211227125444.21187-22-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211227125444.21187-1-jefflexu@linux.alibaba.com>
References: <20211227125444.21187-1-jefflexu@linux.alibaba.com>
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
Cc: tao.peng@linux.alibaba.com, linux-kernel@vger.kernel.org,
 joseph.qi@linux.alibaba.com, bo.liu@linux.alibaba.com,
 linux-fsdevel@vger.kernel.org, eguan@linux.alibaba.com,
 gerry@linux.alibaba.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Once notified, user daemon need to get more details of the request by
reading the devnode. The readed information includes the file range of
the request, with which user daemon could somehow prepare corresponding
data (e.g. download from remote through network) and fill the hole.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 fs/cachefiles/daemon.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/cachefiles/daemon.c b/fs/cachefiles/daemon.c
index 311dcd911a85..ce4cc5617dfc 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -29,6 +29,8 @@ static ssize_t cachefiles_daemon_write(struct file *, const char __user *,
 				       size_t, loff_t *);
 static __poll_t cachefiles_daemon_poll(struct file *,
 					   struct poll_table_struct *);
+static ssize_t cachefiles_demand_read(struct file *, char __user *, size_t,
+				      loff_t *);
 static __poll_t cachefiles_demand_poll(struct file *,
 					   struct poll_table_struct *);
 static int cachefiles_daemon_frun(struct cachefiles_cache *, char *);
@@ -63,6 +65,7 @@ const struct file_operations cachefiles_demand_fops = {
 	.owner		= THIS_MODULE,
 	.open		= cachefiles_daemon_open,
 	.release	= cachefiles_daemon_release,
+	.read		= cachefiles_demand_read,
 	.write		= cachefiles_daemon_write,
 	.poll		= cachefiles_demand_poll,
 	.llseek		= noop_llseek,
@@ -322,6 +325,32 @@ static __poll_t cachefiles_daemon_poll(struct file *file,
 	return mask;
 }
 
+static ssize_t cachefiles_demand_read(struct file *file, char __user *_buffer,
+				      size_t buflen, loff_t *pos)
+{
+	struct cachefiles_cache *cache = file->private_data;
+	struct cachefiles_req *req;
+	int n, id = 0;
+
+	if (!test_bit(CACHEFILES_READY, &cache->flags))
+		return 0;
+
+	spin_lock(&cache->reqs_lock);
+	req = idr_get_next(&cache->reqs, &id);
+	spin_unlock(&cache->reqs_lock);
+	if (!req)
+		return 0;
+
+	n = sizeof(req->req_in);
+	if (n > buflen)
+		return -EMSGSIZE;
+
+	if (copy_to_user(_buffer, &req->req_in, n) != 0)
+		return -EFAULT;
+
+	return n;
+}
+
 static __poll_t cachefiles_demand_poll(struct file *file,
 					   struct poll_table_struct *poll)
 {
-- 
2.27.0

