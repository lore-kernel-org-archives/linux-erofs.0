Return-Path: <linux-erofs+bounces-2563-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 260A2FD2D64
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 12:01:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVXXb3cftz3cCK;
	Tue, 10 Mar 2026 23:01:19 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:bf0:244:244::119"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773144079;
	cv=none; b=EY2MSYod1ZHYfP6O2vbZ2X5+BHbsHBkL+DwVd5kBv5bbUAhTykwreye3SizKxpcXkSf4C8ehXurIMYEflzy9HEBIxkdPrR9GGFd4JPGjimxHJ4uZnhJbr652VlXqyobCqGPnzq5IYgdmFZ56CXtrsAlt24cD+Ry2tode8g5lr3IAMa+D8VLUJlGRlk9AEBsaB7Q8lwnrcO++WxHYS+rWng6DuXkSa4krbN6c9XikjVKnkv3dVch3zQiUIzJDupY+DzzCt/8sy1jz6JhMFvC6N2ilTMg10SPLeoJ0AxxdBg1oCJPYBAFjapMk1lX9L7pz5NNC49JWIBQcEgnuMno6hg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773144079; c=relaxed/relaxed;
	bh=x7yqvKgRQlPCuPxWpeGgWE7MFZhfk9JfcC1gFXD6dw4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Uc3Q04YG4muMC0KaQq4vBY4oetRaerHX1VZf0lz9kS/7wgpVfYlXcKBBFfLS6ZUP6IKTwtEAqCkCJTKJJic/qkbVZ9vsczTQyoT0x4wF2E1IxA+cKXYbKEhBtAl1G7casMfDsVZ2Y6PRSF7xCb6OWJnLiCY8sSAkGz7lSzTKUt4SqDbmcd/+f5fzkgFWRzfA6shrwjlKcFW/EcBD/RNbSBtfaggXjEdI3h9KDHQUvoXuK7RYAsX0aoPn+LhXgv9b0yZvq6GvpCkoxanG5cRgV2kxuPKwG3b7ZhezjFpHZrd52taLbOREEsxZ7d81t9atcmCnV92Tcrc3vOJEK2BF6g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de; dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=vC8qGYtm; dkim-atps=neutral; spf=pass (client-ip=2001:bf0:244:244::119; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org) smtp.mailfrom=avm.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=avm.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=avm.de header.i=@avm.de header.a=rsa-sha256 header.s=mail header.b=vC8qGYtm;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=avm.de (client-ip=2001:bf0:244:244::119; helo=mail.avm.de; envelope-from=phahn-oss@avm.de; receiver=lists.ozlabs.org)
