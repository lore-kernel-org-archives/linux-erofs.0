Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645A7606A33C
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 02:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=H91usF/b
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQ3x24GdHz2yKn;
	Thu, 12 Nov 2026 13:19:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::32f"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794449958;
	cv=none; b=IuOpSjafm2AFDC1LrCpJIe0TC1azzsw/aPIJLwLT0Z2ffxfPmfrptJPafGrZjwxEOgWHBoklWTzBaghoW1XDpuLw9Q5GZa1E1gHyD+irI52ZWjqYoSPtMzzzdsBJgX1PfrJAZ4BXW0w3AYP6ZMGMrQpqLfQiztKvwxhDzsdQTVgjqh13OeKMo2OjJtAVpBG+cudjqWPeVoYAZn/CfRCDLRpisBYFw1JFxKhm17LicIi7TekG8nX+mfRDU4prXGyLGx+cRfdzu/M/Am780TSVWeQtw8eCFFJs5q/2U+9NzQPfLsr9JYp2afSAwWsbYqd7tD1NwozymGgxyJ+46MGUCg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794449958; c=relaxed/relaxed;
	bh=wtyuAeh2OycyURWuZUtug5qWxrkAw9jwsi6eWss0uMA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YHmZ4RIbCN/yGjDHlYeZxqQNmDUZLWsKh8b/J35I+wiqIGZkOoV/HLNXdWWMx+6oed0P5fZEbqIos0MPH4u0WzKaAIfsBE7rudskSm9ZmdzSI42GfV6Bo9DzNfz7S29FHdTElZbAHd6jfmVTVLsn1viFrx2vNB46kOKBONnpCkYW38uzoNdWcQp/5E2GLBz0yO0vg23Rxbw+SzScukcnjGTWSXuv9lGdy0y7LV+jgrwEWShAsyWGPa5jDu5UqxMCNiUuLktXrW//oQHKFwqWohVFN3G41+VXkM+MEQSoU3D04TGHWpaZ4uKRhvITeujsDOLO50M0/utXx2of5OEZMg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=H91usF/b; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32f; helo=mail-wm1-x32f.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=H91usF/b;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::32f; helo=mail-wm1-x32f.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQ3x02GYKz2xjM
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 13:19:15 +1100 (AEDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so34988195e9.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 11 Nov 2026 18:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1794449950; x=1795054750; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wtyuAeh2OycyURWuZUtug5qWxrkAw9jwsi6eWss0uMA=;
        b=H91usF/bxjof2qPFytSvMI48fxEFomwwq5PBHisOlTD+Wtc1pE7cTeyf9FkYH6PkCV
         HskDHBQrgzj/X9rzsluPFHNvPizQXy5Lu0WN5KTp+gi9ChJexLs73sJXYIpXEboijGYP
         z/y1xqYhHKtqGyfvojdKUsT1Sr/D5Erqo+jt0/pkzTAlNU8NKKf/vQiMDF1Y0vkRo52X
         yHtTEimmzPVTZAvoqxXn3/4iGoZHWGloJEqi8z5m7pA9kkM0mCmesFFganDd3rBetVFJ
         xm3GpUziwXX8npvSW2WlIBtU1FqdEczInEX3ywIPunB8AgQvQNhLXStNLS3EurIRY2Mu
         h8pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794449950; x=1795054750;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wtyuAeh2OycyURWuZUtug5qWxrkAw9jwsi6eWss0uMA=;
        b=fYnFJsAGKmggcc5cRQR1H02qaC4dheaILFANrcwRGbJdyCs7bBRoFOKOaSsikpS78P
         Bp+aOO9/8cucyO0Yv5YE4uuWyEzcQGghsDRchCn1+AURYG8sRvtNhitCWm1Y0Qptr+ng
         NlOsc9lmJ4CB0zwL9Si1ZKyncWdieGy4WPbWMnIpsvOUx5ISV56N5csXLgT9Wavw1q+2
         Mt1T6HpT2Dh04Ch+E8HAAvA7vgKYz84H2rkmeIpDs+4+bF2BRl/HazHBmH2IKSo2jYc4
         kh17iyFMOdEIz7/SdPUOZ39tM3eNBynIqcx8m5oFuBObtTQ5vGqnYIbYkmL5810eKQXD
         LF2w==
X-Gm-Message-State: APuU4Z/8E8LnCNWVVLmnZm31XrdMYw7YZHxM8H1oMCOj8U3eHl4hqRxM
	nYx+O7tkZZCchqkG1SErN7wNheaO2xHaVLNWsyin06IlL1/Pzfnba6oNYC4pOYAXZKSomlxHKn1
	EJoQnvbM=
X-Gm-Gg: AYBFou14uBPgrDYGq5ICHjpAhAXEvEDzZhOsKrW2orSA1qZrLOfOfRUc9Uf2tVRCsr6
	7ccZvQa+zHt+Uuf1aRLbkRy2Idxs64AIAgoenb/v+GwZClQLDKXhyQAUZSQvQj2T2DC/s8ZYmc5
	/7Fz88jWGURS1g4sThXAhb6gpuD4QVZaThajnFH7ggcztYz00uvFQgE7a89UdpQbbJLZvGvn5ud
	6u+gk+kbpjGaSSYwB61IgADDCFVakf3dc8d6xjExMAPgh1TKPu0FswOv6EgtvM/zhEZIBk/thOT
	elO7eCIaVKoDUb8FAKJbTHRLovjyZJj0ryzwbcbtbgUxdBjt54Uiio5roetboxUKxx2UT6bEHYv
	yCZt0XWnZS8lzBMVWIePVNuzx6iiwB6GnyecfU3Ik7t9U0vDvlAezFPQGiVDvmZkyYHgp7xRqdb
	B2jDCH1RQb9927Dmij/tQXv4STy/sRW6OKr9x+rjABRUpDyiokZXrW/lwhVDGe44WIwt2ku0OaD
	gAeWPteGvEd4pX0mgMOmEevaJhQ2fa1hgyvb9yZkXHXUR+oja8ZLqUCOQgc3iBwuXShPxhyYS2D
	V/w42BwFJ+OPDYU2VQ0fLHXv4bdS2jNflsp52GNi5le5gyabPTdWSfZT28DxspTIBypp
X-Received: by 2002:a05:600c:b86:b0:4a1:de8a:603a with SMTP id 5b1f17b1804b1-4ba093583e2mr78863875e9.6.1794449950314;
        Wed, 11 Nov 2026 18:19:10 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:b047:dbcd:74c9:840f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e28d0b2sm24209905e9.7.2026.11.11.18.19.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 18:19:09 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH] docs: erofs: refine the on-disk overview
