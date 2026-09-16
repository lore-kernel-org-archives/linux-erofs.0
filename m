Return-Path: <linux-erofs+bounces-4571-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD802C88E77
	for <linux-erofs@archiver.kernel.org>; Wed, 16 Sep 2026 09:10:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hlClV2zGkz2ySf;
	Wed, 16 Sep 2026 19:10:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:3b::10"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789549814;
	cv=none; b=NTI8IDGlanWRl78whbGjI55RlACzkNGJDnSVLNi+Lpgw5TJqbcleUdh6g9LDcWU66yDOS0vV52Y4zbH6L0wxzgTmt9pnb+vS0svbgVORpAUBrFYod9ZcZFB3/i9UzCa8UGvxfPiu7uiE1tnx4x2Wi/iS73SE9XqpvvbC/oXFAYHC38iwllNaQvXOywpZFO5TLYOHONE8ezRapguS+IlIRrRRheawmj8fTbJ9kmfGUTM3rUMb/D9/2A5T7xkfZzca45wSFUqMR/c67UWY+OiPTDDY6MLGH3Bvnp22RNJ9QfWF0+knQWrymNuLQ1+Smji0z0nmziNpW4kR+TaCbSnK+w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789549814; c=relaxed/relaxed;
	bh=E81YfdQ0AJYTPkXmtqlOODcUxV3/SbP3WLhNFzqHVfo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=YW+e1CUrGi/kU73OCOZ6rOg0C2hi0snN33tR5Ed6j2JKUXCwOo29hYrp5ebJ/AX2q6grYZvxalmURm5mO2VJ0xSSkGtfsKZuWMCnFMZjWTU3f3f58tjp4jeOVbWdbKlCADMUhL4/HbwMwi7yDz+zV8d1EL/SPoSe120W5bnbhAXerd6/z1gXgxjF+zHBNbj4H0owvWp1F+D6FwlBI7abL+fqVXnzWPzG5Iuzk44Bqjbu7FRWTtn4XehDF5v/FyMTUXueK3XkWLniYN2xFex/rVzvNfSG9tiJc6X+9HtVjsojmzVed1xR1o0NLbyD4hTpKo1obynqA7ORrV1G6G7yhw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Kenpnuyu; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:3b::10; helo=mail-pz2-x10.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Kenpnuyu;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:3b::10; helo=mail-pz2-x10.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pz2-x10.google.com (mail-pz2-x10.google.com [IPv6:2607:f8b0:4864:3b::10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hlClS1XkYz2xlY
	for <linux-erofs@lists.ozlabs.org>; Wed, 16 Sep 2026 19:10:10 +1000 (AEST)
Received: by mail-pz2-x10.google.com with SMTP id 41be03b00d2f7-cc1cebad4afso663202a12.0
        for <linux-erofs@lists.ozlabs.org>; Wed, 16 Sep 2026 02:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789549808; x=1790154608; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=E81YfdQ0AJYTPkXmtqlOODcUxV3/SbP3WLhNFzqHVfo=;
        b=Kenpnuyuu6FoqUm5QfroHq7VeQuqJC85TdhnGWeYMDTUcE1BSnWPrYaH/mFchJPsEt
         BnnqOfOlVsDXfk+zw8w3+3mBMzmiITmCeLa8Wlz9rY8iEQjEuuA5K+c+Zk7vxFBjM5nM
         6LkcDsmFZ+RJ7cSarti7bA2vLuzOzY+LieVyiqcP4QHMLanQN7QTdnZ1vfxwXoYjgjwT
         KQUTE9TC5KdQU66jM/kblemq02d8Bpge4htFP7fEp6FA+LmUDmo1Ikp7ErT6fMbA2Uz2
         MtEOxHREB5c+j1rgIwesoND0Q4ndPg3BxWwk1fpNv7qAIpNa98ANbdQtBoZO5X4vXZ97
         oVuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789549808; x=1790154608;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=E81YfdQ0AJYTPkXmtqlOODcUxV3/SbP3WLhNFzqHVfo=;
        b=mR+LWF2Pig6jj4+wByWdumVv3NpqJeK844PZkFAqg02E4hu7OZOOC86aumzveSoKoF
         vFfq+iUeG2uzXjXS3ZRCeiC72Ftx8xLKSbTa2fmCEsQcddwkh6WodkCU01hLjkxbvTma
         454k/e8PmvTCead+7rbaywTNi7ERijYxaUCsk2js8fDgqW690D/GksUIAVbAbThI+8XB
         U8ns9SwiuShu8yhAG9nZ7Dyij6J2tu4DDRNYsncauteQvJmMfLOfVKuGCIQ7VAsYUolZ
         bivcY8PXDrLBi1er/y4nFWZd79+Pf0olFkGxeAKLY5T01URJiuK36ILDclgCDpmn6rHE
         nFlQ==
X-Gm-Message-State: AFuF++nbi+tt4OXblrfxEelT/UraTRN+P7zLWCf/YHrsmkIs8Y5tJRDc
	eQWQHccwoALQgy6lDhKAbA6y/vcdAbB1ZIy+3OLoTlYXw19ltY9dmBo1YKwVrCUO
X-Gm-Gg: AYBFou3IdiCIHVwGaWUlA7eU6SLhCCR+ATGEYr3n22qF1QR3PmjiMtOnXOyvUI8oE2B
	ixg7XE5gGik3kFHfIUSaWrDkBkHmM42VMNxCB5tF9rJeZ026lPd9SLPOS3sJ6OisG1o0JzsSm/g
	cw+BOq9ta0kTRMda4a2u5I5DQXOu3nwwsZ9uHD6ka334GXsnk+4YpCKg9uysO0OzLBCJdnxhf78
	jLxFCno3+Rj3i+mLTBlCV+1L9xr61dfxsmTeBB5PSs76G0weT9QCufbPSNWkdp9NGobq40728ui
	e9oDDLYazz85OeOWoz2BVJcBwF4EHYLlYFqb/WGPneIi++UPle9UZRmGa1KRDPBEmYpAPJRYDs1
	OgbJanT6zD24u2lybM5/tL8JXQqHeAI+fjZmfAMgSZV7jxD8z3PehXCukwkTYBLrzwJlfddGJsp
	6qd+ze6zm0GyvBCmvTNHw1kD3fJe+DHx6KTcAna1cm8Ho+4op+SW22JQWf5N4lFHwTt5OGDDMnX
	xzm4r3PluCTRBkXP8NiUI4RJN9hQCb8HgjGxG3NQ7Jo2XzEj/WMQrjaGO6y
X-Received: by 2002:a05:6a20:729d:b0:3da:421e:40f3 with SMTP id adf61e73a8af0-3dd5f5c78e7mr4556263637.17.1789549808213;
        Wed, 16 Sep 2026 02:10:08 -0700 (PDT)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.58])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc50ab50d67sm1215277a12.6.2026.09.16.02.10.06
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 02:10:07 -0700 (PDT)
From: Yifan Zhao <stopire@gmail.com>
X-Google-Original-From: Yifan Zhao <yifan.yfzhao@foxmail.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH RFC 0/2] erofs-utils: add dm-persistent file delta support
Date: Wed, 16 Sep 2026 17:10:01 +0800
Message-ID: <cover.1789545930.git.stopire@gmail.com>
X-Mailer: git-send-email 2.55.0
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

