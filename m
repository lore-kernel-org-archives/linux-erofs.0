Return-Path: <linux-erofs+bounces-2595-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0064AFD2D62
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:02:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXXp25k7z3cG3;
	Tue, 10 Mar 2026 23:01:30 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=212.42.244.94
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144090;
	cv=none; b=nZfu2C1ybKcnqDlc/iDT8eTuvzGT6h4lpAAMFaksH7zqCE1CJOBqjbg7J2IOjMYi9NWl3YrNG1avk//zjs2rvBVj4TziC8jhHg/KXhvy0IfRTyoq3oB6fmRAglriFh3GLO+IuPd54h6SkeUK+NGfBF2FXZ5yeP8H6CcaLIJEsdBP7NLyBhuSQH6ga7/LHw1IOJLMymj6st0QfZvDABAs73QIT4Xv0FlmlRrHmW5bzU7bnpr0aYoBiCmqOsU1Nf0JehxsBbB89J6vSwB0rg7AY8vrlydS+/JrEHQXpmkbf/C0SQqbQDNnycMFK0p0p9RTSUubqjvCC1aKX0xGnrZt+w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144090; c=relaxed/relaxed;
	bh=ZO/wrR73FYLAl6k0Rsc8zfSsoIcYSzctfHSIfQZUiOc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AdpYVOSPr1MGRc4+reHQpELrch2PQeNtM4SSSctdOPHqLN82A5LOn06lA+3OC19syV4s5BiMyG4f0cnzB7Pq/7kMgknPdUsN5YrwWckXnTSRjGxNH6I951NoOd2lhiBhrfX3k5YtRmGw/1fBn/dAJMJpjKpY34cvO4KpX/YlLnRDtPXRocdxqBqPSeG0PzMM6DtWXLnfeMxIiKPAm5o4GCeUJDoyz/cTTE7uxiCMgfjsR+X+yRuGSZj+fC6HiP9EurXb2FYREshQO1QMvFRI7e1ayU/nLSwjJGtvoOMKqfAztkSr9Wi3/shXlzmWrDOGPBcq0NVdNxZSNshjWX2PsA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; spf=pass (client-ip=212.42.244.94; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=212.42.244.94; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXXn2M9zz3cF8
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:01:29 +1100 (AEDT)
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ac-e21d-7f0000032729-7f000001d9c0-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:24 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:24 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:37 +0100
Subject: [PATCH 11/61] pstore: Prefer IS_ERR_OR_NULL over manual NULL check
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
Message-Id: <20260310-b4-is_err_or_null-v1-11-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
To: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org, 
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org, 
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, 
 Philipp Hahn <phahn-oss@avm.de>
Cc: Kees Cook <kees@kernel.org>, Tony Luck <tony.luck@intel.com>, 
 "Guilherme G. Piccoli" <gpiccoli@igalia.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=958; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=50ahf3Ovo2xs3bKtWfsEny3TDWNoY4zAg8ay7QEz3LI=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAX7sQcV3VwS+mx5jK1HizkW2meRfNqVaBq2u
 sez6firU+2JATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAF+wAKCRA0LQZT0ays
 2xq8B/0SUo4r3rxVq9RsANPcVwQvjAVIq5IHS3vrGpufO9mdcUCVswBYAGcqVWlGUWYhZ9D5Afm
 wOzPQKPaAOE+fY5h8prRvYwP+dSX3nADwI8Y6unKqygPjUrnO+GjcQ97MVfA906q0I9/A6k6cjF
 jRX1r++tFvKvjX46AZyTpQKZC7YoNaBrH37lhDan3ZiZqsJrJDSI+f2JPLEkh5ffnrBrT1NRvPO
 /GMhxFHqkXWNux7Q6NSnWc5GTjmQY/JD/+/V9BILGVpDvPcV2orOeVbtK+hA0s3T4ekXooFahFe
 5VVhIFMEZXUHZMw53adA+fpwHBkKMznHg4ePWJsQNeHf/dyM
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143724-9167EF2F-D7D1D994/0/0
X-purgate-type: clean
X-purgate-size: 960
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Kees Cook <kees@kernel.org>
To: Tony Luck <tony.luck@intel.com>
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/pstore/zone.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/pstore/zone.c b/fs/pstore/zone.c
index a3b003f9a3a079c482b673f57023ce88fc290dbf..dce8403ca18566cc4a7a853ccdc7e1c165666fcb 100644
--- a/fs/pstore/zone.c
+++ b/fs/pstore/zone.c
@@ -1226,7 +1226,7 @@ static struct pstore_zone **psz_init_zones(enum pstore_type_id type,
 
 	for (i = 0; i < c; i++) {
 		zone = psz_init_zone(type, off, record_size);
-		if (!zone || IS_ERR(zone)) {
+		if (IS_ERR_OR_NULL(zone)) {
 			pr_err("initialize zones %s failed\n", name);
 			psz_free_zones(&zones, &i);
 			return (void *)zone;

-- 
2.43.0


