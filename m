Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DA78C2BB3F
	for <linux-erofs@archiver.kernel.org>; Mon, 20 Nov 2023 04:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1700453761;
	bh=I3yQNAV5i9i/OMA9ll/UNVMs7Fn6oZ5qFKK0D5McEKU=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=klL/RVBzhvReoB5nAOT38Df7d9FH+OKdmz4H5I4sEG/3BKvhzbbYqPTkgOSFDp1aA
	 I3voOGnCDWHQHjwoAm1V26H938Ne3ikfnJZECeG6qh7267TKyWDgFYdCiFztGgt93e
	 Y9BdNLqrgfwgGRylHj+fE0+gLV+1HC88kIbDd6Y5N6EvEQIjQQrmXBosKu5Bxy7v9K
	 nwrEQVc4SVjs2hiLLCrnLxMab+h1Ady2Bqo/wQAd07Gv+VXhpETLWVDPOhTD+NrUa5
	 lGIMuYhaQh+mEHmjdUjoH1d7CBkSwjQV90jPBXxG1aew5rCuHj/AgCABQ1BEemgLsH
	 3GN97FTH3nxmQ==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4SYZ1s0tXMz3cYj
	for <linux-erofs@archiver.kernel.org>; Mon, 20 Nov 2023 15:16:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Jj/Cv4rs;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=bytedance.com (client-ip=2607:f8b0:4864:20::42d; helo=mail-pf1-x42d.google.com; envelope-from=zhujia.zj@bytedance.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4SYZ1P4d2Mz3cFf
	for <linux-erofs@lists.ozlabs.org>; Mon, 20 Nov 2023 15:15:37 +1100 (AEDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6be0277c05bso3438176b3a.0
        for <linux-erofs@lists.ozlabs.org>; Sun, 19 Nov 2023 20:15:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700453735; x=1701058535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I3yQNAV5i9i/OMA9ll/UNVMs7Fn6oZ5qFKK0D5McEKU=;
        b=OKZ+0o9L3Ht8iC4b6cOmyh6vtV1yLmFdyIbzKhiXRKqmo/cq9UO6vx9xdwVydjxX69
         TEbP4M0pC9mmE1Op2kNyyRUifsLKjRoZUVm62JL3yX6xuPoBVTXiBWbh8xh8/YRG1O1x
         PmpsnMr98IiYeOaLI1XCZ9CWmKPsb6RRDDfYjK8acxc78YsylpzZfmidH11jg66wFnqS
         cef76x8t1pVScFf3uiYTqVKyZPoXSs8tcmI3hLPLOeVem+H7EVpLqiPWuCZZpIr3ib2k
         0ReE72BRFUg3106OfUD17iMg2UIaEiKB0ZMG/G96S2IQSy829kLMugA6+zeDEyRWnzmY
         exGA==
X-Gm-Message-State: AOJu0YziYzOD3oeHL1no1slnLWwWA1xa2ao4Rj5AWmjzJLqvoMbmcVuD
	g/WZfHe/cNVbtA+R3ipuNRmlpbxim2pVQUosMnZOuA==
X-Google-Smtp-Source: AGHT+IFkSm1NBdoY7dzAdsWmGn420PY4USgPH4erEC9WZuyziRFrX75OKDKwLGHvlN5iggDKFyl5pw==
X-Received: by 2002:a05:6a20:438d:b0:187:b4f2:b025 with SMTP id i13-20020a056a20438d00b00187b4f2b025mr5073423pzl.27.1700453734859;
        Sun, 19 Nov 2023 20:15:34 -0800 (PST)
Received: from C02G705SMD6V.bytedance.net ([61.213.176.5])
        by smtp.gmail.com with ESMTPSA id h18-20020a170902f7d200b001cc4e477861sm5065266plw.212.2023.11.19.20.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Nov 2023 20:15:34 -0800 (PST)
To: dhowells@redhat.com,
	linux-cachefs@redhat.com
Subject: [PATCH V6 RESEND 4/5] cachefiles: narrow the scope of triggering EPOLLIN events in ondemand mode
Date: Mon, 20 Nov 2023 12:14:21 +0800
Message-Id: <20231120041422.75170-5-zhujia.zj@bytedance.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20231120041422.75170-1-zhujia.zj@bytedance.com>
References: <20231120041422.75170-1-zhujia.zj@bytedance.com>
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

Don't trigger EPOLLIN when there are only reopening read requests in
xarray.

Suggested-by: Xin Yin <yinxin.x@bytedance.com>
Signed-off-by: Jia Zhu <zhujia.zj@bytedance.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
---
 fs/cachefiles/daemon.c   | 14 ++++++++++++--
 fs/cachefiles/internal.h | 12 ++++++++++++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/cachefiles/daemon.c b/fs/cachefiles/daemon.c
index aa4efcabb5e3..70caa1946207 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -355,14 +355,24 @@ static __poll_t cachefiles_daemon_poll(struct file *file,
 					   struct poll_table_struct *poll)
 {
 	struct cachefiles_cache *cache = file->private_data;
+	XA_STATE(xas, &cache->reqs, 0);
+	struct cachefiles_req *req;
 	__poll_t mask;
 
 	poll_wait(file, &cache->daemon_pollwq, poll);
 	mask = 0;
 
 	if (cachefiles_in_ondemand_mode(cache)) {
-		if (!xa_empty(&cache->reqs))
-			mask |= EPOLLIN;
+		if (!xa_empty(&cache->reqs)) {
+			rcu_read_lock();
+			xas_for_each_marked(&xas, req, ULONG_MAX, CACHEFILES_REQ_NEW) {
+				if (!cachefiles_ondemand_is_reopening_read(req)) {
+					mask |= EPOLLIN;
+					break;
+				}
+			}
+			rcu_read_unlock();
+		}
 	} else {
 		if (test_bit(CACHEFILES_STATE_CHANGED, &cache->flags))
 			mask |= EPOLLIN;
diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index b9a90f1a0c01..26e5f8f123ef 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -329,6 +329,13 @@ cachefiles_ondemand_set_object_##_state(struct cachefiles_object *object) \
 CACHEFILES_OBJECT_STATE_FUNCS(open, OPEN);
 CACHEFILES_OBJECT_STATE_FUNCS(close, CLOSE);
 CACHEFILES_OBJECT_STATE_FUNCS(reopening, REOPENING);
+
+static inline bool cachefiles_ondemand_is_reopening_read(struct cachefiles_req *req)
+{
+	return cachefiles_ondemand_object_is_reopening(req->object) &&
+			req->msg.opcode == CACHEFILES_OP_READ;
+}
+
 #else
 static inline ssize_t cachefiles_ondemand_daemon_read(struct cachefiles_cache *cache,
 					char __user *_buffer, size_t buflen)
@@ -359,6 +366,11 @@ static inline int cachefiles_ondemand_init_obj_info(struct cachefiles_object *ob
 static inline void cachefiles_ondemand_deinit_obj_info(struct cachefiles_object *obj)
 {
 }
+
+static inline bool cachefiles_ondemand_is_reopening_read(struct cachefiles_req *req)
+{
+	return false;
+}
 #endif
 
 /*
-- 
2.20.1

