Return-Path: <linux-erofs+bounces-3937-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90BECC4451C
	for <linux-erofs@archiver.kernel.org>; Sat, 18 Jul 2026 19:16:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h2c2F01jDz2xjN;
	Sun, 19 Jul 2026 05:16:05 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::329"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784402164;
	cv=none; b=mVN107MgG/tH6v+5R2x8BqYuOhKs09c8ksAfeWeS9Zc0xHFUgyDQjA6I4lUPIwDhSWNoGh9+v85n7McxRqDISZdFfMK+37s+/J0zNIbb2a28JU4gi5nocZiHcKnyTeG8lmnBrUwMyffdFOgd1CK7Hj+JKHuNxa7GKiaS9KEhOjVAmKmNNFnpvSo/Sha6RtDjBmP6D/l7CyJoICaThblY/35vo9w6E08yQYrtfBHuq6JMMcVMyHw6R+tIRp9ZBrLtNRNozrVra3Yd1vXTv8Mb6sQ1daiUChdQHAx1wBBDK39zSGIn0wkWaC6aIJBl3RAAQqTcwYBMZH0FOLW0BoNLrw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784402164; c=relaxed/relaxed;
	bh=n/RuzzR56AKowWPeBaHkPa2me5UyA+I6b2NoNXGG3tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7gCCnSEDQ+sa1mXHtQXC+Ov+jUkQWxtfpzHhFmriBc2AIjOIocezQqS4nqNpz5uaphAd5FWdXhNyMaWMR7qAIDeWPz+FcTutiYE9LQlBbMCNT5eJR4FjYlVQum2S+7I34LNocKTb4dEGD+tcSFLM1HcAf7u+mnnWZW/IG+hnwb98dBEgB9ZnFCYeZ7sia8Jnlx1wia48o1H/SeDUhlS/lUDGzHUnx7mcQm4se8GR/5Ujvvs7FoAusP+D8V2q1MB1MnJ4ZDFk3fgBTg9XvPRz3zsUQviZF9h9fdU2MTJlptcDUGd8p8YcRbfrsrDUJzlgVhkMwbHkIPe+pbEq8KO3g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=auxfbjeV; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::329; helo=mail-wm1-x329.google.com; envelope-from=ericcurtin17@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=auxfbjeV;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::329; helo=mail-wm1-x329.google.com; envelope-from=ericcurtin17@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h2c291TgKz2xl6
	for <linux-erofs@lists.ozlabs.org>; Sun, 19 Jul 2026 05:16:00 +1000 (AEST)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-493f6de72faso17910995e9.0
        for <linux-erofs@lists.ozlabs.org>; Sat, 18 Jul 2026 12:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784402158; x=1785006958; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n/RuzzR56AKowWPeBaHkPa2me5UyA+I6b2NoNXGG3tc=;
        b=auxfbjeVRQ4NgUILH5cWwe7rZkLPuqHh5QBvzi9kCAYKDvT65u+LCP/BSd9B3kdur2
         sNA4x94NBi1IvhYpDzezK5wD2KeiR+LSWkdjQRHbFdoOnm0M4eH5O1qk+b4i3Pz+E33L
         Jw++8fqEiNV2BWv1sjS/nvi/RS4/02TM1D95tbbiryMqy5dlDema5oyFT13ToOjzGfI0
         gxfR5Y/Q84mRsl6oHBYgGksgyXC/Rf1MYHuE0UO5jz//DsLGQKvWS9lGTGKJK4JqIO80
         kv+HhPF5GV6/bnP/0+poobSB0wy0HsaeY+VJkaZkgRgjqaIbs9+BBEAKvClI3raBEIph
         lOGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784402158; x=1785006958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n/RuzzR56AKowWPeBaHkPa2me5UyA+I6b2NoNXGG3tc=;
        b=qejhPBdyZ0a12oz68JcOa1UKFooAkZtDcavhq151GtHTZ9LvWzozoJXvieMn2zVoCf
         lPpAHNu5zjwPHWd9zJcD+RKOr8waxPWj9wut2aY2ubJVKHSY6uNFIWs1IAVuXwSFBqbk
         44D5QkYzjlaURFRurxRElgadFsx+4jne0EkUJPiIeooDK4AhJogONNS9cbpnP68BR2f1
         QstXOn7qYAQCPoOzaiOzbPjeYQV4brv6aL3mDJywHMBEDfK2m545mGUQbX6bq3dTCzga
         EYuGRW4uGRLf9DPN1yqT7xLD8IKo3eCISL3SMyJOKXROWYJWT3KSce8e3hbqLHgy4E2y
         cRZQ==
X-Forwarded-Encrypted: i=1; AHgh+RohB2v2sidyelMAeScDW/LGJk/SVFI0hKAsYoz2dZVnDfdTIuWrZ8XF/kfDZHx/v3Oi6IpoZjRlPMS8SQ==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YyKukO39nWZAaWmQRdHfC7KSnU/ijKAEluWRwxxVeMa0l/HuHZH
	Vyp2A8IA1/h5m1T6tQ+XMaPkZd9DF2R62rFnDUIcKpBP0eOhwaJnkBVn
