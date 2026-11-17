Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBA7606A31C
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Nov 2026 07:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CHeucwop
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTGWw05JPz2yD3;
	Tue, 17 Nov 2026 18:27:08 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::42b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794900427;
	cv=none; b=L+6ZmmPYslPjx6FQAunrKZKSBlT6AnYdKwXO8DLsNF0XlzF7u9+AMQ77OyrnsCLizPuTyQfk3wkUhDC5Y4H7S5HnhDDKIii8qqp0FhIh5MTnF7wntanGU3Sq6pgwnMzSfQ1wj3dhD6BsMfb5yFTZiw6qLoRIlArEQmaYPcV+yCuWeyyUMicp5yotQEhT4ZtQDkNMSpTQXYUet4gTK31XqTQAtyfP7+zNAFX9B2k1A5GUiIPXGSdyP+dtCaAOsyBsWZT3PXivzQCNluK4Fif77n5N3a/IKkfieHuRSU/UQ2ItKkQfYRJiMqBlBnfEdNFvqy6XzQc1wxy38JVeE03ijQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794900427; c=relaxed/relaxed;
	bh=nUl/pcE+bfyFxVaKO9bRN8bgb8zEUh9VA8z0Pq5976s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Orume340YFt1uEEsad6VZc3y+kEx/MToN2RywYnJ7p116fHaRPqJmS+hSPHrtfBIBvonjBbPyEabQYf+fcO4dCPMvi76o+TYRZE0IxPdLTOBva9KjMBEd2bV3iq6CK6/rCfZDXfV4f/tkasZx1wVRuMczF6GfuQGRs1CmeLLecn6E68IJrk8ihy7qxqXNhKU/4js/CKbf+sjRuWepCJ39cPLHv3tJYMsoik4dp7SBaucN4DpBMENmihnw4/5aWpQsKs4T9IWtqZ5EKfTId6WYEIIqFs4kn0O4DUBI5sTpi1o8vAim6nE2Oor/2+yWhF9S/7PSWTNMMaOVvErEl+fwQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CHeucwop; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::42b; helo=mail-pf1-x42b.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CHeucwop;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::42b; helo=mail-pf1-x42b.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTGWv2C2sz2xPb
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 18:27:07 +1100 (AEDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-8b904d10882so1741753b3a.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Nov 2026 23:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794900425; x=1795505225; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nUl/pcE+bfyFxVaKO9bRN8bgb8zEUh9VA8z0Pq5976s=;
        b=CHeucwopJA/RBnXBK25Lqt3R0awCAkt4G8kd7iDqh8PfiIu6iMD8vxLbTbuwC9UxpE
         HOointgMUn4zx7ZjscUCHxEXG4BEb87WU1ycQDpYqfYYzaWzeegkbv1wDsebo5tqfosM
         pgT5baBphR3JDKocDS4LuleJE4gR932XRBQ3c1qbgeARIe7s6M1+miLnowUVPVgT3PmT
         BHAQa99ASZonFOdNyxZoIUid5S7rGQJkuE5TJH9X+XL+JrHUr75uWsbI55OwTLb4Wf/e
         0OgRb9IAYNWYT5l7KubmyJX5ZqJBYyC2kpRX3Wb9hdkleFXe/4W/yT0ti7wTsocZZC4O
         2+5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794900425; x=1795505225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nUl/pcE+bfyFxVaKO9bRN8bgb8zEUh9VA8z0Pq5976s=;
        b=uOUCJDW6x3GgC1cfsUJbwGeLnp5GvSw24NcEzjAcp9yR46RwIev7TkWnZ8+cTH/Ivs
         bv4cnl/I/AOeAJGmQYKPGy9EN6Xlk4kXzN5nMSP/o5bFOvL0OOz9kpAahiJkASse0ehU
         jPMT+Qy6i4Y2cRJZve+jmriVhSm+aWOzmBnDDGG9U0iK6HAEWf6HRELrbYgq+27/HoQm
         83JrFKEj1slRfe/8/f1LkhPeOBZQhSkC1SaQ+FmDOgRFrcgaFSj+9Lt9w6IPcpzm/SOo
         BYSF+4COrSrxbLEpRKvGp4XlyceSm+zIl6Uv/JW6fNJR3WMXeZf9noSIx0AGPgiCyP5h
         fbAw==
X-Gm-Message-State: APuU4Z/Ac+zMntfEHHKt5aNfYl+TPhCTUpIcNFHe97MVndiJtiMd8McK
	uDebic3TC76c4Vf2dl6HX3WCfxxSKr8KEDu08yM9B1+USlp54Iwo/qQ23h8H2q/jNV4=
X-Gm-Gg: AYBFou1/F6pkfp1wtPGcuiaIV95r3tTryDsehBh32kFfX2Y1NMOtaIQBYY2c8foHwTF
	bnzIfeHvKjEsY1wZiMolDF+0KzkJ33V104MUvAMXNm3P+mmf4V0trS1IvMMJZD2rN7IYOaQeKpX
	cKSan/a1oMiJxEApKBfxc14re5CNToVoW7udsN93Z3ISc0T9p1aTD1HRzMzgP+VrglKtF6kEUzv
	VdgSjGWNS0P38JVRE91pW0zxms6HxiReCfaO3/eFWp14O/JYtmHafAa1E9a8bhmXTXFOI4Pt2Pk
	MkE8UikF9L3kDhOzsO2BJnq+vrN/Ja/PqAlFDbGr2pvO1ZvdIQUExMeYr+z5D2+QHV9+ljzzdf+
	CTlxl06ed/iu2LCGqG617TySVBfXHupsk+8RfgLdJUFAEOPZ6llzh9xFM0cH192yWiDrN1lJfAf
	XsLvDylWi/fe+Fz9V8CeapESQq9EOQIS1UBEgykXHEDSwgAlsSJUDce8oxU3/6KeDM6lbOFYh+9
	AYWAjs09noPHtHchnCv+5VtCUESoQMoeqJ/I7WbyFyuKdvGlMrqFRexZz/pgY97fy0uMSONCxb+
	LdPeJJsgQAS54RXKkA7U2bpXznkdJogo64UkfE+KxS0nmWn5
X-Received: by 2002:a05:6a00:1746:b0:8a3:23c1:c0e3 with SMTP id d2e1a72fcca58-8beb84e28dfmr10822103b3a.59.1794900425385;
        Mon, 16 Nov 2026 23:27:05 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed2055031sm4940716b3a.39.2026.11.16.23.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 23:27:04 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Yifan Zhao <stopire@gmail.com>
Subject: [PATCH v2 4/9] erofs-utils: lib: fix erofs_io_pread() caller error handling
Date: Tue, 17 Nov 2026 15:26:24 +0800
Message-ID: <bbc8c52c67635698235c835cfff01aa05154beaa.1794899782.git.stopire@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794899782.git.stopire@gmail.com>
References: <20261112124725.2774244-1-stopire@gmail.com> <cover.1794899782.git.stopire@gmail.com>
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
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

erofs_io_pread() may return a positive value smaller than len on a
short read. Check the return value correctly in its callers.

Assisted-by: Codex:gpt-6-astra
Assisted-by: Claude Code:deepseek-v4.1-flash-1017
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/backends/fanotify.c |  3 ++-
 lib/fragments.c         |  2 +-
 lib/inode.c             | 11 +++++------
 lib/super.c             |  2 +-
 mount/main.c            | 10 +++++-----
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/lib/backends/fanotify.c b/lib/backends/fanotify.c
index cf8b616..898ea84 100644
--- a/lib/backends/fanotify.c
+++ b/lib/backends/fanotify.c
@@ -169,7 +169,8 @@ static int erofs_fanotify_handle_range(struct erofs_fanotify_ctx *ctx,
 		  (unsigned long long)(offset + length));
 
 	read_len = erofs_io_pread(&ctx->vd, ctx->fetch_buf, length, offset);
-	if (read_len < 0) {
+	if (read_len != length) {
+		read_len = read_len < 0 ? read_len : -EIO;
 		erofs_err("Failed to fetch range [%llu, %llu): %s",
 			  (unsigned long long)offset,
 			  (unsigned long long)(offset + length),
diff --git a/lib/fragments.c b/lib/fragments.c
index 1f9e493..090c135 100644
--- a/lib/fragments.c
+++ b/lib/fragments.c
@@ -148,7 +148,7 @@ int erofs_fragment_findmatch(struct erofs_inode *inode,
 	ret = erofs_io_pread(vf, data, s1, fpos + inode->i_size - s1);
 	if (ret != s1) {
 		free(data);
-		return -errno;
+		return ret < 0 ? ret : -EIO;
 	}
 	e1 = s1 - EROFS_TOF_HASHLEN;
 	deduped = 0;
diff --git a/lib/inode.c b/lib/inode.c
index 00fd885..9ce7af5 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -2024,18 +2024,17 @@ static int erofs_set_inode_fingerprint(struct erofs_inode *inode, int fd,
 	if (!ishare_xattr_prefix_id)
 		return 0;
 	erofs_sha256_init(&md);
-	do {
+	while (remaining) {
 		u8 buf[32768];
 
 		ret = erofs_io_pread(&vf, buf,
 				     min_t(u64, remaining, sizeof(buf)), pos);
-		if (ret < 0)
-			return ret;
-		if (ret > 0)
-			erofs_sha256_process(&md, buf, ret);
+		if (ret <= 0)
+			return ret < 0 ? ret : -EIO;
+		erofs_sha256_process(&md, buf, ret);
 		remaining -= ret;
 		pos += ret;
-	} while (remaining);
+	}
 	erofs_sha256_done(&md, out + sizeof("sha256:") - 1);
 #if defined(_WIN32) && !defined(__CYGWIN__)
 	ret = erofs_io_lseek(&vf, pos - inode->i_size, SEEK_SET);
diff --git a/lib/super.c b/lib/super.c
index 694a3e9..c6a9230 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -89,7 +89,7 @@ int erofs_read_superblock(struct erofs_sb_info *sbi)
 		return 0;
 
 	read = erofs_io_pread(&sbi->bdev, data, EROFS_MAX_BLOCK_SIZE, 0);
-	if (read < EROFS_SUPER_OFFSET + sizeof(*dsb)) {
+	if (read < 0 || read < EROFS_SUPER_OFFSET + sizeof(*dsb)) {
 		ret = read < 0 ? read : -EIO;
 		erofs_err("cannot read erofs superblock: %s",
 			  erofs_strerror(ret));
diff --git a/mount/main.c b/mount/main.c
index 347a71b..345053b 100644
--- a/mount/main.c
+++ b/mount/main.c
@@ -591,8 +591,8 @@ static ssize_t erofsmount_tarindex_pread(struct erofs_vfile *vf, void *buf,
 	if (index_part) {
 		local_read = erofs_io_pread(&tp->tarindex_vf, buf,
 					    index_part, offset);
-		if (local_read < 0)
-			return local_read;
+		if (local_read != index_part)
+			return local_read < 0 ? local_read : -EIO;
 	}
 	if (tardata_part) {
 		remote_read = erofs_io_pread(tp->zinfo_vf, buf + local_read,
@@ -1460,9 +1460,9 @@ static int erofsmount_ublk_handler(void *ctx, struct erofs_ublk_request *rq)
 
 	ret = erofs_io_pread(vf, rq->buf, rq->nr_sectors << 9,
 			     rq->start_sector << 9);
-	if (ret < 0) {
-		rq->result = -EIO;
-		return (int)ret;
+	if (ret != (rq->nr_sectors << 9)) {
+		rq->result = ret < 0 ? ret : -EIO;
+		return rq->result;
 	}
 	rq->result = ret;
 	return 0;
-- 
2.56.0


