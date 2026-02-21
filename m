Return-Path: <linux-erofs+bounces-2343-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 395AEC624A3
	for <linux-erofs@archiver.kernel.org>; Sat, 21 Feb 2026 21:43:09 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fJLFl58rgz2xN8;
	Sun, 22 Feb 2026 08:43:07 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::52b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771710187;
	cv=none; b=Qt1C4Lwz/VLQwK/9qhv73Rrn/B0HSA1XX6WzmvdlMLtoeJRfjfp7sloZT1Lkv62wNOf0y2+V1ni84H8cDPcf9j0ibx6m3uRk77V6zEX92+tVUSF+5YR1tnX3VlucG5+oxBrUXREaisVDmxRGnguz52xWhMRYZ1UFAWSGzEPgE6C+C2S0VjAMayJpT4moj1c2YxYKot0vhk0W41WBVxEAXZCO4SDjPpiF+VTVAEy8GYVn6gfM6iLDbImE5bdMnk7eahVPNK3n0rI8eg6EGcLOXxWV/JvuyPcQUSkpuz/ZjgcU02jAAyd0LspYYt3hPP6h6ABC4OTJ99HLsHF1aIk/0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771710187; c=relaxed/relaxed;
	bh=cu2B0KjnblF4/AnjmnavdDiF9wzBrWUA0z5Mk52Ut8o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=krjFjbn2PcYpEb5MzYQB+J3y1JZtxJe8qpHJV5pfQ7z4s/aIueKVhfT226qlm8tu0QC1lcECOCWFzr3FbGyD9P//qDUgAp7ES/AylGGpnoBtLzKTHKqSNghHrg9Xy1Ea18G6ZwiRzf3piM9wLJ6+2GHzhlYEVTfL1AQLCVYU3oudoQBNvoXT/YUrwoSHMl9S8mglLPY17r2HKxdLO7cvLqYDque91p+EiWx282u3gzitvh6P6z6QispTCPeHWJYsA6PyJ0m7nZLkG1EbTYxctByXlP6ZrdPuyclrzqEsnTLNPRcRR+2ekpgY1aEds4o8trdKBgJS/gs/t+YkvFYsOg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=itZh4pBv; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::52b; helo=mail-pg1-x52b.google.com; envelope-from=danascape@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=itZh4pBv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::52b; helo=mail-pg1-x52b.google.com; envelope-from=danascape@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fJLFk33qrz2xN2
	for <linux-erofs@lists.ozlabs.org>; Sun, 22 Feb 2026 08:43:06 +1100 (AEDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-c648bc907ebso1852067a12.3
        for <linux-erofs@lists.ozlabs.org>; Sat, 21 Feb 2026 13:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771710184; x=1772314984; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cu2B0KjnblF4/AnjmnavdDiF9wzBrWUA0z5Mk52Ut8o=;
        b=itZh4pBvZa3U8hjPwS9yFyA0XJyfn3kSivOtuNtv1LXApgWxRdHZeshvXpAHCYjugz
         cKQAO2SAmSxKqzicJ/6Qp6YIGmwzH3vrA5iwkGIxtQ+R9LZ3DFNSVqav8ocVa+7xfL0Y
         krv0wN8KeVql8aEWI5Bm7zuQ8ypOrIMEyB8YrQVNADBtGJpFZd/Hubtm7G3WCENUM7ig
         76pTsjtYlbNzRnoV7eVHsCnvi2l9o6MG3FccIP1BTSK/EYc95eG3lsJXvihK9E15Gf6w
         FzNY8ylY9RveS56exmLLx5tukamMeNDFtL7iBvxDkgiv0g+S4kyLtKsxB9f/1ShQBIyo
         zZtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771710184; x=1772314984;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cu2B0KjnblF4/AnjmnavdDiF9wzBrWUA0z5Mk52Ut8o=;
        b=tKBGkQAd4wRVvRUCzExvreiKfLVahimP2ccuf7+O3L7JMdtytPsm3o2CZlJag7PWbY
         eEI23zJwlA0qBuLbZDFf5vOi5v0WM4Afc1a1+K75JKJUSG2V+YfZuANPmT1t45Yeq22W
         Ka2jB6g2TQ73xjEas4L7n2jyj1z+T9fjDByQ2jvK//kxyO5rVOHj6n0fGJnGp2k3ycPw
         V/cSaDpfl+z9sJRJ1Y61Pnm8xsrpdt5dqnYQMB9az1O9OfmYPncNEkx8/86bMw8TZkjV
         Gv5qKJ65FijXlI9KD0nEEmtPR+fag7cExcHxABX539slxXThNq1qx1WXYKr3QWQtXDUl
         1gMg==
X-Gm-Message-State: AOJu0YxuUUvryJt8xMZdMhONijZL4jpNmUncQig6w/EUCfLcJHD7WdhO
	7CPvnvpQGgVn7S5iFBopRVedLynkrl2+PK3RxKoZPOrmJ8j3pJSOcNMY
X-Gm-Gg: AZuq6aJAIRlhYeFZYtq0joksctS/WlhpuwCGWE47zn0eIMXnmS1tZLeyvK1LGDvsBsw
	bcZM3IaY4uNHczYHJko4b2Qmq8GpvrS7po0yP4+fnlpFmFHUWrLU27jSt08Ovh9/AEiZdkFdOpa
	xi9nDz1GPukkLNDNYDZ6LN3fyL/9YBJbGSAPtw95uzZgBoZ26f0Ff8jvV08/9OK8Rz95l/e/SZo
	wIIkFyF1XV4yM6y/OY8Tn3yKIxKQb6LOJKRpvPJK6+UxpLM4BABEb8yvoGBZkRtuk8MrtX8P1Bp
	GtLpmlznNau8cgHlDFFdmC5/QlU7YT7spI/uY/Ao0Y2UFKDCzLhbARHb7+sAO1qOpazm/96RWgb
	KGrc+sajWixg76UjCKDSR3tSROyOb8GlzRv1HV6z5XLNnFBpU3SA4b+HXaq5LroxZBfU/U6Y5Hz
	jDR8Dl+Sx845QAQ6Q6B+K3/0Q7bJhyspRWbkFbQ9KOdHiXIjBZQumrBa0laqaZ7VLUOYV8Ig==
X-Received: by 2002:a05:6a20:94c9:b0:35d:cc9a:8bbb with SMTP id adf61e73a8af0-39545f8f1dcmr3385875637.47.1771710183942;
        Sat, 21 Feb 2026 13:43:03 -0800 (PST)
Received: from danascape.tail34aafc.ts.net ([101.0.63.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-358a2b72d69sm2588339a91.14.2026.02.21.13.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Feb 2026 13:43:03 -0800 (PST)
From: Saalim Quadri <danascape@gmail.com>
To: danascape@gmail.com
Cc: linux-erofs@lists.ozlabs.org
Subject: [question] GSoC Proposal 2026
Date: Sun, 22 Feb 2026 03:12:58 +0530
Message-ID: <20260221214258.129214-1-danascape@gmail.com>
X-Mailer: git-send-email 2.52.0
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

Hi everyone, I am Saalim Quadri an undergrad student at Dayananda Sagar College of Engineering, pursuing Electronics and Communications.
I wish to participate in the GSoC 2026 as a part of the EROFS filesystem.

I have been contributing to the Linux Kernel and have more than 10 accepted patches.
I have also worked with Android Linux Ecosystem in the past years, and have worked on several subsystems, backports and fixes.

I started looking into https://erofs.docs.kernel.org/en/latest/roadmap.html, and I am interested in expanding erofs-utils to stabilize liberofs APIs.

In that sense, I would like to know if anyone in the community could provide with some suggestions for my proposal, and a positive impact.
Any suggestion or hint is appreciated!

Sincerely,
Saalim Quadri

