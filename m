Return-Path: <linux-erofs+bounces-4581-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF982C982CC
	for <linux-erofs@archiver.kernel.org>; Sun, 20 Sep 2026 07:59:31 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hnf015lpMz2y8c;
	Sun, 20 Sep 2026 17:59:29 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::431"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789891169;
	cv=none; b=LDHvwp+mdqPqd11aU/YPQt1+wlKxIxjI7jmqwwiuKMxh52BBErW1mIETDPyY1E1pkkEV26+j038YEvA6BjsiSboelDO80p3p8h0ASwYECCjndTA2IuUczEejInSTOSLkHFLcQNi27M2aif0xXXBjkaazIMJXUd1NJrVoTM2dwwunwal+CbCZNcrI+oHzSNUraBefVBYeRRV2NswUlb2C+vOongVZHies/pSewb6t/0nAIktR3f9vQhYj2huNkE2BCcUMRe2V37fBLiJenZjTeBkwOQVOsdcEJNM2p2aEfCFaPbqS6xIiI3h2uqYFSvUbH/vAiy7d9HFpQQp9h61V7g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789891169; c=relaxed/relaxed;
	bh=0c78Z2vKrdMRWU65XsyDjEBSPDNGNHPw7EgjwZGly+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvp+8pnql3mlAkMNI3lDPgdt7ROHqthN9F8JMB2udorkyPN3EsbF91ndOGZDqTWZSaTHdX9Mz7IF5otPVaMSFi02qcz8inCVBzapdqZXTqaHYGwOfJl3Xc+43W2rdpXnCZBuucT553/pig7Bwq6hxV/G0Rn1VqQG36jedsHA9mhDwlqiuiEj7Atq/sR2oweK70BVRTFzgtmfp1LrGEeQQsdtf/qrlFcPrJ2TwuizYj84FdAADhf9v8EnNr27EZIzhT1Vs5P2xpvj7cLfP3s4y7PzSsl7IpmkB1IQA9soFZaCpt3GeAmqBp3Vx/P6N+K9KaHYHMyb1qW+h0tLMJWHuA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CIqlBlvn; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::431; helo=mail-wr1-x431.google.com; envelope-from=mike.malyshev@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CIqlBlvn;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::431; helo=mail-wr1-x431.google.com; envelope-from=mike.malyshev@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hnf0029Wbz2xqM
	for <linux-erofs@lists.ozlabs.org>; Sun, 20 Sep 2026 17:59:27 +1000 (AEST)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-48586861639so777303f8f.0
        for <linux-erofs@lists.ozlabs.org>; Sun, 20 Sep 2026 00:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789891164; x=1790495964; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0c78Z2vKrdMRWU65XsyDjEBSPDNGNHPw7EgjwZGly+g=;
        b=CIqlBlvn+h1qWnfXNVAcZo/SVKQI2maUNihb8ScUiu9scpi8pHH+pjaY/ImlgnPzEA
         SnwEDK5yNtPg34Xnm8Y5Z+5XbXFTufhjFH+s7QJtJ1msnuJuIWVSvXLZSEQQKw0U3wT3
         BttlRo/4wUEDoRVQEW9RVXIfKh0TvhbarhQbbQ7JTSZzGaO5mepjPRiuPrHxXV/wVZ2k
         aReDfoeOcQpjNBG06YWXZC9PvGqsK6osAflVJ6bOySunGdr/SWvKhnhdoyWnBSzJG75h
         Ip+da/fKlkujuC9FpnpwMmm+3mMQ5NFQHDkKQHpUM6jrh58VnZtkxJ+cWusxanUXS8Q6
         MTKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789891164; x=1790495964;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0c78Z2vKrdMRWU65XsyDjEBSPDNGNHPw7EgjwZGly+g=;
        b=MrzHVXwQxi6v7/CQ9OfJMPU0jnBg6MB879Be08Vg6EN+PlW2Ywc1UvhW+Szg5MIzcd
         5fmd9F8+H7cuRCYTBtj8RifRGkWcojhnolCi/+XY3wj8Z/0nPsxYYvf7iDuOpMdGnsNw
         4qQdH7VYN+R+NZv5DMLS7MY0TgzhQyqAHHb9Ax1X63ufGG6fb0bLvFO16dHS/nxHcDin
         lXWrlweOio2tJHt8wJsqq15xji06AE0gvJCjr/jHUKo+bvK0NPeJc4Ip9hHYQ+LM/pc5
         j+EYolFdS0dWrX5O0xQqTdBKUlU4guBZpwRtAX0eoby8od0J3c5Zm3SEeMguApDs+EXn
         HZJA==
