Return-Path: <linux-erofs+bounces-4683-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB03FCA600C
	for <linux-erofs@archiver.kernel.org>; Thu,  8 Oct 2026 19:09:00 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j100C0kxsz30WS;
	Fri, 09 Oct 2026 06:08:59 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1334"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791486539;
	cv=none; b=ortEqKz7+fjnNFlaKD5gv72T9SL7BzL13hE+Mg6CSnOg8frVQVsZkSGzpdQFYjbdWEH0yqkcDfaAazNhnU4+WfI//yqxDJvatsfokRIFwDO8bBhQRVk9gVIhfc5s9+74ViY4gLHvu33vHMkw2tDzpyOg7b9fdAxNP0Z71O8lfMfWZ5lo7P7K0+zUss488n6Wv7f0ESwB6/Vex2+e3ekrK2A15SSQaLgR5k+caQ+dqvfZl/aDUrIXuxoiA0BqRRtPUfuNf3fms+9ryPtD5IbEXcPHxTTuSxIXPq9vpWaeaBVbD04L9QXZelosdz6JWf5fgxXYbP/TPxxFg6ClnTztuA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791486539; c=relaxed/relaxed;
	bh=bK56KhP12nN+K16lwK99gcseDIqNs+bzdxiXAeZPNow=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aFlgPOLv5/w0qiDnNtdgsQh+TGTmxx9YLSN7FITdsisxisPH2W5+S+uFoK8t+358SAD1hSm1RIEzxQaVLuiqe90H9AcESvhlv2kmu6sj7FehBDKki0GJBdMoyCbKDMRIIr/etJtemOJjvJQ+9UB3zHGej/uoxH39hyIQwuoeLWe/01tU4gfJAbcXCchr2oGih9ViyLttvSCFP3kSqgh7Nt+EGdnbk0vMKQueu8CNyasQ/TiQq0ZBqV8S7MupCWtDzs0xVV1xlc55kqcBc7uqSHAtlEM2fCbW2/ZPDHoeo2vm5KKhNKylpNjvycfuFUHRDV+YjTmRXUA/0MtCr1aZyg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; dkim=pass (2048-bit key; unprotected) header.d=trailofbits.com header.i=@trailofbits.com header.a=rsa-sha256 header.s=google header.b=NIYEY/j1; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1334; helo=mail-dy1-x1334.google.com; envelope-from=artem@trailofbits.com; receiver=lists.ozlabs.org) smtp.mailfrom=trailofbits.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=trailofbits.com header.i=@trailofbits.com header.a=rsa-sha256 header.s=google header.b=NIYEY/j1;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=trailofbits.com (client-ip=2607:f8b0:4864:20::1334; helo=mail-dy1-x1334.google.com; envelope-from=artem@trailofbits.com; receiver=lists.ozlabs.org)
Received: from mail-dy1-x1334.google.com (mail-dy1-x1334.google.com [IPv6:2607:f8b0:4864:20::1334])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j100B2xtrz30WQ
	for <linux-erofs@lists.ozlabs.org>; Fri, 09 Oct 2026 06:08:58 +1100 (AEDT)
Received: by mail-dy1-x1334.google.com with SMTP id 5a478bee46e88-33c2520ad38so8040473eec.1
        for <linux-erofs@lists.ozlabs.org>; Thu, 08 Oct 2026 12:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1791486535; x=1792091335; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bK56KhP12nN+K16lwK99gcseDIqNs+bzdxiXAeZPNow=;
        b=NIYEY/j1otF/VDxRdZ96IJeZ/luowgD1uu7anF0BPet7mkxjqKphrAabkM6msbEOSe
         vs17EO/QJO7E8hY0oQAyMk8kGiE45KyhP204RPqZBuL96QuChSA2ysRbssOLffVYNM6j
         Wo+OUw/uN48L8BAgN/r5pQ92iEh9wQFGiu3BLhqpzLKaz4UeoMF1QCZYG82uOm6PyZkB
         2aWExri57i/WdwtQZd+89LyvNiMBXa+9jGXFkia/H/VNmWACpWKN7wteZl7yI/qG7XYa
         okrwKzMMVyT/IqKqNwqoG+4wnOWM0X6BoRTfnI9XKYAQEgQFBK+CbmZnt9lZeVUh51wx
         VUgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791486535; x=1792091335;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bK56KhP12nN+K16lwK99gcseDIqNs+bzdxiXAeZPNow=;
        b=vx/LDPX6eHdotEhmRZWoC2XK0IYvIWORCCVK8+5ykp1uLTA0x1skjnjO0P4VeDXrM3
         znh7Bwr7nVX7vkkDPRpFM3L9KriAt2rRGDdwr288MjEtGo1OdqDueSYKpYdmTaIH2/Cl
         xszuijx11C1DXHGiVFKisrBNkhXtDFUb2aV4jpraY5ut7rZcuhditSyB+0w9tEu+OfQd
         tK681f8Ulz4R9FWwNo3Cz7JzFgCp60UAaRg3eZq9pZRAUYdkWplIgdjlqp0X8yI6/XZV
         ybkO0bw/Wxk3jIwgnxla9Jfc1MtCNxSYlwi0UXoTDK+eDmBHKBTMlhAMb/L6G0qqjZt1
         OJNQ==
