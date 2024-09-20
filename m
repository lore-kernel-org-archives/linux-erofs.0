Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8781CF3964
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Sep 2024 02:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1726800593;
	bh=kqk81g7cDt96LcsILwVIIivCeMHJdyCwfxcWpXlbjK8=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=h9pscUN/BeUmTlvxrchShBZ916y7/DAKZ55PINfKXQBdas2Qyca3thj7dTpK1p4vk
	 dpDvYXfe0aW3rdivzVtT4HT5pq33/OkwReksaMigyqNRQKgk7gcD7VMPBMF3ZIhZvX
	 9PCHb+BT+0tiN98Cs+hFFP5s9Eb9Cyz8O2ZkVEaT8QwDpQPSHrqt5NDcGMtJun72hD
	 4h9gpguC3ZaLgt68RE0QVTQ9uDYbteTItx96G8MeHivr928KTnyOe0IrQyNVUoJ63i
	 a1jJMrTkEaYqBDNmSGKtjF1bn1+DNzRz4KRWBAIgwdc0c83ptd4aPYgge3jOTVEEtV
	 Y7W6JlHT5Nj4A==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4X8xgj05TLz2yxN
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Sep 2024 12:49:53 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=148.135.17.20
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1726800588;
	cv=none; b=i1XHHFw7+ywBZWH3C6N8xyAiEvGf/Cl8YIpGtJj+DNF97eOHZjQm+e/gvTMEKw+jlmzHGQA60rL5QFsEZ9DK9kNZDkU86LgcyXwv/eUE5u5G0sxAH4vOFegKHIQC+XEDd1dkyKGPVBvgTTeri8Y/yJKOvCw56mDA5ZB7hdOeO27fcpAYsQdXtK7VkuvbUKO1jSdnsawqBoN9TqWcERLJUKkcyWrx3zhoSrUFUsUj9E5OmMjJ719hxRFFkeeXzEs92oX599H30yFdFx0s7FPxfVdlxq9/DN19XlImUghe+IU2PAFNH3yuZ2YLGiSahQggp8+W3Dfqmodyd+gu44O8Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1726800588; c=relaxed/relaxed;
	bh=kqk81g7cDt96LcsILwVIIivCeMHJdyCwfxcWpXlbjK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmiOlJUf/j6dVtwcOU8DypFMNPOkCfHQ6NZplc/zvwE2le052qDV99DYQY/6BU38hWTZGG+RxBNX4aAi5mT3saYRRmB8nc5vzsRST8GQpR/k0258QXQluGFqnFtkwaXGTF/go8XIcAGlWNlJrqX6OdppM9n/FuRNhswCJewRyesDCqfPUnWmq+eFe2rakMDWcwAxRM2scsIG2EkV5rhwQugRCIR1xZWYzuy2SXdF8OJ/kvyRJhuHOwSgjOl1Ur5fu6+twOm9A+JnbrAFBWUbfUJP08/U09M0tKROSSK3hDP/J7yKgpCGa6q+/NtVeMbP4LBNg6FOF1OjtW9boX6gKg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=tlmp.cc; dkim=pass (2048-bit key; secure) header.d=tlmp.cc header.i=@tlmp.cc header.a=rsa-sha256 header.s=dkim header.b=ZcZSdQbp; dkim-atps=neutral; spf=pass (client-ip=148.135.17.20; helo=mail.tlmp.cc; envelope-from=toolmanp@tlmp.cc; receiver=lists.ozlabs.org) smtp.mailfrom=tlmp.cc
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=tlmp.cc
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=tlmp.cc header.i=@tlmp.cc header.a=rsa-sha256 header.s=dkim header.b=ZcZSdQbp;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=tlmp.cc (client-ip=148.135.17.20; helo=mail.tlmp.cc; envelope-from=toolmanp@tlmp.cc; receiver=lists.ozlabs.org)
Received: from mail.tlmp.cc (unknown [148.135.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4X8xgc0lPGz2xpp
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Sep 2024 12:49:48 +1000 (AEST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E02B36983F;
	Thu, 19 Sep 2024 22:49:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tlmp.cc; s=dkim;
	t=1726800584; h=from:subject:date:message-id:to:cc:mime-version:
	 content-transfer-encoding:in-reply-to:references;
	bh=kqk81g7cDt96LcsILwVIIivCeMHJdyCwfxcWpXlbjK8=;
	b=ZcZSdQbp0VIvi0hfV0+927P1+M62iDNMPEz8UWh77he1IbyVS8s/xfcerNU97WMcSpe4It
	R1kVb/4LL5o9xetugpbqxLTEZN4aS7SAknhy4/zhXOdgJLfk66eLW8cLEuet/nekxGdGtE
	VNe/jAajUxhGXzCTWtAzEB4KygCCsKR4MEmBV/NANbcUiw1aW6eyoAfKFtGrBK6jdc9j/t
	OfznPOPYLnnXj8aRGZZobGAeY43OmcdTNKwZG3PMqhv/UXZLLPRGmLEuJbtwb9uVMvDr1Y
	c3xZ0GuAZkcmDtSR7g3pfZ7mjEjwvxr4CMZ6ixa0xKIFJX0AX3fSho3Zu58Aog==
To: rust-for-linux@vger.kernel.org
Subject: [PATCH RESEND 1/1] rust: error: auto-generate error declarations
Date: Fri, 20 Sep 2024 10:49:19 +0800
Message-ID: <20240920024920.215842-2-toolmanp@tlmp.cc>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240920024920.215842-1-toolmanp@tlmp.cc>
References: <2024091602-bannister-giddy-0d6e@gregkh>
 <20240920024920.215842-1-toolmanp@tlmp.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
From: Yiyang Wu via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Yiyang Wu <toolmanp@tlmp.cc>
Cc: gregkh@linuxfoundation.org, LKML <linux-kernel@vger.kernel.org>, gary@garyguo.net, linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

This patch adds a new cmd_errno to convert the include/linux/errno.h
content into declare_err! macros for better maintainability and readability.

Signed-off-by: Yiyang Wu <toolmanp@tlmp.cc>
---
 rust/.gitignore      |  1 +
 rust/Makefile        | 14 ++++++++++-
 rust/kernel/error.rs | 58 +++-----------------------------------------
 3 files changed, 18 insertions(+), 55 deletions(-)

diff --git a/rust/.gitignore b/rust/.gitignore
index d3829ffab80b..ba71ef4a9239 100644
--- a/rust/.gitignore
+++ b/rust/.gitignore
@@ -5,6 +5,7 @@ bindings_helpers_generated.rs
 doctests_kernel_generated.rs
 doctests_kernel_generated_kunit.c
 uapi_generated.rs
+errno_generated.rs
 exports_*_generated.h
 doc/
 test/
diff --git a/rust/Makefile b/rust/Makefile
index dd76dc27d666..f5a1680fe59c 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -22,6 +22,8 @@ always-$(CONFIG_RUST) += exports_alloc_generated.h exports_helpers_generated.h \
 always-$(CONFIG_RUST) += uapi/uapi_generated.rs
 obj-$(CONFIG_RUST) += uapi.o
 
+always-$(CONFIG_RUST) += kernel/errno_generated.rs
+
 ifdef CONFIG_RUST_BUILD_ASSERT_ALLOW
 obj-$(CONFIG_RUST) += build_error.o
 else
@@ -289,6 +291,15 @@ $(obj)/uapi/uapi_generated.rs: $(src)/uapi/uapi_helper.h \
     $(src)/bindgen_parameters FORCE
 	$(call if_changed_dep,bindgen)
 
+quiet_cmd_errno = EXPORTS $@
+      cmd_errno = \
+	$(CC) $(c_flags) -E -CC -dD $< \
+	| sed -E 's/\#define\s*([A-Z0-9]+)\s+([0-9]+)\s+\/\*\s*(.*)\s\*\//declare_err!(\1, "\3.");/' \
+	| grep -E '^declare_err.*$$' > $@
+
+$(obj)/kernel/errno_generated.rs: $(srctree)/include/linux/errno.h FORCE
+	$(call if_changed,errno)
+
 # See `CFLAGS_REMOVE_helpers.o` above. In addition, Clang on C does not warn
 # with `-Wmissing-declarations` (unlike GCC), so it is not strictly needed here
 # given it is `libclang`; but for consistency, future Clang changes and/or
@@ -420,7 +431,8 @@ $(obj)/uapi.o: $(src)/uapi/lib.rs \
 
 $(obj)/kernel.o: private rustc_target_flags = --extern alloc \
     --extern build_error --extern macros --extern bindings --extern uapi
-$(obj)/kernel.o: $(src)/kernel/lib.rs $(obj)/alloc.o $(obj)/build_error.o \
+$(obj)/kernel.o: $(src)/kernel/lib.rs $(obj)/kernel/errno_generated.rs \
+    $(obj)/alloc.o $(obj)/build_error.o \
     $(obj)/libmacros.so $(obj)/bindings.o $(obj)/uapi.o FORCE
 	+$(call if_changed_rule,rustc_library)
 
diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
index 6f1587a2524e..bb16b40a8d19 100644
--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -23,60 +23,10 @@ macro_rules! declare_err {
             pub const $err: super::Error = super::Error(-(crate::bindings::$err as i32));
         };
     }
-
-    declare_err!(EPERM, "Operation not permitted.");
-    declare_err!(ENOENT, "No such file or directory.");
-    declare_err!(ESRCH, "No such process.");
-    declare_err!(EINTR, "Interrupted system call.");
-    declare_err!(EIO, "I/O error.");
-    declare_err!(ENXIO, "No such device or address.");
-    declare_err!(E2BIG, "Argument list too long.");
-    declare_err!(ENOEXEC, "Exec format error.");
-    declare_err!(EBADF, "Bad file number.");
-    declare_err!(ECHILD, "No child processes.");
-    declare_err!(EAGAIN, "Try again.");
-    declare_err!(ENOMEM, "Out of memory.");
-    declare_err!(EACCES, "Permission denied.");
-    declare_err!(EFAULT, "Bad address.");
-    declare_err!(ENOTBLK, "Block device required.");
-    declare_err!(EBUSY, "Device or resource busy.");
-    declare_err!(EEXIST, "File exists.");
-    declare_err!(EXDEV, "Cross-device link.");
-    declare_err!(ENODEV, "No such device.");
-    declare_err!(ENOTDIR, "Not a directory.");
-    declare_err!(EISDIR, "Is a directory.");
-    declare_err!(EINVAL, "Invalid argument.");
-    declare_err!(ENFILE, "File table overflow.");
-    declare_err!(EMFILE, "Too many open files.");
-    declare_err!(ENOTTY, "Not a typewriter.");
-    declare_err!(ETXTBSY, "Text file busy.");
-    declare_err!(EFBIG, "File too large.");
-    declare_err!(ENOSPC, "No space left on device.");
-    declare_err!(ESPIPE, "Illegal seek.");
-    declare_err!(EROFS, "Read-only file system.");
-    declare_err!(EMLINK, "Too many links.");
-    declare_err!(EPIPE, "Broken pipe.");
-    declare_err!(EDOM, "Math argument out of domain of func.");
-    declare_err!(ERANGE, "Math result not representable.");
-    declare_err!(ERESTARTSYS, "Restart the system call.");
-    declare_err!(ERESTARTNOINTR, "System call was interrupted by a signal and will be restarted.");
-    declare_err!(ERESTARTNOHAND, "Restart if no handler.");
-    declare_err!(ENOIOCTLCMD, "No ioctl command.");
-    declare_err!(ERESTART_RESTARTBLOCK, "Restart by calling sys_restart_syscall.");
-    declare_err!(EPROBE_DEFER, "Driver requests probe retry.");
-    declare_err!(EOPENSTALE, "Open found a stale dentry.");
-    declare_err!(ENOPARAM, "Parameter not supported.");
-    declare_err!(EBADHANDLE, "Illegal NFS file handle.");
-    declare_err!(ENOTSYNC, "Update synchronization mismatch.");
-    declare_err!(EBADCOOKIE, "Cookie is stale.");
-    declare_err!(ENOTSUPP, "Operation is not supported.");
-    declare_err!(ETOOSMALL, "Buffer or request is too small.");
-    declare_err!(ESERVERFAULT, "An untranslatable error occurred.");
-    declare_err!(EBADTYPE, "Type not supported by server.");
-    declare_err!(EJUKEBOX, "Request initiated, but will not complete before timeout.");
-    declare_err!(EIOCBQUEUED, "iocb queued, will get completion event.");
-    declare_err!(ERECALLCONFLICT, "Conflict with recalled state.");
-    declare_err!(ENOGRACE, "NFS file lock reclaim refused.");
+    include!(concat!(
+        env!("OBJTREE"),
+        "/rust/kernel/errno_generated.rs"
+    ));
 }
 
 /// Generic integer kernel error.
-- 
2.46.0

