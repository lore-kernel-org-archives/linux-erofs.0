Return-Path: <linux-erofs+bounces-3249-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B63BEF364A8
	for <linux-erofs@archiver.kernel.org>; Thu,  9 Apr 2026 17:33:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fs6Tt1Cg2z2yT0;
	Fri, 10 Apr 2026 03:33:22 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip=103.117.158.51 arc.chain=zohomail.in
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775756002;
	cv=pass; b=RlfspGcfrGVFQOmU82q70QGfzKIsIPfGxoiW3BChWLEsWVLIVG80po0PEBpe2nwLmqL6vZO4+n5KYVUnvBf8dtCRxikIU+4+tF0iA2OBVlRVCqOackElUFrhsEKepm7ZK1HuRmgs4SgDNVycAtenH0ssD0DmunnqjjtBfjpIwQLMrG8YZLFF5uAFCWadLMyPqLrc3VhPb1tbLh3/CKFLxGs6HoWiJrU0uVvmmEAviueqjiHXd0crq3iZM15M1h3EHfP748F67vAsa2tK01bsBMWBgoH4S3riFSmH8hjHswYd6QdoNQg5DzrG1TY9tXBAitEQOv4x/2K9FdC9L8WbOw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775756002; c=relaxed/relaxed;
	bh=OZFfnMMa15DSxWwsfOMR+4HhpfWrhgKR11KHd2nnO+M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SvWroS+EuH/nbG3wIu/tMh8NuZ1cM9d9CgtrDXU55Cnwr68moJvFrts96L3wf7VYsRul+4Wc7Yqav+U3TcUWoR54CkzQZqgIilmsw4NwSKFwH2zlYqAYONhineEyaXnFd5GFg26ib3LYGVkd4ydgZFftQJnnxBkPkwXqN8IdnfPfQp1B4/PXnCk8qnfA8N0ZXietkj+nFDe4w07nqCpSj7ng1NYhdlbi7747OtDQaWCseTt6ilpszIGft/p1HlPNunIObxYJMyBA/OUabXBnStmVTlCdjRnSllnt8O1QZddeALf8tmJ62sOdFVmYAICF3a/aS5ziG2XOFqvVYycjiw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=vnsh.in; dkim=pass (1024-bit key; unprotected) header.d=vnsh.in header.i=ch@vnsh.in header.a=rsa-sha256 header.s=zoho header.b=haUCVuyh; dkim-atps=neutral; spf=pass (client-ip=103.117.158.51; helo=sender-of-o51.zoho.in; envelope-from=ch@vnsh.in; receiver=lists.ozlabs.org) smtp.mailfrom=vnsh.in
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=vnsh.in
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=vnsh.in header.i=ch@vnsh.in header.a=rsa-sha256 header.s=zoho header.b=haUCVuyh;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=vnsh.in (client-ip=103.117.158.51; helo=sender-of-o51.zoho.in; envelope-from=ch@vnsh.in; receiver=lists.ozlabs.org)
Received: from sender-of-o51.zoho.in (sender-of-o51.zoho.in [103.117.158.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fs6Tr1QGYz2xpn
	for <linux-erofs@lists.ozlabs.org>; Fri, 10 Apr 2026 03:33:19 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; t=1775755994; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=SlQKwoFdjHVE3mcsmtRkVHJlbuUHfb+yJEnQdWS/EUCEr0+YwbsQ5x8c0/nDmL6zfdUtO6Mk55gzt9FyO5ZxryEA73Vd2Ajk00B8EH5KIT5L0A8fwWVeyJt9vhctgoYWhECaVolJZblpUovitqeQlfdHaIaw7bZs0LQjODP0Bgo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1775755994; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=OZFfnMMa15DSxWwsfOMR+4HhpfWrhgKR11KHd2nnO+M=; 
	b=BHd+wC9cWWXY9I0cmBXOMpIo4Hb1XOLJNp6acMQXRHjCy30lmOpWqHw/NbVGdKfwCjuSeG1Ow/RfSgipzUhzX2Pq0Vu/oj+dtaQL4fECrfL7VIHqmTzlwTvf93gc4xHp0ufGJKpyRYh8jNMbN8mPooLFP8+zLM2JI3os0Q0pL3Y=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=vnsh.in;
	spf=pass  smtp.mailfrom=ch@vnsh.in;
	dmarc=pass header.from=<ch@vnsh.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1775755994;
	s=zoho; d=vnsh.in; i=ch@vnsh.in;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=OZFfnMMa15DSxWwsfOMR+4HhpfWrhgKR11KHd2nnO+M=;
	b=haUCVuyhyySqXoQTEPZKFWCYPbOF2lY+VF34xA6tcXPAd90ZJn1K/LhfYpSuNqpp
	eTXhPFNKXLbK1QBE9gEz5oEo131aKJDW6AOxQI6+607eNVKg048icgTa5zxXHeJ6ZTM
	uNE+V+C/xQ8uoO05YGNDzTcvQ67BEjkFuHfjFhDo=
Received: by mx.zoho.in with SMTPS id 1775755991848468.0637705028429;
	Thu, 9 Apr 2026 23:03:11 +0530 (IST)
From: Vansh Choudhary <ch@vnsh.in>
To: linux-erofs@lists.ozlabs.org
Cc: Vansh Choudhary <ch@vnsh.in>
Subject: [PATCH] erofs-utils: lib: fix get_unaligned_le64() return type
Date: Thu,  9 Apr 2026 17:33:10 +0000
Message-ID: <20260409173310.91143-1-ch@vnsh.in>
X-Mailer: git-send-email 2.43.0
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
X-ZohoMailClient: External

get_unaligned_le64() reads a 64-bit little-endian value but is
declared to return u32. Return u64 so callers do not lose the upper
32 bits.

Signed-off-by: Vansh Choudhary <ch@vnsh.in>
---
 include/erofs/defs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/erofs/defs.h b/include/erofs/defs.h
index 71ca11b..37f349f 100644
--- a/include/erofs/defs.h
+++ b/include/erofs/defs.h
@@ -228,7 +228,7 @@ static inline void put_unaligned_le32(u32 val, void *p)
 	__put_unaligned_t(__le32, cpu_to_le32(val), p);
 }
 
-static inline u32 get_unaligned_le64(const void *p)
+static inline u64 get_unaligned_le64(const void *p)
 {
 	return le64_to_cpu(__get_unaligned_t(__le64, p));
 }
-- 
2.43.0


