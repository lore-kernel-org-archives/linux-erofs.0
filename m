Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A4A606A334
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Nov 2026 04:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=XXiYKJN/
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jKBqj02h3z2xB1;
	Wed, 04 Nov 2026 15:12:49 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=156.224.81.201
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793765568;
	cv=none; b=hpVSGXeLqr3KlXBDcB0zV6ioZt7dYfcaFHi/evM8t5Pz5KDeTwf8K0Eu/0bwjgxXTbgRdIAWGjs8si8nh00sbPI3um5StczCrVPyfjAfBl+vw/p3fW3Nlf49pIjEV2Axr4Vd0bm7kesCNSXW+ZAkjmlbZqntRFk5039dPC/l/39iy9BtNaBU1/BMYLaqBSpyEoEmXQy+FxWt2NVO+okew3ihFpz8BowU5WSbf3Ufrma8Z+fXwSt2XRBgOvvBjTm4n40X+AjKF7Xs2y4TvHfhWJp8Z1jbEL92Cn3qlUKxNl+1EzMqVFvmK2IMyMq0555l2iSoUDjpTZ4AhARrxktO/w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793765568; c=relaxed/relaxed;
	bh=dfoFO12FmzzLrXk/obllxLJsRWbX8H5jvqhQwbEJo0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bi2f9vHfwFKMp+x0/PHGtf47HEdzjjmqDNyxK80/pyU4UyI4KPlRQkXr/vlkXhFOA9FLfFU0TCHZM+pFCIvmaKNPXirqpeV8KjVzKdchhBhBbFFwH4CAlg0aMmpWoXxFnC/4p3WCveHUBIBXCRR9nc35OaWZGJSQo0GbniZE024NOhlRHkwvHLo5XAPluJwCjUqDeFr3CnH9lbsMEBVanSOheJbNn0j0bNJJXC3zlbsve8os8NGV4O5/sNI6fRFjw+ukuQ0t6Zi4JiTK8zEWZYmuGO1gjJmBFvT1bdqtJ81e9aLFzAKsiFJQTbfQLCG6kyWMUD9ben7CgsxoQ7Pczw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=XXiYKJN/; dkim-atps=neutral; spf=pass (client-ip=156.224.81.201; helo=mail-m81201.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org) smtp.mailfrom=deepseek.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=XXiYKJN/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=deepseek.com (client-ip=156.224.81.201; helo=mail-m81201.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org)
