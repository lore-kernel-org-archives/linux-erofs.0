Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B48606A320
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Nov 2026 05:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Gt1Irr/u
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jVSR70mf6z2y2R;
	Thu, 19 Nov 2026 16:57:07 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::52a"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795067827;
	cv=none; b=iHf4pyrTGPDuQk5pgsOfpqxrOKMXatyaWaUUsRwBu0whYOR3OC6y3AXFaJQOn8AloNtvvEfilEwIaY0gZB2EauSYwGSMntx9ZvZbcIv75PqbX56R3g6uE7qpSqQtjiXQohkM61wxFJfN9BodZYvZxuAP2WmVKWVt8VwDab6auwTY3fZarri9madjte3JM5s/hZmixI8HpOn7awKdlgl2SjeE7b/gwDhAmwNm4BtWs03tOrrGoOkL6Ldoz3eBrxiwEDsk9e9fWKUw7E/kaq26HW28YGiaN+q0jKmwda0epLeweQAVmuos9aIxj0Hn9hQXPJJkmTzsftkic+18Bys36g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795067827; c=relaxed/relaxed;
	bh=rEpqto8+d8Qs3aykCxzet9fQe1+1d0lHLcmek2w7oLQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=E2e/4HrFJD1CjgevMYYmDUr6OPpNNTLgMRZC39UuIXDPIPchKA+cIPzhjPYRnOfooOGCD4DTl8rMvcroz7mCCuzD69NLnajPQd4fM6lVxwRt6/ud1SEeYf8Zldz/TObRhl8wt/kCnU186MdBRbfxMozzDrALD+sYVxRnUI/D5RFsccxZNoJjzM63aDfjirewKg5LOpuIvx1pzjwGLro3Rm4aQ812/HCO1xc83n2cQrF2TzC97mT3V3vaYlPltkciqBWVwfpkKkhXt7KEErWmJSTaLY6Rg8ZDKT1kJrb6PTcRFHptt0NzxetKonLomU2e0LzNAnSxq8D0oSrbjJapnA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Gt1Irr/u; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::52a; helo=mail-pg1-x52a.google.com; envelope-from=leeonion.muyu@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Gt1Irr/u;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::52a; helo=mail-pg1-x52a.google.com; envelope-from=leeonion.muyu@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jVSR55rP7z2y0B
	for <linux-erofs@lists.ozlabs.org>; Thu, 19 Nov 2026 16:57:05 +1100 (AEDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-cd62c570b5dso1488383a12.2
        for <linux-erofs@lists.ozlabs.org>; Wed, 18 Nov 2026 21:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795067823; x=1795672623; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rEpqto8+d8Qs3aykCxzet9fQe1+1d0lHLcmek2w7oLQ=;
        b=Gt1Irr/up553KANDkj7B8AJAAK4udKhz+dgdhz9SgvxPqFfCP0OyYB6PqutFO3Jmd/
         3NbRzhDH7+BH8zOqaOcLhUybqcdEZppaxZebn5MjdCES44EpxAAMTa4UjReSlJxrpskL
         TzsDRxdW3b/YmRmqaA7FkN3xA2OmpxQxHGFFJWYxAEzYzyz8uBqaErehjAR4o/aXVKCj
         kYVXbV4L5gyECAKTCH+PoZb0UsZ5en8IJVtMJCjTetHHovLp+vS9wRMwq7rKTU2PHThQ
         PBOQa4phXtavnCEVFkQRhcMbqdxJRmVXb0OSxZK8R+cO2uHw5aXONEfPu+qjCzVJ+xtx
         EesQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795067823; x=1795672623;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rEpqto8+d8Qs3aykCxzet9fQe1+1d0lHLcmek2w7oLQ=;
        b=P0eQQIWLcLKFENKYEqm1VWOzKSG/U82Bvoh6xcqCZFIWVwAsUoGeCPvGjlhgh8sUSH
         F4mJczDb37P5LbzNNHtt149vF/4/9ARs2hNigEDRBZxsh7g7hNlRQpF3pP88ZgOONX6g
         wSDSaljubznjyUQzzu2kVjYL2vggHNqzgt9R9u23+UwsgqrrKoZq3fLE2941iumNyKgE
         WxnBWtTxT9bOLCIxpeD2TeHbyTZQK3GPyVxZbkyclQB9jb+BSaKRsIrTUa5eN2uukb0Q
         ouvd4zvbNrtRHjfx/CitXPITOj6b+kI7pI8YI1Jhzq1jJBlcg35iQklCwzmzxzACLsGT
         RJfQ==
X-Gm-Message-State: APuU4Z/G8urEh2NVAzftLX2RQZPRDhhLx1TRjNqnwktHYf84RezqFFC7
	fzJYHEMLhNIa+k/K3RenzVBe8DmixlkUaEVLKzd3AqWhVcJevA6IObyDuU4h7H2l
X-Gm-Gg: AZFdTZf5pPBO+MyTwsG+GxKt4edaHE/hm/+5oB3vil9sh6AV5NDrIh6sAMztFPjQTmv
	YFUoHCXD/fX7rNr9PGCD5R81H1uWLVlp1emjIERVssPI3maGyFnutWqToAmQ1WGQGec6QqY8xHV
	QDn+NICpT2d/nqxLSWQ+RCu3N00pTvJdgDF++IqNYc7rz+s7/YNy8xbZ9EMiKESHFYjieLqwo1i
	sWaMOUQHCtcgLtW2KvygANb+mfMJjfCw9bYGavbAfeBXQuOp0Wc9uLVMjeSL8o+Fe/CN1itLrnP
	7BDw538CV01pUp/NBKqYSBaE/3zEzhLzSle3AuL2z9vUDgGn20s3DZO8Jhmlj+ABEJs4WzlswH9
	XAiUK94llFhMIResVB3adhleyifeJCQb6fmhzDiXEg0KT1Xbf5fycDoz+3s3Fk2krP/E1JSQjVX
	j/6G8tJymI0u8/+aU3YudgrPkMMkH/4Cv0PFvCV9G3BaUIl4QIVxTCf4V1l9+PvaRfHJc0leiiP
	edymN6mwyXMF1QaiNG6sAA4us4TuS6wFFE3drdZh2nVF9F1H+E3KAdsVapQAkXsfIfp6mLZgIiS
	SRFcIZ1WF6KTA4sxMn40+yyhZM3eq/Hclg==
X-Received: by 2002:a17:90b:1b0e:b0:3b1:3598:f881 with SMTP id 98e67ed59e1d1-3b3d07c9e3dmr5750370a91.53.1795067823072;
        Wed, 18 Nov 2026 21:57:03 -0800 (PST)
Received: from server225.. ([39.170.101.209])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d6349bsm868812a91.9.2026.11.18.21.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 21:57:02 -0800 (PST)
From: Ping Li <leeonion.muyu@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	chao@kernel.org,
	Ping Li <leeonion.muyu@gmail.com>
Subject: [PATCH] erofs-utils: fsck: return nonzero exit code on superblock checksum failure
Date: Thu, 19 Nov 2026 13:56:55 +0800
Message-Id: <20261119055655.3909032-1-leeonion.muyu@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When the superblock checksum fails to verify, main() jumps to the
exit_put_super label without setting "err", bypassing the conversion
of fsckcfg.corrupted into -EFSCORRUPTED.  As a result, fsck.erofs
prints "failed to verify superblock checksum" but exits with 0, so
callers gating on the exit code (e.g. boot scripts) silently miss
superblock corruption.

Set the error code before jumping so the exit code matches the
message.

Fixes: f44043561491 ("erofs-utils: introduce fsck.erofs")
Signed-off-by: Ping Li <leeonion.muyu@gmail.com>
---
 fsck/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fsck/main.c b/fsck/main.c
index b2d8f1a..2ca1078 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -1174,6 +1174,7 @@ int main(int argc, char *argv[])
 	    erofs_superblock_csum_verify(&g_sbi)) {
 		fsckcfg.corrupted = true;
 		erofs_err("failed to verify superblock checksum");
+		err = -EFSCORRUPTED;
 		goto exit_put_super;
 	}
 

base-commit: f36cadb5c563995ab3aa8572a60ed6b721b9557d
-- 
2.34.1


