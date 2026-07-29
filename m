Return-Path: <linux-erofs+bounces-4034-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DC20C54FD4
	for <linux-erofs@archiver.kernel.org>; Wed, 29 Jul 2026 20:31:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h9PB31nmQz2xwP;
	Thu, 30 Jul 2026 06:31:23 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785357083;
	cv=none; b=Y43TPc4oYLSG6KWRqPWFNwsAY0X2EUXLQOOjRzC1akkIgA1himKML2oZyEXXuXN+g/e0KwiFNtuZnfmW1nr01ohYY+SeC2O0im/esLEnIvPZ+YD0p/hSevLlFiP+qU9b4HYDtDTTK7qrrSu8ZOnyw7ZlZJ9MDFl/fqGj+tL0xSlyX5pg74cj34d2Bc0mQvX51vpHyKIMqK+AEJueqPcVb+YqWAnR32CWS6PeuQn2P0ljOkT5hUgmXrrfYOiSGGbBrOekikDFgnBHCzAvmsDQs8ca61e0VIQbaLITyG/NeQKqguwYmSVyQt+SMa43RLae5jY6Zb77n9AJiPl/9EiJmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785357083; c=relaxed/relaxed;
	bh=RjRUvDe+bJNBqhq66T/xuljvlY+A7ShYMNSrevR1/Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l7vp5d6bV57JmUI9x0DUlVTPT1ZjempvkT+b5IkiLuCcYA7ouUY2W3m3xow6abcvdddNzxnVY2OF+86apIOQ8PwLf5VdhRMhgLCRMlvaHfuq3/+MY4VyuWOYoJZJ4QA9tV1RvC+CKUWtgoPM5CduCMUURc0i5kF/1i6aBcZ8MjfzCn4bsbkSUYWnXhIUfiXGw8whXTFuQoFvZRUrJiyMdI/yiow8LYGb+5+uNdYurfsBaRGDdPo9CfzQnhVxv6ma1Ij5gfQ1CZwo/fmUW7XqGuMbckh31932V4etGv50KlBdHhaXV37+MpQYb8E50U0nkDsVgt92ZLRdckU0wgGG0w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NUglqCmZ; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NUglqCmZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h9PB218HYz2xlZ
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 06:31:22 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 812366001D
	for <linux-erofs@lists.ozlabs.org>; Wed, 29 Jul 2026 20:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492641F000E9;
	Wed, 29 Jul 2026 20:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785357079;
	bh=RjRUvDe+bJNBqhq66T/xuljvlY+A7ShYMNSrevR1/Mk=;
	h=From:To:Cc:Subject:Date;
	b=NUglqCmZqZfb8NcArjoGd7qeeoupv5xj5T45yEQ76bpXLndLQ4uvWy2gaNdo+s/uB
	 K/tJ5BNLoNLMVY+1n7EwoaYTU4IQ48tZ8R+Z4DhJrZ1AW3kzE4h2kgWu32WVmHktj6
	 XmfKS/QwbrbCtykIz1EFpgMa+hFWBYfGx5LSahs1f7VRm/brYlQwE5wRhlGFynaPP/
	 U3fdmxJlxkqsW2JhCNxnofXX6K8kWo9+/Nt9p0I8uXKziqUUzSGtiu7gIHISEZjs2U
	 /g2Iw1RXkrolKshOqOlEMVIkYMCCmKwbZJ31JmOdtlyzNktFdKkyg4ef1Izbjuuzpo
	 ro8CW/mGHl3NQ==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH] erofs-utils: mkfs: silence false-positive uninitialization warning
Date: Thu, 30 Jul 2026 04:30:58 +0800
Message-ID: <20260729203058.29830-1-xiang@kernel.org>
X-Mailer: git-send-email 2.50.1
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

main.c: In function 'mkfs_parse_options_cfg':
main.c:1236:21: warning: 'i' may be used uninitialized in this function [-Wmaybe-uninitialized]
    pclustersize_max = i;
    ~~~~~~~~~~~~~~~~~^~~

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 mkfs/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index 33c410d..929ce7c 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1228,7 +1228,7 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 #endif
 		case 'C':
 			err = erofs_mkfs_strtol(optarg, &endptr, &i, 0);
-			if (err < 0 || *endptr != '\0' || i <= 0) {
+			if (err || *endptr != '\0' || i <= 0) {
 				erofs_err("invalid physical clustersize %s",
 					  optarg);
 				return -EINVAL;
@@ -1250,7 +1250,7 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 				}
 			}
 			err = erofs_mkfs_strtol(optarg, &endptr, &i, 0);
-			if (err < 0 || (*endptr != '\0' && algid != endptr) ||
+			if (err || (*endptr != '\0' && algid != endptr) ||
 			    i <= 0) {
 				erofs_err("invalid metabox option %s", optarg);
 				return -EINVAL;
-- 
2.50.1 (Apple Git-155)


