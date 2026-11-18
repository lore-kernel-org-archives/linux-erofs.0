Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABDD606A31C
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Nov 2026 01:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=f5ubodRW
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTkrG5qD5z2xqv;
	Wed, 18 Nov 2026 12:42:54 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::32e"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794966174;
	cv=none; b=StZyGYUxI3i1AYo/cr1gFFQ1YOFF5ua+YSLWg8VKxPEyjt/wSLD5eIOJG5IT1QZ+1bifO9qCvDxmEc8CIpWgGmhuA48a3+sPGoJoTf0/9+RXv1h965icc8dWn09vICSDelRIIJiN4IOWkx2Hp1ZxQwGSXyUMFiVVJHQLIcD8Stc6/839QsJNqFLqFP3YN8IxjnwxxBrhqn9/tmaTbGeSLL81027h6Qst91Xvks0ceiUCb7QjqtPtcTIx9HuVdUm3UmH8IaSi0Sj01wHfxz3fxKBLTYabvwK646gga2zK9POwKFbAKML5wddF15jEbNfIyZGQ6KNsCHv+WTi9iNv/dA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794966174; c=relaxed/relaxed;
	bh=bVP/b/2vV2X3nJI3JJf3EMadfGj7qNyylMOudwqYc9c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OgR7GznKwHIb9ifvzrky+TcivF0iTp22MEjvgF6PBC7trjyjF0CZEyfgdD+oIhO7ZdDz6p8oZbP4OucUcdFEf7TtlY4LNTBi6L7iWRnRKAUKIED24ebJw/M/3/9qKVYq+VkNyqwi7z03tE0WMpmNuFFHKtLSdN+eQx6jHaKaK53KNNJpBCBDW2tIfoEmMxy77+MxpJgIxZAt5zYdO/6pmDu3fo6hA+W8J6BxiAdXnLJzcMbJeLzIdXdcvHsC9W+s1rvzA+hhnHs4OJHHILesAO2Uq3XZacR4oc2np15tSbbtKwCPq/TnnKgpo7oyGFv2KPuJUTxmZyXYHNqcfI4cbA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=f5ubodRW; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32e; helo=mail-wm1-x32e.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=f5ubodRW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::32e; helo=mail-wm1-x32e.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTkrD2gQQz2xNC
	for <linux-erofs@lists.ozlabs.org>; Wed, 18 Nov 2026 12:42:51 +1100 (AEDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-4bb6adaf0f1so4305735e9.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 17:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1794966168; x=1795570968; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bVP/b/2vV2X3nJI3JJf3EMadfGj7qNyylMOudwqYc9c=;
        b=f5ubodRWxpM3QACJ8VlI+oW/QDfzPJA+BPmCYoh8F5HNoU+qpooNYjGwtCzydmWg9q
         jkpKhIVbbhpfLzngrLYaD3QXWiaCsD1NMra9pih4mNj/dMq9IZs49P11RVTYuojR066+
         Q1MyT8L/tJMUVuGyN6BMbLqzHtUHJoygumq9sK/nT5HKag5aV6SXiRVti8+uxHH8UHdj
         CGQ4ZE8SXDmewMTOGiSy43GxhTIyGvMXtNuhjAfTbn5LA3k7mXLp3DoH0Y1OQ+cjh8HS
         ouPoIrxQoeVknbdFtchRefeiMhDk+KIjAAMgzMfMvKkaF43sOu8MVCHcf+fB2QWpUy1r
         4aFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794966168; x=1795570968;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bVP/b/2vV2X3nJI3JJf3EMadfGj7qNyylMOudwqYc9c=;
        b=PGV63Ir6NyY713Ro8kXEZ7DWm9L/ecKy1eq8vTh525pcHqvpasKklKL9iEhWIFrQGy
         lRRFQUXa+CJ1ZDHYZ3jxjByICrRIG+Hj9/6KNZzrT6UfpV4w6Pnu05DohmaNGshLH19m
         u2+BwuOynAhvKxYWofGcCbXTRPcuMnQVTszvIpciRjhtM3ZK4VBeNtFlz6TZvV0OEHP+
         fdzmuT/KUXn52pC+BVmHTT04xvh0WZWpXkYu0v2ojkCfm2ZoV+tWYupU4kQmehKM6z4d
         Sq63o6LeCCk/2xrnG1Gd9nSD5Lk8p6qyAuKCOWw1tv3Nua0e4XCm3wNIYXkM074O+bug
         dgKQ==
X-Gm-Message-State: APuU4Z86+st3dg7BpwK/rL5kmtJphuJTVFu8P1+t0Fm2Fervl/d2+z0B
	pFnPb46YGydPCoJoDGncYLWRqAX5oxEt3PBn6pTOobBDctDJl/6ogB533hErM7A+R3cNJPIzIWk
	E0ceXbSo=
X-Gm-Gg: AYBFou23iIZWSb+dE1KLs80S6IOVTLUprpQShP5FiBTtSkJBccZK9zw86+XZ79Vkw7d
	xvSrvt6GPamm9idY9J3SkQXnTknftcMcVbyORq/Kt6LQ3a+Tu3ZnWSqopOArMS9+/b2ckJ5JWOi
	QWDIxAQ0bRlcKiFYBE4o28nRWBdvHrqaBNrCIuZ9J3Gxx2nDlKpJYcQAFnQJ7wRxH+Ee+F8nlL/
	vIPlExVWhh81Pt2+zg/+FRl6O8KKH98GQ9bNqWtFkufrtJPxjj2Ps/J4I2bWg4a/PNvG/GAFfMg
	zjRVPVmYQzgXLzko0+TauACMbARrcPbGUVCqo3AcYoh/3OpE+KbRhecl1qFVS7++XDiGvKZK30u
	sfabURqlk9ru4q57CX8g16K7gTlfx9+dYur80djUWAxd7kBVQFQn2C/mMsDSYddgD+4cFvynev4
	ttFx6MuS7E5edEDYL7FMw7lnkvohf8VJ0sF6bCr/VmHui5XnpMrGKT4MN/5NTtM1O6avPbJDexU
	z0WJjNoVmG+3NvfAb5+pjxwLGOjxX3Ioe2Tr69/z1gU3JTLAM1URrs8KK/MZ/PNPEwgZOiiQtL6
	UhMw0+bEhrHnhVIsP5uJlkxt1elIluujacALq3yNV0Mq4kZcwepv1xbYBcjc+MQ2pTpCb4BTFO9
	RWizmqj+FhRmf+MdIDg==
X-Received: by 2002:a05:600c:3b20:b0:4ab:c447:49df with SMTP id 5b1f17b1804b1-4bb7da1baf6mr18728595e9.23.1794966168466;
        Tue, 17 Nov 2026 17:42:48 -0800 (PST)
Received: from F7R9GP321C.tail0bfbd.ts.net ([2a02:8108:8388:6600:3844:e3ef:fe85:661a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7d2abfc4sm26929965e9.7.2026.11.17.17.42.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 17:42:47 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v2 1/4] erofs-utils: lib: fix dentries returned for terminal path components
Date: Wed, 18 Nov 2026 02:42:42 +0100
Message-ID: <20261118014245.67917-1-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
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
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Paths ending in .. or a followed symlink can return a stale dentry,
causing directory metadata updates to affect the wrong inode or fail
with ENOTDIR.

Return the resolved directory's dentry, reusing the cached parent for
.. when possible.

Fixes: 95d315fd7958 ("erofs-utils: introduce tarerofs")
Fixes: fd041ac99272 ("erofs-utils: lib: follow symlinks on intermediate tar path components")
Assisted-by: ChatGPT:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
v1: https://lore.kernel.org/r/20261104040725.2473313-1-sereno.xu@deepseek.com
v2:
 - only support two-field format for now.

 lib/rebuild.c | 45 +++++++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/lib/rebuild.c b/lib/rebuild.c
index 2fa8feb..a5dd4f3 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -86,11 +86,23 @@ struct erofs_dentry *erofs_d_lookup(struct erofs_inode *dir, const char *name)
 /* Bound symlink chains during path resolution, like the kernel's MAXSYMLINKS. */
 #define EROFS_REBUILD_SYMLINK_DEPTH	40
 
+static struct erofs_dentry *erofs_d_find_any_alias(struct erofs_inode *inode)
+{
+	struct erofs_dentry *d;
+
+	if (IS_ROOT(inode))
+		return NULL;
+	list_for_each_entry(d, &erofs_parent_inode(inode)->i_subdirs, d_child)
+		if (d->inode == inode)
+			return d;
+	return ERR_PTR(-ENOENT);
+}
+
 static struct erofs_dentry *__erofs_rebuild_get_dentry(struct erofs_inode *root,
 		struct erofs_inode *pwd, char *path, bool aufs,
 		bool *whout, bool *opq, bool to_head, unsigned int depth);
 
-static struct erofs_inode *erofs_rebuild_follow_link(struct erofs_inode *root,
+static struct erofs_dentry *erofs_rebuild_follow_link(struct erofs_inode *root,
 		struct erofs_inode *pwd, struct erofs_inode *link,
 		unsigned int depth)
 {
@@ -113,13 +125,8 @@ static struct erofs_inode *erofs_rebuild_follow_link(struct erofs_inode *root,
 		base = target[0] == '/' ? root : pwd;
 		d = __erofs_rebuild_get_dentry(root, base, target, false,
 					       &dumb_wh, &dumb_opq, false, depth);
-		if (IS_ERR(d))
-			return ERR_CAST(d);
-		/* target referred to the root or base directory itself ("/", ".") */
-		if (!d)
-			return base;
-		if (d->type == EROFS_FT_DIR)
-			return d->inode;
+		if (IS_ERR(d) || !d || d->type == EROFS_FT_DIR)
+			return d;
 		if (d->type != EROFS_FT_SYMLINK)
 			return ERR_PTR(-ENOTDIR);
 		/* the target is itself a symlink: keep following the chain */
@@ -132,9 +139,13 @@ static struct erofs_dentry *__erofs_rebuild_get_dentry(struct erofs_inode *root,
 		struct erofs_inode *pwd, char *path, bool aufs,
 		bool *whout, bool *opq, bool to_head, unsigned int depth)
 {
-	struct erofs_dentry *d = NULL;
+	struct erofs_dentry *d, *parent = NULL;
 	char *s = path;
+	bool parent_cached = false;
 
+	d = (pwd == root ? NULL : erofs_d_find_any_alias(pwd));
+	if (IS_ERR(d))
+		return d;
 	*whout = false;
 	*opq = false;
 
@@ -154,6 +165,11 @@ static struct erofs_dentry *__erofs_rebuild_get_dentry(struct erofs_inode *root,
 		if (__erofs_unlikely(is_dot_dotdot(s))) {
 			if (s[1] == '.') {
 				pwd = pwd->i_parent;
+				d = parent_cached ? parent :
+					(pwd == root ? NULL : erofs_d_find_any_alias(pwd));
+				if (IS_ERR(d))
+					return d;
+				parent_cached = false;
 			}
 		} else {
 			if (aufs && !slash) {
@@ -167,13 +183,17 @@ static struct erofs_dentry *__erofs_rebuild_get_dentry(struct erofs_inode *root,
 				}
 			}
 
+			parent = d;
 			d = erofs_d_lookup(pwd, s);
 			/* follow a symlinked intermediate component like a real fs */
 			if (d && slash && d->type == EROFS_FT_SYMLINK) {
-				pwd = erofs_rebuild_follow_link(root, pwd,
+				d = erofs_rebuild_follow_link(root, pwd,
 							d->inode, depth);
-				if (IS_ERR(pwd))
-					return ERR_CAST(pwd);
+				if (IS_ERR(d))
+					return d;
+				pwd = d ? d->inode : root;
+				/* The target may have a different parent. */
+				parent_cached = false;
 				*slash = '/';
 				s = slash + 1;
 				continue;
@@ -198,6 +218,7 @@ static struct erofs_dentry *__erofs_rebuild_get_dentry(struct erofs_inode *root,
 				d->type = EROFS_FT_UNKNOWN;
 				d->inode = pwd;
 			}
+			parent_cached = true;
 			pwd = d->inode;
 		}
 
-- 
2.54.0 (Apple Git-157)


