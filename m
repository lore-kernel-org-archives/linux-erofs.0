Return-Path: <linux-erofs+bounces-4005-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 762BDC531C9
	for <linux-erofs@archiver.kernel.org>; Sat, 25 Jul 2026 15:09:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h6pDX3xxxz2yFg;
	Sun, 26 Jul 2026 01:09:32 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::330"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784992172;
	cv=none; b=InMEav5pXsJXUfSNpKaMPRuPu0Af2A/OAfR96DPz3BcFKhE9u41nackaUhq5ZiZRLewywWbID35S9pUaLa1HUN43nJ/0GWch2UezN5xpFC9FDS3ya4lxXlDbEIdJqUCqfzim2Ra2ctW2yg2Ye0uTHAY8NqJWL1/HPLMTWAtIIuETwWo6xTnVd6TNGiPh2qLHoznSE087PYBbvsZz0hnkshCYNGz8CYJCIBXKsKHsg9XQdNMbsLdALwsPC07KAPTZxxEQx6UyEx4WtnGNBKHDiCTHuodBXAj1BG4tAN10KYCTkhiVegiGUBZ3jxojpqOrdrHFIeAXjzpOAkyPq4C+UA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784992172; c=relaxed/relaxed;
	bh=KCy7pdKEYUPKAWT3r58iDEgFKac/6WybGjekqTA8tJs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ar4Shf5ozoPbigHEV/NnwPI1k5TF2b3Y8NBWW16wuFMIuKuInQavASpytBSnmsBtXk3BWd/DcF5R/h90J1IhsvdpELzQaRS+Lf0emnJ6YXg1jtV7Xl2S42lrSlOgb0iPbTvBjfWwFxoA+Yj/iweHFcPCP49kv2ey0BxAhkdUb78Z1LUvmAgKAqJ1cKqdWiTpEj0WSZd+NPgQhM+2Fi+Eflz5Z+KmPnsWvhEHSJlEMFg80cFdqMEdANQf8I7M3ssyDuPAlhPPsvMruKfC/QtG+4ldQ6AXr37UXEFNf1rKEVnULjR3wLsJKGj/kkTYLfya1nSPopWJcTz+I4ugtCmsFA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mIrDm264; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::330; helo=mail-wm1-x330.google.com; envelope-from=mike.malyshev@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mIrDm264;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::330; helo=mail-wm1-x330.google.com; envelope-from=mike.malyshev@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h6pDT5s30z2xl5
	for <linux-erofs@lists.ozlabs.org>; Sun, 26 Jul 2026 01:09:28 +1000 (AEST)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-49545ba3d4eso7725995e9.3
        for <linux-erofs@lists.ozlabs.org>; Sat, 25 Jul 2026 08:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784992164; x=1785596964; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KCy7pdKEYUPKAWT3r58iDEgFKac/6WybGjekqTA8tJs=;
        b=mIrDm264t/QbYJSc2kvnPUqlJGHNEdZhxkxrZes2BVOfN6br/jHkY2gC4kphHrnfwY
         4nAOYE8+SRxrxKHo1ESJVXQ5mxH6w+BB0Y/4ivtiP5GxQYbyr5YVa5tXAx1wGVMIpsxI
         CsNgV9K2ffAcSDAcigkkr6IEV62pZbj5OBzZtfn08LO4d0Ud68E7CGQ4wQWOJ6W+i+73
         SLLpPXFqM0Pe2pVgLFzs3jmT8Qir9hZLsVIuHGL47Z3rfkh+n31FSVd1DZOcYTe1dmFG
         3f7d9WtDmSrMNM/snXhw+1Oybt1WJqz9chixSmRvZhBeFgKLPBdVBM2+JzE63deziFkY
         an4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784992164; x=1785596964;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KCy7pdKEYUPKAWT3r58iDEgFKac/6WybGjekqTA8tJs=;
        b=laalKjz0+CGzN/9F+h+LolOJkz3BgqUBVytbYthdwdaGIh7qVsRNDudUGHp2G8myxe
         VOBae0VkOO21i+rybByjV/cZmEiSc7jPVvU7DXH31Ho9915+M6U3YAH4PNjG6y+ko3Sw
         4oqLQ5YYbajWkWUUAhjAF+ed7BLQKiwHwcDTux8T8eW3Ft8jv6EYS/6+Sl9J64hVq1jt
         TqQ24kdue+mmhR9V9prTnHUZDfhmMyE4lugblpUspw6hsOnjF1dLMpkQPky769zM9QrY
         Ks6n+lMe65quskmtGIL4IivA8HlWrGlANj81J9PdF6eMOObXCDzLba4ykPxHa/4ScY3z
         PkLw==
