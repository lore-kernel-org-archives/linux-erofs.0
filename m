Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C902B606A32D
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Nov 2026 00:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=enW/igrw
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jJVHd71zTz3c88;
	Tue, 03 Nov 2026 11:46:05 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::32c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793666765;
	cv=none; b=UXkWr01yi3Msy1viMrcfiAAA3j8PpmuTuG9ZhdDRVR7MwYJemJC8D4n4vYTdZo/4HEZ17K4OaK206EPQlQZYI73k5baNI3FZW5MtAbqnz2sMibwOAhX5y55/QLwpyDuey8HV+XCP4t2XFaN+P2f3nNKOLHlJoaxWHYPv8SohjLiB+PCnLk36/0AQRxxwAtXGcsRJipU2gBcBHKMQpRJakVBFTkHGGq1WN60zvy990T2EWQVEbhZeGbJQHBljcK7azRmEBH7S/ts1Cg7nvu9lwwh7ut/7Ym4/RE3wrtirsMOwT7zRod4wQao2lh5nwTXJ9KkbWiyRYQR7RlwdUB+7iA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793666765; c=relaxed/relaxed;
	bh=LCo7cfG94SNSV7kDVLY7VDItD3rdeOPc5IqFtc9i4pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ps0FcLVHLxGIEh9rdT5MQIu8RYGKw+mwbjWpIpIFjoetqqO2LyscxRKCy8rsoNSJB7o7AcpOexvod2nF+0j+fXhpvE3MFRmsppvGFBwb8jvmRM3DQqXkxwGxZP2xLC3Tw25jd5JeXv6Ot/yKPA3e6cooc9GmSO+CR4QuiRhwL1Zr/DjGhRRfjVa67cOeprC3FZIfPffjL2Kqa4fQC6KrX1UhiL1f0VkVhAqtGTaxVt0CCgzmGDgThZ2Gt2Pgb3d+9tzRdbKEWxek2muRfg24KohyWVumyCLYCgQcjmZgFR1hfeUmZ9Z1m5xNPi9VvKYxXCJqgT1p9X7+fHtxlJQqRQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=enW/igrw; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32c; helo=mail-wm1-x32c.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=enW/igrw;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::32c; helo=mail-wm1-x32c.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jJVHY48xQz3c5N
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Nov 2026 11:46:01 +1100 (AEDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-4a549cd7fd2so1465415e9.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 02 Nov 2026 16:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1793666757; x=1794271557; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LCo7cfG94SNSV7kDVLY7VDItD3rdeOPc5IqFtc9i4pI=;
        b=enW/igrwj1jscreX2RQVF86yKtqZwj/8SZbrg9h+DTzNMWgf9i2YbAQwS/FHqNR7l5
         GyyoB/tZN/jWtIzfab+Et1GlMa9+m8PXGv4jh44NSdOJQQofi/mR5wv+tMkea05c/WjH
         oREu9JwW4kmbb/Lt1v68vRhRYH+Stj+4a57UDgC6RYL58tnSoESIzqmDHMVra1o16I6w
         58ch0JumQ9Or8uSlqkuXZxfAWOHeGuIHhAyu5sxm0/3IzwX+WKkNgi3hQoRJ9d2oIkmR
         cplOPybs/B8d4JXb8oLz7MIdaas2GvyqdJJTxqM00vjJ71e1ICM178WJGP6rf/anvS4D
         FBaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793666757; x=1794271557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LCo7cfG94SNSV7kDVLY7VDItD3rdeOPc5IqFtc9i4pI=;
        b=TnwrmB1va1QAf3pZ1dYoJdWvQiDYYOksiJMwVE54vUQPXAOAeIOLOY8SxHWeeEx/JN
         hBVmgnwtY5qBnrmJRnTd80eho3OzFp7N62saymHc9VujA6ozNILABLxHCh/7r/EkUDZB
         XI6x9KF2NnxjLcCJo+fpgAdCWxNLM6uyRE3X4v3lL+fx3RwCD4JheOh11sC9h5V4k7ih
         EwC97GPXuQHTcmLvO3qVNwW+gwC/DJnPnMJIkSXGjgF0MPxAyJY0/6ijBbtxT/In/9pg
         HIhCkqhp6F+5fWTblWlw9a6+7QveNzEErjTAwSqy6OUBugXibwuFIZRY1D+5BMakOGQr
         5ZhQ==
X-Gm-Message-State: AFq9FYKLwnQwcefZfnNkwS6XHKbByQSv+WC8YOl/KL3K091O0GGBsIMd
	letAwiHg+Az7pV0yRVoPFhjt0U+MXiB2RXO/6kz/vzQoDnKcS0PGRG1qoF/YSHSb55657Wk/2Zm
	rWmzDmc4=
X-Gm-Gg: AYBFou3wQDukY6pgrbzB1+Gm3VC899ph2QBEmZZ9HOzfsCNf2s96BL96O9KTnNzZ9Y2
	cIA7/gppl2MTY4VTsRugYRkkh2SQO8vq2Ipaj8sv51k9oa0nfa+USCLerfFhfkSX3y0vUObfkY6
	IKbTqrKy4OTY0gvHR9ovjaiqIjrHn2z3NSbDR0EMD8+nD+7+IwzPNWgXsH/4Fm1f6TyDTOBYRhz
	dHXPggAPPVXH6BvZtICKzTP8HqhO+vGGIo4wNYPawQbnBzp5z70jWbZFGIjrfakEfvvcAUOvwJ7
	j6f0BkAmPYx2XxQdYoirNfOmN//2JPiymW3x+vtvwBE17glfHg1NAYVo5Uj9H6hzsiKXgBbXbMr
	zGT+PDDs0LSQSf0WAe3Edev+H4xgv9cnMvzCoq2y2j5q8a9d7ndhFRdKh+I7vR5NZD0xeVQ/53s
	RNoRgl+JZGGa50JwF9J0cMa3D8tZgCIlXw4zjGTrf9eD4DRgFjwdsXFpTNOAkpAsWBhV+mzyEgY
	2yCmf9Su96tGHphjyCH7gLqQrix0mxHR6u7uAzXT84/NBPlvSaxk/TdWcbOA5RVPrilBRxARMEO
	ak2iC3ww7SlBas91bznsVa9/FuHsTCpbd2PoDJimk2islFPvo5/aYEAwy8QfjZETsxOD
X-Received: by 2002:a05:600c:37c8:b0:4a2:18c4:61a5 with SMTP id 5b1f17b1804b1-4ac16acd93cmr271994735e9.6.1793666757172;
        Mon, 02 Nov 2026 16:45:57 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:3c00:331c:b5fa:ff22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a555e59dsm22078585e9.0.2026.11.02.16.45.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 02 Nov 2026 16:45:56 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH 4/5] erofs-utils: add native Windows support
Date: Tue,  3 Nov 2026 01:45:46 +0100
Message-ID: <20261103004547.15053-4-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261103004547.15053-1-xiang.gao@docker.com>
References: <20261103004547.15053-1-xiang.gao@docker.com>
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

Add an OS abstraction layer for file metadata, positional I/O and
temporary files, with Win32 implementations for MinGW builds.
Keep POSIX interfaces for other hosts, including Cygwin.

Add an Alpine-based Docker target for x86-64 Windows builds using
MSYS2 static libraries, with compression, S3 and OCI support.

Assisted-by: ChatGPT:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 Dockerfile                     |  67 ++++++-
 configure.ac                   |  22 ++-
 fsck/Makefile.am               |   2 +
 fsck/main.c                    |  23 +--
 include/erofs/defs.h           |   7 +-
 include/erofs/err.h            |   2 +-
 include/erofs/inode.h          |   2 +-
 include/erofs/io.h             |   8 +-
 include/erofs/os.h             |  60 +++++++
 include/erofs/tar.h            |   2 +-
 include/erofs/windows_compat.h | 159 +++++++++++++++++
 lib/Makefile.am                |  11 ++
 lib/blobchunk.c                |   2 +-
 lib/config.c                   |   5 +
 lib/diskbuf.c                  |  24 ++-
 lib/fragments.c                |  27 ++-
 lib/global.c                   |   4 +
 lib/inode.c                    |  47 +++--
 lib/io.c                       |  41 ++---
 lib/liberofs_private.h         |   2 -
 lib/metabox.c                  |   2 +-
 lib/namei.c                    |   2 +-
 lib/rebuild.c                  |   6 +-
 lib/remotes/docker_config.c    |   4 +-
 lib/remotes/oci.c              |  11 +-
 lib/remotes/s3.c               |  12 +-
 lib/super.c                    |   2 +-
 lib/tar.c                      |   8 +-
 lib/uuid.c                     |   5 +
 lib/windows_compat.c           | 308 +++++++++++++++++++++++++++++++++
 lib/xattr.c                    |   7 +-
 mkfs/main.c                    |  24 +--
 scripts/msys2-ucrt64.sha256    |  17 ++
 33 files changed, 800 insertions(+), 125 deletions(-)
 create mode 100644 include/erofs/os.h
 create mode 100644 include/erofs/windows_compat.h
 create mode 100644 lib/windows_compat.c
 create mode 100644 scripts/msys2-ucrt64.sha256

diff --git a/Dockerfile b/Dockerfile
index 3c4e88b..2e9689d 100644
--- a/Dockerfile
+++ b/Dockerfile
@@ -1,4 +1,8 @@
-# Build fully static erofs-utils binaries
+# Build static erofs-utils binaries:
+#   docker build --target linux --output type=local,dest=output/linux .
+#   docker build --target windows --output type=local,dest=output/windows .
+
+ARG MINGW_BUILD_PLATFORM=linux/amd64
 
 FROM alpine:3.24.1 AS builder
 
@@ -46,5 +50,64 @@ RUN ./autogen.sh && \
         --with-uuid && \
     make -j"$(nproc)" V=1 LDFLAGS="-all-static" && make install
 