This series adds a file-delta framework and a dm-persistent backend to
mkfs.erofs.  Unchanged data is referenced from the parent image; changed
nonzero data is stored in the new image.

Example: rootfs/disk.img is the baseline file, and epoch1.cow is a sealed
dm-persistent v1 snapshot exception store for that file, using 4096-byte
(8-sector) chunks.

  # Create the parent image containing /disk.img.
  mkfs.erofs -Eforce-chunk-indexes --chunksize=4096 \
    parent.erofs rootfs/

  # Apply epoch1.cow to /disk.img and write next.erofs.
  mkfs.erofs -Eforce-chunk-indexes --chunksize=4096 \
    --file-delta=dm-persistent:/disk.img:epoch1.cow \
    next.erofs parent.erofs

  # Check the new image using the parent as its external data device.
  fsck.erofs --device=parent.erofs next.erofs

The update --chunksize must match the exception store's chunk size.

Yifan Zhao (2):
  erofs-utils: mkfs: add file-delta framework
  erofs-utils: mkfs: support dm-persistent file deltas

 include/erofs/internal.h     |   2 +
 lib/Makefile.am              |   5 +-
 lib/blobchunk.c              |  25 +++
 lib/dm_persistent.c          | 396 +++++++++++++++++++++++++++++++++++
 lib/file_delta.c             | 214 +++++++++++++++++++
 lib/file_delta_chunk.c       | 203 ++++++++++++++++++
 lib/liberofs_chunk.h         |   2 +
 lib/liberofs_dm_persistent.h |   9 +
 lib/liberofs_file_delta.h    |  81 +++++++
 lib/rebuild.c                |  34 ++-
 man/mkfs.erofs.1             |  71 +++++++
 mkfs/main.c                  | 113 +++++++++-
 12 files changed, 1148 insertions(+), 7 deletions(-)
 create mode 100644 lib/dm_persistent.c
 create mode 100644 lib/file_delta.c
 create mode 100644 lib/file_delta_chunk.c
 create mode 100644 lib/liberofs_dm_persistent.h
 create mode 100644 lib/liberofs_file_delta.h


base-commit: 2429baa75a5278ddaf8221740a6a65dd390acb08
-- 
2.55.0


