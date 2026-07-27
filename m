Return-Path: <linux-erofs+bounces-4017-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 912EBC531D0
	for <linux-erofs@archiver.kernel.org>; Mon, 27 Jul 2026 10:49:04 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h7wLz0gBxz2yjR;
	Mon, 27 Jul 2026 20:48:59 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::429"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785149339;
	cv=none; b=oG9UKd6V7WKpxaQryBW6M6ZlTxrsvUoGy3J2sdbZpBePbGmdmyznRY136yHHnjpH+62EdvauyLvXxr0KvWAGT9wEt9SqDWuMMO4IDQoBO+I1yslbmg27ZCstNy3MQA6yOB6ZDe4BLWBBFsqPS3x563aszp4fmYfeT61V1YrzlIxpuKvJ5hzZ3MhX/4V7sQaT5NHCfTIzZIyUzyCO4lBXbgIWS6xSDgVPQlIT0odd4296JZCB51N6YzrHFmZcW2lOJw1CcaOif/Qy4SJK38LjJwrFOWOG25CZHWcomiqjXPYf7KVXzRxrJ6FHJpdAW195vfXkycXEBcO0E6LskZh/ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785149339; c=relaxed/relaxed;
	bh=gIBDnTFBEfRAPDF98N/BG5njMjm4UBvysiUnpdybqUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFRtJRTgyR+zgyl8LLpGlEiEqCLcEjlOPJIJXtxUIRa21aAjUy+0r/oy6ce4GkjYJqHJbhmGgXzlcC2hXy87FbuNonk0gVhpQH5+66h1MV0DGoMWQ7OyfmbQbH8itJxkaPEsqzvjXsQvXujLdcboGCURBcXaCUS7e9CLA8vwB8dDVqUwtVBs6eEQQ4iIIGimc9P9SiL/5FIijhVKqpbyhd7UuMx0qAKf7YR+STiRMlUpDD+f97nRA1zpmmpUoyh8XVR/jgRaUVab7u0LCPHj1NAqz4mRwjjV7nN5XAXKy9Qy7OYOPNTPEvTrv7nkFdEwFekZOfazbHsIKTVhjc7jTA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jPMB2nEL; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::429; helo=mail-wr1-x429.google.com; envelope-from=ericcurtin17@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jPMB2nEL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::429; helo=mail-wr1-x429.google.com; envelope-from=ericcurtin17@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h7wLx64kXz2yjp
	for <linux-erofs@lists.ozlabs.org>; Mon, 27 Jul 2026 20:48:57 +1000 (AEST)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-47f84023916so2568623f8f.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 27 Jul 2026 03:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785149335; x=1785754135; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gIBDnTFBEfRAPDF98N/BG5njMjm4UBvysiUnpdybqUo=;
        b=jPMB2nEL+W/+fc7d3NM/YaPqFJzI0kl+gBDhR0MKfKUsWdjbmY1jSw4n/ZfIwg1T4K
         WE/Kq7/auxiORe6qzUX/weuyaEBRg3W9z8SpKy6bZR6F5vJZsqP+gdOHbAb9DKZFIvH6
         HO3T7mNnbgml+suyB4MtQ3oBNDl7e64wTRrglrhLYNAUtctLdOIkJEuEymDFIlo0lmKQ
         hpWiX2z+btuqw8nhEi4vwx17MqKgCEK6tipfL3OfNbW1NvbqKOvje7RzoUSSyJpELw2Y
         GDjCDEzLlZrTaescJkDdd27qmx1DwTRT2AR+WjiehwqvPTkUf5+l76c73jcb4jCl/wGM
         ZqNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785149335; x=1785754135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gIBDnTFBEfRAPDF98N/BG5njMjm4UBvysiUnpdybqUo=;
        b=mWTyHySi9zXOl+gUCVXKpa3sKO+Ut3W0+VuSCa8Yn7gOQf3uw44IjTHQL5WrDc6Soj
         vuDMKK1y51h6oJmzXfp0h7n5OcwmMz3hTYoqrTCKTb/btoxmq4rWOabF1YQOOYzGy7z6
         0JOnXdkIYc/8PwA9dWQPp/I5suxaB/SJeyKaDO7oyd8ratTuK1hVfHt4sXlaYAH6r6Vj
         3GPNkxDNU9jtDpQIXDFrMsdF1X3dgI4xIfJOHJxJhc51xjDwH/4e61XBL4ua5AxVU3yt
         ZKAyW//wz8KnKED6Yc2UFW5FIJOoPTpegblNsAiDfe/+EGNzcOYd7ChNerOjPjbzSGwH
         hXXg==
