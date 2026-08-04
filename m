Return-Path: <linux-erofs+bounces-4100-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14714C55184
	for <linux-erofs@archiver.kernel.org>; Tue,  4 Aug 2026 03:32:44 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDfHt0Z87z2yYs;
	Tue, 04 Aug 2026 13:32:42 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::436"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785814362;
	cv=none; b=eiNzI0p64H0/KUa3NjA7NylsLAh6yYZBk9YBf4jSyALWpU43t3GZPAeHjO5qEh/eeMBYRFvVVIOoH/4DRQGesgng95Xl1+v5xwzYHdvJkX0lrc/3C8LShDUipJKfOEwWKW+Xrrv8Mp6DTrL0RRmwLXJq4ZmiiJHtHRz79ABwUDdc9lcSefPY5wXubGAmmK0FoRE5Ic8k56UbprCfGpZfYSC09LAUt1J2LJF0Rnt1iWPrRmaRAr+S5k56jmeerQoWtTr+Q8frWxnwZQjpn/FNP3oy2ycPtHjZ9vmQk/OMMVkySop7v/6uf0m+DnD8e5S9xlHc/EE5pmSJlUg/1QOV6g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785814362; c=relaxed/relaxed;
	bh=xdmUrICWc9i+Ly/B/B4LyV6Wyg/mY/8lKR+7W8dS1p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gr84ajyfYpCGWJBX93/OxHvLionUeO0xDPnHDKwPRtQF06JqIeJ8PtZ+R1OkrGi3lsAPPzhgsJ5weGEqkRZRpqRVWAYq6XIzXGviZ13KyZRbZ7iVF5/dcvQLSrbNLrIMRBOWI1inZrwBztRokL8E2w1Ax2TsXnhvL6VPZfIgHF1i28eYe+EODmdptYolg/p9akm5OsmEmQ3/Euv021KNiOtgFgy9h/eFVqoQXmPT+0X3vRsH+BOCqCdUJ6lpVyLEhbtIatXmpAmK58kRzvkHyGNllvXc933M1q8XMYJYZzzZ8+Vig0uQQtia2D56PxPPGi//U3eXnEbiGbQU7+cGhA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=UMU4bzm0; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::436; helo=mail-wr1-x436.google.com; envelope-from=martin@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=UMU4bzm0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::436; helo=mail-wr1-x436.google.com; envelope-from=martin@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDfHs1sTJz2xns
	for <linux-erofs@lists.ozlabs.org>; Tue, 04 Aug 2026 13:32:41 +1000 (AEST)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-47fde295992so374840f8f.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 03 Aug 2026 20:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20251104.gappssmtp.com; s=20251104; t=1785814358; x=1786419158; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xdmUrICWc9i+Ly/B/B4LyV6Wyg/mY/8lKR+7W8dS1p0=;
        b=UMU4bzm0Lh1Hyf7FKsHPB/gpF9H8qDQqmLkGUk+LxpkovIUrO0B5ELMh1Ay7o1w3dE
         cjJPHROB4/8GDds1CNa7ljJd5rSgxsN/D61RyQlaD49mqEEFuSkFzwIkg8PmeSRD3Ply
         I8faRVRVejd5wxFDOJ4fq2gvoHuVCI18aJnN0Suwga0FKXBZsvF0Wc2rZFk5QEtvs6En
         KuVtxsn/qaUzLzozz89ybHgPJz7Giml1IsLCJ0s1ykhUD5kKUVyEsnh0O45vQFEH2Wxx
         G5hga81wuqPXSsQc0p9o9Lai8Ci/Wc8v+5gNKf83k0DjPtiRUnIe4T5Ai4Fyk1ujd/up
         hOxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785814358; x=1786419158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xdmUrICWc9i+Ly/B/B4LyV6Wyg/mY/8lKR+7W8dS1p0=;
        b=RaZTzIES6427+qp7/jzAJ7vcdB6daBHod6cIbIworWIKIEEfnzdf+LrcqYtTjqZVqa
         sLyb0Uca41Kvjw5pYCf0GFud0jbAjpTUvGqO9Zkka+/DOJcXUYiETd/N1U91BuHJOzFz
         V6bW/GuncOkl7Poduc7wsCdxHJWp2Xz+wtfsZu+gbJCABbhT0NylOdgG1Z+vkYwIF4Tb
         VDsx4IpxIX918gg/GetP0uP48nHXutKDvvzKy1qcEVPaUQceSDD/6gYzMgCSWO5f1mTr
         LaZd0giCKesdswISvfWGRyi66wvg3crXB7BmnXGiKNXxRlBYh+3E1G34Gjq71EFKQvbf
         0PNg==
