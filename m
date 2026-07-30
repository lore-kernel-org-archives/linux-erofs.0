Return-Path: <linux-erofs+bounces-4040-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5CD6C54FDF
	for <linux-erofs@archiver.kernel.org>; Thu, 30 Jul 2026 07:16:09 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h9gV001rhz2yDs;
	Thu, 30 Jul 2026 17:16:08 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785395767;
	cv=none; b=IZYFghnliUdjswUt7oX8RUhSLsBkYkVC3Px5uTL+S6CFMDPgeJrneJ+M3gEUeXP7v5ZPSJE4VtLzQzf/zuGvltt3XhLiYm5eihSbpSx++iRPGHaC+HqLNih/F/syHenNFw6eMcEpzx4vZzilZv+SwILiB0Tt33efmepBMCTgbJIhsGRf5+dkJMz8yodv0bo2E/UmhDxCEUZc95GtAmi4ILcODjgJ87LGwHq6DJIVBKDmRAYSznOQHGMckY+RPX4aSyI42FTEnRXHCfh4rhiviT28Z+KvtxMb3VQFddNjUwBcRYZI7XnMudDVyXx1Tc+mu3V95ojVvVILxuEn5Nd69Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785395767; c=relaxed/relaxed;
	bh=VlLomZ2ihL9HFxlrx7gRVvKB0MpDdFuMFLp7qf/zQYY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aDqjmYr2RuDnl8NO6xr5nZqntOOGvMacXod9/6GCYJRWhY3eq87rnPxULUomLKPF0yRjW0cRb0llZVIHyHagCPpVrh6l0KYSFfY5NH0T/8ZTxAjlhh/rSlSk5Cl2+2vUEfmZr4vlowvrIm+CcDPfIbVsuQaf1P2Ci/vnHR5+ZhFpiIfsp3vXrk5Lgytd0cqtRGDBFv18SVIUL6/oW4ZevQe4BQ2SRVR8QNbqKAUamVbaBvAiUOaTA2q+sLt2em4kY6C/hjGgIgZBnnghZWlhtqMDkbXDQRjwX/J7RZ+W1GzTtdXM2nKhq3XL450r4s/tO/QMeC00fAt1zXApxg5P8A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; dkim=pass (2048-bit key; unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=MpKYlVJw; dkim-atps=neutral; spf=pass (client-ip=148.163.135.74; helo=mx0a-00364e01.pphosted.com; envelope-from=tz2294@columbia.edu; receiver=lists.ozlabs.org) smtp.mailfrom=columbia.edu
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=MpKYlVJw;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=columbia.edu (client-ip=148.163.135.74; helo=mx0a-00364e01.pphosted.com; envelope-from=tz2294@columbia.edu; receiver=lists.ozlabs.org)
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h9gTz1YFwz2xF8
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 17:16:06 +1000 (AEST)
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6g36S2238417
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 02:59:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=VlLo
	mZ2ihL9HFxlrx7gRVvKB0MpDdFuMFLp7qf/zQYY=; b=MpKYlVJwcHKHdws+WTax
	xNY1KC8xJ5UwioqCDfrXm10hsZ38GifYdzzDgdp5k3EXoevWleyY1dFEYtamvhpJ
	nWsGgJa6p/YoSuJF4WIywki9iMXIn1c5Wn4DkpQGgbayfJ6qYYenwE7IR3x6i5za
	dwukXaXhPCmDnx00K9b63BM+126tHcyEXiVmjVGTroLxLwgeaoTkFFz5LrgjZQxx
	gCxc77WryoG5AoO8xqG+CIpVGqcvPcJy1Hre/qmfzNh4Lg+NyHId2TO5o74a17H5
	PMqGOiw2sWKl/vs2sNdLr6yI8HY3DLjU7PD9m6sqBVNHZv4IJI6fROiKcTd5+32Y
	+Q==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fqrjq25c9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 02:59:03 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-930f5da3467so211794485a.2
        for <linux-erofs@lists.ozlabs.org>; Wed, 29 Jul 2026 23:59:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785394742; x=1785999542;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VlLomZ2ihL9HFxlrx7gRVvKB0MpDdFuMFLp7qf/zQYY=;
        b=C8Yry75PGze3BP33EDwCKpQPa3vajbrAGZxE75VLleUBVo4iI2z1QNyv3dQAP0r2lg
         wnPcMI7VHN2SlN1X4144IWsdhBJjVheA2y3Pp0xu3fwuvPTAOPNH8SVd1+cDPYXxcE2O
         JpiUiXjpcSp1+Cs7yah0ctytPwra6J4VlCR1OQVejn38B0hBnYiLXHc0dlHwfsa24ndy
         kWhIuixW4QvFZ3Mnceqlae7KxvxFiVAHgvP653Eu/3z8UmUmV2D7h0VFHH+bh9LHv5PY
         sO3TNXN+RyHy/++c8rXGvl3SMsMpQLwi7dEtkBvf/qjHbeZUo8DVkFg18Tg3Z5MzQuwk
         NO7Q==
X-Forwarded-Encrypted: i=1; AHgh+RrMltQ8pMyKJeGkaimMSPVprs1/WTZ57Qr8fV/D0vs5/yOj4HFK2bBuwhPT8NuPOWf/or2GX75Q+8clrg==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yzx7HnLtk/9QWeeYxKV2jGx0DqmsZGp0pCtnkVcwhPXK7SxSkJV
	N1bOFLDAp0sr8RK/rXFedg5d150KZ4evt9AtsuuKLXPW8QNLuc2MzsfnM/PpSk3DRoUMmxUabQq
	uwHf38/3tEdoC8jfSbDhNej+Sp7X+rHGm7op2rzkrxp15oaXNdWKj8QvroSH+VA==
X-Gm-Gg: AR+sD12If7VDNgNlkckmT/7FJMQLLSICACIShNDvm7H7ZtfgatF/qRgG2p75X3V5nP3
	1E1KP3UH1qHE/Ju902pOaKd8Cm4Q/gCScfjBGg7wqqXcvTAwOx3jgQzJRS1RQOZcrTY2iQpt4w+
	Y5Xw29ho25YkpWmqb0c1e4WGMs7gmLwXrBHp4V8+fi/s74wJMqZzWaY2vs3M/tP8mIsS7m91nUA
	F5APi0RNLmqsMWAoRyOcSlSbn3+a7GfAdLgNVHYoWMehTO8CHCxjjr3LAUO/Cv6RUN3PF2gk28H
	Pw1l2Y7kQGOXYtRpgRWq7Qi6ODJoFo3jbacO0lm1pc+0EDDcesDZnNb10VoQIqF/t8XyFHJ544l
	SqpDPrhPYlo4oItOg16LI+VCRf2BMGmvRc/G39wsMJURXCQ==
X-Received: by 2002:a05:620a:4728:b0:92e:94a7:16e8 with SMTP id af79cd13be357-93485f9eb93mr142631085a.15.1785394742137;
        Wed, 29 Jul 2026 23:59:02 -0700 (PDT)
X-Received: by 2002:a05:620a:4728:b0:92e:94a7:16e8 with SMTP id af79cd13be357-93485f9eb93mr142629985a.15.1785394741655;
        Wed, 29 Jul 2026 23:59:01 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3221bc7sm349752485a.7.2026.07.29.23.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:59:00 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 30 Jul 2026 02:57:53 -0400
Subject: [PATCH v7 3/5] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-blk-dontcache-v7-3-3e8e6850068d@columbia.edu>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
In-Reply-To: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>,
        Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Hillf Danton <hdanton@sina.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
        Christoph Hellwig <hch@lst.de>, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785394735; l=3060;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=VqAWR9drHd5aaagFAxsb9cXKpB8GAafaVAD01CXD178=;
 b=vBSV9PuGaob7EwfUbiGv6fypiN4LKkZCFKVdXD+PIQv8LCcBMfs8U5vzkhknkhDiwC6C0Zrx+
 5R4OEUS3RiTCHa0v/202zDRtO2dKByH8pttxUhsn6U5qKVyhcv1ODCk
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: uvuOrVkvQx04K2r9sD-pqVbG2fmBhJwi
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX7Oy2x2EvkWLw
 qerUoBM7p7gebVbxfA+X6pfgwSEQAD1WPlVJPNVDwKJyPSAHo2g3fVZ9PahK2FUuwgp3njs+sDa
 S23Zu8x3jy3NZXE4ujITORYEV5Fq2U6JFYuCTnGzcsNiVrfE1Ul/
X-Authority-Analysis: v=2.4 cv=S4PpBosP c=1 sm=1 tr=0 ts=6a6af637 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=aYi4XJYX91a15INjywwA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-GUID: uvuOrVkvQx04K2r9sD-pqVbG2fmBhJwi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX0ZbobRTiFLNL
 iA1vT/LCuBHb5g486w06tMglYcz2qbY55Ex/qpFPAruVL4GsLxV+a/5Kvhaj1buhCZc4v5VS688
 qkV6SAV+G159a+/WiKlK/F27wJ9hGt0KqY//UwvdIWSJVnanT3QRh2CaypSgi0bYWh/VMc93I/k
 eMHqftQXYy8et9Q32aXIOwl0QA6+dRCDO2BNf9WTgffNHJixzSkJUfYXRZnSstx0oDSw4frXsZk
 TRyS4/EvldipB8tQUBkltoAXKfgbNsZpnXiodcaoJ5L/Eq6Ni0eYbXp9j1Pc0oznN/ayvpHRAp8
 kYGp2wtKc2Ts2nOmHzXwBeqcLEom6DMDzpty2GxMxYN7tOrP+NUNskqcjvcxCueU/s0WNqUxSnq
 S+h15PjIGSrdHOihgmclu/isqveF04ejdJfcsXr9CDeZ5rBDTJKhBQXvkLiLLPHiOg4KEG1axWp
 xLXJS1aJ7osvC2yL8Jw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11859
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 phishscore=0 lowpriorityscore=10 impostorscore=10
 clxscore=1011 priorityscore=1501 spamscore=0 suspectscore=0 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300048

Set BIO_COMPLETE_IN_TASK on iomap writeback bios when a dropbehind folio
is added. This ensures that bi_end_io runs in task context, where
folio_end_dropbehind() can safely invalidate folios.

With the bio layer now handling task-context deferral generically,
IOMAP_IOEND_DONTCACHE is no longer needed, as XFS no longer needs to
route DONTCACHE ioends through its completion workqueue. Remove the flag
and its NOMERGE entry.

Without the NOMERGE, regular I/Os that get merged with a dropbehind
folio will also have their completion deferred to task context.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/iomap/ioend.c      | 5 +++--
 fs/xfs/xfs_aops.c     | 4 ----
 include/linux/iomap.h | 5 +----
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 30468d51b5ad..1ae8a8fb8503 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -238,8 +238,6 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 
 	if (wpc->iomap.flags & IOMAP_F_SHARED)
 		ioend_flags |= IOMAP_IOEND_SHARED;
-	if (folio_test_dropbehind(folio))
-		ioend_flags |= IOMAP_IOEND_DONTCACHE;
 	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
 		ioend_flags |= IOMAP_IOEND_BOUNDARY;
 
@@ -256,6 +254,9 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 	if (!bio_add_folio(&ioend->io_bio, folio, map_len, poff))
 		goto new_ioend;
 
+	if (folio_test_dropbehind(folio))
+		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
+
 	/*
 	 * Clamp io_offset and io_size to the incore EOF so that ondisk
 	 * file size updates in the ioend completion are byte-accurate.
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 51293b6f331f..cd8de8c82d78 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -522,10 +522,6 @@ xfs_ioend_needs_wq_completion(
 	if (ioend->io_flags & (IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED))
 		return true;
 
-	/* Page cache invalidation cannot be done in irq context. */
-	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE)
-		return true;
-
 	return false;
 }
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 56b43d594e6e..68af4935a107 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -404,16 +404,13 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
 #define IOMAP_IOEND_BOUNDARY		(1U << 2)
 /* is direct I/O */
 #define IOMAP_IOEND_DIRECT		(1U << 3)
-/* is DONTCACHE I/O */
-#define IOMAP_IOEND_DONTCACHE		(1U << 4)
 
 /*
  * Flags that if set on either ioend prevent the merge of two ioends.
  * (IOMAP_IOEND_BOUNDARY also prevents merges, but only one-way)
  */
 #define IOMAP_IOEND_NOMERGE_FLAGS \
-	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT | \
-	 IOMAP_IOEND_DONTCACHE)
+	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT)
 
 /*
  * Structure for writeback I/O completions.

-- 
2.39.5


