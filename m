Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B64606A33E
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 09:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=TLN7VPsL
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQFBT4wFvz2yKn;
	Thu, 12 Nov 2026 20:16:33 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::42f"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794474993;
	cv=none; b=X6cD1RzbmnvHsmxOQkOmVHWGUggMJJUk8wW9daeSlY+BpboXCHieLXHnntGo80ciVEUzrwP5oS6RDnCIBCIoYqm/31ejxbdIgFXYwY7aLm1md379VnuMc9MI4jAJF1CljkKzmGH0y2UUEQtByQkqOGk05QXHfUuYig95xSDY7mLzv91AW5qkycVY+bXs2yo3dH0dlp5jIJa108VeJv46g+Y8rZ2Z5I1liX4F4e+aoQ7TTqgKKQHFMe5j6l/PnUqWlvjbRF33NUPYsSt1W/aKddKSGOdNSxl8xrKvzef7vbvf+FzgzSRVWwaFuBs5Hfo0aQhr9AcUZAW7Ty1mSQ8Law==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794474993; c=relaxed/relaxed;
	bh=iwKcXB+nL/O1Q+K5YbvqbNCC85Ls2keqIxGcIWCoh4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1bHqS3xb246xdkST2oCRFX2c45+HouRmEgVoAFqR7YmeJlUHgc3g9uGVnquWrk2uLbDKoMghLo1g3YncEti2w2YLpQtmbGIS4bCSooM4siA3n6mR14qlYe0BLXtGUEjLFXKKwC31Nb5z9gMpjJ0qOavtNo7tVPfavEvALW9rAUAocb7SydiK0+H+3v43zHNsjk2c1MEzzABsYxDmtR+VJ3P6iLwH/+eK0u+dW1x2WRECRRjiOrjNLxjw19Qjx/Cx/YWGZA+1uMooNvzno0qMFtsrdB0n1LSAlbIiKqvsPKJvlVnSASi9RSgVfijVMisbpn+0n6CkE0VnEu1LTasRg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=TLN7VPsL; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::42f; helo=mail-wr1-x42f.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=TLN7VPsL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::42f; helo=mail-wr1-x42f.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQFBR5jv2z2xwP
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 20:16:30 +1100 (AEDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-491aaed7565so2357630f8f.2
        for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 01:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1794474987; x=1795079787; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iwKcXB+nL/O1Q+K5YbvqbNCC85Ls2keqIxGcIWCoh4o=;
        b=TLN7VPsLCUTlPTOXpyeUh8NZNZFWzZQWjspJyTBAepjQCZFlR61ohXlDaGYD/4/BbE
         JtfNHo1Upn2rRMFAXYRDcJCEBtuUWzWFHa3iGat+2lTD24Br1BgqCPNX5QsLBNx7FoTp
         U0eoQDHIXf0uUVYY0v2/NeBFLL6Evv7y6OPix7eYsXlxMohy6+7Lv+IzeFuyQznI1ysl
         M2ot5c7IuiQ2NEUFEWS8tcxh8O9ODoN4kmWpENJO2A2ODZ9IxVHKed005J3GIEoluaAU
         X1D4WFyVeRuXSlWUN8bJTg8CEUKeOtupQOlIrgx1e3Xv39mGovdb5FwTBArXR1Mnq40Y
         jm0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794474987; x=1795079787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iwKcXB+nL/O1Q+K5YbvqbNCC85Ls2keqIxGcIWCoh4o=;
        b=f3rtC2ddgfm4DDLL0o3seVoOv1hmRTtmcBPNmgJaYBrWMz8e8BewpgTCnG8LdLIfvS
         g2J/TMay4jhMLjjU5uyLd5ywEkdAfnzWsbVUY7gEu9PoUbgGo8MXexucdNsjDe+sRqfR
         9mj1Sa/hHe8rKDOfcRsGzFskSC+g3K2yEOjLbWRv+M7rtk8YlB3jQY9KhSag13JEmIF9
         6YsSZOCcPpVm3QGJf9dmA3GtB12c75r8l0CI7SczmXeTkMnnkBYoeyZaO5JWyPCUwlLh
         L30gHl1jFmhi6OGoi8Y/XmdjFH/HeQPgscxlf1ooEIDZ9t6Aviqnwgyz0yAGtlL+xSCU
         Ye9g==
X-Gm-Message-State: APuU4Z8z8iUmsG4aDwn5gTAIx/28gsrEcRcHFgrB3A53pyXUK8vTKDN0
	wRh4qtUTmoSaVzPMxrfd+a5yy6FcdD9ywwYH3+hVGHCfCMeuusuaCt3Qq29MDaHBsEsq1OL+UqC
	OpWZbf+0=
X-Gm-Gg: AYBFou0Xx0q0LYcJeF0iK1S8+LqUXEB0g93h8T6Mm+fNyAOTu74UdFJuX3u1gafVnjg
	mBxK1BZoyEJIKTYVrQ9388xZ4Js8BesEwR9U44F9+toM6zW39Acse6WFq9qmora7rI05doTI1eu
	s9FO/vR6nCO17tVzCGdFy+nOW1z/d6eW3+eZL+8jn5+8sAwR1DXlJ6P/IgmhD9sOxxTSvCxYmuF
	Y04cYhLmG1jjBdx/zoFUpGD7xpb+NojSj6gNJq7qd9LVfl2XzbwvUaIzcFnkf1PBBCA6DRi62jI
	YiBcpr6QSFTSlH3AUR53vE06cpOwBPB/yus/TVGmcFX78DQ+P4QwAJ5yfDe6vHMzYUPkwrpOcnU
	cdmd2nDyXOk52djb5MuMp2SZydV+RcLwXA2kqJfgdfhfoS6W2xxi4oyLDSDzpVX4hdYZiT9qjOP
	6vWfuPAac7AwvSW5u2duMwWU31obKdYpa9XHg/I/vFDHKH1Y6XvGlguu+qP10nmPWGYyZDZD+5g
	HBP2DVpR3J7014+H4UOuxpbEXZMdGSxgR6fvftJYAp652Cgao7RekAg7z2PNp08jpxhVviIhrHV
	hS5AjI8lEFBCp+TCZLUEcy6Ao/EEySwzZGMIfV0O0TMTbdG/lePY3Wb2pYgAwpbOXp+c
X-Received: by 2002:a05:6000:40dc:b0:48d:f470:6b3e with SMTP id ffacd0b85a97d-499c727123amr9304374f8f.13.1794474986711;
        Thu, 12 Nov 2026 01:16:26 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:b047:dbcd:74c9:840f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4983600bd6esm15960039f8f.28.2026.11.12.01.16.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 01:16:26 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v2] docs: erofs: refine the on-disk overview
