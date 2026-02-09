Return-Path: <linux-erofs+bounces-2278-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84862EF0708
	for <linux-erofs@archiver.kernel.org>; Mon,  9 Feb 2026 04:38:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4f8X5S5qYwz2yFm;
	Mon, 09 Feb 2026 15:38:52 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1770611932;
	cv=none; b=Xdf+YBHVkkD8RL5X1PyRZYElCBX3TMwj+GJCADOI53mYYwj6xC7iNkEJAOvxi2G3l2xIyTzHp0pt2hblOwO4q5Ckt+6WH7EsoEV9u5seMLrKTs47HNu63BkrLD/D2urdazgb5rCVY/rdYSIKdBiHBYF+PFkCXQI1HssZTYUTvhJGyDSN3eg43uWAqi6oqxLu6v9qw5s8KCXrdmj0ljYsbbftnJkFXcPwA/rkvueLBMUvhAzp0Y8WHw6fHuvh60tOc1nJ8xTLDCtdxbwVDxZB4ThhRT5R6I74tGFlZ8LRHcx/KWjuut/CqFjWcquwQk/fUKzeBvAnnj7bNfy2FIWudw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1770611932; c=relaxed/relaxed;
	bh=NlVyR4nrljbFps8PD6qZ2cmyBji1n5BvIUynP1wBIhg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bCAg14ueMcm8ZXzyBpdMgVhWfjG4S/+YBixcoC2/FoSBGhqMBxdsXXKhYSU3q/ZpmbcOkOpHvSJdo18+yyPfjTROr9ORXNaFYbRXBZxGC18XrDmWox2LURRS424rqiborgIEGpoAi2Xaq3i3YIGRS0CRRVG7Mi+El2rcUEOIj8xwXRpfNY4Qg/VLChrODVXHx2uiVZBvLZkATxOADkflxTOHc//eAJL6CWPGHkUcuohsYVoi5NJExTThgbWJN0zFZmhyLIlww0pzHe9o7dqkSvGtwoRCAzMO+vq6rBxB61P1gUGrt87a7W9h1183bLfpwq1SgZuLXGtYzpuQMRZtEg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=PxBjeHkA; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=PxBjeHkA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4f8X5R502Rz2xnl
	for <linux-erofs@lists.ozlabs.org>; Mon, 09 Feb 2026 15:38:51 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0197F40910;
	Mon,  9 Feb 2026 04:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239F9C116C6;
	Mon,  9 Feb 2026 04:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770611928;
	bh=k8MFO1fvEa81983PZZbGBam9eef9UAr6x95M54EpI5g=;
	h=Date:From:To:Cc:Subject:From;
	b=PxBjeHkAVIqiS2HOifeKOtUJN0jAVzAxeOUNjP1y77uLDwUmHQzKxOp7Yk91kMGsh
	 1oCmo0aOKo1FE2pk3YzQLSpe4NfbcI+pl0z2uXzGvly87LHSUM1Dg3vccRgFP5dty5
	 U4YxmKSD6EpAtVsp4z4fYOc0p81IXg9JFDpzXCIvMy8g8XSCikhDDB3m/pLJOXRfw9
	 lrsmcD3QdIv2iN1ZsVo1MbuzzCG+wakVIOTxY/UcgQ1UBCUc2ek14ETbdnq1r9d1v+
	 fWo23j+kdvMCMT95YVaxPh8RnERHcrm1HhNCTG/NN46l3mprJAvfGfBcJujRViAVYr
	 6oqhePEqdfApw==
Date: Mon, 9 Feb 2026 12:38:34 +0800
From: Gao Xiang <xiang@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Ferry Meng <mengferry@linux.alibaba.com>, Chao Yu <chao@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [GIT PULL] erofs updates for 7.0-rc1
Message-ID: <aYlkynqBRVbO5WtD@debian>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Ferry Meng <mengferry@linux.alibaba.com>, Chao Yu <chao@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Linus,

Could you consider this pull request for 7.0-rc1?

In this cycle, inode page cache sharing among filesystems on the same
machine is now supported, which is particularly useful for high-density
hosts running tens of thousands of containers.

In addition, we fully isolate the EROFS core on-disk format from other
optional encoded layouts since the core on-disk part is designed to be
simple, effective, and secure. Users can use the core format to build
unique golden immutable images and import their filesystem trees
directly from raw block devices via DMA, page-mapped DAX devices, and/or
file-backed mounts without having to worry about unnecessary intrinsic
consistency issues found in other generic filesystems by design.
However, the full vision is still working in progress and will spend
more time to achieve final goals.

There are other improvements and bug fixes as usual, as listed below.

All commits have been in -next for a while. Note that I have merged the
`vfs-7.0.iomap` branch in order to import iomap changes and route the
iomap updates properly, so the same merge conflicts are observed as in:

https://lore.kernel.org/r/20260206-vfs-iomap-v70-71e0b356ce5c@brauner

