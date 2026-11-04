Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C798C606A32F
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Nov 2026 04:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=CXImXi71
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jKBqg3xDzz2y89;
	Wed, 04 Nov 2026 15:12:47 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=154.81.10.32
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793765567;
	cv=none; b=VUI9L13C53neZhSO2wodEm5L3tyWeYqS7Cy+7JjnpeSNUBtzJPsMguZo84/Ki3Az+jOcd+gHkskQhsl68OSzhSJUYu5PXoktPjBwHQTPKP8bLviJNHf3gBk5znmEXsoee3LKddWcYTCSbQU3emJIO+rwBI7YBWVcdenygRrL/Dp9HwZO+SJ8mFepHZ6/CTFNDdQn5ApDvCdPZnVOjzLFWPbNHov0wQlLk66Dtl07317gNusYDZaQ36yoyiIJ9QnMX+VPYb9MbF1JF5cZ/pZLgO9bxrs7amNj9OX6LtLyE1R9SsvAN5aXgsxnq+mBJrL2nVvbGp3QKW3/DDp1uiNMIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793765567; c=relaxed/relaxed;
	bh=ffVAoUStzWVADAKSO71SuGTzq8J7QN+HgJlhLet7uUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWvrGHppDGV5AFBHPu001Seq/jtZSE2d7UetsKA51j3LtLT7Omn58o2KTlYOheV9DrP5r13eOSLPmNI7uzKEnATmJk8hT4As/+g5TbaU3UJGnqQzZ98oZWsphHrlBUQD+eI6EUUbXJsQAHU3Gtgk+rrK1wrw1rkIprXHJ9db+XJjidkuEx4D2IOUyKQxVmH9+ARnXmiMsOc81AVrOTN+IfDeh9hrxfl6RQBMYUXbJ+h5l6bii7MuLA6fY842QsPxGtFzl1IAKkgpPnjXWvq5LAsFBmGgXfJSWbcYXdq3hrKSuRoR7fqhkVBRCKDW6SCnYG8Hvz8CFREpSLiqke3UuA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=CXImXi71; dkim-atps=neutral; spf=pass (client-ip=154.81.10.32; helo=mail-m1032.netease.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org) smtp.mailfrom=deepseek.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=CXImXi71;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=deepseek.com (client-ip=154.81.10.32; helo=mail-m1032.netease.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 303 seconds by postgrey-1.37 at boromir; Wed, 04 Nov 2026 15:12:44 AEDT
Received: from mail-m1032.netease.com (mail-m1032.netease.com [154.81.10.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jKBqc2GtYz2x9N
	for <linux-erofs@lists.ozlabs.org>; Wed, 04 Nov 2026 15:12:43 +1100 (AEDT)
Received: from localhost.localdomain (unknown [124.243.154.173])
	by smtp.qiye.163.com (Hmail) with ESMTP id 536bdc6ee;
	Wed, 4 Nov 2026 12:07:37 +0800 (GMT+08:00)
From: Wenyuan Xu <sereno.xu@deepseek.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: sereno.xu@deepseek.com
Subject: [RFC 5/7] erofs-utils: mkfs: support two-field manifest records
Date: Wed,  4 Nov 2026 04:07:23 +0000
Message-ID: <20261104040725.2473313-6-sereno.xu@deepseek.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104040725.2473313-1-sereno.xu@deepseek.com>
References: <20261104040725.2473313-1-sereno.xu@deepseek.com>
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
X-HM-Tid: 0aa1a4bdb1b803a3kunma3fc75f17e088
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaT0lPVhgdTEtDShhOTkpCQlYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU9VSU9IVUpOT1VKTEhZV1kWGg8SFR0UWUFZS1VLVU
	tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=CXImXi71QUta9jf9KYkBiRqxY4Q1L5TMldVYY6e2QK97VRyalR9QpZKLeBmCM+m6hHJCURU5YabXI7qNvTcQz7GnNv9ZCmUdo+1nXP5PhEV6odFJVdjJFAK+P0wsA1KGJqJdYbf5wzgal1CvSaAjLemD5TqAsz45uZb+U4YhQMw=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=ffVAoUStzWVADAKSO71SuGTzq8J7QN+HgJlhLet7uUM=;
	h=date:mime-version:subject:message-id:from;
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Accept PATH PAYLOAD records alongside complete manifest records. Import
metadata and xattrs from the backing file using local import policies,
without recursively scanning directories. Read symbolic links without
following their targets.

Preserve source hard links unless hard dereferencing is requested, and
count only entries imported into the image. Allow explicit hard links
to refer to entries imported from backing files.

Assisted-by: LLM
Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
---
 lib/manifest.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 86 insertions(+), 2 deletions(-)

diff --git a/lib/manifest.c b/lib/manifest.c
index bf8eb8c..244c1a0 100644
--- a/lib/manifest.c
+++ b/lib/manifest.c
@@ -175,6 +175,75 @@ enum erofs_manifest_field {
 	EROFS_MANIFEST_FIELD_COUNT,
 };
 
+static struct erofs_inode *erofs_manifest_load_local(struct erofs_importer *im,
+		struct erofs_inode *parent, char *payload)
+{
+	struct erofs_inode *inode;
+	struct stat st;
+	char *path;
+	size_t len;
+	int ret;
+
+	/* PAYLOAD */
+	if (erofs_manifest_decode(payload, false, &len) || *payload != '/')
+		return ERR_PTR(-EINVAL);
+	if (asprintf(&path, "%s%s", im->params->source, payload) < 0)
+		return ERR_PTR(-ENOMEM);
+
+	ret = lstat(path, &st) ? -errno : 0;
+	if (ret)
+		goto out_path;
+	if (!S_ISDIR(st.st_mode) && !im->params->hard_dereference) {
+		inode = erofs_iget(st.st_dev, st.st_ino);
+		if (inode) {
+			free(path);
+			if (inode->i_nlink == UINT_MAX) {
+				erofs_iput(inode);
+				return ERR_PTR(-EOVERFLOW);
+			}
+			++inode->i_nlink;
+			return inode;
+		}
+	}
+
+	inode = erofs_new_inode(im->sbi);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
+		goto out_path;
+	}
+	ret = erofs_fill_inode(im, inode, &st, path);
+	if (ret)
+		goto out_inode;
+	inode->i_parent = parent;
+	inode->datasource = EROFS_INODE_DATA_SOURCE_LOCALPATH;
+	if (S_ISLNK(inode->i_mode)) {
+		inode->i_link = malloc(st.st_size);
+		if (!inode->i_link) {
+			ret = -ENOMEM;
+			goto out_inode;
+		}
+		if (readlink(path, inode->i_link, st.st_size) < 0) {
+			ret = -errno;
+			goto out_inode;
+		}
+	}
+
+	if (!im->params->no_xattrs) {
+		/* XATTR */
+		ret = erofs_scan_file_xattrs(inode);
+		if (ret)
+			goto out_inode;
+	}
+
+	free(path);
+	return inode;
+out_inode:
+	erofs_iput(inode);
+out_path:
+	free(path);
+	return ERR_PTR(ret);
+}
+
 static int erofs_manifest_parse_record(struct erofs_importer *im,
 				 struct erofs_inode *sentinel, char *line)
 {
@@ -183,7 +252,7 @@ static int erofs_manifest_parse_record(struct erofs_importer *im,
 	struct erofs_dentry *d;
 	char *f[EROFS_MANIFEST_FIELD_COUNT], *token, *dot;
 	char name[EROFS_NAME_LEN + 1];
-	bool hardlink, is_root;
+	bool hardlink, is_root, short_record = false;
 	u64 mode, size = 0, uid, gid, rdev = 0, sec, nsec;
 	size_t len;
 	int i, ret = -EINVAL;
@@ -196,8 +265,13 @@ static int erofs_manifest_parse_record(struct erofs_importer *im,
 		do {
 			token = strsep(&line, " ");
 		} while (token && !*token);
-		if (!token)
+		if (!token) {
+			if (i == EROFS_MANIFEST_PAYLOAD + 1) {
+				short_record = true;
+				break;
+			}
 			return -EINVAL;
+		}
 		f[i] = token;
 	}
 
@@ -212,6 +286,16 @@ static int erofs_manifest_parse_record(struct erofs_importer *im,
 		return -EEXIST;
 	is_root = parent == sentinel;
 
+	if (short_record) {
+		inode = erofs_manifest_load_local(im, parent,
+				f[EROFS_MANIFEST_PAYLOAD]);
+		if (IS_ERR(inode))
+			return PTR_ERR(inode);
+		if (is_root && !S_ISDIR(inode->i_mode))
+			goto out;
+		goto link;
+	}
+
 	/* MODE */
 	hardlink = f[EROFS_MANIFEST_MODE][0] == '@';
 	if (hardlink) {
-- 
2.43.0


