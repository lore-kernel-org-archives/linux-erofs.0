Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319C2606A326
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Nov 2026 04:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=j/0k2TUJ
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jKBqd1r7Yz2xcB;
	Wed, 04 Nov 2026 15:12:45 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=47.251.158.134
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793765565;
	cv=none; b=bJX+yOR69piM2J/Eg1gQ+7n742ejRMf+jrvBDeINLDb+3Z/hPGPY+Ct3uEOENQua+KcYIZRXz1myHlYxut/LwyvFq1b3UnAnPWvq/t8xy0GkBxXo7DBQKn13B8G7pA53CSIbHeuTvjmePNU+HZ5gUushKZquAKwRktiahvU9OB6xDXiIeeh8h7LofoAQqF3Sdi1PpVSPHC00fQcgBTdptbdSP3joc5LRmF8Tx4XqazBI0dF85TTq6M2VUwfll6oKj63UGfNjf0Y0Tzl4s79erVymR4VMFOrUJZ9k35TDSurE0BvIDzRl8r3CFjyympgYcLs/QqR8tLpdeNbirmzOOA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793765565; c=relaxed/relaxed;
	bh=ybivg3PbgROGQMlDbNRdRU+SsCVtKenBJzfatC/zz2w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JVEGD4yfo1DWAGxKzO8fjQFEeC53b32VwXf7C+4pyU8TC1yTNvvqYYdIOSRLjpxhqplJWvbTZB+QE1qcvlFZ0iXpwy9u5I6FcGH3d3DdK1lOAcnZm4X3Gb+y/erTEqHvPMgXgdWmLphZZXmy76gboYHhx8VEGQOq7ui53SjpWbyNHzJzyyQ8T9E0WUGu0+FSwLei4KzGsnLkUYl4mqfyWtbTXiUISa0ocINz+GhjonwEI5lcms6I/lvOaQNhvMjbE8hh77UJkjn89uAeP9DFYwiGsl8kCCLMbQHV25gIrXTMYtAElGjuuDnjKQ8Senpd5qBzZo516z9UJfHVBdRq2Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=j/0k2TUJ; dkim-atps=neutral; spf=pass (client-ip=47.251.158.134; helo=mail-m158134.netease.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org) smtp.mailfrom=deepseek.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=j/0k2TUJ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=deepseek.com (client-ip=47.251.158.134; helo=mail-m158134.netease.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 304 seconds by postgrey-1.37 at boromir; Wed, 04 Nov 2026 15:12:41 AEDT
Received: from mail-m158134.netease.com (mail-m158134.netease.com [47.251.158.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jKBqY6VG7z2x9c
	for <linux-erofs@lists.ozlabs.org>; Wed, 04 Nov 2026 15:12:41 +1100 (AEDT)
Received: from localhost.localdomain (unknown [124.243.154.173])
	by smtp.qiye.163.com (Hmail) with ESMTP id 536bdc6cd;
	Wed, 4 Nov 2026 12:07:28 +0800 (GMT+08:00)
From: Wenyuan Xu <sereno.xu@deepseek.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: sereno.xu@deepseek.com
Subject: [RFC 0/7] erofs-utils: add manifest input support
Date: Wed,  4 Nov 2026 04:07:18 +0000
Message-ID: <20261104040725.2473313-1-sereno.xu@deepseek.com>
X-Mailer: git-send-email 2.43.0
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
X-HM-Tid: 0aa1a4bd8a4903a3kunma3fc75f17e02b
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaTEpIVh0aTUlLTU1CQxlCSVYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU9VSU9IVUpOT1VKTEhZV1kWGg8SFR0UWUFZS1VLVU
	tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=j/0k2TUJBOp40YcfN43Tji7z2VUZ8+evhyt4pNK+PNfYhN0CDKb86LUFbrnMsxbol5zxfFWjlec0croQwEtZF9des3WpM33RQQJf7fYe46/GuZ++qheyosa/i1QxI8F/gRxqWObR//JY3oEb2L18vavWbghEtlIaMB71AlPm9N4=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=ybivg3PbgROGQMlDbNRdRU+SsCVtKenBJzfatC/zz2w=;
	h=date:mime-version:subject:message-id:from;
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

This series adds manifest input support to mkfs.erofs. It lets callers
specify the image tree and metadata without first creating a matching
staging directory, while reading regular file contents from a backing
directory. Only entries listed in the manifest are imported; source
directories are not scanned recursively.

This series is based on origin/experimental-tests.

Usage:

  mkfs.erofs --manifest=manifest.txt out.erofs basedir/

The manifest accepts two record formats, which can be mixed:

  PATH PAYLOAD SIZE MODE UID GID RDEV MTIME [KEY=VALUE ...]
  PATH PAYLOAD

The complete record syntax is inspired by composefs's
"mkcomposefs --from-file" format, documented in composefs-dump(5) [1].
This series uses eight fixed fields with PAYLOAD immediately after PATH,
omitting the NLINK, CONTENT and DIGEST fields from the composefs format.

Complete records specify metadata and xattrs explicitly. Regular file
payloads identify backing files relative to basedir, symlink payloads
provide link contents, and a MODE beginning with @ creates a hard link
to an earlier entry. Fields unused for a file type are not parsed and
can be written as '-'.

Two-field records import metadata, contents and xattrs from the backing
file using local import policies. Symlinks are imported without
following their targets, and source hard links are preserved unless
--hard-dereference is specified.

PATH must start with '/', with the root directory defined first and
parents preceding their children. Duplicate paths and xattr keys are
rejected. String fields support \xXY byte escapes, including binary
xattr values. MTIME uses seconds.nanoseconds, where 1.1 means one second
and one nanosecond.

Both formats support regular file compression, xattr name prefixes and
shared xattrs. They also work with --incremental=data: the manifest
provides the update tree, matching directories are merged, and directory
metadata comes from the new records. No on-disk format changes are
required.

Patch 1 moves local root inode initialization to the local source path.
Patches 2 and 3 add helpers for duplicate xattr detection and building
shared xattrs from already loaded inodes. Patches 4 and 5 implement the
complete and two-field formats. Patches 6 and 7 add documentation and
regression coverage.

Test 033 covers file types, metadata, hard links, escaping, binary and
shared xattrs, name prefixes, malformed records, compression and
incremental updates. It checks images using dump.erofs and fsck.erofs.

Please apply the fix in [2] before running test 033.

[1] https://man.archlinux.org/man/composefs-dump.5.en
[2] https://lore.kernel.org/all/20261104035208.2471090-1-sereno.xu@deepseek.com/

Feedback on the record formats and importer integration is welcome.

Assisted-by: LLM
Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>

Wenyuan Xu (7):
  erofs-utils: mkfs: init root inode in local source mode
  erofs-utils: lib: add erofs_inode_has_xattr helper
  erofs-utils: lib: add erofs_build_shared_xattrs() helper
  erofs-utils: mkfs: add manifest input mode
  erofs-utils: mkfs: support two-field manifest records
  erofs-utils: man: document manifest input formats
  erofs-utils: tests: cover manifest input

 include/erofs/inode.h    |   2 +
 include/erofs/manifest.h |  17 ++
 include/erofs/xattr.h    |   3 +
 lib/Makefile.am          |   3 +-
 lib/inode.c              |  30 +-
 lib/manifest.c           | 527 ++++++++++++++++++++++++++++++++
 lib/xattr.c              |  62 +++-
 man/mkfs.erofs.1         | 114 +++++++
 mkfs/main.c              |  43 ++-
 tests/Makefile.am        |   3 +
 tests/erofs/033          | 637 +++++++++++++++++++++++++++++++++++++++
 tests/erofs/033.out      |   2 +
 12 files changed, 1403 insertions(+), 40 deletions(-)
 create mode 100644 include/erofs/manifest.h
 create mode 100644 lib/manifest.c
 create mode 100755 tests/erofs/033
 create mode 100644 tests/erofs/033.out

-- 
2.43.0