Date: Thu, 12 Nov 2026 10:16:15 +0100
Message-ID: <20261112091615.40264-1-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261112021905.36269-1-xiang.gao@docker.com>
References: <20261112021905.36269-1-xiang.gao@docker.com>
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
changes since v1:
 - address Chengyu's comment to describe more about the metabox.

 Documentation/filesystems/erofs.rst | 119 +++++++++++++++++++++-------
 1 file changed, 90 insertions(+), 29 deletions(-)

diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
index 02caf3b061fe..cea781b3cb16 100644
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
@@ -185,16 +199,50 @@ to be as simple as possible::
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
 
- 1. Inode metadata space
+EROFS core metadata consists only of the superblock, inodes, and directory
+entries stored in directory inode data.  The physical locations of inode
+data are recorded as block numbers to avoid block-alignment checks.
 
-    Each valid inode should be aligned with an inode slot, which is a fixed
-    value (32 bytes) and designed to be kept in line with compact inode size.
+Only a few superblock fields, including the root nid (see below), are needed
+to parse the filesystem tree.  Most of the remaining fields provide filesystem
+statistics reported to userspace and should not affect the core filesystem
+logic.
 
-    Each inode can be directly found with the following formula:
-         inode offset = meta_blkaddr * block_size + 32 * nid
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
+
+ 1. Inode metadata view
+
+    Each valid inode is aligned to a 32-byte inode slot, matching the
+    size of a compact inode.  Inodes can be stored either inside or outside
+    the metabox inode, with a flag in the nid indicating whether they are
+    stored inside.
+
+    For inodes not in the metabox, each inode can be located directly
+    using the following formula::
+
+         inode physical position = meta_blkaddr * block_size + 32 * nid
 
     ::
 
@@ -224,8 +272,8 @@ may not. All metadata can be now observed in two different spaces (views):
                                             |-> aligned with 4B
                                                         |-> aligned with 4B
 
-    Inode could be 32 or 64 bytes, which can be distinguished from a common
-    field which all inode versions have -- i_format::
+    Inodes can be 32 or 64 bytes, distinguished by the i_format field common
+    to both formats::
 
         __________________               __________________
        |     i_format     |             |     i_format     |
@@ -236,31 +284,44 @@ may not. All metadata can be now observed in two different spaces (views):
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
+
+    For inodes in the metabox, the remaining nid bits identify the inode slot
+    within the metabox's inode address space.  This data is read through the
+    metabox inode, with decompression as needed.  The metabox inode itself is
+    located outside the metabox and is identified by metabox_nid in the
+    superblock.
 
- 2. Shared xattrs metadata space
+ 2. Shared xattrs metadata view
 
-    Shared xattrs space is similar to the above inode space, started with
-    a specific block indicated by xattr_blkaddr, organized one by one with
-    proper align.
+    The shared xattr metadata view is similar to the inode metadata view.
+    It starts at the block indicated by xattr_blkaddr, with entries stored
+    sequentially on 4-byte boundaries.  Shared xattrs are stored either all
+    inside or all outside the metabox; this metadata view cannot be selected
+    individually for each entry.
+
+    Each shared xattr can be located using the following formula::
 
-    Each share xattr can also be directly found by the following formula:
          xattr offset = xattr_blkaddr * block_size + 4 * xattr_id
 
+    When COMPAT_SHARED_EA_IN_METABOX feature is enabled, this offset is within
+    the metabox inode's address space.  Otherwise, it is a physical position
+    in the filesystem image.
+
 ::
 
                            |-> aligned by  4 bytes
-- 
2.54.0 (Apple Git-157)


