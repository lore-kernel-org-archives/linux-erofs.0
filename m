Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A47FCF397F
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Sep 2024 02:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1726800590;
	bh=NBsLeq/4sQ8AcrTmee8ysml0OejfPujGQbZMIO2X+mA=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=P4cKlwUQFYEMilNQiuPMECLYbtEBoasrkkQkimA8Dn2bKC5t+Ww3DFZWfxbDw0wGs
	 ZEAZoXevHl7hSDRZIVELyVEn1JfEoiD7CQxVZEsJ8YsQEyJeQSRARWlzzNmxHE7EQL
	 cWmrMzMiNSDyEb+37p22AP7Ow7ayIR97/HqsLK4lpJ+WE/UyMOL6pVg1Gvd8VPMzvv
	 JIadFJIvFJZ3a2ptBVWCHcLP+VIZaiv/OewRC2E+5mslAsCbkbIvNIfBUu/8AzXvUT
	 ba2Y2vdOoIk+K4Q4Dd/VJE7tYQJBnM3WQXU4TPWetnTE+z2QxHz9eP0ikl+pMw3CB7
	 D1yjCdhw15pSA==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4X8xgf2CM9z2yWK
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Sep 2024 12:49:50 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=148.135.17.20
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1726800587;
	cv=none; b=IZbax1RnFSZvnxotO8sqKF7WWFWlC9ThPA7Pwc31BaLKnKhEJgD89VRS/rd4MrmmXlSIu7Dicn0PLL6M5AeavWcFY/ka/R0aNnT6QIkta8Niv+xqdR+BzejDU39Iys2F6n0rj/VzGxKF962mNc8XzX1BEkTydMee6wozo4+CZHS/e/8vb6AuM6c/dyTifqlT3Iw76fiqUb8WrSCtgOFwB0qUMj4kADM2bnL/YVgzD/9lisErv72lb75OeIMWMXNLDpPP5sn8fvPVprw95vjvf0UMPlznZwVICnIJr1ac80xnTVwYSTBnP3cD3P0axFuFnnuwCTbpHm1+YO4/mBZIcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1726800587; c=relaxed/relaxed;
	bh=NBsLeq/4sQ8AcrTmee8ysml0OejfPujGQbZMIO2X+mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AD5ERc46wxzR1aOgkoPQa8JgyAnT6RiSnk3ywW4Ks1G19zATwQxUY1VsW0YJxXzXJLIvlnp+LpB4vpAJSIz6u51JutL0M/bpSH0rhf7qpK4s8bLHQZKq2IWdQle7ZFES2pesWCxVKrcPlpq98MgJHVZzBOo2djh94mZoSYr5Zd8Vs77P6vqwXVpAIDcrIH86dJh0PruGjSLs/zQVbneGsKyqwnjrZKcUnlQ3OxlRvPNFBIMMqEs9BeYllEcqmaVfrbH8Wso4ojzbinbmCYzAARR6KmOQbeaQRtlO7KQSeyxXL4PR5/Fev2I26KI9JVYP0OgiRicU+i+NkpyELSt7Ng==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=tlmp.cc; dkim=pass (2048-bit key; secure) header.d=tlmp.cc header.i=@tlmp.cc header.a=rsa-sha256 header.s=dkim header.b=KKeIXorr; dkim-atps=neutral; spf=pass (client-ip=148.135.17.20; helo=mail.tlmp.cc; envelope-from=toolmanp@tlmp.cc; receiver=lists.ozlabs.org) smtp.mailfrom=tlmp.cc
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=tlmp.cc
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=tlmp.cc header.i=@tlmp.cc header.a=rsa-sha256 header.s=dkim header.b=KKeIXorr;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=tlmp.cc (client-ip=148.135.17.20; helo=mail.tlmp.cc; envelope-from=toolmanp@tlmp.cc; receiver=lists.ozlabs.org)
Received: from mail.tlmp.cc (unknown [148.135.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4X8xgZ4Df5z2xpp
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Sep 2024 12:49:46 +1000 (AEST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1A5D2697C9;
	Thu, 19 Sep 2024 22:49:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tlmp.cc; s=dkim;
	t=1726800580; h=from:subject:date:message-id:to:cc:mime-version:
	 content-transfer-encoding:in-reply-to:references;
	bh=NBsLeq/4sQ8AcrTmee8ysml0OejfPujGQbZMIO2X+mA=;
	b=KKeIXorrvFDJLDxpZIcA7qDlcoQGYZzomYUsQiIAyHfsNrjYHg+d4jZTHZtR941rdmKV8G
	Tg6FK6zsqDERv8Jfo/2GUfbWa4PZa/gYOzirfWmMOCSxn5dcCb0BjG5UYVjU4A6D4UejF3
	RbVfiblfSLvzOgo3vZQkekALufyWiRt7bzew03FVylWXsb/8hPNLrJw8TZ5Mdbd5p9zzhF
	2Oi9DKGrkUABOaVv1o6GT3P38SbxxaTQWlywGZOk1OpeZDPxUyxFLEtrqm8sldNJkiUUhD
	9fsgG1pGieiifkxmgsYsc/RsQBl8tohmzY8Ek3g5wBfCBsjRW9hs7hdrt8d68A==
To: rust-for-linux@vger.kernel.org
Subject: [PATCH RESEND 0/1] rust: introduce declare_err! autogeneration
Date: Fri, 20 Sep 2024 10:49:18 +0800
Message-ID: <20240920024920.215842-1-toolmanp@tlmp.cc>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <2024091602-bannister-giddy-0d6e@gregkh>
References: <2024091602-bannister-giddy-0d6e@gregkh>
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
Cc: gregkh@linuxfoundation.org, LKML <linux-kernel@vger.kernel.org>, gary@garyguo.net, linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Currently, the error.rs's errno import is done manually by copying the
comments from include/linux/errno.h and uses the declare_err! to wrap
the constant errno.

However, this reduces the readability and increases difficulty of
maintaining the error.rs if the errno list is growing too long or
or if errno.h gets updated for new semantics.

This patchset solves this issues for good by introducing a rule
to generate errno_generated.rs by seding the errno.h and
including the generated file in the error.rs.

This patch is based on the rust-next branch.

Yiyang Wu (1):
  rust: error: auto-generate error declarations

 rust/.gitignore      |  1 +
 rust/Makefile        | 14 ++++++++++-
 rust/kernel/error.rs | 58 +++-----------------------------------------
 3 files changed, 18 insertions(+), 55 deletions(-)

-- 
2.46.0

