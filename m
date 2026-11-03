Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A05606A324
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Nov 2026 06:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ESVoQ6+e
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jJdw06wRMz2xSS;
	Tue, 03 Nov 2026 17:29:36 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25" arc.chain=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793687376;
	cv=pass; b=eZ6GEpOjv8sTZLYfBdONu74xcWMnIbS6T7nOPqWOPz1GNiaAETHgETnrOV6MNRnd2RbDsjLPLnYXAiWVqQr+h8i6pxolLYQdt9+lk0SvaAZDpWwBt/PQCAvXWAynHJpz8O2aSeVW4o0BlDLYLtjaHQvKSRbARMeBdaG1zNEvw5XWv0af2JOQ7tXNU7y7foHpR70aCkNDsG37H+g9UNjLceKdE+f8vkDId+uIdcmd+tkBCeSyFn3D6jIXp/H416UFv8mp7b/C+ZHR99PbnoWmCyDavSvotA+XccHXcwYIFqAeI3Rjta2+j3KMV88vlWD9076XKJLXKml5fEHxvTcA/w==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793687376; c=relaxed/relaxed;
	bh=YsyfiCpg9lxmYrMJMc2pVDhQtP06099TNCGNIqa+JxM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FnL1jfYKpZYbSopV/ObAncpymBAL8clnZRnq9R7kK1jr4a+CL1QfDGk1LVU6O0tCR2K92GRG2kPsh+qQOdASCznh4yUIiiei/Hzh2Z8Gh5v72ZdnJmExuHPcKBROqnRYcSCv6OqGjXPGQy1Jm6drH+7IgzGApbuZk1g5ZLsolhmtuxpLLSj3ys+UDT3xu7S9LPr1eDKCv1VB+GL8M92YHo0WqCo0RTCacF0wehOpbj3ze+xC+rwWGiAcO+wOAdLmKq1lDibQ3SaDJRBMPcuN56XRNkhsAYN6mfEnYpPmFbBYiDoOvvJU1m6ri1yuPxK+tVYjxtvmkMyanJ4f2nzV7g==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ESVoQ6+e; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=devnull+daejun7.park.samsung.com@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ESVoQ6+e;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=devnull+daejun7.park.samsung.com@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jJdvz3p7hz2xKQ
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Nov 2026 17:29:35 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 945F6429D7;
	Tue,  3 Nov 2026 06:29:32 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793687372;
	b=U3ZAt3aAZPhgqwkSq0h6QwcXdurN5j6DddbPLRIuZWMo+KFyD9iJdAkkmQLAUIrF3CBZ
	 LNGC76tx/BuvRVAR0eRwdyS99E+H1Nc1c+GIcLfeJr/pBdfsZd408vNG5j0wXV4OQXIdP
	 KPD8bDSw+8DVGKs4b2WW9odzfdxZS7s/SiAA/bTeUTkYl/+qn0hRv/3ywyqxZF7enjxlD
	 uQgt5epn9Ndg5+8FBZ6TAQccU1prgk5wDuB4DvjlqG+mkxQZ5lZgIrYbA2cRQC+GE9Ppz
	 ig6MDJq02MiaQF6ycEDVbgdjuvjjeRom6o5fOu3RSoC4xE1JiO45vBBLlSvcKgccSoQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793687372;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=YsyfiCpg9lxmYrMJMc2pVDhQtP06099TNCGNIqa+JxM=;
	b=2RMDRkd8m8z2Dpe+HvEUE+zm7PrhucVQrQqOsWnfPwjZNL0DG6iAaC497PH3g7SbCwLt
	 IlkH5H5O7GZPMEzEzoF3XYwKKDNgHQJSUI5/vcsuY26wZb6hZ747lOhXRKlNh0P+QPEn4
	 BCqVrI12hShXHrZrGYJTaFC0/Nv038iAp3z8PPnfYXOQiNrQYQBCSo+O2J94vP4SRfLHL
	 HDkPZ5B4oNjbZYXseeYf30mQcFoLhB/8MqQG9cdS7Wqphf8hXETo2OCsdhxwJDFHcOqTK
	 q6cyHgUAa7vyAt3Tr8xYD87mDQRzttUNJjGg2X+GQIARpalA3F16nICNBidXnqZQ6tA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B93BE1F00A02;
	Tue,  3 Nov 2026 06:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793687372;
	bh=YsyfiCpg9lxmYrMJMc2pVDhQtP06099TNCGNIqa+JxM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ESVoQ6+e1ICd0qf5MASR6lW/koOQseOyNzvCCjPUoeJd/E4KGW7943urUX852eoup
	 +9UZP6uHA7TC+BhI6D4pxuqNwJfSHMGw1h9Pt+FFHe/y7GOaWaY39dnRYWRYdf0Ncx
	 Li8dyro36aWpirblux72rQF+rp6LCSCK1DeaZ7oIGYx5TramB3ZRcE7KTqyo581Ttx
	 FLhY6lAis5PxpSLnDg5c/ma2mDU4kVTdRYBjjw+wcUsLegu7xZPxGszu8pIs/I1rMW
	 ihnVAqXYvX8sbt55dAElbcjDbu/2pd47u0kxSJQ9WYqhRvGf5PqvYJ7UoPkP6L32s7
	 gR759PG9/O0mQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 30380467D4;
	Tue,  3 Nov 2026 06:29:31 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Tue, 03 Nov 2026 15:29:31 +0900
