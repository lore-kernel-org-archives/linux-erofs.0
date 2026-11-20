Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5025F606A334
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Nov 2026 10:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=cBM50gtk
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jWBpN5k4cz2yQl;
	Fri, 20 Nov 2026 21:46:20 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::435"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795171580;
	cv=none; b=LzPeehv9SOMvb5MQOkA3ODr9f756jIxq1OOUho94OdfabywwhqGV0OE41kx0K4ZFapZfn6KONk/yUdkKDYaxJ9GjdvvCMtBvVUtvx0VxPJJc5Y6lgTInveUnQlVGHeq6ko7V1mOQKZM/yah22mGYTjdR+d5S7TJW49mNjPngeNwSIYNtVCfbp/NK4rm6nYVzHNBwSYSSzuV56AgPGhp4wol2CUQt/XBX2tnHagDPd+9JBVbOtRxD6X36tSyOrhw+8CoC11QJRsg2IlEs1RkpPw5vvOqbwPjY05ATqbAUj5/pYEbYegnocBqYKX/Caf9apl6nxr+SfzTolWKIQ8RjGg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795171580; c=relaxed/relaxed;
	bh=d6BHZqfNwah7wJXoIQIIAGcy3zh13fL1Hr5sWYwjGcE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LJL/c4tf3oSwXwZAhwLkcGJ6xPjXzRaKdTT0FHAmoAlUkVSSUMz1S2En0aHVLr5RGpEBqtQmiZESN8w1rKjm8iTRk1FA13njHA9XmnEF/ZCTm67Xr9tnYXj0y0tHr61NCJlUfSzesy/JWvtX3F2jIF3I9djbEdLm3W9AMLDrGYbRpTw1QiG+MaEIGyO2siHxyoD1gPHMfZQ0436LkDI+hywYo+iSly0N61IxfXXBvOo2GzbArLA/LBkgLPoFSbOkrhxBVMFZmc4U0inbr8LxfWjwaitSXbT72LpEtk1/3r/9/hlBdFFlT31HkUzQ2/9DN75dkdJPH2MdcomNWHAykA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=cBM50gtk; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::435; helo=mail-wr1-x435.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=cBM50gtk;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::435; helo=mail-wr1-x435.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jWBpM0R5Lz2yST
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Nov 2026 21:46:18 +1100 (AEDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-49a92144733so344843f8f.0
        for <linux-erofs@lists.ozlabs.org>; Fri, 20 Nov 2026 02:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795171570; x=1795776370; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=d6BHZqfNwah7wJXoIQIIAGcy3zh13fL1Hr5sWYwjGcE=;
        b=cBM50gtkP9fr9aKCqPHbNGwoNrRluXl5R6xC187K1XQDsOYFlaooOaUtFAAultsEry
         93wG7zWpVUUzNkIE1HR3iyTQ5OQO2qbneiPnRt0Q39h36yGqPR55tD+1IvcIljiN8sjc
         k8MPgQZ8fCVC514Z8MxS1T5VwpK2j7OB1KF1nMBc7I02FfS2KF35fti4dc1BC15HQj1a
         IR+magXCXa2756TfNkwgg9J7XGjRgHwPi5JuduQe616a/qAS/LegsSDODrZfo8XGQczR
         a057RV3tWJaXBwL3aiwjVcs7OIqSlU5O28R97JnjBXBZ8wafOQPBj7EQO86DPMXHTVjE
         5LRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795171570; x=1795776370;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d6BHZqfNwah7wJXoIQIIAGcy3zh13fL1Hr5sWYwjGcE=;
        b=mKR3M171ZooTnKcV/sK4LEgXPzEb/MCJ5Y8x1WOwOA47vDJ5qY6KaXD1IobcQLawnm
         uUGRKkf4syyQoqGt9vJzO/tBgwlavvAF8K3gZgdnHu4G9hJ7vfzxqAVCEHsiVKFR/PbK
         s2HPTcLudQCxACcAuFy85jZBiu0dwp4GlSe8SK1sTsZ45rmwbUgUFVq1G1KfjeL6rvJG
         esMHbvmkKi93+uv8es+7niMBLg60lc/RJao9BsyCGWHdl+Xjq0w5zQVGgM94Upsc4QFr
         FU5FGU4pv7Pee4gE+bJAF0qdD4MyhYjtQtvQCZRi8JoVaFzXKMJJaTGUObUvRCS01FHM
         Jz1Q==
X-Gm-Message-State: APuU4Z9BpX+y54xxLlPLXGYW8MBASJbXHtob6eHMV+BK8kMWDwA8BNbW
	LxmrlhGAH1zsYoXcP/TDK1w0kJdgv3VjG/x9ltihPx0JCH8gA5rpkHC0e1FDDccMqtf3e/hrtfO
	eAcnNz10=
X-Gm-Gg: AZFdTZdpVuMQ7o2UIDzQQlkUKUJ253GsulHE67WiO0ytJaqCZ/Tt9K936eJ0MBcKAk/
	8LkSjUvGz2l4ZOxHx99KIGfOkO33y4WKWuljCqKPagVbmg5qUDDNebiR4Elr/X0InUuEhxAld1Y
	WWJzMZYxPUkt++Xl5CLMI3swgqXoJxhKeMhdY3FPK6N3Ibd1DZ6vaLPX6DRkNHHyZkIpgu2632G
	Lt0Ngz07r+8sa0OKuJKKxwdLo+X04h0BlzZW68y7XI+dq0x5GV2ea8g0wdX4dyf5szVvMn+7or9
	9A+EbESCE63MFiV9GMObi5ZZAx/swdPgJk0y2w7cTHhyUeBL/USm8F+Lv9JecyTor0v3ECKUny8
	aBIubDLvpBsM/b68qvRI/euBIt5VqaCnu5sL47L2tnbFJ4PDAScxjTUr2vIxGae/Yn6nVyI/JOT
	c6MOkqgLSvKDJQhwj88v9sNRiiMfHiMd5nJbTDhTboHySP416mUqQG3Vh66E5jgj+sDHwFgwZq/
	GPzju6UWVAmwId7c0TmqCKgPrxSTtRfqxKiYh5ObLUBz1ZgSj7wa2rCmed6qDDWIxCNTWXuFj1w
	1yZQDfDWtEZJpEqKngWcP5ZB/lHpHMunsoNbjGnQg8MStfUrwfYsR+05ag0YWA==
X-Received: by 2002:a5d:5888:0:b0:490:a481:7ac8 with SMTP id ffacd0b85a97d-4abb532ea79mr4747006f8f.29.1795171570545;
        Fri, 20 Nov 2026 02:46:10 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:5888:55e8:d901:aec])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b110d56sm4795522f8f.40.2026.11.20.02.46.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 02:46:10 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v2 1/5] erofs-utils: lib: fix dentries returned for terminal path components
