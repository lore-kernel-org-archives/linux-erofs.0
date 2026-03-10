Return-Path: <linux-erofs+bounces-2597-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BC75FD2D63
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:02:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXXs3ljwz3cG5;
	Tue, 10 Mar 2026 23:01:33 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=212.42.244.119
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144093;
	cv=none; b=TZ/26Cpkka81gHvnG4v7sTVQZXI+vmdzYwVzhA5zCNj2N2Wl8JD9vcBl+vlsmg7zWfml7sXs8QlNRTvap/kGCYObSVso0r2hpNetf75i65O6AAG5l2kJ3zidw3nMektHmfOA5t2hFyo6KJ62BgAkshlEJ99SW52sVY81KS8t9To8oPPoXinMYOZqssEeqm+un/EWyVXX3WBfNR0V8ochKtCdGJKVP1YT35s+jwVqGhZc1GdbHOYmQ6UirW60AUoqD5I4gUxAn+JghiE6o0dfd4H5JSIhenLBWV3RgreY0Y5NV7Quwn0ASF1TCryBGHLERuSde4p7/VcVlRmUNA3FBg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144093; c=relaxed/relaxed;
	bh=fFGvRlKzm+7M1qonE6vgNo7ccQBlVkvo/OM+PnyhH+0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hb+4VebLWhLmqRlm35+htkBN2DrIctVAkaMEtfLNtDUL/7UWEj5VgBH44qi8qu+NlHVnoKzcmC+GeFeDKXyf1EQBA7IXM8QtELHFqSxMzYL1oKBexrgLdOjmDqRo5oWX/KOE/HhbvIQY2e+GDbiMSquL/eq0ZSqGLFS5e6QZYzCRzsjUH2BtfnSOc9zPpGN7cVoWvTF+SKJH9tpjuO+Zvw03578qF2nu6v+nj/wcSJpmTjQMfJQtTcX3xKQX37oZdeT7Mvt7bmRX595xxJgYXHRCyAJRWWFwUtIv7lfoXtOnFRvFjxUiDR386YDUXO9D+Qm8ebeyc0Uro8FQFnFbXw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=ZioiLNZ6; dkim-atps=neutral; spf=pass (client-ip=212.42.244.119; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=ZioiLNZ6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=212.42.244.119; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXXr69Bhz3cF8
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:01:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143723; bh=KX6X+DDiGt9UXTjcCHLPV6DtScldl/2cIRjPuvT9tTY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ZioiLNZ6EfhKGMrW73+pjGIuwzOuvOKiSTcZ7wPJiCwebXNzeEOuXWZ+A1nFHvhW4
	 kJcOoKZ0VhxgqpRswcks1O+/9tUDVhOk4k88nkZD85ItDoYcz2HVcAjttfrO5CwuLe
	 NFoc05VLkE1QM4ORDb0Hi3i8FcBzsZqAPnJdPzxQ=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ab-2367-7f0000032729-7f0000019d06-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:23 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:23 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:32 +0100
Subject: [PATCH 06/61] 9p: Prefer IS_ERR_OR_NULL over manual NULL check
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
Message-Id: <20260310-b4-is_err_or_null-v1-6-bd63b656022d@avm.de>
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
Cc: Eric Van Hensbergen <ericvh@kernel.org>, 
 Latchesar Ionkov <lucho@ionkov.net>, 
 Dominique Martinet <asmadeus@codewreck.org>, 
 Christian Schoenebeck <linux_oss@crudebyte.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=932; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=KX6X+DDiGt9UXTjcCHLPV6DtScldl/2cIRjPuvT9tTY=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAXqJp0CDUjw9jEvsvX+a/KbvAdXeFk7KScmA
 k1gbpU+8P+JATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAF6gAKCRA0LQZT0ays
 29mrCACj+Vud6UtbAeAOyyVoHbFLvMA1jaglqqRGws0fgYsgwpzXFXvy2i2CmaAOIcTuq4UVTOl
 2Cp9O2MO0VDKHA4864zJOud8em6WQkYpTs1edDKjyZ8gpLnrkl+uUALuLIZHLcn32/PFl6USje2
 0rlhbB9Ue5RZDoT7EFzcp3mX899jCdSGzalbeWr5SPDgRQW0S9l7PbTpDgAvlvTr4+JT6Q76sJ+
 Xum3jXXZ29Rm368akWgnu/SoCzltjqdTHnSYloTAliMoi8hFFj6gbktEQSHRbMEzLVXTgNcHq2l
 4mfiDZbzmkqs8S8e3yaP+Mk/R/tjrHLygop2cIGzqTfhnlfW
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143723-77CF7E1F-303E842C/0/0
X-purgate-type: clean
X-purgate-size: 934
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Eric Van Hensbergen <ericvh@kernel.org>
To: Latchesar Ionkov <lucho@ionkov.net>
To: Dominique Martinet <asmadeus@codewreck.org>
To: Christian Schoenebeck <linux_oss@crudebyte.com>
Cc: v9fs@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/9p/fid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/9p/fid.h b/fs/9p/fid.h
index 0d6138bee2a3d1ab565ab2d210c0a3f3bf97e4e3..3bb7ef4380e972a2d9ab67eb4aab6cc5bfe2eea7 100644
--- a/fs/9p/fid.h
+++ b/fs/9p/fid.h
@@ -27,7 +27,7 @@ static inline struct p9_fid *v9fs_fid_clone(struct dentry *dentry)
 	struct p9_fid *fid, *nfid;
 
 	fid = v9fs_fid_lookup(dentry);
-	if (!fid || IS_ERR(fid))
+	if (IS_ERR_OR_NULL(fid))
 		return fid;
 
 	nfid = clone_fid(fid);

-- 
2.43.0


