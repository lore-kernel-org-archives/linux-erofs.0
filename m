Return-Path: <linux-erofs+bounces-3735-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D6EDCDB46F
	for <linux-erofs@archiver.kernel.org>; Tue, 23 Jun 2026 13:52:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gl62K2tVTz2y71;
	Tue, 23 Jun 2026 23:52:25 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782222745;
	cv=none; b=bnFkM44Tx63xcdQKpKv/Yk2935WPahNzHs4CApJYqBw0bjzfFvjEiy3aIcWdqTcGd07TzUVuvZdra2dFDeasUXhSt+SI5bc97xwl9NozS8Amo7becuo6uKh0Xs1tt3gXWS3Iym8T6QVrmnj7lEnCHmy8TG5gyoecArAKl9b5yySn/LbFxoOKMBVuNJtOqm4lu4ZLL6HvIALQf3A0zeNxU6HiSpPzD5w4MC3K+VCiwgSI3AjW0uA4nT3+HgMmJKXGtV9O6c6Y17J49y5kn89of16py6SCb/xeFylewKFggOM+tzjEJcMctewCk/Ks8y8NW6ddKbujEq+C1B8Be4eCMw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782222745; c=relaxed/relaxed;
	bh=PoOEKS+eDTfInw4OHh9azlmGlb94rL+G6EWiMKCHpNM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dt53gMImF5eW2izcToeneCqizsPrRAgtyQzQEOi68PEmyJhZXTxN3jnkyXe361dJ+Hysfloe9E4EiWMyr4nynGVWdSyFoV+aN1YJJfPF4Hjwd1IVbY7x0ayzsV8H1bDLqIMoW/+0z0A/CmW+sWdZujVIuBL6RSTHBYGrfJQ34JpH2eI6TbmpC3MouiX9JdGby1CXcsv3ksFT5xQL4EUb/47F2adJ5+cyWWrGce3GKSvUs/aOR+cHQ9ZAuitIOamKRblSHL+YvWV41aZiiFBDFUYFsTr++kZYmv1rn/j/VNFA4L0AEzJsp9TjyzQVUO/geITiLOmnaO0vN5bXHVQalg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=fail (p=none dis=none) header.from=lst.de; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=jn5S83jL; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+1ce5920da89166e1197d+8339+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=jn5S83jL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+1ce5920da89166e1197d+8339+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gl62H07Lhz2xM7
	for <linux-erofs@lists.ozlabs.org>; Tue, 23 Jun 2026 23:52:20 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=PoOEKS+eDTfInw4OHh9azlmGlb94rL+G6EWiMKCHpNM=; b=jn5S83jLuCl3m+DKs0KX2qnWLx
	m2yF7h06gH9mTy/pDA92JeRc2O5jP05jl4ogvEK0WS/W+H2H/z3IkvpjXXgmHUpvHT3sptVLvL7Br
	bdj61w5J3Idd4NY/Zsc55aMTtERBE7uWQwMF+2/Q1aC0sRMqxRDKFRxBcc5cshUtO69Ggren/x0SY
	h8pgGlgpkm4+nUORnZ/nDCZO9pXSB6IVG3ZOpm0ZJOk3keO0M185jKz4nbdMD+4nbb5wRCPkOSlA3
	1v37DXKZK7FKgA7oHSLZygJ36ECcR5KQ52Enk4r4EyA8A3DUt7SoRgfLPxdwc+/PDcp90jw/dz7GC
	VNZ4Ipsw==;
Received: from [2001:4bb8:2f6:ef61:5b2b:8638:3844:9408] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wc1Xy-00000006NCY-17nf;
	Tue, 23 Jun 2026 13:52:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Kelu Ye <yekelu1@huawei.com>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	fuse-devel@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: don't build bios/contexts over multiple iomaps v2
Date: Tue, 23 Jun 2026 15:51:35 +0200
Message-ID: <20260623135208.1812933-1-hch@lst.de>
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

It would be great to get the fix into 7.2 as the fixed bug can be
triggered by users.

Changes since v1:
 - don't submit fuse context after each iteration
 - consolidate some code to support the above
 - fix a bug in the fs PI support found while doing the above