X-Forwarded-Encrypted: i=1; AHgh+Rpk0sBtpK0KnastAzmJIx4z7sfBja7UDaj+jZYhoK3AMsFppPmeIcWkOkqCaOnebjokbfOjq/e5T073vw==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YyQQKjokA9i0W2QDGWsXxkYHfNMYUrqteUnTTlpN/A7+1PdO7pq
	iYen9OTT8gv9YFL8sPFgSV3ciMI2ElJfsmNdYokyOXwHlaRo4iOKkskf
X-Gm-Gg: AR+sD10w1KonAT4XW0cQLt2uTlqmW91gemtsvLgW7gWCVuMKQGhPUwe7zko4aRsCQl5
	BgADJay14VTMkTsG3F7+jOB2oDGRfH506a7G0ZggGXSDQbeKtK7HJFWZt0LZ9ZPFdzfkKUg5kGY
	zB9+z8wR/KL04agTPZc4i/D2R1dksuUSeWYqoEoBlPBfZBpAZWQtTzSWCOU+jsngK9OVNC4IgYN
	5b49/x9Ny17manO39ZN11MTaj9dYGShib1CBfbhy9InJhhyWE6u3YnBAAM4snHjyVGLEaiC+tbB
	rxzS0LDt3jw2fwoUXDugXCx/DuzkfLpQDgk0m3uXo+1Px3cbQqJFplhji4wHcy4nwO0LRf5hLYF
	6lUcI98bZ/hXUwmMEX+rmxkIdRoia0SvdHBAvqhv1hmrwsx3DgBX2temj1Q2BZogQ4Mjp4nsXvd
	et59veeg==
X-Received: by 2002:a05:6000:178e:b0:47f:9d0e:f94 with SMTP id ffacd0b85a97d-47f9fea4247mr10061977f8f.36.1785149334424;
        Mon, 27 Jul 2026 03:48:54 -0700 (PDT)