Subject: [PATCH v2 1/3] erofs: apply the stacked fs check to extra
 file-backed devices
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
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261103-erofs-fileio-bioset-v2-1-5b91af423f72@samsung.com>
References: <20261103-erofs-fileio-bioset-v2-0-5b91af423f72@samsung.com>
In-Reply-To: <20261103-erofs-fileio-bioset-v2-0-5b91af423f72@samsung.com>
To: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>, Jingbo Xu <jefflexu@163.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793687370; l=2267;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=sBPUwaW5nh1BZZ5bGZhc9yc4TVa5dHShdY8rmkDN50M=;
 b=illcO8XCFxG/SolTRokzWsZMW4CHgUDWCeN3ezbH5XDUb4PA8UF2JLJLIYffOSRXsQ7qTWBcD
 vt4ms4C8dIABzjmVDkd4HqwvwStFV82NyQF/ABTjbi0FhSITSqXTgyg
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Daejun Park <daejun7.park@samsung.com>

erofs_fc_fill_super() rejects a file-backed mount whose image is on a
file-backed EROFS or on a filesystem with s_stack_depth set. This
bounds the nesting of reads. Extra devices given by device= are not
checked. File-backed mounts can still nest through them without limit.

Apply the same check to extra devices.

Fixes: fb176750266a ("erofs: add file-backed mount support")
Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/erofs/super.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index ce05557bd9..ee01a5ef85 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -122,6 +122,14 @@ void *erofs_read_metadata(struct super_block *sb, struct erofs_buf *buf,
 	return buffer;
 }
 
+/* see the comment in erofs_fc_fill_super() */
+static bool erofs_is_stacked_file(struct file *file)
+{
+	struct super_block *sb = file_inode(file)->i_sb;
+
+	return (sb->s_op == &erofs_sops && !sb->s_bdev) || sb->s_stack_depth;
+}
+
 static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 			     struct erofs_device_info *dif, erofs_off_t *pos)
 {
@@ -161,6 +169,11 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 		} else if (!S_ISREG(file_inode(file)->i_mode)) {
 			fput(file);
 			return -EINVAL;
+		} else if (erofs_is_stacked_file(file)) {
+			erofs_err(sb, "%s: file-backed devices cannot be on stacked fses",
+				  dif->path);
+			fput(file);
+			return -EINVAL;
 		}
 		if (!dif->dax_dev && test_opt(&sbi->opt, DAX_ALWAYS)) {
 			erofs_info(sb, "DAX unsupported by %s. Turning off DAX.",
@@ -701,9 +714,7 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 		 * It MUST change if another fs plans to support them, which
 		 * may also require adjusting FILESYSTEM_MAX_STACK_DEPTH.
 		 */
-		inode = file_inode(sbi->dif0.file);
-		if ((inode->i_sb->s_op == &erofs_sops &&
-		     !inode->i_sb->s_bdev) || inode->i_sb->s_stack_depth) {
+		if (erofs_is_stacked_file(sbi->dif0.file)) {
 			erofs_err(sb, "file-backed mounts cannot be applied to stacked fses");
 			return -ENOTBLK;
 		}

-- 
2.43.0