X-Forwarded-Encrypted: i=1; AKwUvBzwpYMuAgUaWprZ/rQlONnQJRp3ZiZEpyqn49fdX0EHbYefTID6IMQ53+TTbpOetQoSmImBzd17DCM5Zg==@lists.ozlabs.org
X-Gm-Message-State: AFuF++lQthpfdUYEk0YALlUk0poQL44gRpoekATRF0nO3LL1d6of8YNa
	AK8AdvSJhoSoNWZGEgXi0swJSup9OZe0U+0LMKFEim8jwnVs5c1pEmKcnqhv2pNs
X-Gm-Gg: AYBFou3qOrm1+DZnu8S4vGVQWo0m2f1C5zEO+LG81kVs71bIxxOrz/rzQb0+NpsIrJl
	6sF65sGyBKuQTvoDzRz0h0sJV2Atm+xbXQjqWKyCmBe7p16f/8OAPAPrLx+0gS7Ajg++ciTZAtm
	CtCjsbKYV0Ny5OXKyYZFUh6+6BTJ+fY3h2Lv7DSChe7fBkWk+NyfooDF9hmptAt2rPDXF1dh3NH
	8bvkh+jBgDmFiULKLQeOC+TioIrXifuER7qC7r64/2HuMfmxH6UW0B6FTcSgHrUUr/hyUUebM0D
	RBXxVu5KBmoJJckyk1t/7mxym9RGzd+n3FDnXuaq0+Chr7rmvJZkSh1D2wSsu+HHfWAH8pcI32k
	o3O/oIK8go+bTMTwKlW7FIP9YeQ5Rjh0N5wHF5jEr+6vOUVsHDTncJkTltWciFspgVXMvoET/9M
	kZBV/3+G/mLll7Aft8VcEwZwMKCVjBz4AK/4E0p44svM1vCbc+jEzws/4xwMmKQQwcQVyYx5wKF
	VoV
X-Received: by 2002:a05:6000:643:b0:487:955:e6c3 with SMTP id ffacd0b85a97d-48713a887ccmr17910040f8f.0.1789891163771;
        Sun, 20 Sep 2026 00:59:23 -0700 (PDT)
Received: from build-server.. ([62.96.37.222])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4872459c3e9sm11905622f8f.32.2026.09.20.00.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 00:59:23 -0700 (PDT)
From: mike.malyshev@gmail.com
To: Gao Xiang <xiang@kernel.org>
Cc: Mikhail Malyshev <mike.malyshev@gmail.com>,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH v2] erofs-utils: lib: follow symlinks on intermediate tar path components
Date: Sun, 20 Sep 2026 07:59:22 +0000
Message-ID: <20260920075922.3495867-1-mike.malyshev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <apBrWmPu9hMDcZHS@192.168.5.19>
References: <apBrWmPu9hMDcZHS@192.168.5.19>
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
symlinked directory, a common "usr-merge" layout in RHEL/UBI/Fedora based
OCI images.  For example a base layer contains:

    lib64 -> usr/lib64        (symlink)
    usr/lib64/                (directory)
    lib64/libc.so.6           (regular file, recorded under the symlink)

These paths are not hand-crafted.  The glibc RPM ships its dynamic loader
and core libraries under /lib64 (and /lib) rather than /usr/lib64, so on a
usr-merged base image (where /lib64 is a symlink to usr/lib64) the packaged
files are recorded under the symlinked component.  In the cdi-operator
layer above all 19 glibc objects (ld-linux-x86-64.so.2, libc.so.6, ...)
appear only under lib64/, with no usr/lib64/ counterpart, so correct
placement depends on resolving the symlink.

erofs_rebuild_get_dentry() walks the path component by component and, when
it reaches "lib64", finds an existing dentry that is a symlink rather than
a directory.  As there are still components left to resolve it bails out
with -ENOTDIR, which surfaces as a bogus ~2 TiB image and "Could not format
the device", making the whole layer unconvertible although the tar is fine.

Extraction tools resolve such a path by following the symlink to its
target: GNU tar (1.35) and busybox tar (1.37) both write the file to
usr/lib64/libc.so.6 and keep lib64 a symlink.  (bsdtar/libarchive instead
refuses with "Cannot extract through symlink" under its default
ARCHIVE_EXTRACT_SECURE_SYMLINKS anti-symlink-attack policy, i.e. an
explicit opt-out of normal resolution rather than different semantics.)
It is standard POSIX pathname resolution: a symlink in a non-final
component is followed.  containerd's walking differ, which applies these
same layers, does the same -- it resolves each entry's parent with
fs.RootPath ("evaluating and bounding any symlink to the root directory").