Date: Fri, 20 Nov 2026 11:46:02 +0100
Message-ID: <20261120104606.25056-1-xiang.gao@docker.com>
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

Paths ending in .. or a followed symlink can return a stale dentry,
causing directory metadata updates to affect the wrong inode or fail
with ENOTDIR.

Return the resolved directory's dentry, reusing the cached parent for
.. when possible.

Fixes: 95d315fd7958 ("erofs-utils: introduce tarerofs")
Fixes: fd041ac99272 ("erofs-utils: lib: follow symlinks on intermediate tar path components")
Assisted-by: ChatGPT:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
v2:
 - fix several LLM issue reports.

 lib/rebuild.c | 45 +++++++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/lib/rebuild.c b/lib/rebuild.c
index 2fa8feb..a5dd4f3 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -86,11 +86,23 @@ struct erofs_dentry *erofs_d_lookup(struct erofs_inode *dir, const char *name)
 /* Bound symlink chains during path resolution, like the kernel's MAXSYMLINKS. */
 #define EROFS_REBUILD_SYMLINK_DEPTH	40
 
+static struct erofs_dentry *erofs_d_find_any_alias(struct erofs_inode *inode)
+{
+	struct erofs_dentry *d;
+
+	if (IS_ROOT(inode))
+		return NULL;
+	list_for_each_entry(d, &erofs_parent_inode(inode)->i_subdirs, d_child)
+		if (d->inode == inode)
+			return d;
+	return ERR_PTR(-ENOENT);
+}
+
 static struct erofs_dentry *__erofs_rebuild_get_dentry(struct erofs_inode *root,
 		struct erofs_inode *pwd, char *path, bool aufs,
 		bool *whout, bool *opq, bool to_head, unsigned int depth);
 
