Return-Path: <linux-erofs+bounces-2729-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 312E2F013C6
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Mar 2026 07:58:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZ6ss4S97z2xlP;
	Mon, 16 Mar 2026 18:58:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::52d"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773647921;
	cv=none; b=QOHsZ4IdYHrp3/P0mSiDkbqhxVOiXGmD/WEZvQZOWV9sJxPUrkm3hh9GbAqND/maUb5ZKVV3WEGAqwwKNy62rwASdTYfgdBpjKz9TCJlmAu89hAwPL05SoqF2uw/+kzTKWu9P5P8QXV0r9PKmUKfAlYFxQ7985UEosDpA/+TyI+ufad0gxcEFAp7PCA6SFdvOsmkVfMn5sV6tbTRP3bx1HuFQmWp/FhWGFTXB+d9a+U05q/v3i14P3AhsbAUPw/hokIujs3L6Yq/wPOT/HNr9vbkozVcC0J2HViDcFh9GEVWiBEr1G02qa8DM1dCt79+KEuUfo1aFvPgQDrNgVCwDg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773647921; c=relaxed/relaxed;
	bh=Xtw98uB7v1zHKoslDSeoSegCcIr7J7RAVQq22gnxnlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAvrTBT4vvK5+j42xadkrkA3qvr35iWhRVFuGt8h8YFQ3SG87sH/16wOL8ONn5FcCzhc0tjmreTO4nOsv4XB5+NKTI3cI981rQlVop1sVmeEP8O+CQ7p69WE4DxdXT6KeMgDuJBSWSe3HUu+2m7eaAX89+nHkxKjfnsqWPnG8fjnCxF4h1dLq3CD0LESqFcflAfKypJr/CgOauoVOYV0/Kry99kahlpu9c/hYezzVY9FQypqbBRBp3yOnWlqkI6ulUG+IImQThBmWlMWrBgkSu9diJU5V4XWKxoXLq8kYi3cRDjWyk/kgBKukkvsRRmpn3LJp67rOuPjGt699XQJZA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=Ag0RfHIq; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::52d; helo=mail-pg1-x52d.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=Ag0RfHIq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::52d; helo=mail-pg1-x52d.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZ6sr5mSkz2xln
	for <linux-erofs@lists.ozlabs.org>; Mon, 16 Mar 2026 18:58:40 +1100 (AEDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-c629a31d1d0so437759a12.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Mar 2026 00:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773647918; x=1774252718; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xtw98uB7v1zHKoslDSeoSegCcIr7J7RAVQq22gnxnlw=;
        b=Ag0RfHIqonAsLW76NqVb/08OP4H23bkWPEUqzoJ9YXEVQKNAnz+GmdDl99+GFGm+Tq
         VsI6rJJRuSelI2+52dPTzDm3LOly47OfmImnE7KN5PVNz1BuGzi0qrYNNfGjEO2jna6G
         Am+9CNDt3Do/7yNDW6rmrsHkXLOGJ1fIWWdMSyLAa549xXd0JYyJyxZ3ZOzElxT4LIsD
         eV7jhjY06N343Q4JwDfr7ofs9HL4Suza9WtRhzIkV8Vi7Gc/bf9FmizeYR0J6VHuS+LL
         M+mZK9gosxscPm6I+BGxfrMipvJk8cKANzOp3j9h2kLnqZLWGEy9DmR3oI3dlQw799wy
         so6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773647918; x=1774252718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xtw98uB7v1zHKoslDSeoSegCcIr7J7RAVQq22gnxnlw=;
        b=Q9KhJtl2KzbngPMIG8hoeEWw2TEQXwFFCHlg2TcZtcsZGFjk9VTCgB0cYo1Tlpx6uK
         0+aQmuMl9JX/uT6Wsx/1Vj5J0kCA5sQagQI/Eb4zsD4P9RNryZLKjgFixyN569IdzxSO
         qUufN/uBERJmhyFot4Dz/PddxZ/jbUPg1P9TMn5sdyHKelHlHeuplpusGdpJTVKHCoKV
         6cBQbYOTYcH+EHDwHwpv3wqNABVVihbfnEkXiphMs8KJNkFtCTkO5rvapebbY5bWDhrw
         gjAx1IujxzHjNhA9MOtqL5Uzo+dtQmef1Y/JZ0GB7fuZZgwSNLG32qya3y3DwfRqrNoI
         tEXw==
X-Gm-Message-State: AOJu0YzPVMN5lybNc7TmvEOmBSp7QAkznDPhIO7eWBXuQhpxWNhvKcD+
	BBTdsZ3+YCEB2pdUlQ+hgfKbV991V0UxTsVAre+bqzP0khIth6T3RkCZW+IS2Lw6
X-Gm-Gg: ATEYQzw8hYq+2JDoXFcvTmrSEZ3OaDB72xgw4l8C1H8fhM0OIsJ+vT0gn2T6If342gP
	KF+g8cB+UHMPM7/2Z8rLH7obCPeqI7xGBNE6kBZf/KnhxHbFsZuXysTgmauaRuSebdQ+w58hMW3
	oRZ6AQ6VCYUhUWSSna/q/8cC32EOvEbHqO9yKtBKGgbDLdcfHoOJ/QXBvuXYIxoRHKuxBhiZ7Hk
	afsDNC1myLnekWU5HoOAZ8ewTev8mANgo8M1/YLPCigsR6vNaQTf6/rIjIHWziKmIm8hI+axRVp
	+cEUU7ewaGdtl2uFZxQzhw7pRzm1N0yRn6+bwIh8IV8KyO866dwtilcm0BQz6dsK3TI+iNjBv8s
	qlGrIaQeQ0b5CWzJwLTR2UaGysxn8ZLcP43sYKer7o8YTRN7dudWq7n1FRlIM3ArJ+JP63RSi+3
	wRXwoqSPzO9vOOjlUrHCoazv7IYb840pGemXs0MXGTW7SEb+aUJHeEClYjcfcLMZECYT+8IK1no
	RjqhUNpGMhwmfO/s9NftOHVpwTiG50ymFPwVwK3RuVFhpcA
X-Received: by 2002:a17:902:e00c:b0:2b0:498b:2bb4 with SMTP id d9443c01a7336-2b0498b2fd8mr24576975ad.0.1773647918346;
        Mon, 16 Mar 2026 00:58:38 -0700 (PDT)
Received: from DESKTOP-PU4IGQQ.localdomain ([117.203.246.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece7ed753sm124225025ad.45.2026.03.16.00.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 00:58:38 -0700 (PDT)
From: Utkal Singh <singhutkal015@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	yifan.yfzhao@foxmail.com,
	Utkal Singh <singhutkal015@gmail.com>
Subject: [PATCH v3 1/2] erofs-utils: lib/tar: skip PAX entries with empty path
Date: Mon, 16 Mar 2026 07:58:30 +0000
Message-ID: <20260316075831.35495-2-singhutkal015@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260316075831.35495-1-singhutkal015@gmail.com>
References: <20260316075831.35495-1-singhutkal015@gmail.com>
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

When a PAX extended header contains 'path=' with an empty value,
the computed length becomes zero. The subsequent trailing-slash
removal loop accesses eh->path[j - 1] where j is zero, resulting
in an out-of-bounds read and undefined behavior.

Skip such entries to avoid unsafe pointer arithmetic and invalid
filename handling.

Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
---
 lib/tar.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/tar.c b/lib/tar.c
index 26461f8..be86984 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -510,6 +510,8 @@ int tarerofs_parse_pax_header(struct erofs_iostream *ios,
 
 			if (!strncmp(kv, "path=", sizeof("path=") - 1)) {
 				int j = p - 1 - value;
+				if (!j)
+					continue;
 				free(eh->path);
 				eh->path = strdup(value);
 				while (eh->path[j - 1] == '/')
-- 
2.43.0


