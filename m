Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 631FCC4332F
	for <linux-erofs@archiver.kernel.org>; Mon, 27 Dec 2021 12:55:55 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4JMyMY6nZFz3c7D
	for <linux-erofs@archiver.kernel.org>; Mon, 27 Dec 2021 23:55:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133;
 helo=out30-133.freemail.mail.aliyun.com;
 envelope-from=jefflexu@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-133.freemail.mail.aliyun.com
 (out30-133.freemail.mail.aliyun.com [115.124.30.133])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4JMyMR2h24z2yxW
 for <linux-erofs@lists.ozlabs.org>; Mon, 27 Dec 2021 23:55:45 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R161e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357; MF=jefflexu@linux.alibaba.com;
 NM=1; PH=DS; RN=12; SR=0; TI=SMTPD_---0V.wXYWr_1640609710; 
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
 fp:SMTPD_---0V.wXYWr_1640609710) by smtp.aliyun-inc.com(127.0.0.1);
 Mon, 27 Dec 2021 20:55:11 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: dhowells@redhat.com, linux-cachefs@redhat.com, xiang@kernel.org,
 chao@kernel.org, linux-erofs@lists.ozlabs.org
Subject: [PATCH v1 22/23] cachefiles: add done command for demand read
Date: Mon, 27 Dec 2021 20:54:43 +0800
Message-Id: <20211227125444.21187-23-jefflexu@linux.alibaba.com>
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

Once has prepared data and filled the hole, user daemon could notify
cachefiles backend by writing 'done' command to devnode.

With done command, the id originally readed from devnode is transferred
back to cachefiles backend. This id identifies the position of the
completed request inside the idr tree, and thus cachefiles backend could
find the corresponding completed request once gets notified.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 fs/cachefiles/daemon.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/fs/cachefiles/daemon.c b/fs/cachefiles/daemon.c
index ce4cc5617dfc..36d0bcf5fc3f 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -48,6 +48,7 @@ static int cachefiles_daemon_tag(struct cachefiles_cache *, char *);
 static int cachefiles_daemon_mode(struct cachefiles_cache *, char *);
 static int cachefiles_daemon_bind(struct cachefiles_cache *, char *);
 static void cachefiles_daemon_unbind(struct cachefiles_cache *);
+static int cachefiles_daemon_done(struct cachefiles_cache *, char *);
 
 static unsigned long cachefiles_open;
 
@@ -91,6 +92,7 @@ static const struct cachefiles_daemon_cmd cachefiles_daemon_cmds[] = {
 	{ "secctx",	cachefiles_daemon_secctx	},
 	{ "tag",	cachefiles_daemon_tag		},
 	{ "mode",	cachefiles_daemon_mode		},
+	{ "done",	cachefiles_daemon_done		},
 	{ "",		NULL				}
 };
 
@@ -604,6 +606,38 @@ static int cachefiles_daemon_tag(struct cachefiles_cache *cache, char *args)
 	return 0;
 }
 
+/*
+ * Request completion
+ * - command: "done <id>"
+ */
+static int cachefiles_daemon_done(struct cachefiles_cache *cache, char *args)
+{
+	unsigned long id;
+	int ret;
+	struct cachefiles_req *req;
+
+	_enter(",%s", args);
+
+	if (!*args) {
+		pr_err("Empty id specified\n");
+		return -EINVAL;
+	}
+
+	ret = kstrtoul(args, 0, &id);
+	if (ret)
+		return ret;
+
+	spin_lock(&cache->reqs_lock);
+	req = idr_remove(&cache->reqs, id);
+	spin_unlock(&cache->reqs_lock);
+	if (!req)
+		return -EINVAL;
+
+	complete(&req->done);
+
+	return 0;
+}
+
 /*
  * Request a node in the cache be culled from the current working directory
  * - command: "cull <name>"
-- 
2.27.0

