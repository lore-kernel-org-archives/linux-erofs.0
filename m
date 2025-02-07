Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3818C0219B
	for <linux-erofs@archiver.kernel.org>; Fri,  7 Feb 2025 08:08:42 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Yq66x0Gdkz30Vk
	for <linux-erofs@archiver.kernel.org>; Fri,  7 Feb 2025 19:08:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.119
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1738915720;
	cv=none; b=d92PweqGAeJN7QdUg0wBY69aL2xrEQ86JytS+cVXCr3rEK4cZdvh02s63VqO9aI2uj0BRJsCzTx48ZUWBLdz5Kezq0Yjoe6Y2MksU+crLc36S8vKiZ+okwImC3pBVaNN0Y7qz5qMakIs8GVOhFmuQOhFfxvlVtBSzuNDlzN8woFKeZyap52yohyXJV0UoLwMFcgi4myub6EJWLWmqiGk0XHGMnDEWdNoajs+yY7nPpjkQnvEgG/1fJF2P5h6YjykuifPhsXuj0m6TEQDJRWsYj0zrpcFo8E1qaVdHZCupt603fq5EFULVuVIHL6mwCdZs8u02mzxMDG24/7whoTb+g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1738915720; c=relaxed/relaxed;
	bh=roiWbo9CpskJmB7RUqO3TURA636FBHMLgNiNyGc+Dr0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LZ+0A/jtJ5KHVJyBUX00i20UOnqq3X4Asz2BwY/nicRDss9zihcsTav0GEx/o6IS+cXgFpMGXnk0bK3EjC9TtvXTYPClvysH1o//ubPm+P2glPshaY4fuNKOJ2qZ4Ksyyeip3eREM6kDQNNF03wOB9hsYCSZ2dzG8OY1wZQwrErsfSlqw/vVkcj8A8swATyxXNQA+BjFnq3I0K01svzPQl8qwe0rP8V/AI+UgamQnoHGDbSuJOqxEBpPr67oBYwtu5/H/XDeM6SYAxx4anQhQrNh+mPZrw7h5OCLSgZX+csCR5hhGFl3ACFs3mJoEjrcd8tf38T+e87giRjTjppGrQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cdLp8bSX; dkim-atps=neutral; spf=pass (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=hongzhen@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cdLp8bSX;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=hongzhen@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Yq66t20yYz3045
	for <linux-erofs@lists.ozlabs.org>; Fri,  7 Feb 2025 19:08:36 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1738915713; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=roiWbo9CpskJmB7RUqO3TURA636FBHMLgNiNyGc+Dr0=;
	b=cdLp8bSX95HKugdZkvNLXSm8C2aJZAHtEL8cVfe4/xc5B7FQLVZC3vkMIdLdSHcwHBIjO4/SiWU2ZsMuoMqPsIhJ2CaRQzmvcfTzKNurrCanC+7gz2Zyl0WVzK8Bw6tuWTNlt3P7+YvwT7iTxmRthg8kozVA1barZ88UfvCsKPo=
Received: from localhost(mailfrom:hongzhen@linux.alibaba.com fp:SMTPD_---0WOylSQ5_1738915710 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 07 Feb 2025 16:08:30 +0800
From: Hongzhen Luo <hongzhen@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH v2] erofs: use Z_EROFS_LCLUSTER_TYPE_MAX to simplify switches
Date: Fri,  7 Feb 2025 16:08:29 +0800
Message-ID: <20250207080829.2405528-1-hongzhen@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
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
Cc: linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

There's no need to enumerate each type.  No logic changes.

Signed-off-by: Hongzhen Luo <hongzhen@linux.alibaba.com>
---
Changes since v1: Put the exception branch at the beginning.