Received: from mail.avm.de (mail.avm.de [IPv6:2001:bf0:244:244::119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVXXY6xCrz3cB5
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 23:01:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143726; bh=Axff4FnAHPNmyZXZ2vgEuavJkfKhCKJPqZGqnoou9Q8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=vC8qGYtmoTTFtKG57rlNoXWnybB42U6r7mF3yDjZNK169i+LPPc6FbsKjJViJXz0P
	 z0SkvHe3S8CzlbyDQgjnVKCfReu3jwjo1Tnr6q9iIPykZjcNCRLdwFjqB3/YTiencA
	 upketXPZTZxW0W7lPSDpgLsiq82FnKI8pFh7qlSE=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ae-2367-7f0000032729-7f000001c97e-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:26 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:26 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:59 +0100
Subject: [PATCH 33/61] mm: Prefer IS_ERR_OR_NULL over manual NULL check
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
Message-Id: <20260310-b4-is_err_or_null-v1-33-bd63b656022d@avm.de>
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
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=3181; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=Axff4FnAHPNmyZXZ2vgEuavJkfKhCKJPqZGqnoou9Q8=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAZGGzCaztqu0lpdWvBpBbRCmO+WdPRS9iZCq
 y8ebihz4r+JATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGRgAKCRA0LQZT0ays
 21/8B/wPP7xI3S+6VTDXKISgyNvBqi0UZCbrYypvYfajV0SZbWCEuGKdkXjsEnnFt9YRKxoHeyi
 XmpmbA47CMrp+VNl6him9YVO8BEPZHU4T3m6BB2+Ps31+3rQDfYs7d+nPEStYiJ7CseLk0vc9Xu
 aMyI8bSdyPpcRveFxPuH/uy4iV8zrSXLAoi0Ddm83MyR2aRNl2iCZfPRsvcbR2T8dPBVJjhKzKb
 5v+Zz66IZ/QArfKSmSkUD+nw+Micr3w6XFCa9e1WMrdcQ/Zh9MZx0TWZwcRgOAgfEwQG/fxgX8/
 bLP83oq+8G1pw01czFBtKoe7eUKh6J8z9KOOUPoqLrMipRXq
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143726-05CBBE1F-4CFCA352/0/0
X-purgate-type: clean
X-purgate-size: 3183
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle and adapted by hand.

To: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 mm/kmemleak.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index d79acf5c51006c3ed42fd88a2246ca148e401999..91136be23a84d825698e98b4f2d0e666429dd593 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1092,7 +1092,7 @@ void __ref kmemleak_alloc(const void *ptr, size_t size, int min_count,
 {
 	pr_debug("%s(0x%px, %zu, %d)\n", __func__, ptr, size, min_count);
 
-	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && !IS_ERR_OR_NULL(ptr))
 		create_object((unsigned long)ptr, size, min_count, gfp);
 }
 EXPORT_SYMBOL_GPL(kmemleak_alloc);
@@ -1152,7 +1152,7 @@ void __ref kmemleak_free(const void *ptr)
 {
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
-	if (kmemleak_free_enabled && ptr && !IS_ERR(ptr))
+	if (kmemleak_free_enabled && !IS_ERR_OR_NULL(ptr))
 		delete_object_full((unsigned long)ptr, 0);
 }
 EXPORT_SYMBOL_GPL(kmemleak_free);
@@ -1170,7 +1170,7 @@ void __ref kmemleak_free_part(const void *ptr, size_t size)
 {
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
-	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && !IS_ERR_OR_NULL(ptr))
 		delete_object_part((unsigned long)ptr, size, 0);
 }
 EXPORT_SYMBOL_GPL(kmemleak_free_part);
@@ -1238,7 +1238,7 @@ void __ref kmemleak_not_leak(const void *ptr)
 {
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
-	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && !IS_ERR_OR_NULL(ptr))
 		make_gray_object((unsigned long)ptr);
 }
 EXPORT_SYMBOL(kmemleak_not_leak);
@@ -1255,7 +1255,7 @@ void __ref kmemleak_transient_leak(const void *ptr)
 {
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
-	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && !IS_ERR_OR_NULL(ptr))
 		reset_checksum((unsigned long)ptr);
 }
 EXPORT_SYMBOL(kmemleak_transient_leak);
@@ -1287,7 +1287,7 @@ void __ref kmemleak_ignore(const void *ptr)
 {
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
-	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && !IS_ERR_OR_NULL(ptr))
 		make_black_object((unsigned long)ptr, 0);
 }
 EXPORT_SYMBOL(kmemleak_ignore);
@@ -1307,7 +1307,7 @@ void __ref kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp)
 {
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
-	if (kmemleak_enabled && ptr && size && !IS_ERR(ptr))
+	if (kmemleak_enabled && size && !IS_ERR_OR_NULL(ptr))
 		add_scan_area((unsigned long)ptr, size, gfp);
 }
 EXPORT_SYMBOL(kmemleak_scan_area);
@@ -1325,7 +1325,7 @@ void __ref kmemleak_no_scan(const void *ptr)
 {
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
-	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
+	if (kmemleak_enabled && !IS_ERR_OR_NULL(ptr))
 		object_no_scan((unsigned long)ptr);
 }
 EXPORT_SYMBOL(kmemleak_no_scan);

-- 
2.43.0


