Return-Path: <linux-erofs+bounces-4014-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1286AC53219
	for <linux-erofs@archiver.kernel.org>; Mon, 27 Jul 2026 10:48:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h7wLt46bTz2yhY;
	Mon, 27 Jul 2026 20:48:54 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::42d"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785149334;
	cv=none; b=Hg1qswuXR3Jl0sYajU1W/Vs/NlZyOTGqxsPfzjzCPHVjgNPrKsXsGh/ml6pSWfI+JJaFDwogxfmOBweMzJ0CB2MWuTqRFvC6t98UbNoNHFg8akCPgZMrTWDlaIdoS0Vtesyye8Tj5iwfyu74fUgZn7miUrE2wCMC+9qV+r8bgac0YjADQvF36QzudOdAwHGLUln/JWP4+45hIRR1y+ZE5mJlva32tiJcxZarzMIqq7bEh2HkvegexektcgNlEG8iFYTxDxTZMLaMhorR8KGl3g3t5YrJhu5KtGKxeh0W/ki1YqnKxCDGAE3hbaQFN9ggCc2YUmh9KL4mLHxpQtUdTw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785149334; c=relaxed/relaxed;
	bh=b0xlGLz0lZUV4g4ovfTp8rb9hxeTp6x+hKCx+BsbNZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaG3FrSMHDlpIVlrnz87Srjd57Qx7cVf8Z9ggM/b6UXj5gcSdsR30UcMFpV5weP4/iiFJa3HtccYGXfUx5nkpKF+Neoge6WMi87TZ0VLcgRdN0qcabtgbg9EnyzirLs+p/dNtKGCHlz7PgIvC7mFndln0JI4lcYTaTB65bsfBzMsiNM4YdK5HHdybrW4LyHTwMKyJy0O4ViCLJf0Sc5CrO9JfqNrn9RMiZMeVcEamPj6tCtEYUVD9OB6vSlFkGlwIcmWob9B9hK5owiVPZiGHNYFBFwIqCMIGmAlrfTd1BrYhT3BdDPC5qr+83JleVDXDcQBEfVU+6IsM5R2Xixt9A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=tIvl/Ppg; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::42d; helo=mail-wr1-x42d.google.com; envelope-from=ericcurtin17@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=tIvl/Ppg;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::42d; helo=mail-wr1-x42d.google.com; envelope-from=ericcurtin17@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h7wLr54yMz2yj1
	for <linux-erofs@lists.ozlabs.org>; Mon, 27 Jul 2026 20:48:52 +1000 (AEST)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-47f7854678cso1427105f8f.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 27 Jul 2026 03:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785149329; x=1785754129; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b0xlGLz0lZUV4g4ovfTp8rb9hxeTp6x+hKCx+BsbNZA=;
        b=tIvl/Ppgi0WbKcFdlsULUJuwGGvt4kZf87bvhEm4nwUokrqIrULHDLqyGi6riNRDPe
         825VEfPlft8SdvsCgIhJsU9fBHHMTiALzPU/bkNLk+bA+9/gxeVqqxXkCg6qh3P2/Yef
         uS1b3pxRHGKJ+lBGDP7DW3/z516VW9ltXNrEARhot/9S3r121Y4TfTWgvfb/JvhK2eab
         DjnuFtslXZdqajupEgXlBtsD2yO4Doxr6SAqQKYdiJzaonH1HDBH598B9viF3sOs5dND
         L3ODav6Oaq8DyoueuWH9ctKcU6SIOgtBD8y52yngS6kEtgmjw7XNWUzXaKSN1Xbhze7j
         h+7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785149329; x=1785754129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b0xlGLz0lZUV4g4ovfTp8rb9hxeTp6x+hKCx+BsbNZA=;
        b=fbamXo9nKwdL0QxY+6iyku9tV6AuQix4hWf3GkLjirn86JSohT5SRjJRYnQHXXbvRT
         rbpB7wQyviY/ypuQq9jFN0aQk12AoZKixhUZ+vHY3VSspDgVIo5XBo4rkI2dizFhuEYA
         KL4iFXIOK9/axwkcLxT3AXeZSK8Ou1ZVTKqT9J2gyXfEUlXnZ9KxhqBDZ7khDyxh6SE3
         W7HSR+CPGZj0e6PbIXSiRFY4GkA60GRl5ETTbGisV9gv7UEqBcGChobNM6xwqA5TnE5C
         c/HHnsHDVgnvQTR5JPT9cJYblaHzZD/Blx5elPfr+bvDo8A+EkAu8K3kx1voOl3icy+K
         0OZg==