X-Gm-Message-State: AOJu0YwLHvPyXXgSJRcHfd+6nEnzcOVgOdyCSdtbxr75lIuvcq60EnrG
	uYMUJaP8WOvooHqlIw6QQAj8QK7zKYnTgzncAtfc4ikV2tEOSKBToeZ609vWXV5SJ+kzsPyQXOu
	4Ush2R/m7
X-Gm-Gg: AR+sD12b8FTs6xc05+jp5jXkau1efPe/zVjRjT9T8pV4MConXpmuDfkIr2X9eiTHohQ
	YBwtUHrKcVSBBc8yygHBf0qm2Hse31/5Z7v4MvZ+aQTYqaCbUsFVDs1Wzcz07ComsTaweirwdcY
	tTisNbZPOgVbUNOb1Zs/7hDjm71WfCglntbrPxEngV3P7xAqHox3Pup1wMIea4nsdDdXWeb2y2Q
	hz+MvmDsPel4b0F1FR94O+jwugiNRoavySAnoCO85uiCP3QWjVkqyYYzUwSdkRk0hQxTKsK1k49
	kYVBmPXbPA8qXPXdogEaqkQteQebzlPYJPiktLDAVc63IU8aXORveuiYK1M/Gk4wbDk6x1Vbs5G
	bklTGT9EDXYEHNXS0juKT820bijeWrScu2IEosqacafYv/k6GUaGUcryNOYwfwvI9SsnCa8wetD
	varC8abJ6wMQL78/+KyKd6j0VENku256XFJ8UZFhYJlYFbTG+Ecn0podKsJfbuy5PRScQ1Ap7pW
	d64eKvgTpxaQbpOgho6KVCAp6FuCFR/w8118Zym8qklLhwg+qslaGb4bNU=
X-Received: by 2002:a05:6000:310a:b0:45e:dd32:92fa with SMTP id ffacd0b85a97d-47fe81cb7ccmr3804246f8f.12.1785814357795;
        Mon, 03 Aug 2026 20:32:37 -0700 (PDT)
Received: from fedora.fritz.box (p200300c78f45f4002fc0e22e545c127a.dip0.t-ipconnect.de. [2003:c7:8f45:f400:2fc0:e22e:545c:127a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd42d91bfsm41286329f8f.15.2026.08.03.20.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:32:37 -0700 (PDT)
From: Martin Pitt <martin@amutable.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Martin Pitt <martin@amutable.com>
Subject: [PATCH 1/3] erofs-utils: tests: fix broken loop in POSIX shells
Date: Tue,  4 Aug 2026 05:32:12 +0200
Message-ID: <20260804033214.211267-2-martin@amutable.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804033214.211267-1-martin@amutable.com>
References: <20260804033214.211267-1-martin@amutable.com>
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

`{1..n}` is a bashism. A POSIX shell iterates once over that literal
string, so the test silently sets a single attribute instead of three and
nothing crosses the block boundary any more. Sadly, `seq` is also not
POSIX (although ubiquitous).

Spell out the loop.

Signed-off-by: Martin Pitt <martin@amutable.com>
---
 tests/erofs/021 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/erofs/021 b/tests/erofs/021
index d36aa56..b77a8d7 100755
--- a/tests/erofs/021
+++ b/tests/erofs/021
@@ -39,7 +39,7 @@ mkdir -p $localdir
 # cross the block boundary; besides set three xattrs to ensure at least
 # one xattr name crosses the block boundary
 touch $localdir/file1
-for i in {1..3}; do
+for i in 1 2 3; do
 	setfattr -n user.p$(_random 249) -v $(_random 512) $localdir/file1 \
 		|| _notrun "no space for xattrs"
 done
-- 
2.55.0


