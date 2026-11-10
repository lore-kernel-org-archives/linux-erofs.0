Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25048606A31C
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=vkmQ5QKs
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP2DW4xmzz30Wh;
	Tue, 10 Nov 2026 20:59:07 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.97
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794304747;
	cv=none; b=CVOXT9OdKVDvG86ZYkWSLAb/VWDHeXSdP6JW5IFcFCx9v9hySr78gMNvEw5F66xdxv/X91yb1b2c8Po/wjaZylN1gTbB7ad8pU6t+TON24FSG7L0rLj1OZTvDICsAyIX2LqHi6SwaJy2PC0xSx1G41sYZ8SoGc/F4rCo9sclHFsLty6xHHb4jvVfywBUzF307VBB7yxqdcdtDD6ff1DQgoQyu+9QYXoWwZA+reXe8bAG4UOF6yhJMdX4ISm1bYtpkQdUoT8GrtCditHrcPLySoBqWnhleh8Pqj/jsKAbFpT4AvhIdAvQrD7vO6oafQQC/mCwwGr6OJ4Yz0AsflF8cA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794304747; c=relaxed/relaxed;
	bh=zc11m+lkn4k6U0lam3uIogXzWEjWDwel4xEjvrfT06w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SThyIA0G+1c7AcueJ/jP7Tu3NRX2luVsuc7f5Dcjijbh8sGBKKJ8Jau+35wF6DGzZdXtkdJfZebI1GdC5dNI65zaaSqCzLqfUgvQs7+HZ2y0uMBGilcmh1fclGQxZKnx5MtdoPrTRExTbszwzK4c6q6YqH6b/G8xCJFpx4a47GzNvsFoZE5gB/r5J1zkKhaySUZesZ3YoDJarbiaKJCMcotKU5plWd4Gqgo38CGihLsg1ltI8l5UX9vo5umJiexoTOd1PLLwFw9EIcjlI+oUO6MM2qqk+fxhh7chRzjfKAwyw4Xhtz95o2REGV/lsH/FvLeOGEA4lJkbAVt6v/A3bQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=vkmQ5QKs; dkim-atps=neutral; spf=pass (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=lanbingying.lby@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=vkmQ5QKs;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=lanbingying.lby@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP2DS6zw2z30Wg
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Nov 2026 20:59:03 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794304737; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=zc11m+lkn4k6U0lam3uIogXzWEjWDwel4xEjvrfT06w=;
	b=vkmQ5QKsXNPK8a57MKaz0nkEetM5Wevogk/uLEnRnfMqnGskMRWS2goeDcSRwk5qLYWvvJod5zfimIB9RF2uj94CYDlOLi3bDYuxDgNoCQ7RgeMKzmtssO8cm40rhaUhVGBMTprIkFaciwAk/9BzIKvqyPJXwJTjFoXkl0qb9EA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=lanbingying.lby@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0XEUtKEo_1794304720;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:lanbingying.lby@linux.alibaba.com fp:SMTPD_---0XEUtKEo_1794304720 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 17:58:56 +0800
From: bingying lan <lanbingying.lby@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH 0/3] erofs-utils: preserve and reserve plain xattr prefixes
Date: Tue, 10 Nov 2026 17:58:39 +0800
Message-ID: <20261110095839.1862839-1-lanbingying.lby@linux.alibaba.com>
X-Mailer: git-send-email 2.53.0.apsara
In-Reply-To: <20261110094012.1820140-1-lanbingying.lby@linux.alibaba.com>
References: <20261110094012.1820140-1-lanbingying.lby@linux.alibaba.com>
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
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

+Cc: Joseph Qi <joseph.qi@linux.alibaba.com>

