Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B49E9CF6D2C
	for <linux-erofs@archiver.kernel.org>; Wed,  2 Oct 2024 14:28:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4XJccl2srGz2yZ1
	for <linux-erofs@archiver.kernel.org>; Thu,  3 Oct 2024 00:28:55 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=147.75.193.91
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1727879332;
	cv=none; b=h23QeUnhQhCgSicNJoCyKb2j+xaaPMjzGWJS6ObGYnf+MKipVvETcrOaSgaIOUhePIEMe/QgVez1cToNq9aTCBh2/JWeASkknboaGfUgYLK9Zne9td+x3btaRcXPlMXHWQaDI4kJUo2XI1l4YCRx4SWbeO8/aNVu1ONVLj96O7UWhmdri3aKWAcvTTnBe4V54KPV1JMfp8+6gTG8ssB3h2bLjzKACtuN4NG0kJVIS7XS4jcCUwbjVDv+2Whm5+cbht/ePRMnUknMUa5JI/9tVbefuj5SMTzu/jS2zFgktyEAgY0pLG+EOQYJG7lhHUPmGRmHeVI3UQUT4LG5HX1bsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1727879332; c=relaxed/relaxed;
	bh=iMy4FEBClDztJONP7hw29e+vqWzHiF3jd0b5Y3qLcR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJjpcmHe7rhlMLliPs3G8aEbs6M9MzZF/xJYb9QMmP4scitGCPwHjThaPHDVWMi4ytT6cPs7EiNYG0aR2VdTdSfu/payqeP0xIL6ePrz0AZFIEZW/vsD9FyXzmvwmeDxVFXvz48jb9SE74t3+vE3NzOKzp9kwWrkxwt0gZoK7QmfNOrISJVjXsthKjN7W7iNCoohUP3pAgNk1zuRAjyD2+mvgvY8XWq5vhfPIdhLM8F7kCCW9Eipgn6TWgIQBiIUAsm6mn35PoIUqVJXkQjsNt/SEZ+uPGN4O+vNiaI84hJSvJyDajWNDJrApNBFmkALpud1bFXHntbPriWT+MyF8w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; dkim=pass (1024-bit key; unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zk3ay2Jj; dkim-atps=neutral; spf=pass (client-ip=147.75.193.91; helo=nyc.source.kernel.org; envelope-from=gregkh@linuxfoundation.org; receiver=lists.ozlabs.org) smtp.mailfrom=linuxfoundation.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zk3ay2Jj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linuxfoundation.org (client-ip=147.75.193.91; helo=nyc.source.kernel.org; envelope-from=gregkh@linuxfoundation.org; receiver=lists.ozlabs.org)
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4XJcch0CzNz2xHt
	for <linux-erofs@lists.ozlabs.org>; Thu,  3 Oct 2024 00:28:51 +1000 (AEST)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 19DCBA41441;
	Wed,  2 Oct 2024 14:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A1BC4CEC2;
	Wed,  2 Oct 2024 14:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879329;
	bh=q3i+jh3J55NJ2YKPmphp1ZR3NNfS4eJnCqjvOtxmT18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zk3ay2JjJFdLcrl6nhhm2OfiNp1ABtROP2IsL4gHDmoy5abLtqvC++JYkrAx60pQd
	 kCNuFG5WAZiDjwo5U/NNzArzlVsamRl9OqXXhAiKWoVxpCarCCGYrtzg8Dzoccmo2z
	 MafR/74iPsA7d+QWg2Y2HkMVhtu0h9uQmVUMicSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Subject: [PATCH 6.6 081/538] cachefiles: Fix non-taking of sb_writers around set/removexattr
Date: Wed,  2 Oct 2024 14:55:20 +0200
Message-ID: <20241002125755.416948368@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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
Cc: Sasha Levin <sashal@kernel.org>, Christian Brauner <brauner@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@lists.linux.dev, David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, netfs@lists.linux.dev, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 80887f31672970abae3aaa9cf62ac72a124e7c89 ]

Unlike other vfs_xxxx() calls, vfs_setxattr() and vfs_removexattr() don't
take the sb_writers lock, so the caller should do it for them.

Fix cachefiles to do this.

Fixes: 9ae326a69004 ("CacheFiles: A cache that backs onto a mounted filesystem")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Christian Brauner <brauner@kernel.org>
cc: Gao Xiang <xiang@kernel.org>
cc: netfs@lists.linux.dev
cc: linux-erofs@lists.ozlabs.org
cc: linux-fsdevel@vger.kernel.org
Link: https://lore.kernel.org/r/20240814203850.2240469-3-dhowells@redhat.com/ # v2
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/xattr.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/fs/cachefiles/xattr.c b/fs/cachefiles/xattr.c
index 4dd8a993c60a8..7c6f260a3be56 100644
--- a/fs/cachefiles/xattr.c
+++ b/fs/cachefiles/xattr.c
@@ -64,9 +64,15 @@ int cachefiles_set_object_xattr(struct cachefiles_object *object)
 		memcpy(buf->data, fscache_get_aux(object->cookie), len);
 
 	ret = cachefiles_inject_write_error();
-	if (ret == 0)
-		ret = vfs_setxattr(&nop_mnt_idmap, dentry, cachefiles_xattr_cache,
-				   buf, sizeof(struct cachefiles_xattr) + len, 0);
+	if (ret == 0) {
+		ret = mnt_want_write_file(file);
+		if (ret == 0) {
+			ret = vfs_setxattr(&nop_mnt_idmap, dentry,
+					   cachefiles_xattr_cache, buf,
+					   sizeof(struct cachefiles_xattr) + len, 0);
+			mnt_drop_write_file(file);
+		}
+	}
 	if (ret < 0) {
 		trace_cachefiles_vfs_error(object, file_inode(file), ret,
 					   cachefiles_trace_setxattr_error);
@@ -151,8 +157,14 @@ int cachefiles_remove_object_xattr(struct cachefiles_cache *cache,
 	int ret;
 
 	ret = cachefiles_inject_remove_error();
-	if (ret == 0)
-		ret = vfs_removexattr(&nop_mnt_idmap, dentry, cachefiles_xattr_cache);
+	if (ret == 0) {
+		ret = mnt_want_write(cache->mnt);
+		if (ret == 0) {
+			ret = vfs_removexattr(&nop_mnt_idmap, dentry,
+					      cachefiles_xattr_cache);
+			mnt_drop_write(cache->mnt);
+		}
+	}
 	if (ret < 0) {
 		trace_cachefiles_vfs_error(object, d_inode(dentry), ret,
 					   cachefiles_trace_remxattr_error);
@@ -208,9 +220,15 @@ bool cachefiles_set_volume_xattr(struct cachefiles_volume *volume)
 	memcpy(buf->data, p, volume->vcookie->coherency_len);
 
 	ret = cachefiles_inject_write_error();
-	if (ret == 0)
-		ret = vfs_setxattr(&nop_mnt_idmap, dentry, cachefiles_xattr_cache,
-				   buf, len, 0);
+	if (ret == 0) {
+		ret = mnt_want_write(volume->cache->mnt);
+		if (ret == 0) {
+			ret = vfs_setxattr(&nop_mnt_idmap, dentry,
+					   cachefiles_xattr_cache,
+					   buf, len, 0);
+			mnt_drop_write(volume->cache->mnt);
+		}
+	}
 	if (ret < 0) {
 		trace_cachefiles_vfs_error(NULL, d_inode(dentry), ret,
 					   cachefiles_trace_setxattr_error);
-- 
2.43.0