Received: from spark.Home ([2001:8a0:7280:4000:53fe:effd:424:fa7e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a659sm49056188f8f.6.2026.07.27.03.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 03:48:53 -0700 (PDT)
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
Subject: [RFC PATCH v2 4/4] init: support pinning the root image's fsverity digest
Date: Mon, 27 Jul 2026 11:48:45 +0100
Message-ID: <20260727104845.2607444-5-ericcurtin17@gmail.com>
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

When the root filesystem is mounted from an image file with rootimage=,
the carrier filesystem holding the image is typically writable and
therefore untrusted. Systems that seal their root images with fsverity
currently need an initramfs for the sole purpose of checking that the
image carries the expected fsverity digest before mounting it.

Add rootimageverity=<hash algorithm>:<hex digest>, which requires the
rootimage= file to have fsverity enabled with exactly this file digest
and fails the boot otherwise, using the same fsverity_get_digest()
interface that IMA and overlayfs already use for digest pinning.
Verification runs on the exact struct file that mount_root_image() then
hands to do_mount_root_file(): the fd-based mount from the preceding
patches means there is no separate path lookup afterwards that could
resolve to something else, and nothing between the check and the mount
that a userspace-less boot could race.

Combined with a trusted kernel command line (e.g. a signed unified
kernel image, or a TPM-measured bootloader configuration), this extends
the chain of trust to every byte of the root filesystem without any
userspace boot stage: the digest pins the image's Merkle tree, and
fsverity keeps verifying all data read from the image against it at
runtime, so post-boot tampering with the carrier filesystem is detected
as well. It is the file-backed counterpart of setting up a dm-verity
target for a partition-backed root via dm-mod.create=.

Two things this does not and cannot do:

 - Establish trust in the carrier filesystem itself. Reaching the image
   file at all means parsing carrier filesystem metadata (superblock,
   directory entries, extents) before any of this runs, the same way a
   dm-verity root still needs a trusted block layer underneath it -
   this is meant to sit on top of an already-appropriately-trusted
   carrier (e.g. one that is itself dm-verity/LUKS-backed, or a
   well-audited always-read-only filesystem), not conjure trust in an
   arbitrary writable one.

 - Cover erofs images that pull in extra devices via
   rootimageflags=device=device=..., since the pinned digest only ever
   applies to the primary image file. Refuse to boot in that
   combination rather than give a false sense of integrity.

Assisted-by: opencode:claude-fable-5
Signed-off-by: Eric Curtin <ericcurtin17@gmail.com>
---
 .../admin-guide/kernel-parameters.txt         | 22 +++++
 init/do_mounts.c                              | 91 ++++++++++++++++++-
 2 files changed, 108 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index a1cd5973e497..dcb5a78fba55 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6766,6 +6766,28 @@ Kernel parameters
 			(though still pinned alive by the image mount) after
 			boot.
 
+	rootimageverity= [KNL] Require the root image specified by
+			rootimage= to have fsverity enabled with this file
+			digest, given as <hash algorithm>:<hex digest>,
+			e.g. sha256:dd1b3fa9...  The boot is aborted if the
+			image carries no or a different fsverity digest, or
+			if rootimageflags= adds extra devices via device=
+			(their contents would not be covered by the digest).
+			Because fsverity keeps verifying data read from the
+			image against its Merkle tree at runtime, a trusted
+			(e.g. signed or TPM-measured) kernel command line
+			extends the chain of trust to the complete root
+			filesystem contents without an initramfs, provided
+			the carrier filesystem holding the image is itself
+			from a trusted source (rootimage= verifies the image
+			file; it does not and cannot retroactively establish
+			trust in the carrier filesystem code and metadata
+			that had to be parsed to reach that file in the first
+			place - the same way a dm-verity root still needs a
+			trusted block layer under it).  Requires
+			CONFIG_FS_VERITY and a carrier filesystem with
+			fsverity support.
+
 	rootwait	[KNL] Wait (indefinitely) for root device to show up.
 			Useful for devices that are detected asynchronously
 			(e.g. USB and MMC devices).
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 316421d8b65b..d4362fd758d8 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -24,6 +24,9 @@
 #include <linux/nfs_fs_sb.h>
 #include <linux/nfs_mount.h>
 #include <linux/raid/detect.h>
+#include <linux/fsverity.h>
+#include <linux/hex.h>
+#include <crypto/hash_info.h>
 #include <uapi/linux/mount.h>
 
 #include "do_mounts.h"
@@ -156,10 +159,18 @@ static int __init root_image_srcdir_setup(char *str)
 	return 1;
 }
 
+static char * __initdata root_image_verity;
+static int __init root_image_verity_setup(char *str)
+{
+	root_image_verity = str;
+	return 1;
+}
+
 __setup("rootimage=", root_image_setup);
 __setup("rootimagefstype=", root_image_fs_names_setup);
 __setup("rootimageflags=", root_image_data_setup);
 __setup("rootimagesrcdir=", root_image_srcdir_setup);
+__setup("rootimageverity=", root_image_verity_setup);
 
 /* This can return zero length strings. Caller should check */
 static int __init split_fs_names(char *page, size_t size, const char *names)
@@ -323,16 +334,73 @@ static int __init do_mount_root_file(struct file *file, const char *dir,
 	return ret;
 }
 
+#ifdef CONFIG_FS_VERITY
+/*
+ * Require the root image to carry the fsverity file digest given by
+ * rootimageverity=<hash algorithm>:<hex digest>.  @file must have been
+ * opened so that its fsverity information is loaded, and must be the
+ * exact file that do_mount_root_file() then mounts (see
+ * mount_root_image()): unlike checking a file and then separately
+ * mounting a path that is assumed, but not guaranteed, to name the same
+ * thing, there is no lookup left for anything to race or disagree with
+ * between this check and the mount.
+ *
+ * Any deviation fails the boot: with a trusted command line this pins
+ * the complete image contents, which fsverity keeps verifying against
+ * the image's Merkle tree as they are read.
+ */
+static void __init verify_root_image(struct file *file)
+{
+	u8 want[FS_VERITY_MAX_DIGEST_SIZE], got[FS_VERITY_MAX_DIGEST_SIZE];
+	enum hash_algo want_algo, got_algo;
+	int want_size, got_size, i;
+	char *hex;
+
+	hex = strchr(root_image_verity, ':');
+	if (!hex)
+		panic("VFS: rootimageverity= expects <algorithm>:<hex digest>");
+	*hex++ = '\0';
+	i = match_string(hash_algo_name, HASH_ALGO__LAST, root_image_verity);
+	if (i < 0)
+		panic("VFS: rootimageverity=: unknown hash algorithm \"%s\"",
+		      root_image_verity);
+	want_algo = i;
+	want_size = hash_digest_size[want_algo];
+	if (strlen(hex) != 2 * want_size || hex2bin(want, hex, want_size))
+		panic("VFS: rootimageverity=: expected %d-byte hex digest",
+		      want_size);
+
+	got_size = fsverity_get_digest(file_inode(file), got, NULL, &got_algo);
+	if (!got_size)
+		panic("VFS: root image does not have fsverity enabled");
+	if (got_algo != want_algo || got_size != want_size ||
+	    memcmp(want, got, want_size))
+		panic("VFS: root image fsverity digest mismatch: expected %s:%*phN, got %s:%*phN",
+		      hash_algo_name[want_algo], want_size, want,
+		      hash_algo_name[got_algo], got_size, got);
+
+	pr_info("VFS: verified root image fsverity digest %s:%*phN\n",
+		hash_algo_name[want_algo], want_size, want);
+}
+#else /* !CONFIG_FS_VERITY */
+static void __init verify_root_image(struct file *file)
+{
+	panic("VFS: rootimageverity= requires CONFIG_FS_VERITY");
+}
+#endif /* !CONFIG_FS_VERITY */
+
 /*
  * Mount the actual root filesystem from the image file rootimage= on the
  * filesystem that was just mounted from root= (the "carrier"), so that
  * image-based systems can boot without an initramfs.
  *
  * Called with the carrier mounted at /root and the cwd there.  The image
- * file is opened exactly once, and that same struct file is what actually
- * gets mounted via do_mount_root_file(), rather than a path that the
- * filesystem driver would then have to resolve again on its own with no
- * guarantee of landing on the same thing.
+ * file is opened exactly once; that same struct file is optionally
+ * fsverity-checked and is what actually gets mounted via
+ * do_mount_root_file(), so there is no window in which the checked file
+ * could be swapped for another before it is mounted, and no independent,
+ * second path lookup for a filesystem driver to disagree with about what
+ * "the image" refers to.
  *
  * On success the cwd is the image's root, ready for the pivot in
  * prepare_namespace().  rootimagesrcdir= is mandatory: the carrier is
@@ -355,6 +423,16 @@ static void __init mount_root_image(void)
 		panic("VFS: rootimage= requires rootimagesrcdir= (use rootimagesrcdir=none to detach the carrier instead, making it unreachable after boot)");
 	if (strcmp(root_image_srcdir, "none") && root_image_srcdir[0] != '/')
 		panic("VFS: rootimagesrcdir= must be an absolute path or \"none\"");
+	/*
+	 * A digest pinned via rootimageverity= only ever covers the
+	 * primary image file; an erofs image that pulls in extra devices
+	 * via rootimageflags=device=... would silently leave those
+	 * unverified, so refuse rather than give a false sense of
+	 * integrity.
+	 */
+	if (root_image_verity && root_image_mount_data &&
+	    strstr(root_image_mount_data, "device="))
+		panic("VFS: rootimageverity= does not cover extra devices added via rootimageflags=device=; refusing to boot");
 
 	path = kmalloc(PATH_MAX, GFP_KERNEL);
 	fs_names = kmalloc(PAGE_SIZE, GFP_KERNEL);
@@ -369,6 +447,9 @@ static void __init mount_root_image(void)
 		panic("VFS: unable to open root image %s: error %ld",
 		      root_image, PTR_ERR(file));
 
+	if (root_image_verity)
+		verify_root_image(file);
+
 	err = init_mkdir("/image", 0700);
 	if (err < 0 && err != -EEXIST)
 		panic("VFS: unable to create /image: error %d", err);
@@ -401,7 +482,7 @@ static void __init mount_root_image(void)
 	/*
 	 * do_mount_root_file() took its own reference to the file (see
 	 * vfs_parse_fs_param_file()); this reference was only needed to
-	 * open it in the first place.
+	 * open it and, if requested, check its fsverity digest.
 	 */
 	fput(file);
 
-- 
2.43.0


