Return-Path: <linux-erofs+bounces-4039-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6AD0C531D0
	for <linux-erofs@archiver.kernel.org>; Thu, 30 Jul 2026 07:12:04 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h9gPH13Y8z2xwH;
	Thu, 30 Jul 2026 17:12:03 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785395523;
	cv=none; b=arLMi0ECnEXuXBNWtRJ81+T5FbJxHAVQa2CFvdDQYXrRUkmf6yzsN3nIaCIyETwnAu3YN90SidjBx4xeWop8J2FLbiJWQd10PJeO7H9sMiRo2mnppzeB0hgH9zr2Qy7zRCUa/+KHsF90QUatMAOag/9tK7nk7dSm7YJB6Ydbfjcd12DylLgWrssH434XEos/Cy9E0psbXddXDOBEiu9kVQ5H0D4sroOSHWGuXbUIg0mgkwXFqSYIQNmKLIAuhp7JF2YUd2yXa4Z2JC42ofFbupqWJrdzuMJkDOgQOZ8oXTLdSsGJRkLg4ntEpBt/EbtX3S1clLtmq9NxDf6LpFsLHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785395523; c=relaxed/relaxed;
	bh=7lnMAQUAxGl0d0xuPXIIpzK+l0m5WwNxFhJZwOOAO20=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eDu0bD1F8VXXZ6iNmUu8pbGIUNO7Zu1l1zUEuhPdb4pQxY+c5X5dwL6iZqQgOYFAwyKpfWvCl5kSvLFk6WxtkLN/EQJuVltWD5ElQ4Emd/vh9UCVKTeEq3Evtbbv0tawLdMDbG/F4LUMi6/q7IiK4GXv8WgVzqOU/Aflo6TwGHFsTreuj8fLHyHl2Ax8H+PCYpvbse1nilX4dYnT5TcuHKDxQSnLKIsZBF45GKh80Qb5WTL9SlbhtJP+GiSjV3Q4HolEsCGUaZfl26eix8BbNY05FCwahMEy7ir98GfKjLgu5xOKfDjon6IKqWZ4rFse7guyHdrDr+ckKiQG2oSTqA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; dkim=pass (2048-bit key; unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=UCAOFlRP; dkim-atps=neutral; spf=pass (client-ip=148.163.135.74; helo=mx0a-00364e01.pphosted.com; envelope-from=tz2294@columbia.edu; receiver=lists.ozlabs.org) smtp.mailfrom=columbia.edu
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=UCAOFlRP;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=columbia.edu (client-ip=148.163.135.74; helo=mx0a-00364e01.pphosted.com; envelope-from=tz2294@columbia.edu; receiver=lists.ozlabs.org)
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h9gPG1FF5z2xF8
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 17:12:01 +1000 (AEST)
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6X31J2221374
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 02:59:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=7lnM
	AQUAxGl0d0xuPXIIpzK+l0m5WwNxFhJZwOOAO20=; b=UCAOFlRPJWowBl3rU040
	SwZ/JO6HqMmh7w10K/pEOvfmU0vwubvQfrY+WMvRgG4Sga5moOoHKNyIzkVd5Dzu
	jqfahkydSebUt3mV4LY6uMauUWmZDaLaVG6DJ8zuquGQHjwda5DXs/HyE6Xiy76v
	8X3qvA6KXU7iaDGIIoDgLC6lxS2+oXXqSPwjDJUXSy22sYMka8CJlsgohpQfkcTW
	LpH4yJB+C/7+PoeS6rF2sFhJdG/fD89iCJNYXO8aOs2edt3Xj4Q0ig8B38u3LCbU
	WIuh7wRAr4Xj+4p4ZfApoiz+Gt7hx7vC+MQhge5/0L0nuYJb4SXiEk7ZY7OWpx4g
	Lg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fqrjq25cf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 02:59:05 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-92e632390d2so335424185a.3
        for <linux-erofs@lists.ozlabs.org>; Wed, 29 Jul 2026 23:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785394743; x=1785999543;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7lnMAQUAxGl0d0xuPXIIpzK+l0m5WwNxFhJZwOOAO20=;
        b=IcD3Jzg3j6OxAqg/35MnaY3pvebaOiKDM9udv10AiUeAReiDMaql4vqVyc6YA/NZCO
         PfwdifzZ+a3oru23+SuRmMlOH6BLFksp4hx0O7aJA1X9P+U1mGwtgITct12WBrm8oxYA
         5GWxDRu1CAYe2iktTxQwoVGLRDLvDTe/WBweTFveG6ScS4wtQ4OMVqxKbsBSP5zLzgGh
         cT05BQTMQnSguuIDPwt1sNPA5OZCtARSz8eIE4SLNwjQ9Mf7GNqtiwTK1PsMVo/dQN1d
         GVfrJo9rw6j+p/+ti/uqRZca/VTSYOL07DCwgYHlDi5qF7FmxJ0TSjpAdRjvgm1yGTze
         hnuQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpsc/C+pO9OGFRaft1zDEPP0jKHcbbRFU/SjE+2MTpTWq5M4eJrwEZc/75XPWwfn+nOZxnTecK22cne4w==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YxI9eI9Kq/ImWxObP82QfNcAcub6c6nfl4xw2Nb4lYlV1HMvmhh
	DwTsAiPs/XCvKP2fmtqcA8rT27K0hrlZVX83RMSyvg/znYULuODyVVMTjZovr6ReRMBK/bQqSsU
	2/f7aNLDTvKFRmW25ZQzPzBOJF3HENXoPEpTGzOisLf1OFrv3z7eEfF7oBVzQ/Q==
X-Gm-Gg: AR+sD11PADViuLkH1QkhKRvuxUGGtUPt8V8X2RVkv7o7Aj5Hg/lpdINlcQ4e0vI5OJn
	Nahq5XY5w6l+UwI28x7+7rl1TACQ5h2rLA024f7Hl/4717XQP0SzgfkMI+IQK1E+XmnD3RCU7ml
	vGfjfG/16CLUTT+8DWlzfYeDI5NoPxDLaH9EOlVOU2b7V4vSa9YoMxVtOlmbYVHqoiGfF1rN3/P
	L0U/7ktrI21TpgQOhNMnOHJcmIXb1jUngZxgvuWntEAfHAPE9hdASDJG5i9ICmBU2eBpRkSiJlR
	IFNuHyJDH5ZNX9zu/SXgLtgl9EQf//FBJJPREESp2s8Ld09MXcpghxs1gTalM9VLa9fZTokWDNf
	n7ThicoW+JUZYAHqrccxDVm+xkwl8iV1f4Y2r+VWP4c+mLQ==
X-Received: by 2002:a05:620a:1a05:b0:92b:6805:9175 with SMTP id af79cd13be357-93486af1e68mr113648385a.61.1785394743701;
        Wed, 29 Jul 2026 23:59:03 -0700 (PDT)
X-Received: by 2002:a05:620a:1a05:b0:92b:6805:9175 with SMTP id af79cd13be357-93486af1e68mr113645485a.61.1785394743228;
        Wed, 29 Jul 2026 23:59:03 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3221bc7sm349752485a.7.2026.07.29.23.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:59:02 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 30 Jul 2026 02:57:54 -0400
Subject: [PATCH v7 4/5] buffer: set BIO_COMPLETE_IN_TASK for dropbehind
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
Message-Id: <20260730-blk-dontcache-v7-4-3e8e6850068d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785394735; l=981;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ZEoFDRdKJkaZHcFnJ/ZnxZn4DtJcz5dwb/qiVw90Hj8=;
 b=b+UxIQsoik7/2fDHnDW0olnU1/qVCDwC00Ozr0+zhh1d0+inVyiX96cXmklJSMAHbamG5lxnQ
 vFMiJx13/y+CaUo/njnCuStF0po4vXeZjTMmpT6DPvkv37PX9GBWJ6S
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: z0v9eBlkrtvlJ6XOLzTraVToN75GL14d
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX4upuSafE1H7b
 BPuIH31oNPyTltQW9qBpHT+gTrl17huOlfwcI85UMmZ5+ezu5QGBvQf5Rxdh78GAHJ02kjX/3aI
 No7Q0qOTSUz3dJCels5xaM1NAbk+7SyJbelCXQ1KGHRvcFarv3JE
X-Authority-Analysis: v=2.4 cv=S4PpBosP c=1 sm=1 tr=0 ts=6a6af639 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=WzT6SMHhq-VMa0lE35UA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-GUID: z0v9eBlkrtvlJ6XOLzTraVToN75GL14d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX6xRaDq0ZwMhz
 fiMWNyqdWuP3cnYeef+i+OI7TvWVzG01OK9kIsN3vahreJmvYeSwKd3iUdEeT+iOdmx8W5m6U0d
 qrauEKnUpSoS/m+l02wSsp6D0aaowp3npFuIqLwjI6EEdBjgejX1YycPfRPsOZOUkyKsy1D7NGD
 B1yaZGsX0NjNkAswtYol/e5BAvmhlKj5Ff6hFe7yexa1Fi8Rrab1yYQjzATRza26pK2jOAEsJN1
 ef++D5OPVa4WWXEk+RW1vjYaNdILsBuntc2hwuMLAmX+q4zsX81D/C5ubmjINjKDb8ZJUwHG77s
 MdZxFgSDIyZGHuE8DsRFaWERueLCEPH3c+qzzQvdwCnWT4rNebgP3pHJhEWEgTHGOCiSHEUBpDh
 r+06uEto1OVyyVvPFPCAIE/2sbRxajRY62IxFFHsSg+nUlC37P7+fBL1xm6kxY/ZnuzOXKOvgwU
 yLOrXoRw54x/zLIRO/Q==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11859
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 phishscore=0 lowpriorityscore=10 impostorscore=10
 clxscore=1015 priorityscore=1501 spamscore=0 suspectscore=0 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300048

Set BIO_COMPLETE_IN_TASK in __bh_submit() for write bios when the folio
has dropbehind set, so that buffer_head writeback completions get
deferred to task context where folio_end_dropbehind() can safely
invalidate folios.

Read completions are not deferred since dropbehind invalidation for
reads is handled synchronously by the reader.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/buffer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index 9af5f061a1f8..6f099847240e 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1203,6 +1203,9 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
 
 	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
 
+	if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
+		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
+
 	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))
 		buffer_set_crypto_ctx(bio, bh, GFP_NOIO);
 

-- 
2.39.5