X-Gm-Gg: AfdE7cn2R64c31y4hpLw6W1quRSUfOjHVEywqkoxnB2JayZytsVZQriRFup27zsV3JQ
	6He/hpO3cyDSfHVaeBWBODRHOsCuE04cCp9jDyzyNYZSnetlrpYQbuKd5Pqp/BxiV4k0y4ymmrz
	abGegp8k5tpdgW/BJ38eKIc2uE7YRypVaBJAJQJa1daTb8pys+KqigFGxO8LsjJMTUEeytkRCKW
	f9br+NWMKCd5ivIzr2gmGit0ZGNyNG5og0MbIlfrz86aZKO+0omdX73KKN8ZGTRGInx06b3Hg9W
	AW1imUHKFQFiuTCYWjyw0+5UoQTk9pu9ZS8q0DbbVfv+EoXOOYVo6YASF1uT5qGVfaERWcjbbrm
	sOBj5LJZTTFezcZekv0pk+9qICE+2sA25hRN2a1owV00iWAXrxEmXNTdF152hbyULeqMvprdlCF
	yS2k7ZsQ==
X-Received: by 2002:a05:600c:4e8b:b0:495:501a:fcf8 with SMTP id 5b1f17b1804b1-495501afdc8mr41543145e9.9.1784402157300;
        Sat, 18 Jul 2026 12:15:57 -0700 (PDT)
Received: from spark.Home ([2001:8a0:7280:4000:c2b:a5ab:a31c:e0a5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2e8529sm140037005e9.11.2026.07.18.12.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 12:15:56 -0700 (PDT)
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
Subject: [RFC PATCH 2/2] init: support pinning the root image's fsverity digest
Date: Sat, 18 Jul 2026 20:15:51 +0100
Message-ID: <20260718191551.1703670-3-ericcurtin17@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260718191551.1703670-1-ericcurtin17@gmail.com>
References: <20260718191551.1703670-1-ericcurtin17@gmail.com>
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
therefore untrusted.  Systems that seal their root images with fsverity
currently need an initramfs for the sole purpose of checking that the
image carries the expected fsverity digest before mounting it.

Add rootimageverity=<hash algorithm>:<hex digest>, which requires the
rootimage= file to have fsverity enabled with exactly this file digest
and fails the boot otherwise, using the same fsverity_get_digest()
interface that IMA and overlayfs already use for digest pinning.

Combined with a trusted kernel command line (e.g. a signed unified
kernel image, or a TPM-measured bootloader configuration), this extends
the chain of trust to every byte of the root filesystem without any
userspace boot stage: the digest pins the image's Merkle tree, and
fsverity keeps verifying all data read from the image against it at
runtime, so post-boot tampering with the carrier filesystem is detected
as well.  It is the file-backed counterpart of setting up a dm-verity
target for a partition-backed root via dm-mod.create=.

Verification is done on the file the kernel is about to mount: it is
opened before mounting (which also loads the fsverity information) and
kept open across the mount, and no userspace exists yet that could race
a replacement in between.

Assisted-by: opencode:claude-fable-5
Signed-off-by: Eric Curtin <ericcurtin17@gmail.com>
---
 .../admin-guide/kernel-parameters.txt         | 13 ++++
 init/do_mounts.c                              | 63 +++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 5dbd56098..105ebb171 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6728,6 +6728,19 @@ Kernel parameters
 			root=) is moved to, instead of detaching it.  Used
 			together with rootimage=.
 
+	rootimageverity= [KNL] Require the root image specified by
+			rootimage= to have fsverity enabled with this file
+			digest, given as <hash algorithm>:<hex digest>,
+			e.g. sha256:dd1b3fa9...  The boot is aborted if the
+			image carries no or a different fsverity digest.
+			Because fsverity keeps verifying data read from the
+			image against its Merkle tree at runtime, a trusted
+			(e.g. signed or TPM-measured) kernel command line
+			extends the chain of trust to the complete root
+			filesystem contents without an initramfs.  Requires
+			CONFIG_FS_VERITY and a carrier filesystem with
+			fsverity support.
+
 	rootwait	[KNL] Wait (indefinitely) for root device to show up.
 			Useful for devices that are detected asynchronously
 			(e.g. USB and MMC devices).
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 1b96ef30b..4eb792b27 100644
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
@@ -155,10 +158,18 @@ static int __init root_image_srcdir_setup(char *str)
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
 static int __init split_fs_names(char *page, size_t size, char *names)
@@ -442,6 +453,55 @@ void __init mount_root(char *root_device_name)
 	}
 }
 
+#ifdef CONFIG_FS_VERITY
+/*
+ * Require the root image to carry the fsverity file digest given by
+ * rootimageverity=<hash algorithm>:<hex digest>.  @file must have been
+ * opened so that its fsverity information is loaded.  Any deviation
+ * fails the boot: with a trusted command line this pins the complete
+ * image contents, which fsverity keeps verifying against the image's
+ * Merkle tree as they are read.
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
@@ -481,6 +541,9 @@ static void __init mount_root_image(void)
 		panic("VFS: unable to open root image %s: error %ld",
 		      root_image, PTR_ERR(file));
 
+	if (root_image_verity)
+		verify_root_image(file);
+
 	err = init_mkdir("/image", 0700);
 	if (err < 0 && err != -EEXIST)
 		panic("VFS: unable to create /image: error %d", err);
-- 
2.43.0