Date: Thu, 12 Nov 2026 03:19:05 +0100
Message-ID: <20261112021905.36269-1-xiang.gao@docker.com>
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

The existing on-disk summary mainly describes inode and shared xattr
metadata views, leaving the overall layout and design rationale unclear.

Expand the summary and refine the terminology and wording while keeping
the section a high-level overview.

Assisted-by: chatgpt:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 Documentation/filesystems/erofs.rst | 100 ++++++++++++++++++++--------
 1 file changed, 72 insertions(+), 28 deletions(-)

diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
index 02caf3b061fe..0633e69aa71e 100644
--- a/Documentation/filesystems/erofs.rst
+++ b/Documentation/filesystems/erofs.rst
@@ -171,13 +171,27 @@ Each mounted filesystem will have a directory in /sys/fs/erofs based on its
 device name (i.e., /sys/fs/erofs/sda).
 (see also Documentation/ABI/testing/sysfs-fs-erofs)
 
-On-disk details
-===============
+On-disk format
+==============
+
+This section provides a high-level overview.  For the latest complete on-disk
+format specification, see:
+
+- https://erofs.docs.kernel.org/en/latest/ondisk/
 
 Summary
 -------
-Different from other read-only file systems, an EROFS volume is designed
-to be as simple as possible::
+
+EROFS keeps its on-disk format as simple as possible to minimize the need
+for metadata consistency checks.
+
+The guiding principle is that malformed or deliberately crafted metadata
+may describe a corrupt filesystem, but its effects should remain confined
+to the data and metadata exposed to userspace: garbage filesystems return
+garbage (meta)data to users, and nothing more.  Violating this rule is
+unsafe and must be prevented by our on-disk design.
+
+::
 
                                 |-> aligned with the block size
    ____________________________________________________________
@@ -185,15 +199,45 @@ to be as simple as possible::
   |_|__|_|_____|__________|_____|______|__________|_____|______|
   0 +1K
 
