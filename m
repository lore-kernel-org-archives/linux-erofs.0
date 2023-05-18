Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39227C77B7D
	for <linux-erofs@archiver.kernel.org>; Thu, 18 May 2023 02:46:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4QMDqy1CGkz3fBx
	for <linux-erofs@archiver.kernel.org>; Thu, 18 May 2023 12:46:06 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4QMDqp68W5z3f66
	for <linux-erofs@lists.ozlabs.org>; Thu, 18 May 2023 12:45:57 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0ViutgVa_1684377951;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0ViutgVa_1684377951)
          by smtp.aliyun-inc.com;
          Thu, 18 May 2023 10:45:52 +0800
From: Jingbo Xu <jefflexu@linux.alibaba.com>
To: xiang@kernel.org,
	chao@kernel.org,
	huyue2@coolpad.com,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH v3 0/5] erofs: cleanup of xattr handling
Date: Thu, 18 May 2023 10:45:46 +0800
Message-Id: <20230518024551.123990-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

changes since v2:
- rebase to v6.4-rc2
- passes xattr tests (erofs/019,020,021) of erofs-utils [1]

[1] https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/log/?h=experimental-tests

v2: https://lore.kernel.org/all/20230330082910.125374-1-jefflexu@linux.alibaba.com/
v1: https://lore.kernel.org/all/20230323000949.57608-1-jefflexu@linux.alibaba.com/

Jingbo Xu (5):
  erofs: introduce erofs_xattr_iter_fixup_aligned() helper
  erofs: unify xattr_iter structures
  erofs: make the size of read data stored in buffer_ofs
  erofs: unify inline/share xattr iterators for listxattr/getxattr
  erofs: use separate xattr parsers for listxattr/getxattr

 fs/erofs/xattr.c | 711 +++++++++++++++++++----------------------------
 1 file changed, 287 insertions(+), 424 deletions(-)

-- 
2.19.1.6.gb485710b

