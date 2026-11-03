Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19931606A334
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Nov 2026 12:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iQjQoALR
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jJpS00tfFz2xK7;
	Tue, 03 Nov 2026 23:54:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793710464;
	cv=none; b=Ilm7MoNIT8JfoeEe05Tv+3FCx9N2bhEMAXcY0WK+PXa/xV10U/6CeIWPX2aiAVTY6Twn1WzM2N2WhZfstjoQUe6gSiNJQgeyz9YfVAxnWojYvcUMbpRq0OiW7YI+7UO424RF/VDj2kxFn7UN7x59vqTVUQJy2/nz7wkgmeZHAA/EmyL/0Jh9Vtzhzsw0uzQRqFAN7WCM5v0vDeDGFg9nm1r3vfyvcNGSkYvWKYF/o5RFJ+N4KBBefnsumCuhioUD3Dg879vBH28k89YuuxXxB8VRgk9vVMFNB9b9auBp0I6uL69Ph8T9uEYmDPaVhq3hbyShmizulVxLVfbGRRn5zA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793710464; c=relaxed/relaxed;
	bh=6l0I/mq9iZ9HD/h7Ui4EY7ABhj1TqxJgvRYhqBnTbAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dulygynj2A23CnaaptSydTVeTMxwSRr0zXi1OHUieAAFKKjO2G4InQO8TYr20cKo3jRp3zc5gSoW8rHyeRaKNSY31uhjnmZt6Apt/AtTTLVWo5LVJxSFvT0LQWmz92eSZHHOBSvmz+jlkS4pYnxkxIjnMSgsRJSCqkrmbne2IPbBNNa6C5p4ucfRiny5mVWGvTMWiByOKBjgD8JobPcyGWaatEmXYfN4di1eqAy8zH//cFlqdFJdQkji04Fm30017zXiXkgNMXNHkBTz+EP/3hEGI2sU+PynAmLczRruN7eeKm3KCjVVmyVzJhWIAoDm5OUFPmv4NNc7kYCQlfPbSw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iQjQoALR; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iQjQoALR;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jJpRy6VM9z2xH9
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Nov 2026 23:54:22 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E82E60621;
	Tue,  3 Nov 2026 12:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7324E1F000C1;
	Tue,  3 Nov 2026 12:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793710459;
	bh=6l0I/mq9iZ9HD/h7Ui4EY7ABhj1TqxJgvRYhqBnTbAQ=;
	h=From:To:Cc:Subject:Date;
	b=iQjQoALRFfomFvUW2GDR06qNgh/Q1TZ1LP4duLLnHR79jzBNGpm7zXQwtOjr83UZh
	 NDfS9V+g9awJSCPHZAZAW0A5s0HMps+2dAicL2GzMhUaS4aWLH6R/eSBOWZPQVIUkv
	 q7er+JN6EeNOBZJHYhIqKpcEnepIBbfgxgXbFs1nSbdgeduJXqasxH3eC/lOtuWnFq
	 A35oza9Irb0kCE79WmXnfzz/nKghRc4Q2t+f3jUZpK5DzR/g2FqY6cxKJZOj8IGJRW
	 BS6AywoYP3fq2RBpCFn/swnxQfShk3CYNF8orqgYipCxQ+0pQ3OkwmmQMGHha5zL45
	 IoUpKmPxEj7Rw==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>,
	Yifan Zhao <stopire@gmail.com>
Subject: [PATCH] erofs-utils: lib: fix packed pos in erofs_xattr_flush_name_prefixes()
Date: Tue,  3 Nov 2026 13:54:12 +0100
Message-ID: <20261103125412.12594-1-xiang@kernel.org>
X-Mailer: git-send-email 2.50.1
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

erofs_os_lseek() usage is no longer valid.

Fixes: bfc94a2580c0 ("erofs-utils: lib: track packed inode position explicitly")
Fixes: e2d8dde04abf ("erofs-utils: add native Windows support")
Reported-by: Yifan Zhao <stopire@gmail.com>
Closes: https://lore.kernel.org/r/6f29b317-9df0-4e96-94c0-e3c3858f41e5@gmail.com
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 lib/fragments.c          |  4 +++-
 lib/liberofs_fragments.h |  2 +-
 lib/xattr.c              | 11 +++++------
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/lib/fragments.c b/lib/fragments.c
index 61577d2..d4e79b2 100644
--- a/lib/fragments.c
+++ b/lib/fragments.c
@@ -403,8 +403,10 @@ int erofs_flush_packed_inode(struct erofs_importer *im)
 	return 0;
 }
 
-int erofs_packedfile(struct erofs_sb_info *sbi)
+int erofs_packedfile(struct erofs_sb_info *sbi, erofs_off_t **ppos)
 {
+	if (ppos)
+		*ppos = &sbi->packedinode->pos;
 	return sbi->packedinode->fd;
 }
 
diff --git a/lib/liberofs_fragments.h b/lib/liberofs_fragments.h
index cf54936..57fe952 100644
--- a/lib/liberofs_fragments.h
+++ b/lib/liberofs_fragments.h
@@ -20,6 +20,6 @@ int erofs_fragment_pack(struct erofs_inode *inode, void *data,
 			erofs_off_t pos, erofs_off_t len, u32 tofh, bool tail);
 int erofs_fragment_commit(struct erofs_inode *inode, u32 tofh);
 int erofs_flush_packed_inode(struct erofs_importer *im);
-int erofs_packedfile(struct erofs_sb_info *sbi);
+int erofs_packedfile(struct erofs_sb_info *sbi, erofs_off_t **ppos);
 
 #endif
diff --git a/lib/xattr.c b/lib/xattr.c
index 93cfead..c670b12 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -885,6 +885,7 @@ int erofs_xattr_flush_name_prefixes(struct erofs_importer *im, bool plain)
 	struct erofs_buffer_head *bh = NULL;
 	struct erofs_vfile _vf;
 	struct ea_type_node *tnode;
+	erofs_off_t *ppos = NULL;
 	s64 start, offset = 0;
 	int err;
 
@@ -897,11 +898,9 @@ int erofs_xattr_flush_name_prefixes(struct erofs_importer *im, bool plain)
 			vf = bmgr->vf;
 		} else if (may_fragments) {
 			erofs_sb_set_fragments(sbi);
-			_vf = (struct erofs_vfile){ .fd = erofs_packedfile(sbi) };
+			_vf = (struct erofs_vfile){ .fd = erofs_packedfile(sbi, &ppos) };
 			vf = &_vf;
-			offset = erofs_os_lseek(vf->fd, 0, SEEK_CUR);
-			if (offset < 0)
-				return -errno;
+			offset = *ppos;
 			bmgr = NULL;
 		} else {
 			plain = true;
@@ -960,8 +959,8 @@ int erofs_xattr_flush_name_prefixes(struct erofs_importer *im, bool plain)
 		erofs_bdrop(bh, false);
 	} else {
 		DBG_BUGON(bmgr);
-		if (erofs_os_lseek(vf->fd, offset, SEEK_SET) < 0)
-			return -errno;
+		if (ppos)
+			*ppos = offset;
 	}
 	erofs_sb_set_xattr_prefixes(sbi);
 	return 0;
-- 
2.50.1 (Apple Git-155)