-FROM scratch
+# Cross-compile x86-64 Windows binaries with static third-party libraries.
+# Alpine packages the MinGW toolchain for x86-64 build hosts.
+FROM --platform=${MINGW_BUILD_PLATFORM} alpine:3.24.1 AS windows-builder
+
+RUN apk add --no-cache \
+    build-base autoconf automake libtool pkgconf git \
+    ca-certificates curl tar zstd mingw-w64-gcc
+
+ENV MINGW_TARGET=x86_64-w64-mingw32 MINGW_PREFIX=/ucrt64
+ENV CC=${MINGW_TARGET}-gcc \
+    AR=${MINGW_TARGET}-ar \
+    RANLIB=${MINGW_TARGET}-ranlib \
+    WINDRES=${MINGW_TARGET}-windres
+
+# Use MSYS2 UCRT64 archives with Alpine's UCRT-based MinGW toolchain.
+# curl-winssl uses the Windows certificate store for HTTPS.
+ARG MSYS2_MIRROR=https://repo.msys2.org/mingw/ucrt64
+WORKDIR /deps
+COPY scripts/msys2-ucrt64.sha256 .
+RUN while read -r checksum package; do \
+        curl -fLsS -o "$package" "${MSYS2_MIRROR}/$package" && \
+        echo "$checksum  $package" | sha256sum -c - && \
+        tar --zstd -xf "$package" -C / ucrt64 || exit 1; \
+    done < msys2-ucrt64.sha256 && \
+    find ${MINGW_PREFIX}/lib -name '*.dll.a' -delete
+
+# Keep native pkg-config metadata out of cross checks.
+ENV PKG_CONFIG_LIBDIR=${MINGW_PREFIX}/lib/pkgconfig PKG_CONFIG_PATH=""
+
+WORKDIR /build
+COPY . .
+RUN ./autogen.sh && mkdir build-windows && cd build-windows && \
+    PKG_CONFIG="pkg-config --static" \
+    CPPFLAGS="-I${MINGW_PREFIX}/include -I${MINGW_PREFIX}/include/tre" \
+    LDFLAGS="-static -L${MINGW_PREFIX}/lib" \
+    LIBS="-lintl -liconv" \
+    ../configure --host=${MINGW_TARGET} --prefix=/output \
+        --enable-static --disable-shared --enable-multithreading \
+        --enable-lz4 --enable-lzma --with-zlib --with-libzstd \
+        --without-uuid --without-selinux \
+        --enable-s3 --enable-oci \
+        --with-libcurl --with-openssl --with-libxml2 --with-json-c \
+        --without-libnl3 && \
+    make -j"$(nproc)" V=1 LDFLAGS="-all-static -L${MINGW_PREFIX}/lib" && \
+    make install-strip && \
+    for binary in /output/bin/*.exe; do \
+        ${MINGW_TARGET}-objdump -p "$binary" > /tmp/imports.txt && \
+        awk '/DLL Name:/ { \
+            name = tolower($3); \
+            if (name !~ /^(kernel32|advapi32|msvcrt|ucrtbase|bcrypt|crypt32|secur32|ws2_32|iphlpapi|wldap32|user32|gdi32|api-ms-win-crt-[a-z0-9-]+)\.dll$/) { \
+                print "Unexpected DLL dependency: " $3; failed = 1 \
+            } \
+        } END { exit failed }' /tmp/imports.txt || exit 1; \
+    done
+
+FROM scratch AS windows
+COPY --from=windows-builder /output .
+
+# Keep the existing Linux output as the default target.
+FROM scratch AS linux
 COPY --from=builder /build/output .
diff --git a/configure.ac b/configure.ac
index 25a4892..c436718 100644
--- a/configure.ac
+++ b/configure.ac
@@ -13,22 +13,34 @@ AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_AUX_DIR(config)
 
 AC_CANONICAL_TARGET
+AC_CANONICAL_HOST
 
 build_linux=no
-case "${target_os}" in
+build_windows=no
+case "${host_os}" in
   linux*)
     build_linux=yes
     ;;
+  mingw*)
+    build_windows=yes
+    ;;
 esac
 
 # OS-specific treatment
 AM_CONDITIONAL([OS_LINUX], [test "$build_linux" = "yes"])
+AM_CONDITIONAL([OS_WINDOWS], [test "$build_windows" = "yes"])
 
 AM_INIT_AUTOMAKE([foreign subdir-objects -Wall])
 
+# Enable LFS (e.g. 64-bit off_t) before compiler and feature checks.
+CPPFLAGS="$CPPFLAGS -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
+
 # Checks for programs.
 AM_PROG_AR
 AC_PROG_CC
+AS_CASE([$host_os], [mingw*], [
+  CPPFLAGS="$CPPFLAGS -D__USE_MINGW_ANSI_STDIO=1"
+])
 AC_PROG_INSTALL
 
 LT_INIT
@@ -242,6 +254,7 @@ AC_CHECK_HEADERS(m4_flatten([
 	linux/types.h
 	linux/xattr.h
 	limits.h
+	regex.h
 	stddef.h
 	stdint.h
 	stdlib.h
@@ -278,6 +291,10 @@ AC_CHECK_DECL(memrchr,[AC_DEFINE(HAVE_MEMRCHR, 1,
    #include <string.h>])
 
 # Checks for library functions.
+AC_SEARCH_LIBS([regcomp], [gnurx regex], [], [
+  AC_CHECK_LIB([tre], [tre_regcomp], [],
+    [AC_MSG_ERROR([POSIX regex support is required (e.g. libgnurx or TRE on Windows)])])
+])
 AC_CHECK_FUNCS(m4_flatten([
 	backtrace
 	copy_file_range
@@ -787,9 +804,6 @@ AS_IF([test "x$enable_s3" != "xno"], [
      AC_MSG_ERROR([S3 disabled: missing libcurl, openssl, or libxml2])])
   ], [have_s3="no"])
 
-# Enable 64-bit off_t
-CFLAGS+=" -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
-
 # Configure fuzzing mode
 AS_IF([test "x$enable_fuzzing" != "xyes"], [], [
   CC_CHECK_CFLAGS(["-fsanitize=address,fuzzer-no-link"], [
diff --git a/fsck/Makefile.am b/fsck/Makefile.am
index fa6e77e..8dcfd29 100644
--- a/fsck/Makefile.am
+++ b/fsck/Makefile.am
@@ -8,6 +8,7 @@ fsck_erofs_SOURCES = main.c
 fsck_erofs_CFLAGS = -Wall -I$(top_srcdir)/include ${openssl_CFLAGS}
 fsck_erofs_LDADD = $(top_builddir)/lib/liberofs.la $(LIBEROFS_LIBS)
 
+if !OS_WINDOWS
 if ENABLE_FUZZING
 noinst_PROGRAMS   = fuzz_erofsfsck
 fuzz_erofsfsck_SOURCES = main.c
@@ -15,3 +16,4 @@ fuzz_erofsfsck_CFLAGS = -Wall -I$(top_srcdir)/include -DFUZZING ${openssl_CFLAGS
 fuzz_erofsfsck_LDFLAGS = -fsanitize=address,fuzzer
 fuzz_erofsfsck_LDADD = $(top_builddir)/lib/liberofs.la $(LIBEROFS_LIBS)
 endif
+endif
diff --git a/fsck/main.c b/fsck/main.c
index e54c523..4e270a6 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -333,7 +333,7 @@ static void erofsfsck_set_attributes(struct erofs_inode *inode, char *path)
 		erofs_warn("failed to set times: %s", path);
 
 	if (fsckcfg.preserve_owner) {
-		ret = lchown(path, inode->i_uid, inode->i_gid);
+		ret = erofs_os_lchown(path, inode->i_uid, inode->i_gid);
 		if (ret < 0)
 			erofs_warn("failed to change ownership: %s", path);
 	}
@@ -683,8 +683,8 @@ static inline int erofs_extract_dir(struct erofs_inode *inode)
 	 * write/execute permission.  These are fixed up later in
 	 * erofsfsck_set_attributes().
 	 */
