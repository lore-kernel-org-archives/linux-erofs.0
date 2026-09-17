Return-Path: <linux-erofs+bounces-4577-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFDCAC982C1
	for <linux-erofs@archiver.kernel.org>; Thu, 17 Sep 2026 03:54:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hlhhK0j6Pz2y2Q;
	Thu, 17 Sep 2026 13:54:09 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:39::11"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789617249;
	cv=none; b=NBTXwwE1he3aUrfGoVBPLDy5bU7tWYvfhke1eFqIWTPtEePfiUp73ZZwRlkKvwGZja6BpQOEJ8x3yQeLhL2RMZULjTF9ZamLRGgTwcW9VbhonQ6xTcmdswRSbpekNzDQ7UIFDER20WkOpBaVDrQH2c61EwVSUjMA4/cOXyQLcqngpVE2BRZLYs9oq9BB3NfvHDB/Pp4JmNF1MOM6OnIlfxsz99vAC/sN6laxgHIpFDBiMW8zArYdBYxjFMm2U9522ZQJelbr7Im3UIR8OUkXiRe/vLaVyE+4cAyCl8ocUrqGu9Sy5XljQ+D+HJzrNcc0lwnuDpeqVQnjstIVyzzxfg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789617249; c=relaxed/relaxed;
	bh=56n5R0GrQJhbXHHcUt7ZnsAvcKCxPIYmPw3vuxy+98s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZpIVV5wPI8Upoooh5PCRNkN6mScK07g+4EVM5S+JvyMXNvoiwOWWMDlzZfOICbhuYLiQwaRFM2WX9MBABqnCVxyHW5Zu0+mGNeZqeW+z8JHaVnZG0wAC1wwkLP9OgQliM224Avr5OUMrgVbo0fQyJudaPIwhsWxFN8yM3vECoeLbFxObIFFdnp/kjsxpkY7QuDxECQP/z/hMYqiS9q7SzlrGKJ7Wg6cNrfCP62jJsyFMsX/+ldEg1hurwCZQmvakUmwg9j2UjGjKQxnr0qDy+iLFf7wTpsp3B6IS0fsHmpxwK3WzDuxkmvbIQkcfWgD60m9QPrtxntfFE4K8iIHVA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mH2+03H9; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:39::11; helo=mail-pj2-x11.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mH2+03H9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:39::11; helo=mail-pj2-x11.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj2-x11.google.com (mail-pj2-x11.google.com [IPv6:2607:f8b0:4864:39::11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hlhhJ3PRCz2xbQ
	for <linux-erofs@lists.ozlabs.org>; Thu, 17 Sep 2026 13:54:08 +1000 (AEST)
Received: by mail-pj2-x11.google.com with SMTP id d9443c01a7336-2d91ede8035so4488695ad.3
        for <linux-erofs@lists.ozlabs.org>; Wed, 16 Sep 2026 20:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789617246; x=1790222046; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=56n5R0GrQJhbXHHcUt7ZnsAvcKCxPIYmPw3vuxy+98s=;
        b=mH2+03H96brsXfm7nTerpprXzodPL315J6LnMNuaJr+aVJGON5AZoLyzHEktHNb5tN
         wnoJiam3/7ZMfsVrwDc4MxbASCIBEVRW2Dk1q0Ffu8mdudnPOuJjvHPLkefr84nioNNa
         R2jjai7ZYxmcOnjkmW07sfnjxDydibcz8ZCqusI2rwRml8gj/nDyMPtdmJ88XqIcwqht
         icmTIUcHKJTRj6nRKcThAtFEQR/1+1jQTI4FJZ+iNbybDyLoYPGGvxYlXgu9O0huG2LM
         rVFqcFxD1qSE9V4tWhxlaDq4LdD/cK7Cjx/rLAsSghvGjRz9iCqerBVl9Dk648xYd8FY
         PNzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617246; x=1790222046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=56n5R0GrQJhbXHHcUt7ZnsAvcKCxPIYmPw3vuxy+98s=;
        b=iq00MBc/pQOtmDVpyxfWUN9d7bLhYK5CLPhxNQA+UTx3Ku18/XJmoqNwjeU/2txscU
         xHq507TX7WuUyle90VcG+u3m/ncce2G6KdXhxc7aiGLIbktYJvCcmSWxgmznQIG6DU6F
         EiihJdvMtnkTc+Cp4G/fdFMvK7TyEaQWSky95FroQkjCpB8XOcXaCQdOmtvnA3vNqbdz
         XbSHl7oL70SEuUm+ynI3+w3GZgECtpFhKZD8hQXQlFf35b6cS7ldF6dLS2ZoZUNsLNzW
         HZy98Mejwt0TrjSaWAsQcczEhEFN03cDGG5I1k9916qzDaWBvvSvcv5naPZTMENM4OX1
         aztA==
X-Gm-Message-State: AFuF++mCQy9fnCQy0kME1ZMJXE3nsNyhH0jjPEVmmQ8xbQHnvvKWwvAK
	DZwnM6JU9yzkbmr94C5rhecm+K6yyA6CpDleB/9+KYYYoSUxRhzxVHkdHQO0FJ6dcnY=
X-Gm-Gg: AYBFou1QU/Bs106jRk+BgXcqoE0AzLgykNHZPQteYj18Pwjip+F8X5FZVbsONepEQOx
	+BSxx/xo7hR9IlBNkec6Y9H61M8jdWFMp+kbJMs2iDr2ElFja46HU6V6deo8N4WRC2TxExqIlf4
	LOdBCExSgB6pT2Oz7TaP15qqM7rRMDZG86JouCeyliRTRn7EV/iqij01TiRQSyVkWOI5PpjrvXv
	ctcuWZ4ojG+b8zptfLf63jGMAKcWkLWOstTHNT0qNUS8xA62CPuJDtm/zoe/rpXm+8nELF78LPX
	AiNahLhqyZtClbw6HR8I1IvDx50nofDfmNBEL173+SPTrVRvvPT0ZpkY5ftRyUy1ZC99vYEHsdR
	B2urLl4hTJPsVV+wR9Ff9iM0e1BXOfr5TDaLBv/g+cwN8gTv2kLgB9nRI7VLMRPut714cCipCKc
	8gbMROumVO3fYooEH72vam/v8ifw6/T21arfyk0Yh1N6rQPrt6XYO16t2DtILVWAURxtbpjerEm
	1b+tjLKj9T7VQekfvEaepij8xFmZOWx5wf+xy9QfUEQXkyebw==
X-Received: by 2002:a17:902:ce89:b0:2d9:484:861d with SMTP id d9443c01a7336-2dd8e51dc3fmr107063865ad.10.1789617246516;
        Wed, 16 Sep 2026 20:54:06 -0700 (PDT)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.58])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89ee3557sm19423245ad.52.2026.09.16.20.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 20:54:06 -0700 (PDT)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Yifan Zhao <stopire@gmail.com>
Subject: [PATCH 4/4] erofs-utils: fsck: avoid truncating lseek() return values
Date: Thu, 17 Sep 2026 11:53:49 +0800
Message-ID: <20260917035349.1339521-4-stopire@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917035349.1339521-1-stopire@gmail.com>
References: <20260917035349.1339521-1-stopire@gmail.com>
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

Check lseek() directly to avoid truncating its return value to int,
which can turn successful seeks beyond INT_MAX into extraction failures.

Fixes: b063ea316aa9 ("erofs-utils: fsck: extract chunk-based file with hole correctly")
Assisted-by: Codex:gpt-6-astra
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 fsck/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fsck/main.c b/fsck/main.c
index 55da9ea..e54c523 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -571,8 +571,7 @@ static int erofs_verify_inode_data(struct erofs_inode *inode, int outfd,
 				}
 			}
 			if (outfd >= 0) {
-				ret = lseek(outfd, map.m_llen, SEEK_CUR);
-				if (ret < 0) {
+				if (lseek(outfd, map.m_llen, SEEK_CUR) < 0) {
 					ret = -errno;
 					goto out;
 				}
-- 
2.55.0