X-Gm-Message-State: AOJu0Yy920+fiudj1kzDG8hLZk9I2dRWy9AbhVmAHu/GA0neD0NBh/TO
	iGlacZVwWz1XUDUguuQ7L2uMRcDIIBcjtT2VCwMYSQ5OSZQ0G2apO2dfeZtMwhLaWVc=
X-Gm-Gg: AR+sD12T08DHSxPRErNjaP4iU+1pXg8iNiEsRxqOScrbEuNNC+zsjoGMXodvz0r4yM4
	Lh13vtlGXqzmA8m5zBFSULrtR7442HcsCtUH/WaZ0Fed3E2+5Zvkf4WPq/950MgdIKEDnvyVc/6
	IPtXgiLXzkuOefOfwAvV1pu0zv8EQXWRaocljjns4KURg4mVQ11NBx7BywwjSWUGgK28w+M3iLq
	OR8K0H9mREHjnAexHALYgZ0sYDv5PHZDiy61QI+q8dViWB74qmM9PgxUZpnZgvtsBvQPBrdJKqN
	YTh/irmjbseijtF3/A0NGN0OygtgSeV9O4tT8Kr8QWY0yTVCojeqfy0eAYPC4uGN+et21X3fV3b
	kCQQH4/ziN+4tWAMRn9URmtGCVv/DbO5Fr7Y1G84BhXIVbbsEj1238YBH6tnibmdpc+j98mufbk
	StkmGSRYW0sV3Qe/6WPw==
X-Received: by 2002:a05:600c:1c27:b0:492:6efc:7c60 with SMTP id 5b1f17b1804b1-496b57257dbmr34141655e9.28.1784992163572;
        Sat, 25 Jul 2026 08:09:23 -0700 (PDT)
Received: from build-server.. ([62.96.37.222])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b388d5b4sm60137165e9.3.2026.07.25.08.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 08:09:22 -0700 (PDT)
From: mike.malyshev@gmail.com
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>,
	Mikhail Malyshev <mike.malyshev@gmail.com>
Subject: [PATCH] erofs-utils: lib: follow symlinks on intermediate tar path components
Date: Sat, 25 Jul 2026 15:09:20 +0000
Message-ID: <20260725150920.1900298-1-mike.malyshev@gmail.com>
X-Mailer: git-send-email 2.43.0
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

From: Mikhail Malyshev <mike.malyshev@gmail.com>

mkfs.erofs --tar fails to convert layers that store files underneath a
symlinked directory, a very common "usr-merge" layout in RHEL/UBI/Fedora
based OCI images.  For example a base layer contains

    lib64 -> usr/lib64        (symlink)
    usr/lib64/                (directory)
    lib64/libc.so.6           (regular file, path goes THROUGH the symlink)

erofs_rebuild_get_dentry() walks the path component by component and, when
it hits the "lib64" component, finds an existing dentry that is a symlink
rather than a directory.  Since there are still components left to resolve
it bails out with -ENOTDIR.  In practice this surfaces as a bogus ~2 TiB
image and "Could not format the device", making the whole layer
unconvertible even though nothing is wrong with the tar.

A real filesystem (and containerd's walking differ, which applies the same
layers via fs.RootPath) resolves such a path by following the symlink to
its target directory.  Do the same during tar rebuild: when an intermediate
path component resolves to a symlink, follow it to the target directory
(relative targets from the containing directory, absolute targets from the
tree root), chasing chained symlinks up to a bounded depth to avoid loops.

Signed-off-by: Mikhail Malyshev <mike.malyshev@gmail.com>
---
 lib/rebuild.c | 72 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 70 insertions(+), 2 deletions(-)

