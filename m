Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C6DCC7EE2F
	for <linux-erofs@archiver.kernel.org>; Wed, 31 May 2023 07:45:24 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4QWLsG6Ddkz3dwF
	for <linux-erofs@archiver.kernel.org>; Wed, 31 May 2023 17:45:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1685519122;
	bh=/jnqgpU1VHrKyzX6kMpJ65m1P/gj2w4kDUJfwiq2tQo=;
	h=To:Subject:Date:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=D1qXpTGn3x2xCflwY4E47o84tWUv3BwXIbKnwlJygTVD03VauVSvdjnvVee3SzH8a
	 QdXNC/Dv2PwBVx923fYY9YM8zqo921JRtR6Pqu6jvByvcezhS/3IJe6FdvdmGHqL3K
	 j/mER2KxQGlz6voutK6yXv9+Ikj7r78NdG+BDgi5UX+iDShfzKRQXbe4IAYAj0jbeW
	 Pg0xBAkUywvUOfLoWQ02tUzWywQ505NbGtoUtRxuBlhJvG/agUose3AcPCaa5LwF2J
	 8rhTN43zLl9vlufl6XA41UGQo2VeccyMV1DUnccHhEsSwPJbgRl2PDFBhVR0NeskRk
	 hgKWAMIZ6tTfQ==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huaweicloud.com (client-ip=14.137.139.154; helo=frasgout12.his.huawei.com; envelope-from=guoxuenan@huaweicloud.com; receiver=<UNKNOWN>)
Received: from frasgout12.his.huawei.com (unknown [14.137.139.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4QWLs62Jx4z3bgn
	for <linux-erofs@lists.ozlabs.org>; Wed, 31 May 2023 17:45:13 +1000 (AEST)
Received: from mail02.huawei.com (unknown [172.18.147.227])
	by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4QWLBF5vtYz9xFZm
	for <linux-erofs@lists.ozlabs.org>; Wed, 31 May 2023 15:15:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
	by APP1 (Coremail) with SMTP id 76C_BwDXPTGi9nZk5ngiCA--.15676S2;
	Wed, 31 May 2023 07:26:30 +0000 (GMT)
To: hsiangkao@linux.alibaba.com,
	chao@kernel.org,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH 0/2] erofs-utils: fsck.erofs bugfixes
Date: Wed, 31 May 2023 15:26:10 +0800
Message-Id: <20230531072612.2643983-1-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: 76C_BwDXPTGi9nZk5ngiCA--.15676S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYj7kC6x804xWl14x267AKxVW8JVW5JwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26r1j6r4UM28EF7xvwVC2z280aVAFwI0_Jr0_Gr1l84ACjc
	xK6I8E87Iv6xkF7I0E14v26r1j6r4UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
	Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJV
	W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l
	42xK82IY64kExVAvwVAq07x20xyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IUbmhF7
	UUUUU==
X-CM-SenderInfo: xjxr53hhqd0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
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
From: Guo Xuenan via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Guo Xuenan <guoxuenan@huawei.com>
Cc: jack.qiu@huawei.com, yangchaoming666@huawei.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

In crafted erofs image, fsck.erofs file extraction exposed
some bugs.

Guo Xuenan (2):
  erofs-utils: fsck: fix outside destination directory exploit
  erofs-utils: fsck: fix segmentfault for crafted image extract

 lib/decompress.c |  8 ++++++--
 lib/dir.c        | 21 +++++++++++++++++++++
 2 files changed, 27 insertions(+), 2 deletions(-)

-- 
2.31.1