v1: https://lore.kernel.org/all/20250207064135.2249529-1-hongzhen@linux.alibaba.com/
---
 fs/erofs/zmap.c | 65 +++++++++++++++++++++----------------------------
 1 file changed, 28 insertions(+), 37 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 689437e99a5a..f65c76991e02 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -265,23 +265,22 @@ static int z_erofs_extent_lookback(struct z_erofs_maprecorder *m,
 		if (err)
 			return err;
 
-		switch (m->type) {
-		case Z_EROFS_LCLUSTER_TYPE_NONHEAD:
+		if (m->type >= Z_EROFS_LCLUSTER_TYPE_MAX) {
+			erofs_err(sb, "unknown type %u @ lcn %lu of nid %llu",
+				  m->type, lcn, vi->nid);
+			DBG_BUGON(1);
+			return -EOPNOTSUPP;
+		}
+
+		if (m->type == Z_EROFS_LCLUSTER_TYPE_NONHEAD) {
 			lookback_distance = m->delta[0];
 			if (!lookback_distance)
 				goto err_bogus;
 			continue;
-		case Z_EROFS_LCLUSTER_TYPE_PLAIN:
-		case Z_EROFS_LCLUSTER_TYPE_HEAD1:
-		case Z_EROFS_LCLUSTER_TYPE_HEAD2:
+		} else if (m->type < Z_EROFS_LCLUSTER_TYPE_MAX) {
 			m->headtype = m->type;
 			m->map->m_la = (lcn << lclusterbits) | m->clusterofs;
 			return 0;
-		default:
-			erofs_err(sb, "unknown type %u @ lcn %lu of nid %llu",
-				  m->type, lcn, vi->nid);
-			DBG_BUGON(1);
-			return -EOPNOTSUPP;
 		}
 	}
 err_bogus:
@@ -329,35 +328,31 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 	DBG_BUGON(lcn == initial_lcn &&
 		  m->type == Z_EROFS_LCLUSTER_TYPE_NONHEAD);
 
-	switch (m->type) {
-	case Z_EROFS_LCLUSTER_TYPE_PLAIN:
-	case Z_EROFS_LCLUSTER_TYPE_HEAD1:
-	case Z_EROFS_LCLUSTER_TYPE_HEAD2:
+	if (m->type >= Z_EROFS_LCLUSTER_TYPE_MAX) {
+		erofs_err(sb, "cannot found CBLKCNT @ lcn %lu of nid %llu", lcn, vi->nid);
+		DBG_BUGON(1);
+		return -EFSCORRUPTED;
+	}
+
+	if (m->type == Z_EROFS_LCLUSTER_TYPE_NONHEAD) {
+		if (m->delta[0] != 1) {
+			erofs_err(sb, "bogus CBLKCNT @ lcn %lu of nid %llu", lcn, vi->nid);
+			DBG_BUGON(1);
+			return -EFSCORRUPTED;
+		}
+		if (m->compressedblks)
+			goto out;
+	} else if (m->type < Z_EROFS_LCLUSTER_TYPE_MAX) {
 		/*
 		 * if the 1st NONHEAD lcluster is actually PLAIN or HEAD type
 		 * rather than CBLKCNT, it's a 1 block-sized pcluster.
 		 */
 		m->compressedblks = 1;
-		break;
-	case Z_EROFS_LCLUSTER_TYPE_NONHEAD:
-		if (m->delta[0] != 1)
-			goto err_bonus_cblkcnt;
-		if (m->compressedblks)
-			break;
-		fallthrough;
-	default:
-		erofs_err(sb, "cannot found CBLKCNT @ lcn %lu of nid %llu", lcn,
-			  vi->nid);
-		DBG_BUGON(1);
-		return -EFSCORRUPTED;
+		goto out;
 	}
 out:
 	m->map->m_plen = erofs_pos(sb, m->compressedblks);
 	return 0;
-err_bonus_cblkcnt:
-	erofs_err(sb, "bogus CBLKCNT @ lcn %lu of nid %llu", lcn, vi->nid);
-	DBG_BUGON(1);
-	return -EFSCORRUPTED;
 }
 
 static int z_erofs_get_extent_decompressedlen(struct z_erofs_maprecorder *m)
@@ -386,9 +381,7 @@ static int z_erofs_get_extent_decompressedlen(struct z_erofs_maprecorder *m)
 				m->delta[1] = 1;
 				DBG_BUGON(1);
 			}
-		} else if (m->type == Z_EROFS_LCLUSTER_TYPE_PLAIN ||
-			   m->type == Z_EROFS_LCLUSTER_TYPE_HEAD1 ||
-			   m->type == Z_EROFS_LCLUSTER_TYPE_HEAD2) {
+		} else if (m->type < Z_EROFS_LCLUSTER_TYPE_MAX) {
 			if (lcn != headlcn)
 				break;	/* ends at the next HEAD lcluster */
 			m->delta[1] = 1;
@@ -452,8 +445,7 @@ static int z_erofs_do_map_blocks(struct inode *inode,
 		}
 		/* m.lcn should be >= 1 if endoff < m.clusterofs */
 		if (!m.lcn) {
-			erofs_err(inode->i_sb,
-				  "invalid logical cluster 0 at nid %llu",
+			erofs_err(inode->i_sb, "invalid logical cluster 0 at nid %llu",
 				  vi->nid);
 			err = -EFSCORRUPTED;
 			goto unmap_out;
@@ -469,8 +461,7 @@ static int z_erofs_do_map_blocks(struct inode *inode,
 			goto unmap_out;
 		break;
 	default:
-		erofs_err(inode->i_sb,
-			  "unknown type %u @ offset %llu of nid %llu",
+		erofs_err(inode->i_sb, "unknown type %u @ offset %llu of nid %llu",
 			  m.type, ofs, vi->nid);
 		err = -EOPNOTSUPP;
 		goto unmap_out;
-- 
2.43.5