Received: from mail-m81201.xmail.ntesmail.com (mail-m81201.xmail.ntesmail.com [156.224.81.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jKBqd3HS7z2xdb
	for <linux-erofs@lists.ozlabs.org>; Wed, 04 Nov 2026 15:12:45 +1100 (AEDT)
Received: from localhost.localdomain (unknown [124.243.154.173])
	by smtp.qiye.163.com (Hmail) with ESMTP id 536bdc6f5;
	Wed, 4 Nov 2026 12:07:39 +0800 (GMT+08:00)
From: Wenyuan Xu <sereno.xu@deepseek.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: sereno.xu@deepseek.com
Subject: [RFC 6/7] erofs-utils: man: document manifest input formats
Date: Wed,  4 Nov 2026 04:07:24 +0000
Message-ID: <20261104040725.2473313-7-sereno.xu@deepseek.com>
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
X-HM-Tid: 0aa1a4bdb8de03a3kunma3fc75f17e09c
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaGhhKVhlLGUtJGUgYTR0aQlYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU9VSU9IVUpOT1VKTEhZV1kWGg8SFR0UWUFZT0tIVU
	pLSUJDQ0xVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=XXiYKJN/VVE5El5AAKQX4inCKYXiNupd7ZeQGKoY0vuSCx60P5C+gK/wWmzNidChA3eShLjTSzcsjG1kWL9mygEYA6UE0NRjtEgWobXGcMLf0rtHGfrcYcW9LmpyLGAGzDmfjdQCqOvbrl5ZjQ7ECNwoBrwtY6Vy13BG0fNmC48=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=dfoFO12FmzzLrXk/obllxLJsRWbX8H5jvqhQwbEJo0w=;
	h=date:mime-version:subject:message-id:from;
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Document complete and two-field manifest records, path handling,
metadata policies, hard links and shared xattrs.

Assisted-by: LLM
Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
---
 man/mkfs.erofs.1 | 114 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/man/mkfs.erofs.1 b/man/mkfs.erofs.1
index 65ec807..a694676 100644
--- a/man/mkfs.erofs.1
+++ b/man/mkfs.erofs.1
@@ -32,6 +32,10 @@ other EROFS image(s), see \fIREBUILD MODE\fR below
 .RE
 .SH OPTIONS
 .TP
+.BI "\-\-manifest=" FILE
+Build an image from a manifest and a base directory.
+See \fIMANIFEST INPUT MODE\fR below.
+.TP
 .BI "\-b " block-size
 Set the fundamental block size of the filesystem in bytes.  In other words,
 specify the smallest amount of data that can be accessed at a time.  The
@@ -224,6 +228,9 @@ The current source-specific support for \fIMODE\fR:
 .I Local directory source
 Only \fBdata\fR is supported. \fBrvsp\fR and \fB0\fR will be ignored.
 .TP
+.I Manifest source (\fB\-\-manifest\fR)
+\fBdata\fR is supported with both complete and short records.
+.TP
 .I Tar source (\fB\-\-tar\fR)
 \fBdata\fR and \fBrvsp\fR are supported. \fB0\fR will be ignored.
 Note that \fBrvsp\fR takes precedence over \fB--tar=i\fR or \fB--tar=headerball\fR.
@@ -331,6 +338,11 @@ The current source-specific support for \fIMODE\fR:
 .I Local directory source
 Only \fBdata\fR is supported. \fBrvsp\fR and \fB0\fR will be ignored.
 .TP
+.I Manifest source (\fB\-\-manifest\fR)
+\fBdata\fR is supported with both complete and short records.
+See \fIMANIFEST INPUT MODE\fR below for incremental usage and parent
+directory requirements.
+.TP
 .I Tar source (\fB\-\-tar\fR)
 \fBdata\fR and \fBrvsp\fR are supported. \fB0\fR will be ignored.
 Note that \fBrvsp\fR takes precedence over \fB--tar=i\fR or \fB--tar=headerball\fR.
@@ -497,6 +509,108 @@ Display help string and exit.
 .TP
 \fB\-V\fR, \fB\-\-version\fR
 Print the version number and exit.
+.SH MANIFEST INPUT MODE
+With \fB--manifest=FILE\fR, \fISOURCE\fR is a base directory supplying backing
+files.  The manifest defines the image tree for a clean build, or the update
+tree for an incremental build; source directories are not recursively scanned.
+Two record formats may be mixed in the same file:
+.PP
+.nf
+PATH PAYLOAD
+PATH PAYLOAD SIZE MODE UID GID RDEV MTIME [KEY=VALUE ...]
+.fi
+.PP
+Exactly two fields select the short format.  Three through seven fields are
+invalid.  Eight or more fields select the complete format.
+.PP
+Both formats support regular file compression with \fB-z\fR, using the same
+compression options as local-directory input.  Without \fB-z\fR, regular file
+data is stored uncompressed.
+.PP
+In the short format, PAYLOAD is a backing path beginning with /, appended
+directly to SOURCE after decoding.  Repeated slashes and . or .. components
+are resolved by the host filesystem.  A directory record imports only that
+directory, not its children.
+.PP
+The field descriptions below apply to complete records unless noted.
+.PP
+Records are separated by newlines; the last newline is optional.  Blank records
+and comments are not supported.  Unused fields require a nonempty placeholder
+('-' is preferred as a placeholder) but are not parsed.
+.PP
+In both formats, PATH names an image entry and must begin with /.  The first record
+must define the root directory.  Every parent directory must precede its children,
+and duplicate paths are errors.  Repeated and trailing slashes in PATH are skipped.
+Individual . and .. components are forbidden.
+.TP
+.B Regular files
+PAYLOAD begins with / and is interpreted relative to the base directory, not
+the host root.  The decoded PAYLOAD is appended directly to the base directory;
+repeated slashes and . or .. components are resolved by the host filesystem,
+as are symlinks.  The source must be a regular file whose size
+exactly equals SIZE, including for empty files.  RDEV is unused.
+.TP
+.B Directories
+SIZE, PAYLOAD and RDEV are unused.  A record describes only the directory itself;
+its size is computed from the generated directory entries.
+.TP
+.B Symbolic links
+PAYLOAD is the link content; repeated slashes are preserved.
+SIZE must equal its decoded byte length.  RDEV is unused.
+.TP
+.B Hard links
+A MODE beginning with @ denotes a hard link.  PATH creates the new entry and
+PAYLOAD names an already defined non-directory entry in the image.  Only the
+leading @ in MODE is examined; all other fields and xattrs are ignored.
+Hard links to earlier hard links are supported.
+Repeated and trailing slashes in PAYLOAD are skipped.
+An explicit @ hard link may refer to a previously defined short record.
+.TP
+.B Character/block devices, sockets and FIFOs
+SIZE and PAYLOAD are unused.  RDEV is the decimal value of stat.st_rdev;
+use zero for sockets and FIFOs.
+.PP
+MODE is an octal stat.st_mode, including file type bits; arbitrary leading zeros
+are accepted.  SIZE, UID, GID and RDEV are unsigned decimal integers within the
+supported ranges.  MTIME is nonnegative seconds.nanoseconds since the Unix
+epoch.  It is not a floating-point value: 1.1 means one second plus one nanosecond.
+Nanoseconds must be between 0 and 999999999.
+.PP
+PATH, used PAYLOAD fields and xattrs encode special bytes as \fB\exXY\fR,
+where XY is a two-digit hexadecimal byte, with either letter case accepted.
+For example, a space is \fB\ex20\fR and a backslash is \fB\ex5c\fR.
+An equals sign within an xattr key or value must be encoded as \fB\ex3d\fR;
+it may appear literally in PATH and PAYLOAD.
+NUL is forbidden in paths, symlink contents and xattr keys, but is permitted in
+xattr values.  Empty xattr values are supported.  Repeated keys within one record
+are rejected after decoding the keys.  Keys must use a supported EROFS xattr
+namespace and be at most 255 bytes; values must fit the on-disk 16-bit length field.
+Identical keys and values used by more than the \fB-x\fR threshold of distinct
+inodes are stored as shared xattrs.
+.PP
+For example, using data from \fIbasedir/source\fR:
+.PP
+.nf
+/ - - 40755 0 0 - 1.0
+/file /source 3 100644 1000 1000 - 1.1 user.note=hello\ex20world
+/link /file - @ - - - -
+/symlink file 4 120777 1000 1000 - 1.0
+.fi
+.PP
+.nf
+mkfs.erofs --manifest=manifest.txt out.erofs basedir
+.fi
+.PP
+Both formats support \fB--incremental=data\fR (or \fB--incremental\fR) with
+an existing image as DESTINATION and a backing directory as SOURCE:
+.PP
+.nf
+mkfs.erofs --incremental=data --manifest=updates.txt base.erofs updates/
+.fi
+.PP
+The manifest must still define the root directory first and each parent before
+its children, even when those directories already exist in the image.
+.PP
 .SH NOTES
 .TP
 .B REBUILD MODE
-- 
2.43.0


