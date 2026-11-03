Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211FC606A33F
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Nov 2026 00:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=SqdNt9D3
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jJVHW5hnXz3c2W;
	Tue, 03 Nov 2026 11:45:59 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::336"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793666759;
	cv=none; b=F+LfTHHmkMk0csRbAJ3+R/Tv91KCIB4pqTzlkddMOqcPKcfINsNO1KyhjQ6VTgiCFKjZnb/+o3Z8ht8GGRMlqb0N9l+0fKHmNLyd+JZSn2bKHpQDMEbKSTRsox9vpxx9MgYSCAIZQsoDtcRHoniIiUruXciqOz4Gxu83hLUP4KOI+wCskYiroRUCMNQdu+Zni83HzMTRtkbwe+kgyqfdqGXIyJFZcOUc0eRoytXnKJKlZm/HvZX/uKgYFom3cUx+bnfBab10CMn6Vzv2WWr7yxiGZG1j8vkhVkTdB5flHlDtaf0mHkTv2qynBOhdsZBH7E9LT+NlMZRskDyGHtf80w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793666759; c=relaxed/relaxed;
	bh=4UFBuYZtfDrF1pS0gA9vWFEJYNF8DKkI7DIC0H9gcig=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QG+qAJ4viZg4F/Ft9EoJtyz+tvXLdQHJJ+59cIrHhjD3KcOiWXtmSk02LXewpy5pLiSlEdwPou6+6OF6DDr7mZM4jk51no9232Ea9/1vX6B1Tuy8rzsYYxTMDfyrqSaf5MmQgwRvB6C+KN2wQxrvg1iIIFqUEVzzToVCUa77C6FlmPdvyMWuOxqq7LrlN94hNFTCtUrIl8NO2SbFLMsbHKfbC57PazPE8kdL9gO5F5AGX+aCwnEYfW/l8lRDRHvT2iYs3ZNK1ZYBKf//biSCHlEUN1ruD7vhgnmh5WFbZG0f6Ls0LFP+nUE0CJIFm8okynrB51o8BHxrIARHSkArfQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=SqdNt9D3; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::336; helo=mail-wm1-x336.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=SqdNt9D3;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::336; helo=mail-wm1-x336.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jJVHT5ZcBz2xLm
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Nov 2026 11:45:56 +1100 (AEDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so27307395e9.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 02 Nov 2026 16:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1793666751; x=1794271551; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4UFBuYZtfDrF1pS0gA9vWFEJYNF8DKkI7DIC0H9gcig=;
        b=SqdNt9D3/ze2mfVkNnVPDcn7PzsP1UUmHDSg9TWFWsywJ+zJj591YvGmEc6f9SQbEk
         vQ7Pt4kdIGrYnbugjSDYONYnfQsYNprFM2OAUT2afu5O7Kh7Ykvk+YvyX/evMTTmwhRX
         jYkJ6hwGnfgvlqMymdl9TxM7KeT4Aa772/P3YvEc55wkHWD2ebPgXcibYqhAgN/F9Jfr
         IOajtnSz42zTeTPzMy6fK4fxKPyFXcOj1jV6qn3sfcCNC/tDnC1YjDBPtbXfgWQkNY9h
         Wu0p7IIIn8MA555mgEkphLIxZNrACZPfVXJYzJzvCQX9mSqZu1D2/YwBSzq83gjd7kch
         eJEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793666751; x=1794271551;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4UFBuYZtfDrF1pS0gA9vWFEJYNF8DKkI7DIC0H9gcig=;
        b=ongXJj3CYLua6haZfwrnBmAlqU4N2T9LftH4uISQQSg3cTCcbv0jeqQzOpOFbhLPml
         hU2Fqs9xBgSN4DrWLfgrDSLT3ksVTZ5vmnGWoM5dffOr0hUJxHQxYMxcXFKGih5Kwsu2
         hGrvBZMh+01dkoVpMy8SCUxfU5ehtW8K4cbyZPzSOzwWWcXZEZhISMaqzgTTiiG/4rwE
         68omadPmR8K5lvbqLAhQr7DrCQ+GsAZtPgTdB9XKvurZbK0v+LUlRQWhLiqH8F23Mu3S
         axk+RLF6AKz2lPmtYDTxN73//K6kMNjzQgMcTfpWYn0pSwZ4fkwvQN613DuL2fl7h7AR
         CP/Q==
X-Gm-Message-State: AFq9FYLBOdVzbImwvKE6LdYXrc2D8V2+xdRdhrrjAsv6YbtCUbnMUM07
	az7FEhObMd/WqNnxzbKhCyvgMwpwLiefMPIJI2j7h0FdK0rBaoydFyInWiC7xCpfQncnzjCvpAw
	qmN/RHeY=
X-Gm-Gg: AYBFou1UolCPbM8GiNuFsceKA1Y/gpsuF07ndO2qsiAUc4mfQNr2gRovjhkfWyI7hAW
	yRaG93fpTaKH7Kw9CNStZvyDUY1EsEx47Gm8QiUs5YMYJ4z2gSrJY6h/LrpWBTtDUYqhjZ+R2/5
	/PwImBuSr1wj4jm27g2qR8VsEmZLPQcssLFAgChN2FVQzYwpWxo8i49ZOgs5WQlEKVjTwn5CkKe
	sytRoMT293OKTDV+tsOYac/SHCvWCm5gUJdQHBYOwzvUphlQkWu8nzE5stZLDJDTgStvOv7hy06
	hrbqEo1XrbAQQc6kcT/B1kD3siB9vHuHyYM+Ak4Mm5NK8LJT/Kv+NiZIevD3BSfWWYBRKJbRjgn
	qXCJr+HuTl1Bvnkjqi4i6aLDStFT5YzIxzvlm0Th0ZTMFXW4lBvVfMFfnaoXmA+f5usKln2akOW
	CTc5XgGTuZkKFpcOSZAPPf9SBJCZ9loKcKcJ32ZkCPv3v0zYqkqamupLt5dZ7WVBdfn9xJxRpRq
	F1h8mlx7Wx0OBKK2QgXTIqBP/wlJxYoaDWKLJjnZQVEOp97wG8cnmEWXXTEjXGrF8pT0dfmcChg
	E7iA6BalEyGjd8dC6k0GrWSrAQrZvlpzSQAznBKN1c5knv+k7jqxr3TC6bq3tp/1seznfA==
X-Received: by 2002:a05:600c:698d:b0:4a2:994:575c with SMTP id 5b1f17b1804b1-4ac185bcc4emr268153655e9.34.1793666750718;
        Mon, 02 Nov 2026 16:45:50 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:3c00:331c:b5fa:ff22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a555e59dsm22078585e9.0.2026.11.02.16.45.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 02 Nov 2026 16:45:50 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH 1/5] erofs-utils: lib: track packed inode position explicitly