Do the same during tar rebuild: when an intermediate path component
resolves to a symlink, follow it to the target directory (relative targets
from the containing directory, absolute targets from the tree root),
chasing chained symlinks up to a bounded depth to avoid loops.  As the
rebuild operates on an in-memory tree with absolute links re-rooted,
following cannot escape the image.

Signed-off-by: Mikhail Malyshev <mike.malyshev@gmail.com>
---

Changes since v1 (https://lore.kernel.org/linux-erofs/20260725150920.1900298-1-mike.malyshev@gmail.com/):
- commit message: explain how these tars are generated (glibc RPM under
  usr-merge) and summarize tar behaviors (GNU/busybox follow, bsdtar's
  secure-symlinks refusal) plus the POSIX / containerd references, per review.
- drop the explanatory block comment; keep the code self-describing.
- resolve the symlink target into an on-stack buffer instead of strdup().
- follow chained symlinks with a loop rather than recursion.
- rebased onto current dev.

 lib/rebuild.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 2 deletions(-)

diff --git a/lib/rebuild.c b/lib/rebuild.c
index ebac1c5..3ac62c6 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -3,6 +3,7 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <string.h>
+#include <limits.h>
 #include <sys/stat.h>
 #include <config.h>
 #if defined(HAVE_SYS_SYSMACROS_H)
@@ -82,8 +83,54 @@ struct erofs_dentry *erofs_d_lookup(struct erofs_inode *dir, const char *name)
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
+static struct erofs_inode *erofs_rebuild_follow_link(struct erofs_inode *root,
+		struct erofs_inode *pwd, struct erofs_inode *link,
+		unsigned int depth)
+{
+	char target[PATH_MAX + 1];
+	bool dumb_wh, dumb_opq;
+
+	for (;;) {
+		struct erofs_dentry *d;
+		struct erofs_inode *base;
+
+		if (depth++ >= EROFS_REBUILD_SYMLINK_DEPTH)
+			return ERR_PTR(-ELOOP);
+		if (!link->i_link)
+			return ERR_PTR(-ENOENT);
+		if (strlen(link->i_link) > PATH_MAX)
+			return ERR_PTR(-ENAMETOOLONG);
+		strcpy(target, link->i_link);
+
+		/* absolute targets are resolved from the tree root */
+		base = target[0] == '/' ? root : pwd;
+		d = __erofs_rebuild_get_dentry(root, base, target, false,
+					       &dumb_wh, &dumb_opq, false, depth);
+		if (IS_ERR(d))
+			return ERR_CAST(d);
+		/* target referred to the root or base directory itself ("/", ".") */
+		if (!d)
+			return base;
+		if (d->type == EROFS_FT_DIR)
+			return d->inode;
+		if (d->type != EROFS_FT_SYMLINK)
+			return ERR_PTR(-ENOTDIR);
+		/* the target is itself a symlink: keep following the chain */
+		pwd = d->inode->i_parent;
+		link = d->inode;
+	}
+}
+
+static struct erofs_dentry *__erofs_rebuild_get_dentry(struct erofs_inode *root,
+		struct erofs_inode *pwd, char *path, bool aufs,
+		bool *whout, bool *opq, bool to_head, unsigned int depth)
 {
 	struct erofs_dentry *d = NULL;
 	char *s = path;
@@ -121,6 +168,16 @@ struct erofs_dentry *erofs_rebuild_get_dentry(struct erofs_inode *pwd,
 			}
 
 			d = erofs_d_lookup(pwd, s);
+			/* follow a symlinked intermediate component like a real fs */
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
@@ -152,6 +209,13 @@ struct erofs_dentry *erofs_rebuild_get_dentry(struct erofs_inode *pwd,
 	return d;
 }
 
+struct erofs_dentry *erofs_rebuild_get_dentry(struct erofs_inode *pwd,
+		char *path, bool aufs, bool *whout, bool *opq, bool to_head)
+{
+	return __erofs_rebuild_get_dentry(pwd, pwd, path, aufs, whout, opq,
+					  to_head, 0);
+}
+
 static int erofs_rebuild_load_chunk_index(struct erofs_sb_info *dst_sb,
 					  struct erofs_inode *inode)
 {
-- 
2.43.0