-All data areas should be aligned with the block size, but metadata areas
-may not. All metadata can be now observed in two different spaces (views):
+Apart from the EROFS superblock, which starts at byte offset 1024, metadata
+and data regions have no fixed locations or boundaries and may be interleaved
+throughout the image.  As a result, inodes do not need to reside in a fixed
+central table, allowing incremental builds, although the image creator may
+still choose to group all inodes together.
+
+All data except inline data must be aligned to the filesystem block size
+[#unencoded_data]_ to enable efficient block I/O, support memory mapping,
+and avoid unnecessary data copies.  Metadata does not require block alignment.
+
+.. [#unencoded_data] Strictly speaking, data refers to unencoded data;
+   encoded inodes are outside the scope of EROFS core metadata.
+
+EROFS core metadata consists only of the superblock, inodes, and directory
+entries stored in directory inode data.  The physical locations of inode
+data are recorded as block numbers to avoid block-alignment checks.
+
+Only a few superblock fields, including the root nid (see below), are needed
+to parse the filesystem tree.  Most of the remaining fields provide filesystem
+statistics reported to userspace and should not affect the core filesystem
+logic.
+
+Encoded inodes, which contain encoded data such as compressed data (including
+compressed directories), use a distinct inode "datalayout" number that allows
+them to be identified or rejected when reading the inode metadata.  Support for
+encoded layouts is optional and can be explicitly disabled at runtime if there
+are security concerns about parsing compressed data in the kernel.
+
+There are two metadata views: one for inode metadata and one for shared
+extended attributes.  Both can also be located in a special hidden inode
+called "metabox", which provides a unified way to compress inode and xattr
+metadata:
 
- 1. Inode metadata space
+ 1. Inode metadata view
 
-    Each valid inode should be aligned with an inode slot, which is a fixed
-    value (32 bytes) and designed to be kept in line with compact inode size.
+    Each valid inode is aligned to a 32-byte inode slot, matching the
+    size of a compact inode.
 
-    Each inode can be directly found with the following formula:
+    Each inode can be located directly using the following formula:
          inode offset = meta_blkaddr * block_size + 32 * nid
 
     ::
@@ -224,8 +268,8 @@ may not. All metadata can be now observed in two different spaces (views):
                                             |-> aligned with 4B
                                                         |-> aligned with 4B
 
-    Inode could be 32 or 64 bytes, which can be distinguished from a common
-    field which all inode versions have -- i_format::
+    Inodes can be 32 or 64 bytes, distinguished by the i_format field common
+    to both formats::
 
         __________________               __________________
        |     i_format     |             |     i_format     |
@@ -236,29 +280,29 @@ may not. All metadata can be now observed in two different spaces (views):
                                         |                  |
                                         |__________________| 64 bytes
 
-    Xattrs, extents, data inline are placed after the corresponding inode with
-    proper alignment, and they could be optional for different data mappings.
-    _currently_ total 5 data layouts are supported:
+    Xattrs, extents, and inline data follow the corresponding inode with
+    proper alignment.  Their presence depends on the inode's datalayout.
+    Five data layouts are currently supported:
 
     ==  ====================================================================
-     0  flat file data without data inline (no extent);
-     1  fixed-sized output data compression (with non-compacted indexes);
-     2  flat file data with tail packing data inline (no extent);
-     3  fixed-sized output data compression (with compacted indexes, v5.3+);
-     4  chunk-based file (v5.15+).
+     0  Flat inode data without inline data (no extents);
+     1  Encoded inode
+     2  Flat inode data with inline tail data (no extents);
+     3  Encoded inode (compact indexes)
+     4  Chunk-based file (v5.15+).
     ==  ====================================================================
 
-    The size of the optional xattrs is indicated by i_xattr_count in inode
-    header. Large xattrs or xattrs shared by many different files can be
-    stored in shared xattrs metadata rather than inlined right after inode.
+    The size of the optional xattrs is indicated by i_xattr_count in the inode
+    header.  Large xattrs or xattrs shared by many files can be stored in
+    shared xattr metadata rather than inlined immediately after the inode.
 
- 2. Shared xattrs metadata space
+ 2. Shared xattrs metadata view
 
-    Shared xattrs space is similar to the above inode space, started with
-    a specific block indicated by xattr_blkaddr, organized one by one with
-    proper align.
+    The shared xattr metadata view is similar to the inode metadata view.
+    It starts at the block indicated by xattr_blkaddr, with entries stored
+    sequentially with proper alignment.
 
-    Each share xattr can also be directly found by the following formula:
+    Each shared xattr can be located directly using the following formula:
          xattr offset = xattr_blkaddr * block_size + 4 * xattr_id
 
 ::
-- 
2.54.0 (Apple Git-157)


