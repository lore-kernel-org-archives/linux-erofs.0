Return-Path: <linux-erofs+bounces-4187-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55461C5AC67
	for <linux-erofs@archiver.kernel.org>; Tue, 11 Aug 2026 07:24:09 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hK35g06hqz2yvG;
	Tue, 11 Aug 2026 17:24:07 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786433046;
	cv=none; b=QOjLprt7c1NKAB6VmHuAnZyreiGMxQOoKgxCPJMj0Ri0Ep6FpcauCNp644tIPKM4u+UFcyqEYZwY7bO+LKMCDucC0TkN+alz2evHDjSKHIhahNtMldEUlGTvrivTf2McdyYt5ZWLl8GIJChLzFfF3CtbE0qKOyI2zSE//ZY2piAwyS/DMGDJXNhbc1rSKtlrljTEceUkZ7P9SaQy5yuyx6wzpWVnarR2OHhblB5mSmN5yQgDqkNaBbgVFeL2xBQZJHfTLlv6cfLIxHUQdY9QD0hbb+0u2UFnpAfGrBo8xr4YDPyPqQJ1eqfc2etFhso0SGp2jvYaVSdyMyfx9uVz/g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786433046; c=relaxed/relaxed;
	bh=xR837NnXZy7HXvZPnt4PmIBdKsmCljxGFnneVYQf2LM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=bSh+hfyBktzrd/XJRydwjWixMtB0NwPZhTioZDE+DuOWzhuUB7P7VZSalvppnpkL9LH24hpU4XIFhJc7Hh83AbUya7XwG8oFMmVZlmIyLr9o7JXHmJvciN8UEfZIyS8BvENFLO8/TrYbAhJJUP8+uOYvbQIHn8oWY551JKKOOROzF4l9n7Vpj68H9Y3eHKKYVqtEDr70yczm7ZDyhy7dELVnqJZMWcmPoo/E2vPhY2nGmnyCHLjdhJZAYhgLVW9yuZbHqt9BGMLoZfLVMUJBTECimEghfBIv+wM7F2f8j8dujxVLJDYxq94RErwZUusBLeucSJ+y0N0AmdI8zkU7Xg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=i9vuftsz; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=i9vuftsz; dkim-atps=neutral; spf=pass (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=i9vuftsz;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=i9vuftsz;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.129.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hK35d4Ty7z2yrL
	for <linux-erofs@lists.ozlabs.org>; Tue, 11 Aug 2026 17:24:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786433039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xR837NnXZy7HXvZPnt4PmIBdKsmCljxGFnneVYQf2LM=;
	b=i9vuftszXmX3Y4NwvpPR3SoGCWyCNMy4d+nbpIlCIxVFFTF7zsZZfDzHjRjGRSPvYj1n22
	ohLuh7BPQCoDpr4HYal9Lk57/0A8NrAOW77orRpCVn2SVTtEK4gH6aL/U14ciX26+7p1Sd
	46D2QhqqOltMpVDoNR5XZAd+a5BZz94=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786433039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xR837NnXZy7HXvZPnt4PmIBdKsmCljxGFnneVYQf2LM=;
	b=i9vuftszXmX3Y4NwvpPR3SoGCWyCNMy4d+nbpIlCIxVFFTF7zsZZfDzHjRjGRSPvYj1n22
	ohLuh7BPQCoDpr4HYal9Lk57/0A8NrAOW77orRpCVn2SVTtEK4gH6aL/U14ciX26+7p1Sd
	46D2QhqqOltMpVDoNR5XZAd+a5BZz94=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-541-a-rIfENHPo-b7iATv93CgQ-1; Tue,
 11 Aug 2026 03:23:57 -0400
X-MC-Unique: a-rIfENHPo-b7iATv93CgQ-1
X-Mimecast-MFC-AGG-ID: a-rIfENHPo-b7iATv93CgQ_1786433036
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 011C819560B4;
	Tue, 11 Aug 2026 07:23:56 +0000 (UTC)
Received: from oxygen.station (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 26A6D180034F;
	Tue, 11 Aug 2026 07:23:52 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	linux-fsdevel@vger.kernel.org,
	amir73il@gmail.com,
	gscrivan@redhat.com,
	brauner@kernel.org
Subject: [PATCH v5 0/2] erofs: share the superblock for file-backed mounts
Date: Tue, 11 Aug 2026 09:10:49 +0200
Message-ID: <20260811071241.389589-1-gscrivan@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 1ajkiwTpgex6sX6vGCh6Hk5sbA_NgdmRy5MxGaGB_hU_1786433036
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This series adds a "superblock_share" mount option for file-backed EROFS
mounts.  When set, mounting the same backing file (identified by inode and
fsoffset) with compatible options reuses the existing superblock instead
of creating a new one, so the page cache and inode cache are shared across
all mounts of the image.  Without the option the behaviour is unchanged.

v4: https://lore.kernel.org/linux-fsdevel/20260804060455.2928514-1-gscrivan@redhat.com/
v3: https://lore.kernel.org/linux-fsdevel/20260801075446.2508805-1-gscrivan@redhat.com/
v2: https://lore.kernel.org/linux-fsdevel/20260731160901.2276832-1-gscrivan@redhat.com/
v1: https://lore.kernel.org/linux-fsdevel/20260730124120.1501126-1-gscrivan@redhat.com/
Needs: https://lore.kernel.org/linux-fsdevel/20260804055949.2927896-1-gscrivan@redhat.com/

Giuseppe Scrivano (2):
  fs: rename vfs_get_super() to get_tree_super() and export it
  erofs: reuse superblock for file-backed mounts

 Documentation/filesystems/erofs.rst |  8 ++++
 fs/erofs/internal.h                 |  1 +
 fs/erofs/super.c                    | 58 +++++++++++++++++++++++++++--
 fs/super.c                          | 19 ++++++++--
 include/linux/fs_context.h          |  4 ++
 5 files changed, 83 insertions(+), 7 deletions(-)

-- 
2.55.0