-static struct erofs_inode *erofs_rebuild_follow_link(struct erofs_inode *root,
+static struct erofs_dentry *erofs_rebuild_follow_link(struct erofs_inode *root,
 		struct erofs_inode *pwd, struct erofs_inode *link,
 		unsigned int depth)
 {
@@ -113,13 +125,8 @@ static struct erofs_inode *erofs_rebuild_follow_link(struct erofs_inode *root,
 		base = target[0] == '/' ? root : pwd;
 		d = __erofs_rebuild_get_dentry(root, base, target, false,
 					       &dumb_wh, &dumb_opq, false, depth);
-		if (IS_ERR(d))
-			return ERR_CAST(d);
-		/* target referred to the root or base directory itself ("/", ".") */
-		if (!d)
-			return base;
-		if (d->type == EROFS_FT_DIR)
-			return d->inode;
+		if (IS_ERR(d) || !d || d->type == EROFS_FT_DIR)
+			return d;
 		if (d->type != EROFS_FT_SYMLINK)
 			return ERR_PTR(-ENOTDIR);
 		/* the target is itself a symlink: keep following the chain */
@@ -132,9 +139,13 @@ static struct erofs_dentry *__erofs_rebuild_get_dentry(struct erofs_inode *root,
 		struct erofs_inode *pwd, char *path, bool aufs,
 		bool *whout, bool *opq, bool to_head, unsigned int depth)
 {
-	struct erofs_dentry *d = NULL;
+	struct erofs_dentry *d, *parent = NULL;
 	char *s = path;
+	bool parent_cached = false;
 
+	d = (pwd == root ? NULL : erofs_d_find_any_alias(pwd));
+	if (IS_ERR(d))
+		return d;
 	*whout = false;
 	*opq = false;
 
@@ -154,6 +165,11 @@ static struct erofs_dentry *__erofs_rebuild_get_dentry(struct erofs_inode *root,
 		if (__erofs_unlikely(is_dot_dotdot(s))) {
 			if (s[1] == '.') {
 				pwd = pwd->i_parent;
+				d = parent_cached ? parent :
+					(pwd == root ? NULL : erofs_d_find_any_alias(pwd));
+				if (IS_ERR(d))
+					return d;
+				parent_cached = false;
 			}
 		} else {
 			if (aufs && !slash) {
@@ -167,13 +183,17 @@ static struct erofs_dentry *__erofs_rebuild_get_dentry(struct erofs_inode *root,
 				}
 			}
 
+			parent = d;
 			d = erofs_d_lookup(pwd, s);
 			/* follow a symlinked intermediate component like a real fs */
 			if (d && slash && d->type == EROFS_FT_SYMLINK) {
-				pwd = erofs_rebuild_follow_link(root, pwd,
+				d = erofs_rebuild_follow_link(root, pwd,
 							d->inode, depth);
-				if (IS_ERR(pwd))
-					return ERR_CAST(pwd);
+				if (IS_ERR(d))
+					return d;
+				pwd = d ? d->inode : root;
+				/* The target may have a different parent. */
+				parent_cached = false;
 				*slash = '/';
 				s = slash + 1;
 				continue;
@@ -198,6 +218,7 @@ static struct erofs_dentry *__erofs_rebuild_get_dentry(struct erofs_inode *root,
 				d->type = EROFS_FT_UNKNOWN;
 				d->inode = pwd;
 			}
+			parent_cached = true;
 			pwd = d->inode;
 		}
 
-- 
2.54.0 (Apple Git-157)


