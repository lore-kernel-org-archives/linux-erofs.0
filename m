Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D89606A323
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 12:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ijp1xl/H
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQKtK6rV3z308Q;
	Thu, 12 Nov 2026 23:47:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::632"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794487673;
	cv=none; b=by41Pxb+O2Qq1zCTlXZ2quf5TMp79Uj9ZU9cXjpypZ2XRg4H1mPLYpJUM/ycyRtUqJBRBTv6ssDBv1vpoTX69e6YL4Q7FdWrhQd5+ZfadwbXL1g/KFXjDZRQvNEph/t/KO3glr3QkAdp47vz4HOeS2A/YLqAkbc6j/GycDHkDcMDMhbqKxi9jJ5+aevPK8uED+nms7fUfPHKaCWt+khbuB6QWofaLziBnQvKpeu6P5zVX+x8I5XEMmd+0E2ADt9yxEK6IW7/zTaQM604FHqhIeEzs1XOaXx+jDD6hdVXqHG6XDQo3AAuBXfaQXifZYJZyJMgWM7fbXD4WEaYoS28Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794487673; c=relaxed/relaxed;
	bh=xHKVFO/rdvpIwAhQk7C87/VisrV1bjMi7tCSVbpwkFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvSRryI57R4J21lqomSMTFJNsoDk68FuLbppqz0FRKaulchom0aLcMKhvmDBIcMx5OgI5/AhDPHV8/fvcKaxn3css23t89LV7+B4TtpsOk/peBZlbXMauLIRhKcvugFdCTL/AW7qDOzh0NBHRDtKWbSYOfx1Hkmy/pQB9H78N3qt8rGORUojpTPVJZUfNx+oUf8E5a+qK6C9mXVftWUL1/Thi+aQ/D6WIHsPSw9VdTm3YgGvalNFwViTtZKtVBtkUYRVjr6qhv+edULkv3iGKluhAuxXJG0nVUfzQqb5v90eVPWUS3tOZ4+Ax8HDPHvVYz16cYlvqN7QxPf11cka3Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ijp1xl/H; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::632; helo=mail-pl1-x632.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ijp1xl/H;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::632; helo=mail-pl1-x632.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQKtK2ZDHz2xly
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 23:47:53 +1100 (AEDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-2e942864693so22180685ad.1
        for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 04:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794487671; x=1795092471; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xHKVFO/rdvpIwAhQk7C87/VisrV1bjMi7tCSVbpwkFI=;
        b=ijp1xl/HlAWk0U9gx4EFmCHici0j+khbKkX0joYS3vY6BscacGkEY1WdMTSlEXnKp7
         GxYXLCXduVpWpo6ybfwvPsnKRumu6l+d2K73LEybrANnqCDB7j09iFmYsuM8Y57h6cgy
         EfHeC8rlo+AJsSp1+Ir8xCXN4SVci+mOafMP0ygksW8CQPleXDb2GNktRG25CqhEuETa
         cZmFjdYX/tFcwJzjHqphrTYSWESq/1agpE3bQcg61UbQAOPm9Zx2q2AUMw1Ee72gLELC
         gI2xVlQzHlOjZ6rxNxTmllvN7BTvDlv4N6aEkzqtpB6hbQ6Nin9hngxtjI3yuJuz/4Oy
         Shxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794487671; x=1795092471;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xHKVFO/rdvpIwAhQk7C87/VisrV1bjMi7tCSVbpwkFI=;
        b=i0xMN8h+a56sKQBvMLe6K7JDutBMgYGBcnrDsaca2DfL0srd6DimGiPwVCakLeD/ux
         O6LBPl0XJHLDR8rKLY8jVUAJEX1a8fXkabOt3xXQ+pbB87qBac/Q7+dlEd0JYvaHvP9c
         rHJGdwokDW/sA5T1P5DsZvyR/qQUee+2eNQbvc7Kg6XTWRAFRNzi6S3NgAtWJeaqBrWr
         0UbKY1nRretQa/SuHOeUriA/WHkPMyj/VMs25XX7c5Rj45a9CY3SjeZACCwXC6YgQvGr
         Smsa4cCkzw9flT3xcRJFKMOY4IOqH55qE4pXvLkfa3XI2y98v0jxaS8SbPECc4S3Rkxq
         8vsQ==
X-Gm-Message-State: APuU4Z+EtcFK9koqEqyyYJB7KHM3c6dmWkHbYvKKxn//PdcQnYoYY99N
	E//MELuoMWgEgPHH1moftV1vpQx+h3RI5nJmMacQ8l4OqLFyj1gKHXHL0bk9bgnC++s=
X-Gm-Gg: AYBFou1FAS0GcOxWH3yGsmYev3d+j55oSfnC7eG3nt9OzWT8p6OqVoUO4bXUAV2CiHO
	wDaix/d2mpTxgjK9QXLrXDculRxEJeCIwjpHtm5HHj84wCXhguhXKp57kaCuBX/e2BJul0uUEJV
	7jc32TJ6eL1Dn3XqoWZHg14XXircney0a6EtiJnLVCpF9pXfZIJuuvnRZiyBSgy6DrUt5gqlcAE
	XwE32ivHMZ1d0mjW85SIfpFMQxw+rxi/41VywNX22iqC5ImawQOAadxJtFSo7tYFNX2Ee7FjSLA
	vOBB5jArtjPbGRoAEx21j1QWrzCpkDI5ZNn5Mmvnsg2m0qp+Ipdeb3DGrq2HO1e6joSzeoVbF7N
	Oa44t0t/XGQJSnVDkvqXzwMgH3y8a40Aba2DockYhEPByzn7A2XSIB+v312b9LGfh500noCLqz4
	sW+PvQBzQJUexaND7YS6PUfJD8dTrWRT7McDk9P4cuhHDat69K03nkCa+T/Ka9Q4hIHUVZqZkNG
	MazAcF1lCcw1jED+iZaDtkgt2wtzEBSD/CDgtFGwEUPSKxoUNw1UxPiPPGXnm5Sm0pC/A3Di96v
	LU/jmNkbjkL1/mm0nvZO98dDk3pbC4t3bTHJDqshWwHWtD+s
X-Received: by 2002:a17:902:ec82:b0:2ed:fd82:e905 with SMTP id d9443c01a7336-2edfd82e953mr12031775ad.31.1794487671094;
        Thu, 12 Nov 2026 04:47:51 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6dd2225sm34189905ad.56.2026.11.12.04.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:47:50 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <stopire@gmail.com>
Subject: [PATCH 5/8] erofs-utils: exclude: fix stack overflow when checking long paths
Date: Thu, 12 Nov 2026 20:47:22 +0800
Message-ID: <20261112124725.2774244-6-stopire@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112124725.2774244-1-stopire@gmail.com>
References: <20261112124725.2774244-1-stopire@gmail.com>
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

Assisted-by: Codex:gpt-6-astra
Assisted-by: Claude Code:deepseek-v4.1-flash-1017
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/exclude.c | 7 ++++++-
 lib/inode.c   | 8 +++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/lib/exclude.c b/lib/exclude.c
index 6beb46b..487da6a 100644
--- a/lib/exclude.c
+++ b/lib/exclude.c
@@ -108,7 +108,12 @@ struct erofs_exclude_rule *erofs_is_exclude_path(const char *dir,
 		/* no prefix */
 		s = name;
 	} else {
-		sprintf(buf, "%s/%s", dir, name);
+		int ret = snprintf(buf, sizeof(buf), "%s/%s", dir, name);
+
+		if (ret < 0)
+			return ERR_PTR(-errno);
+		if ((size_t)ret >= sizeof(buf))
+			return ERR_PTR(-ENAMETOOLONG);
 		s = buf;
 	}
 
diff --git a/lib/inode.c b/lib/inode.c
index 3108aa0..f687857 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -1851,6 +1851,7 @@ static int erofs_mkfs_import_localdir(struct erofs_importer *im, struct erofs_in
 	__nr_subdirs = *nr_subdirs;
 	__nlink = *i_nlink;
 	while (1) {
+		struct erofs_exclude_rule *rule;
 		struct erofs_inode *inode;
 		struct erofs_dentry *d;
 		char buf[PATH_MAX];
@@ -1873,7 +1874,12 @@ static int erofs_mkfs_import_localdir(struct erofs_importer *im, struct erofs_in
 			continue;
 
 		/* skip if it's a exclude file */
-		if (erofs_is_exclude_path(dir->i_srcpath, dp->d_name))
+		rule = erofs_is_exclude_path(dir->i_srcpath, dp->d_name);
+		if (IS_ERR(rule)) {
+			ret = PTR_ERR(rule);
+			goto err_closedir;
+		}
+		if (rule)
 			continue;
 
 		d = erofs_d_alloc(dir, dp->d_name);
-- 
2.56.0