Date: Tue,  3 Nov 2026 01:45:43 +0100
Message-ID: <20261103004547.15053-1-xiang.gao@docker.com>
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

Track the packed inode position in memory instead of querying the
file offset. Use positional writes for fragment data and seek
explicitly before the sendfile fallback.

Factor out __erofs_io_pwrite() and fix its short-write handling.

Assisted-by: ChatGPT:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 include/erofs/io.h |  2 +-
 lib/fragments.c    | 44 +++++++++++++++++++++-----------------------
 lib/io.c           | 29 ++++++++++++++---------------
 3 files changed, 36 insertions(+), 39 deletions(-)

diff --git a/include/erofs/io.h b/include/erofs/io.h
index 96309fd..f3d4899 100644
--- a/include/erofs/io.h
+++ b/include/erofs/io.h
@@ -68,7 +68,7 @@ struct erofs_vfile {
 	};
 };
 
-ssize_t __erofs_io_write(int fd, const void *buf, size_t len);
+ssize_t __erofs_io_pwrite(int fd, const void *buf, size_t len, u64 pos);
 int __erofs_0write(int fd, size_t len);
 
 int erofs_io_fstat(struct erofs_vfile *vf, struct stat *buf);
diff --git a/lib/fragments.c b/lib/fragments.c
index f137e41..bb9ef72 100644
--- a/lib/fragments.c
+++ b/lib/fragments.c
@@ -49,6 +49,7 @@ struct erofs_packed_inode {
 	unsigned long *uptodate;
 	erofs_mutex_t mutex;
 	u64 uptodate_bits;
+	erofs_off_t pos;
 };
 
 const char *erofs_frags_packedname = "packed_file";
