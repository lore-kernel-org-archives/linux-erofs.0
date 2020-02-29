Return-Path: <SRS0=ylHl=4R=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD409C3F2D4
	for <linux-erofs@archiver.kernel.org>; Sat, 29 Feb 2020 04:52:16 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6082C246AF
	for <linux-erofs@archiver.kernel.org>; Sat, 29 Feb 2020 04:52:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="miz9mRId";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aol.com header.i=@aol.com header.b="ES7xH2ip"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6082C246AF
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 48TvCL687FzDrMh
	for <linux-erofs@archiver.kernel.org>; Sat, 29 Feb 2020 15:52:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1582951934;
	bh=k0b8AAYYA3VkoymouIkFrpsFB1JLdDqIVONFnUCi5ts=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=miz9mRIdXb4ZpkPslV8Rf5qX2bGwNBzJOmIIX5F9z07s3sIS29XofJkDJtTxwA6Dm
	 6U2F0SMbJDZ8FJtl94E06IubuHy93J7NPqA02my51/kDwgAkq7xkey1dpVylHzJF7x
	 AMnDSakJo/6ygaTw3IYBHvrlG/iPSMd2xe4oQ6R4yxNkavQ0s8mXrYKRcdhSpjvNGR
	 ztLE8L5IxgPa3q48Ax1mNY15avoHtsA2xBRIM6DlmcRVauvpKzuwJKTRay/hIGXyKM
	 n43cj2GHQIUnouJl6ytz7Dr8GkNCOihClJywghVlv0ceqLIYh287lLzXvDkO0eN62D
	 h7pFKqOuoFd3w==