X-Forwarded-Encrypted: i=1; AHgh+RqtOZSah0ac062DbYr0cD6TGdYRsc4fg77d73unTBWSJUmsa+h6iGvbr9CEpJKoLZaj7ZJri4k2GTSvnw==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yz03XgzVsWA9MzgYM8LSMYjVOTF/rvnvNT2wDU/WaAFAonekafk
	V0eL44/00O5OiIBp5TthKBksrAweKp2Np4H4yRpgkRLasHo7ZKbifV7s
X-Gm-Gg: AR+sD12pkjeSsKISzxT3lPL3yNvskic1xlVzeNeULbLP8tKh4Rl7CSty8LaWLcIpfgb
	iolSCqQEl1qWNEgAk85naRIOiqpQIkme8QoGT5y5j8y0ZnL1YH00/pw7lGpoRKLlk7YlBUzFCaI
	cFOno2SPji5F0IhEHrVQHlE+vNsVi9nOBGGRuBs8VeszKC8NnoLAUKmR2NCHUL86q0NXZhpygMl
	2C6uAgOjPtU/Zj6VGDKsorNXsZYOPED4+DTqFqfKQS8EOfFSdjwVwagDPpd/Qv9rM4tx/VM1IGZ
	nJ/9UosXAXVeJQL/Uc1QU9+6gz2l9KI23QaBIJh3/pAf3zd+PDndK4C59oHUS2y1OAdWL4Cb2Fg
	2Y78RLNBqDcdkeYAgxwtK6L38c9IbzwBAMLOu2TXXfjBwiT0McsPkqyoVoWK10XC5TMmAGtz0fC
	UD0IXjKQ==
X-Received: by 2002:a05:6000:4029:b0:47f:84b2:2671 with SMTP id ffacd0b85a97d-47f9fc8d144mr10155626f8f.7.1785149329056;
        Mon, 27 Jul 2026 03:48:49 -0700 (PDT)