@@ -245,9 +246,7 @@ int erofs_pack_file_from_fd(struct erofs_inode *inode,
 	if (__erofs_unlikely(!inode->i_size))
 		return 0;
 
-	offset = lseek(epi->fd, 0, SEEK_CUR);
-	if (offset < 0)
-		return -errno;
+	offset = epi->pos;
 
 	if (vf->ops)
 		memblock = NULL;
@@ -260,20 +259,24 @@ int erofs_pack_file_from_fd(struct erofs_inode *inode,
 		bool noseek = vf->ops && !vf->ops->pread;
 		off_t pos = fpos;
 
+		memblock = NULL;
+		rc = lseek(epi->fd, offset, SEEK_SET);
+		if (rc < 0) {
+			rc = -errno;
+			goto out;
+		}
 		do {
 			sz = min_t(u64, remaining, UINT_MAX);
 			rc = erofs_io_sendfile(&vout, vf,
 					       noseek ? NULL : &pos, sz);
-			if (rc <= 0)
-				break;
+			if (rc <= 0) {
+				if (!rc)
+					rc = -EIO;
+				goto out;
+			}
 			remaining -= rc;
 		} while (remaining);
 
-		if (remaining && rc >= 0) {
-			rc = -EIO;
-			goto out;
-		}
-
 		sz = min_t(u64, inode->i_size, EROFS_FRAGMENT_INMEM_SZ_MAX);
 		memblock = malloc(sz);
 		if (!memblock) {
@@ -291,7 +294,7 @@ int erofs_pack_file_from_fd(struct erofs_inode *inode,
 			goto out;
 		}
 	} else {
-		rc = __erofs_io_write(epi->fd, memblock, inode->i_size);
+		rc = __erofs_io_pwrite(epi->fd, memblock, inode->i_size, offset);
 		if (rc != inode->i_size) {
 			if (rc >= 0)
 				rc = -EIO;
@@ -299,6 +302,7 @@ int erofs_pack_file_from_fd(struct erofs_inode *inode,
 		}
 	}
 
+	epi->pos = offset + inode->i_size;
 	rc = erofs_fragment_pack(inode, memblock, offset, inode->i_size,
 				 tofh, onheap);
 out:
@@ -332,17 +336,16 @@ int erofs_fragment_commit(struct erofs_inode *inode, u32 tofh)
 		return 0;
 	}
 
-	offset = lseek(epi->fd, 0, SEEK_CUR);
-	if (offset < 0)
-		return -errno;
+	offset = epi->pos;
 
-	ret = write(epi->fd, fi->data, fi->length);
+	ret = __erofs_io_pwrite(epi->fd, fi->data, fi->length, offset);
 	if (ret != fi->length) {
 		if (ret < 0)
 			return -errno;
 		return -EIO;
 	}
 	offset += fi->length;
+	epi->pos = offset;
 
 	if (!list_empty(&fi->list)) {
 		struct erofs_fragment_bucket *bk = &epi->bks[FRAGMENT_HASH(tofh)];
@@ -380,7 +383,7 @@ int erofs_flush_packed_inode(struct erofs_importer *im)
 	if (!epi || !erofs_sb_has_fragments(sbi))
 		return 0;
 
-	if (lseek(epi->fd, 0, SEEK_CUR) <= 0)
+	if (!epi->pos)
 		return 0;
 
 	erofs_update_progressinfo("Processing packed data ...");
@@ -460,7 +463,6 @@ int erofs_packedfile_init(struct erofs_sb_info *sbi, bool fragments_mkfs)
 			.sbi = sbi,
 			.nid = sbi->packed_nid,
 		};
-		s64 offset;
 
 		err = erofs_read_inode_from_disk(&ei);
 		if (err) {
@@ -469,11 +471,7 @@ int erofs_packedfile_init(struct erofs_sb_info *sbi, bool fragments_mkfs)
 			goto err_out;
 		}
 
-		offset = lseek(epi->fd, ei.i_size, SEEK_SET);
-		if (offset < 0) {
-			err = -errno;
-			goto err_out;
-		}
+		epi->pos = ei.i_size;
 		epi->uptodate_bits = round_up(BLK_ROUND_UP(sbi, ei.i_size),
 					      sizeof(epi->uptodate) * 8);
 		epi->uptodate = calloc(1, epi->uptodate_bits >> 3);
@@ -548,7 +546,7 @@ static void *erofs_packedfile_preload(struct erofs_inode *pi,
 	if (err)
 		goto err_out;
 
-	err = pwrite(epi->fd, buffer, map->m_llen, map->m_la);
+	err = __erofs_io_pwrite(epi->fd, buffer, map->m_llen, map->m_la);
 	if (err < 0) {
 		err = -errno;
 		if (err == -ENOSPC) {
diff --git a/lib/io.c b/lib/io.c
index 3333170..14253af 100644
--- a/lib/io.c
+++ b/lib/io.c
@@ -26,7 +26,7 @@
 #define EROFS_MODNAME	"erofs_io"
 #include "erofs/print.h"
 
-ssize_t __erofs_io_write(int fd, const void *buf, size_t len)
+static ssize_t __erofs_io_write(int fd, const void *buf, size_t len)
 {
 	ssize_t ret, written = 0;
 
@@ -61,24 +61,12 @@ int erofs_io_fstat(struct erofs_vfile *vf, struct stat *buf)
 	return fstat(vf->fd, buf);
 }
 
-ssize_t erofs_io_pwrite(struct erofs_vfile *vf, const void *buf,
-			u64 pos, size_t len)
+ssize_t __erofs_io_pwrite(int fd, const void *buf, size_t len, u64 pos)
 {
 	ssize_t ret, written = 0;
 
-	if (__erofs_unlikely(cfg.c_dry_run))
-		return 0;
-
-	if (vf->ops)
-		return vf->ops->pwrite(vf, buf, pos, len);
-
-	pos += vf->offset;
 	do {
-#ifdef HAVE_PWRITE64
-		ret = pwrite64(vf->fd, buf, len, (off64_t)pos);
-#else
-		ret = pwrite(vf->fd, buf, len, (off_t)pos);
-#endif
+		ret = pwrite(fd, buf, len - written, (off_t)pos);
 		if (ret <= 0) {
 			if (!ret)
 				break;
@@ -96,6 +84,17 @@ ssize_t erofs_io_pwrite(struct erofs_vfile *vf, const void *buf,
 	return written;
 }
 
+ssize_t erofs_io_pwrite(struct erofs_vfile *vf, const void *buf,
+			u64 pos, size_t len)
+{
+	if (__erofs_unlikely(cfg.c_dry_run))
+		return 0;
+
+	if (vf->ops)
+		return vf->ops->pwrite(vf, buf, pos, len);
+	return __erofs_io_pwrite(vf->fd, buf, len, pos + vf->offset);
+}
+
 ssize_t erofs_io_pwritev(struct erofs_vfile *vf, const struct iovec *iov,
 			 int iovcnt, u64 pos)
 {
-- 
2.54.0 (Apple Git-157)


