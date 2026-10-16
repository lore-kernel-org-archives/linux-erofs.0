Return-Path: <linux-erofs+bounces-4740-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90D0CCC6B38
	for <linux-erofs@archiver.kernel.org>; Fri, 16 Oct 2026 04:11:59 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j5WjT26vYz2yNj;
	Fri, 16 Oct 2026 15:11:57 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.28.5
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792123917;
	cv=none; b=b8bfsE1v2KJ0FnLDbQ+/DAYynhxMmrLHqzi9yC73g+TsZbssrPQ6FuEUjaqYNc1k1av4b3lqciFNOvhz4G9lBC3LxB4jfqQyjlAs4wbbtPxmnnxvIEj0sUHy595Hn7kFJO9tju9ijkkvFAs6ZaiBbB0IvzmGNG/HFmAN6zgOg54zUQHIocCDC+YtpTgrIcJJWpBcCZ3ycEsuKsnDSgMQWgPAsqkd+3/ZLN3D9lsSqcxL+gW9kdg3PJG8PsKaEwfjAFFurXhD6TdnekgAevu68A7P2EyQN4UIprUpdEtHcOXTG1pE9l55Aybe/N1/1un08zambajJ6e41CMsq/jaLkA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792123917; c=relaxed/relaxed;
	bh=vbO+vifKiqBGD5SfF2m4S6cQe/JLEOcIEjOjSAHPgdU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P55U3bLyGWtY68nmRfMaf+2lImt6+YtF+T3/HDwvSKgISr4va8weaCNWAk/8XrmKH4H786FCJ/mT0AQKacqec/DBElGPRfPEEotTgbIrG/7j2ZMhVf9f8dhfnsy3ODuB23U6TQxZbwFkQFfo18KGO6DjhtYNJwU8RrG3zdEd1GwtAeRFtPEphFWavXddakbNd3KjU2VVHFrgSZtuX/704wmXO1rWY/8mnRgH/uNZVJuNLPx5NwpoYUpwD33REdXRJE/QEFZWzj1U2GKO+1hX6qcFu0+voGgd1DS+IJWR4Va/9/U7DSwRvQ2Um1HtaCS5FNfjEhIoSzZ1EfHpG2Yjyw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; dkim=pass (1024-bit key; unprotected) header.d=xiaopeng.com header.i=@xiaopeng.com header.a=rsa-sha256 header.s=default header.b=GCWqHgBT; dkim-atps=neutral; spf=pass (client-ip=115.124.28.5; helo=out28-5.mail.aliyun.com; envelope-from=liuc63@xiaopeng.com; receiver=lists.ozlabs.org) smtp.mailfrom=xiaopeng.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=xiaopeng.com header.i=@xiaopeng.com header.a=rsa-sha256 header.s=default header.b=GCWqHgBT;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=xiaopeng.com (client-ip=115.124.28.5; helo=out28-5.mail.aliyun.com; envelope-from=liuc63@xiaopeng.com; receiver=lists.ozlabs.org)
Received: from out28-5.mail.aliyun.com (out28-5.mail.aliyun.com [115.124.28.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j5WjQ39Qsz2xNC
	for <linux-erofs@lists.ozlabs.org>; Fri, 16 Oct 2026 15:11:51 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1792123906; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=vbO+vifKiqBGD5SfF2m4S6cQe/JLEOcIEjOjSAHPgdU=;
	b=GCWqHgBTcf76B2VC5guewxzURc/ErKmSp2Aeo8FNNfevV+Fq6sVntr3a0TSpQ/cF1OLpcNXynnZnDvEQeEgvzgjjraDsOXNCDXZ4+oPW9yd0IWqUyVXIdDOUBg+Bc7ssS44QBJw6Z4kOUkFmANrqS2fB0S6XP2cR76fa56itA/Q=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.09093241|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0151924-0.000875209-0.983932;FP=17779160273956545723|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037006180;MF=liuc63@xiaopeng.com;NM=1;PH=DS;RN=9;RT=9;SR=0;TI=SMTPD_---.jg1YhS-_1792123903;
Received: from localhost(mailfrom:liuc63@xiaopeng.com fp:SMTPD_---.jg1YhS-_1792123903 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 16 Oct 2026 12:11:44 +0800
From: Liu Chao <liuc63@xiaopeng.com>
To: Chao Yu <chao@kernel.org>,
	Chunhai Guo <guochunhai@vivo.com>,
	Gao Xiang <xiang@kernel.org>,
	Hongbo Li <lihongbo22@huawei.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Yue Hu <zbestahu@gmail.com>
Cc: linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] erofs: fix unsigned underflow in LZ4 in-place decompression
Date: Fri, 16 Oct 2026 12:11:43 +0800
Message-ID: <20261016041143.2293155-1-liuc63@xiaopeng.com>
X-Mailer: git-send-email 2.50.1
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

z_erofs_lz4_handle_overlap() computes the overlap offset between the
input and output page arrays as rq->outpages - rq->inpages.  Both
values are derived from on-disk pcluster metadata (pcl->length and
pcl->pclustersize) which an attacker can set independently, so
outpages may legitimately be smaller than inpages.  The unsigned
subtraction then underflows, causing rq->out[] to be indexed far out
of bounds and the returned LZ4 source pointer to point past the
output buffer, resulting in out-of-bounds reads and writes.

The in-place path is only valid when the output buffer is at least as
large as the input buffer, so guard the branch with
rq->outpages >= rq->inpages.  When the condition does not hold, fall
through to docopy, which copies the compressed data to the per-CPU
buffer and decompresses safely.

Reviewed-by: Fang Xieyan <fangxy@xiaopeng.com>
Signed-off-by: Liu Chao <liuc63@xiaopeng.com>
---
 fs/erofs/decompressor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 354762c97..50a5f9ddf 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -117,6 +117,7 @@ static void *z_erofs_lz4_handle_overlap(struct z_erofs_decompress_req *rq,
 		oend = rq->pageofs_out + rq->outputsize;
 		omargin = PAGE_ALIGN(oend) - oend;
 		if (rq->partial_decoding || !may_inplace ||
+		    rq->outpages < rq->inpages ||
 		    omargin < LZ4_DECOMPRESS_INPLACE_MARGIN(rq->inputsize))
 			goto docopy;
 
--
2.50.1