Received: from spark.Home ([2001:8a0:7280:4000:53fe:effd:424:fa7e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a659sm49056188f8f.6.2026.07.27.03.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 03:48:48 -0700 (PDT)
From: Eric Curtin <ericcurtin17@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y . Ts'o" <tytso@mit.edu>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	fsverity@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Curtin <ericcurtin17@gmail.com>
Subject: [RFC PATCH v2 1/4] fs: allow in-kernel mounters to hand filesystems an already-open source file
Date: Mon, 27 Jul 2026 11:48:42 +0100
Message-ID: <20260727104845.2607444-2-ericcurtin17@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260727-gepaukt-eislauf-waran-7c03f0e47609@brauner>
References: <20260727-gepaukt-eislauf-waran-7c03f0e47609@brauner>
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

do_new_mount() and its path_mount() wrapper only ever let a filesystem's
->get_tree() resolve its own source, either from a path string that the
kernel translates to fc->source via vfs_parse_fs_param_source(), or from
whatever the filesystem's own ->parse_param() does with it. There is no
way for a caller that already has an open, already-validated struct file
in hand to mount from *that exact file*: the best it can do is hand the
filesystem a path and hope nothing about the target changed by the time
the filesystem re-resolves it, which is not a guarantee the VFS can make.

Add struct fs_context::source_file alongside the existing ::source, set
via a new vfs_parse_fs_param_file() instead of the string parameter
path, and a new path_mount_file() / init_mount_file() pair mirroring
path_mount() / init_mount() that use it. This is deliberately not wired
up to the fsconfig(FSCONFIG_SET_FD) uAPI: it is for in-kernel callers
only, so no existing filesystem's ->parse_param() needs to change to
avoid misinterpreting it, and none is affected by this patch.

Filesystems that support being mounted from a plain file and want to
accept exactly the file a caller hands them, instead of independently
re-resolving fc->source (unset in this case), check fc->source_file
from their ->get_tree(). erofs is converted to do so in the next patch;
the immediate motivation is letting init/do_mounts.c mount an fsverity-
checked root image from the same struct file it just checked, instead
of a path that erofs would then look up again on its own.

Signed-off-by: Eric Curtin <ericcurtin17@gmail.com>
---
 Documentation/filesystems/mount_api.rst | 18 +++++
 fs/fs_context.c                         | 39 +++++++++-
 fs/init.c                               | 18 +++++
 fs/internal.h                           |  2 +
 fs/namespace.c                          | 96 ++++++++++++++++++++++++-
 include/linux/fs_context.h              |  4 ++
 include/linux/init_syscalls.h           |  2 +
 7 files changed, 175 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/mount_api.rst b/Documentation/filesystems/mount_api.rst
index e8b94357b4df..7b799f61c39d 100644
--- a/Documentation/filesystems/mount_api.rst
+++ b/Documentation/filesystems/mount_api.rst
@@ -138,6 +138,24 @@ The fs_context fields are as follows:
      This specifies the source.  It may be a block device (e.g. /dev/sda1) or
      something more exotic, such as the "host:/path" that NFS desires.
 
+   * ::
+
+       struct file *source_file
+
+     An alternative to ``source`` for in-kernel mounters only (there is no
+     userspace-visible way to set this): an already-open file to use as the
+     source, set by vfs_parse_fs_param_file() instead of parsing a path
+     string.  At most one of ``source`` and ``source_file`` is ever set.
+
+     Filesystems that support being mounted from a plain file (as opposed to
+     a block device) and want to let such an in-kernel caller hand them an
+     exact, already-validated file - rather than a path they would then have
+     to re-resolve themselves, with no way to guarantee the two refer to the
+     same thing - should check this field in their ``get_tree`` and use it
+     directly instead of falling back to opening ``source``.  See
+     fs/erofs/super.c:erofs_fc_get_tree() for reference, and
+     init/do_mounts.c:mount_root_image() for the in-kernel caller.
+
    * ::
 
        char *subtype
diff --git a/fs/fs_context.c b/fs/fs_context.c
index 23ad66cd94e1..ab853147b87b 100644
--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -85,7 +85,7 @@ int vfs_parse_fs_param_source(struct fs_context *fc, struct fs_parameter *param)
 	if (param->type != fs_value_is_string)
 		return invalf(fc, "Non-string source");
 
-	if (fc->source)
+	if (fc->source || fc->source_file)
 		return invalf(fc, "Multiple sources");
 
 	fc->source = param->string;
@@ -94,6 +94,36 @@ int vfs_parse_fs_param_source(struct fs_context *fc, struct fs_parameter *param)
 }
 EXPORT_SYMBOL(vfs_parse_fs_param_source);
 
+/**
+ * vfs_parse_fs_param_file - Set an already-open file as the mount source
+ * @fc: The filesystem context to modify
+ * @key: Parameter name; only "source" is currently supported
+ * @file: The file to use as the mount source
+ *
+ * In-kernel callers (see path_mount_file()) can use this to hand a
+ * filesystem an already-opened struct file as its source, instead of a
+ * path string for the filesystem to resolve on its own.  A reference is
+ * taken; it is released when @fc is freed.
+ *
+ * This deliberately has no fsconfig(FSCONFIG_SET_FD) counterpart: it is
+ * not reachable from userspace, so no filesystem needs to opt in to
+ * receive it and existing ->parse_param() implementations are unaffected.
+ * Filesystems that want to use the file directly (rather than silently
+ * ignoring it and falling back to re-resolving fc->source, which is not
+ * set in this case) check fc->source_file from their ->get_tree().
+ */
+int vfs_parse_fs_param_file(struct fs_context *fc, const char *key,
+			    struct file *file)
+{
+	if (strcmp(key, "source"))
+		return -EINVAL;
+	if (fc->source || fc->source_file)
+		return invalf(fc, "Multiple sources");
+	fc->source_file = get_file(file);
+	return 0;
+}
+EXPORT_SYMBOL(vfs_parse_fs_param_file);
+
 /**
  * vfs_parse_fs_param - Add a single parameter to a superblock config
  * @fc: The filesystem context to modify
@@ -376,6 +406,7 @@ struct fs_context *vfs_dup_fs_context(struct fs_context *src_fc)
 	fc->fs_private	= NULL;
 	fc->s_fs_info	= NULL;
 	fc->source	= NULL;
+	fc->source_file	= NULL;
 	fc->security	= NULL;
 	get_filesystem(fc->fs_type);
 	get_net(fc->net_ns);
@@ -504,6 +535,8 @@ void put_fs_context(struct fs_context *fc)
 	put_fc_log(fc);
 	put_filesystem(fc->fs_type);
 	kfree(fc->source);
+	if (fc->source_file)
+		fput(fc->source_file);
 	kfree(fc);
 }
 EXPORT_SYMBOL(put_fs_context);
@@ -543,6 +576,10 @@ void vfs_clean_context(struct fs_context *fc)
 	security_free_mnt_opts(&fc->security);
 	kfree(fc->source);
 	fc->source = NULL;
+	if (fc->source_file) {
+		fput(fc->source_file);
+		fc->source_file = NULL;
+	}
 	fc->exclusive = false;
 
 	fc->purpose = FS_CONTEXT_FOR_RECONFIGURE;
diff --git a/fs/init.c b/fs/init.c
index 33e312d74f58..d896d937e3e2 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -44,6 +44,24 @@ int __init init_mount(const char *dev_name, const char *dir_name,
 	return ret;
 }
 
+/*
+ * Like init_mount(), but the source is an already-open file rather than a
+ * path for the filesystem to resolve on its own; see path_mount_file().
+ */
+int __init init_mount_file(struct file *file, const char *dir_name,
+		const char *type_page, unsigned long flags, void *data_page)
+{
+	struct path path;
+	int ret;
+
+	ret = kern_path(dir_name, LOOKUP_FOLLOW, &path);
+	if (ret)
+		return ret;
+	ret = path_mount_file(file, &path, type_page, flags, data_page);
+	path_put(&path);
+	return ret;
+}
+
 int __init init_umount(const char *name, int flags)
 {
 	int lookup_flags = LOOKUP_MOUNTPOINT;
diff --git a/fs/internal.h b/fs/internal.h
index d77578d66d42..04fb75383024 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -91,6 +91,8 @@ extern bool may_mount(void);
 
 int path_mount(const char *dev_name, const struct path *path,
 		const char *type_page, unsigned long flags, void *data_page);
+int path_mount_file(struct file *file, const struct path *path,
+		const char *type_page, unsigned long flags, void *data_page);
 int path_umount(const struct path *path, int flags);
 int path_pivot_root(struct path *new, struct path *old);
 
diff --git a/fs/namespace.c b/fs/namespace.c
index fe919abd2f01..31bf263d1efc 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3783,10 +3783,14 @@ static int do_new_mount_fc(struct fs_context *fc, const struct path *mountpoint,
 /*
  * create a new mount for userspace and request it to be added into the
  * namespace's tree
+ *
+ * @name is the source given as a path string, as usual; @file is an
+ * alternative, already-open source (see path_mount_file()).  At most one
+ * of the two is ever set by callers.
  */
-static int do_new_mount(const struct path *path, const char *fstype,
-			int sb_flags, int mnt_flags,
-			const char *name, void *data)
+static int do_new_mount_2(const struct path *path, const char *fstype,
+			  int sb_flags, int mnt_flags,
+			  const char *name, struct file *file, void *data)
 {
 	struct file_system_type *type;
 	struct fs_context *fc;
@@ -3826,6 +3830,8 @@ static int do_new_mount(const struct path *path, const char *fstype,
 		err = vfs_parse_fs_string(fc, "subtype", subtype);
 	if (!err && name)
 		err = vfs_parse_fs_string(fc, "source", name);
+	if (!err && file)
+		err = vfs_parse_fs_param_file(fc, "source", file);
 	if (!err)
 		err = parse_monolithic_mount_data(fc, data);
 	if (!err && !mount_capable(fc))
@@ -3837,6 +3843,14 @@ static int do_new_mount(const struct path *path, const char *fstype,
 	return err;
 }
 
+static int do_new_mount(const struct path *path, const char *fstype,
+			int sb_flags, int mnt_flags,
+			const char *name, void *data)
+{
+	return do_new_mount_2(path, fstype, sb_flags, mnt_flags, name, NULL,
+			      data);
+}
+
 static void lock_mount_exact(const struct path *path,
 			     struct pinned_mountpoint *mp, bool copy_mount,
 			     unsigned int copy_flags)
@@ -4155,6 +4169,82 @@ int path_mount(const char *dev_name, const struct path *path,
 			    data_page);
 }
 
+/**
+ * path_mount_file - Mount a new filesystem sourced from an already-open file
+ * @file: The already-open source file
+ * @path: The mountpoint
+ * @type_page: Filesystem type
+ * @flags: MS_* flags
+ * @data_page: Filesystem-specific mount data
+ *
+ * Like path_mount(), except the source is an already-open struct file
+ * rather than a path for the filesystem to look up on its own.  This is
+ * only usable for a plain new mount: bind/move/remount/propagation-change
+ * requests, which path_mount() distinguishes by inspecting @dev_name, make
+ * no sense for an anonymous open file and are rejected.
+ *
+ * @file is not consumed; the fs_context takes its own reference (see
+ * vfs_parse_fs_param_file()).
+ *
+ * This has no io_uring/syscall-visible counterpart: it exists so that
+ * in-kernel mounters (see init_mount_file()) can hand a filesystem the
+ * exact file they resolved and validated, instead of a path that the
+ * filesystem then re-resolves independently, which is the only way to
+ * guarantee the two refer to the same thing.
+ */
+int path_mount_file(struct file *file, const struct path *path,
+		    const char *type_page, unsigned long flags,
+		    void *data_page)
+{
+	unsigned int mnt_flags = 0, sb_flags;
+
+	if ((flags & MS_MGC_MSK) == MS_MGC_VAL)
+		flags &= ~MS_MGC_MSK;
+
+	if (data_page)
+		((char *)data_page)[PAGE_SIZE - 1] = 0;
+
+	if (flags & (MS_NOUSER | MS_REMOUNT | MS_BIND | MS_MOVE |
+		     MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
+		return -EINVAL;
+
+	if (!may_mount())
+		return -EPERM;
+	if (flags & SB_MANDLOCK)
+		warn_mandlock();
+
+	if (!(flags & MS_NOATIME))
+		mnt_flags |= MNT_RELATIME;
+	if (flags & MS_NOSUID)
+		mnt_flags |= MNT_NOSUID;
+	if (flags & MS_NODEV)
+		mnt_flags |= MNT_NODEV;
+	if (flags & MS_NOEXEC)
+		mnt_flags |= MNT_NOEXEC;
+	if (flags & MS_NOATIME)
+		mnt_flags |= MNT_NOATIME;
+	if (flags & MS_NODIRATIME)
+		mnt_flags |= MNT_NODIRATIME;
+	if (flags & MS_STRICTATIME)
+		mnt_flags &= ~(MNT_RELATIME | MNT_NOATIME);
+	if (flags & MS_RDONLY)
+		mnt_flags |= MNT_READONLY;
+	if (flags & MS_NOSYMFOLLOW)
+		mnt_flags |= MNT_NOSYMFOLLOW;
+
+	sb_flags = flags & (SB_RDONLY |
+			    SB_SYNCHRONOUS |
+			    SB_MANDLOCK |
+			    SB_DIRSYNC |
+			    SB_SILENT |
+			    SB_POSIXACL |
+			    SB_LAZYTIME |
+			    SB_I_VERSION);
+
+	return do_new_mount_2(path, type_page, sb_flags, mnt_flags, NULL,
+			     file, data_page);
+}
+
 int do_mount(const char *dev_name, const char __user *dir_name,
 		const char *type_page, unsigned long flags, void *data_page)
 {
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index 0d6c8a6d7be2..b35d7583f0bd 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -16,6 +16,7 @@
 
 struct cred;
 struct dentry;
+struct file;
 struct file_operations;
 struct file_system_type;
 struct mnt_namespace;
@@ -99,6 +100,7 @@ struct fs_context {
 	const struct cred	*cred;		/* The mounter's credentials */
 	struct p_log		log;		/* Logging buffer */
 	const char		*source;	/* The source name (eg. dev path) */
+	struct file		*source_file;	/* Already-open source file, in-kernel only */
 	void			*security;	/* LSM options */
 	void			*s_fs_info;	/* Proposed s_fs_info */
 	unsigned int		sb_flags;	/* Proposed superblock flags (SB_*) */
@@ -148,6 +150,8 @@ extern int vfs_get_tree(struct fs_context *fc);
 extern void put_fs_context(struct fs_context *fc);
 extern int vfs_parse_fs_param_source(struct fs_context *fc,
 				     struct fs_parameter *param);
+int vfs_parse_fs_param_file(struct fs_context *fc, const char *key,
+			    struct file *file);
 extern void fc_drop_locked(struct fs_context *fc);
 
 extern int get_tree_nodev(struct fs_context *fc,
diff --git a/include/linux/init_syscalls.h b/include/linux/init_syscalls.h
index 28776ee28d8e..ac937cdb9d46 100644
--- a/include/linux/init_syscalls.h
+++ b/include/linux/init_syscalls.h
@@ -2,6 +2,8 @@
 
 int __init init_mount(const char *dev_name, const char *dir_name,
 		const char *type_page, unsigned long flags, void *data_page);
+int __init init_mount_file(struct file *file, const char *dir_name,
+		const char *type_page, unsigned long flags, void *data_page);
 int __init init_umount(const char *name, int flags);
 int __init init_chdir(const char *filename);
 int __init init_chroot(const char *filename);
-- 
2.43.0


