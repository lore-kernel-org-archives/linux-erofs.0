Return-Path: <linux-erofs+bounces-2556-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 955F6EB1053
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:17 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXRv4vtQz3cBN;
	Tue, 10 Mar 2026 22:57:15 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=212.42.244.119
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773143835;
	cv=none; b=DvSbUHsxyMIY8MlqVqmIybLbD5jkTKeYobkhaj6yVqqh1TMliyZGqTkGiFRf92bybxkyzRhwokonbKgtvAZUxdXth5/XVRT6nS0CK4Q4XhboP+nOEJIsCmftLHJUHr+aO2uJl10UDJVGfsMryyJaKer7LcegjRnf1+1WKu0czfIKgwVv+nr890iDjkNfl8o7oF2LFG+llI/Z88qplTFuGLpsvR8wmXRZZH0NQFEKoAVHkTLbv7HgUmUzbuO6rHTYiQz+mi0/IFvsWeaIgCtuoD+MFEalvP5a8oZ9JnyodsrN3/DY69yV3X9FL6vfgKCofS5LAfYe4MxDSxlDnhqv7g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773143835; c=relaxed/relaxed;
	bh=UqoCfhfTnRmuJC079QUYeXoC3nkqphscNqN7PPxlKOk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RPJCdvxjjw2wUUwXeAqG8N1YdCcViagd7GiDikVE5GbLeJkQzBxMLgQZ3zPFNnGXj6I67INRGkg2yYmf0wQ+OP8a2czvdbIaWmlNL8t7e2IYDmyyXUtdnIMr/lqeDdo/7ry9DYnCBA75+g5claqvVDiebfuBLeG5J0oG1x+MA1fAa/i8hoh2JweG3L8tetpYUlMgX3fBFuMQ9b09+bTNfX1ZiStAlU2MN0XSfkQfYbzFknhEkOK69Gm4TBEyYv1pfWp/GjuHPqM8WUt6RdBWNxJJ14FEjqFFsCozbZM1TcxK0VvbivE/Cit9fOL909ydA+NZon7/wfV83nMMl+B6og==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=OzCQWGEP; dkim-atps=neutral; spf=pass (client-ip=212.42.244.119; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=OzCQWGEP;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=212.42.244.119; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXRs3jrnz3bmM
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 22:57:13 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143729; bh=aOTa0J99wrUiCJDKciZIBaRSFy8AAIBeipk1P/Ry6Do=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=OzCQWGEP3xIWg4aft9Gi61CqVxzVTLKLAimjDrWeQqUc3hUkPv1N3tKeXtgO8+TTP
	 XhmqP+sFetcOut+NsJt0vEBnYbeIs2Hbr8gQtf+aklxbXgaq0RnUqAMfY7Dvjp000Y
	 AkX7mNRKwyV5huTmoXbZ4xAO9eyZ3soV+HNDBiK0=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006b1-2367-7f0000032729-7f000001ca34-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:29 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:29 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:23 +0100
Subject: [PATCH 57/61] reset: Prefer IS_ERR_OR_NULL over manual NULL check
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
Message-Id: <20260310-b4-is_err_or_null-v1-57-bd63b656022d@avm.de>
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
Cc: Philipp Zabel <p.zabel@pengutronix.de>
X-Developer-Signature: v=1; a=openpgp-sha256; l=968; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=aOTa0J99wrUiCJDKciZIBaRSFy8AAIBeipk1P/Ry6Do=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAaYTbMwEnKjO28t4NGQZrm6X1QSq5SK/k8qB
 qh4VPr1rLCJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGmAAKCRA0LQZT0ays
 21umCACxIKapQYseolYqqyBm7SyLTZbMM7MUu/ruXbxGyc49Ef4ha2YprHG4wuhRGtqa+VJappe
 JyX0Z9X9KMdJsI/T+BsTdbSpg720pNSAKbSG/WcuoRUIgTiyuqx3+IKJLG0jtFT86FOozZPOWEy
 PPGiUFAfCi7lTKlHGrGHOhGX9fNEHoC67p+hbdbdmFe+ifTERx6lzSSYvUcvltMUMt2tdHG0fgm
 mbuvPyYzKrB65Gooayr+TJ6lncMe1eo3kIkCgAS0gJFF08HI7PwP3Atbb7J7YpFYREokazErNBn
 540BWDngwOE49h53Z1ngLFPv4fl7uolW05pdRIimfw0qiceA
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143729-7B4FEE1F-3FF7DD9F/0/0
X-purgate-type: clean
X-purgate-size: 970
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Semantich change: Previously the code only printed the warning on error,
but not when the pointer was NULL. Now the warning is printed in both
cases!

Change found with coccinelle.

To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/reset/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index fceec45c8afc1e74fe46311bdc023ff257e8d770..649bb4ebabb20a09349ccbfc62f8280621df450e 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -715,7 +715,7 @@ EXPORT_SYMBOL_GPL(reset_control_bulk_acquire);
  */
 void reset_control_release(struct reset_control *rstc)
 {
-	if (!rstc || WARN_ON(IS_ERR(rstc)))
+	if (WARN_ON(IS_ERR_OR_NULL(rstc)))
 		return;
 
 	if (reset_control_is_array(rstc))

-- 
2.43.0


