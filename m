Return-Path: <linux-erofs+bounces-3681-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0207CD98E6
	for <linux-erofs@archiver.kernel.org>; Fri, 19 Jun 2026 05:01:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ghQRM69Xnz3bpm;
	Fri, 19 Jun 2026 15:01:19 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781845279;
	cv=none; b=RBDKWUPz9Z6OTouyIRkllClK+eBIlKuiMG3YePpe0SmgS96CJ6nVsZAIkaxV1n3SJDBPHu9Gscl/+XfhTtsVPutsjEUldzIkusIGuWPHcmME/JKaTePKJdF3GoSfGRXHcExS/xu4qiQM2dclwJl0ZkPJGP/sbnmONXNCNxQySZvkjQN/JD0kGLiIHvVvNzGSULQ+hYX2RnAmMuRk+qUvqHe0zEK1btmnibrGtg+TsFfXmdju0CJg4IzquWkk9VRhUe09Jl6v/hHt4Bc9Cyor++zJsNRsPOBHRBlaHG/JZIiR6hrCYejpMsyx2K69iKdhKGurNOE85FTPe2dExeKPJA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781845279; c=relaxed/relaxed;
	bh=3RTdskEA4tzXBpUPTIzVtRb3u/Fp36An/J4SqIF2JFo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mg5RpKLmkgEMEyO3csSjjSs+X3lgzR5s78qLke7mgrzYLXGGVbAVra5/IzsE9PGGRtFXi6jtZpWwZZyQmp7p/2sFY7ERCRERNrHrt/Eo3UYrdLuV31VSQToTGkVk1p1unGTqylDZTScHCunKzJZ7QeGzqPGGyjOf58teVQEKfwTH9incLQW8VHZBRbJvO2zP8n9LcPnMyNI1zEAXZmSXt8xnrLZRKrosbAqG/uKJ+I5tBHp8IQ2jxQtEWhg02IbhZEFCcVWkGQOpJnmywGXRAwEsgCsh0ZyMjl/1+7H1goFiWf8oCupb7wJzb6PBve7YTlfxbCnmCXmgLFHzsUYElQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=fail (p=none dis=none) header.from=lst.de; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=KBxf7AR7; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+9d9d02d532328e2be671+8335+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=KBxf7AR7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+9d9d02d532328e2be671+8335+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ghQRK5nrvz2ySW
	for <linux-erofs@lists.ozlabs.org>; Fri, 19 Jun 2026 15:01:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=3RTdskEA4tzXBpUPTIzVtRb3u/Fp36An/J4SqIF2JFo=; b=KBxf7AR7O9I/8vH/No1JC1CG+F
	XnkEev87+xTe+fGLXth4ggbMJV/yvapF7rSHBRYXnd2BOQhAVnOheex6E7SxmQ20oFhmX3245LsFe
	deE2nuD06R4QMKWmEa+YfojzSKpZa9xagOyxoP8i7+JU4n4vzkzjhp50eAJvk3mDBrb7a00cTrlXG
	6VG4JaecJnqKsruepYFvmnwTd5M8Qy0RSp510WWRLVpCoStZ+tvlUVKSQyn8od96vNr+pXMJl/S38
	Ld0qO8GCucUPZMQJtG8KAwvKOCVIE+FpOBO6lyGilTGefQ+d+NmBIb/GMgOzjiumnJEbQaetjTfJd
	01DiwEOQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1waRLr-00000001zi3-0VdP;
	Fri, 19 Jun 2026 05:01:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Kelu Ye <yekelu1@huawei.com>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: don't build bios/contexts over multiple iomaps
Date: Fri, 19 Jun 2026 07:00:52 +0200
Message-ID: <20260619050105.439956-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this patch changes how iomap submits bios for reads.  The old behavior
to build up bios across iomap was already considered problematic for
a while, but we now ran into a erofs bug because of it, so it's time
to finally fix it.

