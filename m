Return-Path: <linux-erofs+bounces-2605-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBE90FD2D64
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:05:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXd11926z3cH4;
	Tue, 10 Mar 2026 23:05:09 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=212.42.244.120
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144309;
	cv=none; b=aLcdTa/y3IXIAokPibvMK9TMohllswYsIWCw+ND8zPbCfXK32HMZ+DOWRpU9qCfRdJ+LT48nWPpmCc2ZijZFnERagGoPOBp30kZyyGJVEB5tfxrtPrV0XZiDOc8biep9R493v4toAszAXUlOT7GFTK/NWc4nVRrBUJM3L0ukt59B6lkK1m2+/OnGzs69bydcFIYCgbsWQN0SjkhBXq5WsuEJTG1rS9y3tFoj5rKBCeMesV4ysEZ+m3QJTQddOOmf5PPyMGvDKvRvDJzyGrDR99GlcaIWFxvoc0PydvFtrsIjSc9SiA97PrU+LVY2cMrddMGtHuV3O1b5lE7MImF8/g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144309; c=relaxed/relaxed;
	bh=oVRlrvP2vbgXglr+z2zhizXrLgYYAnk6ZwkJlTNfyBA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TdkE9R0HSf0Lo+iDulbjXXJYUwboOyTYaRq3ECtAgB83cKzvjTrIQj3bbA/IkSOT3uGWoGLxOeLj/cI2mnXhEfUdvL7tNyIsm/QHRahhT1dYX39bS9ojEsrYZxoe6uJAyRWtjZEFNmkjOkmZ7LCCgXcVtMWl+mQY7OOUQoGQ0R5JKvXxXm0SfBkDr3LXj0o/S2ZLtONHOMU4MoYRMJGkYACsmRfTLVV1hS8F1nAE86KoOa46hBzYmICbBRyLPR/coxr9GDzFv5HAJchaKWBLR3+Kich8klI7cLS3fCcN2SsHyVmzH/b9e+LtIalEK7ICuWJzRxnEuXg2u+1SMBSJ5Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=HvCb/8oi; dkim-atps=neutral; spf=pass (client-ip=212.42.244.120; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=HvCb/8oi;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=212.42.244.120; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXd03T57z3cH3
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:05:07 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143724; bh=Z5CcgUmxb8TIHuxVENT8+Rdbeolb2IW3uV9KbiLoZl0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HvCb/8oi+QjPTMN2Yg58hVQgISqDho2KSemsYUZ+vy5VD2bnZIm5jRkx5UuokMrry
	 Cd/bADEMvLj4WpFiDDooSYtHMuljYAEx/RujmrWNzucIvLCjqd0TnsL6u3xLqdwjKn
	 SoUF7kcbAi1lGgdxzJJB8ERoQMMzj0TR7iF4FK9M=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ab-b734-7f0000032729-7f000001bfb4-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:23 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:23 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:34 +0100
Subject: [PATCH 08/61] fuse: Prefer IS_ERR_OR_NULL over manual NULL check
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
Message-Id: <20260310-b4-is_err_or_null-v1-8-bd63b656022d@avm.de>
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
Cc: Miklos Szeredi <miklos@szeredi.hu>
X-Developer-Signature: v=1; a=openpgp-sha256; l=890; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=Z5CcgUmxb8TIHuxVENT8+Rdbeolb2IW3uV9KbiLoZl0=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAXxKvlvqCH0DwJSbq+UNs0LTyfOD3vzlRqtT
 2TRtqiRMXSJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAF8QAKCRA0LQZT0ays
 2xgMCACJUN2JSxzamJUFQvwc92wfvAAIT82LlFBC4CNAPLjUwClhfMFmMBmKAZA8HDz81VrcG/p
 fo2P5eS+rFs83E9iVI/bW+OpSphb7hd9/Pa3DNpSkaQcLQUMHw39s5ltgUYmcwhQdUpEa+pWYW+
 gg+34EAVtKnYkmIuH1aWQKSSPRHXFEEIj8Mu1YI3EnTGvDB+NleQt1zN6UaIksTNUf5+3I2W33b
 Z+hxOEmA2AEpaox3bemtlkSQbWv4qtVtcFYcWHKzhKpkUH0i5WAZ0lUSrDgtHsTI7KM+223fQQ9
 V7CmYp8rYAFlP8Yb8uQbtjIbd9Kw5z3oAZRh0mglz23o1NU6
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143723-035C7A3D-B44CD0B6/0/0
X-purgate-type: clean
X-purgate-size: 892
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/fuse/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 7ac6b232ef12323e3afb97b98301f623bce917a4..7b39c013027bd9c4ba6f080bfc9b3ec22bc2dd4a 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1599,7 +1599,7 @@ int fuse_reverse_inval_entry(struct fuse_conn *fc, u64 parent_nodeid,
 		goto put_parent;
 	while (!entry) {
 		struct dentry *child = try_lookup_noperm(name, dir);
-		if (!child || IS_ERR(child))
+		if (IS_ERR_OR_NULL(child))
 			goto put_parent;
 		entry = start_removing_dentry(dir, child);
 		dput(child);

-- 
2.43.0


