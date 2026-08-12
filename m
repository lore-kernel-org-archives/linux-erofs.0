Return-Path: <linux-erofs+bounces-4213-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E093C5B56A
	for <linux-erofs@archiver.kernel.org>; Wed, 12 Aug 2026 14:29:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKrV550bGz302l;
	Thu, 13 Aug 2026 00:29:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786544973;
	cv=none; b=k69B0ef38/FIgkebvBXn19yrMO9fqEr/Xjuuelz5Iixf7ebKfWpDCH2ZsKPZBnCxhrA0dNQ5PuI+nWaPIIRH+LBoB6gMNfKRUl5NkeTyx0jV9n9RRFCi+Hvp0sIPnm8HcVSU52rGBJgyuwLux0w7jdLGTw7i8qC67CEBVItU2+CK7tj7YypNji7iEyHXG5lio3k5xYDfoAv3g8WjFunjInJxuYya6nrDg+CDWdarGEprPuL/dtP8y6P3ZdXoZcC7o3H1IWR5g+KOQOvawYY07cH/C2i2dddHkSWqgsGaG2XSowLsV/W4LDf2MICcN1rBd4mSdcO2uBhCtlxz+ZwtyA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786544973; c=relaxed/relaxed;
	bh=cQlSbAIttH+rNkAEoVDMXcXh5dsCND2QuLXOvV9cLG0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=OPjdMLu5lYEv2xJiZwEFV4k8AhDBGYvdv7sTlKgvjL7Wk4EVS/tqp0s0txrXQYTNSrgknGhPxruIVC5FwK7z9JSlFfpetMaAsxPE3bMG8eviOa/br/+V6/JKTYAtf54PGVV/+DXr63/IaAv/valAuRWX56XgZKLTNnljx4KnlMmfvpWV/rzIiLh+BzEHt0caDB3BKkFf8mN2nVF1G7hfLNR3Dhjp6rMqJ6Tew0jitOrw1N5bdace9vVKjhcS2jrFDSgvjO66bbV8jFV5gW0ezhRo8bc39ag8l6SU6CS8G0edUHAHYdac/5+mPH+LivAyZUVuGyGeZHSpHJKvFy2x/g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NMvH5ei3; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NMvH5ei3; dkim-atps=neutral; spf=pass (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org) smtp.mailfrom=redhat.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NMvH5ei3;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NMvH5ei3;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=redhat.com (client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=gscrivan@redhat.com; receiver=lists.ozlabs.org)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKrV4233jz2ytv
	for <linux-erofs@lists.ozlabs.org>; Thu, 13 Aug 2026 00:29:30 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786544962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cQlSbAIttH+rNkAEoVDMXcXh5dsCND2QuLXOvV9cLG0=;
	b=NMvH5ei3XHC2VhV4loAFBSQVpgbdhr9sVnHOqQ8J9YSHpxI9sxP2bZtx+eTbgxzDV7L0kE
	zFzT37pZ+rm6XzbI1hL420byZ0M0qi8oLyFJ3kT5gTid/PadqQDWcrKkNZt8h4R4Zv2zIK
	ReGDvhFhn/gI7qrZbDRdAnF6XUAVJqg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786544962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cQlSbAIttH+rNkAEoVDMXcXh5dsCND2QuLXOvV9cLG0=;
	b=NMvH5ei3XHC2VhV4loAFBSQVpgbdhr9sVnHOqQ8J9YSHpxI9sxP2bZtx+eTbgxzDV7L0kE
	zFzT37pZ+rm6XzbI1hL420byZ0M0qi8oLyFJ3kT5gTid/PadqQDWcrKkNZt8h4R4Zv2zIK
	ReGDvhFhn/gI7qrZbDRdAnF6XUAVJqg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-232-37Ig9cT_MuWTn-sfLDU5cw-1; Wed,
 12 Aug 2026 10:29:20 -0400
X-MC-Unique: 37Ig9cT_MuWTn-sfLDU5cw-1
X-Mimecast-MFC-AGG-ID: 37Ig9cT_MuWTn-sfLDU5cw_1786544959
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 92AA71800984;
	Wed, 12 Aug 2026 14:29:18 +0000 (UTC)
Received: from oxygen.station (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CD1011800577;
	Wed, 12 Aug 2026 14:29:15 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	linux-fsdevel@vger.kernel.org,
	amir73il@gmail.com,
	gscrivan@redhat.com,
	brauner@kernel.org,
	viro@zeniv.linux.org.uk,
	jack@suse.cz
Subject: [PATCH v6 0/2] erofs: share the superblock for file-backed mounts
Date: Wed, 12 Aug 2026 16:28:02 +0200
Message-ID: <20260812142907.1010046-1-gscrivan@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: JlgQ-_i9G3XLe8kw_cNZet_Y7Zz194kWIX_flzO5a14_1786544959
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

v5: https://lore.kernel.org/linux-fsdevel/20260811071241.389589-1-gscrivan@redhat.com/
v4: https://lore.kernel.org/linux-fsdevel/20260804060455.2928514-1-gscrivan@redhat.com/
v3: https://lore.kernel.org/linux-fsdevel/20260801075446.2508805-1-gscrivan@redhat.com/
v2: https://lore.kernel.org/linux-fsdevel/20260731160901.2276832-1-gscrivan@redhat.com/
v1: https://lore.kernel.org/linux-fsdevel/20260730124120.1501126-1-gscrivan@redhat.com/
Needs: https://lore.kernel.org/linux-fsdevel/20260804055949.2927896-1-gscrivan@redhat.com/

Giuseppe Scrivano (2):
  fs: rename vfs_get_super() to get_tree_super() and export it
  erofs: reuse superblock for file-backed mounts

 Documentation/filesystems/erofs.rst |  7 ++++
 fs/erofs/internal.h                 |  1 +
 fs/erofs/super.c                    | 56 +++++++++++++++++++++++++++--
 fs/super.c                          | 19 +++++++---
 include/linux/fs_context.h          |  4 +++
 5 files changed, 80 insertions(+), 7 deletions(-)

-- 
2.55.0


