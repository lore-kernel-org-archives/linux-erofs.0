Return-Path: <linux-erofs+bounces-3374-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 061C3FF885A
	for <linux-erofs@archiver.kernel.org>; Mon,  4 May 2026 14:03:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4g8Ndc4Z8wz2yZ3;
	Tue, 05 May 2026 00:03:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1777903380;
	cv=none; b=nkqGTlL6R8FJYS+ns6BiiQZFnT60yrjqjcxiJ5df+EA7cddInl1tJjng7Oki1T0yXkTIV8a3VxJKnSBZthDSB6EGVMOvEq1IfM7ugnAKZur4wcdEBceLk90cm/jbxusuwkDiRM8P6OxI6F4pYSvc9wl3HSk4selJ3aAcqAIw4YHr9fAAqnm3Or3inAosMQFCqNhKfWXLK30yvjPHd6T2wFyu7j1UKEhn52CMHX+bm1ylmPDD3lCXsAhuibCuEAylEh3FQi3x8J1vDxn7s1PMOWDE6ZRxg6A0h9t30oO+MVNfrvPzUVeZdioNrXM5IBdPOv3OLPH48tN/SqGnkLovPA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1777903380; c=relaxed/relaxed;
	bh=qed7wDOsYy+hMF+YVINbLo5HOlC2CmVNxRhFqeEWndw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQoC6rRozg46KvfdFTHREv7sSDqsOEAfKD8tabMCM4NdquUKjhfUR17GL4FqM+y3JosIHtgmPWL5L7s/CfOfkc6+BHR7ltxvUmMf3WplkFkizIWFnhWAD7+/m1guUN6dmGWmacL09oI2rwZL3sngclplZ/8mdToKdHTWWih/KzsN9IHt+BvKnWtUEhk46SSK8AHbKRIQsWHQvt7ZN5O86ZeWLMpLHyXESXyeQKqtkRjYTjdwGYqXNgqXeZrqj/PGrqlug6Jdcaa1w+/hrF38A1VxA6+vuulgEeAe5YT3aKhC9sZ5kSe7Uk1dCSX6oZaZxZQrXODHM5a0dwLCrdbS9A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; dkim=pass (1024-bit key; unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dRAetAll; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=gregkh@linuxfoundation.org; receiver=lists.ozlabs.org) smtp.mailfrom=linuxfoundation.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dRAetAll;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linuxfoundation.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=gregkh@linuxfoundation.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4g8Ndb5cvzz2xS2
	for <linux-erofs@lists.ozlabs.org>; Tue, 05 May 2026 00:02:59 +1000 (AEST)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B46FD43F68;
	Mon,  4 May 2026 14:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468C6C2BCB8;
	Mon,  4 May 2026 14:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903377;
	bh=XW27s83QbpkYHYPx44Tj1CSzLwrZk0Ooa/iuY+NtbFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRAetAllAq+htXcFyETMlDdANG8ftO+M729pXDPsc1QlOlR8ZRkd/5W+r6lCbVU23
	 6N9cvRzSlVip2qiYfc1eYtI2UyTp4SK5bX7DcqFDJ67zTwJbv4aW+MPTOgPKmdB1Oi
	 3puzpnRlCsi0tTdo5pyl2Ew/lPIeaurpQ8bYme9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	Amir Goldstein <amir73il@gmail.com>,
	Serge Hallyn <serge@hallyn.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.0 168/307] fs: prepare for adding LSM blob to backing_file
Date: Mon,  4 May 2026 15:50:53 +0200
Message-ID: <20260504135149.185981479@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit 880bd496ec72a6dcb00cb70c430ef752ba242ae7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file_table.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -66,6 +66,12 @@ void backing_file_set_user_path(struct f
 }
 EXPORT_SYMBOL_GPL(backing_file_set_user_path);
 
+static inline void backing_file_free(struct backing_file *ff)
+{
+	path_put(&ff->user_path);
+	kmem_cache_free(bfilp_cachep, ff);
+}
+
 static inline void file_free(struct file *f)
 {
 	security_file_free(f);
@@ -73,8 +79,7 @@ static inline void file_free(struct file
 		percpu_counter_dec(&nr_files);
 	put_cred(f->f_cred);
 	if (unlikely(f->f_mode & FMODE_BACKING)) {
-		path_put(backing_file_user_path(f));
-		kmem_cache_free(bfilp_cachep, backing_file(f));
+		backing_file_free(backing_file(f));
 	} else {
 		kmem_cache_free(filp_cachep, f);
 	}
@@ -283,6 +288,12 @@ struct file *alloc_empty_file_noaccount(
 	return f;
 }
 
+static int init_backing_file(struct backing_file *ff)
+{
+	memset(&ff->user_path, 0, sizeof(ff->user_path));
+	return 0;
+}
+
 /*
  * Variant of alloc_empty_file() that allocates a backing_file container
  * and doesn't check and modify nr_files.
@@ -305,7 +316,14 @@ struct file *alloc_empty_backing_file(in
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
 EXPORT_SYMBOL_GPL(alloc_empty_backing_file);



