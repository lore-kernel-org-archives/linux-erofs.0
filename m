Return-Path: <linux-erofs+bounces-3805-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 724C1C43458
	for <linux-erofs@archiver.kernel.org>; Thu,  2 Jul 2026 16:48:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4grjWk5XH3z2xPb;
	Fri, 03 Jul 2026 02:48:50 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1783010930;
	cv=none; b=HJV4J3Ior4UM60V9JMoYHeB86Qcc/1mzxDeCRVVHbAmkc+0Mllauw2qmsnjdgIddYgzJAFawBdZlwse5KWRSv+AK4/XE4uTrBd4OkqkANdLNjuCk6vS+v5wJd7fKV3d/0O/p7wfqCqeJBE5iSh+Nk1ydKobax65yXepCsu7KtYb2buWMLNvdYlcFuC57Jshqp+p97f8+nM7nDFAEJJnZWP+Pj60SHjqj0ZUaFw9pp60Y/ZfKRifshnzved1WFHv1ZKwd9VBy6Jhn2aj47lRYIp8htulpr5nrIyQfHBFd2kR0YLPAR2KuzoJKoEWPndfv0m8NOUz8g+4ZOIWsgrNy6g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1783010930; c=relaxed/relaxed;
	bh=lxaEB9ivtd1cudx/QItx/MaDYy56jhVPw1crZ3vhZXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DF53hTRS9R0gP+Rr03J3ZY/Leoi3xMchv6YKJPP4blnlvE6RwY4OpEOl0/wCMj3nKRsY7O5g2z0LBgD8U923jCoCvf7C/5sMWzTm8FTJ6GJ3t/BkYRgPOIonrr7iFBEHRyaJEwHvzFZUEe/EjpS4zD3rDBU5vd2OyV6B7ipu0MFiboFvvrcayY5/+oPwF8cHkFyEUcdLPxwxAnN/7etk5Y/obzelscYTu6X/HE8rKNJKD9eLYdlBoOtLs+vP0xGkhcPn1IUBYGni+ul1H2wyvs5IOHtzcWjWIDTJ5P4atgXCfTLZudLy3XY4KLYf+NoM25QujQPe2/1PODFU488mvw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; dkim=pass (1024-bit key; unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bxp8+s4a; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=gregkh@linuxfoundation.org; receiver=lists.ozlabs.org) smtp.mailfrom=linuxfoundation.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bxp8+s4a;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linuxfoundation.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=gregkh@linuxfoundation.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4grjWj3P4Lz2xLq
	for <linux-erofs@lists.ozlabs.org>; Fri, 03 Jul 2026 02:48:48 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CB5742E34;
	Thu,  2 Jul 2026 16:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68F71F000E9;
	Thu,  2 Jul 2026 16:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010926;
	bh=lxaEB9ivtd1cudx/QItx/MaDYy56jhVPw1crZ3vhZXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bxp8+s4a/1t16bjQIi64OJGP/2GUxkMe8nXbm/UnfMo+6cBEf/1v+FjqvNL2kTl5L
	 02HDKGQWLoWdWETIW2AQwkkt9M+GEU9L9E/Jxa9q3aIreOZhaElBrAaAdJFLN1O/OF
	 T7754V6c44Pw6+MqQf/jCh3RCQv/MCe8jGD+vlZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	Amir Goldstein <amir73il@gmail.com>,
	Serge Hallyn <serge@hallyn.com>,
	Paul Moore <paul@paul-moore.com>,
	Cai Xinchen <caixinchen1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/175] fs: prepare for adding LSM blob to backing_file
Date: Thu,  2 Jul 2026 18:19:49 +0200
Message-ID: <20260702155117.633809919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 880bd496ec72a6dcb00cb70c430ef752ba242ae7 ]

In preparation to adding LSM blob to backing_file struct, factor out
helpers init_backing_file() and backing_file_free().

Cc: stable@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org
Cc: linux-erofs@lists.ozlabs.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Serge Hallyn <serge@hallyn.com>
[PM: use the term "LSM blob", fix comment style to match file]
Signed-off-by: Paul Moore <paul@paul-moore.com>
[1. The commit def3ae83da02
("fs: store real path instead of fake path in backing file f_path")
is not merged, The 6.6 LTS version accordingly operates on
&ff->real_path instead of &ff->user_path.

2. Mainline's file_free() does both the backing_file cleanup and the
kmem_cache_free() synchronously.  Linux 6.6.y defers the actual kfree()
to file_free_rcu() via call_rcu(), so only path_put() is done
synchronously in file_free().]
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file_table.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 234284ef72a9a5..b4c208a771539d 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -72,11 +72,16 @@ static void file_free_rcu(struct rcu_head *head)
 		kmem_cache_free(filp_cachep, f);
 }
 
+static inline void backing_file_free(struct backing_file *ff)
+{
+	path_put(&ff->real_path);
+}
+
 static inline void file_free(struct file *f)
 {
 	security_file_free(f);
 	if (unlikely(f->f_mode & FMODE_BACKING))
-		path_put(backing_file_real_path(f));
+		backing_file_free(backing_file(f));
 	if (likely(!(f->f_mode & FMODE_NOACCOUNT)))
 		percpu_counter_dec(&nr_files);
 	call_rcu(&f->f_rcuhead, file_free_rcu);
@@ -252,6 +257,12 @@ struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred)
 	return f;
 }
 
+static int init_backing_file(struct backing_file *ff)
+{
+	memset(&ff->real_path, 0, sizeof(ff->real_path));
+	return 0;
+}
+
 /*
  * Variant of alloc_empty_file() that allocates a backing_file container
  * and doesn't check and modify nr_files.
@@ -274,7 +285,14 @@ struct file *alloc_empty_backing_file(int flags, const struct cred *cred)
 		return ERR_PTR(error);
 	}
 
+	/* The f_mode flags must be set before fput(). */
 	ff->file.f_mode |= FMODE_BACKING | FMODE_NOACCOUNT;
+	error = init_backing_file(ff);
+	if (unlikely(error)) {
+		fput(&ff->file);
+		return ERR_PTR(error);
+	}
+
 	return &ff->file;
 }
 
-- 
2.53.0




