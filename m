Return-Path: <linux-erofs+bounces-2564-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C219FD2D64
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:01:24 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXXc62Bbz3cB5;
	Tue, 10 Mar 2026 23:01:20 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=212.42.244.119
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144080;
	cv=none; b=fUBCvr9cMVcPd++jnBiNan953w6YaZCC+96oyVTXUtJ19j3rMKpVVcEWCcGzSCHSbBl/HV3he9WLhyC5SeaHO0AFSiPXPBGH8wLBXNVTninWo3sfeEZsRfj5sm+Vw3jr582fPQoBIuz8v0AG6iLrpWRYfGWjsQq73SS36Ml6lL+cJ+QSSX/EgcCKM9cy+N7eoOwdO0VZPhL0Wnotlx7g89zNdyBm7D6MY7b/dItVi7B+XGdUSKAXOxTIaBuzw+9Y8NMQEUb/sVNv4phvQlmOAl30PkTik0oU4MBqgM2oj2bnOZfJHXj8Uk9NwHDsco0L9jZ4oRoxjMD3b3Bo8FBRew==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144080; c=relaxed/relaxed;
	bh=Bw00K/cYen8HzVy4Opfh9Xr2YPOPoH4QqmKdT33VAv8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XfqsYBW45KpKbWOoKgl9FtMdCji+iDE6TxyDPsQvbtKInMfSGYTDjpySY0V31kNnVJgGvRn/yeV8xA1gc9DT+bHHjqMN3dnYfjym52k1PGafGz/eb7xIXNKc9fAGg2O5u/7FcN7Umzr0Opf9fDT6b6IyZ511kMz1j3W+DZr3x9KJ9Yl6XWM6AnSveWqnabov7fstF+PY6RcirbvbfaDJuvBM3kx+d1MBi+N/QKePBJC/6fTrMbyrgKH2NKkVUZQ2G/PDqCNLmqZDDs3vAAlPFzA2rflFfNe0XU8H+SFW+RFx3VxNnvWZlgdeBEyvhH058v8e0qSHUKeyiGL0uL7f7g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=XrOjEMLx; dkim-atps=neutral; spf=pass (client-ip=212.42.244.119; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=XrOjEMLx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=212.42.244.119; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXXZ01Ttz3cBP
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:01:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143725; bh=pn4l4Bneda6cRvLB6hSFUDCMaCdQu5yrimDpnU+4XNM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=XrOjEMLxKN0Q5AmyrWHNIKWYwAXYvxSGofpRw1fSzyTCz7O3kSu9wZMVhCigrODma
	 xaDgiBmBXDbNfcoI5fcc6yYimuO3Cnj4vKRdoox62XvE8LKZz+/gN4z3zTXbmuJ2J8
	 09unIVObBESNuzHAoxHz8OyIcq6YqGzcxhMd6Jyc=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ac-2367-7f0000032729-7f0000019d5a-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:25 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:24 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:46 +0100
Subject: [PATCH 20/61] apparmor: Prefer IS_ERR_OR_NULL over manual NULL
 check
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
Message-Id: <20260310-b4-is_err_or_null-v1-20-bd63b656022d@avm.de>
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
Cc: John Johansen <john.johansen@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1034; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=pn4l4Bneda6cRvLB6hSFUDCMaCdQu5yrimDpnU+4XNM=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYZg+c1WuLJkNtjs3nyvfVhnVwRMFZkjRyjg
 9Bta5ElUMSJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGGQAKCRA0LQZT0ays
 21AMCAC7XRT2CFV3uyPK4StoEGsXQYqMR1ynn7bit9TqTcf+0Wgtn6TYvMctAHR6A5S0MhH7yf7
 gILWOKn6+HLqPdr3lmY3ZuYwuYUr4OHhvBA9aCnbDXWOuH1dD12oVxx3wu0+3drbZUUw1a5lJWN
 hsJfyDm3gNagxfOpgqCfQqiJ9xVVghJWjS+o0/hto7AZgqOBw9ObaanKLghJUEDwwTwpQEVda2+
 0LDNyTd4iej+Ak8COmDse1KGC2gcs+EiSzfYOC0pte2fBmGM11VRcAnsxd2vAsBFmvs/mJ8XFJS
 YSqDB3vEx2vFoOZdvhWx2ECAhXN2w/fnobSlleabiSgRaViM
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143725-914AAE1F-0BAD1D24/0/0
X-purgate-type: clean
X-purgate-size: 1036
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: John Johansen <john.johansen@canonical.com>
To: Paul Moore <paul@paul-moore.com>
To: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: apparmor@lists.ubuntu.com
Cc: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 security/apparmor/apparmorfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 2f84bd23edb69e7e69cb097e554091df0132816d..5145b0c9c699514697291967c5a7b1e96b8753d1 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -352,7 +352,7 @@ static void aafs_remove(struct dentry *dentry)
 {
 	struct inode *dir;
 
-	if (!dentry || IS_ERR(dentry))
+	if (IS_ERR_OR_NULL(dentry))
 		return;
 
 	/* ->d_parent is stable as rename is not supported */

-- 
2.43.0


