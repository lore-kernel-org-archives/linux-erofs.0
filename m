Return-Path: <linux-erofs+bounces-4234-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A99CC5DF6E
	for <linux-erofs@archiver.kernel.org>; Sun, 16 Aug 2026 13:07:24 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hNGTQ3wkwz2xwM;
	Sun, 16 Aug 2026 23:07:22 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786885642;
	cv=none; b=TgAq553y7pbQtmpSSRAMG1YL946Hm9fNkvKcBZ++cOwlfB1/2ItO2FmYCjFITT0hj9Toto2Rv98gV8uEGsHtifltXWvE+gTSECWOhOMawoCv7A7dta+1XXbI7TTQtpg3g3SQN01J6pofeYQekNpiGHg4fKvAsigYdjXYYwphybYf8hT9M34J0rIEMGk0iKMcgnZOfeYRBjtVlRnGpQt3SlA6aU0b5VwffcI28sqdxJTMfjEaE8tohHr4yUZ8dUWKxL8S/J3eYSgye4o4wpdA6eBWS9IKR7ycCbvLwOrisT0Ao6EnX9k1EhUf3iSwiTrk/NUc6UJjyawVoneK62YlhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786885642; c=relaxed/relaxed;
	bh=rz+hKesUm5LQKGvenpBVjjK/M8DTaKet2HnibsIRb5g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X6OLuEMCI19t9SDcE5heNxXo0zxMWUvzHe219Y4oUiY8CxjLE92655fGxe92PwLs8+s6IskihfdL0ggzuwmqefCwb8IT1odg76bvN+1ROsrXvQZF3wNWht02TGW2csraogLgpFniWMKN5S3yl7HhZOS1TKYyCzk/919APYTOMaogwqq31FkchbYJx7V6eWwxvyA66HtyUq+TBrsnOTWhxKqTDjkwRnyUqbZE0lXzBk17uUENwqsZI6NWdBUfS9ens9ZpXftEQLsM2Ii0OSt7wJRsyNSSH9Jfll7mfT0dcqvTFZoEDOB1BhLzIKTKRWmr5zTgBziB9k81/+8wEfzERw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; dkim=pass (2048-bit key; unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=g2+r7KzE; dkim-atps=neutral; spf=pass (client-ip=148.163.156.1; helo=mx0a-001b2d01.pphosted.com; envelope-from=ojaswin@linux.ibm.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.ibm.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=g2+r7KzE;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.ibm.com (client-ip=148.163.156.1; helo=mx0a-001b2d01.pphosted.com; envelope-from=ojaswin@linux.ibm.com; receiver=lists.ozlabs.org)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hNGTP5Gycz2xft
	for <linux-erofs@lists.ozlabs.org>; Sun, 16 Aug 2026 23:07:21 +1000 (AEST)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67GB1QDc2486556;
	Sun, 16 Aug 2026 13:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=rz+hKesUm5LQKGvenpBVjjK/M8DTaKet2HnibsIRb
	5g=; b=g2+r7KzEaf0OwyeUDQjhM+YX8FiOWo9+TOWPUUS7qNS+JBfpEjKsrmlfX
	ajFYpLUCLcIITtw6fWkPIRAjHtkeMSAczuR7QLx3cO30OKuS0NLXWanGZaRoDo/U
	O1/vJwLjmDjx4oh5p3IukVoueBGEBqlqcLBfDScUFj9nCVW0SrlMj/Ebka9pRiKN
	Udts3X0YTUaHAX98hinNRsTI/QOHWde8RjfZDDDgL+OUUpL2wPqWfSocoIwLKtPD
	00oiKg23uS89+VgRhc7Z7lLmL35KYPNEvp6m+KwGM3OYUuwyqm0gtnMI5aZoPGGt
	FfQmE1RI/2KIK7QGhlY1h/rgZ3CHg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2fu4db07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 16 Aug 2026 13:07:17 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67GCucsW021491;
	Sun, 16 Aug 2026 13:07:16 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g354y1a5h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 16 Aug 2026 13:07:16 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67GD7EwN47448478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 16 Aug 2026 13:07:14 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F46220049;
	Sun, 16 Aug 2026 13:07:14 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 63B8120040;
	Sun, 16 Aug 2026 13:07:11 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.17.50])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sun, 16 Aug 2026 13:07:11 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
        Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <hongbohbli@tencent.com>, Chunhai Guo <guochunhai@vivo.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] erofs: fix unused pcluster_pools for higher page sizes