-	if (mkdir(fsckcfg.extract_path, 0700) < 0) {
-		struct stat st;
+	if (erofs_os_mkdir(fsckcfg.extract_path, 0700) < 0) {
+		erofs_os_stat_t st;
 
 		if (errno != EEXIST) {
 			erofs_err("failed to create directory: %s (%s)",
@@ -692,7 +692,7 @@ static inline int erofs_extract_dir(struct erofs_inode *inode)
 			return -errno;
 		}
 
-		if (lstat(fsckcfg.extract_path, &st) ||
+		if (erofs_os_lstat(fsckcfg.extract_path, &st) ||
 		    !S_ISDIR(st.st_mode)) {
 			erofs_err("path is not a directory: %s",
 				  fsckcfg.extract_path);
@@ -827,9 +827,9 @@ static inline int erofs_extract_file(struct erofs_inode *inode)
 	erofs_dbg("extract file to path: %s", fsckcfg.extract_path);
 
 again:
-	fd = open(fsckcfg.extract_path,
-		  O_WRONLY | O_CREAT | O_NOFOLLOW |
-			(fsckcfg.overwrite ? O_TRUNC : O_EXCL), 0700);
+	fd = erofs_os_open(fsckcfg.extract_path,
+			   O_WRONLY | O_CREAT | O_NOFOLLOW |
+				(fsckcfg.overwrite ? O_TRUNC : O_EXCL), 0700);
 	if (fd < 0) {
 		if (fsckcfg.overwrite && tryagain) {
 			if (errno == EISDIR) {
@@ -898,7 +898,7 @@ static inline int erofs_extract_symlink(struct erofs_inode *inode)
 
 	buf[inode->i_size] = '\0';
 again:
-	if (symlink(buf, fsckcfg.extract_path) < 0) {
+	if (erofs_os_symlink(buf, fsckcfg.extract_path) < 0) {
 		if (errno == EEXIST && fsckcfg.overwrite && tryagain) {
 			erofs_warn("try to forcely remove file %s",
 				   fsckcfg.extract_path);
@@ -934,7 +934,8 @@ static int erofs_extract_special(struct erofs_inode *inode)
 		return ret;
 
 again:
-	if (mknod(fsckcfg.extract_path, inode->i_mode, inode->u.i_rdev) < 0) {
+	if (erofs_os_mknod(fsckcfg.extract_path, inode->i_mode,
+			   inode->u.i_rdev) < 0) {
 		if (errno == EEXIST && fsckcfg.overwrite && tryagain) {
 			erofs_warn("try to forcely remove file %s",
 				   fsckcfg.extract_path);
@@ -1023,7 +1024,7 @@ verify:
 
 	oldpath = erofsfsck_hardlink_find(inode->nid);
 	if (oldpath) {
-		if (link(oldpath, fsckcfg.extract_path) == -1) {
+		if (erofs_os_link(oldpath, fsckcfg.extract_path) == -1) {
 			erofs_err("failed to extract hard link: %s (%s)",
 				  fsckcfg.extract_path, strerror(errno));
 			return -errno;
@@ -1139,7 +1140,7 @@ int main(int argc, char *argv[])
 	fsckcfg.extract_path = NULL;
 	fsckcfg.extract_pos = 0;
 	fsckcfg.umask = umask(0);
-	fsckcfg.superuser = geteuid() == 0;
+	fsckcfg.superuser = erofs_os_geteuid() == 0;
 	fsckcfg.corrupted = false;
 	fsckcfg.print_comp_ratio = false;
 	fsckcfg.check_decomp = false;
diff --git a/include/erofs/defs.h b/include/erofs/defs.h
index fabd867..9073b80 100644
--- a/include/erofs/defs.h
+++ b/include/erofs/defs.h
@@ -24,6 +24,8 @@ extern "C"
 #include <config.h>
 #endif
 
+#include "os.h"
+
 #ifdef HAVE_ENDIAN_H
 #include <endian.h>
 #else
@@ -361,8 +363,9 @@ unsigned long __roundup_pow_of_two(unsigned long n)
 #define __always_inline	inline
 #endif
 
-#ifdef HAVE_STRUCT_STAT_ST_ATIM
-/* Linux */
+#if defined(HAVE_STRUCT_STAT_ST_ATIM) || \
+	(defined(_WIN32) && !defined(__CYGWIN__))
+/* Linux and native Windows */
 #define ST_ATIM_NSEC(stbuf) ((stbuf)->st_atim.tv_nsec)
 #define ST_CTIM_NSEC(stbuf) ((stbuf)->st_ctim.tv_nsec)
 #define ST_MTIM_NSEC(stbuf) ((stbuf)->st_mtim.tv_nsec)
diff --git a/include/erofs/err.h b/include/erofs/err.h
index 1d18d54..708a7b9 100644
--- a/include/erofs/err.h
+++ b/include/erofs/err.h
@@ -35,7 +35,7 @@ static inline const char *erofs_strerror(int err)
 
 static inline void *ERR_PTR(long error)
 {
-	return (void *)error;
+	return (void *)(intptr_t)error;
 }
 
 static inline int IS_ERR(const void *ptr)
diff --git a/include/erofs/inode.h b/include/erofs/inode.h
index 5b67b95..8c22dae 100644
--- a/include/erofs/inode.h
+++ b/include/erofs/inode.h
@@ -41,7 +41,7 @@ int erofs_allocate_inode_bh_data(struct erofs_inode *inode, erofs_blk_t nblocks,
 				 int device_id);
 bool erofs_dentry_is_wht(struct erofs_sb_info *sbi, struct erofs_dentry *d);
 int __erofs_fill_inode(struct erofs_importer *im, struct erofs_inode *inode,
-		       struct stat *st, const char *path);
+		       erofs_os_stat_t *st, const char *path);
 struct erofs_inode *erofs_new_inode(struct erofs_sb_info *sbi);
 int erofs_importer_load_tree(struct erofs_importer *im, bool rebuild,
 			     bool incremental);
diff --git a/include/erofs/io.h b/include/erofs/io.h
index f3d4899..eafcaa6 100644
--- a/include/erofs/io.h
+++ b/include/erofs/io.h
@@ -17,8 +17,10 @@ extern "C"
 #endif
 #include <unistd.h>
 #include <sys/stat.h>
-#include <sys/uio.h>
 #include "defs.h"
+#if defined(HAVE_SYS_UIO_H) || !defined(_WIN32)
+#include <sys/uio.h>
+#endif
 
 #ifndef O_BINARY
 #define O_BINARY	0
@@ -48,7 +50,7 @@ struct erofs_vfops {
 	ssize_t (*read)(struct erofs_vfile *vf, void *buf, size_t len);
 	ssize_t (*write)(struct erofs_vfile *vf, void *buf, size_t len);
 	off_t (*lseek)(struct erofs_vfile *vf, u64 offset, int whence);
-	int (*fstat)(struct erofs_vfile *vf, struct stat *buf);
+	int (*fstat)(struct erofs_vfile *vf, erofs_os_stat_t *buf);
 	ssize_t (*sendfile)(struct erofs_vfile *vout, struct erofs_vfile *vin,
 			    off_t *pos, size_t count);
 	int (*xcopy)(struct erofs_vfile *vout, off_t pos,
@@ -71,7 +73,7 @@ struct erofs_vfile {
 ssize_t __erofs_io_pwrite(int fd, const void *buf, size_t len, u64 pos);
 int __erofs_0write(int fd, size_t len);
 
-int erofs_io_fstat(struct erofs_vfile *vf, struct stat *buf);
+int erofs_io_fstat(struct erofs_vfile *vf, erofs_os_stat_t *buf);
 ssize_t erofs_io_pwrite(struct erofs_vfile *vf, const void *buf, u64 pos, size_t len);
 ssize_t erofs_io_pwritev(struct erofs_vfile *vf, const struct iovec *iov,
 			 int iovcnt, u64 pos);
diff --git a/include/erofs/os.h b/include/erofs/os.h
new file mode 100644
index 0000000..0725239
--- /dev/null
+++ b/include/erofs/os.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#ifndef __EROFS_OS_H
+#define __EROFS_OS_H
+
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdarg.h>
+
+/*
+ * The file position after erofs_os_pread() or erofs_os_pwrite() is undefined.
+ * Use lseek() before subsequent read() or write().
+ */
+#if defined(_WIN32) && !defined(__CYGWIN__)
+#include "windows_compat.h"
+#else
+#ifdef HAVE_SYS_SYSMACROS_H
+#include <sys/sysmacros.h>
+#endif
+
+/* Keep the native stat layout on POSIX hosts. */
+typedef struct stat erofs_os_stat_t;
+
+#define erofs_os_stat		stat
+#define erofs_os_lstat		lstat
+#define erofs_os_fstat		fstat
+#define erofs_os_open		open
+#define erofs_os_link		link
+#define erofs_os_pread		pread
+#define erofs_os_pwrite		pwrite
+#define erofs_os_realpath	realpath
+#define erofs_os_strndup	strndup
+#define erofs_os_getpagesize	getpagesize
+#define erofs_os_fsync		fsync
+#define erofs_os_mkdir		mkdir
+#define erofs_os_getuid		getuid
+#define erofs_os_geteuid	geteuid
+#define erofs_os_getgid		getgid
+#define erofs_os_getegid	getegid
+#define erofs_os_lchown		lchown
+#define erofs_os_readlink	readlink
+#define erofs_os_symlink	symlink
+#define erofs_os_mknod		mknod
+#define erofs_os_major		major
+#define erofs_os_minor		minor
+#define erofs_os_makedev	makedev
+
+#endif
+
+/* Return a temporary file descriptor or a negative errno. */
+int erofs_os_tmpfile(void);
+
+#endif
diff --git a/include/erofs/tar.h b/include/erofs/tar.h
index a816633..cc1df17 100644
--- a/include/erofs/tar.h
+++ b/include/erofs/tar.h
@@ -12,7 +12,7 @@ extern "C"
 #include "internal.h"
 
 struct erofs_pax_header {
-	struct stat st;
+	erofs_os_stat_t st;
 	struct list_head xattrs;
 	bool use_mtime;
 	bool use_size;
diff --git a/include/erofs/windows_compat.h b/include/erofs/windows_compat.h
new file mode 100644
index 0000000..ce16f23
--- /dev/null
+++ b/include/erofs/windows_compat.h
@@ -0,0 +1,159 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#ifndef __EROFS_WINDOWS_COMPAT_H
+#define __EROFS_WINDOWS_COMPAT_H
+
+/* Native MinGW builds; Cygwin uses its own POSIX interfaces. */
+#ifndef WIN32_LEAN_AND_MEAN
+#define WIN32_LEAN_AND_MEAN
+#endif
+#ifndef NOMINMAX
+#define NOMINMAX
+#endif
+#include <windows.h>
+#include <io.h>
+#include <direct.h>
+#include <fcntl.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <time.h>
+#include <unistd.h>
+#include <errno.h>
+
+#ifndef S_IFBLK
+#define S_IFBLK 0060000
+#endif
+#ifndef S_IFLNK
+#define S_IFLNK 0120000
+#endif
+#ifndef S_IFSOCK
+#define S_IFSOCK 0140000
+#endif
+#ifndef S_ISLNK
+#define S_ISLNK(m) (((m) & S_IFMT) == S_IFLNK)
+#endif
+#ifndef S_ISBLK
+#define S_ISBLK(m) (((m) & S_IFMT) == S_IFBLK)
+#endif
+#ifndef S_ISSOCK
+#define S_ISSOCK(m) (((m) & S_IFMT) == S_IFSOCK)
+#endif
+#ifndef S_ISUID
+#define S_ISUID 04000
+#define S_ISGID 02000
+#define S_ISVTX 01000
+#endif
+
+struct iovec {
+	void *iov_base;
+	size_t iov_len;
+};
+
+#ifndef O_NOFOLLOW
+#define O_NOFOLLOW 0x10000000
+#endif
+
+/* The CRT's stat has a truncated inode number and no block size. */
+typedef struct {
+	uint64_t st_ino;
+	dev_t st_dev, st_rdev;
+	mode_t st_mode;
+	unsigned int st_nlink, st_uid, st_gid;
+	off_t st_size;
+	struct timespec st_atim, st_mtim, st_ctim;
+	unsigned int st_blksize;
+	uint64_t st_blocks;
+} erofs_os_stat_t;
+
+#ifndef st_atime
+#define st_atime st_atim.tv_sec
+#endif
+#ifndef st_mtime
+#define st_mtime st_mtim.tv_sec
+#endif
+#ifndef st_ctime
+#define st_ctime st_ctim.tv_sec
+#endif
+
+int erofs_os_stat(const char *path, erofs_os_stat_t *st);
+int erofs_os_lstat(const char *path, erofs_os_stat_t *st);
+int erofs_os_fstat(int fd, erofs_os_stat_t *st);
+int erofs_os_open(const char *path, int flags, ...);
+int erofs_os_link(const char *oldpath, const char *newpath);
+ssize_t erofs_os_pread(int fd, void *buf, size_t len, off_t offset);
+ssize_t erofs_os_pwrite(int fd, const void *buf, size_t len, off_t offset);
+char *erofs_os_realpath(const char *path, char *resolved);
+char *erofs_os_strndup(const char *s, size_t len);
+int erofs_win_random(void *buf, unsigned int len);
+int erofs_os_getpagesize(void);
+int erofs_win_unsupported(void);
+
+static inline int erofs_os_fsync(int fd)
+{
+	return _commit(fd);
+}
+static inline int erofs_os_mkdir(const char *path, mode_t mode)
+{
+	return _mkdir(path);
+}
+
+static inline unsigned int erofs_os_getuid(void)
+{
+	return 0;
+}
+
+static inline unsigned int erofs_os_geteuid(void)
+{
+	return 0;
+}
+
+static inline unsigned int erofs_os_getgid(void)
+{
+	return 0;
+}
+
+static inline unsigned int erofs_os_getegid(void)
+{
+	return 0;
+}
+
+static inline int erofs_os_lchown(const char *path, unsigned int uid,
+				  unsigned int gid)
+{
+	return erofs_win_unsupported();
+}
+
+static inline ssize_t erofs_os_readlink(const char *path, char *buf, size_t len)
+{
+	return erofs_win_unsupported();
+}
+
+static inline int erofs_os_symlink(const char *target, const char *path)
+{
+	return erofs_win_unsupported();
+}
+
+static inline int erofs_os_mknod(const char *path, mode_t mode, dev_t dev)
+{
+	return erofs_win_unsupported();
+}
+
+/* Linux device encoding is used for image metadata, not Windows devices. */
+static inline unsigned int erofs_os_major(dev_t dev)
+{
+	return (dev >> 8) & 0xfff;
+}
+
+static inline unsigned int erofs_os_minor(dev_t dev)
+{
+	return (dev & 0xff) | ((dev >> 12) & 0xfff00);
+}
+
+static inline dev_t erofs_os_makedev(unsigned int maj, unsigned int min)
+{
+	return (min & 0xff) | ((maj & 0xfff) << 8) | ((min & 0xfff00) << 12);
+}
+
+#endif
diff --git a/lib/Makefile.am b/lib/Makefile.am
index f9b2ed2..c428400 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -13,12 +13,14 @@ noinst_HEADERS = $(top_srcdir)/include/erofs_fs.h \
       $(top_srcdir)/include/erofs/inode.h \
       $(top_srcdir)/include/erofs/internal.h \
       $(top_srcdir)/include/erofs/io.h \
+      $(top_srcdir)/include/erofs/os.h \
       $(top_srcdir)/include/erofs/list.h \
       $(top_srcdir)/include/erofs/print.h \
       $(top_srcdir)/include/erofs/bitops.h \
       $(top_srcdir)/include/erofs/tar.h \
       $(top_srcdir)/include/erofs/trace.h \
       $(top_srcdir)/include/erofs/xattr.h \
+      $(top_srcdir)/include/erofs/windows_compat.h \
       $(top_srcdir)/include/erofs/compress_hints.h \
       $(top_srcdir)/include/erofs/importer.h \
       $(top_srcdir)/lib/liberofs_base64.h \
@@ -49,6 +51,15 @@ liberofs_la_SOURCES = config.c io.c cache.c super.c inode.c xattr.c exclude.c \
 
 liberofs_la_CFLAGS = -Wall ${libuuid_CFLAGS} -I$(top_srcdir)/include
 liberofs_la_LIBADD = $(LIBEROFS_LIBS)
+if OS_WINDOWS
+liberofs_la_SOURCES += windows_compat.c
+liberofs_la_LIBADD += -lbcrypt
+check_PROGRAMS = windows_compat_test
+TESTS = windows_compat_test$(EXEEXT)
+windows_compat_test_SOURCES = windows_compat_test.c windows_compat.c
+windows_compat_test_CPPFLAGS = -I$(top_srcdir)/include
+windows_compat_test_LDADD = -lbcrypt
+endif
 if ENABLE_LZ4
 liberofs_la_CFLAGS += ${liblz4_CFLAGS}
 liberofs_la_SOURCES += compressor_lz4.c
diff --git a/lib/blobchunk.c b/lib/blobchunk.c
index 50e4f7e..e985215 100644
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -602,7 +602,7 @@ int erofs_blob_init_device(struct erofs_sb_info *sbi, int device_id)
 	if (!vf)
 		return -ENOMEM;
 
-	fd = open(sbi->devs[device_id - 1].src_path,
+	fd = erofs_os_open(sbi->devs[device_id - 1].src_path,
 		  O_WRONLY | O_CREAT | O_TRUNC | O_BINARY, 0666);
 	if (fd < 0) {
 		ret = -errno;
diff --git a/lib/config.c b/lib/config.c
index 3470812..b158581 100644
--- a/lib/config.c
+++ b/lib/config.c
@@ -179,6 +179,11 @@ unsigned int erofs_get_available_processors(void)
 {
 #if defined(HAVE_UNISTD_H) && defined(HAVE_SYSCONF)
 	return sysconf(_SC_NPROCESSORS_ONLN);
+#elif defined(_WIN32)
+	SYSTEM_INFO info;
+
+	GetSystemInfo(&info);
+	return info.dwNumberOfProcessors;
 #else
 	return 0;
 #endif
diff --git a/lib/diskbuf.c b/lib/diskbuf.c
index b32a39a..81ce7d6 100644
--- a/lib/diskbuf.c
+++ b/lib/diskbuf.c
@@ -66,7 +66,8 @@ void erofs_diskbuf_close(struct erofs_diskbuf *db)
 	db->sp = NULL;
 }
 
-int erofs_tmpfile(void)
+#if !defined(_WIN32) || defined(__CYGWIN__)
+int erofs_os_tmpfile(void)
 {
 #define	TRAILER		"tmp.XXXXXXXXXX"
 	char buf[PATH_MAX];
@@ -86,6 +87,7 @@ int erofs_tmpfile(void)
 	(void)fchmod(fd, 0666 & ~u);
 	return fd;
 }
+#endif
 
 int erofs_diskbuf_init(unsigned int nstrms)
 {
@@ -98,9 +100,14 @@ int erofs_diskbuf_init(unsigned int nstrms)
 	dbufstrm = strm;
 
 	for (; strm < dbufstrm + nstrms; ++strm) {
-		struct stat st;
-
-		/* try to use the devfd for regfiles on stream 0 */
+		erofs_os_stat_t st;
+
+		/*
+		 * Try to use the devfd for regfiles on stream 0. Skip Windows,
+		 * where extending a non-sparse file can allocate the entire
+		 * 2 TiB scratch range.
+		 */
+#ifndef _WIN32
 		if (strm == dbufstrm && !g_sbi.bdev.ops) {
 			strm->devpos = 1ULL << 40;
 			if (!ftruncate(g_sbi.bdev.fd, strm->devpos << 1)) {
@@ -108,16 +115,19 @@ int erofs_diskbuf_init(unsigned int nstrms)
 				goto setupone;
 			}
 		}
+#endif
 		strm->devpos = 0;
-		strm->fd = erofs_tmpfile();
+		strm->fd = erofs_os_tmpfile();
 		if (strm->fd < 0)
 			return -ENOSPC;
+#ifndef _WIN32
 setupone:
+#endif
 		strm->tailoffset = 0;
 		erofs_atomic_set(&strm->count, 1);
-		if (fstat(strm->fd, &st))
+		if (erofs_os_fstat(strm->fd, &st))
 			return -errno;
-		strm->alignsize = max_t(u32, st.st_blksize, getpagesize());
+		strm->alignsize = max_t(u32, st.st_blksize, erofs_os_getpagesize());
 	}
 	return 0;
 }
diff --git a/lib/fragments.c b/lib/fragments.c
index bb9ef72..637b1f6 100644
--- a/lib/fragments.c
+++ b/lib/fragments.c
@@ -11,7 +11,10 @@
 #endif
 #include <stdlib.h>
 #include <unistd.h>
+#include <config.h>
+#ifdef HAVE_SYS_MMAN_H
 #include <sys/mman.h>
+#endif
 #include "erofs/err.h"
 #include "erofs/inode.h"
 #include "erofs/print.h"
@@ -108,7 +111,7 @@ static erofs_off_t erofs_fragment_longmatch(struct erofs_inode *inode,
 			break;
 
 		if (!inmem) {
-			if (pread(epi->fd, buf[1], sz, pos - sz) != sz)
+			if (erofs_os_pread(epi->fd, buf[1], sz, pos - sz) != sz)
 				break;
 			if (memcmp(buf[0], buf[1], sz))
 				break;
@@ -240,7 +243,7 @@ int erofs_pack_file_from_fd(struct erofs_inode *inode,
 {
 	struct erofs_packed_inode *epi = inode->sbi->packedinode;
 	s64 offset, rc, sz;
-	char *memblock;
+	char *memblock = NULL;
 	bool onheap = false;
 
 	if (__erofs_unlikely(!inode->i_size))
@@ -248,12 +251,15 @@ int erofs_pack_file_from_fd(struct erofs_inode *inode,
 
 	offset = epi->pos;
 
-	if (vf->ops)
-		memblock = NULL;
-	else
+#ifdef HAVE_SYS_MMAN_H
+	if (!vf->ops) {
 		memblock = mmap(NULL, inode->i_size, PROT_READ,
 				MAP_SHARED, vf->fd, fpos);
-	if (memblock == MAP_FAILED || !memblock) {
+		if (memblock == MAP_FAILED)
+			memblock = NULL;
+	}
+#endif
+	if (!memblock) {
 		erofs_off_t remaining = inode->i_size;
 		struct erofs_vfile vout = { .fd = epi->fd };
 		bool noseek = vf->ops && !vf->ops->pread;
@@ -285,7 +291,8 @@ int erofs_pack_file_from_fd(struct erofs_inode *inode,
 		}
 		onheap = true;
 
-		rc = pread(epi->fd, memblock, sz, offset + inode->i_size - sz);
+		rc = erofs_os_pread(epi->fd, memblock, sz,
+				    offset + inode->i_size - sz);
 		if (rc != sz) {
 			if (rc >= 0) {
 				DBG_BUGON(1);
@@ -308,8 +315,10 @@ int erofs_pack_file_from_fd(struct erofs_inode *inode,
 out:
 	if (onheap)
 		free(memblock);
+#ifdef HAVE_SYS_MMAN_H
 	else if (memblock)
 		munmap(memblock, inode->i_size);
+#endif
 	return rc;
 }
 
@@ -452,7 +461,7 @@ int erofs_packedfile_init(struct erofs_sb_info *sbi, bool fragments_mkfs)
 		}
 	}
 
-	epi->fd = erofs_tmpfile();
+	epi->fd = erofs_os_tmpfile();
 	if (epi->fd < 0) {
 		err = epi->fd;
 		goto err_out;
@@ -635,7 +644,7 @@ int erofs_packedfile_read(struct erofs_sb_info *sbi,
 			if (!uptodate)
 				continue;
 
-			err = pread(epi->fd, buf, len, pos);
+			err = erofs_os_pread(epi->fd, buf, len, pos);
 			if (err < 0)
 				break;
 			if (err == len) {
diff --git a/lib/global.c b/lib/global.c
index 938aa0a..344dd10 100644
--- a/lib/global.c
+++ b/lib/global.c
@@ -24,6 +24,10 @@ int liberofs_global_init(void)
 
 	erofs_mutex_lock(&erofs_global_mutex);
 	erofs_init_configure();
+#ifdef _WIN32
+	_setmode(STDIN_FILENO, O_BINARY);
+	_setmode(STDOUT_FILENO, O_BINARY);
+#endif
 #ifdef S3EROFS_ENABLED
 	xmlInitParser();
 #endif
diff --git a/lib/inode.c b/lib/inode.c
index da29b5a..b1f5b97 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -1228,15 +1228,15 @@ static bool erofs_should_use_inode_extended(struct erofs_importer *im,
 
 u32 erofs_new_encode_dev(dev_t dev)
 {
-	const unsigned int major = major(dev);
-	const unsigned int minor = minor(dev);
+	const unsigned int major = erofs_os_major(dev);
+	const unsigned int minor = erofs_os_minor(dev);
 
 	return (minor & 0xff) | (major << 8) | ((minor & ~0xff) << 12);
 }
 
 #ifdef WITH_ANDROID
 int erofs_droid_inode_fsconfig(struct erofs_inode *inode,
-			       struct stat *st,
+			       erofs_os_stat_t *st,
 			       const char *path)
 {
 	/* filesystem_config does not preserve file type bits */
@@ -1284,7 +1284,7 @@ int erofs_droid_inode_fsconfig(struct erofs_inode *inode,
 }
 #else
 static int erofs_droid_inode_fsconfig(struct erofs_inode *inode,
-				      struct stat *st,
+				      erofs_os_stat_t *st,
 				      const char *path)
 {
 	return 0;
@@ -1292,7 +1292,7 @@ static int erofs_droid_inode_fsconfig(struct erofs_inode *inode,
 #endif
 
 int __erofs_fill_inode(struct erofs_importer *im, struct erofs_inode *inode,
-		       struct stat *st, const char *path)
+		       erofs_os_stat_t *st, const char *path)
 {
 	struct erofs_importer_params *params = im->params;
 	struct erofs_sb_info *sbi = inode->sbi;
@@ -1335,7 +1335,7 @@ int __erofs_fill_inode(struct erofs_importer *im, struct erofs_inode *inode,
 }
 
 static int erofs_fill_inode(struct erofs_importer *im, struct erofs_inode *inode,
-			    struct stat *st, const char *path)
+			    erofs_os_stat_t *st, const char *path)
 {
 	const struct erofs_importer_params *params = im->params;
 	int err;
@@ -1419,10 +1419,10 @@ static struct erofs_inode *erofs_iget_from_local(struct erofs_importer *im,
 	const struct erofs_importer_params *params = im->params;
 	struct erofs_sb_info *sbi = im->sbi;
 	struct erofs_inode *inode;
-	struct stat st;
+	erofs_os_stat_t st;
 	int ret;
 
-	ret = lstat(path, &st);
+	ret = erofs_os_lstat(path, &st);
 	if (ret)
 		return ERR_PTR(-errno);
 
@@ -1578,7 +1578,8 @@ static int erofs_mkfs_handle_nondirectory(const struct erofs_mkfs_btctx *btctx,
 			symlink = malloc(inode->i_size);
 			if (!symlink)
 				return -ENOMEM;
-			ret = readlink(inode->i_srcpath, symlink, inode->i_size);
+			ret = erofs_os_readlink(inode->i_srcpath, symlink,
+					       inode->i_size);
 			if (ret < 0) {
 				free(symlink);
 				return -errno;
@@ -1745,7 +1746,7 @@ static void *z_erofs_mt_dfops_worker(void *arg)
 	dfops->exited = true;
 	if (ret < 0)
 		pthread_cond_signal(&dfops->full);
-	pthread_exit((void *)(uintptr_t)(ret < 0 ? ret : 0));
+	return (void *)(intptr_t)(ret < 0 ? ret : 0);
 }
 
 static int erofs_mkfs_go(const struct erofs_mkfs_btctx *ctx,
@@ -2012,7 +2013,7 @@ static int erofs_set_inode_fingerprint(struct erofs_inode *inode, int fd,
 	struct erofs_vfile vf = { .fd = fd };
 	struct sha256_state md;
 	u8 out[32 + sizeof("sha256:") - 1];
-	int ret;
+	off_t ret;
 
 	if (!ishare_xattr_prefix_id)
 		return 0;
@@ -2030,6 +2031,11 @@ static int erofs_set_inode_fingerprint(struct erofs_inode *inode, int fd,
 		pos += ret;
 	} while (remaining);
 	erofs_sha256_done(&md, out + sizeof("sha256:") - 1);
+#if defined(_WIN32) && !defined(__CYGWIN__)
+	ret = erofs_io_lseek(&vf, pos - inode->i_size, SEEK_SET);
+	if (ret < 0)
+		return ret;
+#endif
 	memcpy(out, "sha256:", sizeof("sha256:") - 1);
 	return erofs_setxattr(inode, ishare_xattr_prefix_id, "",
 			      out, sizeof(out));
@@ -2051,12 +2057,13 @@ static int erofs_mkfs_begin_nondirectory(const struct erofs_mkfs_btctx *btctx,
 				return ctx.fd;
 			break;
 		case EROFS_INODE_DATA_SOURCE_LOCALPATH:
-			ctx.fd = open(inode->i_srcpath, O_RDONLY | O_BINARY);
+			ctx.fd = erofs_os_open(inode->i_srcpath, O_RDONLY | O_BINARY);
 			if (ctx.fd < 0)
 				return -errno;
 			break;
 		case EROFS_INODE_DATA_SOURCE_REBUILD_BLOB:
-			ctx.fd = open(inode->rebuild_blobpath, O_RDONLY | O_BINARY);
+			ctx.fd = erofs_os_open(inode->rebuild_blobpath,
+					       O_RDONLY | O_BINARY);
 			if (ctx.fd < 0)
 				return -errno;
 			ctx.fpos = inode->rebuild_src_dataoff;
@@ -2261,10 +2268,10 @@ static int __erofs_mkfs_build_tree(const struct erofs_mkfs_btctx *ctx)
 
 	if (!ctx->rebuild) {
 		struct erofs_importer_params *params = im->params;
-		struct stat st;
+		erofs_os_stat_t st;
 		int err;
 
-		err = lstat(params->source, &st);
+		err = erofs_os_lstat(params->source, &st);
 		if (err)
 			return -errno;
 
@@ -2293,6 +2300,8 @@ static int erofs_get_fdlimit(void)
 	if (rlim.rlim_cur == RLIM_INFINITY)
 		return 0;
 	return rlim.rlim_cur;
+#elif defined(_WIN32)
+	return _getmaxstdio();
 #else
 	return _POSIX_OPEN_MAX;
 #endif
@@ -2380,7 +2389,7 @@ struct erofs_inode *erofs_mkfs_build_special_from_fd(struct erofs_importer *im,
 {
 	struct erofs_sb_info *sbi = im->sbi;
 	struct erofs_inode *inode;
-	struct stat st;
+	erofs_os_stat_t st;
 	void *ictx;
 	int ret;
 
@@ -2388,7 +2397,7 @@ struct erofs_inode *erofs_mkfs_build_special_from_fd(struct erofs_importer *im,
 	if (ret < 0)
 		return ERR_PTR(-errno);
 
-	ret = fstat(fd, &st);
+	ret = erofs_os_fstat(fd, &st);
 	if (ret)
 		return ERR_PTR(-errno);
 
@@ -2511,9 +2520,9 @@ struct erofs_inode *erofs_make_empty_root_inode(struct erofs_importer *im,
 		return ERR_PTR(-ENOMEM);
 	}
 	root->i_mode = S_IFDIR | 0777;
-	root->i_uid = (!params || params->fixed_uid == -1) ? getuid() :
+	root->i_uid = (!params || params->fixed_uid == -1) ? erofs_os_getuid() :
 							     params->fixed_uid;
-	root->i_gid = (!params || params->fixed_gid == -1) ? getgid() :
+	root->i_gid = (!params || params->fixed_gid == -1) ? erofs_os_getgid() :
 							     params->fixed_gid;
 	root->i_parent = root;
 	root->i_mtime = root->sbi->epoch + root->sbi->build_time;
diff --git a/lib/io.c b/lib/io.c
index 14253af..ccec1fd 100644
--- a/lib/io.c
+++ b/lib/io.c
@@ -12,7 +12,10 @@
 #endif
 #include <stdlib.h>
 #include <sys/stat.h>
+#include <config.h>
+#ifdef HAVE_SYS_IOCTL_H
 #include <sys/ioctl.h>
+#endif
 #include "erofs/internal.h"
 #ifdef HAVE_LINUX_FS_H
 #include <linux/fs.h>
@@ -48,7 +51,7 @@ static ssize_t __erofs_io_write(int fd, const void *buf, size_t len)
 	return written;
 }
 
-int erofs_io_fstat(struct erofs_vfile *vf, struct stat *buf)
+int erofs_io_fstat(struct erofs_vfile *vf, erofs_os_stat_t *buf)
 {
 	if (__erofs_unlikely(cfg.c_dry_run)) {
 		buf->st_size = 0;
@@ -58,7 +61,7 @@ int erofs_io_fstat(struct erofs_vfile *vf, struct stat *buf)
 
 	if (vf->ops)
 		return vf->ops->fstat(vf, buf);
-	return fstat(vf->fd, buf);
+	return erofs_os_fstat(vf->fd, buf);
 }
 
 ssize_t __erofs_io_pwrite(int fd, const void *buf, size_t len, u64 pos)
@@ -66,7 +69,7 @@ ssize_t __erofs_io_pwrite(int fd, const void *buf, size_t len, u64 pos)
 	ssize_t ret, written = 0;
 
 	do {
-		ret = pwrite(fd, buf, len - written, (off_t)pos);
+		ret = erofs_os_pwrite(fd, buf, len - written, (off_t)pos);
 		if (ret <= 0) {
 			if (!ret)
 				break;
@@ -138,7 +141,7 @@ int erofs_io_fsync(struct erofs_vfile *vf)
 	if (vf->ops)
 		return vf->ops->fsync(vf);
 
-	ret = fsync(vf->fd);
+	ret = erofs_os_fsync(vf->fd);
 	if (ret) {
 		erofs_err("failed to fsync(!): %s", strerror(errno));
 		return -errno;
@@ -196,7 +199,7 @@ int erofs_io_fallocate(struct erofs_vfile *vf, u64 offset,
 int erofs_io_ftruncate(struct erofs_vfile *vf, u64 length)
 {
 	int ret;
-	struct stat st;
+	erofs_os_stat_t st;
 
 	if (__erofs_unlikely(cfg.c_dry_run))
 		return 0;
@@ -204,7 +207,7 @@ int erofs_io_ftruncate(struct erofs_vfile *vf, u64 length)
 	if (vf->ops)
 		return vf->ops->ftruncate(vf, length);
 
-	ret = fstat(vf->fd, &st);
+	ret = erofs_os_fstat(vf->fd, &st);
 	if (ret) {
 		erofs_err("failed to fstat: %s", strerror(errno));
 		return -errno;
@@ -227,11 +230,7 @@ ssize_t erofs_io_pread(struct erofs_vfile *vf, void *buf, size_t len, u64 pos)
 
 	pos += vf->offset;
 	do {
-#ifdef HAVE_PREAD64
-		ret = pread64(vf->fd, buf, len, (off64_t)pos);
-#else
-		ret = pread(vf->fd, buf, len, (off_t)pos);
-#endif
+		ret = erofs_os_pread(vf->fd, buf, len, (off_t)pos);
 		if (ret <= 0) {
 			if (!ret)
 				break;
@@ -288,7 +287,7 @@ int erofs_dev_open(struct erofs_sb_info *sbi, const char *dev, int flags)
 {
 	bool ro = (flags & O_ACCMODE) == O_RDONLY;
 	bool truncate = flags & O_TRUNC;
-	struct stat st;
+	erofs_os_stat_t st;
 	int fd, ret;
 
 #if defined(HAVE_SYS_STATFS_H) && defined(HAVE_FSTATFS)
@@ -296,7 +295,7 @@ int erofs_dev_open(struct erofs_sb_info *sbi, const char *dev, int flags)
 
 repeat:
 #endif
-	fd = open(dev, (ro ? O_RDONLY : O_RDWR | O_CREAT) | O_BINARY, 0644);
+	fd = erofs_os_open(dev, (ro ? O_RDONLY : O_RDWR | O_CREAT) | O_BINARY, 0644);
 	if (fd < 0) {
 		erofs_err("failed to open %s: %s", dev, strerror(errno));
 		return -errno;
@@ -305,7 +304,7 @@ repeat:
 	if (ro || !truncate)
 		goto out;
 
-	ret = fstat(fd, &st);
+	ret = erofs_os_fstat(fd, &st);
 	if (ret) {
 		erofs_err("failed to fstat(%s): %s", dev, strerror(errno));
 		close(fd);
@@ -396,7 +395,7 @@ void erofs_blob_closeall(struct erofs_sb_info *sbi)
 
 int erofs_blob_open_ro(struct erofs_sb_info *sbi, const char *dev)
 {
-	int fd = open(dev, O_RDONLY | O_BINARY);
+	int fd = erofs_os_open(dev, O_RDONLY | O_BINARY);
 
 	if (fd < 0) {
 		erofs_err("failed to open(%s).", dev);
@@ -454,11 +453,7 @@ static ssize_t __erofs_copy_file_range(int fd_in, u64 *off_in,
 		char *end, *p;
 
 		to_read = min_t(size_t, length, sizeof(buf));
-#ifdef HAVE_PREAD64
-		read_count = pread64(fd_in, buf, to_read, *off_in);
-#else
-		read_count = pread(fd_in, buf, to_read, *off_in);
-#endif
+		read_count = erofs_os_pread(fd_in, buf, to_read, *off_in);
 		if (read_count == 0)
 			/* End of file reached prematurely. */
 			return copied;
@@ -475,11 +470,7 @@ static ssize_t __erofs_copy_file_range(int fd_in, u64 *off_in,
 		for (p = buf; p < end; ) {
 			ssize_t write_count;
 
-#ifdef HAVE_PWRITE64
-			write_count = pwrite64(fd_out, p, end - p, *off_out);
-#else
-			write_count = pwrite(fd_out, p, end - p, *off_out);
-#endif
+			write_count = erofs_os_pwrite(fd_out, p, end - p, *off_out);
 			if (write_count < 0) {
 				/*
 				 * Adjust the input read position to match what
diff --git a/lib/liberofs_private.h b/lib/liberofs_private.h
index 64bcae8..464987d 100644
--- a/lib/liberofs_private.h
+++ b/lib/liberofs_private.h
@@ -23,5 +23,3 @@ static inline void *memrchr(const void *s, int c, size_t n)
 	return NULL;
 }
 #endif
-
-int erofs_tmpfile(void);
diff --git a/lib/metabox.c b/lib/metabox.c
index 5c2eada..587f6dd 100644
--- a/lib/metabox.c
+++ b/lib/metabox.c
@@ -26,7 +26,7 @@ static int erofs_metamgr_init(struct erofs_sb_info *sbi,
 {
 	int ret;
 
-	ret = erofs_tmpfile();
+	ret = erofs_os_tmpfile();
 	if (ret < 0)
 		return ret;
 
diff --git a/lib/namei.c b/lib/namei.c
index 9d04693..c064bb7 100644
--- a/lib/namei.c
+++ b/lib/namei.c
@@ -19,7 +19,7 @@ static dev_t erofs_new_decode_dev(u32 dev)
 	const unsigned int major = (dev & 0xfff00) >> 8;
 	const unsigned int minor = (dev & 0xff) | ((dev >> 12) & 0xfff00);
 
-	return makedev(major, minor);
+	return erofs_os_makedev(major, minor);
 }
 
 int erofs_read_inode_from_disk(struct erofs_inode *vi)
diff --git a/lib/rebuild.c b/lib/rebuild.c
index c378885..a5bd7fa 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -313,8 +313,8 @@ static int erofs_rebuild_update_inode(struct erofs_sb_info *dst_sb,
 	case S_IFIFO:
 	case S_IFSOCK:
 		inode->i_size = 0;
-		erofs_dbg("\tdev: %d %d", major(inode->u.i_rdev),
-			  minor(inode->u.i_rdev));
+		erofs_dbg("\tdev: %d %d", erofs_os_major(inode->u.i_rdev),
+			  erofs_os_minor(inode->u.i_rdev));
 		inode->u.i_rdev = erofs_new_encode_dev(inode->u.i_rdev);
 		break;
 	case S_IFDIR:
@@ -577,7 +577,7 @@ static int erofs_rebuild_basedir_dirent_iter(struct erofs_dir_context *ctx)
 	if (ctx->dot_dotdot)
 		return 0;
 
-	dname = strndup(ctx->dname, ctx->de_namelen);
+	dname = erofs_os_strndup(ctx->dname, ctx->de_namelen);
 	if (!dname)
 		return -ENOMEM;
 	d = erofs_rebuild_get_dentry(mergedir, dname, false,
diff --git a/lib/remotes/docker_config.c b/lib/remotes/docker_config.c
index 8e236fc..3450014 100644
--- a/lib/remotes/docker_config.c
+++ b/lib/remotes/docker_config.c
@@ -62,11 +62,11 @@ static char *docker_config_path(void)
 static char *read_file_to_string(const char *path)
 {
 	FILE *fp;
-	struct stat st;
+	erofs_os_stat_t st;
 	char *buf;
 	size_t nread;
 
-	if (stat(path, &st) < 0)
+	if (erofs_os_stat(path, &st) < 0)
 		return NULL;
 
 	if (st.st_size <= 0 || st.st_size > (1 << 22))
diff --git a/lib/remotes/oci.c b/lib/remotes/oci.c
index 24d3902..e485c48 100644
--- a/lib/remotes/oci.c
+++ b/lib/remotes/oci.c
@@ -314,7 +314,7 @@ static int ocierofs_parse_auth_header(const char *auth_header,
 			continue;
 
 		len = param_end - param_start;
-		value = strndup(param_start, len);
+		value = erofs_os_strndup(param_start, len);
 		if (!value) {
 			ret = -ENOMEM;
 			goto out;
@@ -891,7 +891,8 @@ static int ocierofs_process_tar_stream(struct erofs_importer *importer, int fd,
 	} while (!ret);
 
 	if (decoder == EROFS_IOS_DECODER_GZRAN) {
-		zinfo_fd = open(config->zinfo_path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
+		zinfo_fd = erofs_os_open(config->zinfo_path,
+					 O_WRONLY | O_CREAT | O_TRUNC, 0644);
 		if (zinfo_fd < 0) {
 			ret = -errno;
 		} else {
@@ -1065,7 +1066,7 @@ static int ocierofs_parse_ref(struct ocierofs_ctx *ctx, const char *ref_str)
 		/* a dot or colon before the slash indicating a registry */
 		if ((dot && dot < slash) || (colon && colon < slash)) {
 			len = slash - ref_str;
-			tmp = strndup(ref_str, len);
+			tmp = erofs_os_strndup(ref_str, len);
 			if (!tmp)
 				return -ENOMEM;
 			free(ctx->registry);
@@ -1081,7 +1082,7 @@ static int ocierofs_parse_ref(struct ocierofs_ctx *ctx, const char *ref_str)
 	colon = strchr(repo_part, ':');
 	if (colon) {
 		len = colon - repo_part;
-		tmp = strndup(repo_part, len);
+		tmp = erofs_os_strndup(repo_part, len);
 	} else {
 		tmp = strdup(repo_part);
 	}
@@ -1259,7 +1260,7 @@ static int ocierofs_extract_layer(struct ocierofs_ctx *ctx,
 
 	stream = (struct ocierofs_stream) {
 		.digest = digest,
-		.blobfd = erofs_tmpfile(),
+		.blobfd = erofs_os_tmpfile(),
 	};
 	if (stream.blobfd < 0) {
 		erofs_err("failed to create temporary file for %s", digest);
diff --git a/lib/remotes/s3.c b/lib/remotes/s3.c
index 6baaa73..d0f69cf 100644
--- a/lib/remotes/s3.c
+++ b/lib/remotes/s3.c
@@ -56,7 +56,7 @@ static const char *s3erofs_parse_host(const char *endpoint, const char **schema)
 	} else {
 		host = split + sizeof("://") - 1;
 		if (schema) {
-			*schema = strndup(endpoint, host - endpoint);
+			*schema = erofs_os_strndup(endpoint, host - endpoint);
 			if (!*schema)
 				return ERR_PTR(-ENOMEM);
 		}
@@ -962,7 +962,7 @@ s3erofs_create_object_iterator(struct erofs_s3 *s3, const char *path,
 			ret = -EINVAL;
 			goto err;
 		}
-		iter->bucket = strndup(path, prefix - path);
+		iter->bucket = erofs_os_strndup(path, prefix - path);
 		iter->prefix = strdup(prefix);
 	}
 
@@ -1127,7 +1127,7 @@ int s3erofs_build_trees(struct erofs_importer *im, struct erofs_s3 *s3,
 	struct s3erofs_object_info *obj;
 	struct erofs_dentry *d;
 	struct erofs_inode *inode;
-	struct stat st;
+	erofs_os_stat_t st;
 	char *trimmed;
 	bool dumb;
 	int ret;
@@ -1431,17 +1431,17 @@ err_free:
 int s3erofs_parse_s3fs_passwd(const char *filepath, char *ak, char *sk)
 {
 	char buf[S3_ACCESS_KEY_LEN + S3_SECRET_KEY_LEN + 3];
-	struct stat st;
+	erofs_os_stat_t st;
 	int fd, n, ret;
 	char *colon;
 
-	fd = open(filepath, O_RDONLY);
+	fd = erofs_os_open(filepath, O_RDONLY);
 	if (fd < 0) {
 		erofs_err("failed to open passwd_file %s", filepath);
 		return -errno;
 	}
 
-	ret = fstat(fd, &st);
+	ret = erofs_os_fstat(fd, &st);
 	if (ret) {
 		ret = -errno;
 		goto err;
diff --git a/lib/super.c b/lib/super.c
index 71b9f4f..5cb9016 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -500,7 +500,7 @@ int erofs_mkfs_format_fs(struct erofs_sb_info *sbi, unsigned int blkszbits,
 int erofs_mkfs_load_fs(struct erofs_sb_info *sbi, unsigned int dsunit)
 {
 	union {
-		struct stat st;
+		erofs_os_stat_t st;
 		erofs_blk_t startblk;
 	} u;
 	struct erofs_bufmgr *bmgr;
diff --git a/lib/tar.c b/lib/tar.c
index 83b3115..75a5752 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -759,7 +759,7 @@ static int tarerofs_write_file_data(struct erofs_inode *inode,
 				nread = -EIO;
 			break;
 		}
-		if (pwrite(fd, buf, nread, off) != nread) {
+		if (erofs_os_pwrite(fd, buf, nread, off) != nread) {
 			nread = -EIO;
 			break;
 		}
@@ -779,7 +779,7 @@ int tarerofs_parse_tar(struct erofs_importer *im, struct erofs_tarfile *tar)
 	struct erofs_inode *root = im->root;
 	bool whout, opq, e = false;
 	char _path[PATH_MAX + 1], *path = _path + 1;
-	struct stat st;
+	erofs_os_stat_t st;
 	mode_t mode;
 	erofs_off_t tar_offset, dataoff;
 
@@ -1044,10 +1044,10 @@ out_eot:
 			goto out;
 		}
 
-		st.st_rdev = makedev(major, minor);
+		st.st_rdev = erofs_os_makedev(major, minor);
 	} else if (th->typeflag == '1' || th->typeflag == '2') {
 		if (!eh.link)
-			eh.link = strndup(th->linkname, sizeof(th->linkname));
+			eh.link = erofs_os_strndup(th->linkname, sizeof(th->linkname));
 	}
 
 	/* EROFS metadata index referring to the original tar data */
diff --git a/lib/uuid.c b/lib/uuid.c
index 3b1bd38..e2f7298 100644
--- a/lib/uuid.c
+++ b/lib/uuid.c
@@ -20,8 +20,10 @@
 #else
 #define _GNU_SOURCE
 #include <unistd.h>
+#ifdef __linux__
 #include <sys/syscall.h>
 #endif
+#endif
 
 /* Flags to be used, will be modified if kernel does not support them */
 static unsigned int erofs_grnd_flag =
@@ -43,6 +45,9 @@ static int s_getrandom(void *out, unsigned size, bool insecure)
 
 #if defined(HAVE_SYS_RANDOM_H) && defined(HAVE_GETRANDOM)
 		r = getrandom(out, size, flags);
+#elif defined(_WIN32)
+		(void)flags;
+		r = erofs_win_random(out, size);
 #elif defined(__linux__) && defined(__NR_getrandom)
 		r = (ssize_t)syscall(__NR_getrandom, out, size, flags);
 #else
diff --git a/lib/windows_compat.c b/lib/windows_compat.c
new file mode 100644
index 0000000..f998f21
--- /dev/null
+++ b/lib/windows_compat.c
@@ -0,0 +1,308 @@
+// SPDX-License-Identifier: GPL-2.0+ OR MIT
+#include <config.h>
+#include "erofs/os.h"
+#include <bcrypt.h>
+#include <string.h>
+
+static int erofs_err_win_to_posix(DWORD error)
+{
+	switch (error) {
+	case ERROR_FILE_NOT_FOUND:
+	case ERROR_PATH_NOT_FOUND:
+		return ENOENT;
+	case ERROR_ACCESS_DENIED:
+	case ERROR_SHARING_VIOLATION:
+		return EACCES;
+	case ERROR_INVALID_HANDLE:
+		return EBADF;
+	case ERROR_NOT_ENOUGH_MEMORY:
+	case ERROR_OUTOFMEMORY:
+		return ENOMEM;
+	case ERROR_DISK_FULL:
+		return ENOSPC;
+	case ERROR_INVALID_PARAMETER:
+		return EINVAL;
+	case ERROR_FILE_EXISTS:
+	case ERROR_ALREADY_EXISTS:
+		return EEXIST;
+	case ERROR_DIRECTORY:
+		return ENOTDIR;
+	default:
+		return EIO;
+	}
+}
+
+int erofs_win_unsupported(void)
+{
+	errno = EOPNOTSUPP;
+	return -1;
+}
+
+/*
+ * The unit of FILETIME is 100-nanoseconds since January 1, 1601, UTC.
+ * Returns the 100-nanoseconds ("hekto nanoseconds") since the epoch.
+ */
+static inline long long filetime_to_hnsec(const FILETIME *ft)
+{
+	long long winTime = ((long long)ft->dwHighDateTime << 32) +
+			   ft->dwLowDateTime;
+
+	/* Windows to Unix Epoch conversion */
+	return winTime - 116444736000000000LL;
+}
+
+static inline void filetime_to_timespec(const FILETIME *ft, struct timespec *ts)
+{
+	long long hnsec = filetime_to_hnsec(ft);
+
+	ts->tv_sec = (time_t)(hnsec / 10000000);
+	ts->tv_nsec = (hnsec % 10000000) * 100;
+}
+
+static int erofs_win_handle_stat(HANDLE h, erofs_os_stat_t *st)
+{
+	BY_HANDLE_FILE_INFORMATION info;
+	DWORD type = GetFileType(h);
+
+	if (type == FILE_TYPE_PIPE || type == FILE_TYPE_CHAR) {
+		memset(st, 0, sizeof(*st));
+		st->st_mode = (type == FILE_TYPE_PIPE ? S_IFIFO : S_IFCHR) | 0600;
+		st->st_blksize = 4096;
+		return 0;
+	}
+
+	if (!GetFileInformationByHandle(h, &info)) {
+		errno = erofs_err_win_to_posix(GetLastError());
+		return -1;
+	}
+	memset(st, 0, sizeof(*st));
+	st->st_dev = info.dwVolumeSerialNumber;
+	st->st_ino = ((uint64_t)info.nFileIndexHigh << 32) | info.nFileIndexLow;
+	st->st_nlink = info.nNumberOfLinks;
+	st->st_size = ((uint64_t)info.nFileSizeHigh << 32) | info.nFileSizeLow;
+	st->st_mode = (info.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) ?
+		S_IFDIR | 0755 : S_IFREG | 0644;
+	if (info.dwFileAttributes & FILE_ATTRIBUTE_READONLY)
+		st->st_mode &= ~0222;
+	filetime_to_timespec(&info.ftLastAccessTime, &st->st_atim);
+	filetime_to_timespec(&info.ftLastWriteTime, &st->st_mtim);
+	filetime_to_timespec(&info.ftCreationTime, &st->st_ctim);
+	st->st_blksize = 4096;
+	st->st_blocks = (st->st_size + 511) / 512;
+	return 0;
+}
+
+int erofs_os_stat(const char *path, erofs_os_stat_t *st)
+{
+	HANDLE h;
+	int ret;
+
+	h = CreateFileA(path, FILE_READ_ATTRIBUTES,
+		FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, NULL,
+		OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS, NULL);
+	if (h == INVALID_HANDLE_VALUE) {
+		errno = erofs_err_win_to_posix(GetLastError());
+		return -1;
+	}
+	ret = erofs_win_handle_stat(h, st);
+	CloseHandle(h);
+	return ret;
+}
+
+int erofs_os_fstat(int fd, erofs_os_stat_t *st)
+{
+	return erofs_win_handle_stat((HANDLE)_get_osfhandle(fd), st);
+}
+
+int erofs_os_lstat(const char *path, erofs_os_stat_t *st)
+{
+	DWORD attr = GetFileAttributesA(path);
+
+	if (attr == INVALID_FILE_ATTRIBUTES) {
+		errno = erofs_err_win_to_posix(GetLastError());
+		return -1;
+	}
+	/* Do not follow junctions or symbolic links while walking a source tree. */
+	if (attr & FILE_ATTRIBUTE_REPARSE_POINT)
+		return erofs_win_unsupported();
+	return erofs_os_stat(path, st);
+}
+
+int erofs_os_open(const char *path, int flags, ...)
+{
+	DWORD access = GENERIC_READ, creation = OPEN_EXISTING;
+	HANDLE h;
+	int fd;
+
+	if ((flags & O_ACCMODE) == O_WRONLY)
+		access = GENERIC_WRITE;
+	else if ((flags & O_ACCMODE) == O_RDWR)
+		access |= GENERIC_WRITE;
+	if (flags & O_CREAT)
+		creation = flags & O_EXCL ? CREATE_NEW : OPEN_ALWAYS;
+	h = CreateFileA(path, access,
+		FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, NULL,
+		creation, flags & O_NOFOLLOW ? FILE_FLAG_OPEN_REPARSE_POINT : 0,
+		NULL);
+	if (h == INVALID_HANDLE_VALUE) {
+		errno = erofs_err_win_to_posix(GetLastError());
+		return -1;
+	}
+	if (flags & O_NOFOLLOW) {
+		BY_HANDLE_FILE_INFORMATION info;
+
+		if (!GetFileInformationByHandle(h, &info)) {
+			DWORD error = GetLastError();
+
+			CloseHandle(h);
+			errno = erofs_err_win_to_posix(error);
+			return -1;
+		}
+		if (info.dwFileAttributes & FILE_ATTRIBUTE_REPARSE_POINT) {
+			CloseHandle(h);
+			errno = ELOOP;
+			return -1;
+		}
+	}
+	if ((flags & O_TRUNC) && !SetEndOfFile(h)) {
+		DWORD error = GetLastError();
+
+		CloseHandle(h);
+		errno = erofs_err_win_to_posix(error);
+		return -1;
+	}
+	fd = _open_osfhandle((intptr_t)h,
+		(flags & (O_ACCMODE | O_APPEND)) | O_BINARY);
+	if (fd < 0)
+		CloseHandle(h);
+	return fd;
+}
+
+int erofs_os_link(const char *oldpath, const char *newpath)
+{
+	if (CreateHardLinkA(newpath, oldpath, NULL))
+		return 0;
+	errno = erofs_err_win_to_posix(GetLastError());
+	return -1;
+}
+
+static ssize_t erofs_win_pio(int fd, void *buf, size_t len, off_t offset,
+			    int writing)
+{
+	OVERLAPPED ov = { .Offset = (DWORD)offset,
+			  .OffsetHigh = (DWORD)((uint64_t)offset >> 32) };
+	DWORD done = 0, error = ERROR_SUCCESS;
+	HANDLE h = (HANDLE)_get_osfhandle(fd);
+	BOOL ok;
+
+	if (offset < 0) {
+		errno = EINVAL;
+		return -1;
+	}
+	if (h == INVALID_HANDLE_VALUE)
+		return -1;
+	if (len > INT_MAX)
+		len = INT_MAX;
+	ok = writing ? WriteFile(h, buf, len, &done, &ov) :
+		       ReadFile(h, buf, len, &done, &ov);
+	if (!ok)
+		error = GetLastError();
+	if (error == ERROR_HANDLE_EOF)
+		return 0;
+	if (error) {
+		errno = erofs_err_win_to_posix(error);
+		return -1;
+	}
+	return done;
+}
+
+ssize_t erofs_os_pread(int fd, void *buf, size_t len, off_t offset)
+{
+	return erofs_win_pio(fd, buf, len, offset, 0);
+}
+
+ssize_t erofs_os_pwrite(int fd, const void *buf, size_t len, off_t offset)
+{
+	return erofs_win_pio(fd, (void *)buf, len, offset, 1);
+}
+
+char *erofs_os_realpath(const char *path, char *resolved)
+{
+	char *p = _fullpath(resolved, path, resolved ? _MAX_PATH : 0);
+	char *s;
+
+	if (p)
+		for (s = p; *s; ++s)
+			if (*s == '\\')
+				*s = '/';
+	return p;
+}
+
+char *erofs_os_strndup(const char *s, size_t len)
+{
+	char *p;
+
+	len = strnlen(s, len);
+	p = malloc(len + 1);
+	if (p) {
+		memcpy(p, s, len);
+		p[len] = '\0';
+	}
+	return p;
+}
+
+int erofs_win_random(void *buf, unsigned int len)
+{
+	if (BCryptGenRandom(NULL, buf, len, BCRYPT_USE_SYSTEM_PREFERRED_RNG)) {
+		errno = EIO;
+		return -1;
+	}
+	return len;
+}
+
+int erofs_os_tmpfile(void)
+{
+	char path[MAX_PATH], name[MAX_PATH];
+	HANDLE h;
+	DWORD len;
+	int fd;
+
+	len = GetTempPathA(sizeof(path), path);
+	if (!len) {
+		errno = erofs_err_win_to_posix(GetLastError());
+		return -errno;
+	}
+	if (len >= sizeof(path)) {
+		errno = ENAMETOOLONG;
+		return -errno;
+	}
+	if (!GetTempFileNameA(path, "ero", 0, name)) {
+		errno = erofs_err_win_to_posix(GetLastError());
+		return -errno;
+	}
+	h = CreateFileA(name, GENERIC_READ | GENERIC_WRITE,
+		FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, NULL,
+		OPEN_EXISTING, FILE_ATTRIBUTE_TEMPORARY |
+		FILE_FLAG_DELETE_ON_CLOSE, NULL);
+	if (h == INVALID_HANDLE_VALUE) {
+		DWORD error = GetLastError();
+
+		DeleteFileA(name);
+		errno = erofs_err_win_to_posix(error);
+		return -errno;
+	}
+	fd = _open_osfhandle((intptr_t)h, O_RDWR | O_BINARY);
+	if (fd < 0) {
+		CloseHandle(h);
+		return -errno;
+	}
+	return fd;
+}
+
+int erofs_os_getpagesize(void)
+{
+	SYSTEM_INFO info;
+
+	GetSystemInfo(&info);
+	return info.dwPageSize;
+}
diff --git a/lib/xattr.c b/lib/xattr.c
index 75a4d0c..4b68a61 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -792,7 +792,7 @@ static int erofs_count_all_xattrs_from_path(struct erofs_sb_info *sbi,
 {
 	int ret;
 	DIR *_dir;
-	struct stat st;
+	erofs_os_stat_t st;
 
 	_dir = opendir(path);
 	if (!_dir) {
@@ -826,7 +826,7 @@ static int erofs_count_all_xattrs_from_path(struct erofs_sb_info *sbi,
 			goto fail;
 		}
 
-		ret = lstat(buf, &st);
+		ret = erofs_os_lstat(buf, &st);
 		if (ret) {
 			ret = -errno;
 			goto fail;
@@ -1207,7 +1207,8 @@ static int erofs_init_inode_xattrs(struct erofs_inode *vi)
 
 	ih = it.kaddr;
 	vi->xattr_shared_count = ih->h_shared_count;
-	vi->xattr_shared_xattrs = malloc(vi->xattr_shared_count * sizeof(uint));
+	vi->xattr_shared_xattrs = malloc(vi->xattr_shared_count *
+					 sizeof(*vi->xattr_shared_xattrs));
 	if (!vi->xattr_shared_xattrs) {
 		erofs_put_metabuf(&it.buf);
 		return -ENOMEM;
diff --git a/mkfs/main.c b/mkfs/main.c
index 93123c1..f75225b 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -657,7 +657,7 @@ static int mkfs_parse_s3_cfg(char *cfg_str)
 
 	p = strchr(cfg_str, ',');
 	if (p) {
-		s3cfg.endpoint = strndup(cfg_str, p - cfg_str);
+		s3cfg.endpoint = erofs_os_strndup(cfg_str, p - cfg_str);
 	} else {
 		s3cfg.endpoint = strdup(cfg_str);
 		return 0;
@@ -698,7 +698,7 @@ static int mkfs_parse_s3_cfg(char *cfg_str)
 		} else if ((p = strstr(opt, "region="))) {
 			p += strlen("region=");
 			opt = strchr(cfg_str, ',');
-			s3cfg.region = opt ? strndup(p, opt - p) : strdup(p);
+			s3cfg.region = opt ? erofs_os_strndup(p, opt - p) : strdup(p);
 		} else {
 			erofs_err("invalid --s3 option %s", opt);
 			return -EINVAL;
@@ -742,7 +742,7 @@ static int erofs_mkfs_strtoll(const char *nptr, char **endptr,
 static int erofs_mkfs_strtol(const char *nptr, char **endptr,
 			     long *res, int base)
 {
-	long long res_ll;
+	long long res_ll = 0;
 	int ret;
 
 	ret = erofs_mkfs_strtoll(nptr, endptr, &res_ll, base);
@@ -966,20 +966,20 @@ static void erofs_rebuild_cleanup(void)
 
 static int mkfs_parse_sources(int argc, char *argv[], int optind)
 {
-	struct stat st;
+	erofs_os_stat_t st;
 	int err, fd;
 	char *s;
 
 	switch (source_mode) {
 	case EROFS_MKFS_SOURCE_LOCALDIR:
-		err = lstat((s = argv[optind++]), &st);
+		err = erofs_os_lstat((s = argv[optind++]), &st);
 		if (err) {
 			erofs_err("failed to stat %s: %s", s,
 				  erofs_strerror(-errno));
 			return -ENOENT;
 		}
 		if (S_ISDIR(st.st_mode)) {
-			cfg.c_src_path = realpath(s, NULL);
+			cfg.c_src_path = erofs_os_realpath(s, NULL);
 			if (!cfg.c_src_path) {
 				erofs_err("failed to parse source directory: %s",
 					  erofs_strerror(-errno));
@@ -997,7 +997,7 @@ static int mkfs_parse_sources(int argc, char *argv[], int optind)
 		cfg.c_src_path = strdup(argv[optind++]);
 		if (!cfg.c_src_path)
 			return -ENOMEM;
-		fd = open(cfg.c_src_path, O_RDONLY);
+		fd = erofs_os_open(cfg.c_src_path, O_RDONLY);
 		if (fd < 0) {
 			erofs_err("failed to open tar file: %s", cfg.c_src_path);
 			return -errno;
@@ -1008,8 +1008,8 @@ static int mkfs_parse_sources(int argc, char *argv[], int optind)
 			return err;
 
 		if (erofstar.dumpfile) {
-			fd = open(erofstar.dumpfile,
-				  O_WRONLY | O_CREAT | O_TRUNC, 0644);
+			fd = erofs_os_open(erofstar.dumpfile,
+					   O_WRONLY | O_CREAT | O_TRUNC, 0644);
 			if (fd < 0) {
 				erofs_err("failed to open dumpfile: %s",
 					  erofstar.dumpfile);
@@ -1624,7 +1624,8 @@ static void erofs_mkfs_default_options(struct erofs_importer_params *params)
 	cfg.c_mt_workers = erofs_get_available_processors();
 	cfg.c_mkfs_segment_size = 16ULL * 1024 * 1024;
 #endif
-	mkfs_blkszbits = ilog2(min_t(u32, getpagesize(), EROFS_MAX_BLOCK_SIZE));
+	mkfs_blkszbits = ilog2(min_t(u32, erofs_os_getpagesize(),
+				    EROFS_MAX_BLOCK_SIZE));
 	params->pclusterblks_max = 1U;
 	params->pclusterblks_def = 1U;
 	g_sbi.feature_incompat = 0;
@@ -2091,7 +2092,8 @@ exit:
 			struct erofs_vfile vf;
 			int fd;
 
-			fd = open(mkfs_aws_zinfo_file, O_WRONLY | O_CREAT | O_TRUNC, 0644);
+			fd = erofs_os_open(mkfs_aws_zinfo_file,
+					   O_WRONLY | O_CREAT | O_TRUNC, 0644);
 			if (fd < 0) {
 				err = -errno;
 			} else {
diff --git a/scripts/msys2-ucrt64.sha256 b/scripts/msys2-ucrt64.sha256
new file mode 100644
index 0000000..d66dd6f
--- /dev/null
+++ b/scripts/msys2-ucrt64.sha256
@@ -0,0 +1,17 @@
+e3257d4303fc0aca4c64f702d4c8cd766a321351c5e61927631c30bfdf2e7536  mingw-w64-ucrt-x86_64-brotli-1.2.1-1-any.pkg.tar.zst
+a95c349e1a838a825d4c6723c0fc497ae62d7ca9fe68b517552fd80afa5cd5f1  mingw-w64-ucrt-x86_64-c-ares-1.34.9-1-any.pkg.tar.zst
+d96afb79b32b3831f98929762a2b2eb4177e6859db0b348e10551893f755de76  mingw-w64-ucrt-x86_64-curl-winssl-8.23.0-1-any.pkg.tar.zst
+ba693dda4ac375af76ce481ff3a6e7481286546cc7dc6d56c7021dae34084157  mingw-w64-ucrt-x86_64-gettext-runtime-1.0-1-any.pkg.tar.zst
+e209dfd2e0955a9ab22bf394b13d477b2d24ae2660327e3981651efd464be0d5  mingw-w64-ucrt-x86_64-json-c-0.19-2-any.pkg.tar.zst
+9a500f38c2b91808741c62fae746b3e9110b33a1ecf5c30fa0c66dbedddf7e16  mingw-w64-ucrt-x86_64-libiconv-1.19-1-any.pkg.tar.zst
+d5f4b5e9d99ff7b2a986d1dc0c73da2bcd93ba68462be7b1debbd6ef76371f57  mingw-w64-ucrt-x86_64-libidn2-2.3.8-4-any.pkg.tar.zst
+d96e0bb50ac3f8b6e44a39ea8de8d186f7b08f6938b0676eb69a7ba1f127bcf4  mingw-w64-ucrt-x86_64-libpsl-0.21.5-3-any.pkg.tar.zst
+26710b6978533c38b60a33762e99128bd74f8520896bb9486656e4aa741bbe5b  mingw-w64-ucrt-x86_64-libssh2-wincng-1.11.1-2-any.pkg.tar.zst
+d50f22545c50d7c0cd584474bba83f0c7a2cd8aab1aed1ad6c1f9c6452f3c4fc  mingw-w64-ucrt-x86_64-libtre-0.9.0-2-any.pkg.tar.zst
+e784273da19bbdcc91cbb510b5e27c3ac021b026140734eefcce5ccbd878bd97  mingw-w64-ucrt-x86_64-libunistring-1.4.2-1-any.pkg.tar.zst
+e774c85139c004ce9b4085474d6b3450526c718d2e8c555a87e47adc11f376b1  mingw-w64-ucrt-x86_64-libxml2-2.15.4-3-any.pkg.tar.zst
+00a807df81a4b7e82445178b8625962ed592cf1f0a08a8e04c8b9338c4362638  mingw-w64-ucrt-x86_64-lz4-1.10.0-1-any.pkg.tar.zst
+773e021ebad83f14b5c103db467411e8ff064663e1c7e7f730e2be72f4117064  mingw-w64-ucrt-x86_64-openssl-3.6.5-1-any.pkg.tar.zst
+a9d771f816d8c0c5bde152ffb27a687ede91079b8e77e5b8297efa3b5a835934  mingw-w64-ucrt-x86_64-xz-5.8.4-1-any.pkg.tar.zst
+130e6ef04c654fc2150a177600aa5ed0035087665a893479d2c85ba7485d5704  mingw-w64-ucrt-x86_64-zlib-1.3.2-3-any.pkg.tar.zst
+dbdb8427280046a2b41697780aa4c52983b708082b0da4755951dc3bea96ca89  mingw-w64-ucrt-x86_64-zstd-1.5.7-2-any.pkg.tar.zst
-- 
2.54.0 (Apple Git-157)


