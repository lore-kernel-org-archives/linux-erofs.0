Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F182F606DA1A
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CT+iOXhf
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1M55CrYz3dHL;
	Tue, 10 Nov 2026 20:19:45 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302385;
	cv=none; b=NSAviBLv96k0i8ib1xECut+8DB4Ax/hE1PpiESb0D5oRAolxlr+np9YTMNWAXRuRy9udNIEdldglqF1s/tmoY6tukrTXivTWlOLyTvZKfj3iPYrSHyGASvEj2/p5DH5BRcC0yOzNIVY3SvZCv+NjUdb21KdLNd7MWYY0GQdWKYC+7Hv1wL9a63QrgmVnxDY2o05ioAuc4x0wp3dFpEVRQfOuD6pmYFD76Cfa6qNCfW2lLCCuQC0Y8lqJtRjnuhl3mMu9eD4XJORu6kr3SlNxkUrzNv462t6NkaZEvpeYa5Aru68z+le87fCqjeC8ehanudC2f3rnMPk2aGfHXEM+QA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302385; c=relaxed/relaxed;
	bh=XL0wpOwuozhlRhYNz0JipJ6kxKX4QenBWX0X6ItK/K0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JsA9TN/4Wk2VKSFnyvodxRXV6qoIYcnkd7FxGdioKReraCAF6jxNajKRnK6OhtdO8gycCUcIK9KXFI0Zji3+zIht2uhibYaIoAbiQKckSCw++vB2Y+gV7kWlbDy0TqNvJZoRq+o6IdiS4FCP6kIamN3BTbwtip4OuaTn1fAuxenCXSU8EXdhdP/iYvtD3H1rA1tn5eXDJ4swOuGHg0yW5aIEc/s9uo9et5P+5yFQlC/Ge5yeVjtdl2CEXj7IVlSR6K9kPj6vyvNTI73lGMnyOq9vAIEs1MuZ//m84CS17CMuWu8J+dwdUx9vPDntkquFyu64XzUo9JNr5rnXkoWFrw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CT+iOXhf; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CT+iOXhf;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1M46H2hz3d8p;
	Tue, 10 Nov 2026 20:19:44 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BB224087D;
	Tue, 10 Nov 2026 09:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32A91F008A4;
	Tue, 10 Nov 2026 09:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302383;
	bh=XL0wpOwuozhlRhYNz0JipJ6kxKX4QenBWX0X6ItK/K0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CT+iOXhfdXS9EjWhCPxyMwbc6qpk2mfT/FYG65nH7AnMeSTgDu4gtnvPph9s+gyJQ
	 ZvCsMu20agRk/DN1s3jOLTDIaiE9C33mbBH7UBmpmq1UA5VoUIzICSYA9Tg4ndMgTH
	 NUHn4RW/Rt1Efr1DcrgvT2Czb0YSTQrx0YgABhREHnhLrge2ohMdRAEXc8ARjQ95GB
	 N91PcDylNuNGgoO+A1oWCOdoVMTmydTR6bkBvDN7xjUC6o/rf57lsPcqiLH9lVYbog
	 fqTRi61Xug5bUX+nw+zLWjcrBruwnR9lQKJTUUtPpS/C/b7PBRlfrij5xhG51EYia0
	 M4TkDbL2tSeqg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:49 +0100
Subject: [PATCH RFC 33/41] fs: add file_is_pseudo()
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-33-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
In-Reply-To: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1523; i=brauner@kernel.org;
 h=from:subject:message-id; bh=fWtwbOqSVGrzkIOODqoKjdbZebK5p812wmLNWmDsq10=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDr3MIVGoy6T1c42Fn1zN66UCnoG5vsrbwj8gcLt
 77hOtpb11HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRhFRGhmevWgXzbBfJf9i+
 0PPiiVlFPwKL+Fc/UFjp/vmC/tGfMw8y/FNqqr0U8TxATPOxjuYj+fU+8bu+/uDa1s7jnDCrjX2
 /FhMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a helper to check whether a file is a regular file on a pseudo
filesystem. Only regular files count. Device nodes on pseudo filesystems
such as devpts, binderfs or the block devices on bdevfs are what they
are.

Look at the inode that actually provides the data via d_real_inode().
overlayfs accepts sysfs, cgroup2, debugfs, tracefs, configfs and
securityfs as lower layers and reads of such an overlayfs file are
served by the file on the pseudo filesystem. Checking the overlayfs
inode would miss that.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/fs.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 99caef43ff3c..407ffb6342ec 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2553,6 +2553,18 @@ static inline const struct inode *file_user_inode(const struct file *f)
 	return file_inode(f);
 }
 
+/*
+ * Regular files on pseudo filesystems are kernel interfaces and must not be
+ * used as storage. Look through stacking filesystems at the inode that
+ * provides the data.
+ */
+static inline bool file_is_pseudo(const struct file *file)
+{
+	const struct inode *inode = d_real_inode(file->f_path.dentry);
+
+	return S_ISREG(inode->i_mode) && (inode->i_sb->s_iflags & SB_I_PSEUDO);
+}
+
 static inline struct file *file_clone_open(struct file *file)
 {
 	return dentry_open(&file->f_path, file->f_flags, file->f_cred);

-- 
2.53.0