Date: Sun, 16 Aug 2026 18:37:08 +0530
Message-ID: <cover.1786884312.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
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
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: wybZggqbW3EdyCReKtdj2aNEOz3itYIM
X-Authority-Analysis: v=2.4 cv=NLLlPU6g c=1 sm=1 tr=0 ts=6a81b605 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=YVvUhAtAW8BG0TNbuoAA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE2MDEwMyBTYWx0ZWRfX7w3gDTyYXZBg
 VbJXFcHHa1TyhCoVxZdIp45ePK/PJlKIiogPdVxSpX+JPxeET9YT3lePW/Rfnin3PiJvdCe8Qbb
 pQeqij3LDUcLip2GAFXx6VDWgEQJa0c=
X-Proofpoint-ORIG-GUID: oYZ1P6jcpP6CgrixDxMdNLOZ5iAPTOwq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE2MDEwMyBTYWx0ZWRfX6/4yMreFiWmn
 ETUO6/A8RW1MT7g/MRF3yJ8dC+Eo47xjYaMb8wako6zomDfKPAqAAY/+GIViGlLrMa9MP4AGh3h
 j8OPMnvbUMwOef3Dvd1VZnvuo+bMmHD68H7vCa5EBqUj/pAoJner+o6WbsVqLgpxSHyWlFNRSDn
 RgdFAMZgYt2brBHi9VnT3NiQd798VngwQoH+0kY0fPYzycTvaYfkg+zXZ3leChBnfzLVUi0a/+g
 BqVexRUY5BWf689LMVVk/FuF0C3m96A+8zdQCSKJRmLrkjqG5cqPo9EAC8fTeML2yxLC820ZhXs
 gb8H0TwpektyQz1f2It9rE1xB1KanandrGPrKo5YtVupfOgCabjN0nchJXSl2QAsknnvvD6XU9G
 lyoZVfWzWxf86wwXJ2AgDB7HwmNVvW5OHtkbdx6M6cOXCL5MldaEc1Phxk05IhqLmtgvzbNH9Zb
 oOxhbns764BSxdTxqpg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_03,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 malwarescore=0 suspectscore=0 clxscore=1011 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608160103

When inserting the erofs module on an older kernel with a 64K page size
machine, we were running into the following dmesg followed by a stack
dump (Needs, CONFIG_DEBUG_VM=y):

[    4.616501] kmem_cache of name 'erofs_pcluster-16' already exists

The root cause is that on 64k page size:

  Z_EROFS_PCLUSTER_MAX_PAGES = 1M / 16k = 16

and, on that kernel, our logic to create the pcluster pool is as:

  static struct z_erofs_pcluster_slab pcluster_pool[] __read_mostly = {
  	_PCLP(1), _PCLP(4), _PCLP(16), _PCLP(64), _PCLP(128),
  	_PCLP(Z_EROFS_PCLUSTER_MAX_PAGES)
  };

so we were ending up creating kmemcaches for nr_pages= 1, 4, 16, 64,
128, and Z_EROFS_PCLUSTER_MAX_PAGES (=16, again). This caused the 
kmem_cache sanity check to emit the warning.

When comparing with the upstream code, I noticed that this issue has
been fixed as a side effect of the patch:

  commit 7361d1e3763baaf7b9349c576137851458ad38d1
  Author: Gao Xiang <xiang@kernel.org>
  Date:   Mon Mar 10 17:54:59 2025 +0800
  
      erofs: support unaligned encoded data

which changes 

   static struct z_erofs_pcluster_slab pcluster_pool[] __read_mostly = {
          _PCLP(1), _PCLP(4), _PCLP(16), _PCLP(64), _PCLP(128),
  -       _PCLP(Z_EROFS_PCLUSTER_MAX_PAGES)
  +       _PCLP(Z_EROFS_PCLUSTER_MAX_PAGES + 1)
   };

and hence the final cache has nr_pages = 17 and doesn't clash with the
nr_pages=16 cache anymore. However, this is still incorrect as on higher
page sizes like 64k we will never use nr_pages > 16 and the rest of the
caches are wasted.

So this patch intends to fix the issue on upstream first and if the
approach looks okay, I'll send a backport for other the older affected
kernels.

Regards,
ojaswin

Ojaswin Mujoo (1):
  erofs: fix unused pcluster_pools for higher page sizes

 fs/erofs/zdata.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

-- 
2.55.0


