Return-Path: <linux-erofs+bounces-4665-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97DD8CA5FFE
	for <linux-erofs@archiver.kernel.org>; Tue,  6 Oct 2026 18:04:59 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hzkg96F9Fz2yfD;
	Wed, 07 Oct 2026 05:04:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791309893;
	cv=none; b=lnOe12Y/nJMegEpgiIhYCgDZYohefCKfZHz9hTotk5JlKrrKaBzH/m5lpb6R71rkhyJnpKIQB8o4bNAguG6B3tu4pqSeEy/1LBfdDCoYSrNhqoRZ48c/BvB1KipfzM/Oou5BCE4J8m5LgLlh4zKIOROk1Jh8DLb/GROhMS7iI7+Em3809qqXs381DJkJ88sJKOGgUHd5pg9JQiCu75crGf1hBrMw/33O25D0THlffQUPunuQz/v/KyTpg2GR8RMrafNBYCAc4Y5ihHVGwHwpjets24jG6MUrR3uebMrvwrDnWuk+vRXxeLMxh4ZhlUJwBGapFe/9tjlk9kv6IgWmbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791309893; c=relaxed/relaxed;
	bh=Rcol3cUhfB+I5x7xKW6uh4oiBZMSTsLeRyYlKrApPww=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=YGeuOEW+qPODijaV3fPQckgCp64e2gLg2xadOajiJknUr6YOypRrk/a78qk9cLf/NFn2l/XiDxU5KXfKTfMadkUq/RveFTxcoSb7H0VZQ/id2B3SjcR01lcev8qpng8WfW3ZE4A67Q9++NOI1Z2tk5/pFEBhSh1f6HqlLOAqE1/AyXYfGdU6/QnJqovodnaAbjEY3vTNYjsUOvvkcTDJ1Hu3aEzBsyDG9qu3zNJ0MHQV+wUMTNH9A5+YK+EoFVaYTRwzbLJ0YTMq9qTA4Pr6zIm/Sf/2wAUGggK+AARLJZVekunld52yRV12jHiV1bCUAfKvfQ3haajYGtVs2PicRg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=GMtxjxUJ; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=devnull+sadmanf.meta.com@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=GMtxjxUJ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=devnull+sadmanf.meta.com@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hzkg86SYHz30HB
	for <linux-erofs@lists.ozlabs.org>; Wed, 07 Oct 2026 05:04:52 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DD4D602C8;
	Tue,  6 Oct 2026 18:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44DFBC4AF60;
	Tue,  6 Oct 2026 18:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791309889;
	bh=ihRqyFEf6J5Jhk93FINWAiO4vX00jYMrNSYBaSH8Ouo=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=GMtxjxUJmk4Bjb+8gN9Bu/3X93J8IPHtkSLQ795ZJKsaPaSJexl3A1MBJaBqLNRSm
	 +SElsxdgs1bi8eXQzfy+7+MvB3ejsjVO8amje6oFHifuOHd/8cQarDTOBtP213IcW7
	 EDrtJFGjOlvOlSswXCRkHOE5O3OWBGVAv/mK8wP35IEMKgrQgwt4/FhRire05np1Qe
	 B8g8ZZ3A0YeG5gyxEV7KGHHJ1d0t/j+1S5b58AphQQhPIwdYe2tNIP324OCro0KHx3
	 ESTWYYynIUmxWthJ32j736cdJZC7En471wrjeqixR9Ts7zWXthA9Gwng9bz7Eb0Kkl
	 +DZ/zoF3dpr6w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24DC1CA5FFE;
	Tue,  6 Oct 2026 18:04:49 +0000 (UTC)
From: Sadman Fahmid via B4 Relay <devnull+sadmanf.meta.com@kernel.org>
Subject: [PATCH RESEND 0/2] erofs-utils: lib: fix a short-read hang and an
 fd leak
Date: Tue, 06 Oct 2026 14:04:46 -0400
Message-Id: <20261006-round1-v1-0-f46b13e11de5@meta.com>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAD44xWoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDAwMz3aL80rwUQ93EVAsLC6Mko9S0ZHMloOKCotS0zAqwQdFKQa7Brn4
 uSrG1tQA60fKyYAAAAA==
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
 Sadman Fahmid <sadmanf@meta.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791309888; l=798;
 i=sadmanf@meta.com; s=20261006; h=from:subject:message-id;
 bh=ihRqyFEf6J5Jhk93FINWAiO4vX00jYMrNSYBaSH8Ouo=;
 b=BhYkEGZqjmJDijwONo/ovMhRNfzS30deWzPSSlCYupf4oVBVXQvqMXDNx+v/bViezjeFRthh9
 GdvZLa2FdNiDFRaHZysnnk2WlWsIXqQ02TbtSMB74e/Pbzyv0bLRY9W
X-Developer-Key: i=sadmanf@meta.com; a=ed25519;
 pk=Pc/arXJpm1RPef8qImFuHROn1p3XNX5MWSUxjZWNTa4=
X-Endpoint-Received: by B4 Relay for sadmanf@meta.com/20261006 with
 auth_id=1125
X-Original-From: Sadman Fahmid <sadmanf@meta.com>
Reply-To: sadmanf@meta.com

Patch 1 makes erofs_io_xcopy() return -EIO instead of spinning forever
when the source hits EOF early (e.g. rebuilding from a truncated
image), and keeps calling copy_file_range() for ranges over 2 GiB.

Patch 2 closes the source fd on two early error paths in
erofs_mkfs_begin_nondirectory().

---
Sadman Fahmid (2):
      erofs-utils: lib: fail instead of hanging on short reads in erofs_io_xcopy()
      erofs-utils: lib: close source fd on early errors in erofs_mkfs_begin_nondirectory()

 lib/inode.c | 14 +++++++++++---
 lib/io.c    | 29 ++++++++++++++++-------------
 2 files changed, 27 insertions(+), 16 deletions(-)
---
base-commit: 1c230a485f25837cb51d6fc79332f30758d9006c
change-id: 20261006-round1-ae8882b2efc7

Best regards,
-- 
Sadman Fahmid <sadmanf@meta.com>



