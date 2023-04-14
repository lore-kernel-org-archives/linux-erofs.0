Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A739C77B73
	for <linux-erofs@archiver.kernel.org>; Fri, 14 Apr 2023 17:24:00 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4PyjwZ5f2yz3fX7
	for <linux-erofs@archiver.kernel.org>; Sat, 15 Apr 2023 03:23:58 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1681493038;
	bh=qgUvM997QJXfBj7OoFl5jxJ2P02ysazlJ3MfSoqKoTg=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=fIZ5i1vLij0hApyt7mggcIP/bWjzMFVRZEQ3CyKpgoT9qCamptLo+iwvLhhog2e5g
	 tFC0+uQHyH/gX6wKA8AaE6zucfFNb3ravz7VNVqgOh8xuMFICgo6aiRiUrONpGJ1O7
	 89S604rqelJv1quz022vgk8eR0y+E4JTGdkF6wso/fcVPWD73qvUxanGUt9JnnTmhC
	 27p1uhd2O5Y5bKjNdsMJ/i41TkHAsnnc3Ql8sBX1cGpTTv3v1iQFVl9pnn8r0cz8OT
	 KnDFQwi6bY8t3C9d9SA1xnFj5b+BDHsmkhj4hW2Ea9jOi+QzC3JEYxgn8BI7KfAuYX
	 jBdO95YJR6tAQ==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=bytedance.com (client-ip=2607:f8b0:4864:20::102f; helo=mail-pj1-x102f.google.com; envelope-from=zhujia.zj@bytedance.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=T3zZn09j;
	dkim-atps=neutral
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4PyjwC1lVTz3fXN
	for <linux-erofs@lists.ozlabs.org>; Sat, 15 Apr 2023 03:23:39 +1000 (AEST)
Received: by mail-pj1-x102f.google.com with SMTP id x8-20020a17090a6b4800b002474c5d3367so1206116pjl.2
        for <linux-erofs@lists.ozlabs.org>; Fri, 14 Apr 2023 10:23:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681493017; x=1684085017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qgUvM997QJXfBj7OoFl5jxJ2P02ysazlJ3MfSoqKoTg=;
        b=e09+IgL8Mtij+8GBz8K9yl6ZAbkarQtjBDbgE5tL7+bro38LARhHOnnRqCWp13XjBX
         lEdPzOFyuh6wBylDs1I20DCCv3xWuL+MVQnByAX6XkOvkHiAC6EtEkeK5D6hm++0cppd
         hcqKtSgYvQiC9EY+Im/vIozQTrGI+eUB9JY2duJkvUqL+sPrgMl3nlyfpMhnCMoXYSdR
         hM2HcIFE6E4MVXiHzA0xMlb9sD/uUqzmQb32SjcyATneNxMG2OC6TlbEqx2NtJS5KcxH
         4J/49XsCjyKlgxtnT037hjOcfuWvpeaJcVSmnm06FJhtrg05uW4FyXrXVpw4N9oEGYU4
         k66g==
X-Gm-Message-State: AAQBX9cY/f31bKmOFa6gELvAiBfT/VpUuyv0NAQGv45L73ZiQc0seiEd
	gGCuVXHkyZHzA1NZSBMJHhWDrg==
X-Google-Smtp-Source: AKy350aBgZHg/laFWLHOBjKb0DZ6Hi2flL729hh8PovcVeBU4tyJFAUENy+tE8fTCKXuvB2+OR9kVQ==
X-Received: by 2002:a05:6a20:8f2a:b0:ee:b24e:a40b with SMTP id b42-20020a056a208f2a00b000eeb24ea40bmr335653pzk.53.1681493017046;
        Fri, 14 Apr 2023 10:23:37 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id q12-20020a631f4c000000b0051b8172fa68sm370315pgm.38.2023.04.14.10.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 10:23:36 -0700 (PDT)
To: dhowells@redhat.com,
	linux-cachefs@redhat.com
Subject: [PATCH V6 5/5] cachefiles: add restore command to recover inflight ondemand read requests
Date: Sat, 15 Apr 2023 01:22:39 +0800
Message-Id: <20230414172239.33743-6-zhujia.zj@bytedance.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230414172239.33743-1-zhujia.zj@bytedance.com>
References: <20230414172239.33743-1-zhujia.zj@bytedance.com>
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
From: Jia Zhu via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Jia Zhu <zhujia.zj@bytedance.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, hsiangkao@linux.alibaba.com, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Previously, in ondemand read scenario, if the anonymous fd was closed by
user daemon, inflight and subsequent read requests would return EIO.
As long as the device connection is not released, user daemon can hold
and restore inflight requests by setting the request flag to
CACHEFILES_REQ_NEW.

Suggested-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Jia Zhu <zhujia.zj@bytedance.com>
Signed-off-by: Xin Yin <yinxin.x@bytedance.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
---
 fs/cachefiles/daemon.c   |  1 +
 fs/cachefiles/internal.h |  3 +++
 fs/cachefiles/ondemand.c | 23 +++++++++++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/fs/cachefiles/daemon.c b/fs/cachefiles/daemon.c
index 70caa1946207d..3f24905f40661 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -77,6 +77,7 @@ static const struct cachefiles_daemon_cmd cachefiles_daemon_cmds[] = {
 	{ "tag",	cachefiles_daemon_tag		},
 #ifdef CONFIG_CACHEFILES_ONDEMAND
 	{ "copen",	cachefiles_ondemand_copen	},
+	{ "restore",	cachefiles_ondemand_restore	},
 #endif
 	{ "",		NULL				}
 };
diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index 26e5f8f123ef1..4a87c9d714a94 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -303,6 +303,9 @@ extern ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *cache,
 extern int cachefiles_ondemand_copen(struct cachefiles_cache *cache,
 				     char *args);
 
+extern int cachefiles_ondemand_restore(struct cachefiles_cache *cache,
+					char *args);
+
 extern int cachefiles_ondemand_init_object(struct cachefiles_object *object);
 extern void cachefiles_ondemand_clean_object(struct cachefiles_object *object);
 
diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index 8e130de952f7d..b8fbbb1961bbc 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -182,6 +182,29 @@ int cachefiles_ondemand_copen(struct cachefiles_cache *cache, char *args)
 	return ret;
 }
 
+int cachefiles_ondemand_restore(struct cachefiles_cache *cache, char *args)
+{
+	struct cachefiles_req *req;
+
+	XA_STATE(xas, &cache->reqs, 0);
+
+	if (!test_bit(CACHEFILES_ONDEMAND_MODE, &cache->flags))
+		return -EOPNOTSUPP;
+
+	/*
+	 * Reset the requests to CACHEFILES_REQ_NEW state, so that the
+	 * requests have been processed halfway before the crash of the
+	 * user daemon could be reprocessed after the recovery.
+	 */
+	xas_lock(&xas);
+	xas_for_each(&xas, req, ULONG_MAX)
+		xas_set_mark(&xas, CACHEFILES_REQ_NEW);
+	xas_unlock(&xas);
+
+	wake_up_all(&cache->daemon_pollwq);
+	return 0;
+}
+
 static int cachefiles_ondemand_get_fd(struct cachefiles_req *req)
 {
 	struct cachefiles_object *object;
-- 
2.20.1