diff --git a/lib/rebuild.c b/lib/rebuild.c
index 108a464..febc95c 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -82,8 +82,60 @@ struct erofs_dentry *erofs_d_lookup(struct erofs_inode *dir, const char *name)
 	return NULL;
 }
 
-struct erofs_dentry *erofs_rebuild_get_dentry(struct erofs_inode *pwd,
-		char *path, bool aufs, bool *whout, bool *opq, bool to_head)
+/* Bound symlink chains during path resolution, like the kernel's MAXSYMLINKS. */
+#define EROFS_REBUILD_SYMLINK_DEPTH	40
+
+static struct erofs_dentry *__erofs_rebuild_get_dentry(struct erofs_inode *root,
+		struct erofs_inode *pwd, char *path, bool aufs,
+		bool *whout, bool *opq, bool to_head, unsigned int depth);
+
+/*
+ * Resolve the target of an intermediate symlink path component to its
+ * directory inode, following chained symlinks up to a bounded depth.  This
+ * lets tar layers that store files under a symlinked directory be converted
+ * the same way a real filesystem extracts them, e.g. usr-merge layouts where
+ * "/lib64 -> usr/lib64" coexists with entries such as "lib64/libc.so.6".
+ */
+static struct erofs_inode *erofs_rebuild_follow_link(struct erofs_inode *root,
+		struct erofs_inode *pwd, struct erofs_inode *link,
+		unsigned int depth)
+{
+	struct erofs_dentry *d;
+	struct erofs_inode *base;
+	bool dumb_wh, dumb_opq;
+	char *target;
+
+	if (depth >= EROFS_REBUILD_SYMLINK_DEPTH)
+		return ERR_PTR(-ELOOP);
+	if (!link->i_link)
+		return ERR_PTR(-ENOENT);
+
+	target = strdup(link->i_link);
+	if (!target)
+		return ERR_PTR(-ENOMEM);
+
+	/* absolute targets are resolved from the tree root */
+	base = target[0] == '/' ? root : pwd;
+	d = __erofs_rebuild_get_dentry(root, base, target, false,
+				       &dumb_wh, &dumb_opq, false, depth + 1);
+	free(target);
+	if (IS_ERR(d))
+		return ERR_CAST(d);
+	/* target referred to the root or the base directory itself ("/", ".") */
+	if (!d)
+		return base;
+	if (d->type == EROFS_FT_DIR)
+		return d->inode;
+	/* the target is itself a symlink: keep following the chain */
+	if (d->type == EROFS_FT_SYMLINK)
+		return erofs_rebuild_follow_link(root, d->inode->i_parent,
+						 d->inode, depth + 1);
+	return ERR_PTR(-ENOTDIR);
+}
+
+static struct erofs_dentry *__erofs_rebuild_get_dentry(struct erofs_inode *root,
+		struct erofs_inode *pwd, char *path, bool aufs,
+		bool *whout, bool *opq, bool to_head, unsigned int depth)
 {
 	struct erofs_dentry *d = NULL;
 	char *s = path;
@@ -121,6 +173,15 @@ struct erofs_dentry *erofs_rebuild_get_dentry(struct erofs_inode *pwd,
 			}
 
 			d = erofs_d_lookup(pwd, s);
+			if (d && slash && d->type == EROFS_FT_SYMLINK) {
+				pwd = erofs_rebuild_follow_link(root, pwd,
+							d->inode, depth);
+				if (IS_ERR(pwd))
+					return ERR_CAST(pwd);
+				*slash = '/';
+				s = slash + 1;
+				continue;
+			}
 			if (d) {
 				if (d->type != EROFS_FT_DIR) {
 					if (slash)
@@ -152,6 +213,13 @@ struct erofs_dentry *erofs_rebuild_get_dentry(struct erofs_inode *pwd,
 	return d;
 }
 
+struct erofs_dentry *erofs_rebuild_get_dentry(struct erofs_inode *pwd,
+		char *path, bool aufs, bool *whout, bool *opq, bool to_head)
+{
+	return __erofs_rebuild_get_dentry(pwd, pwd, path, aufs, whout, opq,
+					  to_head, 0);
+}
+
 static int erofs_rebuild_write_blob_index(struct erofs_sb_info *dst_sb,
 					  struct erofs_inode *inode)
 {
-- 
2.43.0


