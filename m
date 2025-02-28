Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B94C8C282D0
	for <linux-erofs@archiver.kernel.org>; Fri, 28 Feb 2025 16:57:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Z4DsL650Dz3c7F
	for <linux-erofs@archiver.kernel.org>; Sat,  1 Mar 2025 03:57:26 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=195.16.41.108
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1740761844;
	cv=none; b=gup5XYoyh8hAAam0Kg1BsexM4UrboqpOBTTIZQ7ZvOVBnidUnh7Nb29/jLVrWOS/44VrjBjpU/TNT074K0HGLca6L5BZWaHusENV2MCL9+KHSgjynE1srj6G9Z+kL21ScPYcMAvqmPEGhN7fELpyHdFN7pSfigJ+GLP2nN/v82TplcAbKckWR3X4fcLnuMN/FAuS3HgoIBZs9Kd/mmJ5sH6fexwSj4jCf/yPLJnwiK7GeQ1F5KVtL0zuYe880znvMb+5UIzB7yYzyznZH1UcOz3ioCxThUdyhMmuQ6m9jYSiuVrIRZuPpPvsJJUqdHE8ZknWYZwcC86LH+HSkYxZdg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1740761844; c=relaxed/relaxed;
	bh=kRQ70sVXyqLeMUokAjV42mjATF1YB0UFdNJz6A64LDw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GUoy9XPtM3M2HxhbpDut7ngLwrDFCXPGHT2tVO+5IMdsVFynBolv6WenAc6Vl31xfhxrhhS32eoEjPThtuGbauIiI+/F3qSPeAGJNx4XmnmtpMj7gVgjd8XILul6Sipsyz5IwI6nYHFhcRnkMfiXZregTQo9yaO+BooAw+4Y1OjOk5KfyYY5SOZGbUaV9ZFR4iHORvHWOcJn8OSYFCWbQ9ABiuxSlaD9rbjGraXr0O+M0pKstHdUzdqRZs+qJd/7LUx3VPG3oKJj8RHr6Fy32CY9rXP1UcMHAQxQVdRLIhAHN5KnpT09O0vsC9MzZCr13mpuAJxFLfVDzaVk/1O2hg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=astralinux.ru; spf=pass (client-ip=195.16.41.108; helo=mail-gw02.astralinux.ru; envelope-from=apanov@astralinux.ru; receiver=lists.ozlabs.org) smtp.mailfrom=astralinux.ru
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=astralinux.ru
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=astralinux.ru (client-ip=195.16.41.108; helo=mail-gw02.astralinux.ru; envelope-from=apanov@astralinux.ru; receiver=lists.ozlabs.org)
X-Greylist: delayed 330 seconds by postgrey-1.37 at boromir; Sat, 01 Mar 2025 03:57:22 AEDT
Received: from mail-gw02.astralinux.ru (mail-gw02.astralinux.ru [195.16.41.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Z4DsG6YCGz3bnx
	for <linux-erofs@lists.ozlabs.org>; Sat,  1 Mar 2025 03:57:22 +1100 (AEDT)
Received: from gca-msk-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw02.astralinux.ru (Postfix) with ESMTP id ED45A1F9D3;
	Fri, 28 Feb 2025 19:51:41 +0300 (MSK)
Received: from new-mail.astralinux.ru (gca-yc-ruca-srv-mail03.astralinux.ru [10.177.185.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw02.astralinux.ru (Postfix) with ESMTPS;
	Fri, 28 Feb 2025 19:51:38 +0300 (MSK)
Received: from rbta-msk-lt-156703.astralinux.ru (unknown [10.177.20.117])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4Z4Dkd0wkWz1h0PW;
	Fri, 28 Feb 2025 19:51:37 +0300 (MSK)
From: Alexey Panov <apanov@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.1 0/2] erofs: handle overlapped pclusters out of crafted images properly
Date: Fri, 28 Feb 2025 19:51:01 +0300
Message-Id: <20250228165103.26775-1-apanov@astralinux.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected, bases: 2025/02/28 15:31:00
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: apanov@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 51 0.3.51 68896fb0083a027476849bf400a331a2d5d94398, {Tracking_uf_ne_domains}, {Tracking_internal2}, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;lore.kernel.org:7.1.1;astralinux.ru:7.1.1;new-mail.astralinux.ru:7.1.1;127.0.0.199:7.1.2;nvd.nist.gov:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 191391 [Feb 28 2025]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.11
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2025/02/28 06:44:00 #27492638
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected, bases: 2025/02/28 15:31:00
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1
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
Cc: Max Kellermann <max.kellermann@ionos.com>, lvc-project@linuxtesting.org, Chao Yu <chao@kernel.org>, linux-kernel@vger.kernel.org, Alexey Panov <apanov@astralinux.ru>, Yue Hu <huyue2@coolpad.com>, Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Commit 9e2f9d34dd12 ("erofs: handle overlapped pclusters out of crafted
images properly") fixes CVE-2024-47736 [1] but brings another problem [2].
So commit 1a2180f6859c ("erofs: fix PSI memstall accounting") should be
backported too.

[1] https://nvd.nist.gov/vuln/detail/CVE-2024-47736
[2] https://lore.kernel.org/all/CAKPOu+8tvSowiJADW2RuKyofL_CSkm_SuyZA7ME5vMLWmL6pqw@mail.gmail.com/

Gao Xiang (2):
  erofs: handle overlapped pclusters out of crafted images properly
  erofs: fix PSI memstall accounting

 fs/erofs/zdata.c | 66 +++++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 32 deletions(-)

-- 
2.39.5