Thanks,
Gao Xiang

The following changes since commit 0f61b1860cc3f52aef9036d7235ed1f017632193:

  Linux 6.19-rc5 (2026-01-11 17:03:14 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git tags/erofs-for-7.0-rc1

for you to fetch changes up to 1caf50ce4af096d0280d59a31abdd85703cd995c:

  erofs: fix UAF issue for file-backed mounts w/ directio option (2026-02-06 15:30:35 +0800)

----------------------------------------------------------------
Changes since last update:

 - Support inode page cache sharing among filesystems

 - Formally separate optional encoded (aka compressed) inode layouts
   (and the implementations) from the EROFS core on-disk aligned plain
   format for future zero-trust security usage

 - Improve performance by caching the fact that an inode does not have
   a POSIX ACL

 - Improve LZ4 decompression error reporting

 - Enable LZMA by default and promote DEFLATE and Zstandard algorithms
   out of EXPERIMENTAL status

 - Switch to inode_set_cached_link() to cache symlink lengths

 - random bugfixes and minor cleanups

----------------------------------------------------------------
Chao Yu (1):
      erofs: fix UAF issue for file-backed mounts w/ directio option

Christian Brauner (1):
      Merge patch series "iomap: erofs page cache sharing preliminaries"

Ferry Meng (4):
      erofs: Use %pe format specifier for error pointers
      erofs: make z_erofs_crypto[] static
      erofs: remove useless src in erofs_xattr_copy_to_buffer()
      erofs: avoid some unnecessary #ifdefs

Gao Xiang (17):
      erofs: improve LZ4 error strings
      erofs: avoid noisy messages for transient -ENOMEM
      erofs: fix incorrect early exits for invalid metabox-enabled images
      erofs: fix incorrect early exits in volume label handling
      erofs: unexport erofs_getxattr()
      erofs: unexport erofs_xattr_prefix()
      erofs: tidy up synchronous decompression
      erofs: add missing documentation about `directio` mount option
      erofs: tidy up erofs_init_inode_xattrs()
      Merge branch 'vfs-7.0.iomap' of ssh://gitolite.kernel.org/pub/scm/linux/kernel/git/vfs/vfs
      erofs: decouple `struct erofs_anon_fs_type`
      erofs: mark inodes without acls in erofs_read_inode()
      erofs: use inode_set_cached_link()
      erofs: separate plain and compressed filesystems formally
      erofs: handle end of filesystem properly for file-backed mounts
      erofs: fix inline data read failure for ztailpacking pclusters
      erofs: update compression algorithm status

Hongbo Li (7):
      iomap: stash iomap read ctx in the private field of iomap_iter
      erofs: hold read context in iomap_iter if needed
      fs: Export alloc_empty_backing_file
      erofs: add erofs_inode_set_aops helper to set the aops
      erofs: using domain_id in the safer way
      erofs: pass inode to trace_erofs_read_folio
      erofs: support unencoded inodes for page cache share

Hongzhen Luo (4):
      erofs: support user-defined fingerprint name
      erofs: introduce the page cache share feature
      erofs: support compressed inodes for page cache share
      erofs: implement .fadvise for page cache share

Yuwen Chen (1):
      erofs: simplify the code using for_each_set_bit

 Documentation/ABI/testing/sysfs-fs-erofs |  20 ++-
 Documentation/filesystems/erofs.rst      |  18 ++-
 fs/erofs/Kconfig                         |  20 ++-
 fs/erofs/Makefile                        |   1 +
 fs/erofs/data.c                          | 115 ++++++++-----
 fs/erofs/decompressor.c                  |  85 +++++-----
 fs/erofs/decompressor_crypto.c           |   2 +-
 fs/erofs/decompressor_deflate.c          |   1 -
 fs/erofs/erofs_fs.h                      |   7 +-
 fs/erofs/fileio.c                        |  52 +++---
 fs/erofs/fscache.c                       |  17 +-
 fs/erofs/inode.c                         |  80 +++++-----
 fs/erofs/internal.h                      |  74 ++++++++-
 fs/erofs/ishare.c                        | 206 ++++++++++++++++++++++++
 fs/erofs/super.c                         | 142 ++++++++++++-----
 fs/erofs/sysfs.c                         |   9 +-
 fs/erofs/xattr.c                         | 266 ++++++++++++++++++++-----------
 fs/erofs/xattr.h                         |  40 +----
 fs/erofs/zdata.c                         | 110 +++++++------
 fs/file_table.c                          |   1 +
 fs/fuse/file.c                           |   4 +-
 fs/iomap/buffered-io.c                   |   6 +-
 include/linux/iomap.h                    |   8 +-
 include/trace/events/erofs.h             |  10 +-
 24 files changed, 856 insertions(+), 438 deletions(-)
 create mode 100644 fs/erofs/ishare.c