Authentication-Results: lists.ozlabs.org;
 spf=pass (sender SPF authorized) smtp.mailfrom=aol.com
 (client-ip=98.137.64.146; helo=sonic301-20.consmr.mail.gq1.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.a=rsa-sha256
 header.s=a2048 header.b=ES7xH2ip; dkim-atps=neutral
Received: from sonic301-20.consmr.mail.gq1.yahoo.com
 (sonic301-20.consmr.mail.gq1.yahoo.com [98.137.64.146])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 48TvC91pk5zDrNY
 for <linux-erofs@lists.ozlabs.org>; Sat, 29 Feb 2020 15:52:04 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1582951923; bh=sWwoxjNs+0RMcYdgNq+4B1nQ66wdRjmjTpjZfYy9Hu8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject;
 b=ES7xH2ipB809c2WfrvbgL8Ehx8SevCYfGmzgL4RoQQGeoXf66ciItau+qBe92lLREjsotxtvphAXHShelNPbJRK2rbr7ybx/8dQYoa9KV1k1gcCV06S259LdXz6DG0uqd9KN3imxj2gcpEXFOmAc8Qls1dyMjf3OognIhOhJVGWddorcmr0lAwQ9l2XvA5CM2WN3f9MulLS/3fz8J3MteahuvLiUBbqf9vrX+qaf/h+h0xoCbwm+z6HXDutJhJWRR0DalAZTKBhllAe/PTFQmTluoFvdXgmpUI8+OIy28NOYpP6A+LV7EqJUAxRjrfjdzMiKE0W7HpiCJ9wuPFyxZQ==
X-YMail-OSG: lM2wvvoVM1nZQlCK5NWXpCOGCXJAbR2QkOO6tDX4jR7gqnE97Vw_oXFgzjLu8Zb
 xV_kH6nuyIuWdUYkkB8Wh_R3o3yUyq2eJeaLdjjAMVYd8rQFBvqMonDhS4ohU3s6VZ770vaBDSO7
 8E8vWWI.ApT_no9OljsdyJi5KP.U3fy9AON4jUxfqPem53ebO9YbmieuWImZ8D35MzMsXMLlKsu8
 E4BBYgBLe9yZFJv0VmiAym7DUXnjIasR3Plqr2G04tHMWeMXJALQ2cc4TeCuHDkS0CevxfITnFNj
 THgusDDzQzGtIGfeyRzBOl50ULZI1u6a6H_hbeF.g5Jd5AYT2tuvdYt4uP5vS471PoFC1iUONmqT
 p1dn7pBRbEELEtLOUPdqH41jW19Ry6uroJeV_SnrrpXiZFq7BXNsZULo_bcEQH.yErtC1yH3fS69
 YOnOkGqNw_UG3HDXOIdTMnJMOzFnQzJ6.EXNcMJ28MODmoF8WcE3DrBVgh4L2.GgDnEvzj3tVS74
 kKp79UYPq8MqTNlymBC5Sg3oIpuHTsTsEUl9x5QbRaOZHmGYSPLJ1AQz4qmEqGIAclTvCVcMN2Dy
 IposTleNNclCWxnk.8gIUdVfn1vyJc3OqLkcRh9d9GYGe2bObsJmxiiPMG7CZ1hclVl7tF.FPZ3N
 C2QbzGRW8BRBkU.ILfFBM2o8oF5bMs1L_Vj6VhmbrF5NAibPr0.cUPQkb1lxmpIFUpbAVn9sammd
 QDjLSB7mDBX_aaUUVXXJe9X5_76u_T0QL_fQtCIeccrFObdR5DnTHHXCdd0CW9tHNX.OThpzMpKU
 Fl7T8_FhboGg_xr1lSvJCfM_R7h1p6HHYdonzaZUoo4RoJeQRwKwOlInbYgri1IVLcL47vAqeMUz
 SiWRFOnq9cX7Ym42Qrp44S0vgx2aPcR_NfRneOwBQpKqaH6gzx4Xg.jx3jjirGSM.gXf9jqgJIsr
 z.ygh8QnezmPvZJAg1mH6mDLTCD7IEL3RAdJmDwZsHl43GTzaSycNjSiEuL3caDjDb1F5xVhB8Y3
 u9TRoqRl5WjcTlf7gTmgbaBXeSNkClnBZUQlH_ngYWeIYT4Smmx5s1lr7d8XjXRdSGRvPTjFqjuk
 X9E2kd_OGTNK26D9cyB59NFsmuFs1c77CeMo5JoXl_Da8_Emhgl1a65u5_sQATuubV0DLg5U4p_S
 zS0T9mWha1uG3618sMfsMwGTgynXKqiXl28117_klSS4Ht7zxq81A1ibux9UIFBn8UbFURZWSdOw
 PSwNG6WaAIhHF6QG.s01hSZrshVB2aUIEqbxxNviOUimkdzecD9L64HXSorlit2BnHf4lcdh4bk4
 QyzkLBZhGjoyqNBEVraP4t_r8g3RT_vA1QnwGhb34yGzH8ZVhhMG6zsS4CW9NJhq8zMXZ6DLav0p
 HS4kMAgT.kZlEepkrI.H2Gxubba2jRw--
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic301.consmr.mail.gq1.yahoo.com with HTTP; Sat, 29 Feb 2020 04:52:03 +0000
Received: by smtp409.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA
 ID 16922bddfd3cbd213433d5c12bb81660; 
 Sat, 29 Feb 2020 04:51:59 +0000 (UTC)
To: linux-erofs@lists.ozlabs.org
Subject: [WIP] [PATCH v0.0-20200229 09/11] ez: lzma: checkpoint feature for
 range encoder
Date: Sat, 29 Feb 2020 12:50:15 +0800
Message-Id: <20200229045017.12424-10-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200229045017.12424-1-hsiangkao@aol.com>
References: <20200229045017.12424-1-hsiangkao@aol.com>
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
From: Gao Xiang via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Gao Xiang <hsiangkao@aol.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

which is used to save the current state of range
encoder for later recovery in order to implement
LZMA fixed-sized output compression.

Signed-off-by: Gao Xiang <hsiangkao@aol.com>
---
 lzma/rc_encoder_ckpt.h | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 lzma/rc_encoder_ckpt.h

diff --git a/lzma/rc_encoder_ckpt.h b/lzma/rc_encoder_ckpt.h
new file mode 100644
index 0000000..415bf0c
--- /dev/null
+++ b/lzma/rc_encoder_ckpt.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: Apache-2.0 */
+/*
+ * ez/lzma/rc_encoder_ckpt.h - checkpoint for range encoder
+ *
+ * Copyright (C) 2020 Gao Xiang <hsiangkao@aol.com>
+ */
+#ifndef __EZ_LZMA_RC_ENCODER_CKPT_H
+#define __EZ_LZMA_RC_ENCODER_CKPT_H
+
+#include "rc_encoder.h"
+
+struct lzma_rc_ckpt {
+	uint64_t low;
+	uint64_t extended_bytes;
+	uint32_t range;
+	uint8_t firstbyte;
+};
+
+void rc_write_checkpoint(struct lzma_rc_encoder *rc, struct lzma_rc_ckpt *cp)
+{
+	*cp = (struct lzma_rc_ckpt) { .low = rc->low,
+				      .extended_bytes = rc->extended_bytes,
+				      .range = rc->range,
+				      .firstbyte = rc->firstbyte
+	};
+}
+
+void rc_restore_checkpoint(struct lzma_rc_encoder *rc, struct lzma_rc_ckpt *cp)
+{
+	rc->low = cp->low;
+	rc->extended_bytes = cp->extended_bytes;
+	rc->range = cp->range;
+	rc->firstbyte = cp->firstbyte;
+
+	rc->pos = 0;
+	rc->count = 0;
+}
+
+#endif
+
-- 
2.20.1