X-Forwarded-Encrypted: i=1; AKwUvBxi5jHL+UI65ck6eSRXXSMGnBOfpl15/V42OXeTzeS03KtucPj3wWybHOZiPBSuSNvSOoWn4qXiRCTXPw==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYJRbTdx4/XZmL11GM1sk7fMRj5Y7ilOgqhzY7epsrValcBYqpJF
	UAzJywzKAc2stV36gilcYQb6rj4Bq3GvySohW6OyjAPOBBrq12j5BPWYSYsOBLiz/dc=
X-Gm-Gg: AYBFou1SUAYq288gfdS6KNMJ4qCNzyAtuQVPMoIB8Dk5U2W2ceqhT2H9lYce0lMP2vM
	JVkEudbObNIIFjfdTzm9d6eR0TirmMANSoFHlhkclpjCQn9GKJe4eOU7dUc3Z3W9aNrTEPtPAG+
	wynCZVJ97zBbAF2OpH63ICIvXLDvqYj3lVI64qq9PsuQ9HqgpyfgZuOFJ8CIn6eo1oC9Xu00xlX
	/wi9tZA6h+Ayh9pFM3Re8FVU3kIJ/IGyL0A+sm5GSnUlqMoS65dQzFzLhoHybLG77xQ5SjkWAMY
	nfmwtNwGxzM27wos+8gFXsSN0eKxhBFKK2YmDL6FN+Z8aD3y0203h+0JqLtUXV/sk2rErDqNfIK
	FgE3jciJrG4XBh9fPjukvS9GEEmRTU0gdMZ/dAgm/ADWKx0iRgOYKWDMIpPCdYj9qtpBixy52HO
	r5NLRtQ5/Qx1hvXjdk1XdzZukGAc31OQPbd0fnqFiIgm7tx/3UvQ9nHuZD4K44SBWvx8SDLNmOo
	IEtPhzZ/8iYsiXFsjIpXyDAI0sIWaEdoi8+AOPxVSgG0A/RakpKYfcNVg5Ifc4G08TSP7o=
X-Received: by 2002:a05:7300:c00d:10b0:341:c6ca:1df3 with SMTP id 5a478bee46e88-3515dd78d9fmr8396610eec.14.1791486513944;
        Thu, 08 Oct 2026 12:08:33 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:bc88:5ec1:4f8a:5b23])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537c841648sm80561eec.3.2026.10.08.12.08.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 12:08:33 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: stable@vger.kernel.org
Cc: Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Robert Morris <rtm@csail.mit.edu>,
	Hongbo Li <lihongbo22@huawei.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <huyue2@coolpad.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Yue Hu <zbestahu@gmail.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>
Subject: [PATCH 6.6.y 0/2] erofs: backport CVE-2025-68251, CVE-2026-53015
Date: Thu,  8 Oct 2026 15:08:26 -0400
Message-ID: <20261008190830.97970-1-artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
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

Hi Greg, Sasha, and maintainers,

I'm working through the smaller CVE backports still missing from 6.6.y.
These 2 upstream changes belong together for CVE-2025-68251,
CVE-2026-53015. They must be applied in this order because the later change
depends on or completes the earlier one.

The complete series is already present in 6.12.y, 6.18.y, and 7.2.y.
Patch 2 also affects 6.1.y and will need a separate backport; this
series contains only the 6.6.y patches.

Could you please consider this series for 6.6.y?

Thanks,
Artem Dinaburg

Series:
  1. erofs: avoid infinite loops due to corrupted subpage compact indexes
  2. erofs: unify lcn as u64 for 32-bit platforms

base: v6.6.157 (79643295eba17affbd16ca97f3ef04c90266b28c) plus stable-queue
revision 958ddf240a33ef26b1771be944f0ea6c3b597472

