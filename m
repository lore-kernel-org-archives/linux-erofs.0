Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BD2BC3ABCE
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Sep 2024 13:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1726495005;
	bh=wrfeI6c5Fy2/wr4QW/RT84D3Z/gYFwXLPq/0MCJKzS4=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=hJKDkM2LPHxZWnZRYRthVh3xbT8vWzjTgIr87ziPoocFwavvVCa92M4IzMFnozEJl
	 IFj2s0PzqD28Knpfv0heItsoPInIS58i5egBDzTOg4OSj9SLXBq49ut4zCoYhRTU2e
	 s09vOO/Ohum8K2FVL3re8gDcIhkxLF3N0XqElVu22iFovNugwAYAosO08T7BUUhDEa
	 Mk531NUcV1NqxnNOdyepytpiti1xaDrll5xbGU7GXfu19amX15Z5/YM22QIOvUy3fi
	 siKNM6s3Z/hKzxp1J5K9r8gnFD7ybXdbELGy4vzcr25q+7p7BOjFIRqQ3qo3gIlMzs
	 AKFaP8JRK1DVA==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4X6mg10N7Mz30GV
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Sep 2024 23:56:45 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=148.135.17.20
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1726495003;
	cv=none; b=XiAxK7O438IQ4E9YyIWZObCUD3zov6opXUl8ciuShhbSYA/4vwHqeX9r7lUZhgZZQ7OuV5kIvFUX5RjKVWh+wdkfS8d/jXDQNZCWaf/TUrzGL32U60qD2uXV5bRg8zusztDhWWw0njDlaA7DDkdCc6ml1sPrLj08W6vGQrqpi/8Ra5JWguhjzdQRcOOAbdRmhoyHlSRSCpv3KWlgAjMjpuWvzzl/uTvxlCmleGnFRSun/l8QnEBHpPN9iVchSsY/BA3rsbGn4qKfyoVT3Le5a/rZpWOr2+Zf80btVhkF2fvrMb10V+MxTQICt3OWn/GwA7ZWmIodPxztqX/IqxAsnA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1726495003; c=relaxed/relaxed;
	bh=wrfeI6c5Fy2/wr4QW/RT84D3Z/gYFwXLPq/0MCJKzS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZ9dbYeBFtVCnsB9Sr9uGqNMbbElorecgnpYLb88PSumIPXFg80Xn2HE+mtUzj7DPNz0VwocdZv2qLQH6jr2AkyOSf2Hpx7sCarGgEEYRlRUjFeMJLAwDoIsCEixf3Jyc60KBBiSrz9KtM7k7GDrbil8vnjTF/Z3Ac0mM8rG+B2M/hI4VTu5wghCfSicNIxyJXu8BmjaYrFOcbJPQBUQS/kzKGiDlg1ziLkAG2TFl8jSZA1xOP394vp5XcS5ynn0IMpDqxgzH61RxfJW9bvIJsHRkCZ7m7Cm5Jslo/pd/X4XWbBE1uOnsJ9jpWmZsFSVBXg2uY9o3NkmRbH7lnz7bA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=tlmp.cc; dkim=pass (2048-bit key; secure) header.d=tlmp.cc header.i=@tlmp.cc header.a=rsa-sha256 header.s=dkim header.b=b/wTow6m; dkim-atps=neutral; spf=pass (client-ip=148.135.17.20; helo=mail.tlmp.cc; envelope-from=toolmanp@tlmp.cc; receiver=lists.ozlabs.org) smtp.mailfrom=tlmp.cc
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=tlmp.cc
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=tlmp.cc header.i=@tlmp.cc header.a=rsa-sha256 header.s=dkim header.b=b/wTow6m;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=tlmp.cc (client-ip=148.135.17.20; helo=mail.tlmp.cc; envelope-from=toolmanp@tlmp.cc; receiver=lists.ozlabs.org)
Received: from mail.tlmp.cc (unknown [148.135.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4X6mfz18Jyz2yVv
	for <linux-erofs@lists.ozlabs.org>; Mon, 16 Sep 2024 23:56:43 +1000 (AEST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0B2F069839;
	Mon, 16 Sep 2024 09:56:38 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tlmp.cc; s=dkim;
	t=1726495000; h=from:subject:date:message-id:to:cc:mime-version:
	 content-transfer-encoding:in-reply-to:references;
	bh=wrfeI6c5Fy2/wr4QW/RT84D3Z/gYFwXLPq/0MCJKzS4=;
	b=b/wTow6mW0pOJ3SLs4zdqnSvHOdwRM0/wdgLDvfxyE4lsB8GyguL7sAgA+xYYDLNTmQihH
	7ygxxN4fyFCXoJ+tUXTs4fVSdbyr0AqIv60ObsXlONL5RpEblVyzOlurHAcuGYpXMIPBnF
	XO/4Gk/f1Ptz3jGeS+dkc0aoqHc1RGiNYM6z5Tesui+jAGQLiGFs3Y+EHQCBSnq88FHD4c
	oOxVuvXQwUMfkOK3DTv4FbdHv+Cxmzv+c/7abQbrqbHDAbqRSglrwuRcUJwWO/Gi5S6GFT
	wzL8ysO2z7HjFBxJOG4sRxcCPECdkMxop4zKibbhekbjBeCxhuqNcLH9oGGRNw==
To: linux-erofs@lists.ozlabs.org
Subject: [RFC PATCH 01/24] erofs: lift up erofs_fill_inode to global
Date: Mon, 16 Sep 2024 21:56:11 +0800
Message-ID: <20240916135634.98554-2-toolmanp@tlmp.cc>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916135634.98554-1-toolmanp@tlmp.cc>
References: <20240916135634.98554-1-toolmanp@tlmp.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
From: Yiyang Wu via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Yiyang Wu <toolmanp@tlmp.cc>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, rust-for-linux@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Lift up erofs_fill_inode as a global symbol so that
rust_helpers can use it for better compatibility.

Signed-off-by: Yiyang Wu <toolmanp@tlmp.cc>
---
 fs/erofs/inode.c    | 2 +-
 fs/erofs/internal.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index db29190656eb..d2fd51fcebd2 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -196,7 +196,7 @@ static int erofs_read_inode(struct inode *inode)
 	return err;
 }
 
-static int erofs_fill_inode(struct inode *inode)
+int erofs_fill_inode(struct inode *inode)
 {
 	struct erofs_inode *vi = EROFS_I(inode);
 	int err;
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 4efd578d7c62..8674a4cb9d39 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -416,6 +416,7 @@ int erofs_map_blocks(struct inode *inode, struct erofs_map_blocks *map);
 void erofs_onlinefolio_init(struct folio *folio);
 void erofs_onlinefolio_split(struct folio *folio);
 void erofs_onlinefolio_end(struct folio *folio, int err);
+int erofs_fill_inode(struct inode *inode);
 struct inode *erofs_iget(struct super_block *sb, erofs_nid_t nid);
 int erofs_getattr(struct mnt_idmap *idmap, const struct path *path,
 		  struct kstat *stat, u32 request_mask,
-- 
2.46.0

